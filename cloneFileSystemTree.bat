@echo off

:: all parameters ends without "\" && all driver marks is lower letter
set drivers=a b c d e f g h i j k l m n o p q r s t u v w x y z
set cloneRootDirectory=d:\cloneFileSystemTree
set cloneRootDirectory2=c:\cloneFileSystemTree

if not exist %cloneRootDirectory% md %cloneRootDirectory%
if not exist %cloneRootDirectory2% md %cloneRootDirectory2%
for %%i in (%drivers%) do if exist %%i: call :clone "root",%%i:
::call :clone d:,nlp_workspace
goto:eof


::@param %1 parent directory
::@param %2 current directory name
:clone 
setlocal
echo begin
set "firstParam=%1"&set "secondParam=%2"
echo %1
echo %2

echo beginif
::using "" in set statement, avoid errors when %1 or %2 contains bracket
if %firstParam%=="root" (set "currentDirectory=%secondParam%") else (set "currentDirectory=%firstParam%\%secondParam%")
echo endif

set cloneCurrentDirectory=%cloneRootDirectory%\%currentDirectory::=%
set cloneCurrentDirectory2=%cloneRootDirectory2%\%currentDirectory::=%
set cloneFFile=%cloneCurrentDirectory%\%secondParam::=%_files.txt
set cloneFFile2=%cloneCurrentDirectory2%\%secondParam::=%_files.txt
set cloneDFile=%cloneCurrentDirectory%\%secondParam::=%_directories.txt
set cloneDFile2=%cloneCurrentDirectory2%\%secondParam::=%_directories.txt


echo %firstParam%
echo %secondParam%
echo %currentDirectory%
echo %cloneCurrentDirectory%
echo %cloneCurrentDirectory2%

echo filter
if "%cloneRootDirectory%"=="%currentDirectory%" goto:eof
if "%cloneRootDirectory2%"=="%currentDirectory%" goto:eof

echo md
if not exist %cloneCurrentDirectory% md %cloneCurrentDirectory%\
if not exist %cloneCurrentDirectory2% md %cloneCurrentDirectory2%\

echo dira-d
set fileCount=0
::using echo>>filenameONESPACEcontent, avoid integer 0,2,3,etc that defaut stream
::using "delims=" avoid space in %%i
for /f “delims=” %%i in ('dir /A-D /B "%currentDirectory%\"') do echo>>%cloneFFile% %%i& echo>>%cloneFFile2% %%i& set /A fileCount+=1
if %fileCount% neq 0 echo>>%cloneFFile% %fileCount%&echo>>%cloneFFile2% %fileCount%

echo dirad
set direCount=0
for /f "delims=" %%i in ('dir /AD /B "%currentDirectory%\"') do echo>>%cloneDFile% %%i&echo>>%cloneDFile2% %%i& set /A direCount+=1
if %direCount% neq 0 echo>>%cloneDFile% %direCount%&echo>>%cloneDFile2% %direCount%

echo forf
::using "" in (), avoid errors when %currentDirectory% contains bracket
if %direCount% neq 0 ^
for /f "delims=" %%i in ('dir /AD /B "%currentDirectory%\"') do ^
call :clone %currentDirectory%,%%i

endlocal
goto:eof
