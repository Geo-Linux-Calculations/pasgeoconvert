unit MathExt;

interface

const
 NO_CROSS     = $00; // no intersection
 CR_LINE_SS   = $01; // segment-segment
 CR_LINE_SV   = $02; // segment-top
 CR_LINE_VV   = $03; // one vertex match    1----1(2)----2
 CR_LINE_SV2  = $04; // both vertices on segments  2----1---2----1
 CR_LINE_VV2  = $05; // two lines have the same coordinates  1(2)----2(1)

 CR_FULL      = $20; // difficult intersection
 CR_INNER     = $21; // full occurrence


type
 TAngleVector = (avRight, avLeft, avUp, avDown);
 TDoublePoint =   packed record
   X  : double;
   Y  : double;
 end;

 T3DPoint =   packed record
  case byte of
    0: (X,Y,Z   : double);
    1: (phi,lam,height :double);
    2: (B,L,H : double);
    3: (REC   : array[0..2] of double);
    4: (pnt   : TDoublePoint; elev : double);
  end;
  T3dArray  =  array of T3dPoint;
  T3dMatrix =  array of T3dArray;
  TBorder   = record
   Vertex : T3dArray;
   Bulge  : T3dArray;
  end;

  TLineIndex  = packed record
    iTop  : integer;
    iEnd  : integer;
    Check : byte;
  end;
  TLineIndexs   = array of TLineIndex;

  TFloatArray   = array of double;
  TIntegerArray = array of integer;
  TSquareMatrix = array of TFloatArray;
  TUniqueKey    = TIntegerArray;
 // NOTE: The radii of the circles are specified using the Z coordinate
 //       The curvature of polyline segments is set through an additional array *Bulge
 //       where X, Y are the coordinates of the center of the arc, Z is its radius, the sign "+" by hour p. "-" against
 // ************************************************************
 //                      GENERAL FUNCTIONS
 // ************************************************************

 function Max(const A,B: double): double;
 function Min(const A,B: double): double;
 function DeltaIPU(BaseIPU, ToPointIPU : double): double;
 function AddIPU(IPU, Angle : double):double;
 function IPUToAngle(IPU: double):double;
 function Set3dPoint(X,Y : Double) : T3DPoint; overload;
 function Set3dPoint(X,Y,Z : Double) : T3DPoint; overload;
 function Set3dArray(const Value : array of T3dPoint) : T3dArray;

 procedure Clear3dMatrix(var Matrix : T3dMatrix);

 // calculate distance
 function   Distance(X1,Y1,X2,Y2 : double) : double;  overload;
 function   Distance(Point1, Point2 : T3dPoint) : double; overload;

 function   Distance3d(Point1, Point2 : T3dPoint) : double;
 // take a math angle
 function   GetAngle(p1, P2 : T3dPoint) : extended; overload;
 function   GetAngle(X1,Y1,X2,Y2 : double) : extended; overload;
 // find the coordinate of a point from the base one with a given angle and a vector of the origin
 function   SetPoint(Base : T3dPoint; Dist, Angle : extended;
  const vector : TAngleVector = avRight; const Hours : boolean= false) : t3dPoint;
 // add the Values array to the end of the Arr array
 procedure  IncArray(var Arr: T3dArray; Values: array of T3dPoint);overload;
 procedure  IncArray(var B: T3dArray; V: array of T3dPoint;baseTop,ValTop:boolean);overload;
// procedure IncArray(var Arr: T3dArray; const Values: T3dArray); overload;
 procedure  IncArrayNoDuplicate(var Arr: T3dArray; Values: array of T3dPoint);
 // change the direction of digitalization
 procedure  InverseArray(var Arr:T3dArray);
 procedure  InverseBorder(var Brd:TBorder);
 // close the array
 procedure  ClosedArray(var Arr:T3dArray; const delta : double = 0.0);
 // move array
 procedure  MoveArray(var Arr:T3dArray;Base,Moved: T3dPoint); overload;
 procedure  MoveArray(var Arr:TBorder;Base,Moved: T3dPoint); overload;
 // swap dots
 procedure SwapPoint(var Arr:T3dArray; bIndex, sIndex:integer);
 // tangent from point to circle
 function  PointKasat(P0, Center: T3dPoint): T3dArray;
 // tangent between circles
 function  CircleKasat(isUpper : boolean; C1, C2: T3dPoint;var Res : T3dArray):boolean;
 // ************************************************************
 //                      CROSSING ELEMENTARY
 // ************************************************************
 // segment - segment
 function CrossLineToLine(p1,p2,l1,l2 : T3dPoint; var Res : T3dArray; const Decimal : byte = 4): byte;overload;
 function CrossLineToLine(p1,p2,l1,l2 : T3dPoint; const Decimal : byte = 4): byte;overload;
 // segment - line
 function CrossLineToCircle(p1,p2,Cnt : T3dPoint; var Cross : T3dArray): boolean;
 // segment - arc
 function CrossLineToArc(a0,a1,C, l0,l1 : T3dPoint; var Cross : T3dArray): boolean;
 // circle - circle
 function CrossCircleToCircle(C1, C2: T3dPoint; var Cross : T3dArray):boolean;
 // circle - arc
 function CrossArcToCircle(a0,a1,b0, Center : T3dPoint; var Cross : T3dArray): boolean;
 // arc - arc
 function CrossArcToArc(a0,a1,c0, l0,l1,c1 : T3dPoint; var Cross : T3dArray): boolean;

 // ************************************************************
 //                INCLUSION ELEMENTARY
 // ************************************************************
 // point to circle
 function PointInCircle(Center : T3dPoint; Pnt: T3dPoint) :boolean;
 // point to segment
 function PointInSegment(P0,P1,B0 : T3dPoint; Pnt: T3dPoint) :boolean;
 // point to sector
 function PointInSector(P0,P1,B0 : T3dPoint; Pnt: T3dPoint) :boolean;


 // ************************************************************
 //                    CROSSING DIFFICULT
 // ************************************************************
 // polyline - polyline (including "arc" segments)
 function CrossPolyToPoly(Base,bBulge,Poly,pBulge:T3dArray; var Res:T3dArray):boolean; overload;
 function CrossPolyToPoly(Base,bBulge,Poly,pBulge:T3dArray):boolean;overload;
 // polyline - polyline (excluding "arc" segments)
 function CrossPolyToPoly(Base,Poly:T3dArray):boolean;overload;
 // polyline - polyline (excluding "arc" segments) taking into account Z
 function CrossPolyToPolyZ(BaseZ,Poly:T3dArray; var Res:T3dArray):boolean;
 // polyline - circle (taking into account the "arc" segments)
 function CrossPolyToCircle(Base,bBulge:T3dArray;Center:T3dPoint; var Res:T3dArray):boolean; overload;
 function CrossPolyToCircle(Base,bBulge:T3dArray;Center:T3dPoint):boolean;overload;
 // polyline - circle (excluding "arc" segments)
 function CrossPolyToCircle(Base:T3dArray;Center:T3dPoint):boolean;overload;

 // ************************************************************
 //                    INCLUSION DIFFICULT
 // ************************************************************
 // point - to polyline (excluding segments - "arcs")
 // point - to polyline (taking into account the "arc" segments)
 function PointInPolygon(Poly,Bulge : T3dArray; Pnt : T3dPoint):boolean; overload;
 function PointInPolygon(Poly : T3dArray; Pnt : T3dPoint):boolean; overload;
 // polyline with polyline (taking into account the intersection mode)
 function PolyInPolyEx(Base,bBulge,Second,sBulge:T3dArray):byte;
 // polyline with polyline first occurrence / intersection check
 function PolyInPoly(Base,bBulge,Second,sBulge:T3dArray):boolean; overload;
 function PolyInPoly(Base,Second : T3dArray):boolean; overload;
 // polyline with a circle (taking into account the intersection mode)
 function PolyInCircleEx(Center:T3dPoint;Poly,Bulge: T3dArray):byte;
 // polyline with a circle check the first occurrence / intersection
 function PolyInCircle(Poly,Bulge: T3dArray;Center:T3dPoint):boolean; overload;
 function PolyInCircle(Poly: T3dArray;Center:T3dPoint):boolean;overload;
 // circle with polyline check the first occurrence / intersection
 function CircleInPoly(Center:T3dPoint;Poly: T3dArray):boolean;
 // ************************************************************
 //                    CROSSING THREE-DIMENSIONAL
 // ************************************************************
 // normal arbitrary object (zone) with line (values in Z-height)
 function Cross3dPolyToLine(Poly, Bulge : T3dArray; Hmax, Hmin : double; p0,p1 : T3dpoint; var Res : T3dArray):byte;
 // segment cylinder (values in Z- height)
 function CrossCylinderToLine(Center : T3dPoint; Hmax,Hmin : double; p0,p1 : T3dpoint; var Res : T3dArray):byte;

 // ************************************************************
 //                    INPUT THREE-DIMENSIONAL
 // ************************************************************
 // point - in a parallelepiped
 function PointInPolygon3d(Poly,Bulge:T3dArray;Hmin,HMax:double; Pnt : T3dPoint):boolean; overload;
 // point - in a parallelepiped (with cylinder notches)
 function PointInPolygon3d(Poly : T3dArray;Hmin,HMax:double; Pnt : T3dPoint):boolean; overload;
 // point to cylinder
 function PointInCylinder(Center:T3dPoint;Hmin,HMax:double;Pnt: T3dPoint) :boolean;
 // ************************************************************
 //                   FUNCTIONS OF MATRIX ANALYSIS (MATRIX)
 // ************************************************************

 procedure DeleteMatrix(var Matrix : TSquareMatrix);
 // matrix multiplication
 function MullMatrix(A,B:TSquareMatrix):TSquareMatrix;
 // calculating the determinant of a matrix
 function CalculateDeterminant(A : TSquareMatrix) : double;
 // calculating the coefficients of an equation of the form f (x) by value and result
 function CalculateKoeficient1d(X,F : TFloatArray) : TFloatArray;
 // calculating the coefficients of an equation of the form f (x, y)
 function CalculateKoeficient2d(XY : TSquareMatrix; FX,FY : TFloatArray) :TSquareMatrix;

 // ************************************************************
 //                LOGICAL ANALYSIS FUNCTIONS
 // ************************************************************
 // minimum / maximum distance in a set of points
 // the result is the index of the point in the Value array
 function FindDistanceFromPoint(Point:T3dPoint;Value : T3dArray;MaxDist:boolean): integer;

 // the result is the indices of the points in the Value array
 function FindDistance(Value : T3dArray;MaxDist:boolean): TLineIndex;

 // search for the similarity of ARCS and CIRCUITS in an array of coordinates
 // result - object coordinates (direct application)
 // pDist - distance in percentage
 // dA    - angle in degrees
 function FindCurve(V : T3dArray; pDist: integer;dA:double): TBorder;

 // ************************************************************
 //                   OTHER FUNCTIONS
 // ************************************************************
 // increase (decrease) polyline
 function OffsetPolyLine(Poly : TBorder; Offset : double): TBorder; overload;
 function OffsetPolyline(Poly : T3dArray; Offset : double): T3dArray; overload;
 // width in Vertex.Z
 function OffsetCline(Poly : T3dArray): T3dArray;
 // remove self-intersecting areas
 function ClearCrossLines(InPoly : T3dArray): T3dArray;
 // delete points with the same coordinates
 function DeleteDuplicatedPoint(Border : TBorder): TBorder;overload;
 function DeleteDuplicatedPoint(P,B : T3dArray): TBorder;overload;
 // merge polylines
 function UnionPoly(Poly1,blg1, Poly2,blg2: T3dArray; var Res,bRes :T3dArray):boolean;
 {// subtract polylines
 function SunstractPoly(Base,bBulge,Second,sBulge: T3dArray; var Res,bRes: T3dArray):boolean;
}
 function ScanPolygon(Poly,Bulge: T3dArray; dH:double): T3dMatrix; //overload;
 //function ScanPolygon(Poly: T3dArray; MX,NY:integer): T3dMatrix;overload;

 function TurnPoint(P:T3dPoint;Base : T3dPoint; Angle: double):T3dPoint;


