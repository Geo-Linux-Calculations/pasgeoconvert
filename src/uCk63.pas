unit uCk63;

interface
uses MathExt, uGisCalc;

 type
  TCk63RegionChar = 'A'..'Z';
  TRowMask    = array of byte;
  TRegionMask = array of TRowMask;

  TCk63Key = packed record
   Region: TCk63RegionChar;
   CM    : double;   // central meridian of the 1st zone
   dB    : double;   // shift of the beginning of the CS from the equator to the north in minutes
   dX    : double;   // ---//--- in meters on the Krasovsky ellipsoid
   dY    : double;   // offset of the origin from the axial meridian to the west in km.
   Z6    : byte;     // sign of a 6-degree zone (if = 1) otherwise the zone is three-degree
   Nr,Nc : byte;     // starting item number (Nr-line Nc-column)
   rows  : word;     // total items vertically (rows) "northward"
   cols  : word;     // total nomenclatures by city (columns) "to the east"
   // coordinates of the rectangle describing all the nomenclatures of the region
   B0,L0 : double;   // south-western corner of the area (origin of the nomenclature)
   // presence / absence mask of nomenclature sheets 1: 100000 in a frame B0,L0 + B1,L1
   Mask  : string;   // mask in hexadecimal format with spaces
   // the mask is set bit by bit from the south-west corner of the area with the reference to the east and north
   // for example, there is an area with this configuration:
   // * *** *** **   => 101110111011  (get out) => 101110111011 => 0 x BBB
   // ************   => 111111111111  (get out) => 111111111111 => 0 x FFF
   // ************   => 111111111111  (get out) => 111111111111 => 0 x FFF
   // ***** *** **   => 111110111011  (get out) => 110111011111 => 0 x DDF
   // counting from left to right in a row, for perception we unfold the mask
   // because in programming, bits are counted from right to left
   // bottom row 110111011111 (turned out already) = 1101 1101 1111 (grouped) = 0xDDF
   // format BITMASK:ROWS[*]  *-six-degree zone, items are assembled
  end;

  TNomenclature63 = packed record
    Region    : TCk63RegionChar;
    IsCompone : byte;
    Row,Col   : word;
    Quad      : TQLongLat;
    SubQuad   : TNomenLess100;
  end;
  TNomenclatureArray = array of TNomenclature63;

  TPointParam = packed record
    Region   : TCk63RegionChar;
    nZone    : byte;      // zone number in the area
    zWidth   : byte;      // width in degrees
    CM       : double;    // central meridian in degrees
    Row,Col  : word;      // index (offset) of the item in the zone
    geoPoint : T3dPoint;  // point with CK42 radians
    pPoint   : T3dPoint;  // point in CK63 meters
  end;
  TPointParams = array of  TPointParam;

  TCk63Convertor = class(TObject)
   private
    FKrassovsky    : TEllipsoidProperty;
    FMask          : array[TCk63RegionChar] of TRegionMask;
    procedure  UnpackMask(index:TCk63RegionChar);
    function   GaussForward(lp: T3dPoint; const Param : TPointParam): T3dPoint;
    function   PointInZone(gPoint : T3dPoint):TPointParams;
    function GetKey(value:TCk63RegionChar): TCK63Key;

   public
    property    Key[Region:TCk63RegionChar] : TCK63Key read GetKey;

    constructor Create;
    destructor  Destroy; override;
    function    CreateRegionNomenclature(xRegion : TCk63RegionChar;
       const Compone : boolean =false): TNomenclatureArray;
    function    SelectNomenclature100(gPntSW,gPntNE: T3dPoint): TNomenclatureArray;
    function SelectSubNomenclature(NOM:TNomenclature63;
           R0,R1 : T3dPoint; Scale : Cardinal; var data:TNomenclatureArray): boolean;
    function    GeoToPlane(gPoint : T3dPoint): TPointParams; overload;
    function    GeoToPlane(gPoint: T3dPoint;  Region: TCk63RegionChar;
      const Zone : byte = 1): T3dPoint; overload;
    function    PlaneToGeo(PntXY: T3dPoint;   Region:TCk63RegionChar): T3dPoint;

    // find point of rectangular network
    function    SelectGrid(N: TNomenclature63; var gGrid : T3dMatrix):boolean;
    function    SelectZoneInfo(Region: TCk63RegionChar; Zone: byte): TPointParam;
    function    StringToNomenclature(const sNomen:String) : TNomenclature63;

  end;


implementation
uses Math,SysUtils,Classes;

//Axial meridian of the 1st zone: FirstMainParallel
//Zone width: SecondMainParallel
//Axial meridian: AxisMeridian
//Zone number: ZoneNumber

