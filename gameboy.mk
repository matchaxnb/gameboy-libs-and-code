.PRECIOUS: %.sym %.tbl %.o
.PHONY = (clean $(PROJECT_NAME) asses objs)
PARENT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
RGBASM = "rgbasm"
RGBASM_ARGS = -I . -I $(PARENT_DIR)/defines -I $(PARENT_DIR) -I $(PARENT_DIR)/common
clean:
	rm -vf *.o *.sym *.gb **/*.o **/*.sym **/*.gb
	find . -name '*.2bpp' -delete
	find . -name '*.2bpp.pal' -delete
	find . -name '*.2bpp.tilemap' -delete

%.o: %.asm ../hardware.inc
	@echo Compiling $@ from $<
	pwd
	$(RGBASM) $(RGBASM_ARGS) -o $@ $<

%.sym: %.o
	@echo About to output $@ from $<
	rgblink -m $(patsubst %.sym,%.tbl,$@) -n $@ $<

%.gb: %.o %.sym */*.asm *.asm
	@echo About to output $@
	rgblink -m $(patsubst %.gb,%.tbl,$@) -o $@ $<
	rgbfix -v -p 0xff $@

%.2bpp: %.png
	rgbgfx -u $< -o $@ -t $@.tilemap -c auto

%.binmap: %.txtmap _utils/build-tilemap.py
	python ../_utils/build-tilemap.py $< $@


$(PROJECT_NAME): $(PROJECT_NAME).gb $(PROJECT_NAME).sym
