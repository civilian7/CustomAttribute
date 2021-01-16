unit uIniConfig;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  System.IniFiles;

type
  IniBoolean = class(TCustomAttribute)
  private
    FSection: string;
    FValue: Boolean;
  public
    constructor Create(const ASection: string; const AValue: Boolean);

    property Section: string read FSection;
    property Value: Boolean read FValue;
  end;

  IniDateTime = class(TCustomAttribute)
  private
    FSection: string;
    FValue: TDateTime;
  public
    constructor Create(const ASection, AValue: string);

    property Section: string read FSection;
    property Value: TDateTime read FValue;
  end;

  IniFloat = class(TCustomAttribute)
  private
    FSection: string;
    FValue: Double;
  public
    constructor Create(const ASection: string; const AValue: Double);

    property Section: string read FSection;
    property Value: Double read FValue;
  end;

  IniInt64 = class(TCustomAttribute)
  private
    FSection: string;
    FValue: Int64;
  public
    constructor Create(const ASection: string; const AValue: Int64);

    property Section: string read FSection;
    property Value: Int64 read FValue;
  end;

  IniInteger = class(TCustomAttribute)
  private
    FSection: string;
    FValue: Integer;
  public
    constructor Create(const ASection: string; const AValue: Integer);

    property Section: string read FSection;
    property Value: Integer read FValue;
  end;

  IniString = class(TCustomAttribute)
  private
    FSection: string;
    FValue: string;
  public
    constructor Create(const ASection, AValue: string);

    property Section: string read FSection;
    property Value: string read FValue;
  end;

  TIniConfig = class(TObject)
  private
    FAutoSave: Boolean;
    FIniFile: TIniFile;
  public
    constructor Create(const AName: string = ''); virtual;
    destructor Destroy; override;

    procedure LoadFromFile;
    procedure SaveToFile;

    property AutoSave: Boolean read FAutoSave write FAutoSave;
  end;

implementation

{ IniBoolean }

constructor IniBoolean.Create(const ASection: string; const AValue: Boolean);
begin
  FSection := UpperCase(ASection);
  FValue := AValue;
end;

{ IniDateTime }

constructor IniDateTime.Create(const ASection, AValue: string);
begin
  FSection := UpperCase(ASection);
  if (AValue <> '') then
    FValue := StrToDateTime(AValue)
  else
    FValue := 0;
end;

{ IniFloat }

constructor IniFloat.Create(const ASection: string; const AValue: Double);
begin
  FSection := UpperCase(ASection);
  FValue := AValue;
end;

{ IniInt64 }

constructor IniInt64.Create(const ASection: string; const AValue: Int64);
begin
  FSection := UpperCase(ASection);
  FValue := AValue;
end;

{ IniInteger }

constructor IniInteger.Create(const ASection: string; const AValue: Integer);
begin
  FSection := UpperCase(ASection);
  FValue := AValue;
end;

{ IniString }

constructor IniString.Create(const ASection, AValue: string);
begin
  FSection := UpperCase(ASection);
  FValue := AValue;
end;

{ TIniConfig }

constructor TIniConfig.Create(const AName: string);
var
  LName: string;
begin
  FAutoSave := True;

  if (AName = '') then
    LName := ChangeFileExt(ParamStr(0), '.ini')
  else
    LName := AName;

  FIniFile := TIniFile.Create(LName);
end;

destructor TIniConfig.Destroy;
begin
  if FAutoSave then
    SaveToFile;

  FIniFile.Free;

  inherited;
end;

procedure TIniConfig.LoadFromFile;
var
  LAttribute: TCustomAttribute;
  LProp: TRttiProperty;
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
begin
  LRttiContext := TRttiContext.Create;
  try
    LRttiType := LRttiContext.GetType(Self.ClassType);
    for LProp in LRttiType.GetProperties do
    begin
      for LAttribute in LProp.GetAttributes do
      begin
        if LAttribute is IniBoolean then
          LProp.SetValue(Self, FIniFile.ReadBool(IniBoolean(LAttribute).Section, LProp.Name, IniBoolean(LAttribute).Value))
        else
        if LAttribute is IniDateTime then
          LProp.SetValue(Self, FIniFile.ReadDateTime(IniDateTime(LAttribute).Section, LProp.Name, IniDateTime(LAttribute).Value))
        else
        if LAttribute is IniFloat then
          LProp.SetValue(Self, FIniFile.ReadFloat(IniString(LAttribute).Section, LProp.Name, IniFloat(LAttribute).Value))
        else
        if LAttribute is IniInt64 then
          LProp.SetValue(Self, FIniFile.ReadInt64(IniString(LAttribute).Section, LProp.Name, IniInt64(LAttribute).Value))
        else
        if LAttribute is IniInteger then
          LProp.SetValue(Self, FIniFile.ReadInteger(IniString(LAttribute).Section, LProp.Name, IniInteger(LAttribute).Value))
        else
        if LAttribute is IniString then
          LProp.SetValue(Self, FIniFile.ReadString(IniString(LAttribute).Section, LProp.Name, IniString(LAttribute).Value));
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

procedure TIniConfig.SaveToFile;
var
  LAttribute: TCustomAttribute;
  LProp: TRttiProperty;
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
begin
  LRttiContext := TRttiContext.Create;
  try
    LRttiType := LRttiContext.GetType(Self.ClassType);
    for LProp in LRttiType.GetProperties do
    begin
      for LAttribute in LProp.GetAttributes do
      begin
        if LAttribute is IniBoolean then
          FIniFile.WriteBool(IniBoolean(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsBoolean)
        else
        if LAttribute is IniDateTime then
          FIniFile.WriteDateTime(IniDateTime(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsExtended)
        else
        if LAttribute is IniFloat then
          FIniFile.WriteFloat(IniFloat(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsExtended)
        else
        if LAttribute is IniInt64 then
          FIniFile.WriteInt64(IniInt64(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsInt64)
        else
        if LAttribute is IniInteger then
          FIniFile.WriteInteger(IniInteger(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsInteger)
        else
        if LAttribute is IniString then
          FIniFile.WriteString(IniString(LAttribute).Section, LProp.Name, LProp.GetValue(Self).AsString);
      end;
    end;
  finally
    LRttiContext.Free;
  end;
end;

end.
