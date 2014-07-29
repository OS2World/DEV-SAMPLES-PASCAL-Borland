
{*******************************************************}
{                                                       }
{       Turbo Pascal Version 7.0                        }
{       Turbo Vision Unit                               }
{                                                       }
{       Copyright (c) 1992 Borland International        }
{                                                       }
{*******************************************************}

unit Memory;

{$O+,F+,X+,I-,S-,Q-}

interface

const
  MaxHeapSize: Longint = $100000;          {  16M }
  LowMemSize: Word = 4096 div 16;       {   4K }
  MaxBufMem: Word = 65536 div 16;       {  64K }

procedure InitMemory;
procedure DoneMemory;
procedure InitDosMem;
procedure DoneDosMem;
function LowMemory: Boolean;
function MemAlloc(Size: Word): Pointer;
function MemAllocSeg(Size: Word): Pointer;
procedure NewCache(var P: Pointer; Size: Word);
procedure DisposeCache(P: Pointer);
procedure NewBuffer(var P: Pointer; Size: Word);
procedure DisposeBuffer(P: Pointer);
function GetBufferSize(P: Pointer): Word;
function SetBufferSize(P: Pointer; Size: Word): Boolean;

implementation

uses
  OS2Def, BSEDos;

type
  PtrRec = record
    Ofs, Seg: Word;
  end;

type
  PCache = ^TCache;
  TCache = record
    Next: PCache;
    Master: ^Pointer;
    Data: record end;
  end;

const
  CacheList: PCache = nil;
  SafetyPool: Pointer = nil;
  SafetyPoolSize: Word = 0;
  DisablePool: Boolean = False;

function FreeCache: Boolean;
begin
  FreeCache := False;
  if CacheList <> nil then
  begin
    DisposeCache(CacheList^.Next^.Master^);
    FreeCache := True;
  end;
end;

function FreeSafetyPool: Boolean;
begin
  FreeSafetyPool := False;
  if SafetyPool <> nil then
  begin
    FreeMem(SafetyPool, SafetyPoolSize);
    SafetyPool := nil;
    FreeSafetyPool := True;
  end;
end;

function HeapNotify(Size: Word): Integer; far;
begin
  if FreeCache then HeapNotify := 2 else
    if DisablePool then HeapNotify := 1 else
      if FreeSafetyPool then HeapNotify := 2 else HeapNotify := 0;
end;

procedure InitMemory;
begin
  HeapError := @HeapNotify;
  SafetyPoolSize := LowMemSize * 16;
  LowMemory;
end;

procedure DoneMemory;
begin
  while FreeCache do;
  FreeSafetyPool;
end;

procedure InitDosMem;
begin
end;

procedure DoneDosMem;
begin
end;

function LowMemory: Boolean;
begin
  LowMemory := False;
  if SafetyPool = nil then
  begin
    SafetyPool := MemAlloc(SafetyPoolSize);
    if SafetyPool = nil then LowMemory := True;
  end;
end;

function MemAlloc(Size: Word): Pointer;
var
  P: Pointer;
begin
  DisablePool := True;
  GetMem(P, Size);
  DisablePool := False;
  MemAlloc := P;
end;

function MemAllocSeg(Size: Word): Pointer;
var
  Selector: Word;
begin
  Selector := 0;
  if Size <> 0 then
    repeat
      if DosAllocSeg(Size, @Selector, 0) <> 0 then
        Selector := 0;
    until (Selector <> 0) or not FreeCache;
  MemAllocSeg := Ptr(Selector, 0);
end;

procedure NewCache(var P: Pointer; Size: Word);
var
  Cache: PCache;
begin
  Inc(Size, SizeOf(TCache));
  PtrRec(Cache).Ofs := 0;
  if DosAllocSeg(Size, @PtrRec(Cache).Seg, 0) <> 0 then
    PtrRec(Cache).Seg := 0;
  if Cache <> nil then
  begin
    if CacheList = nil then Cache^.Next := Cache else
    begin
      Cache^.Next := CacheList^.Next;
      CacheList^.Next := Cache;
    end;
    CacheList := Cache;
    Cache^.Master := @P;
    Inc(PtrRec(Cache).Ofs, SizeOf(TCache));
  end;
  P := Cache;
end;

procedure DisposeCache(P: Pointer);
var
  Cache, C: PCache;
begin
  PtrRec(Cache).Ofs := PtrRec(P).Ofs - SizeOf(TCache);
  PtrRec(Cache).Seg := PtrRec(P).Seg;
  C := CacheList;
  while (C^.Next <> Cache) and (C^.Next <> CacheList) do C := C^.Next;
  if C^.Next = Cache then
  begin
    if C = Cache then CacheList := nil else
    begin
      if CacheList = Cache then CacheList := C;
      C^.Next := Cache^.Next;
    end;
    Cache^.Master^ := nil;
    DosFreeSeg(PtrRec(Cache).Seg);
  end;
end;

procedure NewBuffer(var P: Pointer; Size: Word);
begin
  P := MemAllocSeg(Size);
end;

procedure DisposeBuffer(P: Pointer);
begin
  DosFreeSeg(PtrRec(P).Seg);
end;

function GetBufferSize(P: Pointer): Word;
var
  Size: Longint;
begin
  if DosSizeSeg(PtrRec(P).Seg, @Size) <> 0 then Size := 0;
  GetBufferSize := Size;
end;

function SetBufferSize(P: Pointer; Size: Word): Boolean;
begin
  SetBufferSize := DosReallocSeg(Size, PtrRec(P).Seg) = 0;
end;

end.
