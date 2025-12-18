# rgbasm -o hello-world.o hello-world.asm; rgblink -o hello-world.gb hello-world.o; rgbfix -v -p 0xff hello-world.gb
.PRECIOUS: %.o %.sym %.map
.PHONY = (clean $(PROJECT_NAME) asses objs)


ASSES_SRC =  $(wildcard */*/*.png) $(wildcard */*/*.map)
ASSES_DST =  $(patsubst %.png,%.2bpp,$(wildcard */*/*.png)) $(patsubst %.map,%.binmap, $(wildcard */*/*.map))
clean:
	rm -f *.o *.sym *.gb

%.o: %.gbasm ../hardware.inc
	@echo Compiling $@ from $<
	rgbasm -o $@ $<

%.sym: %.o
	@echo About to output $@ from $<
	rgblink -m $(patsubst %.sym,%.map,$@) -n $@ $<

%.gb: %.o %.sym */*.gbasm *.gbasm
	@echo About to output $@
	rgblink -o $@ $<
	rgbfix -v -p 0xff $@

%.2bpp: %.png
	rgbgfx -u $< -o $@ -t $@.tilemap -O -P

%.binmap: %.map _utils/build-tilemap.py
	python _utils/build-tilemap.py $< $@

asses: $(ASSES_DST)
	@echo Assets are $(ASSES_DST)
	make $(ASSES_DST)

$(PROJECT_NAME): $(PROJECT_NAME).gb $(PROJECT_NAME).sym
