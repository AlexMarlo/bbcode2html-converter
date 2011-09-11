unit Unit1; 

{$mode delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Clipbrd, Interfaces, StringsHelper;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }


{ TForm1 }

procedure paste_to_clipboard(const Str: WideString);
var
  Size: integer;
  Data: THandle;
  DataPtr: Pointer;
begin
  Size := Length(Str);
  Clipboard.AsText := Str;
  exit;

  if Size = 0 then
    exit;
  if not IsClipboardFormatAvailable(CF_UNICODETEXT) then
    Clipboard.AsText := Str
  else
  begin
    Size := Size shl 1 + 2;
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(Pointer(Str)^, DataPtr^, Size);
        //Clipboard.AsText := Data;
        //Clipboard.SetTextBuf(Data);
        //Clipboard.SetAsHandle(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  end;
end;

procedure CSTC(s: string);
var
  hg: THandle;
  P: PChar;
begin
  hg := GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, Length(S) + 1);
  P := GlobalLock(hg);
  StrPCopy(P, s);
  GlobalUnlock(hg);
  //OpenClipboard(Application.Handle);
  SetClipboardData(CF_TEXT, hg);
  CloseClipboard;
  GlobalFree(hg);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  j, k, z: integer;
  buf, buf2, str: string;
  cmp: boolean;

begin
  memo2.Clear;
  memo3.Clear;
  z := 0;

  for j := 0 to memo1.Lines.Count - 1 do
  begin
    str := trim(memo1.lines[j]);

    if copy(str, 8, 4) <> 'www.' then
      buf2 := copy(str, 8, length(str))
    else
      buf2 := copy(str, 12, length(str));
    for k := 1 to length(buf2) do
    begin
      if (buf2[k] = '/') then
        break;
    end;
    buf2 := copy(buf2, 1, k - 1);

    if (str <> '') and (str <> ' ') then
    begin
      if memo1.Lines.Count > 1 then
        buf2 := '[b]' + Edit1.Text + IntToStr(j + 1 - z) + '[/b]';
      memo2.Lines.Add('[url=' + str + ']' + buf2 + '[/url]');

      if memo1.Lines.Count > 1 then
        buf2 := Edit1.Text + IntToStr(j + 1 - z);
      memo3.Lines.Add('<a href="' + str + '">' + buf2 + '</a>');
    end
    else
      z := z + 1;
  end;

  paste_to_clipboard(memo2.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  paste_to_clipboard(memo2.Text);
  //CSTC(memo2.Text);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: integer;
  j, k: integer;
  buf, buf2, str: string;
  cmp: boolean;

begin
  memo2.Clear;
  memo3.Clear;

  for j := 0 to memo1.Lines.Count - 1 do
  begin
    str := trim(memo1.lines[j]);

    if copy(str, 8, 4) <> 'www.' then
      buf2 := copy(str, 8, length(str))
    else
      buf2 := copy(str, 12, length(str));
    for k := 1 to length(buf2) do
    begin
      if (buf2[k] = '/') then
        break;
    end;
    buf2 := copy(buf2, 1, k - 1);

    if (str <> '') and (str <> ' ') then
    begin
      memo2.Lines.Add('[url=' + str + ']' + str + '[/url]');
      memo3.Lines.Add('<a href="' + str + '">' + str + '</a>');
    end;
  end;
  paste_to_clipboard(memo2.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  j, z, en: integer;
  buf, buf2, img, str: string;
begin
  memo2.Clear;
  memo3.Clear;
  z := 0;

  for j := 0 to memo1.Lines.Count - 1 do
  begin
    str := trim(memo1.lines[j]);

    buf := get_str_between(str, '[URL=', ']', en);

    if (buf <> '') and (buf <> ' ') and (str[1] = '[') and
      ((str[2] = 'U') or (str[2] = 'u')) then
    begin
      str := copy(str, en, length(str) - en + 1);
      buf2 := get_str_between(str, ']', '[/url]', en);
      img := get_str_between(str, '[img]', '[/img]', en);

      if not(img = '') then
      begin
        memo2.Lines.Add('<a href="' + buf + '"><img src="' + img + '"></a>');
        continue;
      end;

      buf2 := replace(buf2, '[b]', '<b>');
      buf2 := replace(buf2, '[/b]', '</b>');
      memo2.Lines.Add('<a href="' + buf + '">' + buf2 + '</a>');
    end
    else
    begin
      str := memo1.Lines[j];
      str := replace(str, '[b]', '<b>');
      str := replace(str, '[/b]', '</b>');
      memo2.Lines.Add(str);
    end;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  memo3.Text := replace(memo1.Text, edit1.Text, memo2.Text);
end;

end.

