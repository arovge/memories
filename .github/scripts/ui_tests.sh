set -o pipefail && xcodebuild CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO" -workspace Memories.xcworkspace -scheme UITests -destination 'platform=iOS Simulator,name=iPhone 13,OS=15.2' test | xcpretty
