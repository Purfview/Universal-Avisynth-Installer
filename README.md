# Universal Avisynth Installer

This is a repository containing several Avisynth versions and the necessary batch file to install/uninstall them.

The screen shot below shows example of what you see when you run setavs.cmd:

![alt text](https://i.postimg.cc/ryvxqt59/Image2.png)

Unpack the archive to a location of your choice and follow the setup instructions below (instructions are also in the batch file):

<pre><code>
::  ########################## Start Configuration #########################

::   The variable "AVS_SRC_DIR" must be set according to the location of
::   this batch file.

::   The simplest way to have this up and running is to copy the "AvisynthRepository"
::   directory to a location of your choice (avoid "Program Files" or "Program Files (x86)")
::   and create a shortcut to the "setavs.cmd" batch file in the root of "AvisynthRepository".

::   If you want to run the batch file from a different directory
::   (e.g. a directory to which the "PATH" environment variable points),
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
</code></pre>

## Note:

Sometimes old installations of Avisynth may leave behind orphan directories and/or registry entries that could interfere with the new install. It's usually a good idea to clean up before using this installer (don't forget to make a backup of the plugins you need):

- Delete "C:\Program Files (x86)\AviSynth" and subdirs (just an example, your path to Avisynth may differ)
- Delete these registry keys:    
"HKEY_CURRENT_USER\Software\Avisynth"    
"HKEY_LOCAL_MACHINE\SOFTWARE\Avisynth"   
"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Avisynth" (only on 64 bit OS) 

## Adopted from: https://forum.doom9.org/showthread.php?t=172124
