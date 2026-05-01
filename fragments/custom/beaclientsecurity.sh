beaclientsecurity)
    name="beA Client Security"
    appName="beA Client Security Installationsprogramm.app"
    type="dmg"
    CLIInstaller="beA Client Security Installationsprogramm.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    downloadURL="https://installer.bea-brak.de/cs/installation/1/beAClientSecurity-Installation.dmg"
    appCustomVersion(){ /usr/bin/defaults read "/Applications/beA Client Security.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null }
    expectedTeamID="PL45P24U4J"
    blockingProcesses=( "JavaApplicationStub" )
    ;;
