/*outside*/
#include<stdio.h>
void f(void){}
char*s="/*outside*/%c#include<stdio.h>%cvoid f(void){}%cchar*s=%c%s%c;%cint main(void){f();/*inside*/printf(s,10,10,10,34,s,34,10,10);return 0;}%c";
int main(void){f();/*inside*/printf(s,10,10,10,34,s,34,10,10);return 0;}
