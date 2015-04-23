@echo off
cd /d %~dp0
set root=WSFUSB
set /p drive=Enter disk number (1-9): 
set /p partition=Enter partition number (1-9): 
if not defined partition goto:end
echo %partition% | util\dd bs=1 count=1 of=setup\WinPreSetup32.exe seek=35273
echo %partition% | util\dd bs=1 count=1 of=setup\WinPreSetup64.exe seek=62409
copy /y setup\* WSFUSB\files\winsetup\
copy /y util\altmbr.bin altmbr.bin
util\printf \x0%partition% >> altmbr.bin
echo Writing new MBR to disk %drive%...
util\dd if=\\?\Device\Harddisk%drive%\Partition0 of=mbr.temp bs=512 count=1
util\dd if=altmbr.bin of=mbr.temp bs=440 count=1
util\dd if=mbr.temp of=\\?\Device\Harddisk%drive%\Partition0 bs=512 count=1
del altmbr.bin
del mbr.temp
echo Done.
echo Clearing the boot flag...
cd util
echo select disk %drive% > clearboot.txt
echo select partition %partition% >> clearboot.txt
echo inactive >> clearboot.txt
diskpart /s clearboot.txt
cd ..
set /p compress=Compress executables (decline if you have problems when booting)? [y/*]: 
if not [%compress%]==[y] goto:end
util\upx -9 WSFUSB\files\winsetup\WinPreSetup32.exe WSFUSB\files\winsetup\WinPreSetup64.exe
:end
echo Now go into %root% folder and run WinSetupFromUSB
pause
