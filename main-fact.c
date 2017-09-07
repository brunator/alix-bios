#include <stdio.h>
#include "factorial.h"

int
main(int argc, char *argv[])
{
  int fact;

  fact = factorial_foo(4);

  printf("fact = %d\n", fact);

  return 0;
}
