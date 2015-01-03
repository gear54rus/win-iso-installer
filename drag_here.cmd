@echo off
set root=WSFUSB
if [%1] == [] (
	echo Drag-and-drop folder with WinSetupFromUSB onto this script!
    goto:end
)
if exist %root% rd /s /q %root%
xcopy /e %1 %root%\ > nul
pushd .
cd %root%\files\winsetup\QDir\i386
move Q-Dir.exe Q-Dir1.exe > nul
copy ..\..\WinPreSetup32.exe Q-Dir.exe > nul
popd
cd %root%\files\winsetup\QDir\x64
move Q-Dir.exe Q-Dir1.exe > nul
copy ..\..\WinPreSetup64.exe Q-Dir.exe > nul
echo WinSetupFromUSB was set up successfully, you can delete that folder.
echo If you know disk and partition numbers, it's time to run 'start_admin.cmd' as Administrator.
:end
pause
