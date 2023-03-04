::Batch script for fast switching of Avisynth versions
::Initial idea and work by Groucho2004
::Modified by jones1913
::Modified and extended by Groucho2004

@echo off
cls
setlocal

:Check administrative privileges
fsutil dirty query %systemdrive% > nul
if errorlevel 1 goto :noAdmin


::  ########################## Start Configuration #########################

::   The variable "AVS_SRC_DIR" must be set according to the location of
::   this batch file.

::   The simplest way to have this up and running is to copy the "AvisynthRepository"
::   directory to a location of your choice (avoid "Program Files" or "Program Files (x86)")
::   and create a shortcut to the "setavs.cmd" batch file in the root of "AvisynthRepository".

::   If you want to run the batch file from a different directory
::   (i.e. a directory to which the "PATH" environment variable points),
::   remove the "%~dp0" and use a fully qualified path to the source directory.
::   Example: "set AVS_SRC_DIR=E:\VideoTools\AvisynthRepository"
set AVS_SRC_DIR=%~dp0


::   Default plugin directories
::   If you leave them blank, the respective "plugin" directories within
::   the "AvisynthRepository" source directories will be used.
set PLUGDIR32=
set PLUGDIR64=


::   Additional plugin directories (works only with Avisynth+)
::   If you leave them blank, only the default plugin directories (see above)
::   will be used.
set PLUGDIR32PLUS=
set PLUGDIR64PLUS=


::  **IMPORTANT:
::  If you have customized any of the above directories and their names contain
::  special characters such as '&', '(' or ')', enclose the variable and path
::  in double quotes and use the escape character '^' before the special character(s).
::  
::  Example 1:
::  set "AVS_SRC_DIR=C:\Program Files ^(x86^)\Avisynth"
::  
::  Example 2:
::  set "PLUGDIR32=C:\Program Files ^(x86^)\Avisynth\Plugins ^& avsi"


::  ########################### End Configuration ##########################



if "%AVS_SRC_DIR%" == "" (
  echo.
  echo The source directory ^(AVS_SRC_DIR^) is not defined.
  echo Please read the instructions above.
  echo.
  goto :end
)

if /i %PROCESSOR_ARCHITECTURE%==x86 if not defined PROCESSOR_ARCHITEW6432 set winarch=x32

:: Remove trailing backslash if present
if "%AVS_SRC_DIR:~-1%"=="\" SET AVS_SRC_DIR=%AVS_SRC_DIR:~0,-1%

echo.
echo  Installed Avisynth version(s):
echo.
if defined winarch (
	"%AVS_SRC_DIR%\Tools\AVSVersion32.exe"
) else (
	"%AVS_SRC_DIR%\Tools\AVSVersion32.exe"
	echo.
	"%AVS_SRC_DIR%\Tools\AVSVersion64.exe"
)
echo.

