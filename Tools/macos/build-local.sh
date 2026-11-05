#!/bin/zsh
# Build the existing SwiftUI / Objective-C++ app using Apple's tools, without installing XcodeGen.
# Usage: zsh Tools/macos/build-local.sh [--run]
set -euo pipefail
cd "$(dirname "$0")/../.."
ROOT=$PWD
BUILD=${ENVISPEED_BUILD_DIR:-"$ROOT/build/macos"}
APP="$BUILD/Envispeed.app"
OBJ="$BUILD/obj"
SDK=$(xcrun --sdk macosx --show-sdk-path)
ARCH=$(uname -m)
MIN_OS=13.0

if (( $# > 1 )) || [[ ${1:-} != "" && ${1:-} != "--run" ]]; then
  print -u2 "Usage: zsh Tools/macos/build-local.sh [--run]"
  exit 2
fi
for pid in $(pgrep -x Envispeed || true); do
  running=$(ps -p "$pid" -o command= || true)
  if [[ $running == "$APP/Contents/MacOS/Envispeed"* ]]; then
    print -u2 "Quit Envispeed before rebuilding (menu bar > Thoát Envispeed)."
    exit 1
  fi
done
mkdir -p "$OBJ" "$APP/Contents/MacOS" "$APP/Contents/Resources"
for stale in "$OBJ"/*.o(N); do rm -f "$stale"; done

print "Building Envispeed for $ARCH (macOS $MIN_OS+)"
for src in Engine/*.cpp App/Core/*.mm; do
  name=${src:t:r}
  flags=(-std=c++17 -g -O0 -isysroot "$SDK" -arch "$ARCH" "-mmacosx-version-min=$MIN_OS" -IEngine -IEngine/platforms)
  [[ $src == *.mm ]] && flags+=(-fobjc-arc)
  xcrun clang++ "${flags[@]}" -c "$src" -o "$OBJ/$name.o"
done
xcrun swiftc -swift-version 5 -D DEBUG -g -Onone -parse-as-library \
  -module-name Envispeed -target "$ARCH-apple-macos$MIN_OS" -sdk "$SDK" \
  -import-objc-header App/Core/Envispeed-Bridging-Header.h \
  -Xcc -IEngine -Xcc -IEngine/platforms \
  App/**/*.swift "$OBJ"/*.o -lc++ \
  -framework Carbon -framework ApplicationServices \
  -o "$APP/Contents/MacOS/Envispeed"

xcrun actool App/Resources/Assets.xcassets --compile "$APP/Contents/Resources" \
  --platform macosx --minimum-deployment-target "$MIN_OS" --target-device mac \
  --app-icon AppIcon --output-partial-info-plist "$BUILD/asset-info.plist" \
  --warnings --errors
cp App/Resources/Emoji.json "$APP/Contents/Resources/"
cp App/Resources/Sounds/*.caf "$APP/Contents/Resources/"
cp design/Envispeed.icns "$APP/Contents/Resources/Envispeed.icns"
cp LICENSE ACKNOWLEDGEMENTS.md "$APP/Contents/Resources/"

python3 - "$APP" "$MIN_OS" <<'PY'
import pathlib, plistlib, re, sys
app = pathlib.Path(sys.argv[1])
with open('App/Info.plist', 'rb') as source:
    info = plistlib.load(source)
project = pathlib.Path('project.yml').read_text()
def version(key):
    return re.search(r'^\s*' + key + r': "([^"]+)"', project, re.M).group(1)
info.update(
    CFBundleExecutable='Envispeed', CFBundleIdentifier='io.github.chequanghuyca.envispeed',
    CFBundleName='Envispeed', CFBundleShortVersionString=version('MARKETING_VERSION'),
    CFBundleVersion=version('CURRENT_PROJECT_VERSION'), LSMinimumSystemVersion=sys.argv[2],
)
with (app / 'Contents/Info.plist').open('wb') as destination:
    plistlib.dump(info, destination, sort_keys=False)
PY
printf 'APPL????' > "$APP/Contents/PkgInfo"
codesign --force --sign - --identifier io.github.chequanghuyca.envispeed \
  --entitlements App/Envispeed.entitlements "$APP"
codesign --verify --deep --strict "$APP"
print "Ready: $APP"
if [[ ${1:-} == "--run" ]]; then
  open "$APP"
fi
