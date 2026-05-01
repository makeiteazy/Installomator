whispertranscribe)
    name="Whisper Transcribe"
    type="dmg"
    case $(arch) in
        "arm64")
            downloadURL="https://api.whispertranscribe.com/download/mac?arch=arm64"
        ;;
        "i386")
            downloadURL="https://api.whispertranscribe.com/download/mac?arch=x64"
        ;;
    esac
    appNewVersion=$(curl -fsIL "https://api.whispertranscribe.com/download/mac?arch=arm64" | grep -i "content-disposition" | sed -E 's/.*WhisperTranscribe-([0-9.]+)-.*/\1/')
    expectedTeamID="X77Z2VJ228"
    ;;