//Horizontal offset: in MainPointParallel divided by 100 000
//Vertical offset: in PoleLongitude divided by 10 000

 const
  Ck63KeyArray : array[TCk63RegionChar] of TCk63Key =(
  (Region:'A';  CM:38.533333334; dB:7; dX:-12900.5630652885; dY:300; Z6:0; Nr:32; Nc:14;
     rows:19;cols:24;  B0:37.383333333334; L0:39.5333333334;  // B0 (selected)
     Mask:'FFFFFF:13 FFF:2 3FF:2 3F:2'),

  (Region:'B';  CM:75.2166666667; dB:9; dX:-16586.4382267995;  dY:300; Z6:0; Nr:39; Nc:18;
     rows:11;cols:22;  B0:42.833333334; L0:74.7166666667;  Mask:'3FFFFF:11'),

  (Region:'C';  CM:21.95;       dB:6; dX:-11057.625484533;  dY:250; Z6:0; Nr:35; Nc:12;
     rows:39; cols:40;  B0:51.333333334; L0:18.95;  // B0 * - rough according to CK42!
     Mask:'7FFFFFF:23 7FFFFFFFFF:2 7FFFFFFFFF:2 7FFFFFC000:9*'),

  (Region:'D';  CM:38.55;       dB:8; dX:-14743.500646044;  dY:250; Z6:0; Nr:38; Nc:31;
     rows:30;cols:44;  B0:053.68333333334; L0:037.55;  // B0 * (selected)
     Mask:'3FE00:5 1FFFE00:2 1FFFFFF:1 FFFFFFFFFF:4 FFFFFFFFFFF:7 FFFFFFFFFFF:10*'),

  (Region:'E';  CM:77.766666667; dB:8; dX:-14743.500646044;  dY:300; Z6:0; Nr:42; Nc:26;     // +++
     rows:12; cols:25; B0:46.483333334; L0:76.76666667;
     Mask:'7FFFF:2 1FFFFFF:10'),

  (Region:'F';  CM:97.0333333334; dB:6; dX:-11057.625484533;  dY:250; Z6:0; Nr:00 ;Nc:00;
     rows:37; cols:49; B0:46.666666667; L0:96.533333334;   // B0 * - rough according to CK42!
     Mask:'1FFFFFFFFFFFF:12 FFFFFFFFFFFF:25'),

  (Region:'G';  CM:121.7166666667; dB:9; dX:-16586.4382267995;  dY:300; Z6:0; Nr:12 ;Nc:17;
     rows:51; cols:50; B0:42.033333334; L0:120.2166666667;
     Mask:'FFFFC0000:1 7FFFFFFC0000:13 3FFFFFFFC0000:7 3FFFFFFFFF000:5 FFFFFFFFFFFF:25'),

  (Region:'H';  CM:47.76666667; dB:8; dX:-14743.500646044;  dY:300; Z6:0; Nr:30; Nc:36;
     rows:31; cols:33;  B0:42.6166666667; L0:46.766666667;   // B0 * (selected)
     Mask:'7FFE0:8 1FFFFFE0:7 3FFFFFFE0:1 3FFFFFFFF:2 FFFFFFFF:4 FFFFFFF0:2 1FFF0:1 1FF80:2'),

  (Region:'I';  CM:68.73333333; dB:7; dX:-12900.5630652885;  dY:250; Z6:0; Nr:31; Nc:37;
     rows:18; cols:32; B0:53.2833333334; L0:68.7333333333;
     Mask:'E00:1 1C000E00:1 1FFFFFF0:1 FFFFFFF0:2 FFFFFFFF:13'),

 (Region:'J';  CM:158.4666666667; dB:9; dX:-16586.4382267995;  dY:400; Z6:1; Nr:01; Nc:19;
     rows:96; cols:97; B0:42.816666666667; L0:143.4666666667;  // B0 - rough (43 to 49 sec) costs 49
     Mask:'1FFFFFF:12 1FFFFFF800:12 FFFFFFFF80000:24 1FFFFFFFFFFFFFFFFFFÑ00000:4 '+
          '1FFFFFFFFFFFFFFFFFFÑ00000:34* 3FFFFFF000000000000000:10*'),

  (Region:'K';  CM:61.7166666667; dB:6; dX:-11057.625484533;  dY:300; Z6:0; Nr:35; Nc:47;  // +++++++++
     rows:23; cols:32; B0:43.3; L0:61.2166666667;
     Mask:'7FFFFFF:10 FFFFFFFF:4 FFFFFFF0:3 FFF80000:6 3C00000:1'),

  (Region:'L';  CM:75.5166666667; dB:9; dX:-16586.4382267995;  dY:500; Z6:1; Nr:03; Nc:48;
     rows:104; cols:61; B0:47.166666667; L0:75.0166666667;
     Mask:'FFFF0000000:27 FFFFFF80000:8 1FFFFFFFFFF80000:1 1FFFFFFFFFFFF000:3 '+
         '1FFFFFFFFFFFF000:56* 1FFFFFFFFFFFFFFF:9*'),

  (Region:'M';  CM:79.5166666667; dB:7; dX:-12900.5630652885;  dY:300; Z6:0; Nr:36; Nc:44;
     rows:18; cols:22;  B0:50.4833333334; L0:78.5166666667;
     Mask:'3FFFFF:11 3FFE00:1 3FF000:6'),

  (Region:'N';  CM:20.96666667; dB:9; dX:-16586.4382267995;  dY:250; Z6:0),  //----
  (Region:'O';  CM:29.05;       dB:8; dX:-14743.500646044;  dY:200; Z6:0),  //----

  (Region:'P';  CM:32.48333333334; dB:7; dX:-12900.5630652885;  dY:250; Z6:0; Nr:29; Nc:73;
     rows:29; cols:22;  B0:49.68333333; L0:31.98333333334;
     Mask:'1FF800:1 FF800:1 FFFC0:2 3FFFF0:1 3FFFFF:12 1FFFFF:2 1FFF:4 FFF:6'),

  (Region:'Q';  CM:32.0333333333; dB:6; dX:-11057.625484533;  dY:400; Z6:1; Nr:34; Nc:19;
     rows:58; cols:82;  B0:62.95; L0:29.0333333333;      // B0 * (selected - 3 min)!
     Mask:'3FFFFFFFFFFFFFF:25* 3FFFFF000000000:4* 3FFFFFFFF000000000:5* '+
          'FFFFFFFFFFFFFF000000000:3* 3FFFFFFFC000000000000:10* '+
          '3FFFFFFFFFFFFFFFFFFC000:10*'),

  (Region:'R';  CM:43.05; dB:8; dX:-14743.500646044;  dY:300; Z6:0; Nr:27; Nc:76;
      rows:30; cols:18;  B0:45.433333334; L0:41.55;
      Mask:'FFE0:6 FFFC:2 7FC:3 7FE:2 7FFF:3 3FFFF:1 3FFFC:5 3FFC:3 3E00:5'),

  (Region:'S';  CM:108.45; dB:8; dX:-14743.500646044;  dY:400; Z6:1; Nr:22; Nc:10;
     rows:60; cols:174;  B0:58.8166666667; L0:105.45;
     Mask:'7FFFFFFFFFFFFFFFFFFFFFFFF:4 7FFFFFFFFFFFFFFFFFFFFFFFF:34* '+
          'FFFFFFFFFFFFFFFFFFFFFFFFF:10* FFFFFFFFFFFFC000000000FFFFF:12*'),

  (Region:'T';  CM:37.9833333334; dB:6; dX:-11057.625484533;  dY:300; Z6:0; Nr:33; Nc:13;
     rows:25; cols:30;  B0:41.4833333333333334; L0:36.4833333334; // B0 from Oleg's program!
     Mask:'3FFC0000:2 3FFF0000:2 3FFF000:2 3FFFFFF:6 FFFF:3 FFFC:1 FFF8:2 '+
          '1FF8:2 1F80:5'),

  (Region:'U';  CM:53.51666666667; dB:8; dX:-114743.500646044;  dY:300; Z6:0; Nr:20; Nc:28;
     rows:32; cols:62;  B0:34.833333334; L0:51.01666666667;
     Mask:'1F00000:3 3FFFFFFFFFFFF:11 3FFFFFFFFFFFFFFF:10 FFFFFFFFFC00:2 1FFC00:6'),

  (Region:'V';  CM:49.0333333334; dB:5; dX:-9214.68790377751;   dY:300; Z6:0; Nr:18; Nc:22;
     rows:19; cols:41;   B0:50.5666666667; L0:48.533333334;
     Mask:'3FFE000:3 3FFFFF0:2 3FFFFFC:1 3FFFFFF:4 1FFFFFFF:1 1FFFFFFFF:1 3FFFFFFFFF:1 '+
          '1FFFFFFFFFF:2 1FFFFFFFFFE:3 1FFF8000000:1'),

  (Region:'W';  CM:60.05;  dB:6; dX:-11057.625484533;  dY:500; Z6:1; Nr:16; Nc:24;
     rows:56; cols:48;   B0:55.85; L0:57.05;
     Mask:'1F:1 3FF:2 FFFFFF:1 FFFFFE:2 FFFFF0:4 FFFFFFFFFFF0:3 '+
          'FFFFFFFFFFF0:9* FFFFFFFFFFFF:29* FFFFFFFFF000:5*'),

  (Region:'X';  CM:23.5;   dB:5; dX:-9214.68790377751;   dY:300; Z6:0; Nr:23; Nc:40;
     rows:24; cols:36; B0:43.4666666667; L0:22.00;
     Mask:'1FFFF000:8 7FFFF000:1 FFFFF000:2 FFFFFFFF:2 FFFFFFFFF:6 7FFFFFFF:2 3FFFFFF:2 FFFFFF:1'),

  (Region:'Y';  CM:52.0166666667; dB:7; dX:-12900.5630652885;  dY:250; Z6:0; Nr:30; Nc:53;  // +++++
     rows:20; cols:34;  B0:48.466666667; L0:61.5166666667;
    Mask:'7FFFC:6 3FE3FFFFF:1 3FFFFFFFF:9 3FCFFFFFF:1 7FFF8:1 7FF80:1 7F000:1'),

  (Region:'Z';  CM:59.78333333; dB:7; dX:-12900.5630652885;  dY:300; Z6:0));   // ----


