#include <iostream>
#include <unordered_map>
#include <vector>
#include <random>

int rand0(int64_t& seed) {
  // PRNG
  seed = seed * 48271LL % 2147483647;
  return seed;
}

int rand1(int64_t& seed) {
  // used for PRNG splitting
  seed = seed * 32767LL % 1999999973;
  return seed;
}


int main() {
  freopen(NULL, "wb", stdout);
  std::vector<int64_t> seeds;
  int nthreads=32;
  seeds.push_back(444);
  for(size_t i = 1; i < nthreads; i++) {
    seeds.push_back(rand1(seeds[i-1]));
  }
  while (1) {
    for (size_t i = 0; i < nthreads; i++) {
        int value = rand0(seeds[i]);
        fwrite((void*) &value, sizeof(value), 1, stdout);
    }
  }
}
