; Per-user installer. Build via Windows/package.ps1.
#ifndef Version
  #error "Pass the executable version via /DVersion."
#endif
#ifndef Arch
  #error "Pass the executable architecture via /DArch."
#endif
#ifndef Src
  #error "Pass the directory containing Envispeed.exe via /DSrc."
#endif

[Setup]
AppId={{E6D17A3F-B1CB-46D8-9E71-13D9366224EF}
AppName=Envispeed
AppVersion={#Version}
AppVerName=Envispeed {#Version}
AppPublisher=Che Quang Huy
AppPublisherURL=https://github.com/chequanghuyca/envispeed
AppSupportURL=https://github.com/chequanghuyca/envispeed/issues
AppUpdatesURL=https://github.com/chequanghuyca/envispeed/releases
VersionInfoVersion={#Version}
DefaultDirName={localappdata}\Programs\Envispeed
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
MinVersion=10.0.18362
OutputBaseFilename=Envispeed-{#Version}-{#Arch}-Setup
SetupIconFile=..\App\Envispeed.ico
UninstallDisplayIcon={app}\Envispeed.exe
UninstallDisplayName=Envispeed
AppMutex=Local\EnvispeedRunning
LicenseFile=..\..\LICENSE
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
#if Arch == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#elif Arch == "x64"
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#else
  #error "Unsupported Envispeed architecture."
#endif

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1=Cài đặt Envispeed
WelcomeLabel2=Envispeed {#Version} sẽ được cài cho tài khoản của bạn, không cần quyền quản trị.%n%nBấm Next để tiếp tục.
FinishedHeadingLabel=Đã cài xong Envispeed
FinishedLabel=Envispeed nằm ở khay hệ thống (góc dưới bên phải). Bấm Alt+Z để chuyển Anh/Việt.
ConfirmUninstall=Gỡ Envispeed khỏi máy?

[Files]
Source: "{#Src}\Envispeed.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\LICENSE"; DestDir: "{app}"
Source: "..\..\ACKNOWLEDGEMENTS.md"; DestDir: "{app}"

[Icons]
Name: "{autoprograms}\Envispeed"; Filename: "{app}\Envispeed.exe"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueName: "Envispeed"; Flags: uninsdeletevalue dontcreatekey

[Run]
Filename: "{app}\Envispeed.exe"; Description: "Mở Envispeed"; Flags: nowait postinstall skipifsilent
