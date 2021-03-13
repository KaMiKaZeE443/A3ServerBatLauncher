:: EDIT TO YOUR OWN NEEDS
 
@echo off
color F
echo Pre startup initialised
echo.
:: Command window name, does not affect anything else
:: Default is: ARMA Server #1
set server_name=TSG ARMA3 Server
:: Path to the ARMA 3 server executable, for example C:ARMA\arma3server.exe
set path_to_server_executable=D:\ServerData\SteamCMD\steamapps\common\Arma3Server\arma3server_x64.exe
:: Name of executable
:: Default 32bit is arma3server.exe, default 64bit is arma3server_x64.exe
set exe_name=arma3server_x64.exe
:: set the port number of the ARMA server, default ARMA is 2302
set server_port_number=2302
:: Name of server profile
set profile_name=TSG
:: List of server side mods, Add the mod to modlist for example adding Mod3 to set modlist=@Mod1; @Mod2;
:: You would do: set modlist=@Mod1; @Mod2; @Mod3;
set modlist=@ExileMod;@CBA_A3;@RyanZombies;@CUPTerrainsMaps;@CUPTerrainsCore;@CUPUnits;@CUPVehicles;@CUPWeapons;@ExtendedSurvivalPack;@ExtendedBaseMod;@VcomAI;@ZombiesandDemons
:: List of server side mods, Add the mod to servermodlist for example adding ServerMod3 to set servermodlist=@ServerMod1; @ServerMod2;
:: You would do: set servermodlist=@ServerMod1; @ServerMod2; @ServerMod3;
set servermodlist=@ExileServer;@infiSTAR_Exile;
:: basic.cfg location, for example C:ARMA\basic.cfg
set path_to_basic_cfg=D:\ServerData\SteamCMD\steamapps\common\Arma3Server\@ExileServer\basic.cfg
:: server.cfg/config.cfg location, for example C:ARMA\server.cfg
set path_to_server_cfg=D:\ServerData\SteamCMD\steamapps\common\Arma3Server\@ExileServer\config.cfg
:: Path to the ARMA directory, for example C:ARMA\
set path_to_arma_directory=D:\ServerData\SteamCMD\steamapps\common\Arma3Server\
:: Default is tbb4malloc_bi
set malloc_name=tbbmalloc_x64
:: If you are using the SteamCMD updater:
:: set use_steam_updater=true
:: Default is false
set use_steam_updater=false
:: set the path to the SteamCMD executable
set path_to_steamcmd_executable=D:\ServerData\SteamCMD\steamcmd.exe
:: set the Steam account name that you want to use to update the server
set account_name=
:: set the above Steam account password
set account_password=
::
:: DO NOT CHANGE ANYTHING BELOW THIS POINT
:: UNLESS YOU KNOW WHAT YOU ARE DOING
::
set error=""
 
echo.
echo Starting vars checks
title %server_name%
 
if "%path_to_server_executable%" == "changeme" (
    set error=path_to_server_executable
    goto error
)
if "%server_port_number%" == "0" (
    set error=server_port_number
    goto error
)
if "%profile_name%" == "changeme" (
    set error=profile_name
    goto error
)
if "%modlist%" == "@Mod1; @Mod2; @Mod3;" (
    set error=modlist
    goto error
)
if "%servermodlist%" == "@ServerMod1; @ServerMod2; @ServerMod3;" (
    set error=servermodlist=
    goto error
)
if "%path_to_basic_cfg%" == "changeme" (
    set error=path_to_basic_cfg
    goto error
)
if "%path_to_server_cfg%" == "changeme" (
    set error=path_to_server_cfg
    goto error
)
if "%path_to_arma_directory%" == "changeme" (
    set error=path_to_arma_directory
    goto error
)
if "%use_steam_updater%" == "true" (
    if "%path_to_steamcmd_executable%" == "changeme" (
        set error=path_to_steamcmd_executable
        goto error
    )
    if "%account_name%" == "changeme" (
        set error=account_name
        goto error
    )
    if "%account_password%" == "changeme" (
        set error=account_password
        goto error
    )
)
set tasklist_name=IMAGENAME eq %exe_name%
 
echo.
echo Variable checks completed!
echo.
set loops=0
 
:loop
tasklist /FI "%tasklist_name%" 2>NUL | find /I /N "%exe_name%">NUL
if "%ERRORLEVEL%" == "0" goto loop
 
:: Steam automatic update for the server files
:: Get from here https://developer.valvesoftware.com/wiki/SteamCMD
if "%use_steam_updater%" == "true" (
    echo Steam Automatic Update Starting
    start /wait %path_to_steamcmd_executable% +login %account_name% %account_password% +force_install_dir %path_to_arma_directory% +app_update 233780 validate +quit
    echo Steam Automatic Update Completed
)
 
echo.
echo Pre startup complete!
echo.
echo Starting server at: %date%,%time%
if "%loops%" NEQ "0" (
    echo Restarts: %loops%
)
 
:: Start the ARMA Server
cd %path_to_server_executable%
start "%profile_name%" /min /wait %exe_name% "-mod=%modlist%" "-config=%path_to_server_cfg%" -port=%server_port_number% "-profiles=%profile_name%" "-cfg=%path_to_basic_cfg%" "-bepath=D:\ServerData\SteamCMD\steamapps\common\Arma3Server\TSG\BattlEye" -name=%profile_name% -autoinit -enableHT -loadMissionToMemory -hugepages -malloc=%malloc_name% -serverMod=%servermodlist%
 
echo To stop the server, close %~nx0 then the other tasks, otherwise it will restart
echo.
goto looping
 
:loop
:: Monitoring Loop
echo Server is already running, running monitoring loop
 
:looping
:: Restart/Crash Handler
set /A loops+=1
timeout /t 5
tasklist /FI "%tasklist_name%" 2>NUL | find /I /N "%server_port_number%">NUL
if "%mission_prefetch%"=="true" (
    taskkill /F /IM %mission_prefetch_exe_name%
)
if "%ERRORLEVEL%"=="0" goto loop
goto loop
 
:error
:: Generic error catching
color C
echo ERROR: %error% not set correctly, please check the config
pause
color F
