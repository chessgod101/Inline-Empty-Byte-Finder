unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, Clipbrd, ShellAPI,inifiles, CommCtrl;

type
  TMainForm = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    FilePathEdit: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    ExecutableCB: TCheckBox;
    ReadableCB: TCheckBox;
    WritableCB: TCheckBox;
    GoButton: TButton;
    SizeEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EmptyByteEdit: TEdit;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    HexCB: TCheckBox;
    PopupMenu1: TPopupMenu;
    C1: TMenuItem;
    C2: TMenuItem;
    C3: TMenuItem;
    C4: TMenuItem;
    C5: TMenuItem;
    MainMenu1: TMainMenu;
    O1: TMenuItem;
    P1: TMenuItem;
    N1: TMenuItem;
    H1: TMenuItem;
    F1: TMenuItem;
    F2: TMenuItem;
    H2: TMenuItem;
    A1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure GoButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    Function CheckSectionFlags(sectionIndex:byte):Boolean;
    procedure C1Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure C5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  end;

Type TSecInfo = Packed Record
  sectionCount:Cardinal;
  Sections:Array of TImageSectionHeader;
End;

type
  THeaderSortState = (hssNone, hssAscending, hssDescending);
var
  MainForm: TMainForm;
  PESections:TSecInfo;
  Descending: Boolean;
  SortedColumn: Integer;
  Hiew32Path,ldfile: String;

implementation
uses SettingsUnit;
{$R *.dfm}

function ListViewFromColumn(Column: TListColumn): TListView;
begin
	Result := (Column.Collection as TListColumns).Owner as TListView;
end;

procedure SetListHeaderSortState(Column: TListColumn; Value: THeaderSortState);
var
  Header: HWND;
  Item: THDItem;
begin
	Header := ListView_GetHeader(ListViewFromColumn(Column).Handle);
	ZeroMemory(@Item, SizeOf(Item));
	Item.Mask := HDI_FORMAT;
	Header_GetItem(Header, Column.Index, Item);
	Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);//remove both flags
	
	case Value of
		hssAscending:
			Item.fmt := Item.fmt or HDF_SORTUP;
		hssDescending:
			Item.fmt := Item.fmt or HDF_SORTDOWN;
	end;
	Header_SetItem(Header, Column.Index, Item);
end;

procedure LoadSettings();
var
sfile:TiniFile;
Begin
	sfile:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'Settings.ini');
	Hiew32Path:=sfile.ReadString('Settings','HiewPath','');
	sfile.Free;
	if FileExists(Hiew32Path)=false then
		MainForm.PopupMenu1.Items[6].Enabled:=false;
End;


Function SNToStr(secIndex:byte):AnsiString;
Begin
	setLength(result,8);
	CopyMemory(@result[1],@PESections.Sections[secIndex].Name[0],8);
End;

procedure TMainForm.C1Click(Sender: TObject);
begin
	if ListView1.SelCount>0 then	
		Clipboard.AsText:=ListView1.Selected.Caption;
end;

procedure TMainForm.C2Click(Sender: TObject);
begin
	if ListView1.SelCount>0 then
		Clipboard.AsText:=ListView1.Selected.SubItems.Strings[0];
end;

procedure TMainForm.C3Click(Sender: TObject);
begin
	if ListView1.SelCount>0 then
		Clipboard.AsText:=ListView1.Selected.SubItems.Strings[1];
end;

procedure TMainForm.C4Click(Sender: TObject);
begin
	if ListView1.SelCount>0 then
		Clipboard.AsText:=ListView1.Selected.SubItems.Strings[2];
end;

procedure TMainForm.C5Click(Sender: TObject);
begin
	if ListView1.SelCount>0 then
		Clipboard.AsText:=ListView1.Selected.SubItems.Strings[3];
end;

Function TMainForm.CheckSectionFlags(sectionIndex:byte):Boolean;
Begin
	result:=false;
	if ExecutableCB.Checked=true then begin
		if (PESections.Sections[sectionIndex].Characteristics and IMAGE_SCN_MEM_EXECUTE)<>IMAGE_SCN_MEM_EXECUTE then
			Exit;
	end;
	
	if ReadableCB.Checked=true then begin
		if (PESections.Sections[sectionIndex].Characteristics and IMAGE_SCN_MEM_READ)<>IMAGE_SCN_MEM_READ then
			Exit;
	end;
	
	if WritableCB.Checked=true then begin
		if (PESections.Sections[sectionIndex].Characteristics and IMAGE_SCN_MEM_WRITE)<>IMAGE_SCN_MEM_WRITE then
			Exit;
	end;
	
	Result:=true;
End;

procedure TMainForm.F1Click(Sender: TObject);
var
	s:String;
