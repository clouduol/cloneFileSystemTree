@echo off
@rem chage page code to utf-8
chcp 65001

echo begin clone
date /t
time /t
set "drivers=a b c d e f g h i j k l m n o p q r s t u v w x y z"
@rem user dependent batch file parameters, set firstly
set "cloneRootDirectory=d:\cloneFileSystemTree"
set "cloneRootDirectory2=c:\cloneFileSystemTree"
set "maxDepth=4"

@rem to run more than once, delete old file system tree
if exist "%cloneRootDirectory%" (
	rd /S /Q "%cloneRootDirectory%"
)
md "%cloneRootDirectory%"
if exist "%cloneRootDirectory2%" (
	rd /S /Q "%cloneRootDirectory2%"
)
md "%cloneRootDirectory2%"
for %%i in (%drivers%) do (
	if exist %%i: (
		call :clone "root","%%i:",%maxDepth%
	)
)

date /t
time /t
echo clone end
@rem clear variables
set drivers=
set cloneRootDirectory=
set cloneRootDirectory2=
set maxDepth=
goto:eof


@rem @param %1 parent directory
@rem @param %2 current directory name
@rem @param %3 left depth
:clone 
setlocal
	@rem process parameters
	set "firstParam=%~1"
	set "secondParam=%~2"
	set "leftDepth=%3"
	set /A "leftDepth-=1"

	if "%firstParam%"=="root" (
		set "currentDirectory=%secondParam%"
	) else (
		set "currentDirectory=%firstParam%\%secondParam%"
	)
	echo "%currentDirectory%"
	set "cloneCurrentDirectory=%cloneRootDirectory%\%currentDirectory::=%"
	set "cloneCurrentDirectory2=%cloneRootDirectory2%\%currentDirectory::=%"

	@rem filter
	if "%cloneRootDirectory%"=="%currentDirectory%" (
		goto:eof
	)
	if "%cloneRootDirectory2%"=="%currentDirectory%" (
		goto:eof
	)

	@rem  create clone directory
	if not exist "\\?\%cloneCurrentDirectory%" (
		md "\\?\%cloneCurrentDirectory%\"
	)
	if not exist "\\?\%cloneCurrentDirectory2%" (
		md "\\?\%cloneCurrentDirectory2%\"
	)

	@rem check left depth
	if %leftDepth% equ 0 (
		tree /F "%currentDirectory%" > "%cloneCurrentDirectory%\%secondParam::=%_tree.txt"
		tree /F "%currentDirectory%" > "%cloneCurrentDirectory2%\%secondParam::=%_tree.txt"
		goto :eof
	)

	set "cloneFFile=%cloneCurrentDirectory%\%secondParam::=%_files.txt"
	set "cloneFFile2=%cloneCurrentDirectory2%\%secondParam::=%_files.txt"
	set "cloneDFile=%cloneCurrentDirectory%\%secondParam::=%_directories.txt"
	set "cloneDFile2=%cloneCurrentDirectory2%\%secondParam::=%_directories.txt"

	@rem record file names
	dir /A-D-S "\\?\%currentDirectory%\" > nul 2>&1
	if %errorlevel% equ 0 (
		dir /A-D-S "\\?\%currentDirectory%\" > "\\?\%cloneFFile%"
		dir /A-D-S "\\?\%currentDirectory%\" > "\\?\%cloneFFile2%"
	)

	@rem recursively clone, nestedly record directory names
	for /f "delims=" %%i in ('dir /AD-S /B "\\?\%currentDirectory%\"') do (
		if not exist "\\?\%cloneDFile%" (
			dir /AD-S "\\?\%currentDirectory%\" > "\\?\%cloneDFile%"
		)
		if not exist "\\?\%cloneDFile2%" (
			dir /AD-S "\\?\%currentDirectory%\" > "\\?\%cloneDFile2%"
		)

		@rem process directory name that contains percent sign
		echo "%%i" | findstr /C:"%%" > nul
		if errorlevel 1 (
			call :clone "%currentDirectory%","%%i",%leftDepth%
		) else (
			tree /F "%currentDirectory%\%%i" > "%cloneCurrentDirectory%\%secondParam::=%_%%i_tree.txt"
			tree /F "%currentDirectory%\%%i" > "%cloneCurrentDirectory2%\%secondParam::=%_%%i_tree.txt"
		)
	) 
endlocal
goto:eof
