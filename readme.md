# 📡 DTU Datenlogger – Hoymiles Wechselrichter Monitoring

Dieses Skript ruft **Echtzeit-Daten von einem Hoymiles DTU (Data Transfer Unit)** ab und speichert sie in einer **MySQL-Datenbank**.

## 🚀 Voraussetzungen

Bevor du das Skript ausführst, installiere die benötigten Python-Pakete mit:

```sh
pip install mysql-connector-python hoymiles-wifi asyncio
```

Falls `hoymiles-wifi` nicht verfügbar ist, stelle sicher, dass du es aus einer passenden Quelle beziehst.

## 📂 Verzeichnisstruktur

```
/projektordner
│── test.py         # Hauptskript zum Abrufen & Speichern der DTU-Daten
│── README.md       # Dokumentation
│── requirements.txt # Liste der Abhängigkeiten (optional)
```

## ⚙️ Funktionen des Skripts

### 1️⃣ **Datenbankverbindung**
Die Funktion `connect_db()` verbindet das Skript mit der **MySQL-Datenbank**:

```python
import mysql.connector
def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",  # Benutzername für MySQL
        password="",  # Passwort für MySQL
        database="inverter_db"
    )
```

---

### 2️⃣ **Daten in MySQL speichern**
Die Funktion `save_data(response)` speichert die aus dem DTU abgerufenen Daten in MySQL.

**Gespeicherte Werte:**
- Wechselrichter-Daten (`inverter_data`)
- PV-Daten (`pv_data`)

**SQL-Tabellenstruktur:**
```sql
CREATE TABLE inverter_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    device_serial VARCHAR(50),
    ap INT,
    firmware_version INT,
    voltage FLOAT,
    frequency FLOAT,
    active_power FLOAT,
    current FLOAT,
    power_factor FLOAT,
    temperature FLOAT,
    warning_number INT,
    dtu_daily_energy FLOAT
);

CREATE TABLE pv_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    inverter_id INT,
    serial_number VARCHAR(50),
    port_number INT,
    voltage FLOAT,
    current FLOAT,
    power FLOAT,
    energy_total FLOAT,
    energy_daily FLOAT,
    error_code INT,
    FOREIGN KEY (inverter_id) REFERENCES inverter_data(id)
);
```

---

### 3️⃣ **Daten vom DTU abrufen**
Das Skript ruft **Echtzeit-Daten** mit `async_get_real_data_new()` ab:

```python
async def main():
    dtu = DTU("192.168.178.159")
    response = await dtu.async_get_real_data_new()

    if response:
        save_data(response)  # Speichert die Daten in MySQL
    else:
        print("❌ Keine Daten vom DTU erhalten.")
```

---

## 🔧 **Skript ausführen**
Starte das Skript mit:

```sh
python test.py
```

Falls du eine **automatische Datenerfassung** möchtest, kannst du das Skript z. B. **alle 5 Minuten** per `cron` oder `systemd` ausführen.

---

## 🛠 **Fehlerbehebung**
Falls du Probleme mit der Datenbankverbindung hast:
```sh
mysql -u root -p
SHOW DATABASES;
```
Falls `inverter_db` nicht existiert, erstelle sie mit:
```sh
CREATE DATABASE inverter_db;
```

---

## ✅ **Fazit**
✔ Ruft Echtzeit-Daten vom Hoymiles DTU ab  
✔ Speichert Messwerte in einer MySQL-Datenbank  
✔ Unterstützt mehrere PV-Strings  
✔ Nutzung von **async** für schnelle Anfragen  

🚀 **Jetzt kann das DTU-Monitoring starten!**
