#include "../libc/assert.h"
int main() {
	int x;

	x = 1000000;
	while (x)
		x = x - 1;
	return x;
}
