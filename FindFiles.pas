unit FindFiles;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, FindFilesCom_TLB, StdVcl, FindLauncher, forms;

type
  TFindFiles = class(TTypedComObject, IFindFiles)
  protected
    launcher:TFindLauncher;
    function Start(const Path, Mask: WideString; Userecurse: SYSINT; const TextToSearch: WideString;
          Hwnd: SYSINT): HResult; winapi;
    function GetLastFinded(var Filename, Diectory: WideString; var Size:int64;var Attr: Integer): HResult;
          winapi;

  end;

implementation

uses ComServ, shredunit, ThreadFind;

function TFindFiles.Start(const Path, Mask: WideString; Userecurse: SYSINT; const TextToSearch: WideString;
          Hwnd: SYSINT): HResult;
begin
  launcher := TFindLauncher.Create();
  launcher.ExecFind(Mask, Path, Userecurse=1, TextToSearch, Hwnd, nil);

end;

function TFindFiles.GetLastFinded(var Filename, Diectory: WideString; var Size:int64;var Attr: Integer): HResult;

var itemThread:TTreadFind;
     itemfounded:TfindObjet;
begin

  Filename:='';
  for itemThread in launcher.ListThread do
  begin
    if itemThread.ListFinded.Count>0 then
    Begin
        itemfounded := itemThread.ListFinded.Items[0];
        Filename := itemfounded.Filename;
        Diectory := itemfounded.basePath;
        Attr :=  itemfounded.attr;
        Size :=  itemfounded.size;
        itemThread.ListFinded.Delete(0);
    End;
  end;
end;

initialization
  TTypedComObjectFactory.Create(ComServer, TFindFiles, Class_FindFiles,
    ciMultiInstance, tmApartment);
end.
