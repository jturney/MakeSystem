# List of binaries to generate
exe := hello
lib := test

# Sources specific to each binary
hello_sources := src/main.cc
test_sources := src/test.cc

# Common include directories
include_dirs := include

# Override the default compiler
#    Understands clang++, g++, and icpc.
CXX := clang++

# Other things that I could need. These flags apply for all binaries
#    need_debug := adds debug flags to the compilation
#    need_blas  := true includes BLAS and LAPACK
#    need_boost := true includes Boost and libraries defined in settings.mk/boost.mk
#    need_gmp   := true includes The GNU Multiple Precision Arithmetic Library
need_psi4 := true
#need_blas := false
#need_debug := true
#need_gmp := true
need_boost := true

include settings.mk/common.mk

