#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetWorkingDir F:\Documents\PremiereMods\support_files\
; the above is what the variable %A_WorkingDir% refers to.

Menu, Tray, Icon, shell32.dll, 283 ; this changes the tray icon to a little keyboard!
#SingleInstance force ;only one instance of this script may run at a time!
;_______________________________________________________________________________________________________________________
;                                                                                                                       
; NOTE: In autohotkey, the following special characters (usually) represent modifier keys:
; # is the WIN key. (it can mean other things though, as you can see above.)
; ^ is CTRL
; ! is ALT
; + is SHIFT
; list of other keys: http://www.autohotkey.com/docs/Hotkeys.htm
; 
; 
;RELEVANT SHORTCUTS I HAVE ASSIGNED IN PREMIERE'S BUILT IN KEYBOARD SHORTCUTS MENU
; KEYS                    PREMIERE FUNCTIONS
;---------------------------------------------------------------------------------
; u                     select clip at playhead. Probably this should be moved to a different series of keystrokes, so that "u" is freed for something else.
; backspace             ripple delete --- but I don't use that in AutoHotKey because it's dangerous. This should be changed to something else; I use SHIFT C now.
; shift c               ripple delete --- very convenient for left handed use. Premiere's poor track targeting makes ripple delete less useful than it could be.
; ctrl alt shift d      ripple delete --- I never type this in manually - long shortcuts like this are great for using AHK or a macro to press them.
; delete                delete
; c                     delete --- I also have this on "C" because it puts it directly under my left hand. Very quick to press without having to move my hand.
; ctrl r                speed/duration panel
; shift 1               toggle track targeting for AUDIO LAYER 1
; shift 2               toggle track targeting for AUDIO LAYER 2. And so on up to 8.
; alt 1                 toggle track targeting for VIDEO LAYER 1
; alt 2                 toggle track targeting for VIDEO LAYER 2. And so on up to 8. I wish there were DEDICATED shortcuts to enable and disable ALL layers
; ctrl p                toggle "selection follows playhead"
; ctrl alt shift 0      Application > Window > Timeline (This key CANNOT be easily reassigned in my PR2017 due to a bug.) (Default is SHIFT 3)
; ctrl alt shift `      Application > Window > Project  (This sets the focus onto a BIN.) (default is SHIFT 1)
; ctrl alt shift 1      Application > Window > Project  (This sets the focus onto a BIN.) (default is SHIFT 1)
; ctrl alt shift 4      Application > Window > program monitor (Default is SHIFT 4)
; ctrl alt shift 7      Application > Window > Effects   (NOT the Effect Controls panel) (Default is SHIFT 7) --- The defaults are stupid. SHIFT 7 is an ampersand if you happen to be in a text box somewhere...
; F2                    gain
; F3                    audio channels --- To be pressed manually by the suer. (this might change in the future.)
; ctrl alt shift a      audio channels --- (I will NOT change this, so that it can always be reliably triggered using AutoHotKey.)
; shift F               From source monitor, match frame.
; ctrl /                Overwrite (default is "." (period))
; ctrl b                select find box --- This is such a useful function when you pair it the the effects panel!!
; ctrl alt F            select find box 
;                                                                                                                        
; Be aware that sometimes other programs like PUUSH can overlap/conflict with your customized shortcuts.                          
;_______________________________________________________________________________________________________________________



;defining some variables below:

savedpreset1 = 100scale
savedpreset2 = 2.4 limiter

applicationname=SecondKeyboardd
statusy = 1850
; statusy = 1700
statusx = 30
statusheight = 80
statusheight2 = 110
statuswidth=500
statuswidth2=700
font=Arial

;++++++++++++++++++++++++++++++++++++++++++++++
; GUI FOR KEYBOARD 1 COMMANDS
Gui,+Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow
Gui,Margin,0,0
Gui,Color,222222
Gui,Font,C00FFFF S27 W200 Q5, Arial
Gui,Add,Text,Vtextt,KEY GOES HERE WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW WWWWWWWWW WWWWWWWWWWW
Gui,Font,c44FF55 S20 W990 norm, Arial
Gui,Add,Text,Vnamee,THE TYPE OF FUNCTIONand the SELECTION WWWWWWWWWWWWWWWWWWWWWWWWWW WWWWWWWWW WWWWWWWWWWW
Gui,Font,cEE6622 S20 W300 norm, Arial
Gui,Add,Text,Vkeyb,1st KEYBOARD IT BE WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW WWWWWWWWWW WWWWWWWWWW

Winset, ExStyle, +0x20, %applicationname%
Gui +E0x20 +LastFound +ToolWindow +disabled

Gui,Show,X%statusx% Y%statusy% W%statuswidth% H%statusheight% noactivate ,%applicationname%

GuiControl,,textt, testing visualizer

;WinSet, Transparent, N ; SecondKeyboardd
WinSet, Transparent, 255
WinSet, ExStyle, +0x00000020, ahk_id %hwnd%
WinSet, TransColor, 111111


;+++++++++++++++++++++++++++++++++++++++++++++++
; GUI FOR KEYBOARD 2 COMMANDS
Gui KB2: New
Gui KB2: +Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow
Gui KB2: Margin,0,0
Gui KB2: Color,000000
Gui KB2: Font,CFF0000 S15 W500 Q5, Franklin Gothic
Gui KB2: Add,Text,Vline1,gui 2 is HEEEERRRREEE WWWWWWWWWWWWWWWWWWWWWWW WWWWWW WWWW
Gui KB2: Font,CFFFF00 S20 W200 Q5, Arial
Gui KB2: Add,Text,Vline2,gui 2 line twwwwoooooo WWWWWWWWWWWWWW WWWWWWW WWWWWWWWWWW
Gui KB2: Font,CFF00FF S20 W200 Q5, Arial
Gui KB2: Add,Text,Vline3,gui 2 line 33333333333333333333 - WWWWWWWWW WWWWW WWWWWWW

Gui KB2: Show,X%statusx% Y%statusy% W%statuswidth2% H%statusheight2% noactivate ,%applicationname%

GuiControl,,line1, 2ND KEYBOARD
GuiControl,,line2, line 2 on gui 2
GuiControl,,line3, line 3 on gui 2

SetTimer,revealtimer,-2500
SetTimer,revealtimer2,-2500


prFocus(panel) ;this function allows you to have ONE spot where you define your personal shortcuts that "focus" panels in premiere.
{
;panel := """" . panel . """" ;this adds quotation marks around the parameter so that it works as a string, not a variable.
;Send ^!+1 ;bring focus to a random bin, in order to "clear" the current focus on any and all bins
Send ^!+7 ;bring focus to the effects panel, in order to "clear" the current focus on the MAIN monitor
if (panel = "effects")
	goto theEnd ;Send ^!+7 ;do nothing. the shortcut has already been pressed.
else if (panel = "timeline")
	Send ^!+0 ;if focus had already been on the timeline, this would have switched to the next sequence in some arbitrary order.
else if (panel = "program")
	Send ^!+4
else if (panel = "project") ;AKA a "bin" or "folder"
	Send ^!+1
; else if (panel = "effect controls")
	; you can continue adding any panels you might need, here.
theEnd:

}
;end of focusing panel

#ifwinactive
Keyshower(yeah, functionused := "", alwaysshow := 0) ;very badass function that shows key presses and associated commands, both from the primary and secondary keyboards (keyboard 2 must be configured using intercept.exe!)
{
;msgbox, keyshower
;the "NA" is extremely important to allow this window to be VISIBLE but not interfere with anything.
;msgbox, %A_priorhotkey% %A_thishotkey%


if (A_priorhotkey = "F23" || A_priorhotkey = "~numpadleft" || A_priorhotkey = "~numpadright") ;please pretend that numpad left and right are not here....
	{
	;this was sent from the 2nd keyboard, using interceptor. Interceptor presses F23, then the key, then releases the key, then releases F23. Very simple, but very effective.
	Gui, kb2: show, NA 
	Gui, hide
	;msgbox,,,what is hapening,1
	GuiControl kb2:,line1, %A_space%FROM 2ND KEYBOARD
	GuiControl kb2:,line2, %A_space%%A_thishotkey%
	GuiControl kb2:,line3, %A_space%%functionused%(`"%yeah%`")
	SetTimer,revealtimer2,-2000
	;msgbox, , , testing now, 1
	}
