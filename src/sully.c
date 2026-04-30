/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sully.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ozmerte <ozmerte@gmail.com>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/05/01 02:20:00 by ozmerte        #+#    #+#                 */
/*   Updated: 2026/05/01 02:20:00 by ozmerte       ###   ########.fr          */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		counter;
	char	filename[256];
	char	*header;
	char	*body;
	char	*footer;
	FILE	*fp;

	counter = 8;
	header = "/* ****************************"
		"****************************** */\n"
		"/*                            "
		"                              */\n"
		"/*                          "
		"  :::      ::::::::   */\n"
		"/*   sully.c                "
		"                :+:      :+:    :+: "
		"   */\n"
		"/*                          "
		"    +:+ +:+         +:+     */\n"
		"/*   By: ozmerte <ozmerte@gm"
		"ail.com>                +#+  +:+ "
		"      +#+        */\n"
		"/*                          "
		"                +#+#+#+#+#+   +#+  "
		"         */\n"
		"/*   Created: 2026/05/01 02:"
		"20:00 by ozmerte        #+#    #+# "
		"                 */\n"
		"/*   Updated: 2026/05/01 02:"
		"20:00 by ozmerte       ###   ###### "
		"##.fr          */\n"
		"/*                          "
		"                              */\n"
		"/* ****************************"
		"****************************** */\n\n";
	body = "#include <stdio.h>\n#include <stdlib.h>\n\nint\tmain(void)\n{\n"
		"\tint\t\tcounter;\n"
		"\tchar\tfilename[256];\n"
		"\tchar\t*header;\n"
		"\tchar\t*body;\n"
		"\tchar\t*footer;\n"
		"\tFILE\t*fp;\n\n"
		"\tcounter = %d;\n"
		"\theader = %c%s%c;\n"
		"\tbody = %c%s%c;\n"
		"\tfooter = %c%s%c;\n"
		"\tif (counter == 0)\n"
		"\t\treturn (0);\n"
		"\tcounter--;\n"
		"\tsprintf(filename, %cSully_%%d.c%c, counter);\n"
		"\tfp = fopen(filename, %cw%c);\n"
		"\tif (fp == NULL)\n"
		"\t\treturn (1);\n"
		"\tfprintf(fp, header);\n"
		"\tfprintf(fp, body, counter, 34, header, 34, 34, body, 34, "
		"34, footer, 34);\n"
		"\tfprintf(fp, footer);\n"
		"\tif (fclose(fp) != 0)\n"
		"\t\treturn (1);\n"
		"\treturn (0);\n}\n";
	footer = "";

	if (counter == 0)
		return (0);
	counter--;
	sprintf(filename, "Sully_%d.c", counter);
	fp = fopen(filename, "w");
	if (fp == NULL)
		return (1);
	fprintf(fp, header);
	fprintf(fp, body, counter, 34, header, 34, 34, body, 34, 34,
		footer, 34);
	fprintf(fp, footer);
	if (fclose(fp) != 0)
		return (1);
	return (0);
}
