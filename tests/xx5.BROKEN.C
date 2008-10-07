#include <unistd.h>
int main(int argc, char **argv) {
	setuid(42);
	return 0;
}

