# Installomator Custom Labels – Copilot-Anweisungen

## Kontext & Rolle

Dieses Repository ist ein Fork von [Installomator](https://github.com/Installomator/Installomator) und wird als Patchmanagement für macOS eingesetzt. Der Fork wird regelmäßig mit dem Upstream synchronisiert.

**Einzige Aufgabe in diesem Repository:** Neue Label-Dateien im Ordner `fragments/custom/` erstellen, für Software, die nicht im Standard-Labelset von Installomator enthalten ist.

Dateien außerhalb von `fragments/custom/` werden **niemals** bearbeitet.

---

## Aufbau eines Labels

Jede Label-Datei enthält genau einen `case`-Block im folgenden Format:

```zsh
labelname)
    name="App Name"
    type="dmg"            # Pflicht
    downloadURL="..."     # Pflicht
    appNewVersion="..."   # Empfohlen
    expectedTeamID="..."  # Pflicht
    ;;
```

### Dateiname

- Entspricht dem Label-Namen (Kleinbuchstaben, Bindestriche erlaubt, keine Leerzeichen)
- Dateiendung: `.sh`
- Beispiel: `myapp.sh` für das Label `myapp`

### Label-Name (erster Wert im `case`)

- **Nur Kleinbuchstaben**, Ziffern, Bindestriche (`-`) und Unterstriche (`_`)
- Kein Leerzeichen, keine Sonderzeichen
- Muss eindeutig sein – darf nicht in `fragments/labels/` bereits existieren

---

## Pflichtfelder

| Variable | Beschreibung |
|---|---|
| `name` | Anzeigename der App (wird auch als Standardprozessname und App-Name verwendet) |
| `type` | Installationstyp (siehe unten) |
| `downloadURL` | Direkte Download-URL des Installationspakets |
| `expectedTeamID` | Apple Developer Team-ID des Herstellers (10-stellig, z. B. `"2BUA8C4S2C"`) |

---

## Optionale Felder

| Variable | Beschreibung | Beispiel |
|---|---|---|
| `appName` | Name der .app-Datei, falls abweichend von `name` | `appName="My App.app"` |
| `appNewVersion` | Aktuelle Version zum Vergleich (verhindert Re-Installation) | `appNewVersion=$(curl ...)` |
| `packageID` | Bundle-ID eines PKG für Versionsvergleich | `packageID="com.vendor.app"` |
| `archiveName` | Dateiname des Downloads, wenn er nicht dem Standardschema entspricht | `archiveName="myapp_installer.zip"` |
| `targetDir` | Installationsziel (Standard: `/Applications` für .app, `/` für pkg) | `targetDir="/Applications/Utilities"` |
| `blockingProcesses` | Prozesse, die beendet werden müssen (Standard: `$name`) | `blockingProcesses=( "MyApp" )` |
| `versionKey` | Plist-Schlüssel für Versionsabfrage (Standard: `CFBundleShortVersionString`) | `versionKey="CFBundleVersion"` |
| `CLIInstaller` | Pfad zu einem CLI-Installer innerhalb des Archives | `CLIInstaller="Install.app/Contents/MacOS/Install"` |
| `CLIArguments` | Argumente für `CLIInstaller` | `CLIArguments=(--mode=silent)` |
| `updateTool` | Pfad zu einem bestehenden Update-Tool auf dem System | `updateTool="/usr/local/bin/mytool"` |
| `updateToolArguments` | Argumente für `updateTool` | `updateToolArguments=( --update )` |
| `curlOptions` | Zusätzliche curl-Optionen für den Download | `curlOptions=( --header "Authorization: Bearer ..." )` |
| `appCustomVersion()` | Shell-Funktion zur benutzerdefinierten Versionsermittlung | Siehe Beispiel unten |

---

## Installationstypen (`type`)

| Typ | Beschreibung |
|---|---|
| `dmg` | Disk Image mit einer `.app`-Datei |
| `pkg` | Standalone-PKG-Datei |
| `zip` | ZIP-Archiv mit einer `.app`-Datei |
| `tbz` / `bz2` | TBZ/BZ2-Archiv mit einer `.app`-Datei |
| `pkgInDmg` | PKG-Datei, die sich innerhalb eines DMG befindet |
| `pkgInZip` | PKG-Datei, die sich innerhalb eines ZIP befindet |
| `appInDmgInZip` | DMG in einem ZIP (selten, z. B. DEVONthink) |
| `updateronly` | Nur ein Update-Tool wird ausgeführt, kein eigentlicher Download |

---

## Hilfsfunktionen

### `downloadURLFromGit "githubuser" "reponame"`
Ermittelt die neueste Release-Download-URL von GitHub. Berücksichtigt `archiveName` und `type`.

```zsh
downloadURL=$(downloadURLFromGit "vendor" "reponame")
```

### `versionFromGit "githubuser" "reponame"`
Ermittelt die neueste Release-Version von GitHub.

```zsh
appNewVersion=$(versionFromGit "vendor" "reponame")
```

---

## Team-ID ermitteln

Die Team-ID ist der 10-stellige Apple Developer Identifier. Methoden:

1. **Aus einer bereits installierten App:**
   ```zsh
   codesign -dv --verbose=4 /Applications/MyApp.app 2>&1 | grep TeamIdentifier
   ```

2. **Aus einem heruntergeladenen DMG/PKG:**
   ```zsh
   spctl -a -vv /Applications/MyApp.app 2>&1 | grep "Team ID"
   ```

3. **Aus einem PKG:**
   ```zsh
   pkgutil --check-signature /path/to/installer.pkg | grep "Team Identifier"
   ```

---

## Versionsermittlung (`appNewVersion`)

Die Versionsermittlung ist **wichtig** – ohne sie wird Installomator die App bei jedem Aufruf neu installieren.

Typische Muster:

```zsh
# Aus GitHub Releases
appNewVersion=$(versionFromGit "githubuser" "reponame")

# Aus einem Redirect-Header (häufig bei direkten Download-Links)
appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[0-9a-zA-Z]*-([0-9.]*)\..*/\1/g')

# Aus der URL selbst
appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*_([0-9.]*)\.dmg.*/\1/')

# Aus einer Webseite scrapen
appNewVersion=$(curl -fsL "https://example.com/releasenotes" | grep -i 'version' | head -1 | sed -E 's/.*Version ([0-9.]+).*/\1/')

# Benutzerdefinierte Funktion (für nicht-standard Versionsspeicherung)
appCustomVersion(){ /usr/bin/defaults read "/Library/Application/MyApp.app/Contents/Info.plist" "CFBundleVersion" }
```

---

## Arch-Handling (Apple Silicon vs. Intel)

Wenn eine App unterschiedliche Downloads für arm64/x86_64 hat:

```zsh
case $(arch) in
    "arm64")
        downloadURL="https://example.com/myapp-arm64.dmg"
    ;;
    "i386")
        downloadURL="https://example.com/myapp-x64.dmg"
    ;;
esac
appNewVersion=$(...)
```

---

## Blockende Prozesse

```zsh
# Standard: Name der App wird automatisch verwendet
# Explizit setzen:
blockingProcesses=( "MyApp" "MyApp Helper" )

# Wenn keine blockenden Prozesse vorhanden (z.B. CLI-Tools, reine PKGs):
blockingProcesses=( NONE )
```

---

## Vollständige Beispiele

### Einfaches DMG-Label (GitHub-Release)
```zsh
mycooltool)
    name="My Cool Tool"
    type="dmg"
    downloadURL=$(downloadURLFromGit "vendor" "mycooltool")
    appNewVersion=$(versionFromGit "vendor" "mycooltool")
    expectedTeamID="XXXXXXXXXX"
    ;;
```

### PKG mit packageID
```zsh
myagent)
    name="My Agent"
    type="pkg"
    packageID="com.vendor.myagent"
    downloadURL="https://example.com/myagent-latest.pkg"
    appNewVersion=$(curl -fsIL "https://example.com/myagent-latest.pkg" | grep -i "^location" | sed -E 's/.*\/[^-]*-([0-9.]+)\.pkg.*/\1/')
    expectedTeamID="XXXXXXXXXX"
    blockingProcesses=( NONE )
    ;;
```

### PKG in DMG
```zsh
mycorporatetool)
    name="Corporate Tool"
    type="pkgInDmg"
    packageID="com.corp.tool"
    downloadURL="https://example.com/corporate-tool.dmg"
    appNewVersion=$(curl -fsL "https://example.com/version.json" | grep '"version"' | sed -E 's/.*"([0-9.]+)".*/\1/')
    expectedTeamID="XXXXXXXXXX"
    ;;
```

### ZIP mit abweichendem App-Namen
```zsh
myrenameapp)
    name="My App"
    appName="My Renamed App.app"
    type="zip"
    downloadURL=$(downloadURLFromGit "vendor" "myapp")
    appNewVersion=$(versionFromGit "vendor" "myapp")
    expectedTeamID="XXXXXXXXXX"
    ;;
```

---

## Checkliste vor dem Speichern

- [ ] Label-Name: nur Kleinbuchstaben, Ziffern, `-` oder `_`
- [ ] Dateiname entspricht dem Label-Namen (`.sh`)
- [ ] `name` gesetzt
- [ ] `type` ist ein gültiger Wert
- [ ] `downloadURL` gesetzt und erreichbar
- [ ] `expectedTeamID` korrekt (mit `codesign` oder `pkgutil` verifiziert)
- [ ] `appNewVersion` implementiert (verhindert unnötige Re-Installationen)
- [ ] `blockingProcesses` sinnvoll gesetzt (ggf. `NONE` für CLI-Tools/PKGs)
- [ ] Arch-Handling wenn nötig (arm64 vs. x86_64)
- [ ] Label existiert **nicht** bereits in `fragments/labels/`
- [ ] Datei liegt in `fragments/custom/`

---

## Testen eines Labels

Vom Repo-Root aus:
```zsh
# Debug-Modus (kein echter Install, Download ins Skript-Verzeichnis)
./assemble.sh -l fragments/custom labelname

# Mit weiteren Optionen
sudo ./assemble.sh -l fragments/custom labelname NOTIFY=silent DEBUG=0
```

---

## Was ich NICHT tue

- Dateien außerhalb von `fragments/custom/` bearbeiten oder erstellen
- `Installomator.sh` im Root direkt bearbeiten (wird generiert)
- PRs oder Branches erstellen (das ist Aufgabe des Benutzers)
- Dateien im Ordner `fragments/disabled/` oder `fragments/broken/` anlegen
