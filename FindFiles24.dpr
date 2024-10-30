library FindFiles24;

uses
  ComServ,
  FindFiles24_TLB in 'FindFiles24_TLB.pas',
  FindFiles24Real in 'FindFiles24Real.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.RES}

begin
end.