begin
	if ListView1.SelCount<=0 then exit;
	
	if fileexists(hiew32path)=false then exit;
	
	s:='/Oh='+ListView1.Selected.SubItems.Strings[0]+' "'+ldfile+'"';
	ShellExecute(0,NIL,@Hiew32Path[1],@s[1],nil,SW_NORMAL);
end;

procedure TMainForm.F2Click(Sender: TObject);
var
s:String;
begin
	if ListView1.SelCount<=0 then exit;
	
	if fileexists(hiew32path)=false then exit;
	
	s:='/Oc='+ListView1.Selected.SubItems.Strings[0]+' "'+ldfile+'"';
	ShellExecute(0,NIL,@Hiew32Path[1],@s[1],nil,SW_NORMAL);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
	DragAcceptFiles(Handle,true);
	LoadSettings;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	DragAcceptFiles(Handle,false);
end;

Function CheckFileType(S:String):Boolean;
var
	ext:String;
Begin
	ext:=(lowercase(ExtractFileExt(s)));
	if (ext='.exe') or (ext='.dll')  then
		result:=true else result:=false;
//FilePathEdit.Text:=s;
End;
procedure TMainForm.FormShow(Sender: TObject);

begin
	if paramcount>0 then begin
		if CheckFileType(paramStr(1))=true then begin
			FilePathEdit.Text:=paramStr(1);
			GoButtonClick(nil);
		end;
	end;
end;

Function GetSectionInfo(fH:THandle):Boolean;
var
	dh:tImageDosHeader;
	pe:timageFileHeader;
	tmp:Cardinal;
Begin
	result:=false;
	SetFilePointer(fH,0,nil,FILE_BEGIN);
	if ReadFile(fH,dh,sizeof(TImageDosHeader),tmp,nil)=false then exit;//could not read file
	if (dh.e_magic<>23117)and(dh._lfanew>=$1000) then exit; //Invalid Header
	SetFilePointer(fH,dh._lfanew+4,nil,FILE_BEGIN);
	if ReadFile(fH,pe,sizeof(TImageFileHeader),tmp,nil)=false then exit;//could not read file
	if pe.NumberOfSections=0 then exit; // no sections to parse;
	SetLength(PESections.Sections,pe.NumberOfSections);
	PESections.sectionCount:=pe.NumberOfSections;
	SetFilePointer(fH,(pe.SizeOfOptionalHeader),nil,FILE_CURRENT);
	if ReadFile(fH,PESections.Sections[0],sizeof(TImageSectionHeader)*pe.NumberOfSections,tmp,nil)=true then
    result:=true;
End;

Function FindData(buffer:PByte;bsize:Cardinal;wcard:Byte;len:Cardinal;var offset,flen:Cardinal):Boolean;
var
  I:Cardinal;
  lbsize:Cardinal;
  os:Cardinal;
Begin
  I:=0;
  while I<bsize do begin
    if buffer[I]=wcard then begin
      lbsize:=0;
      os:=I;
      repeat
        inc(lbsize);
        inc(I);
        if not(I<bsize) then
          break;
      until (buffer[I]<>wcard);
      if lbsize>=len then begin
        offset:=os;
        flen:=lbsize;
        Result:=true;
        Exit;
      end;
    end;
  inc(I);
  end;
  Result:=false;
End;

Procedure YieldWarning(s:String);
Begin
  MessageBeep(MB_ICONWARNING);
  MessageBox(Application.Handle,@s[1],PChar('Error'),MB_OK);
End;

procedure TMainForm.A1Click(Sender: TObject);
begin
  MessageBox(Application.Handle,'Inline Empty Byte Finder v1.3','About',MB_OK);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute=true then
  FilePathEdit.Text:=OpenDialog1.FileName;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
var
  b:Byte;
  sz,len,I,os,tmp,llen:Cardinal;
  //li:TListItem;
  s:WideString;
  h:THandle;
  buffer:Array of byte;
  fCount:Cardinal;