constructor TCk63Convertor.Create;
var M   : TCk63RegionChar;
begin
  inherited Create;
  FKrassovsky := Ellipsoids[ellKrass];
  for M:='A' to 'Z' do
   UnpackMask(M);
end;

destructor TCk63Convertor.Destroy;
var M : TCk63RegionChar;
    n : integer;
begin
  for M:='A' to 'Z' do
  begin
   for n:=0 to LenGth(FMask[M])-1 do
   Finalize(FMask[M][n]);
   Finalize(FMask[M]);
  end;
  inherited;
end;



procedure TCk63Convertor.UnpackMask(index:TCk63RegionChar);
var n,C  : integer;
    i,ps : integer;
    SL   : TStringList;
    S,cS : string;
    is6  : boolean;
    FKey : TCk63Key;
const
  sHex = '0123456789ABCDEF';

    procedure DecodeHexMask(var R : TRowMask);
    var _i,_j : integer;
        _val  : byte;
    begin
      for _i:=LenGth(S) downto 1 do
      begin
        _val:=Pos(S[_i],sHex)-1;
        if not (_val in [0..15]) then continue;
        for _j:=0 to 3 do
        begin
          SetLenGth(R, LenGth(R)+1);
          R[High(R)]:= byte((_val and ($01 shl _J))>0);
          if is6 and (R[High(R)]=1) then  R[High(R)]:=2;
        end;
      end;
    end;

