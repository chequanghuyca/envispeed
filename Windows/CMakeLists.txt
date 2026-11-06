# Envispeed engine + test tools, cross-platform (MSVC on Windows, clang on macOS for validation).
# Configure:  cmake -S Windows -B Windows/build -G Ninja -DCMAKE_BUILD_TYPE=Release
# Build:      cmake --build Windows/build
# Test binaries are kept under the build directory.
cmake_minimum_required(VERSION 3.21)
# Static C++ runtime (/MT): Envispeed.exe runs without the Visual C++ Redistributable, which the installer and zip don't ship (#79)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
project(Envispeed LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(ROOT ${CMAKE_CURRENT_SOURCE_DIR}/..)
set(ENGINE ${ROOT}/Engine)
set(AS ${ROOT}/Tools/autoswitch)

set(ENGINE_SRC ${ENGINE}/Engine.cpp ${ENGINE}/Vietnamese.cpp ${ENGINE}/SmartSwitchKey.cpp)

add_library(envispeed_engine STATIC ${ENGINE_SRC} ${ENGINE}/Driver.cpp ${ENGINE}/TouchModel.cpp)
target_include_directories(envispeed_engine PUBLIC ${ENGINE} ${ENGINE}/platforms)
if(MSVC)
  target_compile_options(envispeed_engine PUBLIC "$<$<COMPILE_LANGUAGE:CXX>:/utf-8;/W0;/EHsc;/bigobj>")
  target_compile_definitions(envispeed_engine PUBLIC _SILENCE_ALL_CXX17_DEPRECATION_WARNINGS NOMINMAX WIN32_LEAN_AND_MEAN _CRT_SECURE_NO_WARNINGS)
else()
  target_compile_options(envispeed_engine PUBLIC -w -O2)
endif()

# A separate engine build with AS_TESTING for the simulator (check.sh compiles sim with -DAS_TESTING).
add_library(envispeed_engine_testing STATIC ${ENGINE_SRC})
target_include_directories(envispeed_engine_testing PUBLIC ${ENGINE} ${ENGINE}/platforms)
target_compile_definitions(envispeed_engine_testing PUBLIC AS_TESTING)
if(MSVC)
  target_compile_options(envispeed_engine_testing PUBLIC /utf-8 /W0 /EHsc /bigobj)
  target_compile_definitions(envispeed_engine_testing PUBLIC _SILENCE_ALL_CXX17_DEPRECATION_WARNINGS NOMINMAX WIN32_LEAN_AND_MEAN _CRT_SECURE_NO_WARNINGS)
else()
  target_compile_options(envispeed_engine_testing PUBLIC -w -O2)
endif()

function(envispeed_tool name src lib)
  add_executable(${name} ${src})
  target_link_libraries(${name} PRIVATE ${lib})
  set_target_properties(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tools")
  if(WIN32 AND MSVC)
    target_sources(${name} PRIVATE Tests/utf8.manifest)
  endif()
endfunction()

envispeed_tool(harness ${AS}/test/harness.cpp envispeed_engine)
envispeed_tool(sim ${AS}/sim/sim.cpp envispeed_engine_testing)
envispeed_tool(drvlazy ${AS}/driver/drvlazy.cpp envispeed_engine)
envispeed_tool(bench ${AS}/driver/bench.cpp envispeed_engine)
envispeed_tool(undo_test ${AS}/driver/undo_test.cpp envispeed_engine)
envispeed_tool(touchsim ${AS}/touch/touchsim.cpp envispeed_engine)

if(WIN32)
  if(NOT MSVC)
    message(FATAL_ERROR "The Envispeed Windows app requires the MSVC toolchain.")
  endif()
  enable_language(RC)
  add_subdirectory(App)
endif()
