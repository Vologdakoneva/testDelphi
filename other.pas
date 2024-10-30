unit other;

interface

uses activex, Vcl.ComCtrls, System.SysUtils, system.Types, Windows,System.Classes;

type
CTITDlg = class
public
  oFile:string;
  ResultFind:TStringList;
  foundAndregistered:boolean;
  procedure OnFileBrowse;
  procedure GetTypeDesc( vt : TVarType; var strDesc : String);
  procedure DumpFunc( var strNode : String; ind:integer; pti : ITypeInfo; pfuncdesc : PFuncDesc; pattr : PTypeAttr; memid : TMemberID);
  function DumpATL( strDump : String; bImpl : Boolean; iInvKind : integer):String;
  constructor create;
const
  MAX_NAMES = 64;   // max parameters to a function;

end;

implementation



{ CTITDlg }



procedure CTITDlg.OnFileBrowse;
var
  strFilter : String;
  iLib      : ITypeLib;
  n,
  m,
  nCount    : cardinal;
  iInfo     : ITypeInfo;
  pTypeAttrs : PTypeAttr;
  pFuncInfo : PFuncDesc;
  strFmt,
  strNode   : string;
  strName, docstring,helpfile   : PWideString;
   helpcontext:PLongint;
  hNode,
  hFunction : TTreeNode;
  CComBSTR : String;
  strGuid  : string;
  k:integer;
begin
  foundAndregistered:=true;
  if FAILED(LoadTypeLib(StringToOleStr( oFile ), iLib )) then
  begin
     // write (' \"\ncontains no registered type library."), _T("Error'),
     foundAndregistered:=false;
    Exit
  end;


  nCount := iLib.GetTypeInfoCount();
  iInfo := nil;
  for n := 0 to nCount-1 do
  begin
    if FAILED(iLib.GetTypeInfo(n, iInfo)) then
      continue;
    if FAILED(iInfo.GetTypeAttr(pTypeAttrs))  then
    begin
      //iInfo.Release();
      continue;
    end;
    new(strName);
        new(docstring);
            new(strName);
                new(helpcontext);
                new(helpfile);

    iLib.GetDocumentation(n, strName, docstring, helpcontext,helpfile);

    strNode := strName^;
    ////////SysFreeString(pwidechar(strName));
    CComBSTR := GUIDToString(pTypeAttrs.guid);
    strGuid := UpperCase( CComBSTR );
    strNode  := strNode + strGuid;
    case pTypeAttrs.typekind of
    TKIND_ENUM:  strFmt := 'Enumeration';
    TKIND_RECORD:  strFmt := 'Record';
    TKIND_MODULE:  strFmt := 'Module';
    TKIND_INTERFACE:  strFmt := 'Interface';
    TKIND_DISPATCH:  strFmt := 'Dispatch interface';
    TKIND_COCLASS:  strFmt := 'Coclass';
    TKIND_ALIAS:  strFmt := 'Alias';
    TKIND_UNION:  strFmt := 'Union';
    else strFmt := '*** Unknown type ***';
    end;
    strNode := strFmt + ' ' + strNode;
      ResultFind.Add(strNode);
    /// treeview  hNode := m_wndTree.Items.InsertNode(strNode);
    if ((pTypeAttrs.typekind = TKIND_INTERFACE)  or
      (pTypeAttrs.typekind = TKIND_DISPATCH)) then begin
      /// Цикл по функциям (Методам)
      for m := 0 to pTypeAttrs.cFuncs-1 do
      begin
        if FAILED(iInfo.GetFuncDesc(m, pFuncInfo  )) then
          break;
        begin
        iInfo.GetDocumentation(pFuncInfo.memid, strName, nil, nil,
          nil);
        strNode := strName^;

        case pFuncInfo.invkind of
        INVOKE_FUNC:  strFmt := 'Function';
        INVOKE_PROPERTYGET:  strFmt := 'Property access';
        INVOKE_PROPERTYPUT:  strFmt := 'Property assign';
        INVOKE_PROPERTYPUTREF:
          strFmt := 'Property assign by reference';

        else strFmt := '*** Unknown function type ***';
        end;
         GetTypeDesc(pFuncInfo.elemdescFunc.tdesc.vt, strFmt);
        strNode := strFmt;// + ' ' + strNode + ' ';
        end;
        DumpFunc(strNode, pFuncInfo.cParams, iInfo, pFuncInfo, pTypeAttrs,
          pFuncInfo.memid);
          ResultFind.Add(strNode);
        begin
      end;

      end;
    end
    else
    iInfo.ReleaseTypeAttr(pTypeAttrs);
    iInfo:=nil;
  end;
  //iLib._Release();
end;


