@echo off
title QR Make
chcp 65001
mode 161,100
cls
set opt1=[91m*[0m 
set opt2=- 
set opt3=- 
goto :banner

:banner
cls
echo.
echo [92m							 ██████╗ ██████╗     [94m███╗   ███╗ █████╗ ██╗  ██╗███████╗
echo [92m							██╔═══██╗██╔══██╗    [94m████╗ ████║██╔══██╗██║ ██╔╝██╔════╝
echo [92m							██║   ██║██████╔╝    [94m██╔████╔██║███████║█████╔╝ █████╗  
echo [92m							██║▄▄ ██║██╔══██╗    [94m██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝  
echo [92m							╚██████╔╝██║  ██║    [94m██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗
echo [92m							 ╚══▀▀═╝ ╚═╝  ╚═╝    [94m╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝[0m
echo                                                    ═════════════════════════════════════════════════════════════════
goto :menu

:menu
echo %opt1% Make QR Code
echo %opt2% Check if curl works
echo %opt3% Exit
echo.
echo Use W and S keys to navigate up and down. Press C to choose your option.
choice /c wsc>nul
if %errorlevel% EQU 1 goto :up
if %errorlevel% EQU 2 goto :down
if %errorlevel% EQU 3 goto :select

:up
if "%opt1%"=="[91m*[0m " (
	set opt1=- 
	set opt3=[91m*[0m 
	goto :banner
)
if "%opt2%"=="[91m*[0m " (
	set opt2=- 
	set opt1=[91m*[0m 
	goto :banner
)
if "%opt3%"=="[91m*[0m " (
	set opt3=- 
	set opt2=[91m*[0m 
	goto :banner
)


:down
if "%opt1%"=="[91m*[0m " (
	set opt1=- 
	set opt2=[91m*[0m 
	goto :banner
)
if "%opt2%"=="[91m*[0m " (
	set opt2=- 
	set opt3=[91m*[0m 
	goto :banner
)
if "%opt3%"=="[91m*[0m " (
	set opt3=- 
	set opt1=[91m*[0m 
	goto :banner
)
goto :banner

:select
if "%opt1%"=="[91m*[0m " (
	goto :qr_maker
	pause>nul
)

if "%opt2%"=="[91m*[0m " (
	cls
	curl --version>nul
	if %errorlevel% EQU 9009 (
		echo [91mCurl doesn't work![0m
	) else (
		echo [92mCurl works![0m
	)
	pause>nul
)

if "%opt3%"=="[91m*[0m " (
	exit /b
)
goto :banner

:qr_maker
cls
set /p data=Type the data to put into the QR Code: 

if exist ".\QRCodes\%data%.qrm" (
	echo [93mThere is already a saved file with this QR code![0m
	echo Would you like to open it, or make another one?
	choice /c om /m "Press O to Open the file, or M to Make another code."
	if %errorlevel% EQU 1 (
		type .\QRCodes\%data%.qrm
		pause>nul
		goto :banner
	)
)

if "%data: =%"=="%data%" (
	goto :makeqr
) else (
	echo [93mIt looks like the data contains spaces![0m
	echo We need to seperate you data!
	pause>nul
	set data=%data: =+%
	goto :makeqr
)

:makeqr
curl qrenco.de/%data%
echo Would you like to save the code as a file.
choice /m "Press Y for Yes, or N for No."

if %errorlevel% EQU 1 (
	if not exist .\QRCodes\ (
		md .\QRCodes\
	)
	cd .\QRCodes\
	set data=%data:/=%
	set data=%data:\=%
	set data=%data:?=%
	set data=%data:|=%
	set data=%data:"=%
	set data=%data:>=%
	set data=%data:<=%
	set data=%data::=%
	set data=%data:*=%
	curl qrenco.de/%data% > %data%.qrm
	goto :banner
)
goto :banner