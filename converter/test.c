
#include "../libc/stdio.h"

int main() {
  FILE* yes = fopen("Workspace/Value","w");
  const char* text = "123";
  fwrite(text, 1, 3, yes);
  return 65;
}
