unit u_cfgfile;

interface

uses
  windows, sysutils, dialogs;

type
  TGameMode = (gmDeathMatch,gmTeamDeathMatch,gmGaussElimination);
  TGameGoal = (ggTimeLimit,ggFragLimit,ggTillTheEndOfTime);
  PCfgData = ^TCfgData;
  TCfgData = record
               game_firstrun: boolean;  // el�sz�r indul-e a j�t�k az adott g�pen
               reserved1: byte;  // mutassa-e az FPS-t
               reserved2: byte;  // f�st m�rt�ke rak�t�n�l
               game_name: string[20];  // j�t�kos neve
               game_autoswitchwpn: boolean;  // automatikus fegyverv�lt�s
               game_showxhair: boolean;  // c�lkereszt megjelen�t�se
               game_showhud: boolean;  // HUD megjelen�t�se
               game_hudisblue: boolean;  // k�k sz�n�-e a HUD
               game_showblood: boolean;  // v�r megjelen�t�se
               game_ODDinteract: boolean;  // optikai meghajt� interaktivit�sa
               game_keybdLEDsinteract: boolean;  // bazooka automatikus �jrat�lt�se
               game_screensaveroff: boolean;  // j�t�k k�zben k�perny�k�m�l� tilt�sa
               game_monitorpowersave: boolean;  // j�t�k k�zben mehet-e monitor z�ld-m�dba
               game_stealthmode: boolean;  // bekapcsolhat�-e a lopakod� m�d
               input_mousesens: byte;  // eg�r �rz�kenys�ge
               input_mousereverse: boolean;  // f�gg�egesen ford�tott eg�rmozg�s
               audio_sfx: boolean;  // hangeffektek
               audio_sfxvol: byte;  // hangeffektek er�ss�ge
               audio_music: boolean;  // zene (N/A)
               audio_musicvol: byte;  // zene er�ss�ge (N/A)
               video_lastvideocard: string[128];  // legut�bbi videok�rtya neve
               video_gamma: shortint;  // gamma-korrekci�
               video_renderq: byte;  // megjelen�t�s min�s�ge
               video_debug: boolean;  // graf. motor debug ablaka
               video_res_w: word;  // felbont�s v�zszintesen
               video_res_h: word;  // felbont�s f�gg�legesen
               video_colordepth: byte;  // sz�nm�lys�g
               video_fullscreen: boolean;  // teljes k�perny�
               video_refreshrate: byte;  // friss�t�si frekvencia
               video_vsync: boolean;  // vertik�lis szinkroniz�ci�
               video_zbuffer16bit: boolean;  // 16 bites zbuffer
               video_shading_smooth: boolean;  // GL_SMOOTH �rnyal�si m�d
               video_mipmaps: boolean;  // mipmap-ek gener�l�sa
               video_filtering: byte;  // text�rasz�r�s
               video_simpleitems: boolean;  // mutassa-e a skyboxot
               video_marksonwalls: boolean;  // l�ved�knyomok
               video_motionblur: byte;   // motion blur
               video_lightmaps: boolean;   // f�nyt�rk�pek
             end;

function cfgFileExists(): boolean;
function cfgLoaded(): boolean;
function cfgGetPointerToBuffer(): PCfgData;
procedure cfgAllocBuffer;
procedure cfgReadIntoBuffer;
procedure cfgWriteFromBuffer;
procedure cfgFlushBuffer;
function cfgGetGameMode(): TGameMode;
procedure cfgSetGameMode(gm: TGameMode);
function cfgGetGameGoal(): TGameGoal;
procedure cfgSetGameGoal(gg: TGameGoal);
function cfgGetGameGoalValue(): integer;
procedure cfgSetGameGoalValue(ggvalue: integer);

implementation

const
  CONST_CFG_FILENAME = 'settings.dat';

var
  cfgdata: pcfgdata = nil;
  gamemode: TGameMode;
  gamegoal: TGameGoal;
  gamegoalvalue: integer;


function cfgFileExists(): boolean;
begin
  result := fileExists(CONST_CFG_FILENAME);
end;

function cfgLoaded(): boolean;
begin
  result := assigned(cfgdata);
end;

function cfgGetPointerToBuffer(): PCfgData;
begin
  result := cfgdata;
end;

procedure cfgAllocBuffer;
begin
  if ( not(assigned(cfgdata)) ) then
    begin
      new(cfgdata);
      zeromemory(cfgdata,sizeof(tcfgdata));
    end;
end;

procedure cfgReadIntoBuffer;
var
  filehandle: cardinal;
  bytesread: cardinal;
begin
  if ( not(assigned(cfgdata)) ) then
    begin
      new(cfgdata);
      zeromemory(cfgdata,sizeof(tcfgdata));
    end;
  if ( cfgFileExists() ) then
    begin
      filehandle := createfile(CONST_CFG_FILENAME,GENERIC_READ,0,nil,
                               OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
      readfile(filehandle,cfgdata^,sizeof(TCfgData),bytesread,nil);
      closehandle(filehandle);
    end
   else cfgdata^.game_firstrun := TRUE;
end;

procedure cfgWriteFromBuffer;
var
  filehandle: cardinal;
  byteswritten: cardinal;
begin
  if ( assigned(cfgdata) ) then
    begin
      filehandle := createfile(CONST_CFG_FILENAME,GENERIC_WRITE,0,nil,
                               CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
      writefile(filehandle,cfgdata^,sizeof(TCfgData),byteswritten,nil);
      closehandle(filehandle);
    end;
end;

procedure cfgFlushBuffer;
begin
  if ( assigned(cfgdata) ) then dispose(cfgdata);
end;

function cfgGetGameMode(): TGameMode;
begin
  result := gamemode;
end;

procedure cfgSetGameMode(gm: TGameMode);
begin
  gamemode := gm;
end;

function cfgGetGameGoal(): TGameGoal;
begin
  result := gamegoal;
end;

procedure cfgSetGameGoal(gg: TGameGoal);
begin
  gamegoal := gg;
end;

function cfgGetGameGoalValue(): integer;
begin
  result := gamegoalvalue;
end;

procedure cfgSetGameGoalValue(ggvalue: integer);
begin
  gamegoalvalue := ggvalue;
end;

end.