begin
  FKey := Ck63KeyArray[index];
  for n:=0 to LenGth(FMask[index])-1 do
  Finalize(FMask[index][n]);
  Finalize(FMask[index]);
  if (FKey.Mask='') or (FKey.cols<1) or (FKey.rows<1) then exit;


  SL  := TStringList.Create;
  SL.Delimiter:=' ';
  SL.DelimitedText:= FKey.Mask;
  for n:=0 to SL.Count-1 do
  begin
    S:=Trim(SL.Strings[n]);
    ps:=Pos(':',S);
    if ps<1 then continue;
    cS:=Copy(S, ps+1, LenGth(S)-1);
    is6:=Pos('*', cS)=LenGth(cS);
    if is6 then delete(cs, LenGth(cS),1);
    C:=StrToIntDef(cS,0);
    if C<1 then continue;
    SetLenGth(S, ps-1);
    for i := 0 to C-1 do
    begin
     SetLength(FMask[index], LenGth(FMask[index])+1);
     DecodeHexMask(FMask[index][High(FMask[index])]);
     SetLenGth(FMask[index][High(FMask[index])], FKey.cols);
    end;
  end;
  SL.Free;
end;


// =============================================================================
// GAUSS-KRUGER
function TCk63Convertor.GaussForward(lp : T3dPoint; const Param : TPointParam): T3dPoint;
var N, X       : extended;
    l_ro,l_ro2 : extended;
    T2, n2     : extended;
    Key        : TCk63Key;
begin
   Key := Ck63KeyArray[Param.Region];
   X:=FKrassovsky.a*(1-FKrassovsky.es)*(1.0050517739*lp.phi-0.5*0.0050623776*sin(2*lp.phi)+
   0.25*0.0000106245*sin(4*lp.phi)+0.0000000208*sin(6*lp.phi)/6);
   N:=FKrassovsky.a/sqrt(1-FKrassovsky.es*sqr(sin(lp.phi)));
   T2:=sqr(tan(lp.phi));
   n2:=FKrassovsky.es*sqr(cos(lp.phi))/(1-FKrassovsky.es);
   L_ro:=0.017453276125372700167260562868155*(180*lp.lam/pi-Param.CM)*cos(lp.phi);
   l_ro2:=l_ro*l_ro;
   result.X:=l_ro2*(1+l_ro2*((5-T2+9*n2+4*n2*n2)+l_ro2*(61-58*t2+t2*t2+270*n2-330*n2*t2)/30)/12);
   result.X:=X+0.5*result.X*N*tan(lp.phi);
   result.X:= result.X+Key.dX;
   result.Y:=1+l_ro2*(1-T2-n2+l_ro2*((5-18*t2+t2*t2+14*n2-58*n2*t2+13*n2*n2-64*n2*n2*t2)+
   l_ro2*(61-479*t2+179*t2*t2-t2*t2*t2)/42)/20)/6;
   result.Y:=l_ro*N*result.Y+Param.nZone*1E6+Key.dY*1E3;
end;


function TCk63Convertor.PlaneToGeo(PntXY : T3dPoint; Region:TCk63RegionChar): T3dPoint;
var  L0, B, n2        : extended;
     t2, y, y2, cosB   : extended;
     rMax, rMin, delta : extended;
     i,z               : byte;
     XY                : T3dPoint;
     Key               : TCk63Key;
