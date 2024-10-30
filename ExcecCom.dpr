library ExcecCom;

uses
  ComServ,
  ExcecCom_TLB in 'ExcecCom_TLB.pas',
  execUnit in 'execUnit.pas' {Iexec: CoClass},
  shredunit in 'shredunit.pas',
  WaitCloses in 'WaitCloses.pas',
  WaiCloseApp in 'WaiCloseApp.pas';

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
