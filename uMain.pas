unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  uIniConfig;

type
  TMyIni = class(TIniConfig)
  private
    FIP: string;
    FLastAccess: TDateTime;
    FPort: Integer;
    FSaveID: Boolean;
  public
    [IniString('connection', '127.0.0.1')]
    property IP: string read FIP write FIP;
    [IniInteger('connection', 8080)]
    property Port: Integer read FPort write FPort;
    [IniDateTime('connection', '2021-01-16 19:25:00')]
    property LastAccess: TDateTime read FLastAccess write FLastAccess;
    [IniBoolean('user', True)]
    property SaveID: Boolean read FSaveID write FSaveID;
  end;

  TfrmMain = class(TForm)
  private
    FConfig: TMyIni;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  FConfig := TMyIni.Create();
  FConfig.AutoSave := True;       // AutoSave in Destroy
end;

destructor TfrmMain.Destroy;
begin
  FConfig.Free;

  inherited;
end;

end.