echo.
echo  Select the Avisynth version you want to install/uninstall:
echo.
echo    1 = Avisynth      2.5.8
echo    2 = Avisynth      2.6.0
echo    3 = Avisynth      2.6.1 (Alpha)
echo    4 = Avisynth      2.6.0 (SEt's multi-threaded build)
echo.

echo    5 = Avisynth+     0.1.0 (x86, r2772)
echo    6 = Avisynth+     0.1.0 (x64, r2772)
echo    7 = Avisynth+ XP  3.7.2 (x86, r3661)
echo    8 = Avisynth+ XP  3.7.2 (x64, r3661)
echo    9 = Avisynth+     3.7.2 (x86, r3661)
echo   10 = Avisynth+     3.7.2 (x64, r3661)

echo.
echo   13 = Uninstall Avisynth x86
echo   14 = Uninstall Avisynth x64
echo.
echo   NOTE: 64 bit versions can be installed alongside 32 bit versions.
echo.
echo.
set no=
set /p no=  [1-12] (leave blank and [Enter] to exit): 
if [%no%]==[] goto :cancel


if %no%==1 set avs=AVS258
if %no%==2 set avs=AVS260
if %no%==3 set avs=AVS261_Alpha
if %no%==4 set avs=AVS260_MT

if %no%==5  (set avs=AVSPLUS010_x86) & set avspl=true
if %no%==6  (set avs=AVSPLUS010_x64) & set avspl=true
if %no%==7  (set avs=AVSPLUS372_x86_XP) & set avspl=true
if %no%==8  (set avs=AVSPLUS372_x64_XP) & set avspl=true
if %no%==9  (set avs=AVSPLUS372_x86) & set avspl=true
if %no%==10 (set avs=AVSPLUS372_x64) & set avspl=true


if %no%==13 (set avs=AVSx86) & goto :uninstall
if %no%==14 (set avs=AVSx64) & goto :uninstall
echo.
if [%avs%]==[] (echo Invalid input...
	goto :menu)

if %avs%==AVSPLUS010_x64 set x64=true
if %avs%==AVSPLUS372_x64 set x64=true
if %avs%==AVSPLUS372_x64_XP set x64=true
if %avs%==AVSPLUS372_x64 set x64=true

:install

:: Remove trailing backslash if present
if "%AVS_SRC_DIR:~-1%"=="\" SET AVS_SRC_DIR=%AVS_SRC_DIR:~0,-1%

if "%PLUGDIR32%" == "" (
  set REGPLUGDIR32=%AVS_SRC_DIR%\%avs%\plugins
) else (
  set REGPLUGDIR32=%PLUGDIR32%
)

if "%PLUGDIR64%" == "" (
  set REGPLUGDIR64=%AVS_SRC_DIR%\%avs%\plugins
) else (
  set REGPLUGDIR64=%PLUGDIR64%
)

if "%PLUGDIR32PLUS%" == "" (
  set REGPLUGDIR32PLUS=%AVS_SRC_DIR%\%avs%\plugins
) else (
  set REGPLUGDIR32PLUS=%PLUGDIR32PLUS%
)

if "%PLUGDIR64PLUS%" == "" (
  set REGPLUGDIR64PLUS=%AVS_SRC_DIR%\%avs%\plugins
) else (
  set REGPLUGDIR64PLUS=%PLUGDIR64PLUS%
)

:: Remove trailing backslash if present
if "%REGPLUGDIR32PLUS:~-1%"=="\" SET REGPLUGDIR32PLUS=%REGPLUGDIR32PLUS:~0,-1%
if "%REGPLUGDIR64PLUS:~-1%"=="\" SET REGPLUGDIR64PLUS=%REGPLUGDIR64PLUS:~0,-1%
if "%REGPLUGDIR32:~-1%"=="\" SET REGPLUGDIR32=%REGPLUGDIR32:~0,-1%
if "%REGPLUGDIR64:~-1%"=="\" SET REGPLUGDIR64=%REGPLUGDIR64:~0,-1%

echo Installing %avs%...
echo.
if defined winarch (
	echo setup for 32bit windows system...
	echo.

	if defined x64 ( echo Attempt to install x64 AVS on x32 Windows.
		goto :cancel )

	echo copying %avs% files to "%WINDIR%\System32"...
	copy /y "%AVS_SRC_DIR%\%avs%\avisynth.dll" "%WINDIR%\System32"
	copy /y "%AVS_SRC_DIR%\%avs%\devil.dll" "%WINDIR%\System32"
	if errorlevel 1 ( echo Failed to copy files to "%WINDIR%\System32"
		goto :error )
	echo.
	echo Writing "HKLM\SOFTWARE\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%"
	reg add "HKLM\SOFTWARE\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%" /f
	echo.

	echo Writing "HKLM\SOFTWARE\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR32%"
	reg add "HKLM\SOFTWARE\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR32%" /f
	if errorlevel 1 ( echo Error on importing registry keys!
		goto :error )

	if "%REGPLUGDIR32PLUS%" GTR "" (
		echo.
		echo Writing "HKLM\SOFTWARE\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR32PLUS%"
		reg add "HKLM\SOFTWARE\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR32PLUS%" /f
		if errorlevel 1 ( echo Error on importing registry keys!
			goto :error )
	)

	call :regWin
) else (
	echo setup for 64bit windows system...
	echo.
	if defined x64 (
		echo copying %avs% files to "%WINDIR%\System32"...
		copy /y "%AVS_SRC_DIR%\%avs%\avisynth.dll" "%WINDIR%\System32"
		copy /y "%AVS_SRC_DIR%\%avs%\devil.dll" "%WINDIR%\System32"
		if errorlevel 1 ( echo Failed to copy files to "%WINDIR%\System32"
			goto :error )
		echo.
		echo Writing "HKLM\SOFTWARE\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%"
		reg add "HKLM\SOFTWARE\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%" /f
		echo.

		echo Writing "HKLM\SOFTWARE\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR64%"
		reg add "HKLM\SOFTWARE\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR64%" /f
		if errorlevel 1 ( echo Error on importing registry keys!
			goto :error )

		if "%REGPLUGDIR64PLUS%" GTR "" (
			echo.
			echo Writing "HKLM\SOFTWARE\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR64PLUS%"
			reg add "HKLM\SOFTWARE\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR64PLUS%" /f
			if errorlevel 1 ( echo Error on importing registry keys!
				goto :error )
		)

		call :regWin
	) else (
		echo copying %avs% files to "%WINDIR%\SysWow64"...
		echo copy /y "%AVS_SRC_DIR%\%avs%\avisynth.dll" "%WINDIR%\SysWow64"
		copy /y "%AVS_SRC_DIR%\%avs%\avisynth.dll" "%WINDIR%\SysWow64"
		copy /y "%AVS_SRC_DIR%\%avs%\devil.dll" "%WINDIR%\SysWow64"
		if errorlevel 1 ( echo Failed to copy files to "%WINDIR%\SysWow64"
			goto :error )
		echo.
		echo Writing "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%"
		reg add "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "" /d "%AVS_SRC_DIR%\%avs%" /f
		echo.

		echo Writing "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR32%"
		reg add "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "PluginDir2_5" /d "%REGPLUGDIR32%" /f
		if errorlevel 1 ( echo Error on importing registry keys!
			goto :error )

		if "%REGPLUGDIR32PLUS%" GTR "" (
			echo.
			echo Writing "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR32PLUS%"
			reg add "HKLM\SOFTWARE\Wow6432Node\Avisynth" /v "PluginDir+" /d "%REGPLUGDIR32PLUS%" /f
			if errorlevel 1 ( echo Error on importing registry keys!
				goto :error )
		)

		call :regWow64
	)
)
goto :end

:regWin
echo.
echo adding more registry entries...
reg add "HKLM\SOFTWARE\Classes\AVIFile\Extensions\AVS" /ve /d "{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /ve /d "AviSynth" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}\InProcServer32" /ve /d "AviSynth.dll" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}\InProcServer32" /v "ThreadingModel" /d "Apartment" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\Media Type\Extensions\.avs" /v "Source Filter" /d "{D3588AB0-0781-11CE-B03A-0020AF0BA770}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\.avs" /ve /d "avsfile" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\.avsi" /ve /d "avs_auto_file" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avsfile" /ve /d "AviSynth Script" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avsfile\DefaultIcon" /ve /d "%WINDIR%\System32\AviSynth.dll,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avs_auto_file" /ve /d "AviSynth Autoload Script" /f >nul 2>&1
if defined avspl (reg add "HKLM\SOFTWARE\Classes\avs_auto_file\DefaultIcon" /ve  /d "%WINDIR%\System32\AviSynth.dll,1" /f
	) else reg add "HKLM\SOFTWARE\Classes\avs_auto_file\DefaultIcon" /ve /d "%WINDIR%\System32\AviSynth.dll,0" /f
