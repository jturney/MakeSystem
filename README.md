MakeSystem
==========

A complete makefile system for compiling simple projects. Simply edit Makefile specifying 
exe, sources, and include\_dirs.

In the Makefile list any binaries that you want to compile:

    exe := test1 test2

Then list the sources files for each binary listed in exe:

    test1_sources := test1.cc
    test2_sources := test2.cc

Set other flags for things you need. For example if you need debug flags set:

    need_debug := 1

To compile all binaries simply issue the `make` command. Or to make a specific binary: `make test1`
