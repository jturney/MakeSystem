include settings.mk/system.mk
include settings.mk/$(CXX).mk

# List new need components here
needs := psi4 boost gmp llvm

CXXFLAGS += $($(CXX).cxxflags)
LDFLAGS  += $($(CXX).ldflags)
TARGET_ARCH += $($(CXX).target_arch)

# Debug and BLAS depend on the compiler. Handle these needs separately
ifeq "$(need_debug)" "true"
	CXXFLAGS += $($(CXX).debug)
else
	CXXFLAGS += $($(CXX).optimization)
endif

# BLAS is compiler specific (because of Intel)
ifeq "$(need_blas)" "true"
	CXXFLAGS += $($(CXX).blas_cxxflags)
	LIBRARIES += $($(CXX).blas_libraries)
endif

define handle-need
ifeq "$$(need_$1)" "true"
	include_dirs += $$($1.include_dirs)
	CXXFLAGS += $$($1.cxxflags)
	LIBRARIES += $$($1.libraries)
	LDFLAGS += $$($1.ldflags)
	ifdef $1.program_suffix
	PROGRAM_SUFFIX += $$($1.program_suffix)
	endif
endif
endef

define include-need
include settings.mk/$1.mk
endef

$(foreach need,$(needs),$(eval $(call include-need,$(need))))
$(foreach need,$(needs),$(eval $(call handle-need,$(need))))
#$(shell echo $(PROGRAM_SUFFIX) ;)
exe_with_suffix := $(addsuffix $(PROGRAM_SUFFIX),$(exe))

all: $(exe_with_suffix)

CPPFLAGS += $(addprefix -I ,$(sort $(include_dirs)))
vpath %.h $(include_dirs)

define build-program
$1_objects := $(subst .cc,.o,$2)
$1_dependencies := $(subst .cc,.d,$2)
$1_assembly := $(subst .cc,.s,$2)
objects += $$($1_objects)
dependencies += $$($1_dependencies)
assembly += $$($1_assembly)

$(1)$(PROGRAM_SUFFIX): $$($1_objects)
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LIBRARIES)
endef

#$(eval $(call build-program,etemplate,$(etemplate_sources)))
$(foreach prog,$(exe),$(eval $(call build-program,$(prog),$($(prog)_sources))))

# Rule to create assembly code only
asm: $(assembly)

.PHONY: clean
clean:
	$(RM) $(exe) $(objects) $(dependencies) $(assembly)

ifneq "$(MAKECMDGOALS)" "clean"
ifneq "$(MAKECMDGOALS)" "asm"
-include $(dependencies)
endif
endif

%.o: %.cc
	$(CXX) -c $< $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o $@ -MT $@ -MMD -MP -MF $*.d

%.s: %.cc
	$(CXX) -S $< $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -o $@

help:
	@echo "List of available targets:"
	@echo "     all"
	@echo "     clean"
	@echo "     asm"
	@$(foreach prog,$(exe_with_suffix),echo "     $(prog)";)