implementation
uses Math;

 var Empty : T3dArray;

 function Set3dPoint(X,Y,Z : Double) : T3dPoint;
 begin
  result.X:=X;
  result.Y:=Y;
  result.Z:=Z;
 end;

 function Set3dPoint(X,Y : Double) : T3dPoint;
 begin
  result.X:=X;
  result.Y:=Y;
  result.Z:=0;
 end;

 function Set3dArray(const Value : array of T3dPoint) : T3dArray;
 begin
   SetLenGth(result, LenGth(Value));
   if Length(Value)>0 then
    Move(Value[0], result[0], SizeOf(T3dPoint)*Length(Value));
 end;

 procedure Clear3dMatrix(var Matrix : T3dMatrix);
  var i : integer;
 begin
   for i:=0 to Length(Matrix) -1 do
   Finalize(Matrix[i]);
   Finalize(Matrix);
 end;


 function TurnPoint(P:T3dPoint;Base : T3dPoint; Angle: double):T3dPoint;
 var dP : T3dpoint;
 begin
   dP:=Set3dPoint(P.X-Base.X, P.Y-Base.Y, 0);
   dP:=Set3dPoint(dP.X*cos(Angle)+dP.y*sin(angle),-dP.X*sin(Angle)+dP.y*cos(angle),P.Z);
   result:=Set3dPoint(dP.X+Base.X, dP.Y+Base.Y,dP.Z);
 end;

                 
function GetAngle(p1, P2 : T3dPoint) : extended;
asm
        FLD qword ptr [p2]+$8
        FLD qword ptr [p1]+$8
        FSUBP
        FLD qword ptr [p2]
        FLD qword ptr [p1]
        FSUBP
        FPATAN
        FLDZ
        FCOMP
        FSTSW
        AND AX, $0100
        CMP AX, $0100
        JE @DONE
        FLDPI
        FLDPI
        FADD
        FADDP
@DONE:
end;

function GetAngle(X1,Y1, X2,Y2 : double) : extended;
asm
        FLD qword ptr [Y2]
        FLD qword ptr [Y1]
        FSUBP
        FLD qword ptr [X2]
        FLD qword ptr [X1]
        FSUBP
        FPATAN
        FLDZ
        FCOMP
        FSTSW
        AND AX, $0100
        CMP AX, $0100
        JE @DONE
        FLDPI
        FLDPI
        FADD
        FADDP
@DONE:
end;

function Min(const A,B: double): double;
asm
        FLD QWORD PTR (A)
        FLD QWORD PTR (B)
        FCOM
        FSTSW
        AND AX, $0100
        CMP AX, $0100
        JE @DONE
        FXCH  ST(1)
@DONE:  FFREE ST(1)
end;

function Max(const A,B: double): double;
asm
        FLD QWORD PTR (A)
        FLD QWORD PTR (B)
        FCOM
        FSTSW
        AND AX, $0100
        CMP AX, $0100
        JNE @DONE
        FXCH  ST(1)
@DONE:  FFREE ST(1)
end;

function  Distance(X1,Y1,X2,Y2 : double) : double;
asm
        FLD qword ptr [X1]
        FLD qword ptr [X2]
        FSUBP st(1),st
        FMUL st, st
        FLD qword ptr [Y1]
        FLD qword ptr [Y2]
        FSUBP st(1),st
        FMUL st, st
        FADDP st(1), st
        FSQRT
end;


function  Distance(Point1, Point2 : T3dPoint) : double;
asm
        FLD qword ptr [Point1]
        FLD qword ptr [Point2]
        FSUBP st(1),st
        FMUL st, st
        FLD qword ptr [Point1]+$8
        FLD qword ptr [Point2]+$8
        FSUBP st(1),st
        FMUL st, st
        FADDP st(1), st
        FSQRT
end;


function Distance3d(Point1,Point2: T3dPoint): Double;
asm
        FLD qword ptr [Point1]
        FLD qword ptr [Point2]
        FSUBP st(1),st
        FMUL st, st
        FLD qword ptr [Point1]+$8
        FLD qword ptr [Point2]+$8
        FSUBP st(1),st
        FMUL st, st
        FLD qword ptr [Point1]+$10
        FLD qword ptr [Point2]+$10
        FSUBP st(1),st
        FMUL st, st
        FADDP st(1), st
        FADDP st(1), st
        FSQRT
end;


 function IPUToAngle(IPU: double):double;
 const _2 : extended =2.0;
 asm
        FLDPI
        FLD _2
        FDIVP
        FLD QWORD PTR (IPU)
        FSUBP
        FTST
        FSTSW
        AND AX, $0100
        CMP AX, $0100
        JNE @DONE
        FLDPI
        FLD _2
        FMULP
        FADDP
 @DONE:
 end;

 function NoramlizeAngle(Angle: double; const To360 : boolean = true):double;
 begin
   result := Angle;
   if Angle =0 then exit;
   //  bring to the limit 0..2pi
   while result<0 do
    result:=result+2*pi;

   while result>2*pi do
    result:=result-2*pi;
   if not To360 and (result>pi) then
    result := -(2*pi-result);
 end;

 // difference between track angles
 // BaseIPU - base track angle
 // ToPointIPU - subsequent track angle
 function DeltaIPU(BaseIPU, ToPointIPU : double):double;
 begin
   result:=NoramlizeAngle(ToPointIPU)-NoramlizeAngle(BaseIPU);
   // the difference should never exceed 180 degrees!
   result:=NoramlizeAngle(result, false);
 end;


 // fold the IPU (if you need to subtract the sign) NOTE: Delta:=AddIPU(3*pi/2, -5*pi/6)
 function AddIPU(IPU, Angle : double):double;
 begin
  result:=IPU+Angle;
  if (Angle=0) or IsInfinite(Angle) then exit;
  while (result>=2*Pi) or (result<0) do
  case result>0 of
   true : result:=result-2*pi;
   false: result:=result+2*pi;
  end;
 end;


function FindDistanceFromPoint(Point:T3dPoint;Value : T3dArray;MaxDist:boolean): integer; overload;
var i        : integer;
    _D,bDist : double;
begin
 _D:=(1-2*byte(MaxDist))*MaxDouble;
 result:=-1;
 for i:=0 to LenGth(Value)-1 do
 begin
  bDist:=Distance(Point, Value[i]);
  case MaxDist of
   true : if bDist>_D then begin result:=i;_D:=bDist; end;
   false: if bDist<_D then begin result:=i;_D:=bDist; end;
  end;
 end;
end;

function FindDistanceFromPoint(Index:integer;Value : T3dArray;MaxDist:boolean): integer; overload;
var i        : integer;
    _D,bDist : double;
begin
 _D:=(1-2*byte(MaxDist))*MaxDouble;
 result:=-1;
 for i:=Index+1 to LenGth(Value)-1 do
 begin
  bDist:=Distance(Value[index], Value[i]);
  case MaxDist of
   true : if bDist>_D then begin result:=i;_D:=bDist; end;
   false: if bDist<_D then begin result:=i;_D:=bDist; end;
  end;
 end;
end;

function FindDistance(Value : T3dArray;MaxDist:boolean): TLineIndex;
var i : integer;
    R : TLineIndexs;
   _D,bDist : double;
begin
 result.iTop:=-1; result.iEnd:=-1;
 _D:=(1-2*byte(MaxDist))*MaxDouble;
  if LenGth(Value)<2 then exit;
  SetLenGth(R, LenGth(Value)-1);
  for i:=0 to LenGth(Value)-2 do
  begin
   R[i].iTop:=i;
   R[i].iEnd:=FindDistanceFromPoint(i, Value, MaxDist);
  end;
  for i:=0 to LenGth(R)-1 do
  begin
  bDist:=Distance(Value[R[i].iTop], Value[R[i].iEnd]);
  case MaxDist of
   true : if bDist>_D then begin result:=R[i];_D:=bDist; end;
   false: if bDist<_D then begin result:=R[i];_D:=bDist; end;
  end;
 end;
end;


function CopyMatrix(Matrix : TSquareMatrix): TSquareMatrix;
var k,l : integer;
begin
 SetLength(result,LenGth(Matrix));
 for k:=0 to LenGth(Matrix)-1 do
 begin
  SetLength(result[k],LenGth(Matrix));
  for l:=0 to LenGth(Matrix)-1 do result[k,l]:=Matrix[k,l];
 end;
end;

function MullMatrix(A,B:TSquareMatrix):TSquareMatrix;
var i,j,k,
    m,n,r : integer;
begin
  DeleteMatrix(result);
  if (LenGth(A)<2) or (LenGth(B)<2) then exit;

  m:=LenGth(A); n:=LenGth(A[0]); r:=LenGth(B[0]);
  // internal dimensions do not match
  if (LenGth(B)<>n) then exit;

  SetLength(result,m);
  for i:=0 to m-1 do
  begin
   SetLength(result[i],r);
   for j:=0 to r-1 do
   begin
    result[i,j]:=0;
    for k:=0 to n-1 do
    result[i,j]:=result[i,j]+A[i,k]*B[k,j];
   end;
  end;

end;

procedure DeleteMatrix(var Matrix : TSquareMatrix);
var k : integer;
begin
  for k:=0 to LenGth(Matrix)-1 do
  Finalize(Matrix[k]);
  Finalize(Matrix);
end;

 // calculating the determinant of a matrix
function CalculateDeterminant(A : TSquareMatrix) : double;
var B       : TSquareMatrix;
    D       : double;
    L,i,j,k : integer;

