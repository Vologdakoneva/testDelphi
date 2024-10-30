program MainLaunch;

uses
  Vcl.Forms,
  TestForms in 'TestForms.pas' {Form1},
  fresultfind in 'fresultfind.pas' {fFindEzec},
  shredunit in 'shredunit.pas',
  other in 'other.pas',
  MainLaunch_TLB in 'MainLaunch_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
