TJROOT = /Users/nmatsakis/versioned/teyjus/bin/

help:
	@echo "make sim -- run interactively"
	@echo "make test TEST=foo -- run the given test"

.PHONY: all sim
all: main.lp

sim: all
	$(TJROOT)/tjsim main

test: all
	$(TJROOT)/tjsim -s 'test "'${TEST}'".' main

%.lpo : %.mod %.sig
	$(TJROOT)/tjcc $*

%.lp : %.lpo
	$(TJROOT)/tjlink $*

-include depend
depend: *.mod *.sig
	$(TJROOT)/tjdepend *.mod > depend-stage
	mv depend-stage depend

.PHONY: clean
clean:
	rm -f *.lpo *.lp depend
