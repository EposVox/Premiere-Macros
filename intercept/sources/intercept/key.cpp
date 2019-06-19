#include "stdafx.h"

#include "key.h"
#include "util.h"

KeyStroke::KeyStroke(std::string serialized)
{
	sscanf(serialized.c_str(), "%hx,%hx,%x", &stroke.code, &stroke.information, &stroke.state);
}

std::string KeyStroke::Serialize(void)
{
	char buf[1024];

	sprintf(buf, "%hx,%hx,%x", stroke.code, stroke.information, stroke.state);

	std::string s(buf);
	return s;
}

KeyStroke::KeyStroke(InterceptionKeyStroke *iks) 
{ 
	memcpy(&stroke, iks, sizeof(InterceptionKeyStroke)); 
}

unsigned short KeyStroke::ToWord(void) {
	short c = stroke.code & 0xff;
	if ( stroke.state & INTERCEPTION_KEY_E0 )
		c |= 0xE000;
	if ( stroke.state & INTERCEPTION_KEY_E1 )
		c |= 0xE100;

	return c;
}

void KeyStroke::Print(void) 
{ 
	char buf[64];

	int code = (stroke.code << 16);
	if (stroke.state & INTERCEPTION_KEY_E0)
		code |= 1 << 24;

	GetKeyNameText(code, buf, 64);

	// Bug in GetKeyNameText()
	if ( ToWord() == 0x0045 )
		strcpy(buf, "Num Lock");

	// Just in case...
	if ( strlen(buf) == 0 )
		sprintf(buf, "%04hX", ToWord());

	printf("[%s]%s ", buf, IsDown() ? "\x19" : "\x18"); 
	fflush(stdout); 
}



KeyCombo::KeyCombo(std::string serialized)
{
	char *s = strdup( serialized.c_str() );

	char *p = strtok(s, "|");
	while (p) {
		std::string str(p);
		KeyStroke k(str);
		Add(k);

		p = strtok(NULL, "|");
	}

	delete s;
}

std::string KeyCombo::Serialize(void)
{
	std::string s;
	s = "";
	for (int i=0; i<Size(); i++) {
		s += Item(i).Serialize();
		if ( i < Size()-1 )
			s += "|";
	}

	return s;
}

void KeyCombo::Add(KeyStroke k)
{
	keylist.push_back(k);
}

void KeyCombo::Read(unsigned short endcode)
{
	Interception in(INTERCEPTION_FILTER_KEY_ALL);

	while (1) {
		in.Wait(10);
		InterceptionKeyStroke *s = in.GetStroke();
		if ( s == NULL )
			continue;

		KeyStroke k(s);

		if ( k.stroke.code == endcode ) {
			if ( k.IsUp() ) 
				break;

			// ignore key down event
		} else {
			Add(k);
			k.Print();
		}
	}
}

void KeyCombo::Print(void)
{
	for (int i=0; i<keylist.size(); i++) {
		keylist[i].Print();
	}
}

void KeyCombo::Send(Interception *in)
{
	if (in == NULL)
		in = new Interception(INTERCEPTION_FILTER_KEY_NONE);

	for (int i=0; i<keylist.size(); i++) {
		in->Send(&(keylist[i].stroke));
	}
}



KeyFilter::KeyFilter(void)
{
	this->device = NULL;
	this->trigger = NULL;
	this->combo = NULL;
	this->label = NULL;
}

KeyFilter::KeyFilter(char *device, KeyStroke *trigger, KeyCombo *combo)
{
	this->device = strdup(device);
	this->trigger = trigger;
	this->combo = combo;
	this->label = NULL;
}

void KeyFilter::LoadFromIniFile(const char *file, const char *label)
{
	char buf[65536];

	GetPrivateProfileStringA(label, "device", NULL, buf, sizeof(buf), file);
	device = strdup(buf);

	GetPrivateProfileStringA(label, "trigger", NULL, buf, sizeof(buf), file);
	std::string t(buf);
	trigger = new KeyStroke(t);

	GetPrivateProfileStringA(label, "combo", NULL, buf, sizeof(buf), file);
	std::string c(buf);
	combo = new KeyCombo(c);

	this->label = strdup(label);
}

void KeyFilter::SaveToIniFile(const char *file, const char *label)
{
	char *l;

	if ( label == NULL )
		l = this->label;

	if ( device ) 
		WritePrivateProfileStringA(l, "device", device, file);
	if ( trigger )
		WritePrivateProfileStringA(l, "trigger", trigger->Serialize().c_str(), file);
	if ( combo )
		WritePrivateProfileStringA(l, "combo", combo->Serialize().c_str(), file);
}

