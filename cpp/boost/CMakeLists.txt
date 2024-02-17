set(CMAKE_CXX_STANDARD 17)

include(ExternalProject)

set(BOOST_CHECKSUM "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454")

if(ANDROID)
  set(B2_IGNORED_LIBRARIES --without-locale)
endif()

ExternalProject_Add(boost
  URL https://boostorg.jfrog.io/artifactory/main/release/1.84.0/source/boost_1_84_0.tar.bz2
  URL_HASH SHA256=${BOOST_CHECKSUM}

  DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/.cache/
  SOURCE_DIR libs/boost
  CONFIGURE_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/libs/boost/tools/build/ && ./bootstrap.sh
  BUILD_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/libs/boost && ./tools/build/b2 --prefix=${CMAKE_CURRENT_BINARY_DIR}/ --libdir=${CMAKE_CURRENT_BINARY_DIR} ${B2_IGNORED_LIBRARIES} install
  INSTALL_COMMAND echo "Finished Building Boost"
)

include_directories(AFTER ${CMAKE_BINARY_DIR}/boost/include/)
link_directories(AFTER ${CMAKE_BINARY_DIR}/boost)
add_executable(boost_dummy src/dummy.cc)
add_dependencies(boost_dummy boost)
target_link_libraries(boost_dummy boost_container)
