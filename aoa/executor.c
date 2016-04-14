#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

static inline unsigned char xtoupper(unsigned char c)
{
  if (!((c >= 'a') && (c <= 'z')))
    return c;
  return ~(1 << 5) & c;
}

static inline unsigned char xtolower(unsigned char c)
{
  if (!((c >= 'A') && (c <= 'Z')))
    return c;
  return (1 << 5) | c;
}

int str2int(const char *s)
{
  bool sign = false;
  int sum = 0;

  if (*s == '-') {
      sign = true;
      s++;
  }

  while (s) {
      if (!((*s >= '0' && *s <= '9')))
        break;
      sum *= 10;
      sum += (~0x30 & *s);

      s++;
  };

  if (sign)
    sum *= -1;
  return sum;
}

uint16_t pack_date(int day, int month, int year)
{
  /* data organization:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     D |D |D |D |D |M |M |M |M |Y |Y |Y |Y |Y |Y |Y
   */
  uint16_t pack = 0;

  /* pack day - 5 bits */
  /* mask:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |1 |1 |1 |1 |1
         0x0    |    0x0    |    0x1    |    0xf
   */
  pack |= ((day & 0x001f) << 11);
  /* After masking:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |D |D |D |D |D

     Now it has to shifted 11 bits righ, bit 4 becomes 15 and so on.

     After shift we get:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     D |D |D |D |D |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0
   */

  /* pack month - 4 bits */
  /* mask:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |1 |1 |1 |1
        0x0     |    0x0    |    0x0    |   0xf
   */
  pack |= ((month & 0x000f) << 7);
  /*
     After masking:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |0 |M |M |M |M

     Now it has to shifted 7 bits righ, bit 3 becomes 10 and so on.

     After shift we get:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     D |D |D |D |D |M |M |M |M |0 |0 |0 |0 |0 |0 |0
   */

  /* pach year - 7 bits */
  /* Adjust full year in order to fit 7 bits. How to do it?
     Let assume only year we can store are:
     * 0-99 corresponds to 1900-1999
     * 100-126 corresponds to 2000-2026.
     * 127 - all bits are high over/underflow
     This is enough for exercise purpose.

     Algorithm is simple:
     if (year >= 1900) and (year <=1999) then
       year := year MOD 100
     else if (year >= 2000) and (year <= 2026) then
       year := (year MOD 100) + 100
     else
       year = 127
   */
  if ((year >= 1900) && (year <= 1999))
    year %= 100;
  else if ((year >= 2000) && (year <= 2026)) {
    year %= 100;
    year += 100;
  }
  else
    year = 127;

  /* mask: don't need mask here
   */
  pack |= year;
  /*
     Don't need shift here.

     After or we get:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     D |D |D |D |D |M |M |M |M |Y |Y |Y |Y |Y |Y |Y

     or:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     D |D |D |D |D |M |M |M |M |1 |1 |1 |1 |1 |1 |1

     in case of fail.
   */

  return pack;
}

static inline int extract_day(uint16_t date)
{
  return (date >> 11);
}

static inline int extract_month(uint16_t date)
{
  return (date >> 7) & 0x000f;
}

static inline int extract_year(uint16_t date)
{
  /* mask for last 7 bits:
     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
     0 |0 |0 |0 |0 |0 |0 |0 |0 |1 |1 |1 |1 |1 |1 |1
         0x0    |    0x0    |    0x7    |    0xf
   */
  int year = date & 0x007f;

  if ((year >= 0) && (year <= 1999))
    year += 1900;
  else if ((year >= 100) && (year <= 126)) {
    year %= 100;
    year += 2000;
  }

  return year;
}

int cnt_one_bit_16(uint16_t data)
{
  int i, ones;

  ones = 0;
  for (i = 0; i < 16; i++)
    if ((data << i) & 0x8000) /* 0x8000 = 1000 0000 0000 0000b */
      ones++;

  return ones;
}

int test_bit_16(uint16_t data, uint16_t pos)
{
}

#define TEST(exp) \
do { \
  if (exp) \
    printf("%s PASSED\n", #exp); \
  else \
    printf("%s FAILED\n", #exp); \
} while (0)

int main(int argc, char *argv[])
{
  TEST(xtoupper('e') == 'E');
  TEST(xtoupper('*') == '*');

  TEST(xtolower('R') == 'r');
  TEST(xtolower('$') == '$');

  TEST(str2int("1234") == 1234);
  TEST(str2int("1000") == 1000);
  TEST(str2int("-456") == -456);
  TEST(str2int("-9842dea") == -9842);

  /* Test date is: 07.12.1980:
     day = 7 = 0011 1b = 0x7
     month = 12 = 110 0b = 0xc
     year = 80 = 101 0000b = 50h

     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
          day      |   month   |      year
     0 |0 |1 |1 |1 |1 |1 |0 |0 |1 |0 |1 |0 |0 |0 |0
         0x3    |   0xe     |   0x5     |   0x0
   */
  TEST(pack_date(7, 12, 1980) == 0x3e50);

  TEST(extract_day(0x3e50) == 7);
  TEST(extract_month(0x3e50) == 12);
  TEST(extract_year(0x3e50) == 1980);

  /* Test date is: 11.04.2016:
     day = 11 = 0101 1b = Bh
     mont = 4 = 010 0b = 4h
     year = 116 = 111 0100b = F4h

     15|14|13|12|11|10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0
          day      |   month   |      year
     0 |1 |0 |1 |1 |0 |1 |0 |0 |1 |1 |1 |0 |1 |0 |0
         0x5    |   0xa     |   0x7     |   0x4
   */
  TEST(pack_date(11, 4, 2016) == 0x5a74);

  TEST(extract_day(0x5a74) == 11);
  TEST(extract_month(0x5a74) == 4);
  TEST(extract_year(0x5a74) == 2016);

  /* Test data:
   * 4971h = 0100 1001 0111 0001b ~ 7 "ones"
   */
  TEST(cnt_one_bit_16(0x4971) == 7);

  /* Test data:
   * 0x0 ~ no "ones"
   */
  TEST(cnt_one_bit_16(0x0) == 0);

  /* Test data:
   * 0xffff = 1111 1111 1111 1111b
   */
  TEST(cnt_one_bit_16(0xffff) == 16);

  return EXIT_SUCCESS;
}
