# TyTools - public domain
# Niels Martignène <niels.martignene@protonmail.com>
# https://koromix.dev/tytools

# This software is in the public domain. Where that dedication is not
# recognized, you are granted a perpetual, irrevocable license to copy,
# distribute, and modify this file as you see fit.

# See the LICENSE file for more details.


set(CMAKE_OSX_DEPLOYMENT_TARGET "10.10" CACHE STRING "")
cmake_minimum_required(VERSION 3.1)
project(TyTools C CXX)

message(STATUS "hola ${CMAKE_SOURCE_DIR}   ,  ${CMAKE_BINARY_DIR},    ${CMAKE_CURRENT_BINARY_DIR}")


set(CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src/tytools)
set(CMAKE_CURRENT_SOURCE_DIR $ENV{CMAKE_BINARY_DIR}/src/tytools)

# set(CMAKE_BINARY_DIR $ENV{CMAKE_CURRENT_BINARY_DIR}/src)
# set(CMAKE_CURRENT_BINARY_DIR $ENV{CMAKE_BINARY_DIR})

if(CONFIG_VARIANT)
    if(IS_ABSOLUTE ${CONFIG_VARIANT})
        set(CONFIG_VARIANT_PATH ${CONFIG_VARIANT})
    else()
        set(CONFIG_VARIANT_PATH "${CMAKE_CURRENT_SOURCE_DIR}/variants/${CONFIG_VARIANT}")
    endif()
    if(EXISTS "${CONFIG_VARIANT_PATH}/variant.cmake")
        include("${CONFIG_VARIANT_PATH}/variant.cmake")
    endif()

    set(USE_UNITY_BUILDS OFF CACHE BOOL "")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

include("${CMAKE_SOURCE_DIR}/cmake/Utility.cmake")

set(VERSION_DEFAULT "0.8.11" CACHE STRING "Default version number")

set(VERSION_WITH_GIT ON CACHE BOOL "Compute version using git tags (fallback)")

set(CONFIG_TYCMD_BUILD ON CACHE BOOL "Build tycmd (Teensy command-line manager)")
set(CONFIG_TYCMD_EXECUTABLE "tycmd" CACHE STRING "Rename tycmd executable")
set(CONFIG_TYCMD_NAME "tycmd" CACHE STRING "Rename tycmd application")

set(CONFIG_URL_WEBSITE "https://github.com/Koromix/tytools" CACHE STRING "Project website")
set(CONFIG_URL_BUGS "https://github.com/Koromix/tytools/issues" CACHE STRING "Project bug report page")

set(CONFIG_PACKAGE_NAME "TyTools" CACHE STRING "Package / installer name")
set(CONFIG_PACKAGE_FILENAME "TyTools" CACHE STRING "Package / installer filename")

set(VERSION ${VERSION_DEFAULT})
if(VERSION_WITH_GIT AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    find_package(Git)
    if(GIT_FOUND)
        # Recompute the version string after each commit, does not work for tags though
        if(EXISTS "${CMAKE_SOURCE_DIR}/.git/logs/HEAD")
            configure_file("${CMAKE_SOURCE_DIR}/.git/logs/HEAD" git_logs_HEAD COPYONLY)
        endif()
        execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --tags
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            OUTPUT_VARIABLE VERSION
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(SUBSTRING ${VERSION} 1 -1 VERSION)
    endif()
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY $ENV{MIX_COMPILE_PATH}/../priv)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY $ENV{MIX_COMPILE_PATH}/../priv)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY $ENV{MIX_COMPILE_PATH}/../priv)

add_subdirectory(${CMAKE_SOURCE_DIR}/src/libhs)
add_subdirectory(${CMAKE_SOURCE_DIR}/src/libty)
if(CONFIG_TYCMD_BUILD)
    add_subdirectory(${CMAKE_SOURCE_DIR}/src/tycmd)
endif()
set(BUILD_TESTS ON CACHE BOOL "Build unit tests and enable CTest")
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(${CMAKE_SOURCE_DIR}/tests/libty)
endif()

set(CPACK_PACKAGE_NAME "${CONFIG_PACKAGE_NAME}")
string(REGEX REPLACE "\\-.*$" "" CPACK_PACKAGE_VERSION "${VERSION}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CONFIG_PACKAGE_FILENAME}")