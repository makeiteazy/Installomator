miro)
    name="Miro"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin-arm64/Install-Miro.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://desktop.miro.com/platforms/darwin/Install-Miro.dmg"
    fi
    appNewVersion=$(curl -fsL "https://formulae.brew.sh/api/cask/miro.json" | grep -o '"version":"[^"]*"' | head -1 | cut -d'"' -f4)
    expectedTeamID="M3GM7MFY7U"
    ;;
