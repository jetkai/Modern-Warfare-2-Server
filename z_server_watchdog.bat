@echo off
::Name
set name=IW4x Bot Warfare Server
::Exe of the server
set server_exe=iw4x.exe
::The regex search for the window name of the server
set server_title_regex=Bot Warfare 24/7 Rust 10x
::Only change this when you don't want to keep the bat files in the game folder. MOST WON'T NEED TO EDIT THIS!
set gamepath=%cd%
::Rate to check if server is hung
set check_rate=300
::Server log location
set log_path=%gamepath%\userraw\logs\server
set log_file=games_mp.log

title IW4x MP - %name% - Server watchdog
echo Visit plutonium.pw / Join the Discord (a6JM2Tv) for NEWS and Updates!
echo (%date%)  -  (%time%) %name% server watchdog start.

::https://superuser.com/questions/699769/batch-file-last-modification-time-with-seconds
dir "%log_path%"\"%log_file%" > nul
for /f "delims=" %%i in ('"forfiles /p "%log_path%" /m "%log_file%" /c "cmd /c echo @ftime" "') do set modif_time_temp=%%i

:Server
	set modif_time=%modif_time_temp%

	timeout /t %check_rate% /nobreak > nul

	dir "%log_path%"\"%log_file%" > nul
	for /f "delims=" %%i in ('"forfiles /p "%log_path%" /m "%log_file%" /c "cmd /c echo @ftime" "') do set modif_time_temp=%%i

	if "%modif_time_temp%" == "%modif_time%" (
		echo "(%date%)  -  (%time%) WARNING: %name% server hung, killing server..."
		::https://stackoverflow.com/questions/26552368/windows-batch-file-taskkill-if-window-title-contains-text
		for /f "tokens=2 delims=," %%a in ('
			tasklist /fi "imagename eq %server_exe%" /v /fo:csv /nh
			^| findstr /r /c:"%server_title_regex%"
		') do taskkill /pid %%a /f
	)
goto Server
