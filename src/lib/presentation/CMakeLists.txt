set(LIB_NAME "${PROJECT_NAME}.Presentation")

set(CMAKE_AUTORCC OFF)

set(EXCLUDE_DIRS "Linux")
glob_recurse_excl(HEADER_FILES src/*.hpp "${EXCLUDE_DIRS}")
glob_recurse_excl(SOURCE_FILES src/*.cpp "${EXCLUDE_DIRS}")
file(GLOB_RECURSE CONF_FILES CONFIGURE_DEPENDS *.conf)
file(GLOB_RECURSE QML_FILES CONFIGURE_DEPENDS imports/*.qml)
list(SORT QML_FILES)
if (ENABLE_QML_LINT)
    message(STATUS "Using qmllint")
    qml_lint(${QML_FILES})
endif()

set(QML_FILES ${QML_FILES} imports/MellowPlayer/qmldir)
if(UNIX AND NOT APPLE)
    glob_recurse_excl(MPRIS_HEADER_FILES src/MellowPlayer/Presentation/Mpris/Linux/*.hpp "")
    glob_recurse_excl(MPRIS_SOURCE_FILES src/MellowPlayer/Presentation/Mpris/Linux/*.cpp "")
    set(SOURCE_FILES ${SOURCE_FILES} ${MPRIS_SOURCE_FILES})
    set(HEADER_FILES ${HEADER_FILES} ${MPRIS_HEADER_FILES})
    if(USE_LIBNOTIFY)
        glob_recurse_excl(LIBNOTIFY_PRESENTER_HEADER_FILES src/MellowPlayer/Presentation/Notifications/Presenters/Linux/*.hpp "")
        glob_recurse_excl(LIBNOTIFY_PRESENTER_SOURCE_FILES src/MellowPlayer/Presentation/Notifications/Presenters/Linux/*.cpp "")
        set(SOURCE_FILES ${SOURCE_FILES} ${LIBNOTIFY_PRESENTER_SOURCE_FILES})
        set(HEADER_FILES ${HEADER_FILES} ${LIBNOTIFY_PRESENTER_HEADER_FILES})
    endif()
endif()

qt5_add_resources(RESOURCES resources/presentation.qrc)
if (ENABLE_QUICK_COMPILER)
    message(STATUS "Using Qt Quick Compiler")
    qtquick_compiler_add_resources(QML_RESOURCES imports/imports.qrc)
else()
    qt5_add_resources(QML_RESOURCES imports/imports.qrc)
endif()


if (MSVC_COMPILER)
    add_library(${LIB_NAME} STATIC ${SOURCE_FILES} ${HEADER_FILES} ${CONF_FILES} ${RESOURCES} ${QML_RESOURCES})
else()
    add_library(${LIB_NAME} SHARED ${SOURCE_FILES} ${HEADER_FILES} ${CONF_FILES} ${RESOURCES} ${QML_RESOURCES})
    install(TARGETS ${LIB_NAME}
            BUNDLE DESTINATION MacOS
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/static)
endif()

target_precompile_headers(${LIB_NAME} REUSE_FROM ${PROJECT_NAME}.Domain)
target_link_libraries(${LIB_NAME} ${PROJECT_NAME}.Domain ${PROJECT_NAME}.Infrastructure
                      qhotkey Qt5::Core Qt5::Qml Qt5::Quick Qt5::QuickControls2 Qt5::Svg
                      Qt5::WebEngine Qt5::WebEngineWidgets Qt5::Widgets)
target_include_directories(${LIB_NAME} PUBLIC src)
if(USE_LIBNOTIFY)
    target_include_directories(${LIB_NAME} SYSTEM PRIVATE ${LIBNOTIFY_INCLUDE_DIRS})
endif()

if(UNIX AND NOT APPLE)
    target_link_libraries(${LIB_NAME} Qt5::DBus)
    if(USE_LIBNOTIFY)
        target_link_libraries(${LIB_NAME} ${LIBNOTIFY_LIBRARIES})
    endif()
endif()
