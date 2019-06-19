#pragma once

#include "interception.h"

class Interception {
	InterceptionContext context;
	InterceptionDevice device;
	InterceptionStroke stroke;
	char deviceName[4096];

public:
	Interception(InterceptionFilter filter);
	int Wait(unsigned long milliseconds);
	int TimedOut(void) { return ( device == 0 ) ? 1 : 0; };

	//InterceptionDevice getDevice(void) { return device; };
	InterceptionKeyStroke *GetStroke(void);
	InterceptionKeyStroke *GetStrokeCopy(void);
	//int GetModifiedStroke(void);
	char *GetDeviceName(void);
	char *GetDeviceNameCopy(void);
	void Send(const InterceptionKeyStroke *keystroke);
	virtual ~Interception(void) { interception_destroy_context(context); };
};

