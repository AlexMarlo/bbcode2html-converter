unit Unit1;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Clipbrd, Interfaces, StringsHelper;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Panel1: TPanel;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Memo3: TMemo;
    Panel2: TPanel;
    Button6: TButton;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
   private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure paste_to_clipboard(const Str: WideString);
var
  Size: Integer;
  Data: THandle;
  DataPtr: Pointer;
begin
  Size := Length(Str);
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
  hg:=GlobalAlloc(GMEM_DDESHARE or GMEM_MOVEABLE, Length(S)+1);
  P:=GlobalLock(hg);
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
  buf, buf2: string;
  cmp: boolean;

begin
  memo2.Clear;
  memo3.Clear;
  z := 0;
  for j := 0 to memo1.lines.count - 1 do
    begin
    if copy(memo1.Lines[j], 8, 4) <> 'www.' then
      buf2 := copy(memo1.Lines[j], 8, length(memo1.Lines[j]))
    else
      buf2 := copy(memo1.Lines[j], 12, length(memo1.Lines[j]));
    for k := 1 to length(buf2) do
      begin
        if (buf2[k] = '/'){ or (buf2[k] = '.')} then
          break;
      end;
    buf2 := copy(buf2, 1, k - 1);
             { if buf=buf2 then
                begin
                  cmp:=true;
                  break;
                end;   }
    if (memo1.lines[j]<>'')and(memo1.lines[j]<>' ') then
      begin
        if memo1.lines.count > 1 then
          buf2 := '[b]' + Edit1.text + inttostr(j + 1 - z) + '[/b]';
        memo2.Lines.Add('[url='+memo1.lines[j]+']'+buf2+'[/url]');

        if memo1.lines.count > 1 then
          buf2 := Edit1.text + inttostr(j + 1 - z);
        memo3.Lines.Add('<a href="' + memo1.lines[j] + '">' + buf2 + '</a>');
      end
    else
      z := z + 1;
    //<a href="http://uploadbox.com/files/OkG6wkz8Dt">Amalia1</a>

  end;

  //[url=http://letitbit.net/download/de3077174386/http-to-bbcode.rar.html] http-to-bbcode.rar [/url]
  //memo2.Lines.Add('</body>');
  //memo2.Lines.Add('</html>');
  paste_to_clipboard(memo2.Text);
end;
procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo1.Clear;
end;
procedure TForm1.Button4Click(Sender: TObject);
begin
  CSTC(memo2.Text)
end;
procedure TForm1.Button5Click(Sender: TObject);
var
  i: integer;
  j, k: integer;
  buf, buf2: string;
  cmp: boolean;

begin
  memo2.Clear;
  memo3.Clear;

  for j := 0 to memo1.lines.count - 1 do
    begin
      if copy(memo1.Lines[j], 8, 4) <> 'www.' then
        buf2:=copy(memo1.Lines[j], 8, length(memo1.Lines[j]))
      else
        buf2:=copy(memo1.Lines[j], 12, length(memo1.Lines[j]));
      for k:=1 to length(buf2) do
        begin
          if (buf2[k] = '/') {or (buf2[k] = '.')} then
            break;
        end;
      buf2 := copy(buf2, 1, k - 1);

    //if memo1.lines.count > 1 then buf2 := 'Part' + inttostr(j + 1);
    if (memo1.lines[j] <> '') and (memo1.lines[j] <> ' ') then
      begin
        memo2.Lines.Add('[url=' + memo1.lines[j] + ']' + memo1.lines[j] + '[/url]');
        memo3.Lines.Add('<a href="' + memo1.lines[j] + '">' + memo1.lines[j] + '</a>');
      end;
    end;
  paste_to_clipboard(memo2.Text);
end;
procedure TForm1.Button6Click(Sender: TObject);
var
  j, z, en: integer;
  buf, buf2, str: string;
begin
  memo2.Clear;
  memo3.Clear;
  z := 0;
  for j := 0 to memo1.lines.count - 1 do
    begin
      buf := get_str_between(memo1.lines[j], '[URL=',']', en);
      if (buf <> '') and (buf[1] = '=') then
        buf := get_str_between(memo1.lines[j], '[url=', ']', en);

      if (buf<>'')and(buf<>' ')and(memo1.lines[j][1]='[')and((memo1.lines[j][2]='U')or(memo1.lines[j][2]='u')){} then
        begin
          str := copy(memo1.lines[j], en, length(memo1.lines[j]) - en + 1);
          buf2 := get_str_between(str, ']', '[/url]', en);
          if buf2 = '' then
            begin
              buf2 := get_str_between(str, '[IMG]', '[/IMG]', en);

              if (search_boyer_moore(1,str,'[b]')>0)or(search_boyer_moore(1,str,'[/b]')>0)  then
                begin
                  buf2 := exchange(buf2, '[b]', '<b>');
                  buf2 := exchange(buf2, '[/b]', '</b>');
                end;
              memo2.Lines.Add('<a href="'+buf+'"><img src="'+buf2+'"></a>');
              continue;
            end;
          if (search_boyer_moore(1,str,'[b]')>0)or(search_boyer_moore(1,str,'[/b]')>0)  then
            begin
              buf2:=exchange(buf2,'[b]','<b>');
              buf2:=exchange(buf2,'[/b]','</b>');
            end;
          memo2.Lines.Add('<a href="'+buf+'">'+buf2+'</a>');
        end
      else
        begin
          str:=memo1.lines[j];
          if (search_boyer_moore(1,str,'[b]')>0)or(search_boyer_moore(1,str,'[/b]')>0) then
            begin
              str:=exchange(str,'[b]','<b>');
              str:=exchange(str,'[/b]','</b>');
              //memo1.lines.add(inttostr(search_boyer_moore(1,str,'[/b]')));
            end;
          memo2.Lines.Add(str);
        end;
      //memo2.Lines.Add(buf);
    end;
end;
procedure TForm1.Button7Click(Sender: TObject);
begin
  memo3.Text := exchange(memo1.Text, edit1.Text, memo2.Text)
end;

end.
