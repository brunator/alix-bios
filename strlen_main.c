/* Compile with: gcc -m32 -Wall -g0 -O0 -c -o strlen_main.o strlen_main.c
 * Link with: gcc -m32 -Wall -o strlen_main strlen_lib.o strlen_main.o
 */
#include <stdio.h>
#include "strlen_lib.h"

int
main(int argc, char *argv[])
{
  const char *text = "Aaaaa bbb ccccc dddd!\n";
  int tsize;

  tsize = strlen_asm(text);
  printf("strlen_asm(\"Aaaaa bbb ccccc dddd!\") = %d\n", tsize);

  return 0;
}