begin
 // CHECK
 L:=LenGth(A);
 if (l<3) and (LenGth(A[0])=0) then exit;
 if  l<>LenGth(A[0]) then exit;
 result:=0;
 // FILLING
 for i:=0 to L-1 do
 begin
  SetLength(B, L-1);
  for j:=1 to L-1 do
  for k:=0 to L-1 do
  if k<>i then
  begin
   SetLength(B[j-1], LenGth(B[j-1])+1);
   B[j-1,High(B[j-1])]:=A[j,k];
  end;
  case LenGth(B)=2 of
   true:  begin
           D:=B[0,0]*B[1,1]-B[1,0]*B[0,1];
           Result:=Result+A[0,i]*(1-2*(i mod 2))*D;
          end;
   false: begin
           D:=CalculateDeterminant(B);
           Result:=Result+A[0,i]*(1-2*(i mod 2))*D;
          end;
  end;
  DeleteMatrix(B);
 end;
 DeleteMatrix(B);
 Finalize(B);
end;

// calculation of equation coefficients f(x)
function CalculateKoeficient1d(X,F:TFloatArray) : TFloatArray;
var RM,Xn : TSquareMatrix;
    j,i   : integer;
    D,K   : double;
begin

  SetLenGth(Xn,LenGth(X));
  for i:=0 to LenGth(Xn)-1 do
  begin
   SetLenGth(Xn[i],LenGth(X));
   for j:=LenGth(Xn[i])-1 downto 0 do
   Xn[i][j]:=Power(X[i], LenGth(Xn[i])-j-1);
  end;
 D:=0;
 Finalize(result);
 case LenGth(Xn)=2 of
  true : if F[0]=F[1] then D:=0 else
         begin
          SetLength(result,2);
          result[0]:=(F[1]-F[0])/(Xn[0,0]+Xn[1,0]);
          result[1]:=F[1]-result[0]*Xn[1,0];
          exit;
         end;
  false: D:=CalculateDeterminant(Xn);
 end;
 if D=0 then exit;
 SetLength(result,LenGth(Xn));

 for j:=0 to LenGth(Xn)-1 do
 begin
  RM:=CopyMatrix(Xn);
  for i:=0 to LenGth(Xn)-1 do RM[i,j]:=F[i];
  k:=0;
  case LenGth(RM)=2 of
   true : K:=RM[0,0]*RM[1,1]-RM[1,0]*RM[0,1];
   false: K:=CalculateDeterminant(RM);
  end;
  result[j]:=K/D;
  DeleteMatrix(RM);
 end;
 DeleteMatrix(Xn);
end;

 // calculation of equation coefficients f(x,y)
 function CalculateKoeficient2d(XY : TSquareMatrix; FX,FY : TFloatArray) : TSquareMatrix;
 var I,J,K : integer;
     R     : TFloatArray;
     V     : TSquareMatrix;
     alleq : boolean;
     Sh    : double;

 begin
  SetLEngth(V,LenGth(FX));
  SetLength(R,LenGth(FY));
  for i:=0 to LenGth(FX)-1 do
  begin
   for j:=0 to LenGth(FY)-1 do R[j]:=XY[i,j];
   V[i]:=CalculateKoeficient1d(FY,R);
  end;
  SetLength(R,LenGth(FX));
  SetLength(result,LenGth(FY));
  for i:=0 to LenGth(FY)-1 do
  begin
   for j:=0 to LenGth(FX)-1 do R[j]:=V[j,i];
   result[i]:=CalculateKoeficient1d(FX,R);
  end;
  k:=0;
  for i:=0 to LenGth(result)-1 do
  begin
   alleq:=true; Sh:=result[i][0];
   for j:=0 to LenGth(result[i])-1 do
   alleq:=result[0,j]=Sh;
   if alleq then
   begin
    for j:=0 to LenGth(result)-2 do
    result[j]:=result[j+1];
    Inc(K);
   end;
  end;
  if K<=Length(Result) then
  SetLength(result,Length(Result)-K);
  Finalize(R);
  DeleteMatrix(V);
 end;



 function SetPoint(Base : T3dPoint; Dist, Angle : extended;
    const vector : TAngleVector = avRight; const Hours : boolean= false) : T3dPoint;
 var dx, dy, _angle : extended;
 begin
  result:=Base;
  _angle:=Angle*(1-2*byte(Hours));
  dx:=Dist*cos(_angle);
  dy:=Dist*sin(_angle);
  case vector of
   avRight: begin result.X:=result.X+dx; result.Y:=result.Y+dy; end;
   avLeft : begin result.X:=result.X-dx; result.Y:=result.Y-dy; end;
   avUp   : begin result.X:=result.X-dy; result.Y:=result.Y+dx; end;
   avDown : begin result.X:=result.X+dy; result.Y:=result.Y-dx; end;
  end;
end;

 procedure SwapPoint(var Arr:T3dArray; bIndex, sIndex:integer);
 var Pnt   : T3dPoint;
     index : integer;
 begin
  index:=LenGth(Arr)-1;
  if (bIndex in [0..index]) and (sIndex in [0..index]) then
  begin
   Pnt:=Arr[bIndex];
   Arr[bIndex]:=Arr[sIndex];
   Arr[sIndex]:=Pnt;
  end;
 end;

// inversion of an array
 procedure  InverseArray(var Arr:T3dArray);
 var i,Len : integer;
     R     : T3dArray;
 begin
  IncArray(R,Arr); Len:=LenGth(R);
  for i:=0 to Len-1 do Arr[i]:=R[Len-i-1];
  Finalize(R);
 end;

 procedure  InverseBorder(var Brd:TBorder);
 var i: integer;
 begin
  for i:=0 to LenGth(Brd.Bulge)-1 do
  if Brd.Bulge[i].Z<>0 then Brd.Bulge[i].Z:=-Brd.Bulge[i].Z;
  InverseArray(Brd.Vertex);
  InverseArray(Brd.Bulge);
  for i:=1 to LenGth(Brd.Bulge)-1 do
  Brd.Bulge[i-1]:=Brd.Bulge[i];
 end;

 procedure  MoveArray(var Arr:T3dArray;Base,Moved: T3dPoint);
 var i  : integer;
     dM : T3dPoint;
 begin
  dM:=Set3dPoint(Moved.X-Base.X,Moved.Y-Base.Y,0);
  for i:=0 to LenGth(Arr)-1 do
  Arr[i]:=Set3dPoint(Arr[i].X+dM.X,Arr[i].Y+dM.Y,Arr[i].Z);
 end;

 procedure  MoveArray(var Arr:TBorder;Base,Moved: T3dPoint);
 begin
   MoveArray(Arr.Vertex,Base,Moved);
   MoveArray(Arr.Bulge,Base,Moved);
 end;


 // close the array
 procedure  ClosedArray(var Arr:T3dArray; const delta : double = 0.0);
 var D : double;
 begin
  if LenGth(Arr)<3 then exit;
  D:= Abs(Distance(Arr[0],Arr[High(arr)]));
  if D>delta then
  begin
    SetLength(Arr, Length(arr)+1);
    Arr[High(arr)]:=Arr[0];
  end else
  Arr[High(arr)]:=Arr[0];

 end;


 // ENTRANCE
 function PointInCircle(Center : T3dPoint; Pnt: T3dPoint):boolean;
 asm
      FLD qword ptr [Pnt]
      FLD qword ptr [Center]
      FSUBP st(1),st
      FMUL st, st
      FLD qword ptr [Pnt]+$8
      FLD qword ptr [Center]+$8
      FSUBP st(1),st
      FMUL st, st
      FADDP st(1), st
      FSQRT
      FLD qword ptr [Center]+$10
      FABS
      FSUBP
      FTST
      FSTSW
      AND AX, $0100
      SHR AX,8
      FFREE ST(0)
 end;




function PointInSegment(P0, P1, B0 : T3dPoint; Pnt: T3dPoint) :boolean;
var sect   : integer;
    Ac1,B  : T3dArray;
begin
 result:=false;
 if (Abs(B0.Z)=0) or (Round(Distance(B0,Pnt))>Abs(B0.Z)) then exit;
 // point is one of the ends of the arc itself
 result:=(Round(Distance(Pnt,P0))=0) or (Round(Distance(Pnt,P1))=0);
 if result then exit;
 SetLenGth(Ac1,4); Ac1[0]:=p0;  Ac1[3]:=p1;
 Ac1[0].Z:=GetAngle(Set3dPoint(0.5*(p0.X+p1.X),0.5*(p0.Y+p1.Y),0),b0)+pi;
 Ac1[1]:=SetPoint(Ac1[0],Abs(b0.Z),Ac1[0].Z, avRight, false);
 Ac1[2]:=SetPoint(Ac1[3],Abs(b0.Z),Ac1[0].Z, avRight, false);
 Ac1[0].Z:=GetAngle(b0,p0)-GetAngle(b0,p1);
 if Abs(Ac1[0].Z)>pi then Sect:=2 else Sect:=1;
 Sect:=Sect*(1-2*Byte(Ac1[0].Z<0))*(1-2*Byte(b0.Z<0));
 case sect of
  // large arc
  -1,2 : result:=not PointInPolygon(Ac1,B, Pnt);
  // minor arc
  1,-2 : result:=PointInPolygon(Ac1,B, Pnt);
 end;
end;

function PointInSector(P0,P1,B0 : T3dPoint; Pnt: T3dPoint) :boolean;
var B : T3dArray;
begin
  result:=PointInSegment(P0,P1,B0, Pnt) or
  PointInPolygon(Set3dArray([P0,P1,B0]),B, Pnt);
end;



Function PointInRect(D0,D1, Pnt : T3dPoint;const Decimal : byte = 4) : boolean;
var FPnt: T3dPoint;
begin
 FPnt:=Set3dPoint(RoundTo(Pnt.X,-Decimal),RoundTo(Pnt.Y,-Decimal),0);
 result:=
  (RoundTo(Max(D0.X,D1.X),-Decimal)>=fPnt.X) and (fPnt.X>=RoundTo(Min(D0.X,D1.X),-Decimal)) and
  (RoundTo(Max(D0.y,D1.y),-Decimal)>=fPnt.y) and (fPnt.y>=RoundTo(Min(D0.Y,D1.Y),-Decimal));
end;



{
 NO_CROSS     = $00; // no intersection
 CR_LINE_SS   = $01; // segment-segment
 CR_LINE_SV   = $02; // segment-vertex
 CR_LINE_VV   = $03; // one vertex match    1----1(2)----2
 CR_LINE_SV2  = $04; // both vertices on segments  2----1---2----1
 CR_LINE_VV2  = $05; // two lines have the same coordinates  1(2)----2(1)
}
 // CROSSING
 // segment with segment
function CrossLineToLine(p1,p2, l1,l2 : T3dPoint; var Res : T3dArray; const Decimal : byte = 4): byte;
var V1,V2 : T3dpoint;
    i     : integer;
    minP, maxP  : T3dPoint;
    minL, maxL  : T3dPoint;
    delta : double;