else if (A_priorhotkey = "F22")
	{
		;this space reserved for keyboard 3! ... and so on.
	}
else if (alwaysshow = 1)
	{
	
	;This space can be used for any keys that the normal visualizer does not notice. please ignore for now...
	Gui, show, NA 
	Gui, kb2: hide
	StringReplace, fixedHotkey, A_thishotkey, ^, ctrl%A_space%, All
	StringReplace, fixedHotkey, fixedHotkey, +, shift%A_space%, All
	StringReplace, fixedHotkey, fixedHotkey, !, alt%A_space%, All
	GuiControl,,textt, %A_space%%fixedHotkey% ;%A_priorhotkey%
	GuiControl,,namee, %functionused%(`"%yeah%`")
	GuiControl,,keyb, 
	SetTimer,revealtimer,-2000
	
	}
else
	{
	;there is no "modifier" key or anything else associated. Therefore, this was a single keypress sent from the primary keyboard.
	;do nothing. This visualization is taken care of by keystroke viz.ahk
	}

}



revealkey(selectionn, keyy, functionn) ;this funciton is now obsolete...
{
;now
;msgbox, revealkey %keyy% %selectionn%
Gui,Show, 
GuiControl,,textt, %keyy%
GuiControl,,namee, %functionn%  (%selectionn%)
GuiControl,,keyb, second keyboard
SetTimer,revealtimer,-1500
}

revealtimer:
Gui, hide
return

revealtimer2:
Gui, kb2: hide
Return

;++++++++++++++++++++++++GUI stuff end.+++++++++++++++++++++++++++++



;cut out lua macros bs

;remove tool tips!
RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return 

;;;;;;temporary tooltip maker;;;;;;
Tippy(tipsHere, wait:=333)
{
ToolTip, %tipsHere%,,,8
SetTimer, noTip, %wait% ;--in 1/3 seconds by default, remove the tooltip
}
noTip:
	ToolTip,,,,8
	;removes the tooltip
return
;;;;;;/temporary tooltip maker;;;;;;



;function to start, then activate any given application
openApp(theClass, theEXE, theTitle := ""){
Keyshower(theEXE, "openApp") ;leads to a function that shows the keypresses onscreen
IfWinNotExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	{
	WinActivate %theClass%
	;WinGetTitle, Title, A
	WinRestore %theTitle%
	}
}



#IfWinActive ahk_exe Adobe Premiere Pro.exe ;---EVERYTHING BELOW THIS LINE WILL ONLY WORK INSIDE PREMIERE PRO! (until canceled with a lone "#IfWinActive")




;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;THIS IS A VERY SIMPLE FUNCTION FOR JUST TYPING STUFF INTO THE SEARCH BAR
;but it doesn't apply them to the clips.

effectsPanelType(item := "lol")
{
Keyshower(item,"effectsPanelType")
;prFocus("effects") ;reliably brings focus to the effects panel
Send ^+!7 ;CTRL SHIFT ALT 7 -- set in premiere to "effects" panel
sleep 10
Send ^b ;CTRL B --set in premiere to "select find box"
sleep 20
Send +{backspace} ;shift backspace deletes any text that may be present.
Sleep, 10
Send %item%
;now this next part re-selects the field in case you want to type anything different
sleep 5
send {tab}
sleep 5
send +{tab}
}


;removed his own presets thing

#IfWinActive

;;;;more premiere mods / macros.;;;;;;;;

;F1 -> [select clip at playhead] and then [ripple delete] . Note the keyboard shortcuts I have assigned in Premiere, above.
;ripple delete clip (or blank) at playhead - requires target tracking to be ON!!
;Note also that this always selects ALL TARGETED TRACKS, so I usually just use it for cutting single-track A-roll.
;It is possible to have it select ONLY the top layer by toggling on and off "selection follows playhead."
#IfWinActive ahk_exe Adobe Premiere Pro.exe
~F1::Send u^+!d
;#if

; control shift r = reverse selected clip
;~^+r::
;Send ^r{tab}{tab}{space}{enter}
;return

;This disables a menu accelerator in premiere, ignoring the pressing of ALT along with SPACE. Otherwise it will open a dumb menu on the top bar, which I never use.
; !space::
; Send {space}
; Return

