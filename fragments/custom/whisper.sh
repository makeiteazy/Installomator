whisper)
    name="WhisperTranscribe"
    type="dmg"
    downloadURL="https://api.whispertranscribe.com/download/mac"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^Content-Disposition | cut -d "-" -f3)
    expectedTeamID="X77Z2VJ228"
    ;;
