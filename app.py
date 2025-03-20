import asyncio
from hoymiles_wifi.dtu import DTU
import mysql.connector

# Funktion zur Verbindung mit der MySQL-Datenbank
def connect_db():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="root",  # Ändere auf deinen Benutzer
            password="",  # Dein sicheres Passwort
            database="inverter_db"
        )
        print("✅ Verbindung zur Datenbank erfolgreich!")
        return conn
    except mysql.connector.Error as err:
        print(f"❌ Fehler bei der Datenbankverbindung: {err}")
        return None

# Funktion zum Speichern der DTU-Daten in MySQL
def save_data(response):
    conn = connect_db()
    if conn is None:
        print("❌ Verbindung fehlgeschlagen. Daten werden nicht gespeichert.")
        return

    cursor = conn.cursor()

    # Überprüfen, ob `sgs_data` eine Liste ist und Daten enthält
    if not response.sgs_data:
        print("❌ Keine `sgs_data` vorhanden.")
        return

    sgs = response.sgs_data[0]  # Erstes Element aus der Liste holen

    # DTU-Daten speichern (Wechselrichter-Tabelle)
    cursor.execute("""
        INSERT INTO inverter_data (device_serial, ap, firmware_version, voltage, frequency, 
                                   active_power, current, power_factor, temperature, warning_number, 
                                   dtu_daily_energy)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (
        response.device_serial_number,
        response.ap,
        response.firmware_version,
        sgs.voltage / 10,  # Millivolt → Volt
        sgs.frequency / 100,  # Millihertz → Hertz
        sgs.active_power / 10,  # 10-fache Skalierung korrigieren
        sgs.current / 1000,  # Milliampere → Ampere
        sgs.power_factor / 1000,
        sgs.temperature / 10,  # Dezikelvin → Celsius
        sgs.warning_number,
        response.dtu_daily_energy
    ))

    # Letzte ID abrufen (für PV-Daten-Verknüpfung)
    inverter_id = cursor.lastrowid

    # PV-Daten speichern (mehrere Strings)
    for pv in response.pv_data:
        cursor.execute("""
            INSERT INTO pv_data (timestamp, inverter_id, serial_number, port_number, voltage, current, power, 
                                 energy_total, energy_daily, error_code)
            VALUES (NOW(), %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            inverter_id,
            pv.serial_number,
            pv.port_number,
            pv.voltage / 10,  # Millivolt → Volt
            pv.current / 1000,  # Milliampere → Ampere
            pv.power / 10,  # 10-fache Skalierung korrigieren
            pv.energy_total / 10,  # 10-fache Skalierung korrigieren
            pv.energy_daily / 10,  # 10-fache Skalierung korrigieren
            pv.error_code
        ))

    # Änderungen speichern & Verbindung schließen
    conn.commit()
    cursor.close()
    conn.close()
    print("✅ Daten erfolgreich gespeichert.")

# Hauptfunktion zur Abfrage der DTU-Daten
async def main():
    dtu = DTU("192.168.178.159")
    response = await dtu.async_get_real_data_new()  # Korrigierter Methodenaufruf

    if response:
        print(f"DTU Response: {response}")
        save_data(response)  # 🛠 Daten speichern!
    else:
        print("❌ Keine Daten vom DTU erhalten.")

# Event-Loop starten
if __name__ == "__main__":
    asyncio.run(main())