;Just kidding, I want to use alt space to rewind and then play. Premiere's version of this SUCKS because it brings you back to where you started
; the ~ is only there so that the keystroke visualizer can see this keypress. Otherwise, it should not be used.
;~!space::
;Send s ;"stop" command (From JKL remapped to ASD.)
;Send +{left}
;sleep 10
;Send d ;"shuttle right" command.
;return


; ;~sc11C::
; ~numpadEnter::
; ;this is the scancode for the numpad enter key.
; ;keystroke viz.ahk does not properly notice this key (always combining it the regular Enter) so I am making a visualizer for it here.
; Keyshower("program monitor zoom to fit - taran mod",,1)

; return


;deleted mousemove sfx


;you can select something inside of premiere (like a group of clips, or a transition) and then, with this code, you can COPY it and SAVE that clipboard state. I use this in conjunction with my secondary keyboard.
;You need to have insideclipboard.exe installed, and all the file paths properly comfigured.
;Keep in mind that you must RESTART your computer before the clipboard states become usable. IDK why.
#ifwinactive ahk_exe Adobe Premiere Pro.exe
saveClipboard(int) {
	StringReplace, int, int, +, , All ;replace + with nothing. This is just in case A_thishotkey contains + if shift was used!
	StringReplace, int, int, !, , All ;replace ! with nothing. This is just in case A_thishotkey contains ! if alt was used!
	StringReplace, int, int, ^, , All ;replace ^ with nothing. This is just in case A_thishotkey contains ^ if ctrl was used!
	;msgbox, , , saving as %int%, 0.6
	tooltip, saving as`n"clip" . %int% . ".clp"
	sleep 10
	SendInput, {Shift Down}{Shift Up}{Ctrl Down}{c Down}
	sleep 20
	ClipWait, 0.25 ; this line might not be needed.
	SendInput, {c up}{Ctrl up}
	sleep 20
	saveToFile("clip" . int . ".clp")
	sleep 1000
	saveToFile("clip" . int . ".clp")
	tooltip,
}

;This is the real magic. With this script, you can PASTE those previously saved clipboard states, at any time.
#ifwinactive ahk_exe Adobe Premiere Pro.exe
recallClipboard(int, transition := 0) {
	;deactivate keyboard and mouse
	keyShower(int, "recallClipboard")
	WinActivate, Adobe Premiere Pro
	prFocus("timeline")
	;Send ^!d ;this is to deselect any clips that might be selected in the timeline.
	;tooltip, "now loading random text into the clipboard."
	loadFromFile("clipTEXT.clp") ;to create this file, just highlight some plain text, copy it, and use insideclipboard.exe to save it as clipTEXT.clp. The clipboard MUST have some text inside; it CANNOT be completely empty. This has the effect of DELETING all the aspects of the clipboard, EXCEPT for text.
	sleep 15
	; ; WinActivate, Adobe Premiere Pro ;IDK if this is needed here.
	; ; loadFromFile("clipTEXT.clp") ;The clipboard must be loaded twice, or it won't work about 70% of the time! I don't know why...
	; ; sleep 15
	;Autohotkey can now delete that string of text, so that no text is accidentlaly pasted into premiere. It doesn't seem to be able to delete EVERYTHING, so the above code is definitely necessary!
	clipboard = 
	;The clipboard is now completely empty.
	sleep 10
	
	;tooltip, now pasting NOTHING into premiere....
	WinActivate, Adobe Premiere Pro ;extremely important to ensure you are still active/focused on Premiere
	SendInput, {Shift Down}{Shift Up}
	sleep 10
	SendInput, {Ctrl Down}{v Down} ;this is a MUCH more robust way of using the keyboard shortcuts to PASTE, rather than just using "Send ^v"
	sleep 5
	SendInput, {v Up}{Ctrl Up}
	sleep 20
	
	;It is necessary to PASTE this COMPLETELY BLANK clipboard into premiere, or Premiere won't "know" that the clipboard has been completely emptied.
	;If you don't do this, Premiere will just use whatever thing you had previously copied inside of Premiere.
	clipboard = 
	;the above line is another method for clearing the clipboard that must also be done to ensure a totally empty clipboard
	sleep 30
	;tooltip, "clip" . %int% . ".clp" ;this code doesn't work
	;tooltip, now preparing to paste %int%
	;msgbox, %int%
	WinActivate, Adobe Premiere Pro 
	loadFromFile("clip" . int . ".clp") ;now we are loading the previously saved clipboard file!
	sleep 15
	; ; loadFromFile("clip" . int . ".clp") ;This must be done twice, or it doesn't work! I don't know why!! :D ;ADENDUM - i tried it with only 1 load and NOW it IS working??? IDK why
	; ; sleep 15
	WinActivate, Adobe Premiere Pro ;this is extremely important.... otherwise, it will try to paste into the command prompt or something. You must ensure the correct program is pasted into.
	
	if (transition = 0)
	{
		target("v1", "off", "all", 5) ;this will disable all video layers, and enable only layer 5.
		;Send +{F16} ;this will soon be linked to the target() function.
		tooltip, only layer 5 was turned on should be
		sleep 150
		
	}
	tooltip, now PASTING into premiere...
	WinActivate, Adobe Premiere Pro
	SendInput, {Shift Down}{Shift Up}{Ctrl Down}{v Down}
	sleep 5
	SendInput, {v Up}{Ctrl Up}
	sleep 10
	
	;the below code doesn't work very well.
	; sleep 100
	;If (transition = 1){
	; ;now if we want an accurate label colorwe have to DELETE what we just did, since none of the label colors will be correct due to a premiere bug.
	; ;tooltip,,,gonna delete now,1
	; tooltip,gonna delete now
	; WinActivate, Adobe Premiere Pro
	; prFocus("timeline")
	; WinActivate, Adobe Premiere Pro
	; SendInput, +{delete} ;ripple delete
	; sleep 100
	
	; ;now to paste again, now that the label colors have been loaded.
	; ;REDO might also work. must test that.
	; WinActivate, Adobe Premiere Pro
	; prFocus("timeline")
	; sleep 30
	; SendInput, {Shift Down}{Shift Up}{Ctrl Down}{v Down}
	; ClipWait, 0.50
	; SendInput, {v Up}{Ctrl Up}
	; sleep 10
	;}
	
	
	if (transition = 0)
		target("v1", "on", "all")
	sleep 10
	; send ^{F9} ;toggle video tracks (hopefully off)
	; send ^+{F9} ;toggle audio tracks (hopefully off)
	tooltip,
	Send ^!d ;this is to deselect any clips that might be selected in the timeline.
	
} ;end of recall Clipboard()

#ifwinactive ;everything below this line can happen in any application!

;;script to TARGET or UNTARGET any arbitrary track
F16::
tooltip all video tracks ON
target("v1", "on", "all")
return
^F16::target("v1", "off", "all")
+F16::target("v1", "off", "all", 5)



Target(v1orA1, onOff, allNoneSolo := 0, numberr := 0)
{
;tooltip, now in TARGET function
; BlockInput, on
; BlockInput, MouseMove
; MouseGetPos xPosCursor, yPosCursor
prFocus("timeline") ;brings focus to the timeline.
wrenchMarkerX := 400
wrenchMarkerY := 800 ;the upper left corner for where to begin searching for the timeline WRENCH and MARKER icons -- the only unique and reliable visual i can use for coordinates.
targetdistance := 98 ;Distance from the edge of the marker Wrench to the left edge of the track targeting graphics
CoordMode Pixel ;, screen  ; IDK why, but it only works like this...
CoordMode Mouse, screen
;tooltip, starting
ImageSearch, xTime, yTime, wrenchMarkerX, wrenchMarkerY, wrenchMarkerX+600, wrenchMarkerY+1000, %A_WorkingDir%\timelineUniqueLocator2.png
if ErrorLevel = 0
	{
	;MouseMove, xTime, yTime, 0
	;tooltip, where u at son. y %ytime% and x %xtime%
	;do nothing. continue on.
	xTime := xTime - targetdistance
	;MouseMove, xTime, yTime, 0
	}
else
	{
	tooltip, fail
	goto resetTrackTargeter
	}
;tooltip, continuing...


ImageSearch, FoundX, FoundY, xTime, yTime, xTime+100, yTime+1000, %A_WorkingDir%\%v1orA1%_unlocked_targeted_alone.png
if ErrorLevel = 1
	ImageSearch, FoundX, FoundY, xTime, yTime, xTime+100, yTime+1000, %A_WorkingDir%\%v1orA1%_locked_targeted_alone.png
if ErrorLevel = 2
	{
	tippy("TARGETED v1 not found")
	goto trackIsUntargeted
	}
if ErrorLevel = 3
	{
	tippy("Could not conduct the TARGETED v1 search!")
	goto resetTrackTargeter
	}
if ErrorLevel = 0
	{
	;MouseMove, FoundX, FoundY, 0
	;tooltip, where is the cursor naow 1,,,2
	;tippy("a TARGETED track 1 was found.")
	if (v1orA1 = "v1")
		{
		send +9 ;command in premiere to "toggle ALL video track targeting."
		sleep 10
		if (onOff = "on")
			{
			;tippy("turning ON")
			send +9 ; do it again to TARGET everything.
			}
		sleep 10
		if (numberr > 0)
			Send +%numberr%
		}
	else if (v1orA1 = "a1")
		{
		send !9 ;command in premiere to "toggle ALL audio track targeting."
		sleep 10
		if (onOff = "on")
			send !9 ; do it again to TARGET everything.
		sleep 10
		if (numberr > 0)
			Send !%numberr%
		}
	goto resetTrackTargeter
	}


trackIsUntargeted:
;tooltip, track is untargeted,,,2
if ErrorLevel = 1
	ImageSearch, FoundX, FoundY, xTime, yTime, xTime+100, yTime+1000, %A_WorkingDir%\%v1orA1%_locked_untargeted_alone.png
if ErrorLevel = 1
	ImageSearch, FoundX, FoundY, xTime, yTime, xTime+100, yTime+1000, %A_WorkingDir%\%v1orA1%_unlocked_untargeted_alone.png
if ErrorLevel = 0
	{
	;MouseMove, FoundX, FoundY, 0
	;tippy("an UNTARGETED track 1 was found.")
	;tooltip, where is the cursor naow,,,2
	
	if (v1orA1 = "v1")
		{
		send +9 ;command in premiere to "toggle ALL video track targets." This should TARGET everything.
		sleep 10
		if (onOff = "off")
			send +9 ; do it again to UNTARGET everything.
		sleep 10
		if (numberr > 0)
			Send +%numberr%
		}
	if (v1orA1 = "a1")
		{
		send !9 ;command in premiere to "toggle ALL audio track targets." This should TARGET everything.
		sleep 10
		if (onOff = "off")
			send !9 ; do it again to UNTARGET everything.
		sleep 10
		if (numberr > 0)
			Send !%numberr%
		}
	goto resetTrackTargeter
	}

resetTrackTargeter:
; MouseMove, xPosCursor, yPosCursor, 0
; blockinput, off
; blockinput, MouseMoveOff
;sleep 1000
tooltip,
tooltip,,,,2
sleep 10
}
;END of TRACK TARGETER






saveToFile(name) {
	;code below does not use any fancy variables. It's a bare string. Unfortunately, I can't find a way to make it work better...
	;change this path ----|                  																 and this one --------|    to your own folder locations.
	;    	              |																										  |
	;                     v																									  	  v
	RunWait, %comspec% /c F:\Documents\PremiereMods\support_files\InsideClipboard\InsideClipboard.exe /saveclp %name%, F:\Documents\PremiereMods\support_files\clipboards\
	
	
	;just saving the below lines of code, which didn't work because %pathh% nor %Exec% variables could not be defined properly. Or something... IDK....
	;RunWait, %comspec% /c %Exec% /saveclp %name%, c:\Users\TaranWORK\Downloads\Taran extra keyboards\insideclipboard\clipboards\
	;RunWait, %comspec% /c %Exec% /saveclp %name%, %pathh%
	
}

loadFromFile(name) {
	; You'll need to change these paths too!
	RunWait, %comspec% /c F:\Documents\PremiereMods\support_files\InsideClipboard\InsideClipboard.exe /loadclp %name%, F:\Documents\PremiereMods\support_files\clipboards\
}


#ifwinactive
; ===========================================================================
; https://autohotkey.com/board/topic/7129-run-a-program-or-switch-to-an-already-running-instance/
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;       MS Outlook might have multiple windows open (main window and email
;       windows).  This parm allows activating a specific window.
; ===========================================================================
RunOrActivate(Target, WinTitle = "")
{
	; Get the filename without a path
	SplitPath, Target, TargetNameOnly

	Process, Exist, %TargetNameOnly%
	If ErrorLevel > 0
		PID = %ErrorLevel%
	Else
		Run, %Target%, , , PID

	; At least one app (Seapine TestTrack wouldn't always become the active
	; window after using Run), so we always force a window activate.
	; Activate by title if given, otherwise use PID.
	If WinTitle <> 
	{
		SetTitleMatchMode, 2
		WinWait, %WinTitle%, , 3
		;TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
		WinActivate, %WinTitle%
	}
	Else
	{
		WinWait, ahk_pid %PID%, , 3
		;TrayTip, , Activating PID %PID% (%TargetNameOnly%)
		WinActivate, ahk_pid %PID%
	}


	SetTimer, RunOrActivateTrayTipOff, 1500
}

; Turn off the tray tip
RunOrActivateTrayTipOff:
	SetTimer, RunOrActivateTrayTipOff, off
	TrayTip
Return

; Example uses...
;#b::RunOrActivate("C:\Program Files\Seapine\TestTrack Pro\TestTrack Pro Client.exe")




#ifwinactive ;everything below this line can happen in any application!
runexplorer(foo){
run, %foo%
keyShower(foo, "runExplorer")
; run, % foo ;the problem with this is that sometims the window is highlighted red in the app tray, but it doesn't actually open itself...
; explorerpath:= "explorer " foo
; Run, %explorerpath% ;the problem here is that it opens a new window instead of switching to the old one...

;RunOrActivate(foo) ;this thing just acts super slowly and horribly.... jeeezz...
}


;obsolete... i THINK???
SendKey(theKEY, fun := "", sometext := ""){
;msgbox sendkey has recieved %lols%
keyShower(sometext, fun)
; keyShower(theKEY, fun, sometext)
Sendinput {%theKEY%}
}



#IfWinActive

!F2::
openApp("ahk_class ConsoleWindowClass", "F:\Documents\Premiere Mods\intercept\intercept.exe")
openApp("ahk_class ConsoleWindowClass", "intercept.exe")
sleep 100
;send y
return





;VK27  SC04D  == numpad right (shift numpad6)
;VK66  SC04D  == numpad 6
;VK25  04B	 == numpad left
;VK64  04B	 == numpad 4



; #if GetKeyState("F9") && GetKeyState("F23") ;experimental stuff, just ignore it.
; numpad6::msgbox, lol
; F24::msgbox, lel
; shift::msgbox, lal
; right::msgbox, right
; #if





;_______________________2ND KEYBOARD IF USING INTERCEPTOR_____________________



;#if (getKeyState("F23", "P")) && IfWinActive ahk_exe Adobe Premiere Pro.exe ;have not tested this to see if it works
;#if (getKeyState("F23", "P")) && (uselayer = 0) ;;you can also use a varibable like so.
#if (getKeyState("F23", "P"))

F23::return ;F23 is the dedicated 2nd keyboard "modifier key." You MUST allow it to "return," and cannot use it for anything else.


;I converted the numpad "5" button on the 2nd keyboard into a SHIFT.... by using intercept.
;it works pretty well, BUT I don't reccomend it. Use CTRL instead. if you use shift, the names of the keys change.
;for example, it's not "+numpad6", it's actually "numpadright" instead. But some programs just interpret this as a normal "right." It's dumb.


~numpadLeft::Keyshower("Nudge clip Left 5 frames")
;~VK25::Keyshower(A_thishotkey, "nudge clip right 5 frames") ;----virtual keys are okay... scancodes might be better, if you want the physical KEY itself, unchanged by chift or numlock.
;~VK27::Keyshower(A_thishotkey, "nudge clip left? 5 frames")
~numpadRight::Keyshower("nudge clip RIGHT 5 frames")


~numpadEnd::Keyshower("add marker color 1 (taran mod)")
~numpadclear::Keyshower("add marker color 2 (taran mod)") ;intercept converts this one from numlock into a harmless numpad5.
~+numpadmult::Keyshower("add marker color 3 (taran mod)")
~numpadpgdn::Keyshower("add marker color 4 (taran mod)")
~numpadhome::Keyshower("add marker color 5 (taran mod)")
~+numpaddiv::Keyshower("add marker color 6 (taran mod)")
~numpadins::Keyshower("add marker color 7 (taran mod)")
~numpadpgup::Keyshower("add marker color 8 (taran mod)")




escape::msgbox,,, you pressed escape. this might cause like problems maybe, 0.9

;C:\ProgramData\NVIDIA Corporation\GeForce Experience\Update ;location to disable GFEv3

;+F1::
+F2:: ;you may not use spaces for filenames of sounds that you want to retreive in this way... since searching in premiere will disregard spaces in a a weird way... returning multiple wrong results....
+F3::
+F4::
+F5::
+F6::
+F7::
+F9::
+F8::
+F10::
+F11::saveClipboard(A_thishotkey)

;F1::
F2:: ;you may not use spaces for filenames of sounds that you want to retreive in this way... since searching in premiere will disregard spaces in a a weird way... returning multiple wrong results....
F3::
F4::
F5::
F6::
F7::
F9::
F8::
F10::
F11::recallClipboard(A_thishotkey)

; F12 is not used here if it is the keyboard's launching key. You MAY put it here if you used F13 to F24 as the launching key

;;;;;next line;;;;;;;;

+`::
+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+0::
+-::
+=::
+backspace::saveClipboard(A_thishotkey)

`::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
-::
=::
backspace::recallClipboard(A_thishotkey)

;;;;;next line;;;;;;;;
+tab::saveClipboard(A_thishotkey)
tab::recallClipboard(A_thishotkey)

;This was the old code, before I realized I can just use A_thishotkey and assign all of them at once!!
; q::recallClipboard("q")
; w::recallClipboard("w")
; e::recallClipboard("e")
q::
w::
e::
r::
t::recallClipboard(A_thishotkey)

+q::
+w::
+e::
+r::
+t::saveClipboard(A_thishotkey)

y::
u::
i::
o::
p::
[::
]::recallClipboard(A_thishotkey)
;;;\:: isn't working ; "full reset mod" that I still have not programmed....

+y::
+u::
+i::
+o::
+p::
+[::
+]::saveClipboard(A_thishotkey)
;;; +\:: doesn't wanna work

;;;;;next line;;;;;;;;

capslock::
a::
s::
d::
f::
g::recallClipboard(A_thishotkey)

+capslock::
+a::
+s::
+d::
+f::
+g::saveClipboard(A_thishotkey)


h::
j::
k::
l::
`;::
'::
enter::recallClipboard(A_thishotkey)

+h::
+j::
+k::
+l::
+`;::
+'::
+enter::saveClipboard(A_thishotkey)

;;;;;next line;;;;;;;;

Lshift::return ;msgbox, , ,you pressed Left shift - you should never see this message if you let it pass normally, 5
;now I use it as a modifier for some of the other numpad keys.
z::
x::
c::
v::
b::
n::
m::
,::
.::recallClipboard(A_thishotkey)
;/:: doesn't wanna work

+z::
+x::
+c::
+v::
+b::
+n::
+m::
+,::
+.::saveClipboard(A_thishotkey)
;+/:: doesn't wanna work

;;;;;next area;;;;;;;;

;None of these modifiers should even happen, I have allowed modifiers to pass through normally.
Lctrl::msgbox LEFT ctrl
Lwin::msgbox LEFT win
Lalt::msgbox LEFT alt

space::tippy("2nd space") ;change this to EXCLUSIVE "play" only?

Ralt::msgbox Ralt - doesnt work
Rwin::msgbox Right Win - doesnt work
Rshift::msgbox RIGHT SHIFT lol

SC062::runexplorer("Z:\Linus\10. Ad Assets & Integrations\~CANNED PRE ROLLS")
Rctrl::runexplorer("Z:\Linus\10. Ad Assets & Integrations\~INTEGRATIONS")
appskey::msgbox, this is the right click appskey KEY I guess

PrintScreen::
tooltip, opening resources folder
runexplorer("\\192.168.1.26\Active Projects\Video & Graphics Resources")
SetTimer, RemoveToolTip, 5000
Return
ScrollLock::
runexplorer("\\192.168.1.26\Edit Bae\Video & Graphics Resources\Thumbnails")
tooltip, opening thumbnails folder ;;this doesn't work! ScrlLock is SC061 for some reason
Return
SC061:: ;;so this is actually scroll lock...
tooltip, opening Thumbnails folder
runexplorer("\\192.168.1.26\Active Projects\Video & Graphics Resources\Thumbnails")
SetTimer, RemoveToolTip, 5000
Return

CtrlBreak::
tooltip, opening record folder
runexplorer("D:\Record")
SetTimer, RemoveToolTip, 5000
pause::
tooltip, opening record folder
runexplorer("D:\Record")
SetTimer, RemoveToolTip, 5000
Break::
tooltip, opening record folder
runexplorer("D:\Record")
SetTimer, RemoveToolTip, 5000
NumLock:: ;THIS IS ACTUALLY PAUSEBREAK FOR MY 2ND KEYBOARD
tooltip, opening record folder
runexplorer("D:\Record")
SetTimer, RemoveToolTip, 5000
Return

insert::
tooltip, opening active projects folder
runexplorer("\\192.168.1.26\Active Projects\Active Projects")
SetTimer, RemoveToolTip, 5000
Return
home::
tooltip, opening finished projects folder
runexplorer("\\192.168.1.26\Active Projects\Finished Projects")
SetTimer, RemoveToolTip, 5000
Return
pgup::
tooltip, opening video scrap folder
runexplorer("\\192.168.1.26\Active Projects\SCRAP")
SetTimer, RemoveToolTip, 5000
Return

delete::
tooltip, opening downloads folder
runexplorer("F:\Downloads")
SetTimer, RemoveToolTip, 5000
Return
end::
tooltip, opening documents folder
runexplorer("F:\Documents")
SetTimer, RemoveToolTip, 5000
Return
pgdn::
tooltip, opening pictures folder
runexplorer("F:\Pictures")
SetTimer, RemoveToolTip, 5000
Return

;calculator up arrow
up::Run, C:\Windows\System32\calc.exe

;obs down arrow
down::Run, obs64.exe, C:\Program Files (x86)\obs-studio\bin\64bit

;run directory opus left arro
left::Run, C:\Program Files\GPSoftware\Directory Opus\dopus.exe

;google keep right arrow
right::Run, "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  "--profile-directory=Default" "--app-id=hmjkmjkepdijhoojdojkdfohbdgmmhki"

;;;;;next area;;;;;;;;



/*
;These are now unused - I realized that keeping them as modifiers (allowing them to pass through normally) is more valuable then as single keys.
SC060::msgbox sc060, which I have assigned from LEFT SHIFT using intercept.exe
SC061::msgbox sc061, right shift
SC062::msgbox sc062, L CTRL
SC063::msgbox sc063, L WIN
SC064::msgbox sc064, L ALT
*/
SC065::msgbox sc065, R ALT
SC066::msgbox sc066, R WIN
SC067::msgbox sc067, R CTRL
SC045::msgbox sc045... num lock but actually pause/break?????
SC07F::msgbox sc7F is as high as I could go, after 80 they become unusable for some reason.
SC080::msgbox sc080... this does not register.
SC0FF::msgbox sc0FF ...this does not register.

#if
#IfWinActive


;--------------END OF 2ND KEYBOARD IF USING INTERCEPTOR~~~~~~~~~~~~~~~~~~~~~

;deleted third keyboard


#IfWinActive
 

#IfWinActive ahk_exe Adobe Premiere Pro.exe

;audioMonoMaker() will open the Audio Channels box, and use the cursor to put both tracks on [left/right], turning stereo sound into mono (with the [right/right] track as the source.
audioMonoMaker(track)
{
CoordMode,Mouse,Screen
CoordMode,pixel,Screen
;SetTitleMatchMode, 2
;DetectHiddenWindows, On

BlockInput, SendAndMouse ;prevent mouse from moving
BlockInput, On
BlockInput, MouseMove


Keyshower(track,"audioMonoMaker")

global tToggle = 1
;msgbox, track is %track%
if (track = "right")
{
	;msgbox, this is for the RIGHT audio track. As usual, your number will be smaller, since I have 150% UI scaling enabled.
	addPixels = 36
}
else if (track = "left")
{
	addPixels = 0
	;msgbox, this is for the LEFT audio track
}
Send ^!+a ;control alt shift a --- ; audio channels shortcut, asigned in premiere - dont use this key combo anywhere else
; fun fact, if you send this keystroke AGAIN, it does NOT close the panel, which is great... that means you can press the button anytime, and it will always result in an open panel.
sleep 15

;this doesn't work, the panel thinks its loaded even before any controls appear on it.
; WinWaitActive, Modify Clip, OS_ViewContainer, 3 ;waits 3 seconds. ;ahk_class #32770 is the audio channels panel, according to window spy.
; if ErrorLevel
; {
    ; tooltip, WinWait timed out.
	; tooltip, no color found, go to ending
	; goto, ending
; }
; else
; {
	; msgbox,,, window was found maybe, 0.1

; }

MouseGetPos, xPosAudio, yPosAudio

;/*
MouseMove, 2222, 1625, 0 ;moved the mouse onto the expected location of the "okay" box, which has a distinct white color when the cursor is over it, which will let us know the panel has appeared.

; msgbox where am i, cursor says
MouseGetPos, MouseX, MouseY

waiting = 0
loop
	{
	waiting ++
	sleep 50
	tooltip, waiting = %waiting%`npixel color = %thecolor%
	MouseGetPos, MouseX, MouseY
	PixelGetColor, thecolor, MouseX, MouseY, RGB
	if (thecolor = "0xE8E8E8")
		{
		tooltip, COLOR WAS FOUND
		;msgbox, COLOR WAS FOUND 
		break
		}
		
	if (waiting > 10)
		{
		tooltip, no color found, go to ending
		goto, ending
		}
	}
	
	
