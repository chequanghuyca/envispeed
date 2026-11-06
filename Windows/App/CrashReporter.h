// Crash reports stay in %LOCALAPPDATA%\Envispeed\Crashes. They record the error, version, thread,
// and stack frames, without typed text or a memory dump.
#pragma once
#include <windows.h>

namespace envispeed::crash {

void install();
void selfTestIfAsked();   // --crash-self-test or --crash-self-test=terminate
void checkAtLaunch();     // offer to open the newest report locally

} // namespace envispeed::crash
