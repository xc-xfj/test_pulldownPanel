cmake_minimum_required(VERSION 3.1)

project(test_pulldowPanel LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS  Quick REQUIRED)
find_package(Qt5Quick CONFIG REQUIRED)
find_package(DtkDeclarative REQUIRED)
#find_package(DtkCore5.5 REQUIRED)
find_package(Qt5QuickCompiler REQUIRED)

file(GLOB_RECURSE SRCS src/*.cpp)

add_executable(${PROJECT_NAME} "main.cpp" "qml.qrc" ${SRCS})

include_directories(${CMAKE_PROJECT_NAME}
    src
)

target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick)
