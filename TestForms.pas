unit TestForms;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList,
  ShellAPI,
  ExecAppThread, Vcl.ComCtrls, activex,
  ExcecCom_TLB, Vcl.AppEvnts,Generics.Collections, WaiCloseApp, shredunit;


type
 ProcComObject = class(TObject)
   public
    Execs:Iexec;
end;


  TForm1 = class(TForm)
    Button1: TButton;
    FolderSelect: TButtonedEdit;
    Label1: TLabel;
    ImageList1: TImageList;
    Button2: TButton;
    prm: TButtonedEdit;
    labVerify: TLabel;
    ApplicationEvents1: TApplicationEvents;
    listExecution: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
    procedure FolderSelectRightButtonClick(Sender: TObject);
  private
    { Private declarations }
    prcComs:ProcComObject;
  public
    { Public declarations }
    ListExec:TList<ProcIdObject>;
    Execs:IIexec;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses fresultfind, other;

procedure TForm1.ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
var
  procObj,procObjItm: ProcIdObject;
  FinIdx:integer;

begin
//
if ((msg.message = MsgTerminate) And  (msg.hwnd=Handle)) then
Begin

  for procObjItm in ListExec do
  begin
     if procObjItm.procID = msg.wParam then
     begin
       break;
     end;
  end;
  FinIdx := ListExec.IndexOf(procObjItm);
  if FinIdx>=0 then
  begin
     listExecution.Items.Add(' Процесс завершен ' + ListExec.Items[FinIdx].nameproc) ;
     ListExec.Delete(FinIdx);
  end;
 Handled:= true;
End;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Application.CreateForm(TfFindEzec, fFindEzec);
 fFindEzec.Show();

end;



procedure TForm1.Button2Click(Sender: TObject);
var
   proc:integer;
   procObj:ProcIdObject;

begin
  if FolderSelect.Text='' then
  Begin
     ShowMessage('Укажите исполняемый файл');
     exit;
  End;
  if ExtractFileExt( FolderSelect.Text) <>'.exe' then
  Begin
     ShowMessage('Файл не являтся исполняемым');
     exit;
  End;

  if Execs=nil then
    Execs:=CoIexec.Create;


  Execs.ExecApp(FolderSelect.Text, prm.Text, handle, proc);
  procObj:= ProcIdObject.Create;
  procObj.procID:=proc;
  procObj.nameproc := FolderSelect.Text;
  procObj.Closed:=false;
  ListExec.Add(procObj);

  listExecution.Items.Add(FolderSelect.Text + ' запущен');

End;


procedure TForm1.FolderSelectRightButtonClick(Sender: TObject);
begin
 with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoFileMustExist];
    if Execute then
      FolderSelect.Text := FileName;
  finally
    Free;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  listExecution.Items.Clear;
  ListExec:=TList<ProcIdObject>.Create;
end;

procedure TForm1.FormShow(Sender: TObject);
var opisans:CTITDlg;
begin
 labVerify.Caption:='';
 opisans:=CTITDlg.Create();
 opisans.oFile:=ExtractFileDir(Application.ExeName) +'\'+'FindFilesCom.dll';
 opisans.OnFileBrowse();
 labVerify.Caption:='Описание библиотек:'+#13;
 if opisans.foundAndregistered then
   labVerify.Caption := labVerify.Caption + opisans.ResultFind.Text
 else
   labVerify.Caption := labVerify.Caption + 'Библиотека FindFilesCom.dll ' +#13+ 'не найдена или не зарегистрирована.';
 Button1.Enabled :=  opisans.foundAndregistered;
 opisans.Free;

 opisans:=CTITDlg.Create();
 opisans.oFile:=ExtractFileDir(Application.ExeName) +'\'+'ExcecCom.dll';
 opisans.OnFileBrowse();

 labVerify.Caption := labVerify.Caption + #13;

 if opisans.foundAndregistered then
   labVerify.Caption := labVerify.Caption + opisans.ResultFind.Text
 else
   labVerify.Caption := labVerify.Caption + 'Библиотека ExcecCom.dll ' +#13+ 'не найдена или не зарегистрирована.';
 Button2.Enabled :=  opisans.foundAndregistered;

 opisans.Free;


end;

end.
