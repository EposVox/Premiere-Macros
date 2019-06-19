#pragma once

#include "interceptionpp.h"

class KeyStroke {
public:
	InterceptionKeyStroke stroke;

	KeyStroke(InterceptionKeyStroke *iks);
	KeyStroke(std::string serialized);
	std::string Serialize(void);
	unsigned short KeyStroke::ToWord(void);
	int IsDown(void) { return ((stroke.state & INTERCEPTION_KEY_UP) == 0) ? 1 : 0; };
	int IsUp(void) { return ((stroke.state & INTERCEPTION_KEY_UP) == 1) ? 1 : 0; };
	void ToDown(void) { stroke.state &= ~INTERCEPTION_KEY_UP; };
	void Print(void);
};

class KeyCombo {
	std::vector<KeyStroke> keylist;

public:
	KeyCombo(void) { };
	KeyCombo(std::string serialized);
	std::string Serialize(void);
	void Add(KeyStroke k);
	int Size(void) { return keylist.size(); };
	KeyStroke Item(int i) { return keylist[i]; };
	void Read(unsigned short endcode);
	void Print(void);
	void Send(Interception *in=NULL);
};

class KeyFilter {
	char *device;
	KeyStroke *trigger;
	KeyCombo *combo;

public:
	KeyFilter(void);
	KeyFilter(const char *file, const char *label) { LoadFromIniFile(file, label); };
	KeyFilter(char *device, KeyStroke *trigger, KeyCombo *combo);
	void Query(void);
	void Print(int showCombo);
	void LoadFromIniFile(const char *file, const char *label);
	void SaveToIniFile(const char *file, const char *label);
	int Match(KeyStroke *stroke, char *source, Interception *in);
	virtual ~KeyFilter(void);

	char *label;
};

class KeyFilterSet {
	char *file;
	std::vector<KeyFilter*> filters;

public:
	KeyFilterSet(const char *file);
	void Print(void);
	void Print(int i);
	void Delete(int i);
	void AddNew(void);
	int GetFilterNumber(void);
	int Match(KeyStroke *stroke, char *source, Interception *in);
	void Run(void);
};

