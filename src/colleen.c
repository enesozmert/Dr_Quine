/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   colleen.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ozmerte <ozmerte@gmail.com>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/05/01 02:10:00 by ozmerte        #+#    #+#                 */
/*   Updated: 2026/05/01 02:10:00 by ozmerte       ###   ########.fr          */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

int	main(void)
{
	char	*header;
	char	*body;
	char	*footer;

	header = "/* ****************************"
		"****************************** */\n"
		"/*                            "
		"                              */\n"
		"/*                          "
		"  :::      ::::::::   */\n"
		"/*   colleen.c              "
		"              :+:      :+:    :+: "
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
		"10:00 by ozmerte        #+#    #+# "
		"                 */\n"
		"/*   Updated: 2026/05/01 02:"
		"10:00 by ozmerte       ###   ###### "
		"##.fr          */\n"
		"/*                          "
		"                              */\n"
		"/* ****************************"
		"****************************** */\n\n";
	body = "#include <stdio.h>\n\nint\tmain(void)\n{\n"
		"\tchar\t*header;\n"
		"\tchar\t*body;\n"
		"\tchar\t*footer;\n\n"
		"\theader = %c%s%c;\n"
		"\tbody = %c%s%c;\n"
		"\tfooter = %c%s%c;\n\n"
		"\tprintf(header);\n"
		"\tprintf(body, 34, header, 34, 34, body, 34, 34, footer, 34);\n"
		"\tprintf(footer);\n"
		"\treturn (0);\n}\n";
	footer = "";

	printf(header);
	printf(body, 34, header, 34, 34, body, 34, 34, footer, 34);
	printf(footer);
	return (0);
}
