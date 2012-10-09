@echo off

set SRC=.\
set LIB=.\lib

set MASMFLAGS=/I%SRC% /nologo /Zi /c
set MASM=ml %MASMFLAGS%

set LINKFLAGS=/CO /BATCH
set LINK=link %LINKFLAGS%


set TARGET=%1
if "%TARGET%" == "" set TARGET=task

goto %TARGET%

:clean
	del *.obj
	del *.exe
	del *.map
	
	goto Exit
	
	
:lib
	%MASM% %LIB%\cga.asm %LIB%\int10.asm %LIB%\kb.asm %LIB%\sys.asm
	goto Exit
	
:subtask
	if not exist %2 goto Exit
	%MASM% %2
	%LINK% %3
	
	goto Exit

:task
	set TASK_ID=%2
	if "%TASK_ID%" == "" set TASK_ID=%DEFAULT_TASK_ID%
	if "%TASK_ID%" == "" goto ErrorNoDefaultTaskId
	
	call make lib
	
	call make subtask %SRC%\%TASK_ID%\2.asm @2.lnk
	call make subtask %SRC%\%TASK_ID%\3.asm @3.lnk
	call make subtask %SRC%\%TASK_ID%\4.asm @4.lnk
	call make subtask %SRC%\%TASK_ID%\5.asm @5.lnk
	call make subtask %SRC%\%TASK_ID%\6.asm @6.lnk
	
	goto Exit
	
:ErrorNoDefaultTaskId
	echo use make task ## or set the your task ID using set DEFAULT_TASK_ID=##
	goto Exit
	
	
:Exit