begin
  Key := Ck63KeyArray[Region];
  XY.X:= PntXy.X - Key.dX; XY.Y:= PntXy.Y;
  rMax:=pi/2; rMin:=-pi/2;
  i:=0; B:=0;

  delta:=3.1574632693616299*FKrassovsky.a*(1-FKrassovsky.es);
  if (delta<Abs(XY.X)) then B:=Pi*(1-2*byte(XY.X<0))/2 else
  begin
   repeat
    inc(i);
    if delta>0 then rMin:=B;
    if delta<0 then rMax:=B;
    B:=(rMax+rMin)/2;
    Delta:=XY.X-FKrassovsky.a*(1-FKrassovsky.es)*(1.0050517739*B-0.5*0.0050623776*sin(2*B)+
    0.25*0.0000106245*sin(4*B)+0.0000000208*sin(6*B)/6);
   until (Abs(Delta)<=1e-8) or (i>253);
   B:=(rMax+rMin)/2;
  end;
  // found Latitude
  cosB:=cos(B);
  t2:=sqr(tan(B));
  n2:=FKrassovsky.es*sqr(cosB)/(1-FKrassovsky.es);
  // arc within a zone
  y:=(1e6*Frac(XY.Y/1E6)-Key.dY*1000)*sqrt(1-FKrassovsky.es*sqr(sin(B)))/FKrassovsky.a;
  y2:=sqr(y);
  z:=3+3*Byte(Key.Z6=1);
  // axial
  L0:=Key.CM+(Trunc(XY.Y/1E6)-1)*z;
  result.Y:=1-y2*((1+2*t2+n2)+y2*(0.25+1.4*t2+1.2*t2*t2+3*n2/10+0.4*t2*n2))/6;
  result.Y:=pi*(L0+y*result.Y*57.2958333333333333333/cosB)/180;
  result.X:=(5+3*t2+6*n2-6*n2*t2)-y2*(2+1/30+3*t2+1.5*t2*t2);
  result.X:=B-DegToRad(y2*(0.5*(1+N2)+y2*result.X/24)*57.29583333333333333333*tan(B));
end;


{ TCk63Convertor }

function TCk63Convertor.GeoToPlane(gPoint: T3dPoint): TPointParams;
var i : integer;
begin
  result:=PointInZone(gPoint);
  for i:=0 to LenGth(result)-1 do
  begin
    result[i].geoPoint:= gPoint;
    result[i].pPoint  := GaussForward(gPoint, result[i]);
  end;
end;

function TCk63Convertor.GeoToPlane(gPoint: T3dPoint; Region: TCk63RegionChar;
 const Zone : byte = 1): T3dPoint;
var i  : integer;
    PP : TPointParam;
begin
  PP.Region := Region;
  PP.nZone  := Zone;
  PP.zWidth := 3*(Ck63KeyArray[Region].Z6+1);
  PP.CM     := Ck63KeyArray[Region].CM + (Zone-1)*PP.zWidth;
  result    := GaussForward(gPoint, PP);
end;


function TCk63Convertor.CreateRegionNomenclature(xRegion: TCk63RegionChar;
   const Compone : boolean = false): TNomenclatureArray;
var i,j  : integer;
    M    : TRegionMask;
    nr   : boolean;
    K    : TCk63Key;
begin
  Finalize(result);
  M := FMask[xRegion];
  K := Ck63KeyArray[xRegion];
  for i:=0 to LenGth(M)-1 do     // rows
  begin
   j:=-1; nr:=true;
   while j<LenGth(M[i])-1 do  // columns
   begin
    inc(j);
    if M[i][j]=0 then continue;
    if not nr and Compone and (M[i][j]=2) and
       ((j mod 2)=1) and (LenGth(result)>0) then
    begin
     with result[High(result)] do
     begin
      IsCompone := K.Nc+j;
      Quad.L1   := Quad.L1+pi/360;
     end;
     continue;
    end;
    SetLenGth(result, LenGth(result)+1);
    with result[High(result)] do
    begin
     Region  := xRegion;
     Row     := K.Nr+i; Col     := K.Nc+j;
     IsCompone:=0;
     Quad.B0 := pi*(K.B0+i*0.33333334)/180;
     Quad.L0 := pi*(K.L0+j*0.5)/180;
     Quad.B1 := pi*(K.B0+(i+1)*0.33333334)/180;
     Quad.L1 := pi*(K.L0+(j+1)*0.5)/180;
     Quad.Scale:=100000;
    end;
    nr:=false;
   end;
  end;

end;

function TCk63Convertor.PointInZone(gPoint: T3dPoint): TPointParams;
var i       : TCk63RegionChar;
    nx,ny   : integer;
    P       : T3dPoint;
    K       : TCk63Key;
    r1, r2  : T3dPoint;
