unit fresultfind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList,
  ThreadFind, Vcl.AppEvnts,
  FindFilesCom_TLB,
  Registry;
type
 TfindObjet = class(TObject)
 public
   seaerchrec:TSearchRec;
   basePath:string;
 end;

type
  TCallbackEvent = procedure(Sender: TfindObjet) of object;
  TfunctionExec = function(Pattern, startpath:string;useRecurce:boolean; textTofind:string; CallBackFunc:TCallbackEvent) :TTreadFind; stdcall;

  TfFindEzec = class(TForm)
    Button1: TButton;
    ResList: TListView;
    FolderSelect: TButtonedEdit;
    ImageList1: TImageList;
    patternEdit: TButtonedEdit;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    chRecurse: TCheckBox;
    chText: TCheckBox;
    textfind: TEdit;
    ApplicationEvents1: TApplicationEvents;
    procedure Button1Click(Sender: TObject);
    procedure FolderSelectRightButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ResListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure chTextClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
  private
    { Private declarations }
    functionExec:TfunctionExec;
    procedure terminate;
  public
    { Public declarations }
    threadserch:TTreadFind;
    Ifnds:IFindFiles;
    procedure CallbackFromDll(Sender: TfindObjet);
  end;

var
  fFindEzec: TfFindEzec;

implementation

{$R *.dfm}

uses shredunit,
  ActiveX,
  ComObj;


 function GetTypeStr(tdesc : TTypeDesc; Context : ActiveX.ITypeinfo):string;
var
  tinfo    : ActiveX.ITypeInfo;
  bstrName : WideString;
begin
   case tdesc.vt of
     VT_PTR   : Result:=GetTypeStr(tdesc.ptdesc^,Context);
     VT_ARRAY : Result:=Format('Array of %s',[GetTypeStr(tdesc.padesc^.tdescElem,Context)]);
     VT_USERDEFINED : begin
                        context.GetRefTypeInfo(tdesc.hreftype, tinfo);
                        tinfo.GetDocumentation(-1, @bstrName, nil, nil, nil);
                        Result:=bstrName;
                      end
   else
     Result:=VarTypeAsText(tdesc.vt);
   end;
end;


//http://msdn.microsoft.com/en-us/magazine/dd347981.aspx
Procedure InspectCOMOnbject(const ClassName: string);
Var
  ComObject     : OleVariant;
  Dispatch      : IDispatch;
  Count         : Integer;
  i,j,k         : Integer;
  Typeinfo      : ActiveX.ITypeinfo;
  ptypeattr     : ActiveX.PTypeAttr;
  pfuncdesc     : ActiveX.PFuncDesc;//http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.vswizard.tagfuncdesc.aspx
  rgbstrNames   : TBStrList;
  cNames        : Integer;
  bstrName      : WideString;
  bstrDocString : WideString;
  sValue        : string;
  sinvkind      : string;
begin

  ComObject     := CreateOleObject(ClassName);
  Dispatch      := IUnknown(ComObject) as IDispatch;
  OleCheck(Dispatch.GetTypeInfoCount(Count));
  for i := 0 to Count-1 do
    begin
       OleCheck(Dispatch.GetTypeInfo(i,0,Typeinfo));
       OleCheck(Typeinfo.GetTypeAttr(ptypeattr));
       try
        case ptypeattr^.typekind of
         TKIND_INTERFACE,
         TKIND_DISPATCH :
          begin
            for j:=0 to ptypeattr^.cFuncs-1 do
            begin
               OleCheck(Typeinfo.GetFuncDesc(j, pfuncdesc));
               try
                 OleCheck(Typeinfo.GetNames(pfuncdesc.memid, @rgbstrNames, pfuncdesc.cParams + 1, cNames));
                 OleCheck(Typeinfo.GetDocumentation(pfuncdesc.memid,@bstrName,@bstrDocString,nil,nil));

                 if 1=1 then //pfuncdesc.elemdescFunc.tdesc.vt<>$0018 then
                 begin
                   //pfuncdesc.elemdescFunc.paramdesc
                   case pfuncdesc.invkind of
                    INVOKE_FUNC           : if pfuncdesc.elemdescFunc.tdesc.vt = VT_VOID then sinvkind :='procedure' else sinvkind :='function';
                    INVOKE_PROPERTYGET    : sinvkind :='get property';
                    INVOKE_PROPERTYPUT    : sinvkind :='put property';
                    INVOKE_PROPERTYPUTREF : sinvkind :='ref property';
                   else
                     sinvkind :='unknow';
                   end;


                    {
                   if bstrDocString<>'' then
                    Writeln(Format('// %s',[bstrDocString]));
                     }
                    if pfuncdesc.cParams<=1 then
                    begin
