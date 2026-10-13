; Shared Inno Setup script for the OBS filters by Yasunari Murayama.
;
; Do not compile this file directly: run build-installers.ps1, which passes the
; per-filter values below as /D defines and adds the UTF-8 BOM Inno Setup needs.
;
; Why this installer does not ask "where should the filter go":
; customers install OBS Studio on any drive and in any folder, so guessing
; C:\Program Files\obs-studio put the filter where OBS never looks.
;
;   Automatic mode (default) installs to
;     %ProgramData%\obs-studio\plugins\<plugin>\bin\64bit + \data
;   which OBS Studio reads no matter where OBS itself is installed.
;
;   Manual mode installs inside one OBS folder
;     <obs>\obs-plugins\64bit + <obs>\data\obs-plugins\<plugin>
;   and is meant for portable OBS, which ignores %ProgramData%.
;   The chosen folder is validated (it must contain bin\64bit\obs64.exe).
;
; Older installers (v1.0.0 / v1.0.1) wrote into a guessed OBS folder. They are
; uninstalled first so an old copy can never shadow the new one.

#ifndef PluginId
  #error PluginId is not defined. Use build-installers.ps1.
#endif
#ifndef FilterName
  #error FilterName is not defined. Use build-installers.ps1.
#endif
#ifndef FilterNameEs
  #define FilterNameEs FilterName
#endif
#ifndef AppIdRaw
  #error AppIdRaw is not defined. Use build-installers.ps1.
#endif
#ifndef LegacyAppIds
  #define LegacyAppIds ""
#endif
#ifndef PackageVersion
  #error PackageVersion is not defined. Use build-installers.ps1.
#endif
#ifndef DllPath
  #error DllPath is not defined. Use build-installers.ps1.
#endif
#ifndef DataDir
  #error DataDir is not defined. Use build-installers.ps1.
#endif
#ifndef OutDir
  #define OutDir "."
#endif
#ifndef OutBase
  #define OutBase "OBS-Filter-Windows-Installer-v" + PackageVersion
#endif
#ifndef AppURL
  #define AppURL "https://yasunarimurayama.com/"
#endif

#define AppDisplayName "OBS " + FilterName + " Filter"
; A GUID AppId needs its opening brace doubled in [Setup].
#define AppIdSetup (Copy(AppIdRaw, 1, 1) == "{") ? "{" + AppIdRaw : AppIdRaw