void KeyFilter::Query(void)
{
	// There may be an unprocessed key up event in the queue, trash it
	Interception *in0 = new Interception(INTERCEPTION_FILTER_KEY_DOWN);
	in0->Wait(100);
	in0->GetStroke();
	delete in0;

	printf("\nDefining filter\n\n");
	printf("Press key which will trigger the combo\n\n");

	// There will be key a key down event followed by a key up event. 
	Interception *in = new Interception(INTERCEPTION_FILTER_KEY_ALL);
	in->Wait(INFINITE);
	trigger = new KeyStroke(in->GetStroke()); // safe, it will not time out!
	device = in->GetDeviceNameCopy();

	in->Wait(INFINITE); // wait for key up
	in->GetStroke(); // trash it
	delete in;
	
	Print(0);

	printf("\nEnter combo for this trigger, end with Esc\n");
	printf("(Empty combo will inhibit trigger key)\n\n");
	combo = new KeyCombo();
	combo->Read(0x01); // SCANCODE_ESC

	printf("\n\n");
	this->label = strdup(ReadText("Enter filter label"));

	printf("\n\n");
	Print(1);
	printf("\n");
}

void KeyFilter::Print(int showCombo)
{
	printf("  Trigger key: ");
	trigger->Print();
	printf("\n     Keyboard: %s", device);

	if (showCombo) {
		printf("\n        Combo: ");
		combo->Print();
		printf("\n        Label: [%s]", label);
	}

	printf("\n");
}

int KeyFilter::Match(KeyStroke *stroke, char *source, Interception *in)
{
	if ( (stroke->ToWord() == trigger->ToWord()) && 
		 (stroke->stroke.state == trigger->stroke.state) &&
		 (strcmp(source, device) == 0) ) {
		combo->Send(in);
		return 1;
	} 

	return 0;
}

KeyFilter::~KeyFilter(void)
{
	if ( device ) delete device;
	if ( trigger ) delete trigger;
	if ( combo ) delete combo;
	if ( label ) delete label;
}


KeyFilterSet::KeyFilterSet(const char *file)
{
	char buf[65536];
	this->file = strdup(file);

	GetPrivateProfileSectionNames(buf, sizeof(buf), file);
	char *p = buf;
	while (*p) {
		KeyFilter *kf = new KeyFilter(file, p);
		filters.push_back(kf);

		p = p + strlen(p) + 1;
	}
}

void KeyFilterSet::Print(void)
{
	printf("\n");
	for (int i=0; i<filters.size(); i++) {
		printf("(%d) %s\n", i+1, filters[i]->label);
		//filters[i]->Print(1);
	}
	printf("\n");
}

void KeyFilterSet::Print(int i)
{
	printf("\n");

	if ( i < 0 )
		return ;

	if ( i > filters.size()-1 )
		return;

	filters[i]->Print(1);
	printf("\n");
}

void KeyFilterSet::Delete(int i)
{
	printf("\n");

	if ( i < 0 )
		return ;

	if ( i > filters.size()-1 )
		return;

	// Delete INI stanza
	WritePrivateProfileStruct(filters[i]->label, NULL, NULL, 0, file);

	filters.erase(filters.begin()+i);

	printf("Filter deleted.\n\n");
}

void KeyFilterSet::AddNew(void)
{
	KeyFilter *kf = new KeyFilter();
	kf->Query();

	char buf[32768];
	int ret = GetPrivateProfileSection(kf->label, buf, sizeof(buf), file);
	if ( ret > 0 ) {
		printf("\aFilter with this label already exists!\n");
	} else {
		if ( SelectOption("(S)ave filter or (C)ancel?", "sc") == 's' ) {
			kf->SaveToIniFile(file, NULL);
			filters.push_back(kf);
		}
	}

	printf("\n");
}

int KeyFilterSet::GetFilterNumber(void)
{
	printf("\n");

	int n = atoi(ReadText("Enter filter number or (a)bort"));
	if ( n == 0 ) {
		printf("\a");
		return -1;
	}

	n = n - 1;
	if (( n < 0 ) || ( n > filters.size()-1 )) {
		printf("\a");
		return -1;
	}

	return n;
}

int KeyFilterSet::Match(KeyStroke *stroke, char *source, Interception *in)
{
	for (int i=0; i<filters.size(); i++) {
		int ret = filters[i]->Match(stroke, source, in);
		if ( ret > 0 )
			return i;
	}

	return -1;
}

void KeyFilterSet::Run(void)
{
	printf("\n\nRunning filters...\n\n");
	Interception *in = new Interception(INTERCEPTION_FILTER_KEY_ALL);
	while (1) {
		in->Wait(INFINITE);  // will not time out, so the following is safe
		InterceptionKeyStroke *iks = in->GetStroke();
		KeyStroke k(iks);
		int f = Match(&k, in->GetDeviceName(), in);
		if ( f > -1 ) {
			SYSTEMTIME st;
			GetSystemTime(&st);

			char buf[64];
			sprintf(buf, "%02hd:%02hd:%02hd.%03hd %-60s", 
				st.wHour, st.wMinute, st.wSecond, st.wMilliseconds,
				filters[f]->label);
			printf("%s\r", buf);
			fflush(stdout);
		} else {
			in->Send(iks);
		}
	}
}

