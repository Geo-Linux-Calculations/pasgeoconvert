unit uMainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, ComCtrls, uGisCalc, mathext, ExtCtrls,uCk63;
type
  TForm1 = class(TForm)
    _convert: TButton;
    _From: TComboBox;
    _to: TComboBox;
    _Load: TButton;
    _save: TButton;
    _: TLabel;
    _lr: TLabel;
    PB1: TProgressBar;
    OD1: TOpenDialog;
    SD1: TSaveDialog;
    Panel1: TPanel;
    _Method: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    _dX: TEdit;
    _dY: TEdit;
    _dZ: TEdit;
    Label5: TLabel;
    _V0: TEdit;
    Label6: TLabel;
    _V1: TEdit;
    Label7: TLabel;
    _V2: TEdit;
    Label8: TLabel;
    _V3: TEdit;
    Label9: TLabel;
    _V4: TEdit;
    Label10: TLabel;
    _V5: TEdit;
    Label11: TLabel;
    _V6: TEdit;
    Panel3: TPanel;
    _page: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Panel2: TPanel;
    MR1: TMemo;
    MP1: TMemo;
    Panel4: TPanel;
    MR2: TMemo;
    MP2: TMemo;
    _vect: TRadioGroup;
    Panel5: TPanel;
    _lBts: TLabel;
    _lB2: TLabel;
    _lB1: TLabel;
    _lL1: TLabel;
    _ll2: TLabel;
    _lb0: TLabel;
    _ll0: TLabel;
    _Bts: TMaskEdit;
    _B2: TMaskEdit;
    _B1: TMaskEdit;
    _L1: TMaskEdit;
    _L2: TMaskEdit;
    _p2: TPanel;
    _ldN: TLabel;
    _ldW: TLabel;
    _ldM: TLabel;
    _dW: TEdit;
    _dN: TEdit;
    _dM: TEdit;
    _p3: TPanel;
    _lalpha: TLabel;
    _lgamma: TLabel;
    _lomega: TLabel;
    _lzone: TLabel;
    _alpha: TEdit;
    _gamma: TEdit;
    _omega: TEdit;
    _zone: TComboBox;
    _B0: TMaskEdit;
    _L0: TMaskEdit;
    Label1: TLabel;
    Label12: TLabel;
    _txt: TLabel;
    Proj: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    _ellps: TComboBox;
    TabSheet4: TTabSheet;
    PageControl1: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    M1: TMemo;
    b1: TMaskEdit;
    l1: TMaskEdit;
    Label15: TLabel;
    Label19: TLabel;
    _elltask: TComboBox;
    Memo1: TMemo;
    Panel6: TPanel;
    Label16: TLabel;
    Panel7: TPanel;
    _reg: TComboBox;
    procedure _convertClick(Sender: TObject);
    procedure _LoadClick(Sender: TObject);
    procedure _FromChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure _vectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MR2Enter(Sender: TObject);
    procedure MR2KeyPress(Sender: TObject; var Key: Char);
  private
    Unlock : string;
    function PrepareArray: T3dArray;
    procedure Convert1963(Pnt: T3dArray);
  public
    PJ   : TCustomProj;
    CK63 : TCk63Convertor;
  end;

var
  Form1: TForm1;

implementation
uses Math;

{$R *.dfm}


function TForm1.PrepareArray : T3dArray;
var i,sep   : integer;
    S,s0,sh : string;
    mode    : byte;
    MP      : TMemo;
