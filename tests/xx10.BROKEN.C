#include <string.h>

char buf[10];
int main(int argc, char **argv) {
	strcpy(buf,argv[0]);
	strncat(buf,"world!",sizeof(buf));
	return 0;
}