begin
 delta := power(10, -(Decimal+1));
 result:=0;  Finalize(res);
 // one of the lines is zero
 if(Distance(p1,p2)=0) or (Distance(l1,l2)=0) then exit;
 // check vertices with vertices
 if (Distance(p1,l1)<delta) or (Distance(p1,l2)<delta) then IncArray(Res,[p1]);
 if (Distance(p2,l1)<delta) or (Distance(p2,l2)<delta) then IncArray(Res,[p2]);
 // if the output array is filled with at least one element then EXIT
 case LenGth(Res) of
  1: result:=CR_LINE_VV;
  2: result:=CR_LINE_VV2;
 end;
 if result>0 then exit;

 minP:=Set3dPoint(Min(p1.x,p2.x),Min(p1.Y,p2.Y));
 maxP:=Set3dPoint(Max(p1.x,p2.x),Max(p1.Y,p2.Y));
 minL:=Set3dPoint(Min(l1.x,l2.x),Min(l1.Y,l2.Y));
 maxL:=Set3dPoint(Max(l1.x,l2.x),Max(l1.Y,l2.Y));

 V1:=Set3dPoint(RoundTo(p2.x-p1.X,-Decimal),RoundTo(p2.Y-p1.y,-Decimal),0);
 V2:=Set3dPoint(RoundTo(l2.x-l1.X,-Decimal),RoundTo(l2.Y-l1.y,-Decimal),0);
 // first vertical dp=0
 if (V1.X=0) and (V2.X<>0) then
 begin
  V2.Z:=V2.Y/V2.X; V2.X:=l1.y-l1.x*V2.Z;
  V1:=Set3dPoint(RoundTo(p1.x,-Decimal),RoundTo(V2.Z*p1.x+V2.X,-Decimal),0);
  if ((V1.Y>=minP.y) and (V1.Y<=MaxP.y)) and
     ((V1.X>=minL.x) and (V1.X<=maxL.x)) then IncArray(Res,[v1]);
  result:=CR_LINE_SS*byte(LenGth(Res)>0)+
  byte(((V1.Y=minP.y) and (V1.Y=MaxP.y)) and ((V1.X=minL.x) and (V1.X=maxL.x)));

 end else
 // second vertical dl=0
 if (V1.X<>0) and (V2.X=0) then
 begin
  V1.Z:=V1.Y/V1.X; V1.X:=p1.y-p1.x*V1.Z;
  V2:=Set3dPoint(RoundTo(l1.x,-Decimal),RoundTo(V1.Z*l1.x+V1.X,-Decimal),0);
  if ((V2.Y>=minL.y) and (V2.Y<=maxL.y)) and
     ((V2.X>=minP.x) and (V2.X<=MaxP.x)) then IncArray(Res,[v2]);
  result:=CR_LINE_SS*byte(LenGth(Res)>0)+
  byte(((V2.Y=minL.y) and (V2.Y=maxL.y)) and((V2.X=minP.x) and (V2.X<=MaxP.x)));
 end else
 // both vertical and coincident
 if ((V1.X=0) and (V2.X=0)) and (p1.X=l1.X) then
 begin

  if (maxL.y>=p2.Y) and (p2.y>=MinL.y) then IncArray(Res,[p2]) else
  if (maxL.y>=p1.Y) and (p1.y>=MinL.y) then IncArray(Res,[p1]);

  if (MaxP.y>=l2.Y) and (l2.y>=MinP.y) then IncArray(Res,[l2]) else
  if (MaxP.y>=p1.Y) and (l1.y>=MinP.y) then IncArray(Res,[L1]);
  result:=CR_LINE_SV*byte(LenGth(Res)=1)+CR_LINE_SV2*byte(LenGth(Res)=2);

 end else
 // both normal
 begin
  V1.Z := MaxDouble;  V2.Z := MaxDouble;
  if v1.x<>0 then
  begin
   V1.Z:=V1.Y/V1.X;
   V1.X:=p1.y-p1.x*V1.Z;
  end else
  V1.X := 0;
  if v2.x<>0 then
  begin
   V2.Z:=V2.Y/V2.X;
   V2.X:=l1.y-l1.x*V2.Z;
  end else
  V2.X := 0;
  // parallel and coincident
  if (RoundTo(V1.Z-V2.Z,-Decimal)+RoundTo(V1.X-V2.X,-Decimal)=0) then
  begin
   if PointInRect(l1,l2,p1, Decimal) then IncArray(Res,[p1]);
   if PointInRect(l1,l2,p2, Decimal) then IncArray(Res,[p2]);
   if PointInRect(p1,p2,l1, Decimal) then IncArray(Res,[l1]);
   if PointInRect(p1,p2,l2, Decimal) then IncArray(Res,[l2]);
   result:=CR_LINE_SV*byte(LenGth(Res)=1)+CR_LINE_SV2*byte(LenGth(Res)=2);
  end else
  // edge match
  begin
   IncArray(Res,[v2]);
   if V1.Z-V2.Z<>0 then
   begin
    Res[0].X:=(V2.X-V1.X)/(V1.Z-V2.Z);
    Res[0].Y:=V1.Z*Res[0].X+V1.X;
    if not PointInRect(l1,l2,res[0], Decimal) or not PointInRect(p1,p2,res[0], Decimal) then
    Finalize(Res);
   end else Finalize(Res);
   result:=CR_LINE_SS*byte(LenGth(Res)>0);
  end;
 end;

end;


function CrossLineToLine(p1, p2, l1, l2 : T3dPoint; const Decimal : byte = 4): byte;
var R : t3dArray;
begin
 result:=CrossLineToLine(p1, p2, l1, l2,R, Decimal);
 Finalize(R);
end;


// segment with a circle
function CrossLineToCircle(p1,p2,Cnt : T3dPoint; var Cross : T3dArray): boolean;
var A0,B0, A,B,C, D: double;
begin
 result:=false;
 Finalize(Cross);
 if P1.X-P2.X<>0 then
 begin
  A0:=(P2.Y-P1.Y)/(P2.X-P1.X);
  B0:=P1.Y-A0*P1.X; D:=b0-Cnt.Y;
  A:=sqr(A0)+1; B:=2*A0*D-2*Cnt.X;
  c:=sqr(Cnt.X)+sqr(D)-sqr(Cnt.Z);
  D:=sqr(b)-4*A*C;
  if (D<0) then exit;
  C:=(-b+sqrt(D))/(2*a);
  if ((C<=max(P1.X, P2.X)) and (C>=min(P1.X, P2.X))) then
  begin
   SetLenGth(Cross,1);
   Cross[0]:=Set3dPoint(C,A0*C+B0,0);
  end;
  D:=(-b-sqrt(D))/(2*a);
  if (D<>C) and ((D<=max(P1.X, P2.X)) and (D>=min(P1.X, P2.X))) then
  begin
   SetLenGth(Cross,LenGth(Cross)+1);
   Cross[High(Cross)]:=Set3dPoint(D,A0*D+B0,0);
  end;
 end else
 begin
  B:=-2*Cnt.Y;
  C:=sqr(Cnt.Y)+sqr(P1.X-Cnt.X)-sqr(Cnt.Z);
  D:=sqr(B)-4*C;
  if D<0 then exit;
  A0:=(-b+sqrt(D))/2;
  if ((a0<=max(P1.Y, P2.Y)) and (a0>=min(P1.Y, P2.Y))) then
  begin
   SetLenGth(Cross,1);
   Cross[0]:=Set3dPoint(P1.X,a0,0);
  end;
  A:=(-b-sqrt(D))/2;
  if (a0<>a) and ((A<=max(P1.Y, P2.Y)) and (A>=min(P1.Y, P2.Y))) then
   begin
    SetLenGth(Cross,LenGth(Cross)+1);
    Cross[High(Cross)]:=Set3dPoint(P1.X,A,0);
   end;
 end;
 result:=LenGth(Cross)>0;
end;


// line segment with arc (any size "more or less 180 is calculated")
function CrossLineToArc(a0,a1,C,l0,l1 : T3dPoint; var Cross : T3dArray): boolean;
var Ac1,B  : T3dArray;
    i,sect : integer;
begin
 Finalize(Cross); result:=false;
 if (Distance(a0,a1)=0) or (Distance(l0,l1)=0) or (C.Z=0) then exit;
 if not CrossLineToCircle(l0,l1,C,Cross) then exit;

 SetLenGth(Ac1,4); Ac1[0]:=A0;  Ac1[3]:=A1;
 Ac1[0].Z:=GetAngle(Set3dPoint(0.5*(A0.X+A1.X),0.5*(A0.Y+A1.Y),0),C)+pi;
 Ac1[1]:=SetPoint(Ac1[0],Abs(C.Z),Ac1[0].Z, avRight, false);
 Ac1[2]:=SetPoint(Ac1[3],Abs(C.Z),Ac1[0].Z, avRight, false);
 Ac1[0].Z:=GetAngle(C,A0)-GetAngle(C,A1);
 if Abs(Ac1[0].Z)>pi then Sect:=2 else Sect:=1;
 Sect:=Sect*(1-2*Byte(Ac1[0].Z<0))*(1-2*Byte(C.Z<0));
 for i:=0 to LenGth(Cross)-1 do
 case sect of
  // large arc
  -1,2 : Cross[i].Z:=byte(not PointInPolygon(Ac1,B,Cross[i]));
  // minor arc
  1,-2 : Cross[i].Z:= byte(PointInPolygon(Ac1,B,Cross[i]));
 end;
 if (LenGth(Cross)=1) and (Cross[0].Z=0) then Finalize(Cross) else
 if (LenGth(Cross)=2)then
 case Cross[1].Z=0 of
  true : if (Cross[0].Z=0) then Finalize(Cross) else SetLenGth(Cross,1);
  false: if (Cross[0].Z=0) then
         begin
          Cross[0]:=Cross[1];
          SetLenGth(Cross,1);
         end;
 end;
 result:=LenGth(Cross)>0;
end;

function CrossCircleToCircle(C1, C2: T3dPoint; var Cross : T3dArray):boolean;
var D,A,dA : double;
begin
 result:=false; Finalize(Cross);
 D:=Distance(C1,C2);
 if (D>Abs(C1.Z)+Abs(C2.Z)) or (D+Min(Abs(C1.Z),Abs(C2.Z))<Max(Abs(C1.Z),Abs(C2.Z))) then exit;
 D:=(sqr(C2.Z)-sqr(C1.Z)-sqr(d))/(2*d);
 SetLenGth(Cross,2); A:=GetAngle(C2,C1);
 dA:=arccos(D/Abs(C1.Z));
 Cross[0]:=SetPoint(C1, Abs(C1.Z), A+dA, avRight, false);
 Cross[1]:=SetPoint(C1, Abs(C1.Z), A-dA, avRight, false);
 result:=LenGth(Cross)>0;