;*/
CoordMode, Mouse, Client
CoordMode, Pixel, Client

MouseMove, 160 + addPixels, 288, 0 ;this is relative to the audio channels window itself. Again, you should reduce these numbers by like 33%...?, since i use 150% UI scaling.
;msgbox, now we should be on a check box
sleep 50

MouseGetPos, Xkolor, Ykolor
sleep 50
PixelGetColor, kolor, %Xkolor%, %Ykolor%
;msgbox, % kolor
; INFORMATION:
; 2b2b2b or 464646 = color of empty box
; cdcdcd = color when cursor is over the box
; 9a9a9a = color when cursor NOT over the box
; note that these colors will be different depending on your UI brightness set in premiere.
; For me, the default brightness of all panels is 313131 and/or 2B2B2B

;msgbox, kolor = %kolor%
If (kolor = "0x1d1d1d" || kolor = "0x333333") ; This is the color of an EMPTY checkbox. The coordinates hsould NOT lead to a position where the grey of the checkmark would be. Also, "kolor" is the variable name rather than "color" because "color" might be already used for something else in AHK.
{
	;msgbox, box is empty
	; click left
	;sendinput, LButton
	MouseClick, left, , , 1
	sleep 10
}
else if (kolor = "0xb9b9b9") ;We are now looking for CHECK MARKS. This coordinate, should be directly on top of the box, but NOT directly on top of the GRAY checkmark itself. You need to detect telltale WHITE color that means the box has been checked.
{
	; Do nothing. There was a checkmark in this box already.
}
sleep 5
MouseMove, 160 + addPixels, 321, 0
sleep 30
MouseGetPos, Xkolor2, Ykolor2
sleep 10
PixelGetColor, k2, %Xkolor2%, %Ykolor2%
sleep 30
;msgbox, k2 = %k2%
If (k2 = "0x1d1d1d" || k2 = "0x333333") ;both of these are potential dark grey background panel colors
{
	;msgbox, box is empty. i should click
	; click left
	;sendinput, LButton
	MouseClick, left, , , 1
	sleep 10
	;msgbox, did clicking happen?
}
else if (k2 = "0xb9b9b9")
{
	; Do nothing. There was a checkmark in this box already
}
;msgbox, k2 color was %k2%
sleep 5
Send {enter}
ending:
CoordMode, Mouse, screen
CoordMode, Pixel, screen
MouseMove, xPosAudio, yPosAudio, 0
BlockInput, off
BlockInput, MouseMoveOff ;return mouse control to the user.
tooltip,

} ; monomaker!!!!!!!!!!!!



