int chararg_foo(const char *str)
{
  int i;
  for (i = 0; str[i] != '\0'; i++);

  return i;
}