goto :eof

:regWow64
echo.
echo adding more registry entries (wow64 mode)...
reg add "HKLM\SOFTWARE\Classes\AVIFile\Extensions\AVS" /ve /d "{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /ve /d "AviSynth" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}\InProcServer32" /ve /d "AviSynth.dll" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}\InProcServer32" /v "ThreadingModel" /d "Apartment" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Classes\Media Type\Extensions\.avs" /v "Source Filter" /d "{D3588AB0-0781-11CE-B03A-0020AF0BA770}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\.avs" /ve /d "avsfile" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\.avsi" /ve /d "avs_auto_file" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avsfile" /ve /d "AviSynth Script" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avsfile\DefaultIcon" /ve /d "%WINDIR%\SysWow64\AviSynth.dll,0" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Classes\avs_auto_file" /ve /d "AviSynth Autoload Script" /f >nul 2>&1
if defined avspl (reg add "HKLM\SOFTWARE\Classes\avs_auto_file\DefaultIcon" /ve /d "%WINDIR%\SysWow64\AviSynth.dll,1" /f
	) else reg add "HKLM\SOFTWARE\Classes\avs_auto_file\DefaultIcon" /ve /d "%WINDIR%\SysWow64\AviSynth.dll,0" /f
goto :eof

:uninstall
echo.
echo Remove %avs% .dll and registry entries from this system?
set /p rm=[y/n]: 
if /i not [%rm%]==[y] goto :cancel
echo.
if defined winarch (
	if /i %avs%==AVSx64 ( echo Attempt to remove x64 AVS from x32 Windows.
		goto :cancel )
	echo removing %avs% files from "%WINDIR%\System32"...
	del "%WINDIR%\System32\avisynth.dll"
	del "%WINDIR%\System32\devil.dll"
	call :unregWin all
) else (
	if /i %avs%==AVSx64 (
		echo removing %avs% files from "%WINDIR%\System32"...
		del "%WINDIR%\System32\devil.dll"
		del "%WINDIR%\System32\avisynth.dll"
		if exist "%WINDIR%\SysWow64\avisynth.dll" (call :unregWin) else (
			call :unregWin all )
	) else (
		echo removing %avs% files from "%WINDIR%\SysWow64"...
		del "%WINDIR%\SysWow64\avisynth.dll"
		del "%WINDIR%\SysWow64\devil.dll"
		if exist "%WINDIR%\System32\avisynth.dll" (call :unregWow64) else (
			call :unregWow64 all )
	)
)
goto :end
	
