#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, New
Gui +resize
Gui, Add, Edit, vEditOriginal Section r9 w200 ReadOnly
Gui, Add, Edit, vEditRotated ys r9 w200 ReadOnly

Gui, Add, Button, Default xm gButtonCheckClipboard, Check Clipboard ; xm to position to left marginal

Gui, Show
return ; end of auto-execute part


Rot13( string )
{
  outString =
  ; loop through the string char by char
  Loop, Parse, string
  {
    char := Asc( A_LoopField )

    
    ; get an offset from ascii value of the character
    ;   value of "A" if in range of A-Z 
    ;   or value of "a" if in range of a-z
    offset := Asc("A") * ( Asc("A") <= char && char <= Asc("Z") ) + Asc("a") * ( Asc("a") <= char && char <= Asc("z") )
    If ( offset > 0 ) ; alphabetic char
    {
        ; rotate the letter value forward in the range of 0..25 (a..z)
        ;  so add the 13 and apply a modulo of 26
        char := Mod( char - offset + 13, 26 )
        ; change the ascii value back to a character (taking the offset into account)
        char := Chr( char + offset )
    }
    Else ; non-alpabetic char
    {
      ; not modified
      char := A_LoopField
    }

    outString .= char
  }
  Return outString
}


ButtonCheckClipboard:
GuiControl,, EditOriginal, ...waiting...
GuiControl,, EditRotated, ...waiting...
ClipWait
clipText = %clipboard%
clipTextRot := Rot13( clipText )
GuiControl,, EditOriginal, %clipText%
GuiControl,, EditRotated, %clipTextRot%
Return

;
GuiClose:
GuiEscape:
ExitApp


