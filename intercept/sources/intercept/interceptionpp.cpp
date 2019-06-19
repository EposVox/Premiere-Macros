#include "interceptionpp.h"

#include "stdafx.h"

Interception::Interception(InterceptionFilter filter)
{
	context = interception_create_context();
	if ( context == 0 ) {
		MessageBox(NULL, "Oblitum Interception driver not loaded!", NULL, MB_OK | MB_ICONERROR);
		ExitProcess(1);
	}

	interception_set_filter(context, interception_is_keyboard, filter);
}

int Interception::Wait(unsigned long milliseconds)
{
	device = interception_wait_with_timeout(context, milliseconds);
	return device; /* will return 0 on timeout */
}

InterceptionKeyStroke *Interception::GetStroke(void) 
{ 
	if ( device < 1 ) 
		return NULL;

	int rx = interception_receive(context, device, &stroke, 1);
	if ( rx ) 
		return (InterceptionKeyStroke*) &stroke; 
	else
		return NULL;
}

InterceptionKeyStroke *Interception::GetStrokeCopy(void)
{
	InterceptionKeyStroke *buf = GetStroke();
	if ( buf == NULL )
		return NULL;

	InterceptionKeyStroke *newbuf = new InterceptionKeyStroke;
	memcpy(newbuf, buf, sizeof(InterceptionKeyStroke));
	return newbuf;
}

char *Interception::GetDeviceName(void)
{
	wchar_t hardware_id[500];

	size_t length = interception_get_hardware_id(context, device, hardware_id, sizeof(hardware_id));
	if(length > 0 && length < sizeof(hardware_id)) {
		wcstombs(deviceName, hardware_id, 4096);
		return deviceName;
	}

	return NULL;
}

char *Interception::GetDeviceNameCopy(void)
{
	char *s = GetDeviceName();
	return s ? strdup(s) : NULL;
}

void Interception::Send(const InterceptionKeyStroke *keystroke) {
	interception_send(context, device, (InterceptionStroke*) keystroke, 1);
}

/* Modified interception */
#if 0

#define CODE_LSHIFT		0x002A
#define CODE_LCTRL		0x001D
#define CODE_LALT		0x0038
#define CODE_RSHIFT		0x0036
#define CODE_RCTRL		0xE01D
#define CODE_RALT		0xE038

#define FLAG_LSHIFT		0x01
#define FLAG_LCTRL		0x02
#define FLAG_LALT		0x04
#define FLAG_RSHIFT		0x08
#define FLAG_RCTRL		0x10
#define FLAG_RALT		0x20

class ModifiedInterception : public Interception {
public:
	ModifiedInterception(void) : Interception(INTERCEPTION_FILTER_KEY_ALL) {};
	unsigned int GetModifiedStroke(void);
};

unsigned int ModifiedInterception::GetModifiedStroke(void)
{
	int flags = 0;
	int code = 0;
	int finish = 0;

	while (1) {
		Wait(10);
		InterceptionKeyStroke *s = GetStroke();
		if ( s == NULL ) {

			continue;
		}

		if ( IsKeyUp(s) ) {
			switch (ToWordCode(s)) {
				case CODE_LSHIFT: flags &= ~FLAG_LSHIFT; break;
				case CODE_RSHIFT: flags &= ~FLAG_RSHIFT; break;
				case CODE_LCTRL: flags &= ~FLAG_LCTRL; break;
				case CODE_RCTRL: flags &= ~FLAG_RCTRL; break;
				case CODE_LALT: flags &= ~FLAG_LALT; break;
				case CODE_RALT: flags &= ~FLAG_RALT; break;
				default: finish = 1; break;
			}
		}

		if ( IsKeyDown(s) ) {
			switch (ToWordCode(s)) {
				case CODE_LSHIFT: flags |= FLAG_LSHIFT; break;
				case CODE_RSHIFT: flags |= FLAG_RSHIFT; break;
				case CODE_LCTRL: flags |= FLAG_LCTRL; break;
				case CODE_RCTRL: flags |= FLAG_RCTRL; break;
				case CODE_LALT: flags |= FLAG_LALT; break;
				case CODE_RALT: flags |= FLAG_RALT; break;
				default:
					code = flags << 24;
					code = code | ToWordCode(s);
					break;
			}
		}

		/* All keys released */
		if (( flags == 0 ) && ( finish == 1 ) )
			return code;
	}
}

#endif 
