#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int	main(void)
{
	int		i = 5;
	int		ret;
	char	file[64];
	char	cmd[256];
	FILE	*fp;
	char	*s = "#include <stdio.h>%1$c#include <stdlib.h>%1$c#include <unistd.h>%1$c%1$cint%5$cmain(void)%1$c{%1$c%5$cint%5$c%5$ci = %4$d;%1$c%5$cint%5$c%5$cret;%1$c%5$cchar%5$cfile[64];%1$c%5$cchar%5$ccmd[256];%1$c%5$cFILE%5$c*fp;%1$c%5$cchar%5$c*s = %2$c%3$s%2$c;%1$c%1$c%5$cif (i < 0)%1$c%5$c%5$creturn (0);%1$c%5$csprintf(file, %2$cSully_%%d.c%2$c, i);%1$c%5$cif (access(file, F_OK) == 0)%1$c%5$c%5$ci--;%1$c%5$cif (i < 0)%1$c%5$c%5$creturn (0);%1$c%5$csprintf(file, %2$cSully_%%d.c%2$c, i);%1$c%5$cfp = fopen(file, %2$cw%2$c);%1$c%5$cif (!fp)%1$c%5$c%5$creturn (1);%1$c%5$cfprintf(fp, s, 10, 34, s, i, 9);%1$c%5$cfclose(fp);%1$c%5$csprintf(cmd, %2$cgcc -Wall -Wextra -Werror -Wno-format-security -o Sully_%%d %%s%2$c, i, file);%1$c%5$cif (system(cmd) != 0)%1$c%5$c%5$creturn (1);%1$c%5$csprintf(cmd, %2$c./Sully_%%d%2$c, i);%1$c%5$cret = system(cmd);%1$c%5$c(void)ret;%1$c%5$creturn (0);%1$c}%1$c";

	if (i < 0)
		return (0);
	sprintf(file, "Sully_%d.c", i);
	if (access(file, F_OK) == 0)
		i--;
	if (i < 0)
		return (0);
	sprintf(file, "Sully_%d.c", i);
	fp = fopen(file, "w");
	if (!fp)
		return (1);
	fprintf(fp, s, 10, 34, s, i, 9);
	fclose(fp);
	sprintf(cmd, "gcc -Wall -Wextra -Werror -Wno-format-security -o Sully_%d %s", i, file);
	if (system(cmd) != 0)
		return (1);
	sprintf(cmd, "./Sully_%d", i);
	ret = system(cmd);
	(void)ret;
	return (0);
}