;script reloader, but it only works on this one :(
;#ifwinactive ahk_class Notepad++
;^r::
;send ^s
;sleep 10
;SoundBeep, 1000, 500
;reload
;return



^!+F2::msgbox, yes, the 2nd keyboard script is still running.

#ifwinactive

!`::
WinGet, ActiveId, ID, A
msgbox, %ActiveId%
;returns 0x1c0b9c ... and only 3 unique codes for each of the 3 Premiere windows I have on my 3 monitors. Does NOT consider subwindows, though maaaaybe it can get that going....
ControlGetFocus, OutputVar, A
msgbox, %OutputVar%
return


;BEGIN savage-folder-navigation CODE!
;I got MOST of this code from https://autohotkey.com/docs/scripts/FavoriteFolders.htm
;and modified it to work with any given keypress, rather than middle mouse click as it had before.

InstantExplorer(f_path)
{
f_path := """" . f_path . """" ;this adds quotation marks around everything so that it works as a string, not a variable.
;msgbox, f_path is %f_path%
SoundBeep, 900, 400
; These first few variables are set here and used by f_OpenFavorite:
WinGet, f_window_id, ID, A
WinGetClass, f_class, ahk_id %f_window_id%
if f_class in #32770,ExploreWClass,CabinetWClass  ; if the window class is a save/load dialog, or an Explorer window of either kind.
	ControlGetPos, f_Edit1Pos, f_Edit1PosY,,, Edit1, ahk_id %f_window_id%

/*
if f_AlwaysShowMenu = n  ; The menu should be shown only selectively.
{
	if f_class in #32770,ExploreWClass,CabinetWClass  ; Dialog or Explorer.
	{
		if f_Edit1Pos =  ; The control doesn't exist, so don't display the menu
			return
	}
	else if f_class <> ConsoleWindowClass
		return ; Since it's some other window type, don't display menu.
}
; Otherwise, the menu should be presented for this type of window:
;Menu, Favorites, show
*/

; msgbox, A_ThisMenuItemPos %A_ThisMenuItemPos%
; msgbox, A_ThisMenuItem %A_ThisMenuItem%
; msgbox, A_ThisMenu %A_ThisMenu%

;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
; msgbox, f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; f_OpenFavorite:
;msgbox, BEFORE:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%

; Fetch the array element that corresponds to the selected menu item:
;;StringTrimLeft, f_path, f_path%A_ThisMenuItemPos%, 0
if f_path =
	return
if f_class = #32770    ; It's a dialog.
{
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		; IF window Title is NOT "export settings," with the exe "premiere pro.exe"
			;go to the end or do something else, since you are in Premiere's export media dialouge box... which has the same #23770 classNN for some reason...
		

		ControlFocus, Edit1, ahk_id %f_window_id% ;this is really important.... it doesn't work if you don't do this...
		tippy("DIALOUGE WITH EDIT1`n`nLE controlfocus of edit1 for f_window_id was just engaged.", 1000)
		; msgbox, is it in focus?
		; MouseMove, f_Edit1Pos, f_Edit1PosY, 0
		; sleep 10
		; click
		; sleep 10
		; msgbox, how about now? x%f_Edit1Pos% y%f_Edit1PosY%
		;msgbox, edit1 has been clicked maybe
		
		; Activate the window so that if the user is middle-clicking
		; outside the dialog, subsequent clicks will also work:
		WinActivate ahk_id %f_window_id%
		; Retrieve any filename that might already be in the field so
		; that it can be restored after the switch to the new folder:
		ControlGetText, f_text, Edit1, ahk_id %f_window_id%
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		ControlSend, Edit1, {Enter}, ahk_id %f_window_id%
		Sleep, 100  ; It needs extra time on some dialogs or in some cases.
		ControlSetText, Edit1, %f_text%, ahk_id %f_window_id%
		;msgbox, AFTER:`n f_path: %f_path%`n f_class:  %f_class%`n f_Edit1Pos:  %f_Edit1Pos%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
/*
else if f_class in ExploreWClass,CabinetWClass  ; In Explorer, switch folders.
{
	tooltip, f_class is %f_class% and f_window_ID is %f_window_id%
	if f_Edit1Pos <>   ; And it has an Edit1 control.
	{
		tippy("EXPLORER WITH EDIT1 only 2 lines of code here....", 1000)
		ControlSetText, Edit1, %f_path%, ahk_id %f_window_id%
		msgbox, ControlSetText happened. `nf_class is %f_class% and f_window_ID is %f_window_id%`nAND f_Edit1Pos is %f_Edit1Pos%
		; Tekl reported the following: "If I want to change to Folder L:\folder
		; then the addressbar shows http://www.L:\folder.com. To solve this,
		; I added a {right} before {Enter}":
		ControlSend, Edit1, {Right}{Enter}, ahk_id %f_window_id%
		return
	}
	; else fall through to the bottom of the subroutine to take standard action.
}
*/
else if f_class = ConsoleWindowClass ; In a console window, CD to that directory
{
	WinActivate, ahk_id %f_window_id% ; Because sometimes the mclick deactivates it.
	SetKeyDelay, 0  ; This will be in effect only for the duration of this thread.
	IfInString, f_path, :  ; It contains a drive letter
	{
		StringLeft, f_path_drive, f_path, 1
		Send %f_path_drive%:{enter}
	}
	Send, cd %f_path%{Enter}
	return
}
; Since the above didn't return, one of the following is true:
; 1) It's an unsupported window type but f_AlwaysShowMenu is y (yes).
; 2) It's a supported type but it lacks an Edit1 control to facilitate the custom
;    action, so instead do the default action below.
tippy("end was reached.",1000)
SoundBeep, 800, 300
; Run, Explorer %f_path%  ; Might work on more systems without double quotes.

