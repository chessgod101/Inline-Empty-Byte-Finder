unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSettingsForm = class(TForm)
    GroupBox1: TGroupBox;
    HiewPathEdit: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
HiewPathEdit.Text:=OpenDialog1.FileName;
end;

end.
