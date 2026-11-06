# Keep the Windows product version in sync with macOS.
set(PROJECT_CONFIG "${ROOT}/project.yml")
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${PROJECT_CONFIG}")
file(STRINGS "${PROJECT_CONFIG}" MARKETING_VERSION_LINE REGEX "MARKETING_VERSION:")
file(STRINGS "${PROJECT_CONFIG}" BUILD_VERSION_LINE REGEX "CURRENT_PROJECT_VERSION:")
if(NOT MARKETING_VERSION_LINE MATCHES "MARKETING_VERSION: *\"([0-9]+\\.[0-9]+\\.[0-9]+)\"")
  message(FATAL_ERROR "Expected a three-part MARKETING_VERSION in project.yml.")
endif()
set(ENVISPEED_VERSION "${CMAKE_MATCH_1}")
if(NOT BUILD_VERSION_LINE MATCHES "CURRENT_PROJECT_VERSION: *\"([0-9]+)\"")
  message(FATAL_ERROR "Expected a numeric CURRENT_PROJECT_VERSION in project.yml.")
endif()
set(ENVISPEED_BUILD "${CMAKE_MATCH_1}")
string(REPLACE "." "," ENVISPEED_VERSION_NUM "${ENVISPEED_VERSION}.${ENVISPEED_BUILD}")
configure_file(Version.h.in Version.h @ONLY)

add_executable(envispeed WIN32 main.cpp Core.cpp Prefs.cpp Site.cpp Settings.cpp Emoji.cpp CrashReporter.cpp Envispeed.rc)
set_target_properties(envispeed PROPERTIES OUTPUT_NAME Envispeed)
target_include_directories(envispeed PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}")
target_compile_definitions(envispeed PRIVATE UNICODE _UNICODE)
target_link_libraries(envispeed PRIVATE envispeed_engine user32 shell32 gdi32 advapi32 imm32 psapi
  ole32 oleaut32 comctl32 gdiplus winmm d2d1 dwrite dwmapi normaliz)
target_link_options(envispeed PRIVATE /MANIFEST:NO)
set_property(SOURCE Envispeed.rc APPEND PROPERTY OBJECT_DEPENDS
  "${CMAKE_CURRENT_BINARY_DIR}/Version.h"
  "${CMAKE_CURRENT_SOURCE_DIR}/Envispeed.ico"
  "${CMAKE_CURRENT_SOURCE_DIR}/Envispeed.manifest"
  "${CMAKE_CURRENT_SOURCE_DIR}/Sounds/SwitchToVietnamese.wav"
  "${CMAKE_CURRENT_SOURCE_DIR}/Sounds/SwitchToEnglish.wav"
  "${ROOT}/App/Resources/Emoji.json")

# Runs SendInput through the app's live hook in an interactive Windows session.
add_executable(envispeed_livetest ../Tests/livetest.cpp)
target_compile_definitions(envispeed_livetest PRIVATE UNICODE _UNICODE)
target_link_libraries(envispeed_livetest PRIVATE envispeed_engine user32 gdi32)
