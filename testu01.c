#include "TestU01.h"
#include <stdint.h>

uint32_t stdin_gen() {
  // read input in chunks for performance
  static uint32_t buffer[1024*1024];
  static int i = 0;
  if(i == 0) {
    fread(buffer, sizeof(uint32_t), 1024*1024, stdin);
  }
  uint32_t x = buffer[i];
  i = (i + 1) % (1024*1024);
  return x;
}

int main() {
  // Reopen stdin in binary mode
  freopen(NULL, "rb", stdin);

  unif01_Gen* gen = unif01_CreateExternGenBits("Threefry (stdin)", stdin_gen);

  // Run the tests.
  bbattery_SmallCrush(gen);

  // Clean up.
  unif01_DeleteExternGenBits(gen);

  return 0;
}
