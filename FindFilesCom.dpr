library FindFilesCom;

uses
  ComServ,
  FindFilesCom_TLB in 'FindFilesCom_TLB.pas',
  FindFiles in 'FindFiles.pas' {FindFiles: CoClass},
  shredunit in 'shredunit.pas',
  FindLauncher in 'FindLauncher.pas',
  ThreadFind in 'ThreadFind.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.TLB}

{$R *.RES}

begin
end.
