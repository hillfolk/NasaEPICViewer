unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.ExtCtrls, System.Threading, System.ImageList, FMX.ImgList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Jsons, FMX.ListBox,
  FMX.Calendar, FMX.Effects, FMX.Filter.Effects;

type
  rcoordinates = record
    lat: double;
    lon: double;
  end;

  rposition = record
    x: double;
    y: double;
    z: double;
  end;

  rattitude_quaternions = record
    q0: double;
    q1: double;
    q2: double;
    q3: double;
  end;

  rcoords = record
    centroid_coordinates: rcoordinates;
    dscover_j2000_position: rposition;
    lunar_j2000_position: rposition;
    attitude_quaternions: rattitude_quaternions;
  end;

  repicdata = record
    image: string;
    caption: string;
    centroid_coordinates: rcoordinates;
    dscover_j2000_position: rposition;
    lunar_j2000_position: rposition;
    sun_j2000_position: rposition;
    attitude_quaternions: rattitude_quaternions;
    coords: string;
    date: TDateTime;
  end;

  TfxMain = class(TForm)
    lyMain: TLayout;
    NetHTTPClient1: TNetHTTPClient;
    ProgressBar1: TProgressBar;
    NetHTTPRequest1: TNetHTTPRequest;
    Layout1: TLayout;
    Layout2: TLayout;
    mLogbox: TMemo;
    btnRequestImage: TButton;
    btnRequest: TButton;
    Layout3: TLayout;
    btnFullSize: TButton;
    ListBox1: TListBox;
    Layout4: TLayout;
    Calendar1: TCalendar;
    GroupBox1: TGroupBox;
    Image1: TImage;
    procedure btnRequestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NetHTTPClient1ReceiveData(const Sender: TObject;
      AContentLength, AReadCount: Int64; var Abort: Boolean);
    procedure NetHTTPClient1RequestError(const Sender: TObject;
      const AError: string);
    procedure NetHTTPClient1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure NetHTTPRequest1RequestCompleted(const Sender: TObject;
      const AResponse: IHTTPResponse);
    procedure NetHTTPRequest1ReceiveData(const Sender: TObject;
      AContentLength, AReadCount: Int64; var Abort: Boolean);
    procedure NetHTTPRequest1RequestError(const Sender: TObject;
      const AError: string);
    procedure btnRequestImageClick(Sender: TObject);
    procedure btnFullSizeClick(Sender: TObject);
    procedure ArcDial1Change(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FStream: TStream;
    FBaseURL: string;
    FArcValue: double;
    FDataArray: TArray<repicdata>;
    function Pasing(AJson: string): repicdata;
  public
    { Public declarations }
    procedure Log(ALog: string);
  end;

var
  fxMain: TfxMain;

const
  APIKey = 'FURY5VovHmEAoExfCysQ9M1CnTY5cSRFY0djsJ0Q';

implementation

uses Description;

{$R *.fmx}

procedure TfxMain.ArcDial1Change(Sender: TObject);
var
  LSize: TSize;
begin

end;

procedure TfxMain.btnFullSizeClick(Sender: TObject);
begin

  if Assigned(FStream) then
  begin
    Image1.Bitmap.LoadFromStream(FStream);
  end;
end;

procedure TfxMain.btnRequestClick(Sender: TObject);
var
  JsonValue: TJSONObject;
begin
  NetHTTPRequest1.URL := FBaseURL;
  Pasing(NetHTTPRequest1.Execute().ContentAsString);

end;

procedure TfxMain.btnRequestImageClick(Sender: TObject);
var
  LImageUrl: string;
  AResponseStream: TMemoryStream;
  LTask: ITask;
begin

  // https://api.nasa.gov/EPIC/archive/enhanced/2016/12/04/png/epic_RBG_20161204003633_01.png?api_key=DEMO_KEY
  LImageUrl :=
    'https://api.nasa.gov/EPIC/archive/enhanced/2016/12/04/png/epic_RBG_20161204003633_01.png?api_key='
    + APIKey;

  Log(LImageUrl);
  AResponseStream := TMemoryStream.Create;
  NetHTTPClient1.Get(LImageUrl, AResponseStream);

end;

procedure TfxMain.Calendar1Change(Sender: TObject);
var
  LSelectedDateTime: TDateTime;
  LSearchUrl: string;
begin
  LSelectedDateTime := Calendar1.DateTime;

  LSearchUrl := 'https://api.nasa.gov/EPIC/api/natural/date/' +
    FormatDateTime('yyyy-mm-dd', LSelectedDateTime) + '?api_key=' + APIKey;
  NetHTTPRequest1.URL := LSearchUrl;
  Pasing(NetHTTPRequest1.Execute().ContentAsString);

end;

procedure TfxMain.FormCreate(Sender: TObject);
begin
  FBaseURL := 'https://api.nasa.gov/EPIC/api/natural/images?api_key=' + APIKey;
end;

procedure TfxMain.FormShow(Sender: TObject);
begin
  fxDescription := TfxDescription.Create(Self);
  fxDescription.ShowModal;

end;

procedure TfxMain.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  LImageUrl: string;
  AResponseStream: TMemoryStream;
  LTask: ITask;
  LDateTimeStr: string;
begin

  // https: // api.nasa.gov/EPIC/archive/enhanced/2016/12/04/png/epic_RBG_20161204003633_01.png?api_key=DEMO_KEY
  // https://api.nasa.gov/EPIC/archive/enhanced/2017/02/09/png/epic_1b_20170209042200_01.png?api_key=FURY5VovHmEAoExfCysQ9M1CnTY5cSRFY0
  with FDataArray[ListBox1.ItemIndex] do
  begin
    // DateTimeToString(LDateTimeStr, 'yyyy/mm//dd', date);
    LDateTimeStr := FormatDateTime('yyyy', date) + '/' +
      FormatDateTime('mm', date) + '/' + FormatDateTime('dd', date);
    LImageUrl := 'https://api.nasa.gov/EPIC/archive/natural/' + LDateTimeStr +
      '/png/' + image + '.png?api_key=' + APIKey;
  end;

  Log(LImageUrl);
  AResponseStream := TMemoryStream.Create;
  NetHTTPClient1.Get(LImageUrl, AResponseStream);
  try
    Image1.Bitmap.LoadFromStream(AResponseStream);
  except
    on E: Exception do
  end;

end;

procedure TfxMain.Log(ALog: string);
begin
  mLogbox.Lines.Add(ALog);
end;

procedure TfxMain.NetHTTPClient1ReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
  ProgressBar1.Max := AContentLength;
  ProgressBar1.value := AReadCount;
end;

procedure TfxMain.NetHTTPClient1RequestCompleted(const Sender: TObject;
  const AResponse: IHTTPResponse);
var
  buf: String;
  LTask: ITask;
begin
  LTask := TTask.Create(
    procedure()
    begin
      try
        FStream := AResponse.ContentStream;
        Image1.Bitmap.LoadFromStream(FStream);

      except
      end;
    end);
  LTask.Start;
end;

procedure TfxMain.NetHTTPClient1RequestError(const Sender: TObject;
const AError: string);
begin
  Log(AError);
end;

procedure TfxMain.NetHTTPRequest1ReceiveData(const Sender: TObject;
AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
  ProgressBar1.Max := AContentLength;
  ProgressBar1.value := AReadCount;
end;

procedure TfxMain.NetHTTPRequest1RequestCompleted(const Sender: TObject;
const AResponse: IHTTPResponse);
var
  buf: String;
  Ljson: TJSONObject;
begin
  buf := '';
  AResponse.ContentStream.Read(buf, AResponse.ContentLength);

end;

procedure TfxMain.NetHTTPRequest1RequestError(const Sender: TObject;
const AError: string);
begin
  Log(AError);
end;

function TfxMain.Pasing(AJson: string): repicdata;
var
  LJsonObject: TJSONObject;
  LjsonArray: TJsonArray;
  LJsonBase: TJsonBase;
  LBoxItem: TListBoxItem;
  I: Integer;
begin
  ListBox1.Clear;
  LjsonArray := TJsonArray.Create(nil);
  LjsonArray.Parse(AJson);
  SetLength(FDataArray, LjsonArray.Count);

  for I := 0 to LjsonArray.Count - 1 do
  begin
    LJsonObject := LjsonArray.Items[I].AsObject;
    with FDataArray[I] do
    begin
      image := LJsonObject.Values['image'].AsString;
      caption := LJsonObject.Values['caption'].AsString;

      centroid_coordinates.lat := LJsonObject.Values['centroid_coordinates']
        .AsObject.Values['lat'].AsNumber;
      centroid_coordinates.lon := LJsonObject.Values['centroid_coordinates']
        .AsObject.Values['lon'].AsNumber;
      dscover_j2000_position.x := LJsonObject.Values['dscover_j2000_position']
        .AsObject.Values['x'].AsNumber;
      dscover_j2000_position.y := LJsonObject.Values['dscover_j2000_position']
        .AsObject.Values['y'].AsNumber;
      dscover_j2000_position.z := LJsonObject.Values['dscover_j2000_position']
        .AsObject.Values['z'].AsNumber;

      dscover_j2000_position.z := LJsonObject.Values['dscover_j2000_position']
        .AsObject.Values['z'].AsNumber;
      dscover_j2000_position.z := LJsonObject.Values['dscover_j2000_position']
        .AsObject.Values['z'].AsNumber;

      lunar_j2000_position.x := LJsonObject.Values['lunar_j2000_position']
        .AsObject.Values['x'].AsNumber;
      lunar_j2000_position.y := LJsonObject.Values['lunar_j2000_position']
        .AsObject.Values['y'].AsNumber;
      lunar_j2000_position.z := LJsonObject.Values['lunar_j2000_position']
        .AsObject.Values['z'].AsNumber;

      sun_j2000_position.x := LJsonObject.Values['sun_j2000_position']
        .AsObject.Values['x'].AsNumber;
      sun_j2000_position.y := LJsonObject.Values['sun_j2000_position']
        .AsObject.Values['y'].AsNumber;
      sun_j2000_position.z := LJsonObject.Values['sun_j2000_position']
        .AsObject.Values['z'].AsNumber;
      attitude_quaternions.q0 := LJsonObject.Values['attitude_quaternions']
        .AsObject.Values['q0'].AsNumber;
      attitude_quaternions.q1 := LJsonObject.Values['attitude_quaternions']
        .AsObject.Values['q1'].AsNumber;
      attitude_quaternions.q2 := LJsonObject.Values['attitude_quaternions']
        .AsObject.Values['q2'].AsNumber;
      attitude_quaternions.q3 := LJsonObject.Values['attitude_quaternions']
        .AsObject.Values['q3'].AsNumber;

      coords := LJsonObject.Values['coords'].AsString;
      date := strtodatetime(LJsonObject.Values['date'].AsString);

    end;
    LBoxItem := TListBoxItem.Create(ListBox1);
    LBoxItem.Text := FDataArray[I].image;
    ListBox1.AddObject(LBoxItem);

  end;

end;

end.
