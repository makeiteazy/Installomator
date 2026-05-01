bnotk-saklite)
    name="BNotK SAK lite"
    type="dmg"
    downloadURL="https://sso.bnotk.de/saklite/bnotk-saklite-latest-setup-macos.dmg"
    appCustomVersion() { defaults read "/Applications/BNotK SAK lite.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "0" }
    expectedTeamID="SUVE3REYTH"
    ;;
