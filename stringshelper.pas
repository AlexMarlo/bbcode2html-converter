unit StringsHelper;

{$mode delphi}

interface

uses
  Classes, SysUtils, RegExpr;

function search_boyer_moore(StartPos: integer; const haystack, needle: string): integer;
function get_str_between(const haystack, left_str, right_str: string; var str_end: integer): string;
function replace(where: string; what: string; than: string): string;
function search_pattern(const haystack, pattern: string; start_pos: integer; var pos: longint): string;
function trim(const str: string): string;

implementation

function search_pattern(const haystack, pattern: string; start_pos: integer;
  var pos: longint): string;
var
  reg: TRegExprEngine;
  len: longint;
  haystack_local: string;
begin
  result := '';
  pos := -1;
  haystack_local := copy(haystack, start_pos, length(haystack));
  reg := GenerateRegExprEngine(PChar(pattern), [ref_singleline, ref_caseinsensitive]);

  if (RegExprPos(reg, PChar(haystack_local), pos, len)) then
  begin
    pos := pos + start_pos;
    result := copy(haystack_local, pos, len);
  end;

  DestroyRegExprEngine(reg);
end;

function search_pattern_pos(const start_pos: integer; haystack, pattern: string): longint;
var
  reg: TRegExprEngine;
  len, pos: longint;
  esc_pattern: string;
  haystack_local: string;
begin
  result := -1;

  esc_pattern := RegExpr.RegExprEscapeStr(pattern);
  haystack_local := copy(haystack, start_pos, length(haystack));
  reg := GenerateRegExprEngine(PChar(esc_pattern), [ref_singleline, ref_caseinsensitive]);

  if (RegExprPos(reg, PChar(haystack_local), pos, len)) then
    result := pos + start_pos;

  DestroyRegExprEngine(reg);
end;

function search_boyer_moore(StartPos: integer; const haystack, needle: string): integer;
type
  TBMTable = array[0..255] of integer;
var
  Pos, lp, i: integer;
  BMT: TBMTable;
begin

  for i := 0 to 255 do
    BMT[i] := Length(needle);
  for i := Length(needle) downto 1 do
    if BMT[byte(needle[i])] = Length(needle) then
      BMT[byte(needle[i])] := Length(needle) - i;

  lp := Length(needle);
  Pos := StartPos + lp - 1;
  while Pos <= Length(haystack) do
    if needle[lp] <> haystack[Pos] then
      Pos := Pos + BMT[byte(haystack[Pos])]
    else if lp = 1 then
    begin
      Result := Pos;
      Exit;
    end
    else
      for i := lp - 1 downto 1 do
        if needle[i] <> haystack[Pos - lp + i] then
        begin
          Inc(Pos);
          Break;
        end
        else if i = 1 then
        begin
          Result := Pos - lp + 1;
          Exit;
        end;
  Result := 0;

end;

function get_str_between(const haystack, left_str, right_str: string;
  var str_end: integer): string;
var
  start_pos, str_length: integer;
  left_srt_pos, left_str_len: integer;
  right_srt_pos: integer;
begin
  left_str_len := length(left_str);
  //left_srt_pos := search_boyer_moore(1, haystack, left_str);
  left_srt_pos := search_pattern_pos(1, haystack, left_str);
  start_pos := left_srt_pos + left_str_len;
  //right_srt_pos := search_boyer_moore(start_pos, haystack, right_str);
  right_srt_pos := search_pattern_pos(start_pos, haystack, right_str);
  str_length := right_srt_pos - start_pos;

  Result := copy(haystack, start_pos, str_length);
  str_end := right_srt_pos;
end;

function replace(where: string; what: string; than: string): string;
begin
  Result := where;
  Result := StringReplace(Result, what, than, [rfReplaceAll]);
end;

function trim(const str: string): string;
var
  i, j, len: integer;
begin
  result := str;
  len := length(str);
  for i := 1 to len do
  begin
    if not (result[i] = ' ') then
      break;
  end;

  for j := len downto 1 do
  begin
    if not (result[j] = ' ') then
      break;
  end;

  result := copy(result, i, j - i + 1);
end;

end.
