unit FindFiles24_TLB;

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
// File generated on 26.10.2024 8:28:25 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\VICTOR_TEST\dllForFind\FindFiles24 (1)
// LIBID: {95E1555D-0EA5-45EE-9F33-0D0B9F4361F7}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
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
  FindFiles24MajorVersion = 1;
  FindFiles24MinorVersion = 0;

  LIBID_FindFiles24: TGUID = '{95E1555D-0EA5-45EE-9F33-0D0B9F4361F7}';

  CLASS_FindDiles: TGUID = '{7DB2107B-91AD-4E8F-8CF5-D27BC7D71542}';
  IID_StartFind: TGUID = '{8A05B88E-6D65-4D5C-9498-A944B7A97170}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  StartFind = interface;
  StartFindDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//


// *********************************************************************//
// Interface: StartFind
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A05B88E-6D65-4D5C-9498-A944B7A97170}
// *********************************************************************//
  StartFind = interface(IDispatch)
    ['{8A05B88E-6D65-4D5C-9498-A944B7A97170}']
    procedure Start(Path: PAnsiChar); safecall;
  end;

// *********************************************************************//
// DispIntf:  StartFindDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8A05B88E-6D65-4D5C-9498-A944B7A97170}
// *********************************************************************//
  StartFindDisp = dispinterface
    ['{8A05B88E-6D65-4D5C-9498-A944B7A97170}']
    procedure Start(Path: {NOT_OLEAUTO(PAnsiChar)}OleVariant); dispid 201;
  end;

implementation

uses System.Win.ComObj;

end.

