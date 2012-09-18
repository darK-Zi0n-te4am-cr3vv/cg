@echo off

set SRC=.\
set LIB=.\lib

set MASMFLAGS=/I%SRC% /nologo /Zi /c
set MASM=ml %MASMFLAGS%

set LINKFLAGS=/CO /BATCH
set LINK=link %LINKFLAGS%


set TARGET=%1
if "%TARGET%" == "" set TARGET=all

goto %TARGET%

:clean
	del *.obj
	del *.exe
	del *.map
	
	goto Exit
	
	
:lib
	%MASM% %LIB%\cga.asm %LIB%\int10.asm %LIB%\kb.asm %LIB%\sys.asm
	goto Exit

:task
	set TASK_ID=%2
	if "%TASK_ID%" == "" set TASK_ID=%DEFAULT_TASK_ID%
	if "%TASK_ID%" == "" goto ErrorNoDefaultTaskId
	
	%MASM% %SRC%\%TASK_ID%\2.asm
	%LINK% @2.lnk
	
	%MASM% %SRC%\%TASK_ID%\3.asm
	%LINK% @3.lnk
	
	
	goto Exit
	
	:ErrorNoDefaultTaskId
	echo use make task ## or set the your task ID using set DEFAULT_TASK_ID=##
	goto Exit
	
:all
	call make lib
	call make task %DEFAULT_TASK_ID%
	goto Exit
	
:Exit