begin
  Finalize(result);
  // CK63 does not work in the southern and western hemispheres!
  if (gPoint.Y<0) or (gPoint.X<0) then exit;
  for i:='A' to 'Z' do
  begin
    if LenGth(FMask[i])<1 then continue;
    P.X:=gPoint.X*180/pi;  P.Y:=gPoint.Y*180/pi;
    K:= Ck63KeyArray[i];
    r1.X:=K.B0;  r1.Y:=K.L0;
    r2.X:=K.B0+K.rows/3;
    r2.Y:=K.L0+K.cols/2;
    // check if the point fits into the zone (roughly)
    if (P.X<r1.X) or (P.Y<r1.Y) or (P.X>r2.X) or (P.Y>r2.Y) then continue;
    // check if the point fits into the zone (exactly)
    // relative latitude / longitude in squares 100000
    nx:=Trunc((P.X-K.B0)*3);  ny:=Trunc((P.Y-K.L0)*2);
    // additional square hit check
    // so that the Execution does not fly out if the square is not set
    if (nx>=LenGth(FMask[i])) or (nx<0) then  continue;
    if (ny>=LenGth(FMask[i][nx])) or (ny<0) then continue;
    // precise check by item mask
    if FMask[i][nx,ny] = 0 then  continue;
    // if we are here then the point belongs to the current zone
    SetLenGth(result, LenGth(result)+1);
    with result[high(result)] do
    begin
     geoPoint  := gPoint;
     Region := i;
     Row    := nx;  Col := ny;
     P.Y    := gPoint.Y*180/pi;      // offset in degrees from start
     zWidth := 3+3*byte(gPoint.Y>pi/3);
     // calculation of the 1st axial in the paired zone 6x3
     // the axial meridian of a 6*degree zone can be further than 1.5 degrees
     // to the east, in this case, draw an additional meridian for the 3rd zone
     if (Round(zWidth)=3) and (Round(100*(K.CM-K.L0))>150) then K.CM:=K.CM-3;
     for nx := 0 to 20 do
     begin
      nZone := nx+1;
      if Abs(P.Y-K.CM)<=zWidth/2 then break;
      K.CM:= K.CM+zWidth;
     end;
     CM:=K.CM;
    end;
  end;
end;


function TCk63Convertor.SelectNomenclature100(gPntSW, gPntNE : T3dPoint): TNomenclatureArray;
var i,j  : integer;
    r    : TCk63RegionChar;
    _Q   : TQLongLat;
    Rct  : TQLongLat;
    K    : TCk63Key;
    mode : byte;
    IsCheck : boolean;

    function _PIR(B,L:double; Q: TQLongLat):boolean;
    begin
     result:=(B>=Q.b0) and  (L>=Q.l0) and
             (B<=Q.b1) and  (L<Q.l1);
    end;
begin
  mode:=0;  // checking the hit of items in the specified area
  Finalize(result);
  Rct.b0:=Abs(180*(gPntNE.X-gPntSW.X)/pi);
  Rct.l0:=Abs(180*(gPntNE.Y-gPntSW.Y)/pi);
  // if the square is less than the nomenclature sheet
  // (we check if the area is included in the nomenclature)
  if (Rct.b0<1/3) and  (Rct.l0<0.5) then mode:=1;

  Rct.b0:=gPntSW.X;  Rct.l0:=gPntSW.Y;
  Rct.b1:=gPntNE.X;  Rct.l1:=gPntNE.Y;

  for r:='A' to 'Y' do
  begin
    K:=Ck63KeyArray[r];
    for i:=0 to LenGth(FMask[r])-1 do
     for j:=0 to LenGth(FMask[r][i])-1 do
     if FMask[r][i,j]<>0 then
     begin
       _Q.b0:=pi*(K.B0+i/3)/180;     _Q.l0:=pi*(K.L0+j/2)/180;
       _Q.b1:=pi*(K.B0+(i+1)/3)/180; _Q.l1:=pi*(K.L0+(j+1)/2)/180;
       case mode of
        0:  IsCheck := _PIR(_Q.b0,_Q.l0, Rct) or _PIR(_Q.b0,_Q.l1, Rct)  or
                       _PIR(_Q.b1,_Q.l1, Rct) or _PIR(_Q.b1,_Q.l0, Rct);
        1:  IsCheck := _PIR(Rct.b0,Rct.l0,_Q) or _PIR(Rct.b0,Rct.l1,_Q)  or
                       _PIR(Rct.b1,Rct.l1,_Q) or _PIR(Rct.b1,Rct.l0,_Q);
       end;
       if IsCheck then
       begin
        SetLenGth(result, LenGth(result)+1);
        with result[high(result)] do
        begin
          Region:=r;
          Quad.Scale:=100000;
          Row       := K.Nr+i; Col := K.Nc+j;
          Quad.B0   := _Q.b0;  Quad.L0:= _Q.l0;
          Quad.B1   := _Q.b1;  Quad.L1:= _Q.l1;
        end;
       end;

     end;
  end;
end;


function TCk63Convertor.SelectSubNomenclature(NOM:TNomenclature63;
   R0,R1 : T3dPoint; Scale : Cardinal; var data:TNomenclatureArray): boolean;
