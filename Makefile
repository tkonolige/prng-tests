
practrand: PractRand/RNG_test threefry.py
	@echo "======================================================================================"
	@echo "This test can run indefinitly. Stoppping it after 1 terabyte of data should be enough."
	@echo "======================================================================================"
	python3 threefry.py | PractRand/RNG_test stdin64

sts: sts/sts
	rm -f result.txt
	python3 threefry.py | sts/sts -i 1000 -
	cat result.txt

testu01: TestU01-2009-install/bin/testu01
	python3 threefry.py | TestU01-2009-install/bin/testu01

.PHONY: practrand sts testu01

PractRand/RNG_test:
	./build_practrand.sh

sts/sts:
	$(MAKE) -C sts

TestU01-2009-install/lib/libtestu01.so:
	mkdir -p TestU01-2009-install
	cd TestU01-2009 && ./configure --prefix="${PWD}/TestU01-2009-install" && $(MAKE) && $(MAKE) install

TestU01-2009-install/bin/testu01: TestU01-2009-install/lib/libtestu01.so testu01.c
	gcc -O3 -o $@ -ITestU01-2009-install/include -LTestU01-2009-install/lib testu01.c -lprobdist -lmylib -ltestu01 -lm -Wl,-rpath TestU01-2009-install/lib

lcg:
	g++ -O3 -o $@ $<

.PHONY: practrand-lcg sts-lcg testu01-lcg

sts-lcg: sts/sts lcg
	rm -rf result.txt
	./lcg | sts/sts -i 1000 -
	cat result.txt

practrand-lcg: PractRand/RNG_test lcg
	./lcg | PractRand/RNG_test stdin32

testu01-lcg: TestU01-2009-install/bin/testu01 lcg
	./lcg | TestU01-2009-install/bin/testu01

splitmix: splitmix.hpp splitmix.cc
	g++ -O3 -o $@ splitmix.cc

.PHONY: splitmix-lcg sts-lcg testu01-lcg

sts-splitmix: sts/sts splitmix
	rm -rf result.txt
	./splitmix | sts/sts -i 1000 -
	cat result.txt

practrand-splitmix: PractRand/RNG_test splitmix
	./splitmix | PractRand/RNG_test stdin32

testu01-splitmix: TestU01-2009-install/bin/testu01 splitmix
	./splitmix | TestU01-2009-install/bin/testu01
