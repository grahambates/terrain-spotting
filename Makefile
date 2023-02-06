PROG=terrain-spotting
TIC=/Applications/tic80.app/Contents/MacOS/tic80
TICOPTS=--skip
PAK=pakettic
TICTOOL=tic-tool
ALG=dlas
LEVEL=5
TARGET=256
PAKOPTS=-z$(LEVEL) -a$(ALG) -p --target-size=$(TARGET)

dist: $(PROG).tic

run:
	$(TIC) $(TICOPTS) $(PROG).lua

run-dist:
	$(TIC) $(TICOPTS) $(PROG).tic

analyze:
	$(TICTOOL) analyze $(PROG).tic


$(PROG).tic: $(PROG).lua
	$(PAK) $(PAKOPTS) $< -o $@

clean:
	$(RM) $(PROG).tic

.PHONY: run dist run-dist clean