var i,k,h  : integer;
    _2     : TNomenclatureArray;
    _4     : TNomenclatureArray;
    _6     : TNomenclatureArray;
    db, dl : double;
    _NM    : TNomenclature63;
    _rec   : TQLongLat;

    function _PIR(B,L:double; Q: TQLongLat):boolean;
    begin
     result:=(B>=Q.b0) and  (L>=Q.l0) and
             (B<=Q.b1) and  (L<Q.l1);
    end;


    function _TrimQuad2(S:TNomenclature63):TNomenclatureArray;
    var j  : integer;
        _Q : TNomenclature63;
    begin
      db:=Abs(0.5*(S.Quad.B1-S.Quad.B0));
      dl:=Abs(0.5*(S.Quad.L1-S.Quad.L0));
      for j:=0 to 3 do
      begin
       _Q := S;
       case j of
         0: begin
             _Q.Quad.B0:= S.Quad.B0+db;
             _Q.Quad.L1:= S.Quad.L0+dl;
            end;
         1: begin
             _Q.Quad.B0:= S.Quad.B0+db;
             _Q.Quad.L0:= S.Quad.L0+dl;
            end;
         2: begin
             _Q.Quad.B1:= S.Quad.B0+db;
             _Q.Quad.L1:= S.Quad.L0+dl;
            end;
         3: begin
             _Q.Quad.B1:= S.Quad.B0+db;
             _Q.Quad.L0:= S.Quad.L0+dl;
            end;
        end;
        case round(S.Quad.Scale div 1000) of
         100: begin
               _Q.SubQuad.Q10_1 :=j+1;
               _Q.Quad.Scale := 50000;
              end;
         50 : begin
               _Q.SubQuad.Q10_2 :=j+1;
               _Q.Quad.Scale := 25000;
              end;
         25 : begin
               _Q.SubQuad.Q10_3 :=j+1;
               _Q.Quad.Scale := 10000;
              end;
        end;
        if (_PIR(R0.X,R0.Y,_Q.Quad) or _PIR(R0.X,R1.Y,_Q.Quad) or
           _PIR(R1.X,R1.Y,_Q.Quad) or _PIR(R1.X,R0.Y,_Q.Quad)) or
            (_PIR(_Q.Quad.B0,_Q.Quad.L0,_rec) or _PIR(_Q.Quad.B0,_Q.Quad.L1,_rec) or
             _PIR(_Q.Quad.B1,_Q.Quad.L0,_rec) or _PIR(_Q.Quad.B1,_Q.Quad.L1,_rec)) then
        begin
         SetLenGth(result, LenGth(result)+1);
         Move(_Q, result[High(result)], SizeOf(TNomenclature63));
        end;
      end;
    end;

begin
  Finalize(result);
  if (Scale>100000) or (NOM.Quad.Scale>100000) or
     (NOM.Quad.Scale<10000) then exit;
  _rec.B0:=R0.X;  _rec.L0:=R0.Y;
  _rec.B1:=R1.X;  _rec.L1:=R1.Y;
  if Scale=100000 then
  begin
   SetLenGth(data,1);
   data[0]:= NOM;
   exit;
  end;
  case Scale div 1000 of
   50: data:=_TrimQuad2(NOM);
   25: begin
         _2:=_TrimQuad2(NOM);
         for i:=0 to LenGth(_2)-1 do
         begin
          _4:=_TrimQuad2(_2[i]);
          if LenGth(_4)<1 then continue;
          h:=LenGth(data);
          SetLenGth(data, LenGth(data)+LenGth(_4));
          Move(_4[0], data[h], LenGth(_4)*SizeOf(TNomenclature63));
          Finalize(_4);
         end;
         Finalize(_2);
       end;
   10:  begin
         _2:=_TrimQuad2(NOM);
         for i:=0 to LenGth(_2)-1 do
         begin
          _4:=_TrimQuad2(_2[i]);
          for k:=0 to LenGth(_4)-1 do
          begin
           _6:=_TrimQuad2(_4[k]);
           if LenGth(_6)<1 then continue;
           h:=LenGth(data);
           SetLenGth(data, LenGth(data)+LenGth(_6));
           Move(_6[0], data[h], LenGth(_6)*SizeOf(TNomenclature63));
          end;
          Finalize(_4);
         end;
         Finalize(_2);
       end;
    5: begin
         db:=Abs(NOM.Quad.B1-NOM.Quad.B0)/16;
         dl:=Abs(NOM.Quad.L1-NOM.Quad.L0)/16;
         for i:=0 to 15 do
          for k:=0 to 15 do
          begin
           _NM:=NOM;
           _NM.Quad.Scale:=5000;
           _NM.SubQuad.Q05:=i*16+k;
           with _NM.Quad do
           begin
            B0:= NOM.Quad.B0+(16-i)*db;
            B1:= NOM.Quad.B0+(15-i)*db;
            L0:= NOM.Quad.L0+ k*dl;
            L1:= NOM.Quad.L0+ (k+1)*dl;
           end;
           // if the area falls into a square ...
           if (_PIR(R0.X,R0.Y,_NM.Quad) or _PIR(R0.X,R1.Y,_NM.Quad) or
             _PIR(R1.X,R1.Y,_NM.Quad) or _PIR(R1.X,R0.Y,_NM.Quad)) or
           // ... or if the square falls into the area
             (_PIR(_NM.Quad.B0,_NM.Quad.L0,_rec) or _PIR(_NM.Quad.B0,_NM.Quad.L1,_rec) or
              _PIR(_NM.Quad.B1,_NM.Quad.L0,_rec) or _PIR(_NM.Quad.B1,_NM.Quad.L1,_rec)) then
           begin
            SetLenGth(data, LenGth(data)+1);
            Move(_NM, data[High(data)], SizeOf(TNomenclature63));
           end;
          end;
       end;
  end;
end;


function TCk63Convertor.SelectGrid(N: TNomenclature63; var gGrid : T3dMatrix):boolean;
var  A    : array[0..3] of T3dPoint;
     _min : T3dPoint;
     _max : T3dPoint;
     P    : T3dPoint;
     i,hx,hy  : integer;
     d    : cardinal;
     fZone : byte;
     PP: TPointParams;
