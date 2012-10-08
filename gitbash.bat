@echo off

rem THIS IS KOSTYL
if exist "C:\Program Files\Git\bin\sh.exe" (
	cmd /c "C:\Program Files\Git\bin\sh.exe" --login -i
) else (
	if exist "d:\Program Files (x86)\Git\bin\sh.exe" (
		rem For KIRUSHA's computer
		cmd.exe /c "d:\Program Files (x86)\Git\bin\sh.exe" --login -i
	) else (
		cmd.exe /c "C:\Program Files (x86)\Git\bin\sh.exe" --login -i
	)
)