//                       if pfuncdesc.elemdescFunc.tdesc.vt = VT_VOID then
//                        Writeln(Format('%s %s;',[sinvkind,bstrName]))
//                       else
//                        Writeln(Format('%s %s : %s;',[sinvkind,bstrName,GetTypeStr(pfuncdesc.elemdescFunc.tdesc, Typeinfo)]));
                    end
                    else
                    begin
                      sValue:='';
                      for k := 1 to pfuncdesc.cParams do
                      begin
                        //Writeln(Format('%s : %d',[rgbstrNames[k], pfuncdesc.lprgelemdescParam[k-1].tdesc.vt]));
                        sValue:= sValue + Format('%s : %s',[rgbstrNames[k], GetTypeStr(pfuncdesc.lprgelemdescParam[k-1].tdesc,Typeinfo)]);
                        if k<pfuncdesc.cParams then
                          sValue:=sValue+';';
                      end;

//                      if pfuncdesc.elemdescFunc.tdesc.vt = VT_VOID then
//                        Writeln(Format('%s %s (%s);',[sinvkind, bstrName, sValue]))
//                      else
//                        Writeln(Format('%s %s (%s) : %s;',[sinvkind, bstrName,SValue,GetTypeStr(pfuncdesc.elemdescFunc.tdesc, Typeinfo)]))
                    end;
                      //Writeln(pfuncdesc.elemdescFunc.tdesc.vt);
                 end;
               finally
                 Typeinfo.ReleaseFuncDesc(pfuncdesc);
               end;
            end;
          end;
        end;
       finally
          Typeinfo.ReleaseTypeAttr(ptypeattr);
       end;
    end;
end;

procedure xxxx(FullPathToDLL:Pwidechar);
type
  T_DGCO = function(const CLSID, IID: TGUID; var Obj): HResult; stdcall; //DllGetClassObject
var
  p: T_DGCO;
  f: IClassFactory;
  //x: IMyObject; //replace by an interface of choice
begin
  p := GetProcAddress(LoadLibrary(FullPathToDLL), 'DllGetClassObject');
  //Win32Check(p <> nil);
  //OleCheck(p(CLASS_MyObject, IClassFactory, f));
  //OleCheck(f.CreateInstance(nil, IMyObject, x));
  //x.Hello('World'); //or whatever your object does
end;


procedure TfFindEzec.ApplicationEvents1Message(var Msg: TMsg;
  var Handled: Boolean);
var Filename, Diectory: WideString;
    Sizes: int64;
    Attr:integer;
    Item:TListItem;
begin
//
if ((msg.message = MsgFind) And  (msg.hwnd=Handle)) then
Begin
  repeat
     Ifnds.GetLastFinded(Filename, Diectory, Sizes, Attr);
       Item:=ResList.Items.Add;
       Item.Caption := Filename;
       Item.SubItems.Add(Diectory);
       if Attr = faDirectory then
         Item.ImageIndex:=2 else
       Begin
         Item.ImageIndex:=-1;
         Item.SubItems.Add(IntToStr(Sizes));
       End;

  until Filename<>'';
  Handled:= true;
End;
end;

procedure TfFindEzec.Button1Click(Sender: TObject);
 var libh:integer;
     paternToRealy:string;
begin
 paternToRealy := patternEdit.Text;
 if paternToRealy = ''  then
    paternToRealy := '*';
Ifnds:=CoFindFiles.Create;
Ifnds.Start(ExcludeTrailingBackslash( FolderSelect.Text ),paternToRealy, 1, '',Handle);

end;

procedure TfFindEzec.FolderSelectRightButtonClick(Sender: TObject);

begin
 with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      FolderSelect.Text := FileName;
  finally
    Free;
  end;

end;

procedure TfFindEzec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := TCloseAction.caFree;
end;

function IsRegistered (const AClassName: string): Boolean;
var
 Dummy: TGuid;
begin
 Result := Succeeded(CLSIDFromProgID (PWideChar(WideString(AClassName)),Dummy))
end;