begin
  result:=false;
  Clear3dMatrix(gGrid);
  d:=(N.Quad.Scale div 50);
  if d=0 then exit;
  A[0].X:=0.5*(N.Quad.B1+N.Quad.B0);
  A[0].Y:=0.5*(N.Quad.L1+N.Quad.L0);
  PP:=PointInZone(A[0]);
  if LenGth(PP)<1 then exit;
  hx:=0;
  for i:=0 to LenGth(PP)-1 do
  if PP[i].Region=N.Region then
  begin
   A[0]  := GaussForward(A[0], PP[i]);
   fZone := PP[i].nZone;
   hx    :=1;
   break;
  end;
  Finalize(PP);
   if hx=0 then exit;

  A[0].X:=N.Quad.B0;    A[0].Y:=N.Quad.L0;
  A[1].X:=N.Quad.B1;    A[1].Y:=N.Quad.L0;
  A[2].X:=N.Quad.B1;    A[2].Y:=N.Quad.L1;
  A[3].X:=N.Quad.B0;    A[3].Y:=N.Quad.L1;
  _min.X:= 1E20;  _min.Y:= 1E20;
  _max.X:=-1E20;  _max.Y:=-1E20;
  for i:=0 to 3 do
  begin
   A[i]:=GeoToPlane(A[i], N.Region, fZone);
   if A[i].X<_min.X then _min.X:=A[i].X;
   if A[i].Y<_min.Y then _min.Y:=A[i].Y;
   if A[i].X>_max.X then _max.X:=A[i].X;
   if A[i].Y>_max.Y then _max.Y:=A[i].Y;
  end;
  _min.X:=d*Trunc(_min.X/d); _min.Y:=d*Trunc(_min.Y/d);
  _max.X:=d*Ceil(_max.X/d);  _max.Y:=d*Ceil(_max.Y/d);
  P :=_min;
  while _min.X<=_max.X do
  begin
    SetLenGth(gGrid, LenGth(gGrid)+1) ;
    hx:= High(gGrid);
    while _min.Y<=_max.Y do
    begin
      SetLenGth(gGrid[hx], LenGth(gGrid[hx])+1);
      hy:= High(gGrid[hx]);
      gGrid[hx,hy] :=PlaneToGeo(_min, N.Region);
      _min.Y:=_min.Y+d;
    end;
   _min.Y:= P.Y;
   _min.X:=_min.X+d;
  end;
  result:=true;
end;

function TCk63Convertor.SelectZoneInfo(Region: TCk63RegionChar; Zone:byte):TPointParam;
var Key : TCk63Key;
begin
  Key:=Ck63KeyArray[Region];
  FillChar(result,SizeOf(TPointParam),0);
  result.Region     := Region;
  result.nZone      := Zone;
  result.zWidth     := 3+3*Key.Z6;
  result.CM         := Key.CM+(Zone-1)*result.zWidth;
  result.pPoint.X   := Key.dX;            // X offset
  result.pPoint.Y   := Key.dY;            // Y offset
  result.geoPoint.X := Key.B0;            // min latitude
  result.geoPoint.Y := Key.B0+Key.rows/3; // max latitude
end;


function TCk63Convertor.StringToNomenclature(const sNomen: String): TNomenclature63;
var Key   : TCk63Key;
    sN    : string;
    pm    : integer;
    ir,ic : integer;
begin
  sN:=Trim(sNomen);
  FillChar(result, SizeOf(TNomenclature63),0);
  if LenGth(sN)<7 then exit;
  if not (sN[1] in ['A'..'M','P'..'Y']) then exit;
  Key:=Ck63KeyArray[sNomen[1]];
  with result do
  begin
   Region:= Key.Region;   // X-10-52
   Delete(sn, 1, 2);      // 10-52
   pm := Pos('-',sn);
   Row:=StrToIntDef(Copy(sN,1,pm-1),65535);  Delete(sn, 1, pm);  //52
   pm := Pos('-',sn);
   if pm>0 then
   begin
    Col:=StrToIntDef(Copy(sN,1,pm-1),65535);
    Delete(sn, 1,pm);
   end else
   begin
    Col:=StrToIntDef(sN,65535);
    sn:='';
   end;
   if (Row=65535) or (Col=65535) then exit;
   ir := Row-Key.Nr; ic := Col-Key.Nc;
   if (LenGth(FMask[Region])<ir) and (LenGth(FMask[Region][ir])<ic) and
      (FMask[Region][ic,ir]=0) then exit;

   Quad.Scale := 100000;
   Quad.B0  := Key.B0+ir/3;   Quad.B1 := Key.B0+(ir+1)/3;
   Quad.L0  := Key.L0+ic/2;   Quad.L1 := Key.L0+(ic+1)/2;
   if sn<>'' then
   // square less than 100000
   begin
   end;

 end;

end;

function TCk63Convertor.GetKey(value:TCk63RegionChar): TCK63Key;
begin
  result:=Ck63KeyArray[value];
end;

end.