end;

 procedure IncArray(var Arr: T3dArray; Values: array of T3dPoint);
 var k:integer;
 begin
   if Length(Values)<1 then exit;
   k := Length(arr);
   SetLength(Arr, Length(Values)+k);
   Move(Values[0], Arr[k], SizeOf(T3dPoint)*Length(Values));
 end;
    {
 procedure IncArray(var Arr: T3dArray; const Values: T3dArray);
 var k:integer;
 begin
   if Length(Values)<1 then exit;
   k := High(arr);
   SetLength(Arr, Length(Arr)+Length(Values));
   Move(Values[0], Arr[k], SizeOf(T3dPoint)*Length(Values));
 end; }


 procedure  IncArrayNoDuplicate(var Arr: T3dArray; Values: array of T3dPoint);
 var i,j : integer;
     Duplicate : boolean;
 begin
   for i:=0 to LenGth(Values)-1 do
   begin
    Duplicate:=false;
    for j:=0 to LenGth(Arr)-1 do
    if Distance(Values[i],Arr[j])=0 then
    begin
     Duplicate:=true;
     Break;
    end;
    if not Duplicate then
    begin
     SetLenGth(Arr, LenGth(Arr)+1);
     Arr[High(Arr)]:=Values[i];
    end;
   end;
 end;

 procedure IncArray(var B: T3dArray; V: array of T3dPoint;baseTop,ValTop:boolean);
 var k : integer;
     X : T3dArray;
 begin
  IncArray(X,V);
  if not ValTop  then InverseArray(X);
  if not baseTop then InverseArray(B);
  IncArray(B,X);
  Finalize(X);
 end;

function CrossArcToCircle(a0,a1,b0, Center : T3dPoint; var Cross : T3dArray): boolean;
var P1,P2 : T3dPoint;
    C1    : T3dArray;
begin
 P1:=SetPoint(Center, Abs(Center.Z), -pi/2,  avRight,  false);
 P2:=SetPoint(Center, Abs(Center.Z), pi/2, avRight, false);
 result:=CrossArcToArc(A0,A1,B0,P1,P2,Set3dPoint(Center.X, Center.Y, Center.Z),C1); IncArray(Cross,C1);
 result:=CrossArcToArc(A0,A1,B0,P1,P2,Set3dPoint(Center.X, Center.Y, -Center.Z),C1); IncArray(Cross,C1);
end;

function CrossArcToArc(a0,a1,c0, l0,l1,c1 : T3dPoint; var Cross : T3dArray): boolean;
var B,P1,P2   : T3dPoint;
    R         : T3dArray;
begin
 Finalize(Cross); result:=false;
 if (Distance(a0,a1)=0) or (Distance(l0,l1)=0) or (c0.Z=0) or (c1.Z=0) then exit;
 result := CrossCircleToCircle(c0,c1,Cross);
 if not result then exit;
 B:=Set3dPoint(0.5*(Cross[0].X+Cross[1].X),0.5*(Cross[0].Y+Cross[1].Y),0);
 P1:=SetPoint(B, 1.5*Distance(Cross[0],B), GetAngle(B,Cross[0]), avRight, false);
 P2:=SetPoint(B, 1.5*Distance(Cross[1],B), GetAngle(B,Cross[1]), avRight, false);
 Cross[0].Z:=byte(CrossLineToArc(a0,a1,c0,B,P1,R) and CrossLineToArc(l0,l1,c1,B,P1,R));
 Cross[1].Z:=byte(CrossLineToArc(a0,a1,c0,B,P2,R) and CrossLineToArc(l0,l1,c1,B,P2,R));

 case Cross[1].Z=0 of
  true : if (Cross[0].Z=0) then Finalize(Cross) else
         SetLenGth(Cross,1);
  false: if (Cross[0].Z=0) then
         begin
          Cross[0]:=Cross[1];
          SetLenGth(Cross,1);
         end;
 end;
 result:=LenGth(Cross)>0;
 end;

 function CrossPolyToPolyZ(BaseZ,Poly:T3dArray; var Res:T3dArray):boolean;
 var R     : t3dArray;
     i,j,k : integer;
     dZ,pX  : double;
 begin
  Finalize(Res);
  for i:=0 to LenGth(BaseZ)-2 do
  begin
   pX:=Distance(BaseZ[i],BaseZ[i+1]);
   if PX>0 then
   for j:=0 to LenGth(Poly)-2 do
   if CrossLineToLine(BaseZ[i],BaseZ[i+1],Poly[j],Poly[j+1],R)>0 then
   begin
    dZ:=BaseZ[i+1].Z-BaseZ[i].Z;
    for k:=0 to LenGth(R)-1 do
     R[k].Z:=BaseZ[i].Z+dZ*Distance(BaseZ[i],R[k])/pX;
    IncArray(res,R);
   end; // j
  end; // i
  result:=LenGth(Res)>0;
 end;


 function CrossPolyToPoly(Base,bBulge,Poly,pBulge:T3dArray; var Res:T3dArray):boolean;
 var i,j : integer;
     R   : t3dArray;
 begin

  Finalize(res); result:=false;
  if (LenGth(bBulge)>0) and (LenGth(bBulge)<>LenGth(Base)) then exit;
  if (LenGth(pBulge)>0) and (LenGth(pBulge)<>LenGth(Poly)) then exit;

  if (LenGth(bBulge)=0) and (LenGth(pBulge)=0) then
  begin
    for i:=0 to LenGth(base)-2 do
    for j:=0 to LenGth(Poly)-2 do
    if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then IncArray(res,R);

  end else
  if (LenGth(bBulge)=0) and (LenGth(pBulge)>0) then
  begin
   for i:=0 to LenGth(base)-2 do
   for j:=0 to LenGth(Poly)-2 do
   case byte(pBulge[j].Z=0) of
    1: if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then IncArray(res,R);
    0: if CrossLineToArc(Poly[j],Poly[j+1],pBulge[j],Base[i],Base[i+1],R) then IncArray(res,R);
   end;

  end else
  if (LenGth(bBulge)>0) and (LenGth(pBulge)=0) then
  begin
   for i:=0 to LenGth(base)-2 do
   case byte(bBulge[i].Z=0) of
    0: for j:=0 to LenGth(Poly)-2 do
       if CrossLineToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],R) then IncArray(res,R);
    1: for j:=0 to LenGth(Poly)-2 do
       if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then IncArray(res,R);
   end;
  end else
  begin
  for i:=0 to LenGth(base)-2 do
  case byte(bBulge[i].Z=0) of
  1: for j:=0 to LenGth(Poly)-2 do
     case byte(pBulge[j].Z=0) of
      1: if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then IncArray(res,R);
      0: if CrossLineToArc(Poly[j],Poly[j+1],pBulge[j],Base[i],Base[i+1],R) then IncArray(res,R);
     end;
  0: for j:=0 to LenGth(Poly)-2 do
     case byte(pBulge[j].Z=0) of
      0: if CrossArcToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],pBulge[j],R) then IncArray(res,R);
      1: if CrossLineToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],R) then IncArray(res,R);
     end;
  end;
  end;
  result:=LenGth(res)>0;
 end;




 function CrossPolyToPoly(Base,bBulge,Poly,pBulge:T3dArray):boolean;
 var i,j : integer;
     R   : t3dArray;
 begin
  result:=false;
  if (LenGth(bBulge)>0) and (LenGth(bBulge)<>LenGth(Base)) then exit;
  if (LenGth(pBulge)>0) and (LenGth(pBulge)<>LenGth(Poly)) then exit;

  if (LenGth(bBulge)=0) and (LenGth(pBulge)=0) then
  begin
    for i:=0 to LenGth(base)-2 do
    for j:=0 to LenGth(Poly)-2 do
    if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then
    begin
     result:=true;
     Break;
    end;
  end else
  if (LenGth(bBulge)=0) and (LenGth(pBulge)>0) then
  begin
   for i:=0 to LenGth(base)-2 do
   for j:=0 to LenGth(Poly)-2 do
   case byte(pBulge[j].Z=0) of
    1: if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then
       begin
        result:=true;
        Break;
       end;
    0: if CrossLineToArc (Poly[j],Poly[j+1],pBulge[j],Base[i],Base[i+1],R) then
       begin
        result:=true;
        Break;
       end;
   end;

  end else
  if (LenGth(bBulge)>0) and (LenGth(pBulge)=0) then
  begin
   for i:=0 to LenGth(base)-2 do
   case byte(bBulge[i].Z=0) of
    0: for j:=0 to LenGth(Poly)-2 do
       if CrossLineToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],R) then
       begin
        result:=true;
        exit;
       end;
    1: for j:=0 to LenGth(Poly)-2 do
       if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then
       begin
        result:=true;
        exit;
       end;
   end;
  end else
  begin
  for i:=0 to LenGth(base)-2 do
  case byte(bBulge[i].Z=0) of
  1: for j:=0 to LenGth(Poly)-2 do
     case byte(pBulge[j].Z=0) of
      1: if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1],R)>0 then
       begin
        result:=true;
        exit;
       end;
      0: if CrossLineToArc(Poly[j],Poly[j+1],pBulge[j],Base[i],Base[i+1],R) then
         begin
          result:=true;
          exit;
         end;
     end;
  0: for j:=0 to LenGth(Poly)-2 do
     case byte(pBulge[j].Z=0) of
      0: if CrossArcToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],pBulge[j],R) then 
         begin
          result:=true;
          exit;
         end;
      1: if CrossLineToArc(Base[i],Base[i+1],bBulge[i],Poly[j],Poly[j+1],R) then
         begin
          result:=true;
          exit;
         end;
     end;
  end;
  end;
 end;



 function CrossPolyToPoly(Base,Poly:T3dArray):boolean;
 var i,j : integer;
 begin
   result:=false;

   for i:=0 to LenGth(Base)-2 do
   for j:=0 to LenGth(Poly)-2 do
   if CrossLineToLine(Base[i],Base[i+1],Poly[j],Poly[j+1])>0 then
   begin
    result:=true;
    exit;
   end;
 end;


 function CrossPolyToCircle(Base,bBulge:T3dArray;Center:T3dPoint; var Res:T3dArray):boolean;
 var R  : T3dArray;
     i  : integer;
 begin
   result:=false; Finalize(Res);
   if (Center.Z=0) or ((LenGth(bBulge)>0) and (LenGth(bBulge)<>LenGth(Base))) then exit;
   if LenGth(bBulge)=0 then
   begin
    for i:=0 to LenGth(base)-2 do
    if CrossLineToCircle(Base[i],Base[i+1],Center,R) then IncArray(res,R);
   end else
   for i:=0 to LenGth(base)-2 do
   case byte(bBulge[i].Z=0) of
    0: if CrossArcToCircle(Base[i],Base[i+1],bBulge[i],Center,R) then IncArray(res,R);
    1: if CrossLineToCircle(Base[i],Base[i+1],Center,R) then IncArray(res,R);
   end;
   result:=LenGth(res)>0;
 end;

 function CrossPolyToCircle(Base,bBulge:T3dArray;Center:T3dPoint):boolean;
  var R  : T3dArray;
      i  : integer;
 begin
   result:=false;
   if (Center.Z=0) or ((LenGth(bBulge)>0) and (LenGth(bBulge)<>LenGth(Base))) then exit;
   if LenGth(bBulge)=0 then
   begin
    for i:=0 to LenGth(base)-2 do
    if CrossLineToCircle(Base[i],Base[i+1],Center,R) then
    begin
     result:=true;
     exit;
    end;
   end else
   for i:=0 to LenGth(base)-2 do
   case byte(bBulge[i].Z=0) of
    0: if CrossArcToCircle(Base[i],Base[i+1],bBulge[i],Center,R) then
       begin
        result:=true;
        exit;
       end;
    1: if CrossLineToCircle(Base[i],Base[i+1],Center,R) then
       begin
        result:=true;
        exit;
       end;
   end;

 end;

 function CrossPolyToCircle(Base:T3dArray;Center:T3dPoint):boolean;
 var Res,B : T3dArray;
 begin
   result:=CrossPolyToCircle(Base, B, Center, Res);
   Finalize(res);
 end;


