# rgbasm -o hello-world.o hello-world.asm; rgblink -o hello-world.gb hello-world.o; rgbfix -v -p 0xff hello-world.gb
.PRECIOUS: %.sym %.map %.tbl
.PHONY = (clean $(PROJECT_NAME) asses objs)
PARENT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

RGBASM = "rgbasm"


RGBASM_ARGS = -I $(PARENT_DIR)/defines -I $(PARENT_DIR)
ASSES_SRC =  $(wildcard */*/*.png) $(wildcard */*/*.map)
ASSES_DST =  $(patsubst %.png,%.2bpp,$(wildcard */*/*.png)) $(patsubst %.map,%.binmap, $(wildcard */*/*.map))
clean:
	rm -vf *.o *.sym *.gb **/*.o **/*.sym **/*.gb
	find . -name '*.2bpp' -delete
	find . -name '*.2bpp.pal' -delete
	find . -name '*.2bpp.tilemap' -delete

%.o: %.gbasm ../hardware.inc
	@echo Compiling $@ from $<
	pwd
	$(RGBASM) $(RGBASM_ARGS) -o $@ $<

%.sym: %.o
	@echo About to output $@ from $<
	rgblink -m $(patsubst %.sym,%.tbl,$@) -n $@ $<

%.gb: %.o %.sym */*.gbasm *.gbasm
	@echo About to output $@
	rgblink -m $(patsubst %.gb,%.map,$@) -o $@ $<
	rgbfix -v -p 0xff $@

%.2bpp: %.png
	rgbgfx -u $< -o $@ -t $@.tilemap -c auto

%.binmap: %.map _utils/build-tilemap.py
	python _utils/build-tilemap.py $< $@

asses: $(ASSES_DST)
	@echo Assets are $(ASSES_DST)
	make $(ASSES_DST)

$(PROJECT_NAME): $(PROJECT_NAME).gb $(PROJECT_NAME).sym
