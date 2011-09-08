unit StringsHelper;

{$mode delphi}

interface

uses
  Classes, SysUtils; 

function search_boyer_moore(StartPos: Integer; const haystack, needle: string): integer;
function get_str_between(const haystack, left_str, right_str: string; var str_end: integer): string;
function search(stpos: integer; where: string; what: string): integer;
function exchange(where: string; what: string; than: string): string;

implementation

function search_boyer_moore(StartPos: Integer; const haystack, needle: string): Integer;
type
  TBMTable = array[0..255] of Integer;
var
  Pos, lp, i: Integer;
  BMT: TBMTable;
begin

  for i := 0 to 255 do
    BMT[i] := Length(needle);
  for i := Length(needle) downto 1 do
    if BMT[Byte(needle[i])] = Length(needle) then
      BMT[Byte(needle[i])] := Length(needle) - i;

  lp := Length(needle);
  Pos := StartPos + lp - 1;
  while Pos <= Length(haystack) do
    if needle[lp] <> haystack[Pos] then
      Pos := Pos + BMT[Byte(haystack[Pos])]
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

//function finder(in1:string; in2:string; in3:string; var en:integer):string;
function get_str_between(const haystack, left_str, right_str: string; var str_end: integer): string;
var
  start_pos, str_length :integer;
  left_srt_pos, left_str_len :integer;
  right_srt_pos: integer;
begin
  left_str_len := length(left_str);
  left_srt_pos := search_boyer_moore(1, haystack, left_str);
  start_pos := left_srt_pos + left_str_len;
  right_srt_pos := search_boyer_moore(start_pos, haystack, right_str);
  str_length := right_srt_pos - start_pos;

  result := copy(haystack, start_pos, str_length);
  str_end := right_srt_pos;
end;

function search(stpos: integer; where: string; what: string): integer;
var
  i, j: integer;
  temp: string;
begin
  result:=0;
  for i := stpos to length(where) - length(what) + 1 do
    begin
      temp := copy(where, i, length(what));
      if temp = what then
        begin
          result := i;
          exit;
        end;

    end;

end;

function exchange(where: string; what: string; than: string): string;
var
  i, j: integer;
  temp: string;
  where_len, than_len: integer;
  what_end, what_len, what_pos: integer;
begin
  j:=0;
  result := where;
  what_pos := search(1, where, what);

  what_len := length(what);
  where_len := length(where);
  than_len := length(than);

  what_end := what_pos - what_len;

  if what_pos > 0 then
    begin
      if what_len = where_len then
        for i := what_pos to what_pos + what_len - 1 do
          begin
            j := j + 1;
            result[i] := than[j];
          end
      else
        begin
          if what_pos = 1 then
            temp := than + copy(where, what_end, where_len + 1 - what_end)
          else
            temp := copy(where, 1, what_pos - 1) + than + copy(where, what_pos + what_len, where_len + 1 - what_end);
          result := temp;
      end;
    end;
end;

end.