function PointInPolygon(Poly,Bulge : T3dArray; Pnt : T3dPoint):boolean;
var i,cnt      : integer;
    FRay, FRes,
    FPoly,FBlg : T3dArray;
begin
  FPoly:=Poly; ClosedArray(FPoly);
  FBlg:=Bulge;
  if (LenGth(FPoly)<>LenGth(FBlg)) and (LenGth(Bulge)>0) then
  begin
   ClosedArray(FBlg);
   FBlg[High(FBlg)].Z:=0;
  end;
  cnt:=0; SetLength(FRay,2);
  FRay[0]:=Pnt;
  if LenGth(FPoly)>1 then
  begin
   FRay[1]:=Set3dPoint(0.5*(FPoly[0].X+FPoly[1].X), 0.5*(FPoly[0].Y+FPoly[1].Y),0);
   FRay[1]:=SetPoint(Pnt, 1e8, GetAngle(Pnt,FRay[1]),avRight,false);
  end else
  FRay[1]:=Set3dPoint(Pnt.X+1e8, Pnt.Y,0);
  for i:=0 to LenGth(FPoly)-2 do
  if LenGth(Bulge)>0 then
  case FBlg[i].Z<>0 of
   true : if CrossLineToArc(FPoly[i],FPoly[i+1],FBlg[i],FRay[0],FRay[1],FRes) then
          inc(Cnt,LenGth(FRes));
   false: if CrossLineToLine(FPoly[i],FPoly[i+1],FRay[0],FRay[1],FRes)=1 then
          inc(Cnt,LenGth(FRes));
  end else
  if CrossLineToLine(FPoly[i],FPoly[i+1],FRay[0],FRay[1],FRes)>0 then
  inc(Cnt,LenGth(FRes));
  result:=(cnt mod 2)=1;
  Finalize(FRes); Finalize(FRay);
  Finalize(FPoly);Finalize(FBlg);
end;

function PointInPolygon3d(Poly,Bulge:T3dArray;Hmin,HMax:double; Pnt : T3dPoint):boolean;
begin
 result:=(Pnt.Z>=Hmin) and (Pnt.Z<=Hmax);
 if result then result:=PointInPolygon(Poly,Bulge,Pnt);
end;

function PointInPolygon3d(Poly : T3dArray;Hmin,HMax:double; Pnt : T3dPoint):boolean;
begin
 result:=(Pnt.Z>=Hmin) and (Pnt.Z<=Hmax);
 if result then result:=PointInPolygon(Poly,Pnt);
end;

function PointInCylinder(Center:T3dPoint;Hmin,HMax:double;Pnt: T3dPoint) :boolean;
begin
 result:=(Pnt.Z>=Hmin) and (Pnt.Z<=Hmax);
 if result then result:=PointInCircle(Center,Pnt);
end;



function PointInPolygon(Poly : T3dArray; Pnt : T3dPoint):boolean;
var i,cnt  : integer;
    FRay,Cross  : t3dArray;
begin
  result:=false;
  if LenGth(Poly)<3 then exit;
  cnt:=0; SetLength(FRay,2);
  FRay[0]:=Pnt;
  FRay[1]:=Set3dPoint(0.5*(Poly[0].X+Poly[1].X), 0.5*(Poly[0].Y+Poly[1].Y),0);
  FRay[1]:=SetPoint(Pnt, 1e8, GetAngle(Pnt,FRay[1]),avRight,false);
  for i:=0 to LenGth(Poly)-1 do
  if CrossLineToLine(Poly[i],Poly[(i+1) mod LenGth(Poly)],FRay[0],FRay[1],Cross)=1 then
  inc(Cnt,LenGth(Cross));
  result:=(cnt mod 2)=1;
end;


function PolyInPoly(Base,bBulge,Second,sBulge : T3dArray):boolean;
var i        : integer;
    FB,FBB,
    FS,FSB,R : T3dArray;
begin
  result:=false; FB:=Base; ClosedArray(FB);
  if LenGth(bBulge)>0 then begin FBB:=bBulge;ClosedArray(FBB);end;
  FS:=Second; ClosedArray(FS);
  if LenGth(sBulge)>0 then begin FSB:=sBulge;ClosedArray(FSB);end;
  result:=CrossPolyToPoly(FB,FBB,FS,FSB);
  if not result then
  for i:=0 to length(Second)-1 do
  if PointInPolygon(FB, FBB, FS[i])then
  begin
   result:=true;
   break;
  end;
  Finalize(R);Finalize(FS);Finalize(FSB);
  Finalize(FB);Finalize(FBB);
end;

function PolyInPoly(Base,Second : T3dArray):boolean;
var i      : integer;
begin
 result:=false;
 if (LenGth(Base)<2) or (LenGth(Second)<2) then exit;
 result:=CrossPolyToPoly(Base,Second);
 if not result then
 for i:=0 to length(Second)-1 do
 if PointInPolygon(Base,Second[i])then
 begin
  result:=true;
  break;
 end;
end;


function PolyInPolyEx(Base,bBulge,Second,sBulge:T3dArray):byte;
var i, cnt    : integer;
    FB, FBB,
    FS,FSB,R  : T3dArray;
begin
 result:=0; cnt:=0;
 FB:=Base; ClosedArray(FB);
 if LenGth(bBulge)>0 then
 begin
  FBB:=bBulge;
  ClosedArray(FBB);
 end;
 FS:=Second; ClosedArray(FS);
 if LenGth(sBulge)>0 then
 begin
  FSB:=sBulge;
  ClosedArray(FSB);
 end;
 // check if all points fall into the base polygon
 for i:=0 to length(FS)-2 do Inc(cnt,byte(PointInPolygon(FB, FBB, FS[i])));
 CrossPolyToPoly(FB,FBB,FS,FSB,R);
 // cnt = length(FS)-1 - all points inside the base polygon
 if (cnt=length(FS)-1) and (LenGth(R)=0) then result:=CR_FULL else
 if (LenGth(R)<>0) then result:=$21;
 Finalize(R);Finalize(FS);Finalize(FSB);
 Finalize(FB);Finalize(FBB);
end;

function PolyInCircleEx(Center:T3dPoint;Poly,Bulge: T3dArray):byte;
var R      : T3dArray;
    i,PinC : integer;
begin
 PinC:=0;
 for i:=0 to LenGth(Poly)-1 do
 Inc(PinC,byte(PointInCircle(Center,Poly[i])));
 CrossPolyToCircle(Poly,Bulge,Center,R);
 if (LenGth(R)=0) and (LenGth(Poly)=PinC) then result:=CR_FULL else
 if (LenGth(R)>0) then result:=$21 else result:=0;
end;



function PolyInCircle(Poly,Bulge: T3dArray;Center:T3dPoint):boolean;
var  i : integer;
begin
 result:=CrossPolyToCircle(Poly,Bulge,Center);
 if not result then
 for i:=0 to LenGth(Poly)-1 do
 if PointInCircle(Center,Poly[i]) then
 begin
  result:=true;
  exit;
 end;
end;

function PolyInCircle(Poly: T3dArray;Center:T3dPoint):boolean;
var  i : integer;
begin
 result:=CrossPolyToCircle(Poly,Center);
 if not result then
 for i:=0 to LenGth(Poly)-1 do
 if PointInCircle(Center,Poly[i]) then
 begin
  result:=true;
  exit;
 end;
end;



function CircleInPoly(Center:T3dPoint;Poly: T3dArray):boolean;
var cinpoly,
    cross   : boolean;
begin
 cinpoly:=PointInPolygon(Poly,Center);
 cross:=CrossPolyToCircle(Poly,Center);
 result:=cinpoly and cross;
 // if the center is inside but there is no intersection with the polyline
 // 1 - option: the circle is completely inside
 // 2 - option: the circle contains the polyline
 if (cinpoly and not cross) then
 // if a point on a circle falls inside the polyline, then the circle is completely inside
 result:=PointInPolygon(Poly, SetPoint(Center, Center.Z, 0, avRight, false));
end;

// TO BE DEVELOPED

function UnionPoly(Poly1,blg1,Poly2,blg2: T3dArray; var Res,bRes :T3dArray):boolean;
var i,j    : integer;
    P1,P2,B1,B2,R : T3dArray;
    cm1,cm2 : byte;

    procedure InsertValues(Index:integer;Values: T3dArray;var Arr: T3dArray);
    var k : integer;
    begin
     SetLength(Arr, LenGth(Arr)+LenGth(Values));
     for k:=Index to LenGth(Arr)-1 do Arr[k+LenGth(Values)]:=Arr[k];
     for k:=0 to LenGth(Values)-1 do  Arr[k+index]:=Values[k];
    end;


    procedure MoveValues(var From, Arr: T3dArray);
    var k : integer;
    begin
     for k:=0 to LenGth(From)-1 do
     if (From[k].Z=-1) or (From[k].Z=0) then
     begin
      SetLength(Arr, LenGth(Arr)+1);
      Arr[High(Arr)]:=From[k];
      From[k].Z:=-2-byte((From[k].Z=0));
     end;

    end;

    function FindVertex(Arr: T3dArray) :boolean;
    var k : integer;
    begin
     result:=false;
     for k:=0 to LenGth(Arr)-1 do
     if (Arr[k].Z=0) or (Arr[k].Z=-1) then
     begin
      result:=true;
      break;
     end;
    end;

begin
 Finalize(Res); Finalize(bRes);
 cm1:=PolyInPolyEx(Poly1,blg1,Poly2,blg2);
 cm2:=PolyInPolyEx(Poly2,blg2,Poly1,blg1);
 if cm1=$21 then
 begin
  Res :=Poly1; bRes:=blg1;
  exit;
 end else
 if cm2=$21 then
 begin
  Res :=Poly2;bRes:=blg2;
  exit;
 end else
 if (cm1=0) or (cm2=0) then exit;
 p1:=Poly1; ClosedArray(P1);
 if LenGth(blg1)>0 then begin b1:=blg1;ClosedArray(b1);end;
 p2:=Poly2; ClosedArray(p2);
 if LenGth(blg2)>0 then begin B2:=blg2;ClosedArray(B2);end;

 for i:=0 to LenGth(p1)-2 do
 begin
  if PointInPolygon(p2, B2, p1[i]) then p1[i].Z:=-1;
  for j:=0 to LenGth(p2)-2 do
  if CrossLineToLine(p1[i],p1[i+1], p2[j], p2[j+1],R)>0 then
  InsertValues(j+1,R,p1);
 end;

 for i:=0 to LenGth(p2)-2 do
 begin
  if not PointInPolygon(p1, B1, p2[i]) then p2[i].Z:=-1;
  for j:=0 to LenGth(p1)-2 do
  if CrossLineToLine(p2[i],p2[i+1], p1[j], p1[j+1],R)>0 then InsertValues(j+1,R,p2);
 end;

 //if FindVertex(A1) then MoveValues(A1,Res);
 //if FindVertex(A2) then MoveValues(A2,Res);

 Finalize(R);