;;; need a line here to check if the path actually exists or not!

Run, %f_path%  ; I got rid of the "Explorer" part because it caused redundant windows to be opened, rather than just switching to the existing window
}
;end of instant explorer

#ifwinactive

;;;; SCRIPT TO ALWAYS OPEN THE MOST RECENTLY SAVED OR AUTOSAVED FILE OF A GIVEN FILETYPE, IN ANY GIVEN FOLDER (AND ALL SUBFOLDERS.);;;;

;;script partially obtained from https://autohotkey.com/board/topic/57475-open-most-recent-file-date-created-in-a-folder/
openlatestfile(directory, filetype)
{
;filetype := """" . filetype . """" ;this ADDS quotation marks around a string in case you need that.
StringReplace, directory,directory,", , All ;" ; this REMOVES the quotation marks around the a string if they are present.

;msgbox, directory is %directory%`n and filetype is %filetype%
Loop, Files,%directory%\*%filetype%, FR
{
If (A_LoopFileTimeModified>Rec)
  {
  FPath=%A_LoopFileFullPath%
  Rec=%A_LoopFileTimeModified%
  }
}

MsgBox 4,, Select YES to open the latest %filetype% at Fpath `n%Fpath%
IfMsgBox Yes
	{
	Run %Fpath%
	}
}

