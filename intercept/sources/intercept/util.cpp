#include "stdafx.h"

#include <conio.h>

#include "util.h"

char SelectOption(const char *text, const char *options)
{
	while(1) {
		printf("%s: ", text);
		fflush(stdout);
		int ch = _getche();
		const char *p = options;
		while (*p) {
			if ( tolower(ch) == tolower(*p) ) {
				printf("\n");
				return ch;
			}
			p++;
		}
		printf("\a\n");
	}
}

char label[1024];
char *ReadText(const char *query) 
{
	do {
		printf("%s: ", query);
		fflush(stdout);
		fgets(label, sizeof(label), stdin);
		while ( (label[strlen(label)-1] == '\r') || (label[strlen(label)-1] == '\n') )
			label[strlen(label)-1] = '\0';
	} while (strlen(label) == 0);

	return label;
}