// Finalize(P1);Finalize(P2);
 Finalize(B1);Finalize(B2);
  Res:=p1; bRes:=p2;
end;

function DeleteDuplicatedPoint(Border : TBorder): TBorder;
var i : integer;
begin
 Finalize(result.Vertex);Finalize(result.Bulge);
 if LenGth(Border.Vertex)=0 then exit;
 IncArray(result.Vertex, [Border.Vertex[0]]);
 for i:=1 to LenGth(Border.Vertex)-1 do
 if Distance(Border.Vertex[i], result.Vertex[High(result.Vertex)])>1 then
 begin
  IncArray(result.Vertex, [Border.Vertex[i]]);
  if i<LenGth(Border.Bulge) then
  IncArray(result.Bulge,  [Border.Bulge[i]]);
 end;
 SetLenGth(result.Bulge,LenGth(result.Vertex));
end;

function DeleteDuplicatedPoint(P,B : T3dArray): TBorder;
var BRD : TBorder;
begin
 Brd.Vertex:=P; Brd.Bulge:=B;
 result:=DeleteDuplicatedPoint(BRD);
end;


function ClearCrossLines(InPoly : T3dArray): T3dArray;
var i,j,prev, next, aLen,
    cross: integer;
begin
 aLen:=LenGth(InPoly);
 for i:=0 to aLen-1 do
 begin
  next:=(i+1) mod aLen;
  cross:=0;
  for j:=0 to aLen-1 do
  begin
   prev:=(aLen+(j-1)) mod aLen;
   if (i<>j) and (Next<>j) and (prev<>i) and (Prev<>Next) then
   cross:=byte(CrossLineToLine(InPoly[i],InPoly[Next],InPoly[j],InPoly[prev]));
   if cross>0 then Break;
  end;
  if cross=0 then  IncArray(result, [InPoly[i]]);
 end;
end;



function OffsetPolyline(Poly : TBorder; Offset : double): TBorder;
var i,prev,aLen,
    next  : integer;
    Pnt   : T3dpoint;
    A     : double;
begin
 Finalize(result.Vertex);
 Finalize(result.Bulge);
 if Offset=0 then exit;
 aLen:=LenGth(Poly.Vertex);
 with Poly do
 for i:=1 to alen-1 do
 begin
  next:=(i+1) mod aLen;  prev:=(aLen+(i-1)) mod aLen;
  A:=0.5*(GetAngle(Vertex[i],Vertex[next])+GetAngle(Vertex[prev],Vertex[i]));
  Pnt:=SetPoint(Vertex[i], Abs(Offset),A-pi/2,avRight, false);
  if PointInPolygon(Vertex,Bulge,Pnt) then Pnt:=SetPoint(Vertex[i], Abs(Offset),A+pi/2,avRight, false);
  IncArray(result.Bulge, [Pnt]);
 end;
 result.Vertex:=ClearCrossLines(result.Bulge);
 Finalize(result.Bulge);
 // self-intersection correction
end;


function OffsetPolyline(Poly : T3dArray; Offset : double): T3dArray;
var i,prev,aLen,
    next  : integer;
    Pnt   : T3dpoint;
    A     : double;
    V     : T3dArray;
begin
 Finalize(result);
 if Offset=0 then exit;
 aLen:=LenGth(Poly);

 for i:=1 to alen-1 do
 begin
  next:=(i+1) mod aLen;  prev:=(aLen+(i-1)) mod aLen;
  A:=0.5*(GetAngle(Poly[i],Poly[next])+GetAngle(Poly[prev],Poly[i]));
  Pnt:=SetPoint(Poly[i], Abs(Offset),A-pi/2,avRight, false);
  if PointInPolygon(Poly,Pnt) then
  Pnt:=SetPoint(Poly[i], Abs(Offset),A+pi/2,avRight, false);
  IncArray(V, [Pnt]);
 end;
 result:=ClearCrossLines(V);
 Finalize(V);
 // self-intersection correction
end;

function OffsetCline(Poly : T3dArray): T3dArray;
var i,n,p,len : integer;
    RA        : T3dArray;
    Pnt       : T3dPoint;
    A         : double;
  function CreateOrtho(Pp,Pc,Pn:T3dPoint;AsLeft:double): T3dPoint;
  var A0,A1         : double;
      p1,p01,p2,p02 : T3dPoint;
      R             : T3dArray;
  begin
    A0:=GetAngle(Pp,Pc); A1:=GetAngle(Pc,Pn);
    p1 :=SetPoint(Pp,Pp.Z/2,A0+AsLeft,avRight,false);
    p2 :=SetPoint(Pn,Pn.Z/2,A1+AsLeft,avRight,false);
    p02:=SetPoint(Pc,Pc.Z/2,A1+AsLeft,avRight,false);
    P02:=SetPoint(P2,1e8,GetAngle(P2,P02),avRight,false);
    p01:=SetPoint(Pc,Pc.Z/2,A0+AsLeft,avRight,false);
    P01:=SetPoint(P1,1e8,GetAngle(P1,P01),avRight,false);
    if CrossLineToLine(P1,p01,P2,P02,R)>0 then
    result:=Set3dPoint(R[0].X,R[0].Y,0) else result.Z:=-1;
  end;
begin
 Finalize(result);
 Len:=LenGth(Poly);
 for i:=0 to Len-1 do
 begin
  n:=(i+1) mod Len; p:=(i-1);
  if i=0 then
  begin
   A:=GetAngle(Poly[0],Poly[1]);
   IncArray(result,[SetPoint(Poly[i],Poly[i].Z/2,A+pi/2,avRight,false)]);
   IncArray(RA,[SetPoint(Poly[i],Poly[i].Z/2,A-pi/2,avRight,false)]);
  end else
  if i=Len-1 then
  begin
   A:=GetAngle(Poly[i-1],Poly[i]);
   IncArray(result,[SetPoint(Poly[i],Poly[i].Z/2,A+pi/2,avRight,false)]);
   IncArray(RA,[SetPoint(Poly[i],Poly[i].Z/2,A-pi/2,avRight,false)]);
  end else
  begin
   Pnt:=CreateOrtho(Poly[p],Poly[i],Poly[n],pi/2);
   if Pnt.z<>-1 then IncArray(result,[Pnt]);
   Pnt:=CreateOrtho(Poly[p],Poly[i],Poly[n],-pi/2);
   if Pnt.z<>-1 then IncArray(RA,[Pnt]);
  end;
 end;
 Len:=LenGth(RA);
 for i:=Len-1  downto 0 do
 IncArray(result,[RA[i]]);
 ClosedArray(result);
end;




function ShortDistance(Base : T3dPoint;var Arr : t3dArray): t3dArray;
var i,j  : integer;
    vMax : Double;
begin
 for i:=0 to lenGth(Arr)-1 do Arr[i].Z:=Distance(Base,Arr[i]);
 while Length(result)<LenGth(Arr) do
 begin
  vMax:=-MaxDouble;
  j:=0;
  for i:=0 to Length(Arr)-1 do
  if (Arr[i].Z>vMax) then begin j:=i;vMax:=Arr[i].Z;end;
  SetLength(result,LenGth(result)+1);
  result[High(result)]:=Arr[j];
  Arr[j].Z:=-Arr[j].Z;
 end;
 for i:=0 to lenGth(result)-1 do result[i].Z:=0;
 InverseArray(result);
end;

function ScanPolygon(Poly,Bulge: T3dArray; dH:double): T3dMatrix;
var i,j,index,cnt : integer;
    pMax,pMin     : T3dPoint;
    Cross,pLine,R : T3dArray;
begin
  pMax:=Set3dPoint(-MaxDouble,-MaxDouble,-MaxDouble);
  pMin:=Set3dPoint(MaxDouble,MaxDouble,0);
  for i:=0 to Length(Poly)-1 do
  begin
   if Poly[i].x>pMax.X then pMax.X:= Poly[i].x;
   if Poly[i].y>pMax.Y then pMax.Y:= Poly[i].y;
   if Poly[i].x<pMin.X then pMin.X:= Poly[i].x;
   if Poly[i].y<pMin.Y then pMin.Y:= Poly[i].y;
   if i<LenGth(Bulge) then
   if Abs(Bulge[i].z)>pMax.Z then pMax.Z:=Abs(Bulge[i].z);
  end;
  if pMax.Z<-1e10 then pMax.Z:=0;
  pMin:=Set3dPoint(pMin.x-2*pMax.Z,pMin.y-2*pMax.Z,0);
  pMax:=Set3dPoint(pMax.x+2*pMax.Z,pMax.y+2*pMax.Z,0);
  SetLength(pLine,2);
  while pMin.Y<=pMax.Y do
  begin
   pLine[0]:=Set3dPoint(pMin.X,pMin.y,0);
   pLine[1]:=Set3dPoint(pMax.X,pMin.y,0);
   if CrossPolyToPoly(Poly,Bulge,pLine,Empty,Cross) then
   if LenGth(Cross)>1 then
   begin
    R:=ShortDistance(pLine[0], Cross);
    index:= LenGth(result);
    cnt:=LenGth(R) div 2;
    SetLength(result,LenGth(result)+cnt);
    for j:=0 to cnt-1 do
    begin
     SetLenGth(result[index+j],2);
     result[index+j][0]:=R[j*2];
     result[index+j][1]:=R[j*2+1];
    end;
    Finalize(R);
   end;
   Finalize(Cross);
   pMin.Y:=pMin.Y+dH;

  end;
  Finalize(pLine);
