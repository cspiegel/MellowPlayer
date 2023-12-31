set(LIB_NAME "${PROJECT_NAME}.Application")

file(GLOB_RECURSE SOURCE_FILES CONFIGURE_DEPENDS src/*.cpp)
file(GLOB_RECURSE HEADER_FILES CONFIGURE_DEPENDS src/*.hpp)

if (MSVC_COMPILER)
    add_library(${LIB_NAME} STATIC ${SOURCE_FILES} ${HEADER_FILES})
else()
    add_library(${LIB_NAME} SHARED ${SOURCE_FILES} ${HEADER_FILES})
    install(TARGETS ${LIB_NAME}
            BUNDLE DESTINATION MacOS
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/static)
endif()

target_precompile_headers(${LIB_NAME} REUSE_FROM ${PROJECT_NAME}.Domain)
target_include_directories(${LIB_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
if(USE_LIBNOTIFY)
    target_compile_definitions(${LIB_NAME} PUBLIC -DUSE_LIBNOTIFY)
endif()
target_link_libraries(${LIB_NAME} PUBLIC Qt5::Core Qt5::Gui ${PROJECT_NAME}.Domain ${PROJECT_NAME}.Infrastructure ${PROJECT_NAME}.Presentation)
if ( NOT SYSTEM_BOOST_DI_FOUND )
    target_link_libraries(${LIB_NAME} PUBLIC Boost.DI)
endif()
