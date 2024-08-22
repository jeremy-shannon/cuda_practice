cmake_minimum_required(VERSION 3.15)

if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES 89)
endif()

project(julia_bmp LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS}) 
add_executable(julia_bmp julia_main.cpp julia.cu)
target_link_libraries(julia_bmp ${OpenCV_LIBS})