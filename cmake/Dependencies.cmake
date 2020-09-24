set(QT_MIN_VERSION 5.15)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
        Concurrent
        Core
        Gui
        Network
        Qml
        Quick
        QuickControls2
        Sql
        Svg
        Test
        WebEngine
        WebChannel
        WebEngineWidgets
        Widgets)
find_package(Qt5LinguistTools REQUIRED)
if (UNIX AND NOT APPLE)
    find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS DBus)
endif()

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
message(STATUS "Found Qt ${Qt5_VERSION} in ${Qt5_DIR}")

if(UNIX AND NOT APPLE)
    find_package(PkgConfig)
    pkg_search_module(LIBNOTIFY REQUIRED libnotify)
    if (LIBNOTIFY_FOUND)
        message(STATUS "Found libnotify ${LIBNOTIFY_VERSION} in ${LIBNOTIFY_LIBDIR}")
        set(USE_LIBNOTIFY ON)
    else ()
        message(STATUS "libnotify not found, system tray icon based notifications will be enabled")
    endif()
endif()

find_package(qxtglobalshortcut QUIET)
if (qxtglobalshortcut_FOUND)
    message(STATUS "Found qxtglobalshortcut")
else()
    add_subdirectory(${CMAKE_SOURCE_DIR}/src/3rdparty/libqxt)
endif()

Include(FetchContent)

if (BUILD_TESTS)
    FetchContent_Declare(
            Catch2
            GIT_REPOSITORY https://github.com/catchorg/Catch2.git
            GIT_TAG        v2.13.1)
    FetchContent_MakeAvailable(Catch2)
endif()