begin
  fCount:=0;
  ListView1.Clear;
  if SortedColumn<5 then
    SetListHeaderSortState(ListView1.Columns.Items[SortedColumn],hssNone);
  Try
    b:=StrToInt('$'+EmptyByteEdit.Text);
  Except
    YieldWarning('Invalid Empty Byte Value!');
    Exit;
  End;

  if SizeEdit.GetTextLen>0 then begin
    try
      if HexCB.Checked=true then
        len:=StrToInt('$'+SizeEdit.Text)
        else
          len:=StrToInt(SizeEdit.Text);
    Except
    YieldWarning('Invalid Size Value!');
    exit;
    end;
  end
  else Begin
    YieldWarning('Size Cannot be blank!');
    Exit;
  End;

  s:=FilePathEdit.text;
  if length(s)<=0 then begin//Empty File Edit
    YieldWarning('You Must Choose A PE File First!');
    Exit;
  End;

  if FileExists(s)=false then begin
    YieldWarning('The Selected File Does Not Exist!');
    Exit;
  end;

  ldfile:=s;
  h:=CreateFileW(@s[1],GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if h=INVALID_HANDLE_VALUE then Begin
    YieldWarning('Could not open file: '+SysErrorMessage(GetLastError));
    Exit;
  End;

  if GetSectionInfo(h)=true then begin
    I:=0;
    while I<PESections.sectionCount do begin
      if CheckSectionFlags(I)=true then begin
        sz:=PESections.Sections[I].SizeOfRawData;
        setlength(buffer,sz);
        SetFilePointer(h,PESections.Sections[I].PointerToRawData,nil,FILE_BEGIN);
          if ReadFile(h,buffer[0],sz,tmp,nil) then begin
            tmp:=0;
            ListView1.Items.BeginUpdate;
            while FindData(@buffer[tmp],sz,b,len,os,llen)=true do begin
              ListView1.Items.Add;
              ListView1.Items.Item[ListView1.Items.Count-1].Caption:=String(SNToStr(I));
              ListView1.Items.Item[ListView1.Items.Count-1].SubItems.Add(IntToHex(PESections.Sections[I].PointerToRawData+os+tmp,2));
              ListView1.Items.Item[ListView1.Items.Count-1].SubItems.Add(IntToHex(PESections.Sections[I].VirtualAddress+os+tmp,2));
              ListView1.Items.Item[ListView1.Items.Count-1].SubItems.Add(IntToStr(llen));
              ListView1.Items.Item[ListView1.Items.Count-1].SubItems.Add(IntToHex(llen,2));
              tmp:=tmp+os+llen;
              sz:=sz-(os+llen);
              inc(fCount);
            end;
            ListView1.Items.EndUpdate;

          end;//end readfile if
      end;//end CheckSectionFlags if
      inc(I);
    end;//end while
  end//end GetSectionInfoIf
  else
    YieldWarning('Could not get section data: '+SysErrorMessage(GetLastError));

  CloseHandle(h);
  StatusBar1.Panels[0].Text:='Caves Found: '+ inttostr(fCount);
End;

procedure TMainForm.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  //ListView1.AlphaSort;
  TListView(Sender).SortType := stNone;
  if Column.Index<>SortedColumn then begin
    SetListHeaderSortState(ListView1.Columns.Items[SortedColumn],hssNone);
    SetListHeaderSortState(Column,hssAscending);
    SortedColumn := Column.Index;
    Descending := False;
  end
  else
    Descending := not Descending;

  if Descending=false then
    SetListHeaderSortState(Column,hssAscending)
  else
    SetListHeaderSortState(Column,hssDescending);

TListView(Sender).SortType := stText;
End;

Function CompareNumbers(I,I2:Cardinal):Integer;
Begin
  Result:=I-I2;
End;

procedure TMainForm.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  if SortedColumn = 0 then Compare := CompareText(Item1.Caption, Item2.Caption)
  else begin
    Try
      case SortedColumn of
        1,2,4: Begin
          Compare:=CompareNumbers(StrToInt('$'+Item1.SubItems[SortedColumn-1]),StrToInt('$'+Item2.SubItems[SortedColumn-1]));
        End;
        3: Begin
          Compare:=CompareNumbers(StrToInt(Item1.SubItems[SortedColumn-1]),StrToInt(Item2.SubItems[SortedColumn-1]));
        End;
      End;
    Except
      Compare:=CompareText(Item1.SubItems[SortedColumn-1], Item2.SubItems[SortedColumn-1]);
    end;
  end;

  if Descending then Compare := -Compare;
End;

procedure UpdateSettings();
var
  sfile:TiniFile;
Begin
  sfile:=TiniFile.Create(ExtractFilePath(Application.ExeName)+'Settings.ini');
  sfile.WriteString('Settings','HiewPath',Hiew32Path);
  sfile.Free;
End;

procedure TMainForm.P1Click(Sender: TObject);
var
  s:String;
begin
  SettingsForm.HiewPathEdit.Text:=Hiew32Path;
  if SettingsForm.ShowModal=mroK then begin
    s:=SettingsForm.HiewPathEdit.Text;
    if FileExists(s) then begin
      Hiew32Path:=s;
      PopupMenu1.Items[6].Enabled:=true;
      UpdateSettings;
    end;
  end;
End;

procedure TMainForm.WMDropFiles(var Msg: TMessage);
var
  l:cardinal;
  s,ext:WideString;
Begin
  l:=DragQueryFile(Msg.WParam,0,nil,0)+1;
  SetLength(s,l);
  DragQueryFile(Msg.WParam,0,@s[1],l);
  s:=trim(s);
  if CheckFileType(s)=true then
    ext:=(lowercase(ExtractFileExt(s)));

  if (ext='.exe') or (ext='.dll')  then
    FilePathEdit.Text:=s;
End;

end.