end;

 {
function ScanPolygon(Poly: T3dArray; MX,NY:integer): T3dMatrix;
var i,j,hid,index,cnt    : integer;
    WY, pMax,
    pMin,dH       : T3dPoint;
    cLine,R,Cross  : T3dArray;

begin
  FinalizeMatrix(result);
  if (MX<3) or (NY<3) then exit;
  pMax:=Set3dPoint(-MaxDouble,-MaxDouble,-MaxDouble);
  pMin:=Set3dPoint(MaxDouble,MaxDouble,0);
  for i:=0 to Length(Poly)-1 do
  begin
   if Poly[i].x>pMax.X then pMax.X:= Poly[i].x;
   if Poly[i].x<pMin.X then pMin.X:= Poly[i].x;
   if Poly[i].y>pMax.Y then pMax.Y:= Poly[i].y;
   if Poly[i].y<pMin.Y then pMin.Y:= Poly[i].y;
  end;

  dH.X:=(pMax.X-pMin.X)/(MX+1);

  SetLenGth(cLine,2);
  for i:=0 to MX do
  begin
   cLine[0]:=Set3dPoint(pMin.X+dH.X*i,pMin.Y,0);
   cLine[1]:=Set3dPoint(cLine[0].X,pMax.Y,0);
   if CrossPolyToPolyZ(Poly, cLine, Cross) and (LenGth(Cross)=2) then
   begin
    SetLenGth(result,LenGth(result)+1);
    hid:=High(result);
    WY.X:=Max(Cross[0].Y,Cross[1].Y);
    WY.Y:=Min(Cross[0].Y,Cross[1].Y);
    dH.Y:=(WY.X-WY.Y)/NY;
    SetLength(result[hid],NY+1);
    case Cross[0].Y=WY.Y of
     true : begin
             result[hid,0]:=Cross[0];
             result[hid,NY]:=Cross[1];
            end;
     false: begin
             result[hid,0]:=Cross[1];
             result[hid,NY]:=Cross[0];
            end;
    end;
    for j:=1 to NY-1 do
    begin
     result[hid,j]:=Set3dPoint(cLine[0].X,WY.Y+j*dH.Y,0);
     result[hid,j].Z:=result[hid,0].Z+j*(result[hid,High(result[hid])].Z-result[hid,0].Z)/(NY+1);
    end;

   end; // cross
  end; // i

  Finalize(cLine);

end;      }

//************************************************************//
//                                                            //
//                     3D - intersections                     //
//                                                            //
//************************************************************//
// Line with a parallelepiped object
// POSTPONED in 17.02.2007
function Cross3dPolyToLine(Poly, Bulge : T3dArray; Hmax,Hmin : double; p0,p1 : T3dpoint; var Res : T3dArray):byte;
var Box, line : t3dArray;
    phi,Z     : double;
    index     : integer;
begin
 SetLength(line,2); phi:= GetAngle(p0,p1);
 result:=0;
 Line[0]:=SetPoint(p0, 1e8, phi+pi,avRight, false);
 Line[1]:=SetPoint(p1, 1e8, phi,avRight, false);
 CrossPolyToPoly(Poly,Bulge,line,Empty,line);
 // checking the horizontal intersection of an "infinitely" long line
 // if there is no intersection, the line profile does not pass through the body of the figure
 if length(Line)<>2 then exit;
 // otherwise, create a profile layout, where the z (H) coordinate becomes the y coordinate
 // to run through 2D vertical analysis functions
 // the starting point is chosen p0 (everything is built relative to it)
 SetLength(Box,5);
 // memorize the distances from p0 2D distances to intersections
 // building a section of the object
 Box[0]:=Set3dPoint((1-2*byte(Abs(GetAngle(p0, Line[0])-phi)>pi/2))*Distance(p0,Line[0]),hMin,0);
 Box[1]:=Set3dPoint(Box[0].x,hMax,0);
 // we postpone the second vertical of the object profile from the first one at a distance of 2D between the replays
 Box[2]:=Set3dPoint((1-2*byte(Abs(GetAngle(p0, Line[1])-phi)>pi/2))*Distance(p0,Line[1]),hMax,0);
 Box[3]:=Set3dPoint(Box[2].x,hMin,0); Box[4]:=Box[0];
 // point p0 "0" height in Y, point p1 at a distance to it
 Line[0]:=Set3dPoint(0,P0.z,0); Line[1]:=Set3dPoint(Distance(p0,p1),P1.z,0);
 // looking for an intersection in the vertical plane
 CrossPolyToPoly(Box,Empty,line,Empty,Res);
 // if there is an intersection then transform
 for index:=0 to Length(Res)-1 do
 begin
  Z:= Res[index].y;
  Res[index]:=SetPoint(P0,Res[index].X,phi, avRight, false);
  Res[index].z:=Z;
 end;
 // profile control (commented out specially)
 //ldoc.ModelSpace.AddLightWeightPolyline(ToleArray(Line,true));
 //ldoc.ModelSpace.AddLightWeightPolyline(ToleArray(box,true));
  if Length(Res)=0 then
  begin
   if PointInPolygon(Box,Empty,Line[0]) then IncArray(res, p0);
   if PointInPolygon(Box,Empty,Line[1]) then IncArray(res, p1);
   if Length(Res)=0 then result:=0 else result:=CR_INNER;
  end else
  result:=CR_FULL;
  Finalize(Box); Finalize(Line);
end;

// cylinder with line
function CrossCylinderToLine(Center : T3dPoint; Hmax,Hmin : double; p0,p1 : T3dpoint; var Res : T3dArray):byte;
var Poly, bulge : T3dArray;
begin
 // transform the circle into two arcs
 // and start a regular polygon entry
 SetLength(Poly,3);SetLength(Bulge,3);
 Poly[0] := Setpoint(Center,Abs(Center.Z), 0, avRight, false);
 Bulge[0]:= Center; Bulge[1]:= Center; Bulge[2]:=Set3dPoint(0,0,0);
 Poly[1] := Setpoint(Center,Abs(Center.Z), pi/3, avRight, false);
 Poly[2] :=Poly[0];
 result:=Cross3dPolyToLine(Poly, Bulge, HMax, HMin, p0, p1, res);
 Finalize(Poly);Finalize(Bulge);
end;



// tangent to circle to point
// POSTPONED 2007
function PointKasat(P0, Center: T3dPoint) : T3dArray;
var  dist, A,T  :  double;
begin
 Finalize(result);
 dist := Distance(P0,Center);
 if (Center.Z=0) or (dist<Abs(Center.Z)) then exit;
 a    := arcsin(Abs(Center.Z)/dist);
 T    := GetAngle(P0, Center);
 SetLength(result,2);
 result[0]:=SetPoint(P0, dist*cos(a), t+a, avRight, false);
 result[1]:=SetPoint(P0, dist*cos(a), t-a, avRight, false);
end;

 // tangent between two circles
 // POSTPONED 2007
function CircleKasat(isUpper : boolean; C1, C2: T3dPoint;var Res : T3dArray):boolean;
var Alpha, Dist, Teta : double;
begin;
 Finalize(res); result:=false;
 dist:=Distance(C1,C2);
 if (Dist=0) or (C1.Z=0) or (C2.Z=0) then exit;
 teta:=GetAngle(C1,C2);
 SetLenGth(res,4); result:=true;
 case isUpper of
  TRUE:  begin     // outer touch points
          Alpha :=arcsin((C1.Z-C2.Z)/dist);
          Res[0]:=SetPoint(C1,C1.Z,teta+(pi/2-alpha),avRight,false);
          Res[1]:=SetPoint(C1,C1.Z,teta-(pi/2-alpha),avRight,false);
          Res[2]:=SetPoint(C2,C2.Z,teta+(pi/2-alpha),avRight,false);
          Res[3]:=SetPoint(C2,C2.Z,teta-(pi/2-alpha),avRight,false);
         end;
  FALSE: begin     // interior touch points
          Alpha :=arccos((C2.Z+C1.Z)/dist);
          Res[0]:=SetPoint(C1,C1.Z,teta+alpha,avRight,false);
          Res[1]:=SetPoint(C1,C1.Z,teta-alpha,avRight,false);
          Res[2]:=SetPoint(C2,C2.Z,teta+alpha-pi,avRight,false);
          Res[3]:=SetPoint(C2,C2.Z,teta-alpha-pi,avRight,false);
         end;
 end;
end;


// find the similarity of arcs and a circle in an array of coordinates
// at the input a set of points in the DECARD SYSTEM at the output
// coordinates of the object in the DECARD SYSTEM, taking into account arcs, circles, etc.

function FindCurve(V : T3dArray; pDist: integer;dA:double): TBorder;
var A         : T3dArray;
    dIpu,dOld : double;
    Index     : TIntegerArray;
    i,I0      : integer;
    P         : T3dPoint;


function CalculateCenterCurve(tIndex:integer):boolean;
var crs    : T3dArray;
    p0,p1  : T3dPoint;
begin
 result:=false;
 P:=Set3dPoint(0,0,0);
 p0:=Set3dPoint(0.5*(V[tIndex].X+V[tIndex+1].X),0.5*(V[tIndex].Y+V[tIndex+1].Y));
 p1:=Set3dPoint(0.5*(V[tIndex+1].X+V[tIndex+2].X),0.5*(V[tIndex+1].Y+V[tIndex+2].Y));
 if CrossLineToLine(P0,SetPoint(P0,1E8, A[tIndex].Y+pi/2, avRight, false),
 P1,SetPoint(P1,1E8, A[tIndex+1].Y+pi/2, avRight, false),crs)>0 then
 crs[0].Z:=-Distance(V[tIndex],crs[0]) else
 if CrossLineToLine(P0,SetPoint(P0,1E8, A[tIndex].Y-pi/2, avRight, false),
 P1,SetPoint(P1,1E8, A[tIndex+1].Y-pi/2, avRight, false),crs)>0 then
 crs[0].Z:=Distance(V[tIndex],crs[0]) else exit;
 P:=Crs[0]; result:=true;
 Finalize(crs);
end;

begin
  finalize(result.Vertex);
  finalize(result.Bulge);
  if Length(V)<2 then exit;
  for i:=0 to LenGth(V)-2 do
  IncArray(A,[Set3dPoint(Distance(V[i],V[i+1]),GetAngle(V[i],V[i+1]))]);
  dOld:=0;
  SetLenGth(Index,LenGth(V));
  P.Y:=Abs(dA*pi/180);
  for i:=0 to LenGth(A)-2 do
  begin
   dIpu:= DeltaIPU(A[i].Y,A[i+1].Y);
   P.X := pDist*A[i].X/100;
   index[i]:= byte(((A[i+1].X-A[i].X)<P.X ) and (Abs(dIpu-dOld)<P.Y));
   dOld:=dIpu;
  end;
  i0:=0; i:=0;
  while i<LenGth(index)-1 do
  begin
   if index[i]=0 then
   begin
    if (i0>5) then
    begin
     index[i-i0-1]:=2;
     index[i]:=1;
     index[i+1]:=3;
    end;
   i0:=0;
   end else inc(i0);
   inc(i);
  end;

  with result do
  begin
   for i:=0 to lenGth(index)-1 do
   if index[i]<>1 then
   begin
    IncArray(Vertex,[V[i]]);
    if (index[i]=2) and CalculateCenterCurve(i) then
    IncArray(Bulge,[P]) else IncArray(Bulge,[Set3dPoint(0,0,0)]);
   end;
    dIPU:=Distance(V[0],V[High(V)]);
   // if 1 arc is calculated in which the length from the start point to the end point is
   // the length of the remaining shoulders then - found a CIRCLE!
   if ((dIPU<1E-5) or (Abs(dIPU-A[0].X)<pDist*A[0].X/100)) and (Bulge[0].Z<>0) and (LenGth(Vertex)=2)  then
   begin
    SetLenGth(Vertex,1);
    Vertex[0]:=Bulge[0];
    Vertex[0].Z:=Abs(Vertex[0].Z);
    Finalize(Bulge);
   end;
  end;

  Finalize(index);
  Finalize(A);
end;


end.

