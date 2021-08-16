
practrand: PractRand/RNG_test threefry.py
	@echo "======================================================================================"
	@echo "This test can run indefinitly. Stoppping it after 1 terabyte of data should be enough."
	@echo "======================================================================================"
	python3 threefry.py | PractRand/RNG_test stdin64

sts: sts/sts
	rm -f result.txt
	python3 threefry.py | sts/sts -i 1000 -
	cat result.txt

.PHONY: practrand sts

PractRand/RNG_test:
	./build_practrand.sh

sts/sts:
	$(MAKE) -C sts

TestU01-2009-install/lib/libtestu01.so:
	mkdir -p TestU01-2009-install
	cd TestU01-2009 && ./configure --prefix="${PWD}/TestU01-2009-install" && $(MAKE) && $(MAKE) install

TestU01-2009-install/bin/testu01: TestU01-2009-install/lib/libtestu01.so testu01.c
	gcc -O3 -o $@ -ITestU01-2009-install/include -LTestU01-2009-install/lib testu01.c -lprobdist -lmylib -ltestu01 -lm -Wl,-rpath TestU01-2009-install/lib