procedure CTITDlg.GetTypeDesc( vt : TVarType; var strDesc : String);
begin
  case vt of
  VT_EMPTY:  strDesc := 'void';
  VT_NULL:  strDesc := 'nil';
  VT_I2:  strDesc := 'short';
  VT_I4:  strDesc := 'long';
  VT_R4:  strDesc := 'single';
  VT_R8:  strDesc := 'double';
  VT_CY:  strDesc := 'CURRENCY';
  VT_DATE:  strDesc := 'DATE';
  VT_BSTR:  strDesc := 'BSTR';
  VT_DISPATCH:  strDesc := 'IDispatch*';
  VT_ERROR:  strDesc := 'SCODE';
  VT_BOOL:  strDesc := 'BOOL';
  VT_VARIANT:  strDesc := 'VARIANT';
  VT_UNKNOWN:  strDesc := 'IUnknown*';
  VT_I1:  strDesc := 'char';
  VT_UI1:  strDesc := 'unsigned char';
  VT_UI2:  strDesc := 'unsigned short';
  VT_UI4:  strDesc := 'unsigned long';
  VT_I8:  strDesc := 'int64';
  VT_UI8:  strDesc := 'uint64';
  VT_INT:  strDesc := 'int';
  VT_UINT:  strDesc := 'unsigned int';
  VT_VOID:  strDesc := 'void';
  VT_HRESULT:  strDesc := 'HRESULT';
  VT_PTR:  strDesc := 'void*';
  VT_SAFEARRAY:  strDesc := 'SAFEARRAY';
  VT_CARRAY:  strDesc := 'CARRAY';
  VT_USERDEFINED:  strDesc := 'USERDEFINED';
  VT_LPSTR:  strDesc := 'LPSTR';
  VT_LPWSTR:  strDesc := 'LPWSTR';
  VT_FILETIME:  strDesc := 'FILETIME';
  VT_BLOB:  strDesc := 'BLOB';
  VT_STREAM:  strDesc := 'STREAM';
  VT_STORAGE:  strDesc := 'STORAGE';
  VT_STREAMED_OBJECT:  strDesc := 'STREAMED_OBJECT';
  VT_STORED_OBJECT:  strDesc := 'STORED_OBJECT';
  VT_BLOB_OBJECT:  strDesc := 'BLOB_OBJECT';
  VT_CF:  strDesc := 'CF';
  VT_CLSID:  strDesc := 'CLSID';
  else strDesc := 'Unknown type ';
  end;

end;


procedure CTITDlg.DumpFunc(var strNode : String; ind:integer; pti : ITypeInfo; pfuncdesc : PFuncDesc; pattr : PTypeAttr; memid : TMemberID);
var
  hr          : HRESULT;
  /// rgbstrNames : array[0..(MAX_NAMES)-1] of PBStrList;
  rgbstrNames : PBStrList;
  bstrName,
  bstrDoc,
  bstrHelp    : PWideString;
  dwHelpID    : PLongint;
  fAttributes,
  fAttribute  : Boolean;
  str         : String;
  lpszDoc     : LPCTSTR;
  cNames      : integer;
  n , ui          : integer;
  strFmt:string;
begin
  hr := S_OK;
//  FUNCDESC*  pfuncdesc = nil;
  bstrName := nil;
  bstrDoc := nil;
  bstrHelp := nil;
  ///// ????? Assert(pti);

  for ui := 0 to MAX_NAMES do ;
    /// ??????? rgbstrNames[ui] := nil;
  TRY
  begin