;;;CLICK ON THE 'CROP' TRANSFORM BUTTON IN ORDER TO SELECT THE CROP ITSELF
cropClick()
{
BlockInput, on
BlockInput, MouseMove
MouseGetPos xPosCursor, yPosCursor

effectControlsX = 10
effectControlsY = 200 ;the coordinates of roughly where my Effect Controls usually are located on the screen
CoordMode Pixel ;, screen
CoordMode Mouse, screen

;you might need to take your own screenshot (look at mine to see what is needed) and save as .png. Mine are done with default UI brightness, plus 150% UI scaling in Windows.
ImageSearch, FoundX, FoundY, effectControlsX, effectControlsY, effectControlsX+300, effectControlsY+1000, %A_WorkingDir%\CROP transform button.png
if ErrorLevel = 1
	{
	;msgbox, we made it to try 2
    tippy("NO CROP WAS FOUND")
	goto resetcropper
	}
if ErrorLevel = 2
	{
    tippy("Could not conduct the search!")
	goto resetcropper
	}
if ErrorLevel = 0
	{
	MouseMove, FoundX+10, FoundY+10, 0 ;this moves the cursor onto the little square thingy.
	;msgbox, is the cursor in position?
	sleep 5
	click left
	}

resetcropper:
MouseMove, xPosCursor, yPosCursor, 0
blockinput, off
blockinput, MouseMoveOff
sleep 10
return
	
}
;end of CROP CLICK