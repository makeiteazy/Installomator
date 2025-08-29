advolux)
    name="Haufe Advolux Kanzleisoftware Installationsprogramm_m1"
    type="dmg"
    downloadURL="https://download.advolux.de/macosx-m1.php"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | cut -d "_" -f3)
    expectedTeamID="TD936WV4J6"
    ;;
