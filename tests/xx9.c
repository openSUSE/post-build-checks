#include <unistd.h>
int main(int argc, char **argv) {
	execl("hello","world","!");
	return 0;
}
