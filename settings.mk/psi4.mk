need_boost := true
need_python := true

ifndef psi4.psi4_config
	psi4.psi4_config := psi4-config
endif
psi4.objdir := $(shell ${psi4.psi4_config} --objdir)
psi4.srcdir := $(shell ${psi4.psi4_config} --srcdir)

psi4.include_dirs := ${psi4.objdir}/include ${psi4.objdir}/src/lib ${psi4.srcdir}/include ${psi4.srcdir}/src/lib
ifeq "$(system.os)" "Darwin"
	psi4.ldflags := -shared -undefined dynamic_lookup
	psi4.cxxflags := -fno-common
else
	psi4.ldflags := -shared
endif

psi4.program_suffix := .so

