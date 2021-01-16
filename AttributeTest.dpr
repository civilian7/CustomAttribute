program AttributeTest;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uIniConfig in 'uIniConfig.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
