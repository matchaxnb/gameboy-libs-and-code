TOP_LEVEL_DIR   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

rwildcard       =   $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))


ALL_MAKEFILE_DIRS	:=  $(shell find -mindepth 2 -type f -name 'Makefile' -printf '%h\n' | sed 's@^[.]/@@g')

.PHONY: all $(ALL_MAKEFILE_DIRS) 


all: 
	@echo "Makefiles detected: $(ALL_MAKEFILE_DIRS)"
	$(foreach d,$(ALL_MAKEFILE_DIRS),$(MAKE) -C $(d) ;) true