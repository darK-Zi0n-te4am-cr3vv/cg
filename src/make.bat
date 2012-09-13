@echo off

set MASMFLAGS=/I. /nologo
set MASM=ml %MASMFLAGS%

set LIB_FILES="LIB\cga.asm LIB\int10.asm LIB\kb.asm LIB\sys.asm"

set TARGET=%1
if "%TARGET%" == "" set TARGET=13

goto %TARGET%

:clean
	del *.obj
	del *.exe

:lib
	
	%MASM% /Fobin\lib.obj %LIB_FILES%