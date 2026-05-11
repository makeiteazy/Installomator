brave)
    name="Brave Browser"
    type="dmg"
    versionKey="CFBundleVersion"
    if [[ $(arch) != "i386" ]]; then
        archiveName="Brave-Browser-arm64.dmg"
    else
        archiveName="Brave-Browser-x64.dmg"
    fi
    downloadURL=$(downloadURLFromGit "brave" "brave-browser")
    # versionFromGit liefert z.B. "1.89.145"; CFBundleVersion ist "189.145" → erstes "." entfernen
    appNewVersion=$(versionFromGit "brave" "brave-browser" | sed 's/\.//')
    expectedTeamID="KL8N8XSYF4"
    ;;