begin
 Finalize(result);
 case _page.ActivePageIndex of
  0: MP:=MP1;
  1: MP:=MP2;
 end;

 for i:=0 to MP.Lines.Count-1 do
 begin
  sh:=''; s0:='';
  S:=Trim(MP.Lines.Strings[i]);
  mode:=byte(Pos('Y:',S)>0);
  case mode of
   1: sep:=Pos('Y',S);
   0: sep:=Pos('-',S);
  end;
  if (S='') or (Pos('/',S)=1) or (sep<1) then continue;
  if Pos('H=',S)>0 then
  begin
   sh:=Copy(S,Pos('H=',S)+2,LenGth(S)-Pos('H=',S)-1);
   SetLenGth(S,Pos('H=',S)-1); S:=Trim(S);
  end;
  s0:=Trim(Copy(S,sep+1+mode,LenGth(S)-sep-mode));
  SetLenGth(S,sep-1-mode);
  if mode=1 then S:=Copy(S,3,Length(S)-2);
  S:=Trim(S);
  SetLenGth(result, LenGth(result)+1);
  case mode of
   0: result[High(result)]:=Set3dPoint(DMS(S),DMS(S0),StrToFloatDef(sH,0));
   1: result[High(result)]:=Set3dPoint(StrToFloatDef(S,1/0),StrToFloatDef(S0,1/0),StrToFloatDef(sH,0));
   2: ;
  end;
 end;
end;

procedure TForm1.Convert1963(Pnt: T3dArray);
var Pout : T3dPoint;
    R    : TPointParams;
    i, j,cnt : integer;
    S : string;
begin
  for i:=0 to cnt-1  do
  case _vect.ItemIndex of
    0: begin
        R := Ck63.GeoToPlane(Pnt[i]);
        S := inttostr(i+1)+':';
        for j:=0 to LenGth(R)-1 do
         S:=S+format(' %s%d X:%.2f Y:%.2f',[R[j].Region, R[j].nZone, R[j].pPoint.X,R[j].pPoint.Y]);
        if  LenGth(R)=0 then  S:=S+' not convertible !';
        MR2.Lines.Add(S);
        Finalize(R);
       end;
    1: begin
        Pout:= Ck63.PlaneToGeo(Pnt[i], _reg.Text[1]);
        MR2.Lines.Add(format('%s-%s',[DMS(Pout.X,2,dtXLat),DMS(Pout.Y,2,dtXLong)]));
       end;
  end;
end;


procedure TForm1._convertClick(Sender: TObject);
var Res,P : T3dArray;
    S     : string;
    i     : integer;
    MR    : TMemo;
    R     : TPointParams;
begin
 case _page.ActivePageIndex of
  0: MR:=MR1;
  1: MR:=MR2;
 end;
 MR.Clear;
 P:=PrepareArray;
 ClearProjObject(PJ);

 if (_page.ActivePageIndex=1) and (Proj.ItemIndex=125) then
 begin
  Convert1963(P);
  Finalize(P);
  exit;
 end;



 case _page.ActivePageIndex of
  0: begin
      PJ.eType:=TEllpsType(_from.ItemIndex+1);
      PJ.Ellps:=Ellipsoids[PJ.eType];
      PJ.DP.eDest := TEllpsType(_to.ItemIndex+1);
      with PJ.DP do
      case _Method.ActivePageIndex of
       0: Finalize(PJ.DP.Value);
       1: begin
           SetLenGth(Value,3);
           Value[0]:=StrToFloatDef(_dX.Text,0);
           Value[1]:=StrToFloatDef(_dY.Text,0);
           Value[2]:=StrToFloatDef(_dZ.Text,0);
          end;
       2:  begin
           SetLenGth(Value,7);
           Value[0]:=StrToFloatDef(_V0.Text,0); Value[1]:=StrToFloatDef(_V1.Text,0);
           Value[2]:=StrToFloatDef(_V2.Text,0); Value[3]:=StrToFloatDef(_V3.Text,0);
           Value[4]:=StrToFloatDef(_V4.Text,0); Value[5]:=StrToFloatDef(_V5.Text,0);
           Value[6]:=StrToFloatDef(_V6.Text,0)/1E6;
          end;
      end;
      for i:=0 to LenGth(P)-1 do
      begin
       SetLenGth(res,LenGth(res)+1);
       res[High(res)]:=ConvertCoordinate(P[i],PJ);
      end;
     end;
  1: begin
      S:='proj='+ProjectionsName[Proj.ItemIndex].Id+
         ' ellps='+Ellipsoids[TEllpsType(_ellps.ItemIndex+1)].Code+
         ' lat_0='+_B0.Text+' lon_0='+_L0.Text+' lat_1='+_B1.Text+' lon_1='+_L1.Text+
         ' lat_2='+_B1.Text+' lon_2='+_L2.Text+' lat_ts='+_Bts.Text+
         ' alpha='+_Alpha.Text+' omega='+_Omega.Text+' gamma='+_gamma.Text+
         ' zone='+_Zone.Text+' N='+_dN.Text+' M='+_dM.Text+' W='+_dW.Text;
      PJ:=CreateProjObject(S,'');
      SetLenGth(res,LenGth(P));
      for i:=0 to LenGth(P)-1 do
      case _vect.ItemIndex of
       0: Res[i]:=GeoToPlane(PJ,P[i]);
       1: Res[i]:=PlaneToGeo(PJ,P[i]);
      end;
     end;

  2: begin
     end;
 end;
 Finalize(P);

 for i:=0 to LenGth(Res)-1 do
 with Res[i] do
 begin
  if IsInfinite(X) or IsInfinite(Y) then
  begin
   MR.Lines.Add('= NOT CONVERTIBLE =');
   Continue;
  end;
  case byte((_vect.ItemIndex=0)and(_page.ActivePageIndex=1))  of
   1: case byte(Z=0) of
       1: MR.Lines.Add(format('X:%.2f Y:%.2f',[X,Y]));
       0: MR.Lines.Add(format('X:%.2f Y:%.2f H=%.2f',[X,Y,Z]));
      end;
   0: case byte(Z=0) of
       1: MR.Lines.Add(DMS(X,2,dtXLat)+'-'+DMS(Y,2,dtXLong));
       0: MR.Lines.Add(DMS(X,2,dtXLat)+'-'+DMS(Y,2,dtXLong)+' H='+FloatToStrF(Z,ffFixed,8,4));
      end;
  end;
 end;
