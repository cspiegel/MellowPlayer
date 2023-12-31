cmake_minimum_required(VERSION 3.16)

set(VERSION_MAJOR 3)
set(VERSION_MINOR 7)
set(VERSION_PATCH 0)

if(EXISTS ${PROJECT_SOURCE_DIR}/.git/)
    execute_process(
            COMMAND git rev-list HEAD --count
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}

            OUTPUT_VARIABLE VERSION_TWEAK
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if (VERSION_TWEAK STREQUAL "")
        set(VERSION_TWEAK 0)
    endif()
else()
    set(VERSION_TWEAK 0)
endif()

project(MellowPlayer VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.${VERSION_TWEAK}")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ ${CMAKE_MODULE_PATH})
message(STATUS "Building MellowPlayer version ${PROJECT_VERSION}")

set(SOURCE_DIR ${CMAKE_SOURCE_DIR})

include(cmake/Macros.cmake)

# Options
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)
set_option(BUILD_TESTS OFF BOOL "TRUE to build the tests, FALSE to ignore them.")
set_option(ENABLE_QUICK_COMPILER ON BOOL "TRUE to compile qml files ahead of time, FALSE to skip ahead of time compilation. Default is ON")
set_option(ENABLE_QML_LINT OFF BOOL "TRUE to check qml file syntax, FALSE to skip check. Default is FALSE")
set_option(ENABLE_COVERAGE OFF BOOL "True to build code coverage targerts")
set_option(ENABLE_LCOV_REPORT OFF BOOL "True to enable lcov coverage report. Default is False.")
set_option(STATIC_LIBSTDCPP OFF BOOL "True to link statically with libstdc++ and libgcc")
set_option(DEFAULT_THEME "Adaptive" STRING "The default theme (available: Default, Midna, MidnaDark, Breeze, BreezeDark, Deezer, Spotify,...)")
if (UNIX)
    set_option(USE_LD_GOLD ON BOOL "Use GNU gold linker")
endif()

if (ENABLE_COVERAGE)
    include(cmake/CodeCoverage.cmake)
endif()
include(cmake/Config.cmake)
include(cmake/Dependencies.cmake)
include(cmake/InstallDirs.cmake)
include(cmake/Tests.cmake)

add_subdirectory(src/lib)
add_subdirectory(src/main)
add_subdirectory(src/plugins)
if(BUILD_TESTS)
    enable_testing()
    include(${CMAKE_BINARY_DIR}/_deps/catch2-src/contrib/Catch.cmake)
    add_subdirectory(src/tests)
endif()
