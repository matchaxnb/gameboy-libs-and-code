.PRECIOUS: %.obj %.tbl %.sym
TOP_LEVEL_DIR   := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
rwildcard       =   $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
ASM             :=  rgbasm
LINKER          :=  rgblink
FIX             :=  rgbfix
BUILD_DIR       :=  build
COMMON_DIR		:=  common
PROJECT_NAME    ?=  
OUTPUT          :=  $(BUILD_DIR)/$(PROJECT_NAME)
SRC_DIR         :=  src
CONF_DIR		:=  config
INC_ARGS        :=  -I $(TOP_LEVEL_DIR)/common -I .
SRC_ASM         :=  $(call rwildcard, $(SRC_DIR)/, *.asm)
FW_ASM			:= $(call rwildcard, $(TOP_LEVEL_DIR)/$(COMMON_DIR)/framework, *.asm)
OBJ_FILES       :=  $(addprefix $(BUILD_DIR)/obj/, $(SRC_ASM:src/%.asm=%.obj))
#FW_OBJ_FILES    :=  $(addprefix $(BUILD_DIR)/fw-obj/, $(FW_ASM:$(TOP_LEVEL_DIR)/common/framework/%.asm=%.obj))
OBJ_DIRS        :=  $(addprefix $(BUILD_DIR)/obj/, $(dir $(SRC_ASM:src/%.asm=%.obj)))
#FW_OBJ_DIRS     :=  $(addprefix $(BUILD_DIR)/fw-obj/, $(dir $(FW_ASM:$(TOP_LEVEL_DIR)/common/framework/%.asm=%.obj)))
ASMFLAGS        :=  -p0 -v  $(INC_ARGS) -P defines/hardware.inc -P defines/palettes.inc -P $(CONF_DIR)/config.asm -P framework/_all.asm
#LINKERFLAGS     :=  -m $(OUTPUT).tbl -n $(OUTPUT).sym -l $(CONF_DIR)/layout.rgblink -d
LINKERFLAGS     :=  -m $(OUTPUT).tbl -n $(OUTPUT).sym -d
FIXFLAGS        :=  -v -p0xff
ASSETS_SRC =  $(wildcard */*/*.png) $(wildcard */*/*.map)
ASSETS_DST =  $(patsubst %.png,%.2bpp,$(wildcard */*/*.png)) $(patsubst %.map,%.binmap, $(wildcard */*/*.map))



.PHONY: all clean asses show default

default: clean all
show:
	@echo "Fw obj dirs is $(FW_OBJ_DIRS)"
	@echo "Obj dirs is $(OBJ_DIRS)"
	@echo "Fw obj files is $(FW_OBJ_FILES)"
	@echo "obj files is $(OBJ_FILES)"

all: asses $(OUTPUT).gb
    
$(OUTPUT).gb: $(BUILD_DIR) asses
	$(FIX) $(FIXFLAGS) $(OUTPUT).gb

$(BUILD_DIR): $(OBJ_FILES)
	$(LINKER) -o $(OUTPUT).gb $(LINKERFLAGS) $(OBJ_FILES) 

#$(BUILD_DIR)/fw-obj/%.obj : $(TOP_LEVEL_DIR)/common/framework/%.asm | $(FW_OBJ_DIRS)
#	$(ASM) -o $@  $(ASMFLAGS) $<

$(BUILD_DIR)/obj/%.obj : src/%.asm $(OBJ_DIRS)
	$(ASM) -o $@ $(ASMFLAGS) $<

$(OBJ_DIRS):
	mkdir -p $@

#$(FW_OBJ_DIRS):
#	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR)

asses: $(ASSETS_DST)
	test ! "$(ASSETS_DST)" = " " && make $(ASSETS_DST) > /dev/null || exit 0

print-%  : ; @echo $* = $($*)