end;

procedure TForm1._LoadClick(Sender: TObject);
begin
 case byte(Sender=_Load) of
  1: if OD1.Execute then
      case _page.ActivePageIndex of
       0: MP1.Lines.LoadFromFile(OD1.FileName);
       1: MP2.Lines.LoadFromFile(OD1.FileName);
      end;
  0: if SD1.Execute then
     begin
      if (SD1.FilterIndex=1) and (Pos('.txt',SD1.FileName)=0) then
       SD1.FileName:=Sd1.FileName+'.txt';
      case _page.ActivePageIndex of
       0: MP1.Lines.SaveToFile(SD1.FileName);
       1: MP2.Lines.SaveToFile(SD1.FileName);
      end;
     end;
 end;

end;

procedure TForm1._FromChange(Sender: TObject);
const V : array[0..1,0..9] of double =
  (( 25,-141,-78.5,0,0.35 ,0.736,      0,      28,-130,-95), //ck42=>wgs84
   (-27,135 , 84.5,0,      0,    0.554,-0.2263,-28,130,95)); //wgs84=>ck42


 procedure FillValues(index:integer);
 begin
  _V0.Text:=FloatToStr(V[index][0]); _V1.Text:=FloatToStr(V[index][1]);
  _V2.Text:=FloatToStr(V[index][2]); _V3.Text:=FloatToStr(V[index][3]);
  _V4.Text:=FloatToStr(V[index][4]); _V5.Text:=FloatToStr(V[index][5]);
  _V6.Text:=FloatToStr(V[index][6]);
  _dX.Text:=FloatToStr(V[index][7]); _dY.Text:=FloatToStr(V[index][8]);
  _dZ.Text:=FloatToStr(V[index][9]);
 end;