:unregWin
echo.
echo removing registry entries...
reg delete "HKLM\SOFTWARE\Avisynth" /f
reg delete "HKLM\SOFTWARE\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /f
reg delete "HKLM\SOFTWARE\Classes\Media Type\Extensions\.avs" /f
if [%1]==[all] call :unregAll
goto :eof

:unregWow64
echo.
echo removing registry entries (wow64 mode)...
reg delete "HKLM\SOFTWARE\Wow6432Node\Avisynth" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{E6D6B700-124D-11D4-86F3-DB80AFD98778}" /f
reg delete "HKLM\SOFTWARE\Wow6432Node\Classes\Media Type\Extensions\.avs" /f
if [%1]==[all] call :unregAll
goto :eof

:unregAll
echo.
echo removing more avs registry entries...
reg delete "HKLM\SOFTWARE\Classes\AVIFile\Extensions\AVS" /f
reg delete "HKLM\SOFTWARE\Classes\.avs" /f
reg delete "HKLM\SOFTWARE\Classes\.avsi" /f
reg delete "HKLM\SOFTWARE\Classes\avsfile" /f
reg delete "HKLM\SOFTWARE\Classes\avs_auto_file" /f
goto :eof

:noAdmin
echo  This batch file must run with elevated privileges, so:
echo.
echo  Right click on it and chose "Run as administrator"
goto :end

:error
echo.
echo something went wrong...
echo.

:cancel
echo.
echo cancelled...
echo.

:end
endlocal
echo.
pause
