set(CMAKE_CXX_STANDARD ${CPPTutorial_BOOST_CXX_STANDARD})

include(ExternalProject)

if (${CMAKE_CXX_COMPILER_ID} STREQUAL Clang)
	set(B2_FLAGS toolset=clang --cxx=clang++ linkflags=-L/system/lib64/)
	set(B2_BOOTSTRAP_FLAGS --with-toolset=clang --cxx=clang++)
endif()

set(B2_CXXFLAGS "")
if(${CPPTutorial_BOOST_CXX_STANDARD} EQUAL 98)
		set(BOOST_URL "https://archives.boost.io/release/1.83.0/source/boost_1_83_0.tar.bz2")
		set(BOOST_CHECKSUM "6478edfe2f3305127cffe8caf73ea0176c53769f4bf1585be237eb30798c3b8e")
		set(B2_CXXFLAGS cxxflags=--std=c++03)
else()
		set(BOOST_URL "https://archives.boost.io/release/1.91.0/source/boost_1_91_0.tar.bz2")
		set(BOOST_CHECKSUM "de5e6b0e4913395c6bdfa90537febd9028ea4c0735d2cdb0cd9b45d5f51264f5")
endif()

if(ANDROID)
	set(B2_FLAGS boost.locale.posix=off ${B2_FLAGS})
	set(B2_CXXFLAGS ${B2_CXXFLAGS} cxxflags=-D__ANDROID__ cflags=-D__ANDROID__ target-os=android)
	if (${CMAKE_CXX_COMPILER_ID} STREQUAL Clang)
		set(B2_CXXFLAGS ${B2_CXXFLAGS} cxxflags=-I$PREFIX/include/aarch64-linux-android linkflags=-L$PREFIX/lib cflags=-I$PREFIX/include/aarch64-linux-android)
		set(B2_FLAGS --without-test --without-process --without-stacktrace ${B2_FLAGS} abi=aapcs architecture=arm address-model=64 binary-format=elf threading=multi )
	endif()
endif()

string(CONCAT CPPTutorial_BOOST_DIR "libs/boost" "${CPPTutorial_BOOST_CXX_STANDARD}")
ExternalProject_Add(boost
	URL ${BOOST_URL}
	URL_HASH SHA256=${BOOST_CHECKSUM}

  DOWNLOAD_DIR ${CMAKE_SOURCE_DIR}/.cache/
	SOURCE_DIR ${CPPTutorial_BOOST_DIR}
	CONFIGURE_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/${CPPTutorial_BOOST_DIR}/tools/build/ && ./bootstrap.sh ${B2_BOOTSTRAP_FLAGS}
	BUILD_COMMAND cd ${CMAKE_CURRENT_BINARY_DIR}/${CPPTutorial_BOOST_DIR} && ./tools/build/b2 --without-python --prefix=${CMAKE_CURRENT_BINARY_DIR}/ --libdir=${CMAKE_CURRENT_BINARY_DIR} ${B2_FLAGS} ${B2_CXXFLAGS} install
  INSTALL_COMMAND echo "Finished Building Boost"
)

include_directories(AFTER ${CMAKE_BINARY_DIR}/boost/include/)
link_directories(AFTER ${CMAKE_BINARY_DIR}/boost)
add_executable(boost_dummy src/dummy.cc)
add_dependencies(boost_dummy boost)
target_link_libraries(boost_dummy boost_container)