function RecurseWin32(const R: TRegistry; const ThePath: string;
   const TheKey: string): string;
 var
   TheList: TStringList;
   i: Integer;
   LP: string;
   OnceUponATime: string;
 begin
   Result  := '-';
   TheList := TStringList.Create;
   try
     R.OpenKey(ThePath, False);
     R.GetKeyNames(TheList);
     R.CloseKey;
     if TheList.Count = 0 then Exit;
     for i := 0 to TheList.Count - 1 do with TheList do
        begin
         LP := ThePath + '\' + TheList[i];
         if CompareText(Strings[i], TheKey) = 0 then
          begin
           Result := LP;
           Break;
         end;
         OnceUponATime := RecurseWin32(R, LP, TheKey);
         if OnceUponATime <> '-' then
          begin
           Result := OnceUponATime;
           Break;
         end;
       end;
   finally
     TheList.Clear;
     TheList.Free;
   end;
 end;

 { Create the output list: you may change the format as you need ...}

 function GetWin32TypeLibList(var Lines: TStringList): Boolean;
 var
    R: TRegistry;
   W32: string;
   i, j, TheIntValue, TheSizeOfTheIntValue: Integer;
   TheSearchedValue, TheSearchedValueString: string;
   TheVersionList, TheKeyList: TStringList;
   TheBasisKey: string;
 begin
   Result := True;
   try
     try
       R          := TRegistry.Create;
       TheVersionList := TStringList.Create;
       TheKeyList := TStringList.Create;

       R.RootKey := HKEY_CLASSES_ROOT;
       R.OpenKey('TypeLib', False);
       TheBasisKey := R.CurrentPath;

       (* Basis Informations *)
       case R.GetDataType('') of
        // rdUnknown: ShowMessage('Nothing ???');
         rdExpandString, rdString: TheSearchedValueString := R.ReadString('');
         rdInteger: TheIntValue         := R.ReadInteger('');
         rdBinary: TheSizeOfTheIntValue := R.GetDataSize('');
       end;
       (* Build the List of Keys *)
       R.GetKeyNames(TheKeyList);
       R.CloseKey;
       ShowMessage(TheKeyList.Strings[1]);
       for i := 0 to TheKeyList.Count - 1 do
          (* Loop around the typelib entries)
          (* Schleife um die TypeLib Eintrage *)
         with TheKeyList do
           if Length(Strings[i]) > 0 then
            begin
             R.OpenKey(TheBasisKey + '\' + Strings[i], False);
             TheVersionList.Clear;
             R.GetKeyNames(TheVersionList);
             R.CloseKey;
             (* Find "Win32" for each version *)
             (* Finde der "win32" fur jede VersionVersion:*)
             for j := 0 to TheVersionList.Count - 1 do
               if Length(TheVersionList.Strings[j]) > 0 then
                begin
                 W32 := RecurseWin32(R, TheBasisKey + '\' +
                   Strings[i] + '\' +
                   TheVersionList.Strings[j],
                   'Win32');
                 if W32 <> '-' then
                  begin
                   Lines.Add(W32);
                   R.OpenKey(W32, False);
                   case R.GetDataType('') of
                     rdExpandString,
                     rdString: TheSearchedValue := R.ReadString('');
                     else
                       TheSearchedValue := 'Nothing !!!';
                   end;
                   R.CloseKey;
                   Lines.Add('-----> ' + TheSearchedValue);
                 end;
               end;
           end;
     finally
       TheVersionList.Free;
       TheKeyList.Free;
     end;
   except
     Result := False;
   end;
 end;

procedure TfFindEzec.FormShow(Sender: TObject);
begin
  ResList.Items.Clear;
end;

procedure TfFindEzec.ResListCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);

begin

    Compare := CompareText(inttostr(Item1.ImageIndex*-1)+Item1.Caption,inttostr(Item2.ImageIndex*-1)+Item2.Caption)


end;

procedure TfFindEzec.terminate;
begin
  if assigned(threadserch) then
  Begin
    threadserch.Free;
    threadserch:=nil;
  End;
end;

procedure TfFindEzec.Button2Click(Sender: TObject);
begin
//
terminate;
end;

procedure TfFindEzec.CallbackFromDll(Sender: TfindObjet);
var findObjet:TfindObjet;
     sss:string;
     Item:TListItem;
begin
   Item:=ResList.Items.Add;
   Item.Caption := Sender.seaerchrec.Name;
   if Sender.seaerchrec.Attr = faDirectory then
     Item.ImageIndex:=2 else Item.ImageIndex:=-1;
   Item.SubItems.Add(Sender.basePath);

//   ResList.AlphaSort;
end;

procedure TfFindEzec.chTextClick(Sender: TObject);
begin
  textfind.Enabled := chText.Checked;
  if not chText.Checked then
    textfind.Text:='';
end;

end.
