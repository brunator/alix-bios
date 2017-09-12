#include <unistd.h>
#include <stdlib.h>

char data[] = "dupa 1234!\n";

int
main(int argc, char *argv[])
{
  write(1, data, sizeof(data));

  exit(0);
}