[Setup]
AppId={#AppIdSetup}
AppName={#AppDisplayName}
AppVersion={#PackageVersion}
AppPublisher=Yasunari Murayama
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
DefaultDirName={commonappdata}\obs-studio\plugins\{#PluginId}
DisableDirPage=yes
UsePreviousAppDir=no
DirExistsWarning=no
DisableProgramGroupPage=yes
#ifdef DryRun
PrivilegesRequired=lowest
#else
PrivilegesRequired=admin
#endif
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=no
SetupLogging=yes
OutputDir={#OutDir}
OutputBaseFilename={#OutBase}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName={#AppDisplayName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
Source: "{#DllPath}"; DestDir: "{code:BinDir}"; Flags: ignoreversion
Source: "{#DataDir}\*"; DestDir: "{code:DataDir}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Messages]
english.FinishedLabel=The filter was installed.%n%nOpen OBS Studio, select a video source (for example your camera), open Filters, click + and add "{#FilterName}".%n%nIf it does not appear, run this installer again and choose the other installation option.
spanish.FinishedLabel=El filtro quedó instalado.%n%nAbre OBS Studio, selecciona una fuente de video (por ejemplo tu cámara), abre Filtros, pulsa + y agrega "{#FilterNameEs}".%n%nSi no aparece, vuelve a ejecutar este instalador y elige la otra opción de instalación.

[CustomMessages]
english.ModeCaption=Where is your OBS Studio?
english.ModeDescription=You do not need to know. Automatic works on any drive.
english.ModeAuto=Automatic (recommended): works with OBS Studio installed on any drive or folder
english.ModeManual=I use portable OBS: let me choose the OBS Studio folder
english.ModeFound=OBS Studio found at:%n%1%n%nKeep "Automatic" unless you run OBS from a portable folder (USB drive, unzipped copy).
english.ModeFoundPortable=A portable OBS Studio was found at:%n%1%n%nThe portable option is already selected for it.
english.ModeNotFound=OBS Studio was not found automatically, and that is fine: "Automatic" still works with OBS installed on any drive.%n%nOnly if you run OBS from a portable folder (USB drive, unzipped copy), choose the second option.
english.DirCaption=Choose your OBS Studio folder
english.DirDescription=Only needed for portable OBS.
english.DirSubCaption=Select the main OBS Studio folder: the one that contains the "bin", "data" and "obs-plugins" folders. Any drive works.
english.DirEmpty=Please choose the OBS Studio folder, or go back and select Automatic.
english.DirNotObs=OBS Studio was not found in:%n%1%n%nThe right folder contains bin\64bit\obs64.exe.%n%nClick No to choose another folder (recommended), or go back and select Automatic.%n%nInstall into this folder anyway?
english.ObsRunning=OBS Studio is open. Close it, then click Retry.
english.ObsRunningAbort=OBS Studio is still open. Close OBS Studio and run this installer again.
english.ReadyAuto=Automatic installation (works with OBS on any drive):
english.ReadyManual=Installing inside this OBS Studio folder:
english.ReadyDetected=OBS Studio found on this PC:
english.ReadyNone=OBS Studio was not found automatically. The filter will still load in any normally installed OBS Studio.
spanish.ModeCaption=¿Dónde está tu OBS Studio?
spanish.ModeDescription=No necesitas saberlo. La opción automática funciona en cualquier disco.
spanish.ModeAuto=Automática (recomendada): funciona con OBS Studio instalado en cualquier disco o carpeta
spanish.ModeManual=Uso OBS portátil: quiero elegir la carpeta de OBS Studio
spanish.ModeFound=OBS Studio encontrado en:%n%1%n%nDeja "Automática", a menos que abras OBS desde una carpeta portátil (memoria USB, copia descomprimida).
spanish.ModeFoundPortable=Se encontró un OBS Studio portátil en:%n%1%n%nLa opción portátil ya quedó seleccionada para esa carpeta.
spanish.ModeNotFound=No se encontró OBS Studio automáticamente, y no pasa nada: "Automática" funciona igual con OBS instalado en cualquier disco.%n%nSolo si abres OBS desde una carpeta portátil (memoria USB, copia descomprimida), elige la segunda opción.
spanish.DirCaption=Elige la carpeta de tu OBS Studio
spanish.DirDescription=Solo hace falta para OBS portátil.
spanish.DirSubCaption=Selecciona la carpeta principal de OBS Studio: la que contiene las carpetas "bin", "data" y "obs-plugins". Sirve cualquier disco.
spanish.DirEmpty=Elige la carpeta de OBS Studio, o regresa y selecciona Automática.
spanish.DirNotObs=No se encontró OBS Studio en:%n%1%n%nLa carpeta correcta contiene bin\64bit\obs64.exe.%n%nPulsa No para elegir otra carpeta (recomendado), o regresa y selecciona Automática.%n%n¿Instalar en esta carpeta de todos modos?
spanish.ObsRunning=OBS Studio está abierto. Ciérralo y pulsa Reintentar.
spanish.ObsRunningAbort=OBS Studio sigue abierto. Cierra OBS Studio y vuelve a ejecutar este instalador.
spanish.ReadyAuto=Instalación automática (funciona con OBS en cualquier disco):
spanish.ReadyManual=Se instalará dentro de esta carpeta de OBS Studio:
spanish.ReadyDetected=OBS Studio encontrado en esta PC:
spanish.ReadyNone=No se encontró OBS Studio automáticamente. El filtro cargará igual en cualquier OBS Studio instalado de forma normal.

[Code]
const
  PluginId = '{#PluginId}';
  ThisAppId = '{#AppIdRaw}';
  LegacyAppIds = '{#LegacyAppIds}';
  UninstallKeyBase = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\';
  DRIVE_REMOVABLE = 2;
  DRIVE_FIXED = 3;
  SEM_FAILCRITICALERRORS = 1;

var
  ModePage: TInputOptionWizardPage;
  DirPage: TInputDirWizardPage;
  { Every OBS Studio folder found on this PC, best guess first. }
  Candidates: TStringList;
  { Folders known to run in portable mode because of a --portable argument. }
  PortableHints: TStringList;

function GetDriveType(lpRootPathName: String): Cardinal;
  external 'GetDriveTypeW@kernel32.dll stdcall';
function SetErrorMode(uMode: Cardinal): Cardinal;
  external 'SetErrorMode@kernel32.dll stdcall';

function CleanDir(Dir: String): String;
begin
  Dir := RemoveQuotes(Trim(Dir));
  StringChangeEx(Dir, '/', '\', True);
  Result := RemoveBackslashUnlessRoot(Trim(Dir));
end;

function AutoDir: String;
begin
  Result := ExpandConstant('{commonappdata}\obs-studio\plugins\') + PluginId;
end;

function IsObsDir(const Dir: String): Boolean;
begin
  Result := (Dir <> '') and FileExists(AddBackslash(Dir) + 'bin\64bit\obs64.exe');
end;

function ListHas(List: TStringList; const Dir: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to List.Count - 1 do
    if CompareText(List[I], Dir) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

function IsPortableObs(const Dir: String): Boolean;
begin
  Result := FileExists(AddBackslash(Dir) + 'portable_mode.txt') or
    FileExists(AddBackslash(Dir) + 'obs_portable_mode.txt') or
    FileExists(AddBackslash(Dir) + 'portable_mode') or
    FileExists(AddBackslash(Dir) + 'obs_portable_mode') or
    ListHas(PortableHints, Dir);
end;

procedure AddCandidate(Dir: String);
begin
  Dir := CleanDir(Dir);
  if (Dir = '') or (not IsObsDir(Dir)) or ListHas(Candidates, Dir) then
    Exit;
  Candidates.Add(Dir);
  Log('OBS Studio found: ' + Dir);
end;

{ obs64.exe lives in <root>\bin\64bit, so the root is three levels up. }
function RootFromExe(ExePath: String): String;
var
  P: Integer;
begin
  Result := '';
  ExePath := RemoveQuotes(Trim(ExePath));
  P := Pos('.exe', Lowercase(ExePath));
  if P = 0 then
    Exit;
  ExePath := Copy(ExePath, 1, P + 3);
  if CompareText(ExtractFileName(ExePath), 'obs64.exe') <> 0 then
    Exit;
  Result := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExePath)));
end;

function HasPortableArg(const Args: String): Boolean;
begin
  Result := (Pos('--portable', Lowercase(Args)) > 0) or (Pos(' -p', Lowercase(' ' + Args)) > 0);
end;

procedure AddFromRunningObs;
var
  Locator, Services, Items, Item: Variant;
  I: Integer;
  Root, Cmd: String;
begin
  try
    Locator := CreateOleObject('WbemScripting.SWbemLocator');
    Services := Locator.ConnectServer('.', 'root\CIMV2');
    Items := Services.ExecQuery('SELECT ExecutablePath, CommandLine FROM Win32_Process WHERE Name = ''obs64.exe''');
    for I := 0 to Items.Count - 1 do
    begin
      Item := Items.ItemIndex(I);
      if VarIsNull(Item.ExecutablePath) then
        Continue;
      Root := CleanDir(RootFromExe(Item.ExecutablePath));
      if Root = '' then
        Continue;
      Cmd := '';
      if not VarIsNull(Item.CommandLine) then
        Cmd := Item.CommandLine;
      { Drop the quoted exe path so a folder name cannot look like an argument. }
      StringChangeEx(Cmd, Item.ExecutablePath, '', True);
      if HasPortableArg(Cmd) and not ListHas(PortableHints, Root) then
        PortableHints.Add(Root);
      AddCandidate(Root);
    end;
  except
    Log('Could not query running OBS: ' + GetExceptionMessage);
  end;
end;

procedure AddFromRegistryRoot(RootKey: Integer);
var
  S: String;
begin
  if RegQueryStringValue(RootKey, 'SOFTWARE\OBS Studio', '', S) then
    AddCandidate(S);
  if RegQueryStringValue(RootKey, UninstallKeyBase + 'OBS Studio', 'InstallLocation', S) then
    AddCandidate(S);
  if RegQueryStringValue(RootKey, UninstallKeyBase + 'OBS Studio', 'DisplayIcon', S) then
    AddCandidate(RootFromExe(S));
  if RegQueryStringValue(RootKey, UninstallKeyBase + 'OBS Studio', 'UninstallString', S) then
    AddCandidate(ExtractFileDir(RemoveQuotes(Trim(S))));
end;

procedure AddFromShortcut(const LnkPath: String);
var
  Shell, Lnk: Variant;
  Root, Args: String;
begin
  if not FileExists(LnkPath) then
    Exit;
  try
    Shell := CreateOleObject('WScript.Shell');
    Lnk := Shell.CreateShortcut(LnkPath);
    Root := CleanDir(RootFromExe(Lnk.TargetPath));
    if Root = '' then
      Exit;
    Args := Lnk.Arguments;
    if HasPortableArg(Args) and not ListHas(PortableHints, Root) then
      PortableHints.Add(Root);
    AddCandidate(Root);
  except
    Log('Could not read shortcut ' + LnkPath + ': ' + GetExceptionMessage);
  end;
end;

procedure AddFromShortcutFolder(const Folder: String);
begin
  AddFromShortcut(AddBackslash(Folder) + 'OBS Studio.lnk');
  AddFromShortcut(AddBackslash(Folder) + 'OBS Studio (64bit).lnk');
  AddFromShortcut(AddBackslash(Folder) + 'OBS Studio\OBS Studio.lnk');
  AddFromShortcut(AddBackslash(Folder) + 'OBS Studio\OBS Studio (64bit).lnk');
  AddFromShortcut(AddBackslash(Folder) + 'OBS.lnk');
end;

procedure AddFromSteam;
var
  S: String;
begin
  if RegQueryStringValue(HKLM32, 'SOFTWARE\Valve\Steam', 'InstallPath', S) then
    AddCandidate(AddBackslash(CleanDir(S)) + 'steamapps\common\OBS Studio');
  if RegQueryStringValue(HKCU, 'Software\Valve\Steam', 'SteamPath', S) then
    AddCandidate(AddBackslash(CleanDir(S)) + 'steamapps\common\OBS Studio');
end;

{ Checks every folder directly inside Parent, which catches names such as
  "OBS-Studio-31.1.1-Windows-x64" that nobody can predict. }
procedure ScanChildren(const Parent: String);
var
  FindRec: TFindRec;
begin
  if not DirExists(Parent) then
    Exit;
  if FindFirst(AddBackslash(Parent) + '*', FindRec) then
  try
    repeat
      if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and
         (FindRec.Name <> '.') and (FindRec.Name <> '..') then
        AddCandidate(AddBackslash(Parent) + FindRec.Name);
    until not FindNext(FindRec);
  finally
    FindClose(FindRec);
  end;
end;

procedure AddFromDrives;
var
  C: Integer;
  Root: String;
  DriveType: Cardinal;
begin
  { No "insert a disk" pop-ups for empty card readers. }
  SetErrorMode(SEM_FAILCRITICALERRORS);
  for C := Ord('A') to Ord('Z') do
  begin
    Root := Chr(C) + ':\';
    DriveType := GetDriveType(Root);
    if (DriveType <> DRIVE_FIXED) and (DriveType <> DRIVE_REMOVABLE) then
      Continue;
    if not DirExists(Root) then
      Continue;
    AddCandidate(Root + 'Program Files\obs-studio');
    AddCandidate(Root + 'Program Files (x86)\obs-studio');
    AddCandidate(Root + 'Program Files (x86)\Steam\steamapps\common\OBS Studio');
    AddCandidate(Root + 'Program Files\Steam\steamapps\common\OBS Studio');
    AddCandidate(Root + 'Steam\steamapps\common\OBS Studio');
    AddCandidate(Root + 'SteamLibrary\steamapps\common\OBS Studio');
    AddCandidate(Root + 'Games\Steam\steamapps\common\OBS Studio');
    AddCandidate(Root + 'Games\SteamLibrary\steamapps\common\OBS Studio');
    ScanChildren(Root);
    ScanChildren(Root + 'Program Files');
    ScanChildren(Root + 'Program Files (x86)');
    ScanChildren(Root + 'Programs');
    ScanChildren(Root + 'Programas');
    ScanChildren(Root + 'Apps');
    ScanChildren(Root + 'Tools');
    ScanChildren(Root + 'Games');
    ScanChildren(Root + 'Juegos');
    ScanChildren(Root + 'Portable');
    ScanChildren(Root + 'PortableApps');
  end;
end;

procedure DetectObs;
begin
  { Most reliable first: the first entry becomes the suggested folder. }
  AddFromRunningObs;
  AddFromRegistryRoot(HKLM64);
  AddFromRegistryRoot(HKLM32);
  AddFromRegistryRoot(HKCU);
  AddFromShortcutFolder(ExpandConstant('{commonprograms}'));
  AddFromShortcutFolder(ExpandConstant('{userprograms}'));
  AddFromShortcutFolder(ExpandConstant('{commondesktop}'));
  AddFromShortcutFolder(ExpandConstant('{userdesktop}'));
  AddFromShortcutFolder(ExpandConstant('{userappdata}\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar'));
  AddFromSteam;
  AddFromDrives;
  ScanChildren(ExpandConstant('{userdesktop}'));
  ScanChildren(ExpandConstant('{userdocs}'));
  ScanChildren(AddBackslash(GetEnv('USERPROFILE')) + 'Downloads');
  Log('OBS Studio folders found: ' + IntToStr(Candidates.Count));
end;

{ Turns whatever the customer picked into the OBS root: the folder itself, a
  folder inside OBS (bin\64bit, obs-plugins...), or the folder that holds OBS. }
function FindObsRoot(Dir: String): String;
var
  I: Integer;
  D: String;
  FindRec: TFindRec;
begin
  Result := '';
  Dir := CleanDir(Dir);
  if Dir = '' then
    Exit;
  D := Dir;
  for I := 0 to 3 do
  begin
    if IsObsDir(D) then
    begin
      Result := D;
      Exit;
    end;
    if (ExtractFileDir(D) = D) or (ExtractFileDir(D) = '') then
      Break;
    D := ExtractFileDir(D);
  end;
  if FindFirst(AddBackslash(Dir) + '*', FindRec) then
  try
    repeat
      if (FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and
         (FindRec.Name <> '.') and (FindRec.Name <> '..') and
         IsObsDir(AddBackslash(Dir) + FindRec.Name) then
      begin
        Result := AddBackslash(Dir) + FindRec.Name;
        Exit;
      end;
    until not FindNext(FindRec);
  finally
    FindClose(FindRec);
  end;
end;

function IsManual: Boolean;
begin
  Result := ModePage.SelectedValueIndex = 1;
end;

function TargetObsDir: String;
begin
  Result := FindObsRoot(DirPage.Values[0]);
  if Result = '' then
    Result := CleanDir(DirPage.Values[0]);
end;

function BinDir(Param: String): String;
begin
  if IsManual then
    Result := AddBackslash(TargetObsDir) + 'obs-plugins\64bit'
  else
    Result := AutoDir + '\bin\64bit';
end;

function DataDir(Param: String): String;
begin
  if IsManual then
    Result := AddBackslash(TargetObsDir) + 'data\obs-plugins\' + PluginId
  else
    Result := AutoDir + '\data';
end;

function IsObsRunning: Boolean;
var
  Locator, Services, Items: Variant;
  ResultCode: Integer;
begin
  try
    Locator := CreateOleObject('WbemScripting.SWbemLocator');
    Services := Locator.ConnectServer('.', 'root\CIMV2');
    Items := Services.ExecQuery('SELECT ProcessId FROM Win32_Process WHERE Name = ''obs64.exe''');
    Result := Items.Count > 0;
  except
    Result := Exec(ExpandConstant('{cmd}'), '/C tasklist /FI "IMAGENAME eq obs64.exe" | find /I "obs64.exe"',
      '', SW_HIDE, ewWaitUntilTerminated, ResultCode) and (ResultCode = 0);
  end;
end;

{ Runs the uninstaller of an older release of this filter, wherever it was
  installed, so its copy cannot load instead of the new one. }
procedure RemoveOldInstall(RootKey: Integer; const Id: String);
var
  Key, UninstallString, AppPath: String;
  ResultCode: Integer;
begin
  Key := UninstallKeyBase + Id + '_is1';
  if not RegQueryStringValue(RootKey, Key, 'UninstallString', UninstallString) then
    Exit;
  AppPath := '';
  RegQueryStringValue(RootKey, Key, 'Inno Setup: App Path', AppPath);
  AppPath := CleanDir(AppPath);
  { Already installed with this installer: Inno Setup upgrades it in place. }
  if CompareText(AppPath, AutoDir) = 0 then
    Exit;
  { Manual mode targets one OBS folder; leave other OBS installs alone. }
  if IsManual and (CompareText(AppPath, TargetObsDir) <> 0) then
    Exit;
  UninstallString := RemoveQuotes(Trim(UninstallString));
  if not FileExists(UninstallString) then
  begin
    Log('Removing orphaned uninstall entry: ' + Id);
    RegDeleteKeyIncludingSubkeys(RootKey, Key);
    Exit;
  end;
  Log('Uninstalling older release ' + Id + ' from ' + AppPath);
  if not Exec(UninstallString, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE,
              ewWaitUntilTerminated, ResultCode) then
    Log('Could not run ' + UninstallString + ': ' + SysErrorMessage(ResultCode));
end;

{ Copies left in an OBS folder by hand or by a broken install would load
  before the %ProgramData% copy and hide the update. }
procedure RemoveStrayCopies;
var
  I: Integer;
  Root: String;
begin
  for I := 0 to Candidates.Count - 1 do
  begin
    Root := Candidates[I];
    if IsPortableObs(Root) then
      Continue;
    if FileExists(AddBackslash(Root) + 'obs-plugins\64bit\' + PluginId + '.dll') then
    begin
      Log('Removing old copy from ' + Root);
      DeleteFile(AddBackslash(Root) + 'obs-plugins\64bit\' + PluginId + '.dll');
      DeleteFile(AddBackslash(Root) + 'obs-plugins\64bit\' + PluginId + '.pdb');
      DelTree(AddBackslash(Root) + 'data\obs-plugins\' + PluginId, True, True, True);
    end;
  end;
end;

procedure RemoveOldVersions;
var
  Ids, Id: String;
  P: Integer;
begin
  Ids := ThisAppId + ';' + LegacyAppIds;
  while Ids <> '' do
  begin
    P := Pos(';', Ids);
    if P = 0 then
    begin
      Id := Ids;
      Ids := '';
    end
    else
    begin
      Id := Copy(Ids, 1, P - 1);
      Delete(Ids, 1, P);
    end;
    Id := Trim(Id);
    if Id <> '' then
    begin
      RemoveOldInstall(HKLM64, Id);
      RemoveOldInstall(HKLM32, Id);
    end;
  end;
  if not IsManual then
    RemoveStrayCopies;
end;

procedure InitializeWizard;
var
  Primary, ParamDir, Info: String;
begin
  Candidates := TStringList.Create;
  PortableHints := TStringList.Create;
  DetectObs;

  Primary := '';
  if Candidates.Count > 0 then
    Primary := Candidates[0];

  if Primary = '' then
    Info := CustomMessage('ModeNotFound')
  else if (Candidates.Count = 1) and IsPortableObs(Primary) then
    Info := FmtMessage(CustomMessage('ModeFoundPortable'), [Primary])
  else
    Info := FmtMessage(CustomMessage('ModeFound'), [Primary]);

  ModePage := CreateInputOptionPage(wpWelcome, CustomMessage('ModeCaption'),
    CustomMessage('ModeDescription'), Info, True, False);
  ModePage.Add(CustomMessage('ModeAuto'));
  ModePage.Add(CustomMessage('ModeManual'));
  ModePage.SelectedValueIndex := 0;

  DirPage := CreateInputDirPage(ModePage.ID, CustomMessage('DirCaption'),
    CustomMessage('DirDescription'), CustomMessage('DirSubCaption'), False, '');
  DirPage.Add('');
  DirPage.Values[0] := Primary;

  { The only OBS on this PC is portable, and portable OBS ignores %ProgramData%. }
  if (Candidates.Count = 1) and IsPortableObs(Primary) then
    ModePage.SelectedValueIndex := 1;

  { Support and automated installs: Setup.exe /OBSDIR="D:\path\to\obs" }
  ParamDir := CleanDir(ExpandConstant('{param:OBSDIR|}'));
  if ParamDir <> '' then
  begin
    DirPage.Values[0] := ParamDir;
    ModePage.SelectedValueIndex := 1;
  end;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (PageID = DirPage.ID) and (not IsManual);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  Chosen, Root: String;
begin
  Result := True;
  if CurPageID <> DirPage.ID then
    Exit;
  Chosen := CleanDir(DirPage.Values[0]);
  if Chosen = '' then
  begin
    SuppressibleMsgBox(CustomMessage('DirEmpty'), mbError, MB_OK, IDOK);
    Result := False;
    Exit;
  end;
  Root := FindObsRoot(Chosen);
  if Root <> '' then
    DirPage.Values[0] := Root
  else
    Result := SuppressibleMsgBox(FmtMessage(CustomMessage('DirNotObs'), [Chosen]),
      mbConfirmation, MB_YESNO or MB_DEFBUTTON2, IDNO) = IDYES;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  I: Integer;
begin
  if IsManual then
    Result := CustomMessage('ReadyManual') + NewLine + Space + TargetObsDir + NewLine
  else
    Result := CustomMessage('ReadyAuto') + NewLine + Space + AutoDir + NewLine;
  Result := Result + NewLine;
  if Candidates.Count = 0 then
    Result := Result + CustomMessage('ReadyNone') + NewLine
  else
  begin
    Result := Result + CustomMessage('ReadyDetected') + NewLine;
    for I := 0 to Candidates.Count - 1 do
      Result := Result + Space + Candidates[I] + NewLine;
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  Result := '';
  if IsManual and (TargetObsDir = '') then
  begin
    Result := CustomMessage('DirEmpty');
    Exit;
  end;
  while IsObsRunning do
    if SuppressibleMsgBox(CustomMessage('ObsRunning'), mbError, MB_RETRYCANCEL, IDCANCEL) = IDCANCEL then
    begin
      Result := CustomMessage('ObsRunningAbort');
      Exit;
    end;
  if IsManual then
    Log('Manual mode, OBS folder: ' + TargetObsDir)
  else
    Log('Automatic mode, folder: ' + AutoDir);
  Log('Plugin goes to: ' + BinDir(''));
  Log('Data goes to: ' + DataDir(''));
#ifdef DryRun
  { Test build: report what would happen and stop before touching the PC. }
  Result := 'Dry run: nothing was installed.';
  Exit;
#endif
  RemoveOldVersions;
end;
