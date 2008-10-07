#include <stdlib.h>
char *buf;
int main(int argc, char **argv) {
	buf = malloc(29);
	realloc (buf, 30);
	return 0;
}
