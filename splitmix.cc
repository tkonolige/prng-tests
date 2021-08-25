#include "splitmix.hpp"
#include <iostream>
#include <unordered_map>
#include <vector>
#include <random>

int main() {
  freopen(NULL, "wb", stdout);
  std::vector<splitmix32> rands;
  int nthreads=32;
  rands.push_back(splitmix32());
  for(size_t i = 1; i < nthreads; i++) {
    rands.push_back(rands[i-1].split());
  }
  while (1) {
    for (size_t i = 0; i < nthreads; i++) {
        int value = rands[i]();
        fwrite((void*) &value, sizeof(value), 1, stdout);
    }
  }
}
