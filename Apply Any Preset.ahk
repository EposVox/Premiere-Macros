;Copy this file to Startup to have it always run with your machine:
;C:\Users\Adam\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
;Apply any Preset (including transitions)
;Configured for Genovation ControlPad CP48 Programmable Macro Keypad
;Adam Taylor aka EposVox http://youtube.com/eposvox
;Tour of my setup working: https://www.youtube.com/watch?v=IK4H14rCDcY

;Original scripting & ideas courtesy of TaranVH - https://www.youtube.com/channel/UCd0ZD4iCXRXf18p3cA7EQfg
;Taran's original VIDEO EXPLANATION:   https://www.youtube.com/watch?v=eZIaBsybO6Y
;Taran's code work https://github.com/TaranVH

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;The ABOVE CODE ^^^ was automaticlaly generated when I made a new .ahk document. I don't know how essential it is.

#SingleInstance force ;only one instance of this script may run at a time!
#IfWinActive ahk_exe Adobe Premiere Pro.exe
;---EVERYTHING BELOW THIS LINE WILL ONLY WORK INSIDE PREMIERE PRO!

Menu, Tray, Icon, shell32.dll, 116
;Above changes the icon in the system tray from the usual AHK icon. Play with the numbers to pick your own.
;icons http://help4windows.com/windows_7_shell32_dll.shtml   https://www.sysmiks.com/icon-number-of-icon-list-shell32-dll-imageres-dll/

^!f::
ControlFocus, Edit7, ahk_class Premiere Pro
Sleep, 10
return

;<<<<>>>>
;THIS IS THE FUNCTION FOR TYPING STUFF INTO THE SEARCH BAR but it doesn't apply them to the clips
effectsPanelType(item)
{
SetKeyDelay, 0
ControlFocus, Edit1, ahk_class Premiere Pro ;this is the effects panel, according to windowspy
sleep 10
send {tab}
sleep 10
send +{tab}
sleep 10
Send +{backspace}
Send %item%
;now this next part re-selects the field in case you want to type anything different
sleep 5
send {tab}
sleep 5
send +{tab}
}

