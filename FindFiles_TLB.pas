unit FindFiles_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 98336 $
// File generated on 26.10.2024 8:07:29 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\VICTOR_TEST\dllForFind\FindFiles (1)
// LIBID: {6400C56B-1F40-4404-898D-AFF005BFABF1}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Member 'StartFind' of 'StartFind' changed to 'StartFind_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  FindFilesMajorVersion = 1;
  FindFilesMinorVersion = 0;

  LIBID_FindFiles: TGUID = '{6400C56B-1F40-4404-898D-AFF005BFABF1}';

  IID_StartFind: TGUID = '{8976C0AC-6751-4503-BEB9-4394922209D8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  StartFind = interface;
  StartFindDisp = dispinterface;

// *********************************************************************//
// Interface: StartFind
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8976C0AC-6751-4503-BEB9-4394922209D8}
// *********************************************************************//
  StartFind = interface(IDispatch)
    ['{8976C0AC-6751-4503-BEB9-4394922209D8}']
    procedure StartFind_; safecall;
    function Get_Property1: Integer; safecall;
    procedure Set_Property1(Value: Integer); safecall;
    property Property1: Integer read Get_Property1 write Set_Property1;
  end;

// *********************************************************************//
// DispIntf:  StartFindDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8976C0AC-6751-4503-BEB9-4394922209D8}
// *********************************************************************//
  StartFindDisp = dispinterface
    ['{8976C0AC-6751-4503-BEB9-4394922209D8}']
    procedure StartFind_; dispid 201;
    property Property1: Integer dispid 202;
  end;

implementation

uses System.Win.ComObj;

end.