begin

 case _page.ActivePageIndex of
  0:  if (_from.ItemIndex=29) and (_to.ItemIndex=40) then FillValues(0) else
      if (_from.ItemIndex=40) and (_to.ItemIndex=29) then FillValues(1);
  1:   begin
         _lb0.Caption:='Bo=';
         _reg.Visible:=false;
         if Proj.ItemIndex=125 then
         begin
          _lb0.Caption:='District';
          _reg.Visible:=true;
          _ellps.ItemIndex:=29;

         end;
       _ellps.Enabled:=Proj.ItemIndex<>125;
       _reg.Enabled:= _vect.ItemIndex=1;
       _lBts.Visible:=Proj.ItemIndex in [110..116,118,122,013,025,101,091,094,098,059];
       _Bts.Visible:=_lBts.Visible;
       _lB1.Visible:=Proj.ItemIndex in [119,120,10,50,52,63,39,0,26,24,49,109,78,97,64..66,43,99,73,75];
       _B1.Visible:=_lB1.Visible;
       _lB2.Visible:=Proj.ItemIndex in [0,26,24,49,109,78,97,64..66,39,99,73,75];
       _B2.Visible:=_lB2.Visible;
       _lL1.Visible:=Proj.ItemIndex in [39,99,73,75];
       _L1.Visible:=_lL1.Visible;

       _lL2.Visible:=Proj.ItemIndex in [99,73,75];
       _L2.Visible:=_lL2.Visible;

       _ldN.Visible:=Proj.ItemIndex in [29,32,102,103];
       _dN.Visible:=_ldN.Visible;

       _ldM.Visible:=Proj.ItemIndex in [32,37];
       _dM.Visible:=_ldM.Visible;

       _ldW.Visible:=Proj.ItemIndex in [43,37];
       _dW.Visible:=_ldW.Visible;

       _p2.Visible:=_ldN.Visible or _ldM.Visible or _ldW.Visible;

       _lalpha.Visible:=Proj.ItemIndex=102;
       _alpha.Visible:=_lalpha.Visible;

       _lgamma.Visible:=Proj.ItemIndex in [70,100];
       _lomega.Visible:=_lgamma.Visible;
       _gamma.Visible:=_lgamma.Visible;
       if _lgamma.Visible then PJ.Other.H:=100;
       _lzone.Visible:=Proj.ItemIndex=104;
       _zone.Visible:=_lzone.Visible;
       _p3.Visible:=_lalpha.Visible or _lgamma.Visible or _lzone.Visible;
       _lB0.Visible:= Proj.ItemIndex<>124; _B0.Visible:=_lB0.Visible;
       _l0.Visible:=_lB0.Visible and (Proj.ItemIndex<>125);
       _ll0.Visible:=_l0.Visible;
      end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i : integer;
begin
 _Method.ActivePageIndex:=0;
// for i:=0 to 2 do _method.Pages[i].TabVisible:=_Page.ActivePageIndex=0;
// _method.Pages[3].Visible :=_Page.ActivePageIndex=01;
 for i:=1 to LenGth(Ellipsoids)-1 do
 begin
  _From.Items.Add(Ellipsoids[TEllpsType(i)].eName);
  _to.Items.Add(Ellipsoids[TEllpsType(i)].eName);
  _ellps.Items.Add(Ellipsoids[TEllpsType(i)].eName);
  _elltask.Items.Add(Ellipsoids[TEllpsType(i)].eName);
 end;
 _From.ItemIndex:=29; _to.ItemIndex:=40;
 _elltask.ItemIndex:=29; _ellps.ItemIndex:=29;


 for i:=0 to LenGth(ProjectionsName)-1 do
 Proj.Items.Add(ProjectionsName[i].Comm);

 Proj.ItemIndex:=124;
 CK63 := TCk63Convertor.Create;
 Unlock := '';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 CK63.Destroy;
end;


procedure TForm1._vectClick(Sender: TObject);
begin
 case _vect.ItemIndex of
  0: _txt.Caption:=' Coordinates : (N481200.00-E321500.00)*';
  1: _txt.Caption:=' Coordinates : (X:521000 Y:-47001)* in meters';
  2: _txt.Caption:=' Coordinates : (X:521000 Y:-47001)* in meters';
 end;
 _reg.Enabled:= _vect.ItemIndex=1;
end;


procedure TForm1.MR2Enter(Sender: TObject);
begin
 if Unlock='patritionmagic' then exit;
 Unlock:='';
end;

procedure TForm1.MR2KeyPress(Sender: TObject; var Key: Char);
begin
  if Unlock='patritionmagic' then exit;
  Unlock := Unlock+Key;
end;

initialization
 DecimalSeparator:='.';

end.
