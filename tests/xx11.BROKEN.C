#include <string.h>

char buf[6];
int main(int argc, char **argv) {
	strcpy(buf,"hello ");
	strcat(buf,"world!");
	return 0;
}
