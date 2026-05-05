anydesk)
    name="AnyDesk"
    type="dmg"
    downloadURL="https://download.anydesk.com/anydesk.dmg"
    appNewVersion=$(curl -fs "https://formulae.brew.sh/api/cask/anydesk.json" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('version',''))")
    expectedTeamID="KHRWM533LU"
    ;;
