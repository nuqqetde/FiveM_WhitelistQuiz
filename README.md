# FiveM Whitelist Quiz System

Ein modernes und benutzerfreundliches Whitelist-Quiz-System für FiveM Roleplay Server, entwickelt von nuqqeT.de.

## 🖼️ Vorschau

![Whitelist Quiz Interface](https://i.ibb.co/y69Rdm0/Screenshot-1531.png)

## 📋 Beschreibung

Dieses System implementiert ein interaktives Quiz, das Spieler nach der Charaktererstellung absolvieren müssen, um auf dem Server spielen zu können. Es dient dazu, das Verständnis der Spieler für wichtige Roleplay-Regeln und -Konzepte sicherzustellen.

## ✨ Features

- Modernes, responsives UI-Design
- Zufällige Auswahl aus einem großen Fragenpool
- 10 Fragen pro Quiz-Durchlauf
- Mindestens 8 richtige Antworten zum Bestehen erforderlich
- 2-Stunden Wartezeit bei Nichtbestehen
- Fortschrittsanzeige während des Quiz
- Animierte Benutzeroberfläche
- Serverseitige Validierung der Antworten

## 📥 Installation

1. Laden Sie das Resource-Paket herunter
2. Platzieren Sie den Ordner in Ihrem FiveM Server-Ressourcen-Verzeichnis
3. Fügen Sie folgende Zeile zu Ihrer `server.cfg` hinzu:
```cfg
ensure whitelist_quiz
```

## ⚙️ Konfiguration

### Fragen anpassen
Die Fragen können in der Datei `server/questions.lua` bearbeitet werden. Jede Frage folgt diesem Format:

```lua
{
    question = "Ihre Frage hier",
    correctAnswer = "Die richtige Antwort",
    options = {
        "Die richtige Antwort",
        "Falsche Antwort 1",
        "Falsche Antwort 2",
        "Falsche Antwort 3"
    }
}
```

### Quiz-Einstellungen
In der `server/main.lua` können folgende Einstellungen angepasst werden:

```lua
local QUESTIONS_PER_QUIZ = 10  -- Anzahl der Fragen pro Quiz
local REQUIRED_CORRECT = 8     -- Mindestanzahl richtiger Antworten
local COOLDOWN_TIME = 7200    -- Wartezeit in Sekunden (2 Stunden)
```

## 🔌 Integration

Das System reagiert auf das Event `character:created`, das nach der Charaktererstellung ausgelöst werden sollte. Fügen Sie in Ihrem Charaktererstellungssystem folgende Zeile hinzu:

```lua
TriggerEvent('character:created')
```

## 📊 Events

### Client Events
- `whitelist:status` - Wird ausgelöst wenn der Whitelist-Status aktualisiert wird
- `whitelist:cooldown` - Wird ausgelöst wenn ein Cooldown gesetzt wird
- `whitelist:passed` - Wird ausgelöst wenn der Test bestanden wurde

### Server Events
- `whitelist:checkAnswers` - Überprüft die Quiz-Antworten
- `whitelist:getQuestions` - Fordert neue Fragen an

## 🎨 Anpassung des Designs

Das Design kann in der `html/style.css` angepasst werden. Die wichtigsten Stile sind:

- Farbschema: Grün (#4CAF50)
- Font: Poppins
- Moderne Glasmorphismus-Effekte
- Responsive Design für alle Bildschirmgrößen

## 📝 Lizenz

Entwickelt von nuqqeT.de - Alle Rechte vorbehalten

## 🤝 Support

Bei Fragen oder Problemen können Sie sich an den Support wenden. 
