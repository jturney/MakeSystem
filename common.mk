include settings.mk/$(CXX).mk
include settings.mk/boost.mk
include settings.mk/gmp.mk

CXXFLAGS += $($(CXX).cxxflags)
LDFLAGS  += $($(CXX).ldflags)
TARGET_ARCH += $($(CXX).target_arch)

ifeq "$(need_debug)" "true"
	CXXFLAGS += $($(CXX).debug)
else
	CXXFLAGS += $($(CXX).optimization)
endif

ifeq "$(need_blas)" "true"
	CXXFLAGS += $($(CXX).blas_cxxflags)
	LIBRARIES += $($(CXX).blas_libraries)
endif

ifeq "$(need_boost)" "true"
	include_dirs += $(boost.include_dirs)
	LIBRARIES += $(boost.libraries)
endif

ifeq "$(need_gmp)" "true"
	include_dirs += $(gmp.include_dirs)
	LIBRARIES += $(gmp.libraries)
endif

CPPFLAGS += $(addprefix -I ,$(sort $(include_dirs)))
vpath %.h $(include_dirs)

define build-program
$1_objects := $(subst .cc,.o,$2)
$1_dependencies := $(subst .cc,.d,$2)
$1_assembly := $(subst .cc,.s,$2)
objects += $$($1_objects)
dependencies += $$($1_dependencies)
assembly += $$($1_assembly)

$1: $$($1_objects)
	$(CXX) $(LDFLAGS) -o $$@ $$^ $(LIBRARIES)
endef

#$(eval $(call build-program,etemplate,$(etemplate_sources)))
$(foreach prog,$(exe),$(eval $(call build-program,$(prog),$($(prog)_sources))))

# Default make target
all: $(exe)

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

