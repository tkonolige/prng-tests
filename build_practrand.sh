mkdir -p PractRand
cd PractRand
curl -OL https://downloads.sourceforge.net/project/pracrand/PractRand-pre0.95.zip
unzip -q PractRand-pre0.95.zip
rm PractRand-pre0.95.zip
g++ -std=c++14 -c src/*.cpp src/RNGs/*.cpp src/RNGs/other/*.cpp -O3 -Iinclude -pthread
ar rcs libPractRand.a *.o
rm *.o
g++ -std=c++14 -o RNG_test tools/RNG_test.cpp libPractRand.a -O3 -Iinclude -pthread
