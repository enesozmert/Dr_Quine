#include<stdio.h>
#define A "Grace_kid.c"
#define B FILE*p=fopen(A,"w");
#define C(s) int main(void){B fprintf(p,s,10,34,34,10,34,34,10,10,10,34,s,34,10);fclose(p);return 0;}
/*Grace*/
C("#include<stdio.h>%c#define A %cGrace_kid.c%c%c#define B FILE*p=fopen(A,%cw%c);%c#define C(s) int main(void){B fprintf(p,s,10,34,34,10,34,34,10,10,10,34,s,34,10);fclose(p);return 0;}%c/*Grace*/%cC(%c%s%c)%c")
