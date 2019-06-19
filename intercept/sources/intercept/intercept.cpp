// intercept.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

#include "key.h"
#include "util.h"

void help(void)
{
	printf("Command line parameters:\n");
	printf("\t/ini path\to\file.ini specify alternate config file (optional)\n");
	printf("\t/apply                non-interactive, apply filters on startup (optional)\n");
}

int _tmain(int argc, _TCHAR* argv[]) {
	printf("\n*** Keyboard Remapper v. 1");
	printf("\n*** Based on Oblitum Interception http://oblita.com/Interception.html\n\n");
	printf("Use /help for help on command-line options\n\n");

	// Set to default, /ini switch will override
	char currDir[1024];
	GetCurrentDirectory(1024, currDir);
	char iniFile[1024];
	sprintf(iniFile, "%s\\keyremap.ini", currDir);

	int mode_apply = 0;
	for (int i=0; i<argc; i++) {
		if ( (stricmp(argv[i], "/help") == 0) || (stricmp(argv[i], "/?") == 0) ) {
			help();
			return 1;
		}

		if (stricmp(argv[i], "/apply") == 0)
			mode_apply = 1;

		if (stricmp(argv[i], "/ini") == 0) {
			// Missing parameter
			if ( i == argc-1 )
				help();

			strcpy(iniFile, argv[i+1]);
			i++;
		}
	}

	printf("Using configuration file %s\n\n", iniFile);
	KeyFilterSet kfs(iniFile);

	if ( mode_apply )
		goto apply;

	while(1) {
		char c = SelectOption("(L)ist filters, (S)how/(A)dd/(R)emove filter, appl(Y) filters or (Q)uit?", "lsaryq");
		switch (c) {
		case 'l':
			kfs.Print();
			break;

		case 's':
			kfs.Print(kfs.GetFilterNumber());
			break;

		case 'q':
			if (SelectOption("(R)eally quit, or (G)o back?", "rg") == 'r')
				return 0;
			break;

		case 'a':
			kfs.AddNew();
			break;

		case 'r':
			kfs.Delete(kfs.GetFilterNumber());
			break;

		case 'y':
			goto apply;
			break;
		}
	}

apply:
	printf("\n\nKeyboard filters activated.");
	printf("\nPlease close this window to restore normal behavior.");
	printf("\nTo activate filters on startup, add /apply to the command line.\n");
	kfs.Run();

	// not reached
	return 0;
}