//    if (FAILED(hr = pti.GetFuncDesc(memid, &pfuncdesc)))
//      AfxThrowOleException(hr);
    fAttributes := false;
    fAttribute := false;
    ///////strNode := '';
    if pattr.typekind = TKIND_DISPATCH then begin
      fAttributes := TRUE;
      fAttribute := TRUE;
      str := str + 'id(' + inttostr(memid)+ ')';
      strNode  := strNode + str;
    end
    else
    if (pattr.typekind = TKIND_MODULE) then
    begin
      fAttributes := TRUE;
      fAttribute := TRUE;
      str := str +'[entry('+IntToStr(memid)+')';
      strNode  := strNode + str;
    end
    else
      // if there are some attributes
      if ((pfuncdesc.invkind > 1) or (pfuncdesc.wFuncFlags>0)  or (pfuncdesc.cParamsOpt = -1) and (ui>0)) then
      begin
        //strNode  := strNode + '[';
        fAttributes := TRUE;
      end;
    if pfuncdesc.invkind = INVOKE_PROPERTYGET then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'propget';
    end;
    if pfuncdesc.invkind = INVOKE_PROPERTYPUT then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'propput';
    end;
    if pfuncdesc.invkind = INVOKE_PROPERTYPUTREF then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'propputref';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FRESTRICTED then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'restricted';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FSOURCE then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'source';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FBINDABLE then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'bindable';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FREQUESTEDIT then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'requestedit';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FDISPLAYBIND then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'displaybind';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FDEFAULTBIND then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'defaultbind';
    end;
    if pfuncdesc.wFuncFlags = FUNCFLAG_FHIDDEN then begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'hidden';
    end;
    if pfuncdesc.cParamsOpt = -1 then // cParamsOpt > 0 indicates VARIANT style
    begin
      if fAttribute then
        strNode  := strNode + ', ';
      fAttribute := TRUE;
      strNode  := strNode + 'vararg';
    end;
    new(bstrName);
    new(bstrDoc);
    new(dwHelpID);
    new(bstrHelp);

    if SUCCEEDED(pti.GetDocumentation(pfuncdesc.memid, bstrName, bstrDoc, dwHelpID, bstrHelp )) then
    begin
      if (bstrDoc <> NullWideStr) then  ///bstrDoc  and  *bstrDoc
      begin
        if fAttributes = FALSE then
           strNode  := strNode// + '['
        else
          fAttributes := TRUE;
        if fAttribute then strNode  := strNode + ', ';
        bstrDoc := nil;
        strNode  := strNode + str;
      end
      else
      if (dwHelpID <> nil) then
      begin
        if fAttributes = FALSE then strNode  := strNode + '[';
        if fAttribute then strNode  := strNode + ', ';
        fAttributes := TRUE;
      end;
    end;
    cNames := 0;
    new(rgbstrNames);
    if FAILED( pti.GetNames(pfuncdesc.memid, rgbstrNames, MAX_NAMES, cNames  )) then
    begin
      /// AfxThrowOleException(hr);
    end;
    strNode  := strNode + (rgbstrNames[0]);
    strNode  := strNode + '(';
    for n := 0 to ind-1 do
    begin
      fAttributes := FALSE;
      fAttribute := FALSE;
      if pfuncdesc.lprgelemdescParam[n].idldesc.wIDLFlags>0 then begin
        strNode  := strNode + '[';
        fAttributes := TRUE;
      end;
      if (pfuncdesc.lprgelemdescParam[n].idldesc.wIDLFlags and IDLFLAG_FIN > 0 ) then begin
        if fAttribute then
          strNode  := strNode + ', ';
        strNode  := strNode + 'in';
        fAttribute := TRUE;
      end;

      if (pfuncdesc.lprgelemdescParam[n].idldesc.wIDLFlags and IDLFLAG_FOUT > 0) then begin ////IDLFLAG_FOUT
        if fAttribute then
          strNode  := strNode + ', ';
        strNode  := strNode + 'out';
        fAttribute := TRUE;
      end;
      if pfuncdesc.lprgelemdescParam[n].idldesc.wIDLFlags = IDLFLAG_FLCID then begin
        if fAttribute then
          strNode  := strNode + ', ';
        strNode  := strNode + 'lcid';
        fAttribute := TRUE;
      end;
      if pfuncdesc.lprgelemdescParam[n].idldesc.wIDLFlags = IDLFLAG_FRETVAL then begin
        if fAttribute then
          strNode  := strNode + ', ';
        strNode  := strNode + 'retval';
        fAttribute := TRUE;
      end;
      if ((pfuncdesc.cParamsOpt = -1)  and  (n = pfuncdesc.cParams - 1)  or
         (n > (pfuncdesc.cParams - pfuncdesc.cParamsOpt))) then
      begin
        if fAttribute then
          strNode  := strNode + ', ';
        if  not fAttributes then strNode  := strNode + '[';
        strNode  := strNode + 'optional';
        fAttributes := TRUE;
        fAttribute := TRUE;
      end;
      if fAttributes then strNode  := strNode + '] ';
      GetTypeDesc(pfuncdesc.lprgelemdescParam[n].tdesc.vt, strFmt);
        strNode := strNode + ' ' + strFmt;

      begin
        ///strNode := strNode + TYPEDESCtoString(pti, pfuncdesc.
        ///  lprgelemdescParam[n].tdesc) + ' ';
        /// strNode  := strNode + (rgbstrNames[n + 1]);
      end;
      if n < pfuncdesc.cParams - 1 then strNode  := strNode + ', ';
    end;
    strNode  := strNode + ');';
  end;


     FINALLY
  end;
end;




constructor CTITDlg.create;
begin
  inherited;
  ResultFind:=TStringList.Create;
end;

function CTITDlg.DumpATL( strDump : String; bImpl : Boolean; iInvKind : integer):String;
var
  strRet,strPrefix        : String;
  iPos          : integer;
  strTypeRet,
  strMethodName : String;
begin
end;








end.

