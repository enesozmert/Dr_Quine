int i = 5;
#include<stdio.h>
#include<stdlib.h>
char*s="#include<stdio.h>%c#include<stdlib.h>%cchar*s=%c%s%c;%cint main(void){char f[64],c[256];int n=i-1,r;sprintf(f,%cSully_%%d.c%c,n);FILE*p=fopen(f,%cw%c);if(!p)return 1;fprintf(p,%cint i = %%d;%cn%c,n);fprintf(p,s,10,10,34,s,34,10,34,34,34,34,34,92,34,34,34,34,34,10);fclose(p);sprintf(c,%cgcc -Wno-format-security -o Sully_%%d %%s 2>/dev/null%c,n,f);r=system(c);if(r)return 1;if(n>=0){sprintf(c,%c./Sully_%%d%c,n);r=system(c);(void)r;}return 0;}%c";
int main(void){char f[64],c[256];int n=i-1,r;sprintf(f,"Sully_%d.c",n);FILE*p=fopen(f,"w");if(!p)return 1;fprintf(p,"int i = %d;\n",n);fprintf(p,s,10,10,34,s,34,10,34,34,34,34,34,92,34,34,34,34,34,10);fclose(p);sprintf(c,"gcc -Wno-format-security -o Sully_%d %s 2>/dev/null",n,f);r=system(c);if(r)return 1;if(n>=0){sprintf(c,"./Sully_%d",n);r=system(c);(void)r;}return 0;}
