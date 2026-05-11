pathfinder)
    name="Path Finder"
    type="dmg"
    downloadURL="https://get.cocoatech.com/PathFinder.dmg"
    appNewVersion=$(curl -fsL "https://get.cocoatech.com/appcast.xml" | grep 'sparkle:shortVersionString' | head -1 | sed -E 's/.*>([^<]+)<.*/\1/')
    expectedTeamID="5GM4WX237V"
    ;;
