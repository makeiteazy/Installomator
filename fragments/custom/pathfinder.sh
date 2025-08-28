pathfinder)
    name="Path Finder"
    type="dmg"
    downloadURL="https://get.cocoatech.com/PathFinder.dmg"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -f https://store.cocoatech.io/updates | grep -i changes | head -1 | sed -E 's/.*version ([0-9]+).*/\1/')
    expectedTeamID="5GM4WX237V"
    ;;
