if (WIN32)
    set(CMAKE_INSTALL_BINDIR bin)
    set(CMAKE_INSTALL_LIBDIR lib)
    set(CMAKE_INSTALL_DATADIR share)
    set(CMAKE_INSTALL_INCLUDEDIR include)
elseif(APPLE)
    set(CMAKE_INSTALL_BINDIR bin)
    set(CMAKE_INSTALL_LIBDIR lib)
    set(CMAKE_INSTALL_DATADIR share)
    set(CMAKE_INSTALL_INCLUDEDIR include)
elseif(UNIX)
    include(GNUInstallDirs)
endif()

message(STATUS "CMAKE_INSTALL_BINDIR: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}")
message(STATUS "CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")
message(STATUS "CMAKE_INSTALL_DATADIR: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}")