;USING THE FUNCTION:
;^!+f::effectsPanelType("") ;-------Types nothing in. So it CLEARS the effects panel search bar
;Disabled above, as I've assigned this to a label now.
;^!+p::effectsPanelType("presets")
;^!+w::effectsPanelType("warp")
mButton::effectsPanelType("presets") ; this is super useful. Using the scroll wheel click as an assignable button...
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;;;;;;;;;;;;;;;FUNCTION FOR DIRECTLY APPLYING A PRESET EFFECT TO A CLIP;;;;;;;;;;;;;;;;;;;;
preset(item)
{
BlockInput, SendAndMouse
BlockInput, On
;Send ^!+`
;Sleep 10
;Send ^!+7
;Sleep 10
SetKeyDelay, 0
MouseGetPos, xpos, ypos ;-----------------------stores the cursor's current coordinates at X%xpos% Y%ypos%
ControlGetPos, X, Y, Width, Height, Edit7, ahk_class Premiere Pro ;;;highlights Premier's effects panel search bar (info gotten from window spy) (changed from Edit1 to Edit7 6/12/19)
MouseMove, X+Width+10, Y+Height/2, 0
sleep 5
MouseClick, left, , , 1 ;------------------------clicks on X
MouseMove, X-13, Y+10, 0
sleep 5
MouseClick, left, , , 1
sleep 5
Send %item%
sleep 30
MouseMove, 34, 80, 0, R ;-----------------------moves cursor down and directly onto the effect's icon
MouseGetPos, iconX, iconY
ControlGetPos, , , www, hhh, DroverLord - Window Class10, ahk_class Premiere Pro
MouseMove, www/3, hhh/2, 0, R ;-----------------clicks in about the CENTER of the Effects panel. This clears the displayed presets from any duplication errors
MouseClick, left, , , 1
sleep 10
MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the effect's icon

sleep 35
MouseClickDrag, Left, , , %xpos%, %ypos%, 0 ;---drags this effect to the cursor's pervious coordinates, which should be above a clip.
sleep 10
MouseClick, left, , , 1 ;------------------------returns focus to the timeline.
BlockInput, off
}
;That's the end of the function. Now we make shortcuts to CALL that function, each with a different parameter!

;All of these refer to presets I have already created and named in Premiere
;note that using ALT for these is kind of stupid... they can interfere with menus.
;ALT C, for example, will always open the CLIP menu. So I can't use that anywhere.
;;---I have assigned most of these to my macro keys on my keyboard, so it's just ONE KEYSTROKE to apply them!

;Various Premiere Effect Presets (alphabetized by command structure)

;< ctrl alt shift >
^!+1::
preset("Wipe-Top-Right") 
Return

^!+2::
preset("Wipe-Top-left") 
Return

^!+3::
preset("Wipe-Down") 
Return

^!+4::
preset("Wipe-Left-Right") 
Return

^!+5::
preset("Wipe-Right-Left") 
Return

^!+6::
preset("Wipe-Up") 
Return

^!+7::
preset("Wipe-Bottom-left") 
Return

^!+8::
preset("Wipe-Bottom-Right") 
Return

^!+9::
preset("Impact Zoom Blur") 
Return

^!+0::
preset("Blur-Diss2") 
Return

^!+a::
preset("CopyLeft")
Return

^!+b::
preset("Big Blur") 
Return

^!+c::
preset("crop") 
Return

^!+d::
preset("Drop2") 
Return

^!+e::
preset("CopyRight")
Return

;^!+f reserved for Label: A-roll

;^!+g reserved for Label: Ad Spots

^!+h::
preset("CopyDown")
Return

;^!+i reserved for Label: B-roll

;^!+j reserved for Label: Music

^!+k::
preset("blueprint")
Return

;^!+l reserved for Label: Dynamic Nested GFX

^!+m::
preset("HandShake")
Return

^!+n::
preset("TextBounce")
Return

;^!+o reserved for "Set to Frame Size" in Premiere

^!+p::
preset("Pixel Dissolve")
Return

;^!+q reserved for Label: Old Videos
^!+r::
preset("Punch In")
Return

;^!+s reserved for Label: GFX

^!+t::
preset("Punch In More")
Return

;^!+U reserved for "Scale to Frame Size" in Premiere

^!+v::
preset("BW") 
Return

^!+w::
preset("MISSFIRE") 
Return

^!+x::
preset("Impact Flash") 
Return

^!+y::
preset("GETGLITCHED") 
Return

^!+z::
preset("Ultra Key")
Return


;< CTRL SHIFT >
^+1::
preset("Glitch Trans")
Return

^+2::
preset("VEEHACHESS")
Return

;^+3 reserved for Nesting in Premiere

;^+4 reserved for Premiere to AE

;^+5 reserved for Label: Adjustment Layers

;^+6 reserved for Label: Sound Effects

^+7::
preset("2GLITCH")
Return

^+8::
preset("2VHS")
Return

; < CTRL ALT >
^!E::
preset("Impact Push Down") 
Return

^+f::
preset("bad tv")
Return

^!i::
preset("Impact Push Left") 
Return

^!o::
preset("Impact Push Right") 
Return

^!p::
preset("Flare") 
Return

^!r::
preset("Impact Push Up") 
Return

^!s::
preset("RGBSEP") 
Return

^!w::
preset("LightLeaks") 
Return

; < SHIFT ALT >
+!a::
preset("Epic Glitch")
Return

+!b::
preset("csurf")
Return

+!c::
preset("RGB Text Effect")
Return

+!d::
preset("HOLOM")
Return

+!h::
preset("NOIRVENE")
Return

+!k::
preset("TVP")
Return

+!l::
preset("VHSD")
Return

+!m::
preset("CopyUp")
Return

+!n::
preset("2VHS")
Return

+!o::
preset("End Card OTN")
Return

+!p::
preset("LoudMax")
Return

;+!q reserved for running bat file for Stream Deck
;+!r reserved for running bat file for Stream Deck
;+!s reserved for text tool on SD Mini

+!t::
preset("Glitch Edges 1")
Return

+!u::
preset("Glitch Edges 2")
Return


#IfWinActive

