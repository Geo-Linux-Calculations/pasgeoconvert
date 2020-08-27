//******************************************************************************
//***                        GEODESIC LIBRARY
//******************************************************************************
//
unit uGisCalc;
interface
uses MathExt;

type
  TEckMode     = 1..6;
  TWagnerMode  = 1..7;
  TMurdochMode = 1..3;
  TVandNumb    = 1..4;
  TPutpType=(putpP1,putpP2,putpP3,putpP3p,putpP4p,putpP5,putpP5p,putpP6,putpP6p);


  TEllpsType =
 // planet Earth
  (ellNone,ellMerit, ellSGS85, ellGRS80, ellIAU76, ellAiry, ellAPL49,
   ellNWL9D, ellModAriy, ellAndrae, ellAustSA, ellGRS67,
   ellBessel, ellBesselNamibia, ellClark66, ellClark80,
   ellCPM, ellDelambre, ellEngelis, ellEverest30, ellEverest48,
   ellEverest56, ellEverest69, ellEverestSS, ellFischer60,
   ellFischer60m, ellFischer68, ellHelmert, ellHough,
   ellInternational, ellKrass, ellKaula, ellLerch,
   ellMaupertius, ellNewInternational, ellPlessis, ellSEAsia,
   ellWalbeck, ellWGS60, ellWGS66, ellWGS72, ellWGS84, ellSphere,

  ellMoon, // MOON
  ellMercury, // Mercury
  ellVenus, // Venus
  ellMars, // Mars
  ellYupiter, // Jupiter
  ellSaturn,// Saturn
  ellUran, // Uran
  ellNeptun, // Neptune
  ellPluton, // Pluton
  ellSun
  );

 TDatumParam = array of double;

 TDatum = packed record
  eDest    : TEllpsType;
  Value    : TDatumParam;
 end;

 TEllipsoidProperty = packed record
  eName   : string;
  a       : double;  // major axis or radius if es=0
  b       : double;  // minor axis or radius if es=0
  e       : double;  // eccentricity
  es      : double;  // e ^ 2
  one_es  : double;  // 1 - e^2
  rone_es : double;  // 1/(1 - e^2)
  ra      : double;  // 1/A
  Rf      : double;  // references
  Code    : string;
 end;

 TProjTitle = packed record
  Id    : string;
  AcId  : string;
  Comm  : string;
 end;

//=================================================================
const
 ProjectionsName : array[0..126] of TProjTitle = (
  (Id: 'aea';    AcId:'AZMEA'; Comm: 'Alberta Equal'),
  (Id: 'aeqd';   AcId:'AZMED'; Comm: 'Azimuthal long-intermediate'),
  (Id: 'airy';   AcId:''; Comm: 'Airy'),
  (Id: 'aitoff'; AcId:''; Comm: 'Aitova'),
  (Id: 'alsk';   AcId:''; Comm: 'Modified stereographic (Alaska)'),
  (Id: 'apian';  AcId:''; Comm: 'Apian Globular I'),
  (Id: 'august'; AcId:''; Comm: 'August Epicycloidal'),
  (Id: 'bacon';  AcId:''; Comm: 'Becken spherical'),
  (Id: 'bipc';   AcId:'BIPOLAR'; Comm: 'Bipolar conic of western hemisphere'),
  (Id: 'boggs';  AcId:''; Comm: 'Boggs Eumorphic'),
  (Id: 'bonne';  AcId:'BONNE'; Comm: 'Bonne (Werner lat_1=90)'),
  (Id: 'cass';   AcId:'CASSINI'; Comm: 'Cassini'),
  (Id: 'cc';     AcId:''; Comm: 'Central Cylindrical'),
  (Id: 'cea';    AcId:''; Comm: 'Equal area cylindrical'),
  (Id: 'chamb';  AcId:''; Comm: 'Chamberlin Trimetric'),
  (Id: 'collg';  AcId:''; Comm: 'Collignon'),
  (Id: 'crast';  AcId:''; Comm: 'Craster Parabolic (Putnins P4)'),
  (Id: 'denoy';  AcId:''; Comm: 'Denoyer Semi-Elliptical'),
  (Id: 'eck1';   AcId:''; Comm: 'Eckert I'),
  (Id: 'eck2';   AcId:''; Comm: 'Eckert II'),
  (Id: 'eck3';   AcId:''; Comm: 'Eckert III'),
  (Id: 'eck4';   AcId:'ECKERT4'; Comm: 'Eckert IV'),
  (Id: 'eck5';   AcId:''; Comm: 'Eckert V'),
  (Id: 'eck6';   AcId:'ECKERT6'; Comm: 'Eckert VI'),
  (Id: 'eqc';    AcId:'EDCYL'; Comm: 'Cylindrical long-intermediate (Curry)'),
  (Id: 'eqdc';   AcId:'EDCNC'; Comm: 'Conical long-intermediate'),
  (Id: 'euler';  AcId:''; Comm: 'Euler'),
  (Id: 'fahey';  AcId:''; Comm: 'Fahea'),
  (Id: 'fouc';   AcId:''; Comm: 'Foucaut'),
  (Id: 'fouc_s'; AcId:''; Comm: 'Foucaut Sinusoidal'),
  (Id: 'gall';   AcId:''; Comm: 'Gaul (sterographic)'),
  (Id: 'gins8';  AcId:''; Comm: 'Ginsburg VIII (TsNIIGAiK)'),
  (Id: 'gn_sinu';AcId:''; Comm: 'General Sinusoidal Series'),
  (Id: 'gnom';   AcId:'GNOMONIC'; Comm: 'Gnomic'),
  (Id: 'goode';  AcId:'GOODE';    Comm: 'Goode Homolosine'),
  (Id: 'gs48';   AcId:''; Comm: 'Mod. Stererographics of 48 U.S.'),
  (Id: 'gs50';   AcId:''; Comm: 'Mod. Stererographics of 50 U.S.'),
  (Id: 'hammer'; AcId:''; Comm: 'Hammer and Eckert-Greifendorf'),
  (Id: 'hatano'; AcId:''; Comm: 'Asymmetric equal area Hatano'),
  (Id: 'imw_p';  AcId:''; Comm: 'Polyconic international'),
  (Id: 'kav5';   AcId:''; Comm: 'Kavraisky V'),
  (Id: 'kav7';   AcId:''; Comm: 'Kavraisky VII'),
  (Id: 'labrd';  AcId:''; Comm: 'Laborde'),
  (Id: 'lagrng'; AcId:''; Comm: 'Lagrange'),
  (Id: 'larr';   AcId:''; Comm: 'Larrivee'),
  (Id: 'lask';   AcId:''; Comm: 'Laskowski'),
  (Id: 'latlong';AcId:'LL'; Comm: 'Lat/long (Geocentric)'),
  (Id: 'longlat';AcId:'LL'; Comm: 'Lat/long (Geocentric)'),
  (Id: 'laea';   AcId:'LMTAN';    Comm: 'Lambert azimuthal equal area'),
  (Id: 'lcc';    AcId:'LM'; Comm: 'Lambert conical equazimuth'),
  (Id: 'leac';   AcId:''; Comm: 'Lambert equal-area conical'),
  (Id: 'lee_os'; AcId:''; Comm: 'Lee Oblated Stereographic'),
  (Id: 'loxim';  AcId:''; Comm: 'Loximuthal'),
  (Id: 'lsat';   AcId:''; Comm: 'Space oblique for LANDSAT'),
  (Id: 'mbt_s';  AcId:''; Comm: 'McBryde-Thomas Flat-Polar Sine (No. 1)'),
  (Id: 'mbt_fps';AcId:''; Comm: 'McBryde-Thomas Flat-Pole Sine (No. 2)'),
  (Id: 'mbtfpp'; AcId:''; Comm: 'McBride-Thomas Flat-Polar Parabolic'),
  (Id: 'mbtfpq'; AcId:''; Comm: 'McBryde-Thomas Flat-Polar Quartic'),
  (Id: 'mbtfps'; AcId:''; Comm: 'McBryde-Thomas Flat-Polar Sinusoidal'),
  (Id: 'merc';   AcId:'MRCAT'; Comm: 'Mercator'),
  (Id: 'mil_os'; AcId:'MSTERO'; Comm: 'Miller Stereographic'),
  (Id: 'mill';   AcId:'MILLER'; Comm: 'Cylindrical Miller'),
  (Id: 'mpoly';  AcId:''; Comm: 'Modified Polyconic'),
  (Id: 'moll';   AcId:'MOLLWEID'; Comm: 'Mallweida'),
  (Id: 'murd1';  AcId:''; Comm: 'Murdocha I'),
  (Id: 'murd2';  AcId:''; Comm: 'Murdocha II'),
  (Id: 'murd3';  AcId:''; Comm: 'Murdocha III'),
  (Id: 'nell';   AcId:''; Comm: 'Nella'),
  (Id: 'nell_h'; AcId:''; Comm: 'Nella-Hammer'),
  (Id: 'nicol';  AcId:''; Comm: 'Nicolosi Globular'),
  (Id: 'nsper';  AcId:''; Comm: 'Near-sided perspective'),
  (Id: 'nzmg';   AcId:'NZEALAND'; Comm: 'New Zealand Grid'),
  (Id: 'ob_tran';AcId:''; Comm: 'General Oblique Transformation'),
  (Id: 'ocea';   AcId:''; Comm: 'Oblique cylindrical equal area'),
  (Id: 'oea';    AcId:''; Comm: 'Oblated Equal Area'),
  (Id: 'omerc';  AcId:''; Comm: 'Oblique Mercator'),
  (Id: 'ortel';  AcId:''; Comm: 'Ortelius Oval'),
  (Id: 'ortho';  AcId:'ORTHO'; Comm: 'Orthographic'),
  (Id: 'pconic'; AcId:''; Comm: 'Perspective conical'),
  (Id: 'poly';   AcId:'PLYCN'; Comm: 'Polyconic (American)'),
  (Id: 'putp1';  AcId:''; Comm: 'Putnins P1'),
  (Id: 'putp2';  AcId:''; Comm: 'Putnins P2'),
  (Id: 'putp3';  AcId:''; Comm: 'Putnins P3'),
  (Id: 'putp3p'; AcId:''; Comm: 'Putnins P3p'),
  (Id: 'putp4p'; AcId:''; Comm: 'Putnins P4p'),
  (Id: 'putp5';  AcId:''; Comm: 'Putnins P5'),
  (Id: 'putp5p'; AcId:''; Comm: 'Putnins P5p'),
  (Id: 'putp6';  AcId:''; Comm: 'Putnins P6'),
  (Id: 'putp6p'; AcId:''; Comm: 'Putnins P6p'),
  (Id: 'qua_aut';AcId:''; Comm: 'Quartic Authalic'),
  (Id: 'robin';  AcId:'ROBINSON'; Comm: 'Robinson'),
  (Id: 'rpoly';  AcId:''; Comm: 'Rectangular Polyconic'),
  (Id: 'sinu';   AcId:'SINUS'; Comm: 'Sinusoidal (Sansona-Flamsteed)'),
  (Id: 'somerc'; AcId:'SWISS'; Comm: 'Mercator (Switzerland)'),
  (Id: 'stereo'; AcId:''; Comm: 'Stereographic'),
  (Id: 'tcc';    AcId:''; Comm: 'Transverse central-cylindrical'),
  (Id: 'tcea';   AcId:'TEACYL'; Comm: 'Transverse cylindrical equal area'),
  (Id: 'tissot'; AcId:''; Comm: 'Tissot'),
  (Id: 'tmerc';  AcId:'TM'; Comm: 'Transverse Mercator'),
  (Id: 'tpeqd';  AcId:''; Comm: 'Equal distance based on 2 points'),
  (Id: 'tpers';  AcId:''; Comm: 'Oblique perspective'),
  (Id: 'ups';    AcId:'PSTEROSL'; Comm: 'Polar-sterographic (universal)'),
  (Id: 'urm5';   AcId:''; Comm: 'Urmaeva V'),
  (Id: 'urmfps'; AcId:''; Comm: 'Urmaeva Flat-Polar Sinusoidal'),
  (Id: 'utm';    AcId:'UTM'; Comm: '(UTM) Universal transverse Mercator'),
  (Id: 'vandg';  AcId:'VDGRNTN'; Comm: 'Van der Grinten I'),
  (Id: 'vandg2'; AcId:''; Comm: 'Van der Grinten II'),
  (Id: 'vandg3'; AcId:''; Comm: 'Van der Grinten III'),
  (Id: 'vandg4'; AcId:''; Comm: 'Van der Grinten IV'),
  (Id: 'vitk1';  AcId:''; Comm: 'Vitkovsky I'),
  (Id: 'wag1';   AcId:''; Comm: 'Wagner I (Kavraisky VI)'),
  (Id: 'wag2';   AcId:''; Comm: 'Wagner II'),
  (Id: 'wag3';   AcId:''; Comm: 'Wagner III'),
  (Id: 'wag4';   AcId:''; Comm: 'Wagner IV'),
  (Id: 'wag5';   AcId:''; Comm: 'Wagner V'),
  (Id: 'wag6';   AcId:''; Comm: 'Wagner VI'),
  (Id: 'wag7';   AcId:''; Comm: 'Wagner VII'),
  (Id: 'weren';  AcId:''; Comm: 'Wereshnikova I'),
  (Id: 'wink1';  AcId:'WINKEL'; Comm: 'Winkel I'),
  (Id: 'wink2';  AcId:''; Comm: 'Winkel II'),
  (Id: 'wintri'; AcId:''; Comm: 'Winkel-Triplea'),
  (Id: 'lcca';   AcId:''; Comm: 'Lambert conical alternative option'),
  (Id: 'krovak'; AcId:'KROVAK'; Comm: 'Krovaka'),
  (Id: 'geocent';AcId:''; Comm: 'Geocentric'),
  (Id: 'gauss';  AcId:'GAUSSK'; Comm: 'Gauss-Krugerr'),
//  (Id: 'pz90';   AcId:'PZ90'; Comm: 'PZ-90'),
//  (Id: 'ck95';   AcId:'CK95'; Comm: 'CK-95'),
  (Id: 'ck63';   AcId:'CK63'; Comm: 'CK-63'),
  (Id: 'MCK';   AcId:'MCK-R'; Comm: 'MCK based on CK63')
);



Ellipsoids : array[TEllpsType] of TEllipsoidProperty = (
(ename:'EMPTY SPHEROID';a:6000000;b:6000000;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 1.66666E-7;rf: 0;code:'Empty'),
(eName:'MERIT 1983';a:6378137.0;b:6356752.29821597;e: 0.08181922;es: 0.00669438499958719;one_es: 0.993305615000413;rone_es: 1.00673950181947;
  ra: 0.15678559428874E-6;rf: 0.00335281317789691;code:'MERIT'),
(ename:'Soviet Geodetic System 85';a:6378136.0;b:6356751.30156878;e: 0.08181922;
es: 0.0066943849995883;one_es: 0.993305615000412;rone_es: 1.00673950181947;ra: 0.156785618870466E-6;rf: 0.00335281317789691;code:'SGS85'),
(ename:'GRS 1980(IUGG 1980)';a:6378137.0;b:6356752.31414036;e: 0.08181919;
es: 0.00669438002289957;one_es: 0.9933056199771;rone_es: 1.00673949677548;ra: 0.15678559428874E-6;rf: 0.00335281068118232;code:'GRS80'),
(ename:'IAU 1976';a:6378140.0;b:6356755.28815753;e: 0.08181922;
es: 0.00669438499958741;one_es: 0.993305615000413;rone_es: 1.00673950181947;ra: 0.156785520543607E-6;rf: 0.00335281317789691;code:'IAU76'),
(ename:'Airy 1830';a:6377563.396;b:6356256.91;e: 0.08167337;
es: 0.00667053976159737;one_es: 0.993329460238403;rone_es: 1.00671533466852;ra: 0.156799695731319E-6;rf: 0.00334085052190358;code:'airy'),
(ename:'Appl. Physics. 1965';a:6378137.0;b:6356751.79631182;e: 0.08182018;
es: 0.0066945418545874;one_es: 0.993305458145413;rone_es: 1.00673966079587;ra: 0.15678559428874E-6;rf: 0.00335289186923722;code:'APL4.9'),
(ename:'Naval Weapons Lab 1965';a:6378145.0;b:6356759.76948868;e: 0.08182018;
es: 0.00669454185458873;one_es: 0.993305458145411;rone_es: 1.00673966079587;ra: 0.156785397635206E-6;rf: 0.00335289186923722;code:'NWL9D'),
(ename:'Modified Airy';a:6377340.189;b:6356034.446;e: 0.08167338;
es: 0.00667054060589878;one_es: 0.993329459394101;rone_es: 1.0067153355242;ra: 0.156805183722966E-6;rf: 0.00334085094546921;code:'mod_airy'),
(ename:'Andrae 1876 (Den.Iclnd.)';a:6377104.43;b:6355847.41523333;e: 0.08158159;
es: 0.00665555555555652;one_es: 0.993344444444443;rone_es: 1.00670014876791;ra: 0.156810980747888E-6;rf: 0.00333333333333333;code:'andrae'),
(ename:'Australian Natl & S. Amer. 1969';a:6378160.0;b:6356774.71919531;e: 0.08182018;
es: 0.0066945418545864;one_es: 0.993305458145414;rone_es: 1.00673966079587;ra: 0.156785028911159E-6;rf: 0.00335289186923722;code:'aust_SA'),
(ename:'GRS 67(IUGG 1967)';a:6378160.0;b:6356774.51609071;e: 0.08182057;
es: 0.00669460532856936;one_es: 0.993305394671431;rone_es: 1.00673972512833;ra: 0.156785028911159E-6;rf: 0.00335292371299641;code:'GRS67'),
(ename:'Bessel 1841';a:6377397.155;b:6356078.96281819;e: 0.081696831215255833813584066738272;
es: 0.006674372230614;one_es: 0.993325627769386;rone_es: 1.00671921879917;ra: 0.156803783063123E-6;rf: 0.00334277318217481;code:'bessel'),
(ename:'Bessel 1841 (Namibia)';a:6377483.865;b:6356165.38296633;e: 0.08169683;
es: 0.00667437223180078;one_es: 0.993325627768199;rone_es: 1.00671921879917;ra: 0.156801651116369E-6;rf: 0.00334277318217481;code:'bess_nam'),
(ename:'Clarke 1866';a:6378206.4;b:6356583.8;e: 0.08227185;
es: 0.0067686579972912;one_es: 0.993231342002709;rone_es: 1.00681478494592;ra: 0.156783888335755E-6;rf: 0.00339007530392876;code:'clrk66'),
(ename:'Clarke 1880 mod.';a:6378249.145;b:6356514.96582849;e: 0.08248322;
es: 0.00680348119602181;one_es: 0.993196518803978;rone_es: 1.00685008562476;ra: 0.156782837619931E-6;rf: 0.00340754628384929;code:'clrk80'),
(ename:'Comm. des Poids et Mesures 1799';a:6375738.7;b:6356666.22191211;e: 0.07729088;
es: 0.00597388071841887;one_es: 0.994026119281581;rone_es: 1.00600978244187;ra: 0.156844570810281E-6;rf: 0.00299141463998325;code:'CPM'),
(ename:'Delambre 1810 (Belgium)';a:6376428;b:6355957.92616372;e: 0.08006397;
es: 0.00641023989446932;one_es: 0.993589760105531;rone_es: 1.00645159617364;ra: 0.15682761571212E-6;rf: 0.00321027287319422;code:'delmbr'),
(ename:'Engelis 1985';a:6378136.05;b:6356751.32272154;e: 0.08181928;
es: 0.00669439396253357;one_es: 0.993305606037466;rone_es: 1.00673951090364;ra: 0.15678561764138E-6;rf: 0.00335281767444543;code:'engelis'),
(ename:'Everest 1830';a:6377276.345;b:6356075.41314024;e: 0.08147298;
es: 0.00663784663019951;one_es: 0.9933621533698;rone_es: 1.00668220206264;ra: 0.156806753526376E-6;rf: 0.00332444929666288;code:'evrst30'),
(ename:'Everest 1948';a:6377304.063;b:6356103.03899315;e: 0.08147298;
es: 0.00663784663020128;one_es: 0.993362153369799;rone_es: 1.00668220206264;ra: 0.156806071989232E-6;rf: 0.00332444929666288;code:'evrst48'),
(ename:'Everest 1956';a:6377301.243;b:6356100.2283681;e: 0.08147298;
es: 0.00663784663020017;one_es: 0.9933621533698;rone_es: 1.00668220206264;ra: 0.156806141327829E-6;rf: 0.00332444929666288;code:'evrst56'),
(ename:'Everest 1969';a:6377295.664;b:6356094.6679152;e: 0.08147298;
es: 0.00663784663020106;one_es: 0.993362153369799;rone_es: 1.00668220206264;ra: 0.156806278505327E-6;rf: 0.00332444929666288;code:'evrst69'),
(ename:'Everest (Sabah & Sarawak)';a:6377298.556;b:6356097.5503009;e: 0.08147298;
es: 0.00663784663019851;one_es: 0.993362153369801;rone_es: 1.00668220206264;ra: 0.156806207396259E-6;rf: 0.00332444929666288;code:'evrstSS'),
(ename:'Fischer (Mercury Datum) 1960';a:6378166;b:6356784.28360711;e: 0.08181333;
es: 0.00669342162296482;one_es: 0.993306578377035;rone_es: 1.00673852541468;ra: 0.156784881422026E-6;rf: 0.00335232986925913;code:'fschr60'),
(ename:'Modified Fischer 1960';a:6378155;b:6356773.32048274;e: 0.08181333;
es: 0.00669342162296449;one_es: 0.993306578377036;rone_es: 1.00673852541468;ra: 0.156785151818982E-6;rf: 0.00335232986925913;code:'fschr60m'),
(ename:'Fischer 1968';a:6378150;b:6356768.33724438;e: 0.08181333;
es: 0.00669342162296749;one_es: 0.993306578377033;rone_es: 1.00673852541468;ra: 0.156785274726998E-6;rf: 0.00335232986925913;code:'fschr68'),
(ename:'Helmert 1906';a:6378200;b:6356818.16962789;e: 0.08181333;
es: 0.00669342162296627;one_es: 0.993306578377034;rone_es: 1.00673852541468;ra: 0.156784045655514E-6;rf: 0.00335232986925913;code:'helmert'),
(ename:'Hough';a:6378270.0;b:6356794.34343434;e: 0.08199189;
es: 0.00672267002233429;one_es: 0.993277329977666;rone_es: 1.00676817019722;ra: 0.15678232498781E-6;rf: 0.00336700336700337;code:'hough'),
(ename:'International 1909 (Hayford)';a:6378388.0;b:6356911.94612795;e: 0.08199189;
es: 0.00672267002233207;one_es: 0.993277329977668;rone_es: 1.00676817019722;ra: 0.156779424519173E-6;rf: 0.00336700336700337;code:'intl'),
(ename:'(CK-42) Krassovsky 1942';a:6378245;b:6356863.01877305;e: 0.081813334;
es: 0.00669342162296504;one_es: 0.993306578377035;rone_es: 1.00673852541468;ra: 0.156782939507655E-6;rf: 0.00335232986925913;code:'krass'),
(ename:'Kaula 1961';a:6378163;b:6356776.99208691;e: 0.08182155;
es: 0.0066947659459099;one_es: 0.99330523405409;rone_es: 1.00673988791802;ra: 0.156784955166558E-6;rf: 0.00335300429184549;code:'kaula'),
(ename:'Lerch 1979';a:6378139;b:6356754.29151034;e: 0.08181922;
es: 0.00669438499958852;one_es: 0.993305615000411;rone_es: 1.00673950181947;ra: 0.15678554512531E-6;rf: 0.00335281317789691;code:'lerch'),
(ename:'Maupertius 1738';a:6397300;b:6363806.28272251;e: 0.10219488;
es: 0.0104437926591934;one_es: 0.989556207340807;rone_es: 1.0105540166205;ra: 0.15631594578963E-6;rf: 0.00523560209424084;code:'mprts'),
(ename:'New International 1967';a:6378157.5;b:6356772.2;e: 0.08182023;
es: 0.0066945504730862;one_es: 0.993305449526914;rone_es: 1.00673966953093;ra: 0.156785090365047E-6;rf: 0.00335289619298362;code:'new_intl'),
(ename:'Plessis 1817 (France)';a:6376523;b:6355863;e: 0.08043334;
es: 0.00646952287129587;one_es: 0.993530477128704;rone_es: 1.00651165014081;ra: 0.15682527923133E-6;rf: 0.00324001026891929;code:'plessis'),
(ename:'Southeast Asia';a:6378155.0;b:6356773.3205;e: 0.08181333;
es: 0.00669342161757036;one_es: 0.99330657838243;rone_es: 1.00673852540921;ra: 0.156785151818982E-6;rf: 0.00335232986655221;code:''),
(ename:'Walbeck';a:6376896.0;b:6355834.8467;e: 0.08120682;
es: 0.00659454809019966;one_es: 0.9934054519098;rone_es: 1.00663832484261;ra: 0.156816106143177E-6;rf: 0.00330272805139054;code:'Walbeck'),
(ename:'WGS 60';a:6378165.0;b:6356783.28695944;e: 0.08181333;es: 0.00669342162296482;one_es: 0.993306578377035;rone_es: 1.00673852541468;ra: 0.156784906003529E-6;rf: 0.00335232986925913;code:'WGS60'),
(ename:'WGS 66';a:6378145.0;b:6356759.76948868;e: 0.08182018;es: 0.00669454185458873;one_es: 0.993305458145411;rone_es: 1.00673966079587;ra: 0.156785397635206E-6;rf: 0.00335289186923722;code:'WGS66'),
(ename:'WGS 72';a:6378135.0;b:6356750.52001609;e: 0.08181881;es: 0.00669431777826779;one_es: 0.993305682221732;rone_es: 1.00673943368903;ra: 0.1567856434522E-6;rf: 0.0033527794541675;code:'WGS72'),
(ename:'WGS 84';a:6378137.0;b:6356752.31424518;e: 0.08181919;es: 0.00669437999014111;
one_es: 0.99330562000985889;rone_es:1.0067394967422762251591434067861;ra:0.15678559428874E-6;
rf: 0.00335281066474748;code:'WGS84'),
(ename:'Normal Sphere (r=6370997)';a:6370997.0;b:6370997;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 0.156961304486566E-6;rf: 0;code:'sphere'),

(ename:'Lunar spheroid';a:1738000.0;b:1738000.0;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 5.7537399309551208285385500575374e-7;rf: 0;code:'Moon'),
(ename:'Mercury';a:2424000.0;b:2424000.0;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 4.1254125412541254125412541254125e-7;rf: 0;code:'Mercury'),
(ename:'Venus';  a:6059000.0;b:6059000.0;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 1.6504373659019640204654233371844e-7;rf: 0;code:'Venus'),
(ename:'Mars';a:3380000;b:3379924.632;e: 0.006678;es: 4.45957E-05;one_es: 0.999955404;rone_es: 1.000044598;ra: 2.95858E-07;rf: 2.22981E-05;code:'Mars'),
(ename:'Jupiter';a:71436000;b:71296340.04;e:0.0625;es:0.00390625;one_es: 0.99609375;rone_es: 1.003921569; ra: 1.39985E-08;rf: 0.001955036;code:'Yupiter'),
(ename:'Saturn';a:60591000;b:60287283.8;e:0.1;es:0.01;one_es: 0.99;rone_es: 1.01010101;ra:1.65041E-08;rf: 0.005012563;code:'Saturn'),
(ename:'Uran';a:24874000;b:24866225.66;e:0.025;es:0.000625;one_es:0.999375;rone_es: 1.000625391; ra: 4.02026E-08;rf: 0.000312549;code:'Uran'),
(ename:'Neptune';a:24874000;b:24870405.45;e:0.017;es:0.000289;one_es: 0.999711;rone_es: 1.000289084;ra:4.02026E-08;rf:0.00014451;code:'Neptun'),
(ename:'Pluton';a:1275000.0;b:1275000.0;e: 0;es: 0;one_es: 1;rone_es: 1;ra: 7.8431372549019607843137254901961e-7;rf: 0;code:'Pluton'),
(ename:'Sun';a:695866000.0;b:695866000.0;e: 0;es: 0;one_es: 1;rone_es: 1; ra: 1.4370582842098909847585598376699e-9;rf: 0;code:'Sun')
);


type
  TDegType   = (dtNone, dtLat, dtLong, dtXLat, dtXLong, dtDegLat, dtDegLong);
  TCoordType = (ctDMS, ctDegree, ctRadian);

  TUnitsType = (
  utKM,         // Kilometer
  utM,          // Meter
  utDM,         // Decimeter
  utCM,         // Centimeter
  utMM,         // Millimeter
  utNM,         // International Nautical Mile
  utIN,         // International Inch
  utFT,         // International Foot
  utYard,       // International Yard
  utSM,         // International Statute Mile
  utFathom,     // International Fathom
  utChain,      // International Chain
  utLink,       // International Link
  utUSSurvIN,   // U.S. Surveyor´s Inch
  utUSSurvFT,   // U.S. Surveyor´s Foot
  utUSSurvYard, // U.S. Surveyor´s Yard
  utUSSurvChain,// U.S. Surveyor´s Chain
  utUSSurvSM,   // U.S. Surveyor´s Statute Mile
  utIndianYard, // Indian Yard
  utIndianFT,   // Indian Foot
  utIndianChain // Indian Chain
  );                                 

const
  cPlainUnits : Array [TUnitsType] Of extended =
       (1000.0, 1.0, 0.1, 0.01, 0.001, 1852.0, 0.0254,
        0.3048, 0.9144, 1609.344, 1.8288, 20.1168, 0.201168, 1/39.37,
        0.304800609601219, 0.914401828803658,  20.11684023368047, 1609.347218694437,
        0.91439523, 0.30479841, 20.11669506);

 NullPoint : T3dPoint = (X:0;Y:0;Z:0);

 InfPoint  : T3dPoint = (X:1/0;Y:1/0;Z:0);


 type
  TComplex = record
   r,i : double;

  end;
  PComplexArray = ^TComplexArray;
  TComplexArray = array of TComplex;

  TEnParam  = array[0..4] of double;
  TApaParam = array[0..2] of double;

  TDerivs = packed record
    x_l, x_p : double; // derivatives of x for lambda-phi
    y_l, y_p : double; // derivatives of y for lambda-phi */
  end;

  TFactors = packed record
    Der  : TDerivs;
    h, k,	        // meridinal, parallel scales
    omega,
    thetap,	        // angular distortion, theta prime
    conv,	        // convergence
    s,		        // areal scale factor
    a, b : double;	// max-min scale error
    code : byte;        // info as to analytics, see following
  end;

  TKRobinson = packed record
   c0 : double;
   c1 : double;
   c2 : double;
   c3 : double;
  end;

  TPJVector = packed record
   r  : double;
   Az : double;
  end;


type

 TRecChamberlin =  packed record

   P     : T3dPoint;
   cp,sp : double;
   Vec   : TPjVector;
   Az    : double;
   beta  : double;
 end;

 TParamChamberlin = packed record
  Base : T3dPoint;
  PT   : array[0..2] of TRecChamberlin;
 end;



 TProjParam  = packed record
  EN            : TEnParam;
  APA           : TApaParam;
  rho,rho0,
  A,B,C,D,G,
  Cx,Cy,Cp      : double;
  mode          : smallint;
 end;


 TOtherParam = packed record

  Guam          : byte;

  Cutted        : byte;

  Titled        : byte;

  Path,lsat     : byte;

  Zone,

  Rot,Offs,

  RotConv       : byte;

  Alpha,Gamma,

  Omega,Azimuth,

  H,theta,dQ    : double;

  Bo,dN,dM,dW   : double;

  Chamb         : TParamChamberlin; // from Chamberlin

  CsIntf        : IDispatch;

  CSConv        : IDispatch;

 end;



  PCustomProj = ^TCustomProj;

  TCustomProj = packed record
   NadName        : string;
   pName          : TProjTitle;
   errno          : integer;
   fForward       : function  (lp:T3dPoint; PJ:PCustomProj):T3dPoint;
   fInverse       : function  (xy:T3dPoint; PJ:PCustomProj):T3dPoint;
   fSpecial       : procedure (lp:T3dPoint; PJ:PCustomProj);
   Geoc           : byte;         // geocentric projection feature
   south          : byte;         // Hemisphere
   is_latlong     : byte;         // proj=latlong ... not really a projection at all */
   is_geocent     : byte;         // proj=geocent ... not really a projection at all */
   B1,B2,                         // parallels
   L1,L2,                         // meridians
   Bts,Lc         : double;       // ts parallel, prime meridian
   C0             : T3dPoint;     // coordinate system center
   x0,y0,                         // shift of the center of the CS X,Y in meters
   k0,                            // scaling factor
   to_meter       : double;       // conversion factor to meters
   from_greenwich : double;       // prime meridian offset (in radians)
   eType          : TEllpsType;
   Ellps          : TEllipsoidProperty;
   Fact           : TFactors;
   DP             : TDatum;        // Datum Params
   PM             : TProjParam;
   Other          : TOtherParam;
 end;



 TNumberQuad  = 1..4;

 TNumber200   = 1..36;
 TNumber100   = 1..144;

 TNomenLess100 = packed record
  case byte of
   50  : (Q50 : TNumberQuad);
   25  : (Q25_1, Q25_2 : TNumberQuad);
   10  : (Q10_1, Q10_2, Q10_3  : TNumberQuad);
   5   : (Q05 : byte);
 end;

 TNomenclature42 = packed record
   iScale  : cardinal;  // index scale
   IsSouth : boolean;   // southern hemisphere
   Row10   : byte;      // line number 10 km break
   Col10   : byte;      // column number 10 km breakdown
   case byte of
    5 : (n500 : TNumberQuad);
    2 : (n200 : TNumber200);
    1 : (n100 : TNumber100);
    0 : (q100 : byte; SubQuad : TNomenLess100)
 end;

 TQLongLat   = packed record
   B0, L0  : extended;
   B1, L1  : extended;
   Error   : boolean;
   IsSouth : byte;
   Scale   : cardinal;  // scale
 end;


 //              COMMON FUNCTION

  procedure ClearProjObject(var PJ : TCustomProj);

  //  object initialization - "PROJECTION" with parameters

  function  CreateProjObject(Ellipsoid:TEllpsType;Center:T3dPoint;uType:TUnitsType):TCustomProj;overload;
  // object initialization - "PROJECTION" with string parameters
  // in this presentation, the projection, converters and parameters are also initialized
  // if the string begins with characters proj - the parameters are decoded
  //  ----//---- ñ NAD: next should be projection index in NAD.txt file
  //  in path  NadPath
  function  CreateProjObject(const Value,NadPath: string):TCustomProj;overload;
  // initialization of the projection created by the function  ÑreateProjObject(Ellipsoid:...
  // all initial parameters must be initialized beforehand
  // if PjIndex is not set or projection <0 PJ.pName.pIndex
  // the function searches for the desired projection by the value of PJ.pName.Ident
  procedure InitSwichProjection(var PJ : TCustomProj;const PjIndex:integer = -1);

  // Direct (inverse) geodesic problems
  // AD - X-dist, Y-azimuth
  function TrueGeoTask(Ellps: TEllpsType;const P1: T3dPoint;Azimuth,Dist: double): T3dPoint;//overload;
  function ReversGeoTask(Ellps: TEllpsType;const P1,P2 : T3dPoint): T3dPoint;//overload;

  // converting geodetic coordinates to projection coordinates
  function  GeoToPlane(PJ:TCustomProj;BL:T3dPoint):T3dPoint;overload;
  function  GeoToPlane(PJ:TCustomProj;B,L:double):T3dPoint;overload;
  function  GeoToPlane(PJ:TCustomProj;BL:T3dArray):T3dArray;overload;

  // converting projection coordinates to geodetic coordinates
  function  PlaneToGeo(PJ:TCustomProj;pXY:T3dPoint):T3dPoint;overload;
  function  PlaneToGeo(PJ:TCustomProj;X,Y:double):T3dPoint;overload;
  function  PlaneToGeo(PJ:TCustomProj;XY:T3dArray):T3dArray;overload;
  // converting geodetic coordinates to Cartesian coordinates
  function  GeoToXYZ(gPnt:T3dPoint;Ellps:TEllipsoidProperty):T3dPoint; overload;
  function  GeoToXYZ(gPnt:T3dPoint;Ellps:TEllpsType): T3dPoint; overload;
  function  GeoToXYZ(gArr:T3dArray;Ellps:TEllpsType): T3dArray; overload;

  // ïconverting Cartesian coordinates to geodetic coordinates
  function XYZToGeo(mPnt:T3dPoint;Ellps:TEllipsoidProperty): T3dPoint; overload;
  function XYZToGeo(mPnt:T3dPoint;Ellps:TEllpsType): T3dPoint; overload;
  function XYZToGeo(mArr:T3dArray;Ellps:TEllpsType): T3dArray; overload;

  // mat.meridian angle at a given point
  function GetPolarAngle(PJ:TCustomProj;gPnt : T3dPoint):double;

  function DekartToGeo(Ellps: TEllpsType;gBase, mPoint: T3dPoint; RotCS: double): T3dPoint;
  function GeoToDekart(Ellps: TEllpsType;gBase, gPoint: T3dPoint; RotCS: double): T3dPoint;


  // transformation of geodetic coordinates from different coordinate systems
  function ConvertCoordinate(gPnt:T3dpoint;Src,Dest: TEllpsType;DP:TDatumParam):T3dPoint; overload;
  function ConvertCoordinate(gA:T3dArray;Src,Dest: TEllpsType;DP:TDatumParam):T3dArray; overload;

  function ConvertCoordinate(gPnt:T3dpoint;PJ:TCustomProj):T3dPoint; overload;
  function ConvertCoordinate(gA:T3dArray;  PJ:TCustomProj):T3dArray; overload;

  // de(en)cryption of values in radians into a string
  function DMS(const aValue : string) : double; overload;
  function DMS(aRadValue : double; Prec : byte; DegType: TDegType):string;overload;
  function DMS(aRadValue : double; IsLong: byte; const Prec : byte = 0) : string;overload;
  // normalization of coordinates according to the law of geodetic coordinates
  function adjlon(lon:double):double; overload;
  function adjlon(Value:double; Latitude : boolean):double; overload;

  //         PROJECTION INITED FUNCTION
  // initialization of individual projections
  procedure InitAEA(var PJ : TCustomProj;B1,B2 : double);
  procedure InitAeqd(var PJ : TCustomProj;IsGuam : byte);

  procedure InitAiry(var PJ : TCustomProj;Bb : double;const Cutted : byte = 0);
  procedure InitAitoff(var PJ : TCustomProj);
  procedure InitAugust(var PJ : TCustomProj);

  procedure InitBipc(var PJ : TCustomProj);
  procedure InitBoggs(var PJ : TCustomProj);
  procedure InitBonne90(var PJ : TCustomProj;B1:double);

  procedure InitCassini(var PJ : TCustomProj);
  procedure InitCC(var PJ : TCustomProj);
  procedure InitChamberlin(var PJ : TCustomProj;P0,P1,P2:T3dPoint);
  procedure InitCollignon(var PJ : TCustomProj);
  procedure InitCraster(var PJ : TCustomProj);

  procedure InitDenoy(var PJ : TCustomProj);

  procedure InitEAC(var PJ : TCustomProj; Bts:double);
  procedure InitEDC(var PJ : TCustomProj; B1,B2:double);

  procedure InitEQC(var PJ : TCustomProj; Bts:double);

  procedure InitFahey(var PJ : TCustomProj);
  procedure InitFoucautSin(var PJ : TCustomProj;dN:double);

  procedure InitHatano(var PJ : TCustomProj);
  procedure InitHammer(var PJ : TCustomProj; dW,dM : double);

  procedure InitIMWPolyconic(var PJ : TCustomProj;B1,B2,L1:double);

  procedure InitGall(var PJ : TCustomProj);
  procedure InitGinsburg(var PJ : TCustomProj);
  procedure InitGnomonic(var PJ : TCustomProj);
  procedure InitGeoCentric(var PJ : TCustomProj);
  procedure InitGlobular(var PJ : TCustomProj; pMode : byte);
  procedure InitGnSinu(var PJ : TCustomProj; dN,dM : double);

  procedure InitSinu(var PJ : TCustomProj);
  procedure InitEckert(var PJ : TCustomProj;PjNo : TEckMode);
  procedure InitGaussKruger(var PJ:TCustomProj);
  procedure InitPZ90(var PJ : TCustomProj);
  procedure InitCK95(var PJ : TCustomProj);

  procedure InitGoode(var PJ : TCustomProj);
  procedure InitFoucaut(var PJ : TCustomProj);

  procedure InitQuarticAuth(var PJ : TCustomProj);
  procedure InitKav5(var PJ : TCustomProj);

  procedure InitKav7(var PJ : TCustomProj);
  procedure InitKrovak(var PJ : TCustomProj;Bts : double);

  procedure InitLaborde(var PJ : TCustomProj;Azimuth:double);
  procedure InitLarrivee(var PJ : TCustomProj);
  procedure InitLask(var PJ : TCustomProj);
  procedure InitLoximuthal(var PJ : TCustomProj;B1:double);
  procedure InitLatLong(var PJ : TCustomProj);
  procedure InitLEAC(var PJ : TCustomProj;B1 : double);
  procedure InitLCC(var PJ : TCustomProj; B1,B2 : double);
  procedure InitLCCA(var PJ : TCustomProj);
  procedure InitLAEA(var PJ:TCustomProj);
  procedure InitLagrange(var PJ : TCustomProj; B1,dW : double);

  procedure InitMoll(var PJ : TCustomProj; const B1 : double);
  procedure InitMPoly(var PJ : TCustomProj);
  procedure InitMillerCyl(var PJ : TCustomProj);

  procedure InitMcSin1(var PJ : TCustomProj);
  procedure InitMcSin2(var PJ : TCustomProj);
  procedure InitMcParabolic(var PJ : TCustomProj);
  procedure InitMcQuartic(var PJ : TCustomProj);
  procedure InitMcSinusoidal(var PJ : TCustomProj);


  procedure InitMercator(var PJ:TCustomProj; Bts: double);
  procedure InitTransMercator(var PJ:TCustomProj; Bts: double);
  procedure InitNicol(var PJ : TCustomProj);
  procedure InitNell(var PJ : TCustomProj);
  procedure InitNellHammer(var PJ : TCustomProj);
  procedure InitNewZeland(var PJ : TCustomProj);

  procedure InitOCEA(var PJ : TCustomProj; Alpha,Bc:double);overload;
  procedure InitOCEA(var PJ : TCustomProj; B1,B2,L1,L2:double);overload;
  procedure InitOrthoGraphic(var PJ : TCustomProj);
  procedure InitOEA(var PJ : TCustomProj;dN,dM : double; const theta :double = 1/0);

  procedure InitOMercator(var PJ : TCustomProj;B1,B2,L1,L2:double;Rotate,Offset,RotConv:byte);overload;
  procedure InitOMercator(var PJ : TCustomProj;Alpha,Lc:double;Rotate,Offset,RotConv:byte);overload;

  procedure InitPerspective(var PJ : TCustomProj;H,Gamma,Omega:double; Titled : boolean);
  procedure InitPutp(var PJ : TCustomProj; PutpType : TPutpType);
  procedure InitPolyAmerican(var PJ : TCustomProj);

  procedure InitRobinson(var PJ : TCustomProj);
  procedure InitRPoly(var PJ : TCustomProj; Bts:double);
  procedure InitInterStereo(var PJ:TCustomProj; Bts:double);
  procedure InitStereographic(var PJ:TCustomProj;Bts:double);
  procedure InitSWMercator(var PJ : TCustomProj);
  procedure InitSOLandsat(var PJ : TCustomProj;Lsat,Path : byte);
  procedure InitSts(var PJ:TCustomProj;dP,dQ:double;TanMode : byte);
  procedure InitSpecStereo(var PJ:TCustomProj;pType: byte);
  procedure InitTissot(var PJ:TCustomProj;B1,B2: double);
  procedure InitMurdoch(var PJ:TCustomProj;prNo: TMurdochMode; B1,B2: double);
  procedure InitEuler(var PJ:TCustomProj;B1,B2: double);
  procedure InitPerspConic(var PJ:TCustomProj;B1,B2: double);
  procedure InitVitkovsky(var PJ:TCustomProj;B1,B2: double);

  procedure InitTwoPointED(var PJ : TCustomProj; b1,b2,l1,l2:double);
  procedure InitTransCC(var PJ : TCustomProj);
  procedure InitTransCEA(var PJ : TCustomProj);

  procedure InitUTM(var PJ:TCustomProj;uZone:byte);
  procedure InitUrmfps(var PJ : TCustomProj; dN:double);
  procedure InitUrm5(var PJ : TCustomProj;Alpha,dN,dQ:double);

  procedure InitVandGriten(var PJ : TCustomProj;vType : TVandNumb);

  procedure InitWink2(var PJ : TCustomProj; B1:double);
  procedure InitWink1(var PJ : TCustomProj; Bts:double);
  procedure InitWinkTripel(var PJ : TCustomProj;B1 : double);
  procedure InitWeren(var PJ : TCustomProj);
  procedure InitWagner(var PJ : TCustomProj; wType : TWagnerMode;Bts:double);

  // get error text
  function GetErrorString(PJ:TCustomProj):string;

  // ============ additional procedures  ===============
  // by point in radians, determine the nomenclature sheet of the specified scale in CK42
  procedure PointToNomenclature42(PointRad: T3dPoint; Scale : cardinal; var Value:TNomenclature42); overload;
  function PointToNomenclature42(PointRad: T3dPoint; Scale : cardinal): string; overload;
  // by the nomenclature determine the frame CK42
  function NomenclatureToRect42(const Quad : string; const ResultType : TCoordType = ctDMS): TQLongLat;


implementation
uses Math, Classes,SysUtils;

type
 TNadRecord  = packed record
  Index    : integer;

  FullName : string;

  Param    : string;

end;


const
  IS_ANAL_XL_YL = $01;	// derivatives of lon analytic *
  IS_ANAL_XP_YP = $02;	// derivatives of lat analytic
  IS_ANAL_HK	= $04;	// h and k analytic
  IS_ANAL_CONV  = $10;	// convergence analytic


const
 ONE_TOL  = 1.00000000000001;
 TOL      = 1.0e-10;
 ATOL     = 1e-50;
 SPI      = 3.14159265359;
 TWOPI    = PI*2;
 HALFPI   = 1.5707963267948966;
 FORTPI   = 0.78539816339744833;
 N_ITER   = 15;
 EPS      = 1e-11;
 MAX_ITER = 10;
 EPSILON  = 1.0e-7;
 // projection constants (stereographic)
 const
   // Miller Oblated Stereographic
  CmpMiller : array [0..2] of TComplex =
   ((r:0.924500;i:0),(r:0;i:0),(r:0.019430;i:0));
  // Lee Oblated Stereographic
  CmpLeeOS : array [0..2] of TComplex =
   ((r:0.721316;i:0),(r:0.;i:0),(r:-0.0088162;i:-0.00617325));

  Cmp48USA : array [0..4] of TComplex =
  ((r:0.98879;i:0),(r:0;i:0),(r:-0.050909;i:0),
   (r:0.0;i:0),(r:0.075528;i:0));

  CmpEllpsAlaska : array [0..5] of TComplex =
  ((r:0.9945303;i:0),(r:0.0052083;i:-0.0027404),
   (r:0.0072721;i:0.0048181),(r:-0.0151089;i:-0.1932526),
   (r:0.0642675;i:-0.1381226),(r:0.3582802;i:-0.2884586));

  CmpSphAlaska : array [0..5] of TComplex =
  ((r:0.9972523;i:0.0),(r:0.0052513;i:-0.0041175),
   (r:0.0074606;i:0.0048125),(r:-0.0153783;i:-0.1968253),
   (r:0.0636871;i:-0.1408027),(r:0.3660976;i:-0.2937382));

  CmpEllpsGS50 : array [0..9] of TComplex =
	((r:0.9827497;i:0.0),
	(r:0.0210669;i:0.0053804),
	(r:-0.1031415;i:-0.0571664),
	(r:-0.0323337;i:-0.0322847),
	(r:0.0502303;i:0.1211983),
	(r:0.0251805;i:0.0895678),
	(r:-0.0012315;i:-0.1416121),
	(r:0.0072202;i:-0.1317091),
	(r:-0.0194029;i:0.0759677),
        (r:-0.0210072;i:0.0834037));

  CmpShpGS50 : array[0..9] of TComplex=
	((r:0.9842990;i:0.0),
	(r:0.0211642;i:0.0037608),
	(r:-0.1036018;i:-0.0575102),
	(r:-0.0329095;i:-0.0320119),
	(r:0.0499471;i:0.1223335),
	(r:0.0260460;i:0.0899805),
	(r:0.0007388;i:-0.1435792),
	(r:0.0075848;i:-0.1334108),
	(r:-0.0216473;i:0.0776645),
        (r:-0.0225161;i:0.0853673));


 // for New Zeland projection

  CmpNZ : array[0..5] of TComplex=

	((r:0.7557853228;i:0.0),
	(r:0.249204646;i:0.003371507),
	(r:-0.001541739;i:0.041058560),
	(r:-0.10162907;i:0.01727609),
	(r:-0.26623489;i:-0.36249218),
	(r:-0.6870983;i:-1.1651967));

 nzTPhi : array[0..8] of double = (1.5627014243,0.5185406398,-0.03333098,
 -0.1052906,-0.0368594, 0.007317, 0.01220, 0.00394, -0.0013);

 nzTPsi : array[0..9] of double = (0.6399175073,-0.1358797613,0.063294409,
 -0.02526853, 0.0117879,-0.0055161, 0.0026906, -0.001333, 0.00067, -0.00034);


  //  for Robinson projection

  XRobin : array[0..18] of TKRobinson =(

        (c0:1;      c1:-5.67239e-12; c2:-0.0000715511; c3:0.00000311028),

        (c0:0.9986; c1:-0.000482241; c2:-0.000024897; c3:-0.00000133094),
        (c0:0.9954; c1:-0.000831031; c2:-0.000044861; c3:-0.000000986588),
        (c0:0.99; c1:-0.00135363; c2:-0.0000596598; c3:0.00000367749),
        (c0:0.9822; c1:-0.00167442; c2:-0.0000044975; c3:-0.00000572394),
        (c0:0.973; c1:-0.00214869; c2:-0.0000903565; c3:0.0000000188767),
        (c0:0.96; c1:-0.00305084; c2:-0.0000900732; c3:0.00000164869),
        (c0:0.9427; c1:-0.00382792; c2:-0.0000653428; c3:-0.00000261493),
        (c0:0.9216; c1:-0.00467747; c2:-0.000104566; c3:0.0000048122),
        (c0:0.8962; c1:-0.00536222; c2:-0.0000323834; c3:-0.00000543445),
        (c0:0.8679; c1:-0.00609364; c2:-0.0001139; c3:0.00000332521),
        (c0:0.835; c1:-0.00698325; c2:-0.0000640219; c3:0.000000934582),
        (c0:0.7986; c1:-0.00755337; c2:-0.0000500038; c3:0.000000935532),
        (c0:0.7597; c1:-0.00798325; c2:-0.0000359716; c3:-0.00000227604),
        (c0:0.7186; c1:-0.00851366; c2:-0.000070112; c3:-0.00000863072),
        (c0:0.6732; c1:-0.00986209; c2:-0.000199572; c3:0.0000191978),
        (c0:0.6213; c1:-0.010418; c2:0.0000883948; c3:0.00000624031),
        (c0:0.5722; c1:-0.00906601; c2:0.000181999; c3:0.00000624033),
        (c0:0.5322; c1:0; c2:0; c3:0));
  YRobin : array[0..18] of TKRobinson =(
        (c0:0; c1:0.0124; c2:3.72529E-10; c3:1.15484e-09),
        (c0:0.062; c1:0.0124001; c2:0.0000000176951; c3:-0.00000000592321),
        (c0:0.124; c1:0.0123998; c2:-0.0000000709668; c3:0.0000000225753),
        (c0:0.186; c1:0.0124008; c2:0.000000266917; c3:-0.0000000844523),
        (c0:0.248; c1:0.0123971; c2:-0.000000999682; c3:0.000000315569),
        (c0:0.31; c1:0.0124108; c2:0.00000373349; c3:-0.0000011779),
        (c0:0.372; c1:0.0123598; c2:-0.000013935; c3:0.00000439588),
        (c0:0.434; c1:0.0125501; c2:0.0000520034; c3:-0.0000100051),
        (c0:0.4968; c1:0.0123198; c2:-0.0000980735; c3:0.00000922397),
        (c0:0.5571; c1:0.0120308; c2:0.0000402857; c3:-0.0000052901),
        (c0:0.6176; c1:0.0120369; c2:-0.0000390662; c3:0.000000736117),
        (c0:0.6769; c1:0.0117015; c2:-0.0000280246; c3:-0.000000854283),
        (c0:0.7346; c1:0.0113572; c2:-0.0000408389; c3:-0.000000518524),
        (c0:0.7903; c1:0.0109099; c2:-0.0000486169; c3:-0.0000010718),
        (c0:0.8435; c1:0.0103433; c2:-0.0000646934; c3:0.00000000536384),
        (c0:0.8936; c1:0.00969679; c2:-0.0000646129; c3:-0.00000854894),
        (c0:0.9394; c1:0.00840949; c2:-0.000192847; c3:-0.00000421023),
        (c0:0.9761; c1:0.00616525; c2:-0.000256001; c3:-0.00000421021),
        (c0:1; c1:0; c2:0; c3:0));



const

 AcDiv = 57.295779513082320876798154814105;

 ErrorList : array[1..44] of string =
(
	'not enough arguments to initialize',	//  -1 */
	'no options found in "init" file',		//  -2 */
	'no colon in init= string',			//  -3 */
	'nameless projection',				//  -4 */
	'unidentified projection',			        //  -5 */
	'eccentricity equal to one' ,	        //  -6 */
	'unknown unit conversion id',			//  -7 */
	'invalid boolean param argument',		//  -8 */
	'unidentified ellipsoid parameter',	        //  -9 */
	'ellipsoid squeeze is zero',		        // -10 */
	'|radius reference latitude| > 90',		// -11 */
	'the square of the eccentricity is zero',	        // -12 */
	'radius or semi-minor axis zero',	        // -13 */
	'latitude or longitude exceeded limits',	// -14 */
	'X or Y offset error',			// -15 */
	'improperly formed DMS value',			// -16 */
	'non-convergent inverse meridinal dist',	// -17 */
	'non-convergent inverse phi2',			// -18 */
	'acos/asin: |arg|>1.+1e-14',			// -19 */
	'condition error',			        // -20 */
	'mirror parallel conic projection',	// -21 */
	'base latitude greater than or equal to 90°',		// -22 */
	'base latitude is 0°',			// -23 */
	'reference latitude greater than or equal to 90°',		// -24 */
	'some breakpoints are the same',	// -25 */
	'projection not selected to be rotated',	// -26 */
	'parameters W, M are less than or equal to zero',		// -27 */
	'lsat parameter out of limit 1..5',		// -28 */
	'path is out of range',		// -29 */
	'parameter h <= 0',				// -30 */
	'parameter k <= 0',				// -31 */
	'reference latitude = 0 or 90° or alpha=90°',	// -32 */
	'reference latitudes are equal, or equal to 0 or 90°',	// -33 */
	'the projection is used only on ellipsoid',	// -34 */
	'zone number error',		                // -35 */
	'arg(s) out of range for Tcheby eval',		// -36 */
	'failed to find projection to be rotated',	// -37 */
	'failed to load NAD27-83 correction file',  	// -38 */
	'both n & m must be spec d and > 0',		// -39 */
	'n <= 0, n > 1 or not specified',		// -40 */
	'don from base latitudes is not indicated',		// -41 */
	'constant parallels are equal',			// -42 */
	'lat_0 is pi/2 from mean lat',			// -43 */
	'the coordinate system is undefined' 	        // -44 //
);


function GetErrorString(PJ:TCustomProj):string;
begin
 if Abs(pj.errno)-1 in [0..LenGth(ErrorList)-1]  then
 result:=ErrorList[abs(pj.errno)] else result:='';
end;

 procedure ClearProjObject(var PJ : TCustomProj);
 begin
  with PJ do
  begin
   Finalize(NadName);
   Finalize(pName);
   fForward:=nil; fInverse:=nil; fSpecial:=nil;
   is_latlong:=0; is_geocent:=0;
   B1:=0; B2:=0; L1:=0;  L2:=0;
   Bts:=0;Lc:=0;
   x0:=0; y0:=0; k0:=1; geoc:=0;
   from_greenwich:=0;
   FillChar(Ellps,SizeOf(TEllipsoidProperty),0);
   FillChar(Fact,SizeOf(TFactors),0);
   FillChar(PM,SizeOf(PM),0);
   Other.CsIntf:=nil;
  end;
 end;

 function  CreateProjObject(Ellipsoid : TEllpsType;Center : T3dPoint;uType : TUnitsType): TCustomProj;
 begin
   ClearProjObject(result);
   result.c0:=Center;
   result.Ellps:=Ellipsoids[Ellipsoid];
   result.to_meter :=cPlainUnits[uType];
   result.eType:=Ellipsoid;
 end;

 //* reduce argument to range +/- PI *//
function adjlon(lon:double):double;
begin
 if IsInfinite(lon) then exit;
 result:=lon;
 while Abs(result)>pi do
 case byte(result>0) of
  1: result:=-(2*pi-result);
  0: result:=result+2*pi;
 end;
end;

function adjlon(Value:double; Latitude : boolean):double;
var limit : double;
begin
 if IsInfinite(Value) then exit;
 result:=Value;
 case Latitude of
  true : limit:=pi;
  false: limit:=2*pi;
 end;
 while Abs(result)>limit/2 do
 case byte(result>0) of
  1: if Latitude then result:=limit-result else
     result:=-(limit-result);
  0: result:=result+limit;
 end;
end;

function aatan2(n,d: double) :double;
begin
 result:=0;
 if (abs(n)<ATOL) and (abs(d)<ATOL) then exit;
 result:=Arctan2(n,d);
end;


function asqrt(v : double) :double;
begin
 result:=0;
 if (v<=0) then exit;
 result:=sqrt(V);
end;


function aasin(v : double) : double;
begin
 Result:=0;
 if abs(v)>ONE_TOL then exit;
 Result := ArcTan2(V, Sqrt(1 - V*V))
end;

function aacos(v : double) :double;
begin
 result:=0;
 if abs(v)>ONE_TOL then exit;
 Result := ArcTan2(Sqrt(1 - V*V), V);
end;




// DIRECT AND INVERSE PROBLEMS
// "external" variables filled with the CalcDelta function (see below)
// for analysis in the inverse geodesic problem

function _CalcDelta(Ellps: TEllipsoidProperty;P1:T3dpoint;Dist,Azim:extended;IsCalcK:boolean;var P0: T3dPoint) : T3dPoint;
var  T2, N2, U2, v2, nu,_v, _u, L,
     v_c, vc2, vc3, t4,
     V, cosp1,  t    : extended;
     FCTask : extended;
begin
 FCTask:=sqrt(Ellps.one_es)/Ellps.a;
 t:=tan(P1.X); t2:=sqr(t); t4:=sqr(t2);
 nu:=sqrt(Ellps.es/Ellps.one_es)*cos(P1.X);
 N2:=nu*nu;
 _v:=Dist*sin(Azim); v2:=sqr(_v);
 _u:=Dist*cos(Azim); U2:=sqr(_u);
 cosp1:=1/cos(P1.X);
 V:=sqrt(1+N2);
 v_c:=V*FCTask; vc2:=sqr(v_c); vc3:=power(v_c,3);
 // "external" variables for analysis in an inverse geodetic problem
 // b1
 P0.B := v_c*(1+N2);
 // l1
 P0.L :=v_c*cosp1;
 if iscalcK then exit;

 //L5
 L:=-P0.L*vc3*t*(1+3*t2+N2)/3;
 //dB
 result.X:=_u-0.5*FCTask*(V*sqr(_v)*t+(1+N2)*U2*N2*FCTask *(3*t/FCTask-t2*_u+_u))+
 FCTask*FCTask/6*((1+N2)*v2*(1+3*T2+N2-9*N2*T2)*(0.25*(1+N2)*t*v2*FCTask-_u)+
   P0.B*t*U2*3*(N2*U2*FCTask-(4-13*N2+3*T2*(2-3*N2))*_v/6) +
   P0.B*V*v2*_u*((1+15*t2*(2+3*t2)) *v2/4 - (2+15*t2*(1+t2))*U2)*FCTask/5);
  result.X:= result.X*P0.B+L*N2;
 // dL
 result.Y:=_v*(1+v_c*t*_u)+vc2*((1+3*t2+N2)*U2*_v-t2*V2*_v+v_c*t*(2+3*t2+N2)*U2*_u*_v+
  0.2*vc2*_v*(t2*(1+3*t2)*V2*V2+(2+15*t2+15*t2*t2) *U2*U2-(1+20*t2+30*t2*t2)*V2*U2))/3;
 result.Y:=result.Y*P0.L+L*(V2*_v*_u+N2);
 // dA
 result.Z:=v_c*_v*(t+ 0.5*v_c*(1+2*t2+N2)*_u)+
  vc3*t*((5+6*t2+N2-4*N2*N2) *U2*_v -(1+2*t2+N2)*V2*_v +
   v_c *((1.25+7*t2+6*t4+1.5*N2+2*N2*T2) *U2*_u*_v - (0.25+5*t2+6*t4+0.5*N2+2*N2*T2)*(V2*_v*_u+N2)) +
   vc2*t*((1+20*t2+24*t4)*V2*V2*_v -(58+280*t2+240*t4) *V2*_v*U2 +(61+180*t2+120*t4) *_v*U2*U2)/20)/6;
end;



 // DIRECT PROBLEM
function TrueGeoTask(Ellps: TEllpsType;const P1: T3dPoint; Azimuth,Dist: double): T3dPoint;
var  P0,D : T3dpoint;
     E    : TEllipsoidProperty;
begin
  result:=P1;
 // if the distance is more than half the Earth's equivalent
  if IsNan(Dist) or (Dist>2e7) or (Azimuth>1e2) then exit;
  E:=Ellipsoids[Ellps];
  D:=_CalcDelta(E,P1,Dist,Azimuth,false,P0);
  if cos(P1.X)=0 then D.Y:=Azimuth;
  result:=Set3dPoint(adjlon(P1.X+D.X,true),p1.Y*Byte(cos(P1.X)<>0)+D.Y,0);
  if abs(P1.X+D.X)>PI/2 then result.L:=result.L+pi;
  result.L:=adjlon(result.L);
end;

// INVERSE PROBLEM
// X - dist  Y-A12  z-A21
function ReversGeoTask(Ellps: TEllpsType;const P1,P2 : T3dPoint): t3dPoint;
var DeltaL,DeltaB,MinB,
    MinL,aLen,dA12 : double;
    D,D0,D1,P0 : T3dPoint;
    Delta : T3dPoint;
    E : TEllipsoidProperty;
    I : byte;
begin
 E:=Ellipsoids[Ellps];
 D0.X:=P2.X-P1.X;
 D0.Y:=P2.Y-P1.Y;
 MinL:=MaxDouble;
 MinB:=MinL;
 D.X:=D0.X; D.Y:=D0.Y;
 result.Y:=0;
 i:=0; P0:=Set3dPoint(0,0,0);
 dA12:=0; aLen:=0;
 while i<254 do
 begin
   _CalcDelta(E,P1, aLen, dA12, true,P0);
   if D.X=0 then D.X:=D.X+1e-10;
   dA12:=Arctan(P0.b*D.Y/(P0.l*D.X));
   if cos(dA12)=0 then break;
   aLen:=Abs(D.X/(P0.b*cos(dA12)));
   inc(i);
   D1:=_CalcDelta(E,P1, aLen, dA12,false,P0);
   DeltaB:=Abs(D1.X-D0.X);
   DeltaL:=Abs(D1.Y-D0.Y);
  if (DeltaB<MinB) and (DeltaL<MinL) then
  begin
   MinB:=DeltaB;
   MinL:=DeltaL;
   result.X:=aLen;
   result.Y:=dA12;
  end;
  D.X:=D.X+0.5*DeltaB*(1-2*byte(D.X<D1.X));
  D.Y:=D.Y+0.5*DeltaL*(1-2*byte(D.Y<D1.Y));
  if Abs(D.X)>Abs(5*D0.X) then Break;
 end;
 if result.X<0 then result.Y:=-result.Y;
 result.X:=Abs(result.X);
 if d0.x<=0 then result.y:=pi-result.y;
 if (d0.x>0) and (result.y<0) then  result.y:=2*pi+result.y;
end;


function GetPolarAngle(PJ:TCustomProj;gPnt : T3dPoint):double;
var Polar,P0 : T3dPoint;
begin
  Polar := GeoToPlane(PJ,gPnt.X+pi/180,gPnt.Y);
  P0    := GeoToPlane(PJ,gPnt.X,gPnt.Y);
  result:= GetAngle(P0,Polar)-pi/2;
end;

function DekartToGeo(Ellps: TEllpsType;gBase, mPoint: T3dPoint; RotCS: double): T3dPoint;
begin
  result:=gBase;
  if ((mPoint.X=0) and (mPoint.x=mPoint.Y)) or (mPoint.x>1E5) or (mPoint.Y>1E5) then exit;
  result:=TrueGeoTask(Ellps,gBase,RotCS,mPoint.X);
  if mPoint.Y>0 then result:=TrueGeoTask(Ellps,result, RotCS+3*pi/2, mPoint.Y) else
  if mPoint.Y<0 then result:=TrueGeoTask(Ellps,result, RotCS+pi/2, Abs(mPoint.Y));
end;

function GeoToDekart(Ellps: TEllpsType;gBase, gPoint: T3dPoint; RotCS: double): T3dPoint;
var D : double;
begin
  result:=ReversGeoTask(Ellps,gbase,gPoint); D:= result.X;
  result:=Set3dPoint(D*cos(RotCS-result.Y),D*sin(RotCS-result.Y));
end;




  // CK42 => WGS84  +28.0 -130.0 -95.0
  // WGS84 => CK42  -28.0 130.0   95.0
  // WORKS !!!!

function Convert3Param(gP:T3dpoint;Src,Dest: TEllipsoidProperty;DP:TDatumParam):T3dPoint;
var P, v  : double;
    dX    : double;
begin
  result:=gP; if Length(DP)<>3 then exit;
  P:=sqrt(sqr(Src.a*cos(gp.B))+sqr(Src.b*sin(gp.B))); // P
  v:=Src.a/sqr(1-Src.es*sqr(sin(gp.B)));              // v
  dX:=(Src.a*(Dest.rf-Src.rf)+Src.rf*(Dest.a-Src.a));       // [adf+fda]
  result.phi:=gP.phi+(-DP[0]*sin(gP.phi)*cos(gP.lam)-DP[1]*sin(gP.phi)*sin(gP.lam)+
  DP[2]*cos(gP.phi)+dX*sin(2*gP.phi))/P;
  if Abs(cos(gP.phi))<1E-5 then result.lam:=0 else
  result.lam:=gP.lam+(-DP[0]*sin(gP.lam)+DP[1]*cos(gP.lam))/(v*cos(gP.phi));
  result.H:=result.H+DP[0]*cos(gP.phi)*cos(gP.lam)+DP[1]*cos(gP.phi)*sin(gP.lam)+
  DP[2]*sin(gP.phi)+dX*sqr(sin(gP.phi))-(Dest.a-Src.a);
  if (Abs((Abs(result.B)-pi/2))<1E-8) and (result.L>100) then result.L:=0;
  result:=Set3dPoint(adjlon(result.B,true), adjlon(result.L,false),result.h);
end;



  // WORKS !!!!
function Convert7Param(gPnt:T3dPoint;S,D:TEllipsoidProperty; DP:TDatumParam):T3dPoint;
var MT1        : array[0..2,0..8] of double;
    Wr         : T3dPoint;
    M,N,cx,cy,
    sx,sy,
    de2,dA,eEq : double;
begin
 N:=S.a*Power(1-S.es*sqr(sin(gPnt.X)),-0.5);
 M:=S.a*(1-S.es)*Power(1-S.es*sqr(sin(gPnt.X)),-1.5);
 eEq:=0.5*(D.es+S.es);
 FillChar(MT1[0,0], SizeOf(MT1),0);

 cx:=cos(gPnt.B); sx:=sin(gPnt.B);
 cy:=cos(gPnt.L); sy:=sin(gPnt.L);
 dA:=1+eEq*cos(2*gPnt.X);
 Wr.X:=M+gPnt.Z;
  // ROW1
 MT1[0,0]:=N*eEq*sx*cx/D.a;  MT1[0,1]:=0.5*N*(sqr(N/D.a)+1)*sx*cx;
 MT1[0,2]:=-cy*sx;           MT1[0,3]:=-sy*sx;      MT1[0,4]:=cx;
 MT1[0,5]:=-Wr.X*dA*sy;      MT1[0,6]:= Wr.X*dA*cy; MT1[0,8]:=-Wr.X*eEq*sx*cx;
  // ROW2
 Wr.Y:=cx*tan(gPnt.X)*(1-eEq);
 Wr.X:=N+gPnt.Z;
 MT1[1,2]:=-sy;              MT1[1,3]:=cy;          MT1[1,5]:= Wr.X*Wr.Y*cy;
 MT1[1,6]:= Wr.X*Wr.Y*sy;    MT1[1,7]:=-Wr.X*cx;
  // ROW3
 MT1[2,0]:=-D.a/N;           MT1[2,1]:=N*sx*sx/2;   MT1[2,2]:=cy*cx;
 MT1[2,3]:=sy*cx;            MT1[2,4]:=sx;          MT1[2,5]:=-N*eEq*sx*cx*sy;
 MT1[2,6]:= N*eEq*sx*cx*cy;  MT1[2,8]:=sqr(S.a)/N+gPnt.Z;
 Wr:=Set3dPoint(DP[3]/206264.806247097,DP[4]/206264.806247097,DP[5]/206264.806247097);
 dA:=(D.a-S.a);  de2:=D.es-S.es;
 result.X:=gPnt.X+(MT1[0,0]*dA+MT1[0,1]*de2+MT1[0,2]*DP[0]+MT1[0,3]*DP[1]+MT1[0,4]*DP[2]+
         MT1[0,5]*Wr.x+MT1[0,6]*Wr.y+MT1[0,7]*Wr.z+MT1[0,8]*DP[6]*1E-6)/(M+gPnt.Z);
 result.Y:=gPnt.Y+(MT1[1,0]*dA+MT1[1,1]*de2+MT1[1,2]*DP[0]+MT1[1,3]*DP[1]+MT1[1,4]*DP[2]+
         MT1[1,5]*Wr.x+MT1[1,6]*Wr.y+MT1[1,7]*Wr.z+MT1[1,8]*DP[6]*1E-6)/((N+gPnt.Z)*cx);
 result.Z:=gPnt.Z+(MT1[2,0]*dA+MT1[2,1]*de2+MT1[2,2]*DP[0]+MT1[2,3]*DP[1]+MT1[2,4]*DP[2]+
        MT1[2,5]*Wr.x+MT1[2,6]*Wr.y+MT1[2,7]*Wr.z+MT1[2,8]*DP[6]*1E-6) ;
 if (Abs((Abs(result.B)-pi/2))<1E-8) or (Abs(result.L)>100) then result.L:=0;
 result:=Set3dPoint(adjlon(result.B,true), adjlon(result.L,false),result.h);
end;

function ConvertCoordinate(gPnt:T3dpoint;Src,Dest: TEllpsType;DP:TDatumParam):T3dPoint;
begin
  result:=gPnt;
  if (Src=ellNone) or (Dest=ellNone) or (Abs(Abs(gPnt.X)-pi/2)<1E-5) then exit;
  case LenGth(DP) of
   0: begin
       result:=GeoToXYZ(gPnt,Src);
       result:=XYZToGeo(result,Dest);
      end;
   3: result:=Convert3Param(gPnt,Ellipsoids[Src],Ellipsoids[Dest],DP);
   7: result:=Convert7Param(gPnt,Ellipsoids[Src],Ellipsoids[Dest],DP);
  end;
end;

function ConvertCoordinate(gPnt:T3dpoint;PJ:TCustomProj):T3dPoint;
begin
  result:=gPnt;
  with PJ do
  if (eType<>ellNone) and (DP.eDest<>ellNone) or (Abs(Abs(gPnt.X)-pi/2)<1E-5) then
  case LenGth(DP.Value) of
   0: begin
       result:=GeoToXYZ(gPnt,eType);
       result:=XYZToGeo(result,DP.eDest);
      end;
   3: result:=Convert3Param(gPnt,Ellipsoids[eType],Ellipsoids[DP.eDest],DP.Value);
   7: result:=Convert7Param(gPnt,Ellipsoids[eType],Ellipsoids[DP.eDest],DP.Value);
  end;
end;

function ConvertCoordinate(gA:T3dArray;Src,Dest: TEllpsType;DP:TDatumParam):T3dArray;
var i : integer;
begin
  Finalize(result);
  if (Src=ellNone) or (Dest=ellNone) then exit;
  SetLenGth(result, LenGth(gA));
  case LenGth(DP) of
   0: for i:=0 to LenGth(gA)-1 do
      begin
       result[i]:=GeoToXYZ(gA[i],Src);
       result[i]:=XYZToGeo(result[i],Dest);
      end;
   3: for i:=0 to LenGth(gA)-1 do
      result[i]:=Convert3Param(gA[i],Ellipsoids[Src],Ellipsoids[Dest],DP);
   7: for i:=0 to LenGth(gA)-1 do
      result[i]:=Convert7Param(gA[i],Ellipsoids[Src],Ellipsoids[Dest],DP);
  end;
end;

function ConvertCoordinate(gA:T3dArray;PJ:TCustomProj):T3dArray;
var i : integer;
begin
  Finalize(result);
  if (PJ.eType=ellNone) or (PJ.DP.eDest=ellNone) then exit;
  SetLenGth(result, LenGth(gA));
  with PJ do
  case LenGth(DP.Value) of
   0: for i:=0 to LenGth(gA)-1 do
       begin
       result[i]:=GeoToXYZ(gA[i],eType);
       result[i]:=XYZToGeo(result[i],DP.eDest);
      end;
   3: for i:=0 to LenGth(gA)-1 do
      result[i]:=Convert3Param(gA[i],Ellipsoids[eType],Ellipsoids[DP.eDest],DP.Value);
   7: for i:=0 to LenGth(gA)-1 do
      result[i]:=Convert7Param(gA[i],Ellipsoids[eType],Ellipsoids[DP.eDest],DP.Value);
  end;
end;


 function  GeoToPlane(PJ:TCustomProj;BL:T3dPoint):T3dPoint;
 var  LP   : T3dPoint;
 begin
  if not Assigned(PJ.fForward) then exit;
  result := InfPoint;
  pj.errno:=-byte(not Assigned(PJ.fForward) or IsInfinite(BL.X) or IsInfinite(BL.Y));
  if (pj.errno<>0) then exit;
  // check for forward and latitude or longitude overange */
  Lp:=Set3dPoint(adjlon(BL.B,true),adjlon(BL.L,false)-PJ.C0.lam);
 // if (abs(abs(lp.phi)-HALFPI)<= 1e-5) then lp.phi :=HALFPI*(1-2*byte(lp.phi<0)) else
  if PJ.geoc=1 then lp.phi := arctan(PJ.Ellps.rone_es*tan(lp.phi));
  result := PJ.fForward(lp,@PJ); // project
  if (pj.errno=0) and not IsInfinite(result.lam) then	// adjust for major axis and easting/northings
  begin
   result.x := (PJ.Ellps.a*result.x+PJ.x0)/PJ.to_meter;
   result.y := (PJ.Ellps.a*result.y+PJ.y0)/PJ.to_meter;
   result.z := BL.Z;
  end else
  result := InfPoint;
 end;

 function  GeoToPlane(PJ:TCustomProj;B,L:double):T3dPoint;
 begin
  result:=GeoToPlane(PJ,Set3dPoint(B,L));
 end;

 function  GeoToPlane(PJ:TCustomProj;BL:T3dArray):T3dArray;
 var i     : integer;
 begin
  if not Assigned(PJ.fForward) then exit;
  SetLenGth(result, LenGth(BL));
  FillChar(result[0],LenGth(result)*SizeOf(T3dPoint),$FF);
  pj.errno:=-byte(not Assigned(PJ.fForward));
  if (pj.errno<>0) then exit;
  for i:=0 to LenGth(result)-1 do
  with result[i] do
  begin
   result[i] :=Set3dPoint(adjlon(BL[i].B,true),adjlon(BL[i].L,false)-PJ.C0.lam);
   result[i] := PJ.fForward(result[i],@PJ); // project
   if (pj.errno=0) and not IsInfinite(result[i].lam) then	// adjust for major axis and easting/northings
   begin
    x := (PJ.Ellps.a*x+PJ.x0)/PJ.to_meter;
    y := (PJ.Ellps.a*y+PJ.y0)/PJ.to_meter;
    z := BL[i].Z;
   end else
   result[i] := InfPoint;
  end;
 end;


 function  PlaneToGeo(PJ:TCustomProj;pXY:T3dPoint):T3dPoint;
 var  xy   : T3dPoint;
 begin
  pj.errno :=-15*byte(not Assigned(PJ.fInverse));
  if (pj.errno<>0)  then exit;
  XY:=Set3dPoint((pXY.x*PJ.to_meter-PJ.x0)*PJ.Ellps.ra,(pXY.y*PJ.to_meter-PJ.y0)*PJ.Ellps.ra);
  result := PJ.fInverse(xy,@PJ); // inverse project
  if (pj.errno=0) and not IsInfinite(result.lam) then
  begin
   result.lam:=adjlon(result.lam+PJ.C0.lam);
   if (PJ.geoc=1) and (abs(abs(result.phi)-HALFPI)>1e-5) then
   result.phi := arctan(PJ.Ellps.one_es*tan(result.phi));
   result.Z := XY.z;
  end else
  result := InfPoint;
 end;

 function  PlaneToGeo(PJ:TCustomProj;X,Y:double):T3dPoint;
 begin
  result:=PlaneToGeo(PJ,Set3dPoint(X,Y,0));
 end;

 function  PlaneToGeo(PJ:TCustomProj;XY:T3dArray):T3dArray;
 var i    : integer;
 begin
  SetLenGth(result, LenGth(XY));
  FillChar(result[0],LenGth(result)*SizeOf(T3dPoint),$FF);
  pj.errno:=-byte(not Assigned(PJ.fInverse));

  for i:=0 to LenGth(result)-1 do
  with result[i] do
  begin
   result[i] := Set3dPoint((XY[i].x*PJ.to_meter-PJ.x0)*PJ.Ellps.ra,
   (XY[i].y*PJ.to_meter-PJ.y0)*PJ.Ellps.ra);
   result[i] := PJ.fInverse(result[i],@PJ); // project
   if (pj.errno=0) and not IsInfinite(result[i].lam) then
   // adjust for major axis and easting/northings
   begin
    result[i].lam:=adjlon(result[i].lam+PJ.C0.lam);
    if (PJ.geoc=1) and (abs(abs(result[i].phi)-HALFPI)>1e-5) then
    result[i].phi := arctan(PJ.Ellps.one_es*tan(result[i].phi)); 
    result[i].Z := XY[i].z;
   end else
   result[i] := InfPoint;
  end;
 end;


function GeoToXYZ(gPnt : T3dPoint;Ellps: TEllipsoidProperty): T3dPoint;
var Rn : double;
begin
  with gPnt do
  if (X<-PI/2) and (X>-1.001*PI/2) then X := -PI/2 else
  if (X>PI/2)  and (X<-1.001*PI/2) then X := PI/2 else
  if (X<-PI/2) or (X >PI/2) then exit;
  if (gPnt.Y > PI) then  gPnt.Y := gPnt.Y-2*PI;
  Rn := Ellps.a/(sqrt(1-Ellps.es * sqr(sin(gPnt.B))));
  result.X := (Rn+gPnt.H)*cos(gPnt.B)*cos(gPnt.L);
  result.Y := (Rn+gPnt.H)*cos(gPnt.B)*sin(gPnt.L);
  result.Z := ((Rn * (1-Ellps.es))+gPnt.h) * sin(gPnt.B);
end;

function XYZToGeo(mPnt : T3dPoint;Ellps : TEllipsoidProperty): T3dPoint;
var  W, t1, s1,
     cos_p1, delta,
     Rn, Sum  : double;       //* distance from Z axis */
     At_Pole  : boolean;      //* indicates location is in polar region */
begin
  At_Pole := (mPnt.X=0.0) and (mPnt.Y=0);
  if mPnt.X=0 then
  case byte(mPnt.Y=0) of
   1: begin
       result.L := 0.0;
       if mPnt.Z=0 then
       begin
        result.L := PI/2;
        result.Z := -Ellps.b;   // WGS84
        exit;
       end else
       result.B := PI*(1-2*byte(mPnt.Z<0))/2;
      end;
   0: result.L := PI*(1-2*byte(mPnt.Y<0))/2;
  end else
  result.L := arctan(mPnt.Y/mPnt.X);

  W     :=sqrt(sqr(mPnt.X)+sqr(mPnt.Y));
  T1    :=(sqr(Ellps.a)-sqr(Ellps.b))/sqr(Ellps.b);
  T1    :=mPnt.Z+Ellps.b*T1*power(mPnt.Z*1.0026/sqrt(sqr(mPnt.Z*1.0026)+sqr(W)),3);
  Sum   :=W-Ellps.a*Ellps.es*power(W/sqrt(sqr(mPnt.Z*1.0026)+sqr(W)),3);
  S1    :=sqrt(sqr(t1)+sqr(Sum));
  Cos_p1:=Sum/S1;
  Rn:=Ellps.a/sqrt(1.0-Ellps.es*sqr(T1/S1));
  if Cos_p1>=0.38268343236508977 then result.Z:=W/Cos_p1-Rn else
  if Cos_p1<=-0.38268343236508977 then result.Z:=-W/Cos_p1-Rn else
  result.Z:=mPnt.Z*S1/T1+Rn*(Ellps.es-1.0);
  if not at_pole then result.B:=arctan(T1/Sum);
end;

function GeoToXYZ(gPnt : T3dPoint;Ellps : TEllpsType): T3dPoint;
begin
 result:=GeoToXYZ(gPnt, Ellipsoids[Ellps]);
end;

function GeoToXYZ(gArr : T3dArray;Ellps : TEllpsType): T3dArray;
var i : integer;
    E : TEllipsoidProperty;
begin
 E:= Ellipsoids[Ellps];
 SetLenGth(result,LenGth(gArr));
 for i:=0 to LenGth(gArr)-1 do
 result[i]:=GeoToXYZ(gArr[i],E);
end;


function XYZToGeo(mPnt : T3dPoint;Ellps : TEllpsType): T3dPoint;
begin
 result:=XYZToGeo(mPnt, Ellipsoids[Ellps]);
end;


function XYZToGeo(mArr : T3dArray;Ellps : TEllpsType): T3dArray;
var i : integer;
    E : TEllipsoidProperty;
begin
 E:= Ellipsoids[Ellps];
 SetLenGth(result,LenGth(mArr));
 for i:=0 to LenGth(mArr)-1 do
 result[i]:=XYZToGeo(mArr[i],E);
end;

//***********************************************************************//
//***                                                                 ***//
//***                 PROJECTION OTHER FUNCTIONS                      ***//
//***                                                                 ***//
//***********************************************************************//


// distance and azimuth from point 1 to point 2
function _vect(dphi,c1,s1,c2,s2,dlam : double):TPJVector;
var cdl : double;
begin
 cdl := cos(dlam);
 case byte((abs(dphi)>1)or(abs(dlam)>1)) of
  1: result.r:=aacos(s1*s2+c1*c2*cdl);
  0: result.r:=2*aasin(sqrt(sqr(sin(0.5*dphi))+ c1*c2*sqr(sin(0.5*dlam))));
 end;
 result.Az:=0;
 if abs(result.r)>1e-9 then result.Az:=arctan2(c2*sin(dlam),c1*s2-s1*c2*cdl) else
 result.r:=0;
end;



function ssfn_(phit,sinphi,eccen: double):double;
begin
 result:=tan(0.5*(HALFPI+phit))*power((1-sinphi*eccen)/(1+sinphi*eccen),0.5*eccen);
end;


function phiaea(qs,Te,Tone_es :double):double;
var con, com, dphi : double;
    i : integer;
begin
 result:=arcsin(0.5*qs);
 if Te<1e-7 then exit;
 for i:=15 downto 0 do
 begin
  con:=Te*sin(result);
  com:=1-sqr(con);
  dphi:=0.5*com*com*(qs/Tone_es-sin(result)/com+0.5/Te*ln((1-con)/(1+con)))/cos(result);
  result:=result+dphi;
  if abs(dphi)<1E-10 then Break;
 end;
 if i<=0 then result:=1.0/0.0;
end;


function phi12(var PJ : TCustomProj; var delta : double):integer;
begin
  delta    := 0.5*(PJ.B2-PJ.B1);
  PJ.PM.Cp := 0.5*(PJ.B2+PJ.B1);
  result   :=-42*byte((abs(delta)<1E-10) or (abs(1E-10)<EPS));
end;

function GetLC(_a,_b,_c: double):double;
begin
 result:=aacos(0.5*(sqr(_b)+sqr(_c)-sqr(_a))/(_b*_c));
end;

function GetV(C : TKRobinson; Z : double) : double;
begin
 result:=C.c0 + z * (C.c1 + z * (C.c2 + z * C.c3))
end;

function GetDV(C : TKRobinson; Z : double) : double;
begin
 result:=C.c1 + z * (C.c2 + C.c2 + z * 3. * C.c3);
end;


 function  fS(S,C:double):double;  // func to compute dr
 asm
      FLD QWORD PTR S
      FLD QWORD PTR S
      FLD QWORD PTR C
      FMULP
      FMULP
      FLD1
      FADDP
      FLD QWORD PTR S
      FMULP
      FWAIT
 end;

 function  fSp(S,C:double):double;  // deriv of fs
 const _3 : extended = 3.0;
 asm
      FLD QWORD PTR S
      FLD QWORD PTR S
      FLD QWORD PTR C
      FLD _3
      FMULP
      FMULP
      FMULP
      FLD1
      FADDP
      FWAIT
 end;


procedure NormHALFPI(var value : double);
begin
 if value>=HALFPI then value:=value-HALFPI else
 if value<=-HALFPI then value:=value+HALFPI;
end;

function DMS(const aValue : string) : double;
var   P,L :integer;
     _V  : string;
const
     cChar = 'NEWSCBÑÞÇÂñþçâ-';
begin
 result:=0; _V:=UpperCase(Trim(aValue));
 if LenGth(_V)<5 then exit;
 if Pos(_V[1],cChar)>0 then _V:=Copy(_V,2,Length(_V)-1);
 if Pos(',', _V)>0 then _V[Pos(',', _V)]:='.';
 P:=Pos('.', _V);
 L:=LenGth(_V);
 case p>0 of
  TRUE:  result:=DegToRad(
          StrToInt(copy(_V,1,p-5))+
          StrToInt(copy(_V,p-4,2))/60+
          StrToFloat(copy(_V,P-2,l-p+3))/3600
          );
  FALSE: result:=DegToRad(
          StrToInt(copy(_V,1,L-4))+
          StrToInt(copy(_V,l-3,2))/60+
          StrToInt(copy(_V,L-1,2))/3600
          );
 end;
 if (aValue[1] in ['W','S','-','þ','Þ','ç','Ç']) then result:=-result;
end;

function DMS(aRadValue : double; Prec : byte; DegType: TDegType) : string;
var  D       : integer;
     sD, sM  : string;
     sS, sMS : string;
     DegVal  : extended;
begin
 DegVal := RoundTo(Abs(aRadValue*648000/PI), -prec);
 D      := trunc(DegVal);
 if prec<>0 then
 begin
  SetLenGth(sMs, prec);
  FillChar(sMs[1], prec, '0');
  DegVal:=frac(DegVal);
  if DegVal=0 then sMS:='0.'+sMs else sMS:=FloatToStr(DegVal)+sMs;
  sMs:=Copy(sMs, 2, prec+1);
 end;

 case DegType in [dtDegLat,dtXLat] of
  true : sD:=formatfloat('00',  D div 3600);
  false: sD:=formatfloat('000', D div 3600);
 end;

 D:=D mod 3600;
 sM:=IntToStr(D div 60);   if Length(sM)=1 then sm:='0'+sm;
 sS:=IntToStr(D mod 60);   if Length(ss)=1 then ss:='0'+ss;

 case DegType in [dtDegLat,dtDegLong] of
  TRUE : if Prec=0 then result:=sD+'°'+sM+''''+sS+'"' else result:=sD+'°'+sM+''''+sS+sms+'"';
  FALSE: if Prec=0 then result:=sD+sM+sS else result:=sD+sM+sS+sms;
 end;

 case DegType of
  dtDegLat      : if aRadValue<0 then result:='þ'+result else result:='ñ'+result;
  dtDegLong     : if aRadValue<0 then result:='ç'+result else result:='â'+result;
  dtXLat        : if aRadValue<0 then result:='S'+result else result:='N'+result;
  dtXLong       : if aRadValue<0 then result:='W'+result else result:='E'+result;
  dtLong, dtLat : if aRadValue<0 then result:='-'+result;
 end;

end;


function DMS(aRadValue : double; IsLong: byte; const Prec : byte = 0) : string;
var  SecVal : extended;
     tval   : integer;
const
  prefix = 'ñþâç';
begin
  SecVal := RoundTo(Abs(aRadValue*648000/PI), -prec);
  tval   := Trunc(SecVal/3600);
  if IsLong in [0..1] then
   result := prefix[2*byte(IsLong)+byte(aRadValue<0)+1];
  case IsLong of
   1,2 : result := result+formatfloat('000°',trunc(tval));
   0,3 : result := result+formatfloat('00°',trunc(tval));
  end;
  SecVal := SecVal-3600*tval;
  tval   := Trunc(SecVal/60);
  SecVal := SecVal-60*tval;
  result := result+formatfloat('00',tval)+''''+formatfloat('00',Trunc(SecVal));
  if (prec>0) and (frac(SecVal)>0) then
   result := result+'.'+formatfloat('####',Round(power(10,prec)*frac(SecVal)));
  result := result+'"';
end;

// ** proc **

function pj_tsfn(phi,sinphi,e: double):double;
begin
 result:=tan(0.5*(HALFPI-phi))/power((1-sinphi*e)/(1+sinphi*e),0.5*e);
end;



function pj_qsfn(sinphi,e,one_es:double): double;
begin
 case e>=1.0e-7 of
  true : result:=one_es*(sinphi/(1-sqr(e*sinphi))-(0.5/e)*ln((1-e*sinphi)/(1+e*sinphi)));
  false: result:=2*sinphi;
 end;
end;



function pj_phi2(ts,e : double;var errno : integer) : double;
var eccnth,  con, dphi: double;
    i : integer;
begin
 eccnth :=0.5*e;
 result := HALFPI-2*arctan(ts);
 for i:=15 downto 0 do
 begin
  con  := e * sin(result);
  dphi := HALFPI-2*arctan(ts*power((1-con)/(1+con), eccnth))-result;
  result :=result+dphi;
  if abs(dphi)<=1e-10 then break;
 end;
 if (i<=0) and (abs(dphi)>1e-8) then errno := -18;
end;


function pj_msfn(sinphi,cosphi,es:double) :double;
begin
 result:=cosphi/sqrt(1-es*sqr(sinphi));
end;


{ meridinal distance for ellipsoid and inverse
**	8th degree - accurate to < 1e-5 meters when used in conjuction
**		with typical major axis values.
**	Inverse determines phi to EPS (1e-11) radians, about 1e-6 seconds.}


function pj_enfn(es:double):TEnParam;
begin
 result[0]:=1-es*(0.25+es*(0.046875+es*(0.01953125+es*0.01068115234375)));
 result[1]:=es*(0.75-es*(0.046875+es*(0.01953125+es*0.01068115234375)));
 result[2]:=sqr(es)*(0.46875-es*(0.01302083333333333333+es*0.00712076822916666666));
 result[3]:=sqr(es)*es*(0.36458333333333333333-es*0.00569661458333333333);
 result[4]:=sqr(sqr(es))*0.3076171875;
end;


function pj_mlfn(phi,sphi,cphi:double;fEn:TEnParam):double;
begin
 result:=fEn[0]*phi-cphi*sphi*(fEn[1]+
 sqr(sphi)*(fEn[2]+sqr(sphi)*(fEn[3]+sqr(sphi)*fEn[4])));
end;

function pj_inv_mlfn(arg,es:double; en:TEnParam;var errno : integer):double;
var s,t, k :double;
    i : integer;
begin
  k:=1/(1-es);
  result := arg;

  for i:=MAX_ITER downto 0 do //rarely goes over 2 iterations */
  begin
   t := 1-es*sqr(sin(result));
   t := (pj_mlfn(result,sin(result),cos(result),en)-arg)*(t*sqrt(t))*k;
   result := result-t;
   if (abs(t)<EPS) then break;
  end;
  errno := -17*byte((i<1) or (abs(t)>=EPS));
end;

// determine latitude from authalic latitude //

function pj_authset(es:double) :TApaParam;
begin
 result[0] := es/3+sqr(es)*0.17222222222222222222+power(es,3)*0.10257936507936507936;
 result[1] := sqr(es)*0.06388888888888888888+power(es,3)*0.06640211640211640211 ;
 result[2] := power(es,3)*0.01641501294219154443;
end;

function pj_authlat(beta: double;APA : TApaParam):double;
begin
 result:=beta+APA[0]*sin(2*beta)+APA[1]*sin(4*beta)+APA[2]*sin(6*beta);
end;

{

pj_zpoly1(COMPLEX z, COMPLEX *C, int n) {

	COMPLEX a;
	double t;

	a = *(C += n);
	while (n-- > 0) {
		a.r = (--C)->r + z.r * (t = a.r) - z.i * a.i;
		a.i = C->i + z.r * a.i + z.i * t;

	a.r = z.r * (t = a.r) - z.i * a.i;
	a.i = z.r * a.i + z.i * t;
	return a;


}

// Estimating a Complex Polynomial

function pj_zpoly1(Z:TComplex;const C : array of TComplex):TComplex;

var t   : double;

    i,n : integer;

    a   : TComplex;

begin

 a:=C[High(C)];

 for i:=High(C) downto 1 do
 begin
  t := a.r;
  a.r:=C[i-1].r+z.r*t-z.i*a.i;
  a.i:=C[i].i+z.r*a.i+z.i*t;
 end;
 t   := a.r;
 result.r := z.r*t-z.i*a.i;
 result.i := z.r*a.i+z.i*t;
end;

// Complex polynomial estimate and derivative
function pj_zpolyd1(Z:TComplex;const C : array of TComplex;var der : TComplex):TComplex;
var t       : double;
    i,n     : integer;

    a,b     : TComplex;

begin

 n:= High(C);
 a:=C[n]; b:=C[n];
 for i:=n downto 1 do
 begin
  if i<n then
  begin
   t   := b.r;
   b.r := a.r + Z.r*t-z.i*b.i;
   b.i := a.i + z.r*b.i+z.i*t;
  end;
  t := a.r;
  a.r:=C[i-1].r+z.r*t-z.i*a.i;
  a.i:=C[i].i+z.r*a.i+z.i*t;
 end;
 t        := b.r;
 der.r    := a.r+z.r*t-z.i*b.i;
 der.i    := a.i+z.r*b.i+z.i*t;
 t        := a.r;
 result.r := z.r*t-z.i*a.i;
 result.i := z.r*a.i+z.i*t;
end;

//***********************************************************************//
//***                                                                 ***//
//***                     PROJECTION FUNCTIONS                        ***//
//***                                                                 ***//
//***********************************************************************//
var
 _Sinu, _Moll : TCustomProj;      // from Goode


function mPolyForward(pntBL: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result:=nullpoint;
end;

function mPolyInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result:=nullpoint;
end;

procedure InitMPoly(var PJ : TCustomProj);
begin
 PJ.fForward:=mPolyForward;
 PJ.fInverse:=mPolyInverse;
end;

function AugustForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
var t,c, x1, y1 : double;
begin
   t  := tan(0.5*PntLP.phi);
   c  := 1+sqrt(1-t*t)*cos(PntLP.lam*0.5);
   x1 := sin(PntLP.lam*0.5)* sqrt(1-t*t)/ c;
   y1 :=  t/c;
   result.x := 4*x1*(3+sqr(x1)-3*sqr(y1))/3;
   result.y := 4*y1*(3+3*sqr(x1)-sqr(y1))/3;
end;


procedure InitAugust(var PJ : TCustomProj);
begin
 PJ.fForward := AugustForward;
 PJ.fInverse := nil;
end;


function llForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;
begin
 result.x := lp.lam/PJ.Ellps.a;
 result.y := lp.phi/PJ.Ellps.a;
end;

function llInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;
begin
 result.phi := xy.y*PJ.Ellps.a;
 result.lam := xy.x*PJ.Ellps.a;
end;

// aka InitLongLat
procedure InitLatLong(var PJ : TCustomProj);
begin
 PJ.is_latlong := 1;
 PJ.x0 := 0.0; PJ.y0 := 0.0;
 PJ.fInverse := llInverse;
 PJ.fForward := llForward;
end;


function GlobForward(LP : T3dPoint; PJ:PCustomProj): T3dPoint; // ellipsoid
var ax, f : double;
begin
  case PJ.PM.mode and $01 of
   1 : result.y:=HALFPI * sin(lp.phi);
   0 : result.y:=lp.phi;
  end;
  ax       := abs(lp.lam);
  result.x := 0;
  if (ax<=1e-10) then exit;
  if (PJ.PM.mode and $02>0) and (ax>=HALFPI) then
  result.x:=sqrt(2.46740110027233965467-lp.phi*lp.phi+1e-10)+ax-HALFPI else
  begin
   f:=0.5*(2.46740110027233965467/ax+ax);
   result.x:=ax-f+sqrt(f*f-sqr(result.y));
  end;
  if (lp.lam<0) then result.x := - result.x;
end;
//apian, "Apian Globular I"  pMode = 0
//ortel, "Ortelius Oval"     pMode = 2
//bacon, "Bacon Globular"    pMode = 1
procedure InitGlobular(var PJ : TCustomProj; pMode : byte);
begin
 PJ.PM.mode:=pMode;
 PJ.fForward:=GlobForward;
end;


function gcForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;
begin
 result.x := lp.lam;
 result.y := lp.phi;
end;

function gcInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;
begin
 result.phi := xy.y;
 result.lam := xy.x;
end;


procedure InitGeoCentric(var PJ : TCustomProj);
begin
 PJ.is_geocent := 1;
 PJ.x0 := 0.0; PJ.y0 := 0.0;
 PJ.fInverse := gcInverse;
 PJ.fForward := gcForward;
end;


function LarrForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // sphere
begin
 result.x:=0.5*lp.lam*(1.+sqrt(cos(lp.phi)));
 result.y:=lp.phi/(cos(0.5*lp.phi)*cos(lp.lam/6));
end;

procedure InitLarrivee(var PJ : TCustomProj);
begin
 PJ.Ellps.es := 0.0;
 PJ.fForward := LarrForward;
end;


function Urm5Forward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;
var _phi: double;
begin
  _phi     := aasin(PJ.PM.B*sin(LP.phi));
  result.x := PJ.PM.C*lp.lam*cos(_phi);
  result.y := _phi*(1+sqr(_phi)*PJ.PM.B)*PJ.PM.A;
end;


procedure InitUrm5(var PJ : TCustomProj;Alpha,dN,dQ:double);
var t,_a : double;
begin
  if IsInfinite(dQ) then PJ.PM.B:=0 else PJ.PM.B:=dQ/3;
  case byte(IsInfinite(Alpha)) of
   1: PJ.PM.C := 1;
   0: PJ.PM.C := cos(Alpha)/sqrt(1-sqr(dN*sin(Alpha)));
  end;
  PJ.PM.A     := 1/(PJ.PM.C*dN);
  PJ.ellps.es := 0;
  PJ.fForward := Urm5Forward;
  PJ.PM.B:=dN;
end;


function ccForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 if (abs(abs(pntBL.phi)-HALFPI)<=TOL) then exit;
 result.x := pntBL.lam;
 result.y := tan(pntBL.phi);
end;

function ccInverse(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint;// spheroid
begin
 result.phi := arctan(pntXY.y);
 result.lam := pntXY.x;
end;


procedure InitCC(var PJ : TCustomProj);
begin
 Pj.fForward:=ccForward;
 Pj.fInverse:=ccInverse;
end;


function MillCylForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := lp.lam;
 result.y := ln(tan(FORTPI+lp.phi*0.4))*1.25;
end;

function MillCylInverse(xy: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.lam:=xy.x;
 result.phi:=2.5*(arctan(exp(0.8*xy.y))-FORTPI);
end;

procedure InitMillerCyl(var PJ : TCustomProj);
begin
 Pj.fForward:=MillCylForward;
 Pj.fInverse:=MillCylInverse;
 Pj.Ellps.Es:=0;
end;


function AitoffForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
var c, d : double;
begin
 result.x :=0;  result.y :=0;
 c := 0.5*PntLP.lam;
 d := arccos(cos(PntLP.phi)*cos(c));
 if d<>0 then // basic Aitoff
 begin
  result.x := 2*d*cos(PntLP.phi)*sin(c)/sin(d);
  result.y := d*sin(PntLP.phi)/sin(d);
 end;
 if PJ.PM.mode>0 then  // Winkel Tripel
 begin
  result.x := (result.x+PntLP.lam*PJ.PM.A) * 0.5;
  result.y := (result.y+PntLP.phi)*0.5;
 end;
end;


procedure InitAitoff(var PJ : TCustomProj);
begin
 PJ.PM.mode := 0;
 PJ.fForward := AitoffForward;
 PJ.fInverse := nil;
end;

procedure InitWinkTripel(var PJ : TCustomProj;B1 : double);
begin
 PJ.B1 := B1;
 If not IsInfinite(PJ.B1) then  begin
  PJ.PM.A  := cos(PJ.B1);
  pj.errno := -22*byte(PJ.PM.A=0);
  if pj.errno<>0 then  exit;
 end else
 PJ.PM.A := 0.636619772367581343;  // 50d28' or acos(2/pi)

 PJ.PM.mode        := 1;
 PJ.fForward := AitoffForward;
 PJ.fInverse := nil;
end;


function TCCForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; //spheroid
var b,bt : double;
begin
 b := cos(lp.phi)*sin(lp.lam);
 bt:=1-sqr(b);
 pj.errno:=-byte(bt<1e-10);
 if pj.errno<>0 then exit;
 result.x := b/sqrt(bt);
 result.y := arctan2(tan(lp.phi),cos(lp.lam));
end;

procedure InitTransCC(var PJ : TCustomProj);
begin
  PJ.fForward := TCCForward;
  PJ.Ellps.es := 0;
end;


function TCEAForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; //spheroid
begin
 result.x:=PJ.PM.A*cos(lp.phi)*sin(lp.lam);
 result.y:=PJ.k0*(arctan2(tan(lp.phi),cos(lp.lam))-PJ.C0.phi);
end;

function TCEAInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint; // spheroid
var  XY : T3dPoint;
begin
 xy.y := PntXY.y*PJ.PM.A+PJ.C0.phi;
 xy.x := PntXY.x*PJ.k0;
 result.phi:=arcsin(sqrt(1-sqr(xy.x))*sin(xy.y));
 result.lam:=arctan2(xy.x,sqrt(1-sqr(xy.x))*cos(xy.y));
end;


procedure InitTransCEA(var PJ : TCustomProj);
begin
  if PJ.k0=0 then PJ.k0:=1;
  PJ.PM.A     := 1/PJ.k0;
  PJ.fInverse := TCEAInverse;
  PJ.fForward := TCEAForward;
  PJ.Ellps.es := 0;
end;

function StsForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
var c,_phi : double;
begin
 _phi     := lp.phi*PJ.PM.Cp;
 result.x := PJ.PM.Cx*lp.lam*cos(lp.phi);
 result.y := PJ.PM.Cy;
 case PJ.PM.mode of
  1: begin
      result.x:=result.x*sqr(cos(_phi));
      result.y:=result.y*tan(_phi);
     end;
  0: begin
      result.x:=result.x/cos(_phi);
      result.y:=result.y*sin(_phi);
     end;
 end;
end;


function StsInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint; // spheroid
var c  : double;
    XY : T3dPoint;
begin
 xy.x:=PntXY.x;
 xy.y:=PntXY.y/PJ.PM.Cy;
 if PJ.PM.mode=1 then result.phi:=arctan(XY.y) else
 result.phi:=aasin(XY.y);
 c:=cos(result.phi);
 result.phi:=result.phi/sqr(PJ.PM.Cp);
 result.lam := xy.x/(PJ.PM.Cx*cos(result.phi));
 if PJ.PM.mode=1 then result.lam:=result.lam/sqr(c) else
 result.lam:=result.lam*c;
end;


procedure InitSts(var PJ:TCustomProj;dP,dQ:double;TanMode : byte);
begin
 PJ.PM.mode  := TanMode;
 PJ.Ellps.es := 0.0;
 PJ.PM.Cx    := dQ/dP;
 PJ.PM.Cy    := dP;
 PJ.PM.Cp    := 1/dQ;
 PJ.fInverse := StsInverse;
 PJ.fForward := StsForward;
end;

procedure InitFoucaut(var PJ : TCustomProj);
begin
 InitSts(PJ,2,2,1);
end;

//Mc Flat Sine no.1
procedure InitMcSin1(var PJ : TCustomProj);
begin
 InitSts(PJ,1.48875, 1.36509, 0);
end;

procedure InitQuarticAuth(var PJ : TCustomProj);
begin
 InitSts(PJ,2,2,0);
end;

procedure InitKav5(var PJ : TCustomProj);
begin
 InitSts(PJ,1.50488, 1.35439, 0);
end;



function eEACForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;   // ellipsoid
begin
 result.x := PJ.k0 * lp.lam;
 result.y := 0.5*pj_qsfn(sin(lp.phi),PJ.ellps.e,PJ.ellps.one_es)/PJ.k0;
end;

function eEACInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;   // ellipsoid
begin
 result.phi := pj_authlat(arcsin(2*xy.y*PJ.k0/PJ.PM.A),PJ.PM.apa);
 result.lam := xy.x/PJ.k0;
end;


function sEACForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;   // spheroid
begin
 result.x := PJ.k0*lp.lam;
 result.y := sin(lp.phi)/PJ.k0;
end;

function sEACInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;   // spheroid
begin
 result.phi := aasin(xy.y*PJ.k0);
 result.lam := xy.x / PJ.k0;
end;


procedure InitEAC(var PJ : TCustomProj; Bts:double);
var t : double;
begin
 t:=0; PJ.Bts:=Bts;
 if not IsInfinite(PJ.Bts) then
 begin
  t     := PJ.Bts;
  PJ.k0 := cos(t);
  pj.errno:=-24*byte(PJ.k0<0);
  if pj.errno<>0 then exit;
 end;
 with PJ.PM do
 case byte(PJ.Ellps.es<>0) of
  1: begin
      apa   := pj_authset(PJ.Ellps.es);
      A    := pj_qsfn(1,Pj.Ellps.e, Pj.Ellps.one_es);
      PJ.fInverse := eEACInverse;
      PJ.fForward := eEACForward;
     end;
  0: begin
      PJ.fInverse := sEACInverse;
      PJ.fForward := sEACForward;
     end;
 end;
end;






function OEAForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; // sphere
var Az, hz, M, N, cp, sp, cl, shz : double;
begin
  cp     := cos(lp.phi);
  sp     := sin(lp.phi);
  cl     := cos(lp.lam);
  Az     := aatan2(cp*sin(lp.lam),cos(PJ.C0.phi)*sp-sin(PJ.C0.phi)*cp*cl)+PJ.PM.Cx;
  shz    := sin(0.5*aacos(sin(PJ.C0.phi)*sp+cos(PJ.C0.phi)*cp*cl));
  M      := aasin(shz*sin(Az));
  N      := aasin(shz*cos(Az)*cos(M)/cos(M*2/PJ.PM.B));
  result.y:=PJ.PM.A*sin(N*2/PJ.PM.A);
  result.x:=PJ.PM.B*sin(M*2/PJ.PM.B)*cos(N)/cos(N*2/PJ.PM.A);
end;

function OEAInverse(XY: T3dPoint;PJ : PCustomProj):T3dPoint; //sphere
var N, M, xp, yp, z, Az, cz, sz, cAz : double;
begin
  N := 0.5*PJ.PM.A*aasin(xy.y/PJ.PM.A);
  M := 0.5*PJ.PM.B*aasin(xy.x/PJ.PM.B* cos(N*2/PJ.PM.A) / cos(N));
  xp := 2. * sin(M);
  yp := 2. * sin(N) * cos(M*2/PJ.PM.B) / cos(M);
  Az := aatan2(xp, yp)-PJ.PM.Cx;
  cAz := cos(Az);
  z := 2. * aasin(0.5 * hypot(xp, yp));
  sz := sin(z);
  cz := cos(z);
  result.phi := aasin(sin(PJ.C0.phi)*cz+cos(PJ.C0.phi)* sz * cAz);
  result.lam := aatan2(sz * sin(Az),cos(PJ.C0.phi)* cz-sin(PJ.C0.phi)* sz * cAz);
end;

procedure InitOEA(var PJ : TCustomProj;dN,dM : double; const theta :double = 1/0);
begin

 pj.errno:=-39*byte((dN<=0) or (dM<=0));
 if pj.errno<>0 then exit;
 PJ.PM.A:=dN;   PJ.PM.B:=dM;
 if IsInfinite(Theta) then PJ.PM.Cx:=0 else PJ.PM.Cx:=theta;
 PJ.fForward:=OEAForward;
 PJ.fInverse:=OEAInverse;
 PJ.Ellps.es := 0;
end;

function SWMercForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;
var phip, lamp, phipp, lampp, sp, cp : double;
begin
  sp    := PJ.ellps.e*sin(lp.phi);
  phip  := 2*arctan(exp(PJ.PM.C*(ln(tan(FORTPI+0.5*lp.phi))-
           0.5*PJ.ellps.e*ln((1+sp)/(1-sp)))+PJ.PM.rho))-HALFPI;
  lamp  := PJ.PM.C* lp.lam;
  cp    := cos(phip);
  phipp := aasin(PJ.PM.B*sin(phip)-PJ.PM.A*cp*cos(lamp));
  lampp := aasin(cp*sin(lamp)/cos(phipp));
  result.x := PJ.PM.rho0*lampp;
  result.y := PJ.PM.rho0*ln(tan(FORTPI+0.5*phipp));
end;


{
  K     =>  rho
  kR    =>  rho0
  cosp0 =>  cosph0
  sinp0 =>  sinph0
}

function SWMercInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;
var
  phip, lamp, phipp, lampp, cp, esp, con, delp : double;
  i : integer;
begin
  phipp := 2*(arctan(exp(xy.y/PJ.PM.rho0)) - FORTPI);
  lampp := xy.x/PJ.PM.rho0;
  cp    := cos(phipp);
  phip  := aasin(PJ.PM.B*sin(phipp)+PJ.PM.A*cp*cos(lampp));
  lamp  := aasin(cp*sin(lampp)/cos(phip));
  con   := (PJ.PM.rho-ln(tan(FORTPI+0.5*phip)))/PJ.PM.C;
  for i:= 6 downto 0 do
  begin
   esp := PJ.ellps.e* sin(phip);
   delp:=(con+ln(tan(FORTPI+0.5*phip))-0.5*PJ.ellps.e*ln((1+esp)/(1-esp)))*
    (1-esp*esp)*cos(phip)*PJ.ellps.one_es;
   phip:=phip-delp;
   if abs(delp)<1e-10 then break;
  end;
  if i>=0 then
  begin
   result.phi := phip;
   result.lam := lamp/PJ.PM.C;
  end;
end;



procedure InitSWMercator(var PJ : TCustomProj);
var cp, phip0, _sp : double;
begin
  if IsInfinite(PJ.C0.phi) then exit;
  with PJ.PM do
  begin                          
   cp     := sqr(cos(PJ.C0.phi));
   C      := sqrt(1+PJ.ellps.es*cp*cp*PJ.ellps.rone_es);
   A      := sin(PJ.C0.phi)/C;
   phip0  := aasin(A);
   B      := cos(phip0);
   _sp    := sin(PJ.C0.phi)*PJ.ellps.e;
   rho    := ln(tan(FORTPI+0.5*phip0))-C*(ln(tan(FORTPI+0.5*PJ.C0.phi))-
             0.5*PJ.ellps.e*ln((1+_sp)/(1-_sp)));
   rho0   := PJ.k0*sqrt(PJ.ellps.one_es)/(1-_sp*_sp);
  end;
  PJ.fInverse := SWMercInverse;
  PJ.fForward := SWMercForward;
end;


function eBonneForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;   // ellipsoid
var _E,r0 : double;
begin
 with PJ.PM do
 begin
  r0  := A+D-pj_mlfn(lp.phi,sin(lp.phi),cos(lp.phi),en);
  _E  := cos(lp.phi)*lp.lam/(r0*sqrt(1-PJ.Ellps.es*sqr(sin(lp.phi))));
  result.x:=r0*sin(_E);
  result.y:=A-r0*cos(_E);
 end;
end;

function eBonneInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint; // ellipsoid
var r0 : double;
begin
 with PJ.PM do
 begin
  r0 := hypot(xy.x,A-xy.y);
  result.phi := pj_inv_mlfn(A+D-r0,PJ.Ellps.es,en,pj.errno);
  if abs(result.phi)>HALFPI then exit;
  result.lam:=(r0*arctan2(xy.x,A-xy.y)*sqrt(1-PJ.Ellps.es*sqr(sin(result.phi)))/cos(result.phi))*
  byte(abs(abs(result.phi)-HALFPI)>1e-10);
 end;
end;

function sBonneForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // spheroid
var r0 : double;
begin
 r0:=PJ.PM.B+PJ.B1-lp.phi;
 result:= NullPoint;
 if abs(r0)> 1e-10 then
 begin
  result.x := r0 * sin(lp.lam*cos(lp.phi)/r0);
  result.y := PJ.PM.B-r0* cos(lp.lam*cos(lp.phi)/r0);
 end;
end;


function sBonneInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;   // spheroid
var r0 : double;
begin
 r0 := hypot(xy.x, PJ.PM.B-xy.y);
 result.phi := PJ.PM.B+PJ.B1-r0;
 if abs(result.phi)>HALFPI then exit;
 result.lam:=(r0*arctan2(xy.x,PJ.PM.B-xy.y)/cos(result.phi))*
 byte(abs(abs(result.phi)-HALFPI)>1e-10);
end;

procedure InitBonne90(var PJ : TCustomProj;B1:double);
begin
  if IsInfinite(B1) then PJ.B1:=0 else PJ.B1:=B1;
  pj.errno:=-23*byte(PJ.B1<1e-10);
  if pj.errno<>0 then exit;
  with PJ.PM do
  case byte(Pj.ellps.es<>0) of
   1: begin
       en := pj_enfn(Pj.ellps.es);
       A  := sin(PJ.B1);
       c  := cos(PJ.B1);
       D := pj_mlfn(PJ.B1,A,c,en);
       A   :=c/(sqrt(1-Pj.ellps.es*A*A)*A);
       PJ.fInverse := eBonneInverse;
       PJ.fForward := eBonneForward;
      end;
   0: begin
       B:=byte(abs(PJ.B1)+1e-10<HALFPI)/tan(PJ.B1);
       PJ.fInverse := sBonneInverse;
       PJ.fForward := sBonneForward;
      end;
  end;

end;


function GnomForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var coslam, cosphi, sinphi : double;
begin
  sinphi := sin(lp.phi);
  cosphi := cos(lp.phi);
  coslam := cos(lp.lam);
  case PJ.PM.mode of
   2: result.y := cosphi * coslam;
   3: result.y := sin(PJ.C0.phi)*sinphi+cos(PJ.C0.phi)*cosphi*coslam;
   1: result.y := -sinphi;
   0: result.y := sinphi;
  end;
  if result.y<=1E-10 then exit;
  result.y := 1/result.y;
  result.x := result.y * cosphi * sin(lp.lam);
  case PJ.PM.mode of
   2: result.y := result.y*sinphi;
   3: result.y:= result.y*(cos(PJ.C0.phi)*sinphi-sin(PJ.C0.phi)*cosphi * coslam);
   0,1: result.y := result.y*cosphi*coslam*(1-2*byte(PJ.PM.mode=0));
  end;
end;


function GnomInverse(PntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var rh, cosz, sinz : double;
    XY: T3dPoint;
begin
  XY   :=PntXY;
  rh   := hypot(xy.x, xy.y);
  result.phi := arctan(rh);
  sinz := sin(result.phi);
  cosz := sqrt(1- sinz * sinz);
  if abs(rh)<=1e-10 then
  begin
   result.phi := PJ.C0.phi;
   result.lam := 0;
   exit;
  end;
  with result do
  case PJ.PM.mode of
   3: begin
       phi := cosz *sin(PJ.C0.phi)+ xy.y * sinz *cos(PJ.C0.phi)/ rh;
       if (abs(phi)>=1) then phi := HALFPI*(1-2*byte(phi<0)) else
       phi := arcsin(phi);
       xy.y := (cosz -sin(PJ.C0.phi)* sin(phi)) * rh;
       xy.x := xy.x*sinz*cos(PJ.C0.phi);
      end;
   2: begin
       phi := xy.y * sinz / rh;
       if (abs(phi)>=1) then phi := HALFPI*(1-2*byte(phi<0)) else
       phi  := arcsin(phi);
       xy.y := cosz * rh;
       xy.x := xy.x* sinz;
     end;
   1: phi   := phi-HALFPI;
   0: begin
       phi  := HALFPI - phi;
       xy.y := -xy.y;
      end;
  end;
  result.lam := arctan2(xy.x, xy.y);
end;


procedure InitGnomonic(var PJ : TCustomProj);
begin
 if abs(abs(PJ.C0.phi)-HALFPI)<1e-10 then PJ.PM.mode:=byte(PJ.C0.phi<0) else
 PJ.PM.mode:=2+byte(abs(PJ.C0.phi)>=1e-10);
 PJ.fForward:=GnomForward;
 PJ.fInverse:=GnomInverse;
 PJ.ellps.es:=0;
end;


// Ok!!! (not exactly)

function RobinsonForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var i    : integer;
    dphi : double;
begin
  dphi := abs(lp.phi);
  i    := floor(dphi*11.45915590261646417544);
  if i>=18 then i:=17;
  dphi := 180*(dphi-0.08726646259971647884*i)/pi;

  result.x := GetV(XRobin[i],dphi)*0.8487*lp.lam;
  result.y := GetV(YRobin[i],dphi)*1.3523;
  if (lp.phi<0) then result.y:=-result.y;
end;

// Ok!!!
function RobinsonInverse(xy: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var i,cnt : integer;
    t,t1  : double;
    K     : TKRobinson;
begin
  result.lam := xy.x/0.8487;
  result.phi := abs(xy.y/1.3523);
  pj.errno:=-byte(result.phi>1.000001);
  if pj.errno<>0 then exit;
  // simple pathologic cases
  if (result.phi=1) then
  begin
   result.phi := HALFPI*(1-2*byte(xy.y<0));
   result.lam := XRobin[18].c0;
  end else
  // general problem
  begin
   cnt:=0;
  // in Y space, reduce to table interval */
   i:=floor(result.phi*18);
   repeat
    inc(cnt);
    if YRobin[i].c0>result.phi then dec(i) else
    if YRobin[i+1].c0<=result.phi then inc(i) else break;
   until cnt>18;
   K := YRobin[i];
   // first guess, linear interp
   t := 5*(result.phi-K.c0)/(YRobin[i+1].c0-K.c0);
   // make into root
   K.c0 := K.c0-result.phi;
   //Newton-Raphson reduction
   repeat
    Inc(cnt);
    t1 := GetV(K,t)/GetDV(K,t);
    t  := t-t1;
    if abs(t1)<1e-8 then break;
   until cnt>100;
   result.phi := pi*(5*i+t)/180;
   if xy.y<0 then result.phi := -result.phi;
   result.lam := result.lam/GetV(XRobin[i],t);
 end;
end;


procedure InitRobinson(var PJ : TCustomProj);
begin
 PJ.fForward:=RobinsonForward;
 PJ.fInverse:=RobinsonInverse;
 PJ.Ellps.Es:=0;
end;


function lccaForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // ellipsoid
var S,r: double;
begin
  S := pj_mlfn(pntBL.phi, sin(pntBL.phi), cos(pntBL.phi),PJ.PM.EN)-PJ.PM.B;
  r  := PJ.PM.D - fS(S,PJ.PM.C);
  result.x := PJ.k0 * (r* sin(pntBL.lam*PJ.PM.A));
  result.y := PJ.k0 * (PJ.PM.D-r*cos(pntBL.lam*PJ.PM.A));
end;

function lccaInverse(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint;// ellipsoid & spheroid
var theta, dr,
    S, dif : double;
    i      : integer;
    xy     :  T3dPoint;
begin
  xy.x  := pntXY.X/PJ.k0;
  xy.y  := pntXY.Y/PJ.k0;
  theta := arctan2(xy.x,PJ.PM.D-xy.y);
  dr    := xy.y-xy.x*tan(0.5*theta);
  result.lam := theta/PJ.PM.A;
  S := dr;
  for i:=MAX_ITER downto 0 do
  begin
   dif := (fS(S,PJ.PM.C)-dr)/fSp(S,PJ.PM.C);
   s   := s-dif;
   if (abs(dif)<1e-12) then break;
  end;
  if i=0 then pj.errno:=-1;
  result.phi := pj_inv_mlfn(S + PJ.PM.B, PJ.ellps.es, PJ.PM.EN,pj.errno);
end;


procedure InitLCCA(var PJ : TCustomProj);
var  _N0,_R0 : double;
begin
 with PJ.PM do
 begin
  pj.errno:=0;
  EN := pj_enfn(PJ.ellps.es);
  pj.errno:=-51*byte(IsInfinite(PJ.C0.phi) or (PJ.C0.phi=0));
  if pj.errno<>0 then exit;
  A    := sin(PJ.C0.phi);
  B   := pj_mlfn(PJ.C0.phi,A, cos(PJ.C0.phi),EN);
  _R0  := 1/(1-PJ.ellps.es*sqr(A));
  _N0  := sqrt(_R0);
  _R0  :=_R0*PJ.ellps.one_es*_N0;
  D    := _N0/tan(PJ.C0.phi);
  C     := 1/(6*_R0 *_N0);
  PJ.fInverse := lccaInverse;
  PJ.fforward := lccaForward;
 end;
end;

{#ifndef lint
static const char SCCSID[]="@(#)PJ_nell.c	4.1	94/02/15	GIE	REL";
#endif
#define PJ_LIB__
#include	<projects.h>
PROJ_HEAD(nell, "Nell") "\n\tPCyl., Sph.";
	    }


function NellForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
var k, V : double;
    i    : integer;
    LP   : T3dPoint;
begin
 lp:=PntLP;

 k := 2*sin(lp.phi);
 V := lp.phi*lp.phi;
 lp.phi := lp.phi*(1.00371-V*(0.0935382+V*0.011412));
 for i:=10 downto 0 do
 begin
  V :=(lp.phi+sin(lp.phi)-k)/(1+cos(lp.phi));
  lp.phi := lp.phi-V;
  if (abs(V)<1e-7) then break;
 end;
 result.x := 0.5*lp.lam*(1+cos(lp.phi));
 result.y := lp.phi;
end;

function NellHForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
begin
 result.x := 0.5*PntLP.lam*(1+cos(PntLP.phi));
 result.y := 2.0*(PntLP.phi-tan(0.5*PntLP.phi));
end;


function NellInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint;  // spheroid
begin
 result.lam := 2.0*PntXY.x/(1+cos(PntXY.y));
 result.phi := aasin(0.5*(PntXY.y+sin(PntXY.y)));
end;


function NellHInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint;  // spheroid
var V : double;
    i : integer;
begin
 result.X:=0;  result.Y:=0;
 for i:=9 downto 0 do
 begin
  V :=(result.phi-tan(result.phi/2)-0.5*PntXY.y)/(1-0.5/sqr(cos(0.5*result.phi)));
  result.phi := result.phi-V;
 if (abs(V)<1e-7) then break;
 end;
 if i=0 then
 begin
  result.phi := HALFPI*(1-2*byte(PntXY.y<0));
  result.lam := 2*PntXY.y;
 end else
 result.lam := 2*PntXY.x/(1+cos(result.phi));
end;



procedure InitNell(var PJ : TCustomProj);
begin
  PJ.fInverse := NellInverse;
  PJ.fForward := NellForward;
end;

procedure InitNellHammer(var PJ : TCustomProj);
begin
 PJ.fInverse := NellHInverse;
 PJ.fForward := NellHForward;
end;



 //m0 -reserv
function eCassForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //ellipsoid
var t,a2,n,a,c : double;
begin
  result.y := pj_mlfn(lp.phi,sin(lp.phi),cos(lp.phi),PJ.PM.en);
  N        := 1/sqrt(1-PJ.ellps.es*sqr(sin(lp.phi)));
  t        := sqr(tan(lp.phi));
  A        := lp.lam*cos(lp.phi);
  C        := sqr(cos(lp.phi))*PJ.ellps.es/(1-PJ.ellps.es);
  a2       := sqr(a);
  result.x := N*A*(1-a2*t*(1/6-(8-t+8*c)*a2/120));
  result.y := result.y-(PJ.PM.A-N*tan(lp.phi)*a2*(0.5+(5-t+6*C)*a2/24));
end;

function eCassInverse(xy: T3dPoint;PJ : PCustomProj):T3dPoint; //ellipsoid
var ph1,t,n,rho,dd : double ;
begin
  ph1 := pj_inv_mlfn(PJ.PM.A+xy.y, PJ.ellps.es,PJ.PM.en,pj.errno);
  t := sqr(tan(ph1));
  n := sin(ph1);
  rho := 1/(1-PJ.ellps.es *N*N);
  n   := sqrt(rho);
  rho := rho*(1-PJ.ellps.es)*n;
  dd  := sqr(xy.x/n);
  result.phi:=ph1-(n*tan(ph1)/rho)*dd*(0.5-(1+3*t)*dd/24);
  result.lam:=(xy.x/n)*(1+t*dd*(0.2*(1+3*t)*dd-1)/3)/cos(ph1);
end;


function sCassForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
  result.x:=arcsin(cos(lp.phi)*sin(lp.lam));
  result.y:=arctan2(tan(lp.phi),cos(lp.lam))-PJ.C0.phi;
end;

function sCassInverse(XY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := arcsin(sin(xy.y+PJ.C0.phi) * cos(xy.x));
 result.lam := arctan2(tan(xy.x), cos(xy.y+PJ.C0.phi));
end;


procedure InitCassini(var PJ : TCustomProj);
begin
 if IsInfinite(PJ.C0.phi) then PJ.C0.phi:=0;
 case byte(pj.ellps.es<>0) of
  1: begin
      PJ.PM.EN := pj_enfn(pj.ellps.es);
      PJ.PM.A := pj_mlfn(PJ.C0.phi, sin(PJ.C0.phi), cos(PJ.C0.phi),PJ.PM.en);
      PJ.fForward:=eCassForward;
      PJ.fInverse:=eCassInverse;
     end;
 0:  begin
      PJ.fForward:=sCassForward;
      PJ.fInverse:=sCassInverse;
     end;
 end;
end;

function OrthoForward(LP: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var coslam, cosphi, sinphi : double;
begin
  sinphi := sin(lp.phi);
  cosphi := cos(lp.phi);
  coslam := cos(lp.lam);
  case PJ.PM.mode of
   2: if cosphi*coslam>=-1E-10 then result.y:=sinphi;
   3: if sin(PJ.C0.phi)*sinphi+cos(PJ.C0.phi)* cosphi * coslam>=1e-10 then
      result.y := cos(PJ.C0.phi)*sinphi-sin(PJ.C0.phi)*cosphi*coslam;
   0,1: if abs(lp.phi-PJ.C0.phi)-1e-10<=HALFPI then
        result.y := cosphi*coslam*(1-2*byte(PJ.PM.mode=0));
  end;
  result.x := cosphi * sin(lp.lam);

end;

function OrthoInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var rh, cosc, sinc : double;
    XY: T3dPoint;
begin
 XY   := pntXY;
 rh   := hypot(xy.x, xy.y);
 sinc := rh;
 if abs(sinc-1)<=1E-10 then sinc:=1;
 if Abs(sinc)>1 then exit;
 cosc := sqrt(1-sqr(sinc)); // in this range OK //

 if abs(rh)<=1e-10 then
 begin
  result.phi := PJ.C0.phi;
  result.lam := 0.0;
  exit;
 end;

 case PJ.PM.mode of
  0:  begin
       xy.y   := -xy.y;
       result.phi := arccos(sinc);
      end;
  1: result.phi := - arccos(sinc);
  2: begin
      result.phi := xy.y*sinc/ rh;
      xy.x := xy.x*sinc;
      xy.y := cosc * rh;
     end;
  3: begin
      result.phi := cosc *sin(PJ.C0.phi) + xy.y * sinc *cos(PJ.C0.phi)/rh;
      xy.y := (cosc-sin(PJ.C0.phi)*result.phi) * rh;
      xy.x := xy.x*sinc *cos(PJ.C0.phi);
     end;
 end; // case
 if PJ.PM.mode in [2,3] then result.phi := aasin(result.phi);
 result.lam := arctan2(xy.x, xy.y);

end;

procedure InitOrthoGraphic(var PJ : TCustomProj);
begin
 if abs(abs(PJ.C0.phi)-HALFPI)<=1e-10 then PJ.PM.mode:=byte(PJ.C0.phi<0) else
 PJ.PM.mode:=2+byte(abs(PJ.C0.phi)>1e-10);
 PJ.fForward:=OrthoForward;
 PJ.fInverse:=OrthoInverse;
 PJ.ellps.es:=0;
end;


function AiryForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var cosz,t, rho,_phi,_php : double;
    _mode,_cut  : byte;
begin
 _php:=HALFPI*(1-2*byte(PJ.C0.phi<0));
 _mode:=PJ.PM.mode and $0F;
 _cut :=byte(PJ.PM.mode>$10);
 case _Mode of
  2,3: begin
        cosz := cos(lp.phi) * cos(lp.lam);
	if PJ.PM.mode=3 then cosz := sin(PJ.C0.phi)*sin(lp.phi)+cos(PJ.C0.phi)*cosz;
        if (_cut=1) and (cosz < -1e-10) then exit;

        if abs(1-cosz)>1e-10 then
        begin
         t    := 0.5 * (1. + cosz);
         rho := -ln(t)/(1-cosz)-PJ.PM.Cp/ t;
	end else
        rho := 0.5-PJ.PM.Cp;
        result.x := rho * cos(lp.phi) * sin(lp.lam);
        if PJ.PM.mode=3 then
        result.y := rho*(cos(PJ.C0.phi)*sin(lp.phi)-sin(PJ.C0.phi)*cos(lp.phi)*cos(lp.lam)) else
	result.y := rho * sin(lp.phi);
       end;
  0,1: begin
	_phi := abs(_php-lp.phi);
        if (_cut=1) and (_phi-1e-10>HALFPI) then exit;
        _phi := 0.5*_phi;
        if lp.phi > 1e-10 then
        begin
         t   := tan(_phi);
         rho := -2*(ln(cos(_phi))/t+t*PJ.PM.Cp);
         result.x := rho * sin(lp.lam);
         result.y := rho * cos(lp.lam);
         if PJ.PM.mode=0 then result.y := -result.y;
	end else
        result:=NullPoint;
      end;
 end;
end;


procedure InitAiry(var PJ : TCustomProj;Bb : double;const Cutted : byte = 0);
var beta : double;
begin
 if IsInfinite(Bb) then  beta := 0.5*HALFPI else   // lat_b
 beta := 0.5 * (HALFPI-Bb);
 if (abs(beta)<1e-10) then PJ.PM.Cp := -0.5 else
 PJ.PM.Cp := sqr(1/tan(beta))*ln(cos(beta));
 case byte(abs(abs(PJ.C0.phi)-HALFPI)<1e-10) of
  1: PJ.PM.mode:=byte(PJ.C0.phi<0);
  0: PJ.PM.mode:=3-byte(abs(PJ.C0.phi)<1e-10);
 end;
 PJ.PM.mode:=$10*Cutted+PJ.PM.mode;
 PJ.fForward:=AiryForward;
 PJ.Ellps.Es:=0;
end;


function Wink1Forward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
begin
 result.x := 0.5*PntLP.lam*(PJ.PM.A+cos(PntLP.phi));
 result.y := PntLP.phi;
end;

function Wink1Inverse(PntXY : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
begin
 result.phi := PntXY.y;
 result.lam := 2*PntXY.x/(PJ.PM.A+cos(result.phi));
end;

const
 TWO_D_PI=0.636619772367581343;

function Wink2Forward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
var k, V : double;
    i    : integer;
    lp   : T3dPoint;
begin
 lp :=  PntLP;
 result.y := lp.phi * TWO_D_PI;
 k := PI * sin(lp.phi);
 lp.phi := 1.8*lp.phi;
 for i:=10 downto 0 do
 begin
  V := (lp.phi+sin(lp.phi)-k)/(1+cos(lp.phi));
  lp.phi := lp.phi-V;
  if (abs(V)<1e-7) then	break;
 end;
 if i=0 then lp.phi := pi*(1-2*byte(lp.phi<0))/2 else
 lp.phi := lp.phi*0.5;
 result.x := 0.5 * lp.lam * (cos(lp.phi) + PJ.PM.A);
 result.y := FORTPI * (sin(lp.phi) + result.y);
end;


procedure InitWink1(var PJ : TCustomProj; Bts:double);
begin
  PJ.Bts:=Bts;
  if IsInfinite(PJ.Bts) then PJ.PM.A:=1 else
  PJ.PM.A        := cos(PJ.Bts);
  PJ.fForward    := Wink1Forward;
  PJ.fInverse    := Wink1Inverse;
end;

procedure InitWink2(var PJ : TCustomProj; B1:double);
begin
  PJ.B1:=B1;
  if IsInfinite(PJ.B1) then PJ.PM.A:=1 else
  PJ.PM.A     := cos(PJ.B1);
  PJ.fForward := Wink2Forward;
  PJ.fInverse := nil;
end;

// ********** van der Grinten (I) *********
function  Vandg1Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var al,g,g2,p2:double;
begin
 p2:=abs(pntBL.phi/HALFPI);
 pj.errno:=-byte(p2-TOL>1);
 if pj.errno<>0 then exit;
 if p2>1 then p2:=1;
 result.x:=pntBL.lam;
 result.y:=0;
 if (abs(pntBL.phi)<=TOL) then exit;
 with result do
 case byte((abs(pntBL.lam)<=TOL)or(abs(p2-1)<TOL)) of
  1: begin
      x:=0;
      y:=PI*tan(0.5*arcsin(p2));
      if pntBL.phi<0 then y:=-y;
     end;
  0: begin
      al:=0.5*abs(PI/pntBL.lam-pntBL.lam/PI);
      g:=sqrt(1-p2*p2);
      g:=g/(p2+g-1);
      g2:=sqr(g);
      p2:=sqr(g*(2/p2-1));
      x:=g-p2;
      g:=p2+sqr(al);
      x:=PI*(al*x+sqrt(sqr(al)*sqr(x)-g*(g2-p2)))/g;
      if (pntBL.lam<0) then x:=-x;
      y:=1-abs(x/PI)*(abs(x/PI)+2*al);
      if (y<-TOL) then pj.errno:=-1;
      if (y<0) then y:=0 else y:=sqrt(y)*PI*(1-2*byte(pntBL.phi<0));
    end;
  end;
end;


function Vandg1Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var t,c0,c1,c2,c3,al,r2,r,m,d,ay,x2,y2: double;
begin
 x2:=pntXY.x*pntXY.x;
 ay:=abs(pntXY.y);
 case byte(ay<TOL) of
 1: begin
     result.phi:=0.0;
     t:=x2*x2+19.73920880217871723738*(x2+4.93480220054467930934);
     case byte(abs(pntXY.x)<=TOL) of
      1: result.lam:=0.0;
      0: result.lam:=0.5*(x2-9.86960440108935861869+sqrt(t))/pntXY.x;
     end;
    end;
 0: begin
     y2:=pntXY.y*pntXY.y;
     r:=x2+y2;
     r2:=r*r;
     c1:=-PI*ay*(r+9.86960440108935861869);
     c3:=r2+TWOPI*(ay*r+PI*(y2+PI*(ay+HALFPI)));
     c2:=c1+9.86960440108935861869*(r-3*y2);
     c0:=PI*ay;
     c2:=c2/c3;
     al:=c1/c3-c2*c2/3;
     m:=2.*sqrt(-al/3);
     d:=2*c2*c2*c2/27+(c0*c0-c2*c1/3)/c3;
     d:=3*d/(al*m);
     t:=abs(d);
     if t-TOL<=1 then
     begin
      case byte(t>1) of
       1: d:=PI*byte(d>0);
       0: d:=arccos(d);
      end;
     result.phi:=PI*(m*cos(d/3+4.18879020478639098458)-c2/3);
     if pntXY.y<0  then result.phi:=-result.phi;
     t:=r2+19.73920880217871723738*(x2-y2+4.93480220054467930934);
     case byte(abs(pntXY.x)>TOL) of
      0: result.lam:=0;
      1: result.lam:=0.5*(r-9.86960440108935861869+asqrt(t))/pntXY.x;
     end;
     end else
     pj.errno:=-1;
    end;
  end;
end;


function  Vandg23Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var x1,at,bt,ct : double;
begin
 bt:=abs(0.63661977236758134308*pntBL.phi);
 ct:=asqrt(1-bt*bt);
 with result do
 case byte(abs(pntBL.lam)<TOL) of
  1: begin
      x:=0;
      y:=PI*(1-2*byte(pntBL.phi<0))*bt/(1.+ct);
     end;
  0: begin
      at:=0.5*abs(PI/pntBL.lam-pntBL.lam/PI);
      case PJ.PM.mode of
       // van der Grinten III
       1: begin
           x1:=bt/(1+ct);
           x:=PI*(sqrt(at*at+1-x1*x1)-at);
           y:=PI*x1;
          end;
       // van der Grinten II
       0: begin
           x1:=(ct*sqrt(1.+at*at)-at*ct*ct)/(1.+at*at*bt*bt);
           x:=PI*x1;
           y:=PI*sqrt(1.-x1*(x1+2.*at)+TOL);
          end;
      end;
      if(pntBL.lam<0) then x:=-x;
      if(pntBL.phi<0) then y:=-y;
     end;
  end;
end;


function  Vandg4Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var x1,t,bt,ct,ft,bt2,ct2,dt,dt2 : double;
begin
 result.x:=pntBL.lam;
 result.y:=0;
 if (abs(pntBL.phi)<=TOL) then exit;
 with result do
 case byte((abs(pntBL.lam)<=TOL) or (abs(abs(pntBL.phi)-HALFPI)<TOL)) of
  1: begin
      x:=0;
      y:=pntBL.phi;
     end;
  0: begin
      bt:=abs(0.63661977236758134308*pntBL.phi);
      bt2:=bt*bt;
      ct:=0.5*(bt*(8-bt*(2+bt2))-5)/(bt2*(bt-1));
      ct2:=ct*ct;
      dt:=0.63661977236758134308*pntBL.lam;
      dt:=dt+1./dt;
      dt:=sqrt(dt*dt-4);
      if((abs(pntBL.lam)-HALFPI)<0) then dt:=-dt;
      dt2:=dt*dt;
      x1:=bt+ct;
      x1:=x1*x1;
      t:=bt+3*ct;
      ft:=x1*(bt2+ct2*dt2-1)+(1-bt2)*(bt2*(t*t+4*ct2)+ct2*(12*bt*ct+4*ct2));
      x1:=(dt*(x1+ct2-1)+2*sqrt(ft))/(4.*x1+dt2);
      x:=HALFPI*x1;
      y:=HALFPI*sqrt(1+dt*abs(x1)-x1*x1);
      if (pntBL.lam<0) then x:=-x;
      if (pntBL.phi<0) then y:=-y;
     end;
  end;
end;



procedure InitVandGriten(var PJ : TCustomProj;vType : TVandNumb);
begin
 PJ.PM.mode:=vType;
 case vType of
  1: begin
      PJ.fForward:= Vandg1Forward;
      PJ.fInverse:= Vandg1Inverse;
     end;
  2,3: begin
      PJ.PM.mode:=PJ.PM.mode-1;
      PJ.fForward:= Vandg23Forward;
      PJ.fInverse:= nil;
     end;
  4: begin
      PJ.fForward:= Vandg4Forward;
      PJ.fInverse:= nil;
     end;
  end;
end;


 
function Eck1Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 0.92131773192356127802*pntBL.lam*(1- 0.31830988618379067154*abs(pntBL.phi));
 result.y := 0.92131773192356127802*pntBL.phi;
end;

function Eck2Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y:=sqrt(4-3*sin(abs(pntBL.phi)));
 result.x:=0.46065886596178063902*pntBL.lam*result.y;
 result.y:=1.44720250911653531871*(2-result.y);
 if (pntBL.phi<0) then result.y:=-result.y;
end;


function Eck1Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid1
begin
 result.phi := pntXY.y/0.92131773192356127802;
 result.lam := pntXY.x/(0.92131773192356127802*(1-0.31830988618379067154*abs(result.phi)));
end;


function Eck2Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := 2-abs(pntXY.y)/1.44720250911653531871;
 result.lam := pntXY.x /(0.46065886596178063902*result.phi);
 result.phi := (4-sqr(result.phi))/3;
 pj.errno:=-1;
 if abs(result.phi)>1.0000001 then exit;
 pj.errno:=0;
 result.phi := arcsin(result.phi);
 if pntXY.y<0 then result.phi := -result.phi;
end;

// ************** eck3 ****************
function Eck3Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := 0.84447640063154240298*pntBL.phi;
 result.x := 0.42223820031577120149* pntBL.lam*(1+asqrt(1-0.4052847345693510857755*sqr(pntBL.phi)));
end;

function Eck3Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := pntXY.y/0.84447640063154240298;
 result.lam := pntXY.x/(0.42223820031577120149*(1+asqrt(1-0.4052847345693510857755*sqr(result.phi))));
end;

// ************** eck4 ****************

function Eck4Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var  V,s,c,p : double;
     i       : integer;
     lp      : T3dPoint;
begin
 lp:= pntBL;
 p := 3.57079632679489661922*sin(lp.phi);
 lp.phi := lp.phi*(0.895168+sqr(lp.phi)*(0.0218849+sqr(lp.phi)*0.00826809));
 for i:=6 downto 0 do
 begin
  c := cos(lp.phi);
  s := sin(lp.phi);
  V :=(lp.phi+s*(c+2)-p)/(1+c*(c+2)-s*s);
  lp.phi := lp.phi-V;
  if (abs(V)<1e-7) then break;
 end;
 if (i=0) then
 begin
  result.x := 0.42223820031577120149* lp.lam;
  result.y := 1.32650042817700232218*Sign(lp.phi);
 end else
 begin
  result.x := 0.42223820031577120149*lp.lam*(1+cos(lp.phi));
  result.y := 1.32650042817700232218*sin(lp.phi);
 end;
end;

function Eck4Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 with result do
 begin
  phi:=aasin(pntXY.y/1.32650042817700232218);
  lam:=pntXY.x/(0.42223820031577120149*(1.+(cos(phi))));
  phi:=aasin((phi+sin(phi)*(cos(phi)+2))/3.57079632679489661922);
 end;
end;

// eck5

function Eck5Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 0.44101277172455148219*(1+cos(pntBL.phi))*pntBL.lam;
 result.y := 0.88202554344910296438*pntBL.phi;
end;

function Eck5Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi :=1.13375401361911319568*pntXY.y;
 result.lam :=2.26750802723822639137*pntXY.x/(1+cos(result.phi));
end;



// ************** Kav7  ****************
function Kav7Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := pntBL.phi;
 result.x := 0.8660254037844*pntBL.lam*asqrt(1-0.30396355092701331433*sqr(pntBL.phi));
end;

function Kav7Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := pntXY.y;
 result.lam := pntXY.x/(0.8660254037844*asqrt(1-0.30396355092701331433*sqr(result.phi)));
end;

procedure InitKav7(var PJ : TCustomProj);
begin
 PJ.fForward:= Kav7Forward;
 PJ.fInverse:= Kav7Inverse;
end;

//PROJ_HEAD(krovak, "Krovak") "\n\tPCyl., Sph.";

{ NOTE:
    According to EPSG, the complete Krovak design method should have the
    following parameters.
    Within PROJ.4, the azimuth and pseudo standard parallel are hard coded
    in the algorithm and cannot be changed externally.
    Others all have defaults to fit common use with Krovak projection.

  lat_0 = latitude of CS start
  lon_0 = longitude of CS start
  ** = True azimuth from center line through CS center
  ** = Width of standard pseudo-parallel
  k  = unit standard pseudo-parallel
  x_0 = 0 if the eastern hemisphere
  y_0 = 0 if northern hemisphere }

function KrovakForward(pntBL: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
  // Constants, identical to inverse transform function
var  alfa, uq, u0, g, k, k1, n0, ro0, ad, s0,_es,_e,
    gfi, u, fi0, lon17, lamdd, deltav, s, d, eps, ro : double;
begin
  _es:=Ellipsoids[ellBessel].es;
  _e :=Ellipsoids[ellBessel].e;
  fi0:=PJ.C0.phi;              // Latitude of projection centre 49° 30'
  alfa:=sqrt(1+(_es*power(cos(fi0),4))/(1-_es));
  uq:=1.04216856380474;//DU(2,59,42,42.69689)
  u0:=arcsin(sin(fi0)/alfa);
  g:=power((1+_e*sin(fi0))/(1-_e*sin(fi0)),alfa*_e/2);
  k:=tan(u0/2+0.785398163397448)/power(tan(fi0/2+0.785398163397448),alfa)*g;
  k1:=PJ.k0;
  n0:=sqrt(1-_es)/(1-_es*power(sin(fi0),2));
  s0:=1.37008346281555;//Latitudeofpseudostandardparallel78°30'00"N
  ro0:=k1*n0/tan(s0);
  ad:=2*0.785398163397448-uq;
  // Transformation
  gfi:=power(((1+_e*sin(pntBL.phi))/(1-_e*sin(pntBL.phi))),(alfa*_e/2));
  u:=2*(arctan(k*power(tan(pntBL.phi/2+0.785398163397448),alfa)/gfi)-0.785398163397448);
  deltav:=-pntBL.lam*alfa;
  s:=arcsin(cos(ad)*sin(u)+sin(ad)*cos(u)*cos(deltav));
  d:=arcsin(cos(u)*sin(deltav)/cos(s));
  eps:=sin(s0)*d;
  ro:=ro0*power(tan(s0/2+0.785398163397448),sin(s0))/power(tan(s/2+0.785398163397448),sin(s0));
   // x and y are reverted!
  _e:=Ellipsoids[ellBessel].a/PJ.Ellps.A;
  result.y:=ro*cos(eps)*_e;
  result.x:=ro*sin(eps)*_e;
end;


function KrovakInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var fi0,alfa,uq,u0,g,k,n0,ro0,ad,s0,a, _es,_e,
    u,l24,lamdd,deltav,s,d,eps,ro,fi1,lon17 : double;
    xy : T3dPoint;
    cnt  : integer;
begin
// calculate lat/lon from xy
// Constants, identisch wie in der Umkehr function
 fi0:=PJ.C0.phi;

 _es:=Ellipsoids[ellBessel].es;
 _e :=Ellipsoids[ellBessel].e;
 alfa:=sqrt(1+(_es*power(cos(fi0),4))/(1-_es));
 uq:=1.04216856380474;
 u0:=arcsin(sin(fi0)/alfa);
 g:=power((1+_e*sin(fi0))/(1-_e*sin(fi0)),alfa*_e/2);
 k:=tan(u0/2+0.785398163397448)/power(tan(fi0/2+0.785398163397448),alfa)*g;
 n0:=sqrt(1-_es)/(1-_es*power(sin(fi0),2));
 s0:=1.37008346281555;  //Latitude of pseudo standard parallel  78°30'00"N
 ro0:=PJ.k0*n0/tan(s0);
 ad:=2*0.785398163397448-uq;
 // Transformation revert y, x
 xy.X:=PntXY.Y; xy.Y:=PntXY.X;
 ro:=sqrt(xy.x*xy.x+xy.y*xy.y);
 eps:=arctan2(xy.y, xy.x);
 d:=eps/sin(s0);
 s:=2*(arctan(power(ro0/ro,1/sin(s0))*tan(s0/2+0.785398163397448))-0.785398163397448);
 u:=arcsin(cos(ad)*sin(s)-sin(ad)*cos(s)*cos(d));
 deltav:=arcsin(cos(s)*sin(d)/cos(u));
 result.lam:=PJ.C0.lam-deltav/alfa;
 // ITERATION FOR lp.phi
 fi1:=u; cnt:=0;
 repeat
  inc(cnt);
  result.phi:=2*(arctan(power(k,-1/alfa)*power(tan(u/2+0.785398163397448),1/alfa)*
              power((1+_e*sin(fi1))/(1-_e*sin(fi1)),_e/2))-0.785398163397448);
  if abs(fi1-result.phi)<1E-14 then break;
  fi1:=result.phi;
 until cnt>100;
 result.lam := result.lam-PJ.C0.lam;
end;


procedure InitKrovak(var PJ : TCustomProj;Bts : double);
begin
 PJ.Bts:=Bts;
 PJ.k0:=0.9999;
// read some Parameters, here Latitude Truescale
 if IsInfinite(PJ.Bts) then PJ.PM.Cx:=0 else
 PJ.PM.Cx:=PJ.Bts;
 // if latitude of projection center is not set, use 49d30'N
 if IsInfinite(PJ.C0.phi) or (PJ.C0.phi=0) then PJ.C0.phi:=0.863937979737193;
 // if center long is not set use 42d30'E of Ferro - 17d40' for Ferro
 // that will correspond to using longitudes relative to greenwich
 // as input and output, instead of lat/long relative to Ferro
 if IsInfinite(PJ.C0.lam) or (PJ.C0.lam=0) then PJ.C0.lam:=0.4334234309119251;
 // if scale not set default to 0.9999


 PJ.fForward:=KrovakForward;
 PJ.fInverse:=KrovakInverse;
end;

{#ifndef lint
static const char SCCSID[]="@(#)PJ_chamb.c	4.1	94/02/15	GIE	REL";
#endif
//typedef struct { double r, Az; ) VECT;
#define PROJ_PARMS__ \
	struct { /* control point data */ \
		double phi, lam; \
		double cosphi, sinphi; \
		VECT v; \
		XY	p; \
		double Az; \
	) c[3]; \
	XY p; \
	double beta_0, beta_1, beta_2;
#define PJ_LIB__
#include	<projects.h>
PROJ_HEAD(chamb, "Chamberlin Trimetric") "\n\tMisc Sph, no inv."
"\n\tlat_1= lon_1= lat_2= lon_2= lat_3= lon_3=";
#include	<stdio.h>
#define THIRD 0.333333333333333333
#define TOL 1e-9
}


// law of cosines */

function ChambForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // spheroid
var sinp, cosp, a : double;
    V   : array[0..2] of TPJVector;
    i,j :integer;
begin
  // dist/azimiths from control
  for i:=0 to 2 do
  with PJ.Other.Chamb.PT[i] do
  begin
   V[i]:=_vect(lp.phi-P.phi,cp,sp,cos(lp.phi),sin(lp.phi),lp.lam-P.lam);
   if v[i].r=0 then break;
   v[i].Az := adjlon(V[i].Az-Vec.Az);
   result:=P;
  end;
  // current point at control point */
  if i<3 then exit;
  // point mean of intersepts
  result := PJ.Other.Chamb.Base;
  with PJ.Other.Chamb do
  for i:=0 to 2 do
  begin
   j:=(i+1) mod 3;
   a := GetLC(PT[i].Vec.r,V[i].r,V[j].r);
   if V[i].Az<0 then a := -a;
   case i of
    // coord comp unique to each arc */
    0: begin
     //   a := PT[0].beta-a;
        result.x := result.x+v[i].r*cos(a);
        result.y := result.y-v[i].r*sin(a);
       end;
    1: begin
        a := PT[1].beta-a;
        result.x := result.x-v[i].r*cos(a);
        result.y := result.y-v[i].r*sin(a);
       end;
    2: begin
        a := PT[2].beta-a;
        result.x:=result.x+v[i].r*cos(a);
        result.y:=result.y+v[i].r*sin(a);
       end;
   end; // case

  end;
  //result.x := result.x/3; // mean of arc intercepts */
 // result.y := result.y/3;

end;

  //+lat_1=10 +lon_1=10 +lat_2=20 +lon_2=20 +lat_3=20 +lon_3=10

// 3- reference points
procedure InitChamberlin(var PJ : TCustomProj;P0,P1,P2:T3dPoint);
var i, j : integer;
begin
  if IsInfinite(PJ.C0.lam) then PJ.C0.lam:=0;
  FillChar(PJ.Other.Chamb,SizeOf(PJ.Other.Chamb),0);
  // 3- reference points
  with PJ.Other.Chamb do
  begin
   PT[0].P:=p0;
   PT[1].P:=p1;
   PT[2].P:=p2;
   for i := 0 to 2 do
   with PT[i] do
   begin
    P.lam := adjlon(P.lam-PJ.C0.lam);
    cp    := cos(P.phi);
    sp    := sin(P.phi);
   end;

   pj.errno:=-25;
   for i := 0 to 2 do
   with PT[i] do
   // inter ctl pt. distances and azimuths
   begin
    j:=(i+1) mod 3;
    Vec := _vect(PT[j].P.phi-P.phi, cp,sp,PT[j].cp,PT[j].sp,PT[j].P.lam-P.lam);
    if Vec.r=0 then exit;
   // co-linearity problem ignored for now */
   end;
   pj.errno:=0;


   PT[0].beta   := GetLC(PT[0].Vec.r,PT[2].Vec.r,PT[1].Vec.r);
   PT[1].beta   := GetLC(PT[0].Vec.r,PT[1].Vec.r,PT[2].Vec.r);
   PT[2].beta   := PI - PT[0].beta;

   {
   P->c[1].p.y = P->c[2].v.r * sin(P->beta_0)
   P->c[0].p.y = P->c[1].p.y
   P->p.y = 2. * ( P->c[0].p.y );
   P->c[2].p.y = 0.;      }

   PT[1].P.y := PT[2].Vec.r* sin(PT[0].beta);
   PT[0].P.y := PT[1].P.y;
   Base.y    := 2*PT[0].P.y;
   PT[2].P.y := 0;

   {
    P->c[1].p.x = 0.5 * P->c[0].v.r
    P->c[0].p.x = - P->c[1].p.x ;
    P->c[2].p.x = P->c[0].p.x + P->c[2].v.r * cos(P->beta_0);
    P->p.x = P->c[2].p.x
   }

   PT[1].P.x := 0.5*PT[0].Vec.r;
   PT[0].P.x := -PT[1].P.x;
   PT[2].P.x := PT[0].P.x+PT[2].Vec.r*cos(PT[0].beta);
   PT[2].P.x := PT[2].P.x;
  end;
  PJ.Ellps.es := 0;
  PJ.fForward := ChambForward;
end;

{#ifndef lint
static const char SCCSID[]="@(#)PJ_imw_p.c	4.1	94/05/22	GIE	REL";
#endif
#define PROJ_PARMS__ \
        double	P, Pp, Q, Qp, R_1, R_2, sphi_1, sphi_2, C2; \
	double	phi_1, phi_2, lam_1; \
	double	*en; \
	int	mode; /* = 0, phi_1 and phi_2 != 0, = 1, phi_1 = 0, = -1 phi_2 = 0 */
#define PJ_LIB__
#include	<projects.h>
PROJ_HEAD(imw_p, "International Map of the World Polyconic")
	"\n\tMod. Polyconic, Ell\n\tlat_1= and lat_2= [lon_1=]";
#define TOL 1e-10
#define EPS 1e-10
}


function loc_for(lp:T3dPoint;PJ:PCustomProj;var yc:double): T3dPoint;
var m,R,t,xa,xb,ya,yb,sp,xc,c,d,b : double;
begin
  result.x := lp.lam;
  result.y := 0;
  if lp.phi=0 then exit;
  sp := sin(lp.phi);
  m := pj_mlfn(lp.phi, sp, cos(lp.phi), PJ.PM.en);

  xa := PJ.PM.B + PJ.PM.D * m;
  ya := PJ.PM.A + PJ.PM.C * m;
  R :=1/(tan(lp.phi)*sqrt(1-PJ.Ellps.es * sqr(sp)));
  C := sqrt(R*R-sqr(xa));
  if (lp.phi<0) then C := - C;
  C := C+ ya - R;

  if PJ.PM.mode < 0 then
  begin
   xb := lp.lam;
   yb := PJ.PM.Cp;
  end else
  begin
   t  := lp.lam * PJ.PM.Cy;
   xb := PJ.PM.rho0 * sin(t);
   yb := PJ.PM.Cp + PJ.PM.rho0 * (1- cos(t));
  end;
  if PJ.PM.mode > 0 then
  begin
   xc := lp.lam;
   yc := 0;
  end else
  begin
   t  := lp.lam * PJ.PM.Cx;
   xc := PJ.PM.rho * sin(t);
   yc := PJ.PM.rho * (1- cos(t));
  end;
  D := (xb - xc)/(yb - yc);
  B := xc + D * (C + R - yc);
  result.x:=D*asqrt(R*R*(1+D*D)-B*B);
  if (lp.phi > 0)then result.x := - result.x;
  result.x := (B + result.x) / (1 + D * D);
  result.y := asqrt(R*R-sqr(result.x));
  if (lp.phi > 0) then result.y := - result.y;
  result.y := result.y+C+R;
end;


function IMWPolyForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // ellipsoid
var yc : double;
begin
 yc:=0;
 result := loc_for(lp,PJ,yc);
end;

function IMWPolyInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;  // ellipsoid
var yc : double;
    t  : T3dPoint;
    cnt : integer;
begin
 yc:=0;    cnt:=0;
 result.phi := PJ.B2;
 result.lam := xy.x/cos(PJ.B2);
 for cnt:=0 to 255 do
 begin
  t := loc_for(result,PJ,yc);
  result.phi:=((result.phi-PJ.B1)*(xy.y-yc)/(t.y-yc))+PJ.B1;
  if t.x=0 then
  begin
   result.lam:=1/0;
   break;
  end;
  result.lam:=result.lam*xy.x/t.x;
  if (abs(t.x-xy.x)<1e-10) or (abs(t.y-xy.y)<1e-10) then Break;
 end;
end;

//   +lon_1=10
procedure InitIMWPolyconic(var PJ : TCustomProj;B1,B2,L1:double);
var del, sig, x1, x2, T2, y1, m1, m2, y2 : double;
begin
  PJ.b1:=b1;
  PJ.b2:=b2;
  PJ.l1:=L1;

  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  if pj.errno<>0 then exit;
  del    := 0.5*(B2-B1);
  sig    := 0.5*(B2+B1);
  pj.errno := byte(abs(del)<1e-10)-42*byte(abs(sig)<1e-10);
  if pj.errno<>0 then exit;


  PJ.PM.en := pj_enfn(PJ.Ellps.es);
  if (Pj.b2<Pj.b1) then // make sure P->phi_1 most southerly (SWAP paralel)
  begin
   del   := Pj.b1;
   Pj.b1 := Pj.b2;
   Pj.b2 := del;
  end;

  if IsInfinite(Pj.l1) then    // use predefined based upon latitude
  begin
   sig := abs(sig*180/pi);
   if sig<=60 then sig := 2 else
   if sig<=76 then sig := 4 else sig := 8;
   Pj.l1 := sig*pi/180;
  end;
  PJ.PM.mode := 0;

  if Pj.b1=0 then
  begin
    PJ.PM.mode := 1;
    y1   := 0;
    x1   := Pj.l1;
  end else
  begin
   PJ.PM.Cx := sin(Pj.b1);
   PJ.PM.rho := 1/(tan(Pj.b1)*sqrt(1-PJ.Ellps.es*sqr(PJ.PM.Cx)));
   y1 := PJ.PM.rho * (1 - cos(L1*PJ.PM.Cx));
   x1 := PJ.PM.rho * sin(Pj.l1*PJ.PM.Cx);
  end;

  if Pj.b2=0 then
  begin
    PJ.PM.mode := -1;
    t2   := 0;
    x2   := Pj.l1;
  end else
  begin
   PJ.PM.Cy := sin(Pj.b2);
   PJ.PM.rho0 := 1/(tan(Pj.b2)*sqrt(1-PJ.Ellps.es*sqr(PJ.PM.Cy)));
   T2 := PJ.PM.rho0 * (1 - cos(Pj.l1*PJ.PM.Cy));
   x2 := PJ.PM.rho0 * sin(Pj.l1*PJ.PM.Cy);
  end;

   m1:=pj_mlfn(Pj.b1,PJ.PM.Cx,cos(Pj.b1),PJ.PM.en);
   m2:=pj_mlfn(Pj.b2,PJ.PM.Cy,cos(Pj.b2),PJ.PM.en);
   y2:=sqrt(sqr(m2-m1)-sqr(x2-x1))+y1;
  PJ.PM.Cp:=y2-T2;
  PJ.PM.A:=(m2*y1-m1*y2)/(m2-m1);
  PJ.PM.C:=(y2-y1)/(m2-m1);
  PJ.PM.B:=(m2*x1-m1*x2)/(m2-m1);
  PJ.PM.D:=(x2-x1)/(m2-m1);

  PJ.fInverse := IMWPolyInverse;
  PJ.fForward := IMWPolyForward;

end;




function BipcForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var  cphi, sphi, cdlam, sdlam, tphi, t, al, Az, z, Av, r : double;
     tag : smallint;
begin
  cphi := cos(lp.phi);
  sphi := sin(lp.phi);
  cdlam := cos(-0.34894976726250681539-lp.lam);
  sdlam := sin(-0.34894976726250681539-lp.lam);
  
  case byte(abs(abs(lp.phi)- HALFPI)<1e-10) of
   1: begin
       Az   := byte(lp.phi<0)*PI;
       tphi := 1/0;
      end;
   0: begin
       tphi := sphi / cphi;
       Az   := arctan2(sdlam,0.70710678118654752469*(tphi - cdlam));
      end;
  end;
  tag := 1-2*byte(Az<=1.82261843856185925133);
   case tag of
   1: begin
       cdlam := cos(lp.lam+1.9198621771937625336);
       sdlam := sin(lp.lam+1.9198621771937625336);
       z     := aacos(0.93969262078590838411*cphi*cdlam-0.34202014332566873287*sphi);
       if not IsInfinite(tphi) then
       Az := arctan2(sdlam,(0.93969262078590838411*tphi+0.34202014332566873287*cdlam));
       Av       := 0.81650043674686363166;
      end;
   -1:begin
       z  := aacos(0.7071067811865475241* (sphi + cphi * cdlam));
       Av := 1.82261843856185925133;
      end;
  end;
  result.y :=tag*1.20709121521568721927;
  if z<0 then exit;
  t  := power(tan(0.5*z),0.63055844881274687180);
  r  := 1.89724742567461030582* t;
  al := 0.5 * (1.81514242207410275904 - z);
  if al<0 then exit;
  al := aacos((t + power(al, 0.63055844881274687180))/1.2724657826708901227);

  t  := 0.63055844881274687180 * (Av - Az);
  if abs(t)<al then r := r/cos(al+t*tag);
  result.x := r * sin(t);
  result.y := result.y-tag*r*cos(t);

  if PJ.south<>0 then
  begin
   t := result.x;
   result.x:=-result.x*0.69691523038678375519-result.y*0.71715351331143607555;
   result.y:=-result.y*0.69691523038678375519+t*0.71715351331143607555;
  end;
end;



function BipcInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var xy  : T3dPoint;
    t,_c,_s,_av, az,al,
    r,rp,rl,z : double;
    neg,i : smallint;
begin
  xy:=PntXY;
  if PJ.south<>0 then
  begin
    t    := xy.x;
    xy.x := -xy.x*0.69691523038678375519+xy.y*0.71715351331143607555;
    xy.y := -xy.y*0.69691523038678375519-t*0.71715351331143607555;
  end;
  neg := 1-2*byte(xy.x>=0);
  case neg of
   1:begin
      xy.y := 1.20709121521568721927-xy.y;
      _s   := -0.34202014332566873287;
      _c   := 0.93969262078590838411;
      _Av  := 0.81650043674686363166;
     end;
  -1:begin
      xy.y := 1.20709121521568721927+xy.y;
      _s   := 0.7071067811865475241;
      _c   := 0.70710678118654752469;
      _Av  := 1.82261843856185925133;
     end;
  end;
  r  := hypot(xy.x, xy.y);
  rp :=r; rl:=r;
  Az := arctan2(xy.x, xy.y);

  for i:=10 downto 0 do
  begin
   z  := 2*arctan(power(r/1.89724742567461030582,1/0.6305584488127468718));
   al := arccos((power(tan(0.5*z),0.6305584488127468718)+
         power(tan(0.5*(1.81514242207410275904-z)),0.63055844881274687180))/1.2724657826708901227);
   if abs(az)<al then r:=rp*cos(al+neg*Az);
   if  abs(rl-r)<1e-10 then break;
   rl:=r;
  end;

  if i<=0 then exit;
  Az         := _Av-Az/0.6305584488127468718;
  result.phi := arcsin(_s*cos(z)+_c*sin(z)*cos(Az));
  result.lam := arctan2(sin(Az),_c/tan(z)-_s*cos(Az));
  case neg of
    1: result.lam:=result.lam-1.9198621771937625336;
   -1: result.lam:=-0.34894976726250681539-result.lam;
  end;
end;

procedure InitBipc(var PJ : TCustomProj);
begin
 // judging by the result - if given then the Southern hemisphere
 PJ.Ellps.es:=0;
 PJ.fForward:=BipcForward;
 PJ.fInverse:=BipcInverse;
end;


function lccForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint;
var rho : double;
begin
 pj.errno:=-1;
  if (abs(abs(pntBL.phi)-pi/2)<1E-10) then
  begin
   if (pntBL.phi*PJ.PM.A)<0 then exit;
   rho := 0;
  end else
  case byte(PJ.Ellps.es<>0) of
   1: rho := PJ.PM.c*power(pj_tsfn(pntBL.phi, sin(pntBL.phi),PJ.Ellps.e),PJ.PM.A);
   0: rho := PJ.PM.c*power(tan(FORTPI+0.5*pntBL.phi),-PJ.PM.A)
  end;
  result.x := PJ.k0*(rho*sin(pntBL.lam*PJ.PM.A));
  result.y := PJ.k0*(PJ.PM.rho0-rho*cos(pntBL.lam*PJ.PM.A));
  pj.errno:=0;
end;


function lccInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint;
var xy  : T3dPoint;
    rho : double;
begin
  xy.x := pntXY.x/PJ.k0;
  xy.y := PJ.PM.rho0-pntXY.y/PJ.k0;
  rho  := hypot(xy.x,xy.y);
  if rho=0.0 then
  begin
   result.X := 0;
   result.Y := pi/2-pi*byte(PJ.PM.A<0);
   exit;
  end;

  if (PJ.PM.A<0) then
  begin
   rho := -rho;
   xy.x := -xy.x;
   xy.y := -xy.y;
  end;
  case byte(PJ.Ellps.es<>0) of
   1: result.phi := pj_phi2(power(rho/PJ.PM.c, 1/PJ.PM.A), PJ.Ellps.e,pj.errno);
   0: result.phi := 2*arctan(power(PJ.PM.c/rho, 1/PJ.PM.A)) - pi/2;
  end;
  result.lam := arctan2(xy.x, xy.y)/PJ.PM.A;
end;

procedure lccSpecial(pntLP : T3dPoint;PJ : PCustomProj);
var rho : double;
begin
  if (abs(abs(pntLP.phi) - HALFPI)<1e-10) then
  begin
   if (pntLP.phi*PJ.PM.A)<=0 then exit;
   rho := 0;
  end else
  case byte(PJ.Ellps.es<>0) of
   1: rho := PJ.PM.c*power(pj_tsfn(pntLP.phi, sin(pntLP.phi),PJ.Ellps.e),PJ.PM.A);
   0: rho := PJ.PM.c*power(tan(0.78539816339744833+0.5*pntLP.phi),-PJ.PM.A);
  end;
  PJ.Fact.code := PJ.Fact.Code or (IS_ANAL_HK + IS_ANAL_CONV);
  PJ.Fact.k    := PJ.k0*PJ.PM.A*rho/pj_msfn(Sin(pntLP.phi),cos(pntLP.phi),PJ.Ellps.es);
  PJ.Fact.h    := PJ.Fact.k;
  PJ.Fact.conv := -PJ.PM.A * pntLP.lam;
end;


procedure InitLCC(var PJ : TCustomProj; B1,B2 : double);
var  cosphi,sinphi,
    ml1, m1 : double;
    secant  : byte;
begin
 PJ.B1:=B1;  PJ.B2:=B2;
 if PJ.k0=0             then PJ.k0:=1;
 if IsInfinite(PJ.B1) then PJ.B1:=0;
 if IsInfinite(PJ.B2) then
 begin
  PJ.B2:=B1;
  PJ.C0.phi:=B1;
 end else
 PJ.B2:=B2;


 pj.errno:=-21;
 if (abs(PJ.B1+PJ.B2)<1e-10) then exit;
 PJ.PM.A:= sin(PJ.B1);
 sinphi := PJ.PM.A;
 cosphi := cos(PJ.B1);
 secant := byte(abs(PJ.B1-PJ.B2)>=1e-10);


 with PJ.PM do
  case byte(PJ.Ellps.es<>0) of
   1: begin
       m1  := pj_msfn(sinphi, cosphi, PJ.Ellps.es);
       ml1 := pj_tsfn(PJ.B1, sinphi, PJ.Ellps.e);
       // secant cone
       if secant=1 then
       begin
        sinphi := sin(PJ.B2);
        A:=ln(m1/pj_msfn(sinphi,cos(PJ.B2),PJ.Ellps.es))/
        ln(ml1/pj_tsfn(PJ.B2,sinphi,PJ.Ellps.e));
       end;
       rho0:=m1*power(ml1,-A)/A;  c := rho0;
       case abs(abs(PJ.C0.phi)-HALFPI)>1e-10 of
        true : rho0:=rho0*power(pj_tsfn(PJ.C0.phi, sin(PJ.C0.phi),PJ.Ellps.e),A);
        false: rho0:=0;
       end;
     end;

  0: begin
      if secant=1 then A:=ln(cosphi/cos(PJ.B2))/ln(tan(FORTPI+0.5*PJ.B2)/tan(FORTPI+0.5*PJ.B1));
      c := cosphi*power(tan(FORTPI+0.5*PJ.B1),A)/A;
      case abs(abs(PJ.C0.phi)-HALFPI)>1e-10 of
       true : rho0:=c*power(tan(FORTPI +0.5*PJ.C0.phi),-A);
       false: rho0:=0;
      end;
     end;
  end;
 pj.errno:=0;
 PJ.fForward:= lccForward;
 PJ.fInverse:= lccInverse;
 PJ.fSpecial:= lccSpecial;
end;


{
#define LINE2 "\n\tConic, Sph\n\tlat_1= and lat_2="
PROJ_HEAD(tissot, "Tissot")
	LINE2;
PROJ_HEAD(murd1, "Murdoch I")
	LINE2;
PROJ_HEAD(murd2, "Murdoch II")
	LINE2;
PROJ_HEAD(murd3, "Murdoch III")
	LINE2;
PROJ_HEAD(euler, "Euler")
	LINE2;
PROJ_HEAD(pconic, "Perspective Conic")
	LINE2;
PROJ_HEAD(vitk1, "Vitkovsky I")
	LINE2;
/* get common factors for simple conics */
	static int }



function sConicsForward(Lp : T3dPoint; PJ:PCustomProj): T3dPoint; // spheroid
begin
  with PJ.PM do
  begin
  case mode of
   2: rho := A + tan(Cp-lp.phi);
   4: rho := Cy * (Cx - tan(lp.phi));
   else
    rho := A - lp.phi;
  end;
  result.x := rho * sin(lp.lam*B);
  result.y := rho0 - rho * cos(lp.lam*B);
  end;
end;


function sConicsInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint; // ellipsoid & spheroid
var xy: T3dPoint;
    _rho : double;
begin
  xy.x:=PntXY.x;
  xy.y:=PJ.PM.rho0-PntXY.y;
  _rho := hypot(xy.x, xy.y);
  if PJ.PM.B<0  then
  begin
   _rho  := - _rho;
   xy.x := - xy.x;
   xy.y := - xy.y;
  end;
  result.lam := arctan2(xy.x, xy.y)/PJ.PM.B;
  with PJ.PM do
  case mode of
   2: result.phi := Cp - arctan(_rho - A);
   4: result.phi := arctan(Cx-_rho/Cy) + Cp;
   else
    result.phi := A -_rho;
  end;
end;

procedure InitTissot(var PJ:TCustomProj;B1,B2: double);
var delta, cs : double;
begin
  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  PJ.B1:=B1;  PJ.B2:=B2;
  if pj.errno=0 then pj.errno:=phi12(PJ,delta);
  if pj.errno<>0 then exit;
  with PJ.PM do
  begin
   mode :=5;
   B    := sin(Cp);
   cs   := cos(delta);
   A    := B / cs + cs / B;
   rho0 := sqrt((A - 2 * sin(PJ.C0.phi))/B);
  end;
  PJ.fInverse := sConicsInverse;
  PJ.fForward := sConicsForward;
  PJ.Ellps.es := 0;
end;

procedure InitMurdoch(var PJ:TCustomProj;prNo: TMurdochMode; B1,B2: double);
var delta, cs : double;
begin
  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  PJ.B1:=B1;  PJ.B2:=B2;
  if pj.errno=0 then pj.errno:=phi12(PJ,delta);
  if pj.errno<>0 then exit;
  with PJ.PM do
  case prNo of
  1: begin
      mode :=1;
      A    := sin(delta)/(delta * tan(Cp)) + Cp;
      rho0 := A - PJ.C0.phi;
      B    := sin(Cp);
     end;
  2: begin
      mode :=2;
      cs   := sqrt(cos(delta));
      A   := cs/tan(Cp);
      rho0 := A + tan(Cp - PJ.C0.phi);
      B    := sin(Cp) * cs;
     end;
  3: begin
      mode := 3;
      A    := delta/(tan(Cp)*tan(delta))+Cp;
      rho0 := A-PJ.C0.phi;
      B    := sin(Cp)*sin(delta)*tan(delta)/sqr(delta);
     end;
  end;
  PJ.fInverse := sConicsInverse;
  PJ.fForward := sConicsForward;
  PJ.Ellps.es := 0;
end;

procedure InitEuler(var PJ:TCustomProj;B1,B2: double);
var delta, cs : double;
begin
  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  PJ.B1:=B1;  PJ.B2:=B2;
  if pj.errno=0 then pj.errno:=phi12(PJ,delta);
  if pj.errno<>0 then exit;
  with PJ.PM do
  begin
   mode :=0;
   B    := sin(Cp) * sin(delta)/delta;
   delta:= delta/2;
   A   := delta / (tan(delta) * tan(Cp)) + Cp;
   rho0 := A - PJ.C0.phi;
  end;
  PJ.fInverse := sConicsInverse;
  PJ.fForward := sConicsForward;
  PJ.Ellps.es := 0;
end;

procedure InitPerspConic(var PJ:TCustomProj;B1,B2: double);
var delta, cs : double;
begin
  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  PJ.B1:=B1;  PJ.B2:=B2;
  if pj.errno=0 then pj.errno:=phi12(PJ,delta);
  if pj.errno<>0 then exit;
  with PJ.PM do
  begin
   mode :=4;
   B    := sin(Cp);
   Cy   := cos(delta);
   Cx   := 1/tan(Cp);
   delta:= PJ.C0.phi - Cp;
   pj.errno:=-43*byte(abs(delta)-1e-10>= HALFPI);
   if pj.errno<>0 then exit;
   rho0 := Cy * (Cx - tan(delta));
  end;
  PJ.fInverse := sConicsInverse;
  PJ.fForward := sConicsForward;
  PJ.Ellps.es := 0;
end;

procedure InitVitkovsky(var PJ:TCustomProj;B1,B2: double);
var delta, cs : double;
begin
  pj.errno:=-41*byte(IsInfinite(B1) or IsInfinite(B2));
  PJ.B1:=B1;  PJ.B2:=B2;
  if pj.errno=0 then pj.errno:=phi12(PJ,delta);
  if pj.errno<>0 then exit;
  with PJ.PM do
  begin
   cs   := tan(delta);
   B    := cs* sin(Cp) / delta;
   A    := delta/(cs * tan(Cp)) + Cp;
   rho0 := A - PJ.C0.phi;
  end;
  PJ.fInverse := sConicsInverse;
  PJ.fForward := sConicsForward;
  PJ.Ellps.es := 0;
end;




function LaborForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid & spheroid
var I : array[1..6] of double;
    V1,V2,ps,t : double;
begin
 with PJ.PM do
 begin
  V1     := A*ln( tan(FORTPI+0.5*lp.phi));
  t      := PJ.ellps.e* sin(lp.phi);
  V2     := 0.5*PJ.ellps.e*A*ln((1+t)/(1-t));
  ps     := 2*(arctan(exp(V1-V2+C))-FORTPI);
  I[1]   := ps-D;
  I[4]   := A * cos(ps);
  I[2]   := 0.5*A*I[4]*sin(ps);
  I[3]   := I[2]*sqr(A)*(5*sqr(cos(ps))-sqr(sin(ps)))/12;
  I[6]   := I[4]*sqr(A);
  I[5]   := I[6]* (sqr(cos(ps))-sqr(sin(ps)))/6;
  I[6]   := I[6]*sqr(A)*(5*power(cos(ps),4)+power(sin(ps),4)-18*sqr(sin(ps)*cos(ps)))/120;
  t        := sqr(lp.lam);
  result.x := B*lp.lam*(I[4]+t*(I[5]+t*I[6]));
  result.y := B*(I[1]+t*(I[2]+t*I[3]));
  V1       := 3*result.x*sqr(result.y)-power(result.x,3);
  V2       := power(result.y,3)-3*sqr(result.x)*result.y;
  result.x := result.x+Cx*V1+Cy*V2;
  result.y := result.y+Cx*V2-Cy*V1;
 end;
end;


function LaborInverse(PntXY : T3dPoint;PJ : PCustomProj):T3dPoint;// ellipsoid & spheroid
var I : array[1..5] of double;
    V : array[1..4] of double;
    ps,pe,tpe,s,
    x2,y2,t : double;
    XY      : T3dPoint;
    j       : integer;
begin
  pj.errno:=-1;

  xy   := PntXY;
  x2   := xy.x*xy.x;
  y2   := xy.y*xy.y;
  V[1] := 3*xy.x*y2-xy.x*x2;
  V[2] := xy.y*y2-3.*x2*xy.y;
  V[3] := xy.x*(5*y2*y2+x2*(x2-10*y2));
  V[4] := xy.y*(5*x2*x2+y2*(y2-10*x2));
  with PJ.PM do
  begin
  xy.x := xy.x-Cx*V[1]-Cy*V[2]+G*V[3]+Cp*V[4];
  xy.y := xy.y+Cy*V[1]-Cx*V[2]-Cp*V[3]+G*V[4];
  ps   := D+xy.y/B;
  pe   := ps+PJ.C0.phi-D;
  for j:=20 downto 0 do
  begin
   V[1]:= tan(FORTPI+0.5*pe);
   if V[1]<0 then exit;
   V[1]:= A*ln(V[1]);
   tpe := PJ.ellps.e*sin(pe);
   V[2]:= 0.5*PJ.ellps.e*A*ln((1+tpe)/(1-tpe));
   t   := ps-2*(arctan(exp(V[1]-V[2]+C))-FORTPI);
   pe  := pe+t;
   if abs(t)<1e-10 then	break;
  end;
  t     := 1-sqr(PJ.ellps.e*sin(pe));
  tpe   := PJ.ellps.one_es/(t*sqrt(t)); //Re
  t     := tan(ps);
  s     := sqr(B);
  d     := tpe*PJ.k0*B;
  I[1]  := t/(2*d);
  I[2]  := t*(5+3*t*t)/(24*d*s);
  d     := cos(ps)*A*B;
  I[3]  := 1/d;
  d     := d*s;
  I[4]  := (1+2*t*t)/(6*d);
  I[5]  := (5+t*t*(28+24*t*t))/(120*d*s);
  x2    :=xy.x*xy.x;
  result.phi:=pe+x2*(-I[1]+I[2]*x2);
  result.lam:=xy.x*(I[3]+x2*(-I[4]+x2*I[5]));
  end;
  pj.errno:=0;
end;

procedure InitLaborde(var PJ : TCustomProj;Azimuth:double);
var sinp,t,R,_N : double;
begin
 PJ.k0:=1;
 if IsInfinite(PJ.C0.phi) or (PJ.C0.phi=0) then exit;
 with PJ.PM do
 begin
  sinp := sin(PJ.C0.phi);
  t    := 1-PJ.Ellps.es*sinp*sinp;
  _n   := 1/sqrt(t);
  R    := PJ.Ellps.one_es*_n/ t;
  B    := PJ.k0*sqrt(_n*R);
  D    := arctan(sqrt(R/_n)*tan(PJ.C0.phi));
  A    := sinp/sin(D);
  t    := PJ.Ellps.e*sinp;
  C    := 0.5*PJ.Ellps.e*A*ln((1+t)/(1-t))-A*ln(tan(FORTPI+0.5*PJ.C0.phi))+ln(tan(FORTPI+0.5*D));
  Cy   := 1/(12*sqr(B));
  Cx   := (1-cos(2*Azimuth))*Cy;
  Cy   := Cy*sin(2*Azimuth);
  G    := 3*(sqr(Cx)-sqr(Cy));
  Cp   := 6*Cx*Cy;
 end;
 PJ.fInverse := LaborInverse;
 PJ.fForward := LaborForward;
end;


{ifndef lint
static const char SCCSID[]="@(#)PJ_nsper.c	4.1	94/02/15	GIE	REL";
#endif
PROJ_HEAD(nsper, "Near-sided perspective") "\n\tAzi, Sph\n\th=";
PROJ_HEAD(tpers, "Tilted perspective") "\n\tAzi, Sph\n\ttilt= azi= h=";
# define EPS10 1.e-10
}


function PerspForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
var coslam, cosphi, sinphi : double;
begin
  sinphi := sin(lp.phi);
  cosphi := cos(lp.phi);
  coslam := cos(lp.lam);
  case PJ.PM.mode of
   3: result.y := sin(PJ.C0.phi)*sinphi+cos(PJ.C0.phi)*cosphi*coslam;
   2: result.y := cosphi * coslam;
   1: result.y := - sinphi;
   0: result.y := sinphi;
  end; //case
  if result.y<PJ.PM.B then exit;
  result.y := PJ.PM.C/(PJ.PM.Cp-result.y);
  result.x := result.y * cosphi * sin(lp.lam);
  case PJ.PM.mode of
   3: result.y:=result.y*(cos(PJ.C0.phi)*sinphi-sin(PJ.C0.phi)* cosphi*coslam);
   2: result.y:=result.y*sinphi;
 0,1: result.y:=result.y*cosphi*coslam*(1+2*(PJ.PM.mode-1));
  end; // case

 { if PJ.Other.Titled>0 then
  begin
   sinphi   := result.y*cos(Pj.PM.G)+result.x*sin(Pj.PM.G);
   cosphi   := 1/(sinphi*sin(Pj.PM.A)*PJ.PM.He+cos(Pj.PM.A));
   result.x := (result.x*cos(Pj.PM.G)-result.y*sin(Pj.PM.G))*cos(Pj.PM.A)*cosphi;
   result.y := sinphi*cosphi;
  end;  }

end;

function PerspInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint; // spheroid
var   rh, cosz, sinz : double;
      XY : T3dPoint;
begin

  xy:=PntXY;
  with PJ.PM do
  begin
  {
  if PJ.Other.Titled>0 then
  begin
   sinz := 1/(n-xy.y *sin(Pj.PM.A));
   rh   := n*xy.x*sinz;
   cosz := n*xy.y*cos(Pj.PM.A)* sinz;
   xy.x := rh*cos(Pj.PM.G)+cosz *sin(Pj.PM.G);
   xy.y := cosz *cos(Pj.PM.G)-rh *sin(Pj.PM.G);
  end;
          }
  rh   := hypot(xy.x, xy.y);
  sinz := 1-rh*rh*rho;
  if sinz<0 then exit;
  sinz := (Cp-sqrt(sinz))/(C/rh+rh/C);
  cosz := sqrt(1-sinz*sinz);

  if abs(rh)<= 1e-10 then
  begin
   result.lam := 0;
   result.phi := PJ.C0.phi;
   exit;
  end;
  case mode of
  3: begin
      result.phi := arcsin(cosz*sin(PJ.C0.phi)+xy.y*sinz*cos(PJ.C0.phi)/rh);
      xy.y := (cosz-sin(PJ.C0.phi)* sin(result.phi))*rh;
      xy.x := xy.x*sinz*cos(PJ.C0.phi);
     end;
  2: begin
      result.phi := arcsin(xy.y * sinz / rh);
      xy.y  := cosz*rh;
      xy.x  := xy.x*sinz;
     end;
  0: begin
      result.phi := arcsin(cosz);
      xy.y   := -xy.y;
     end;
  1: result.phi := - arcsin(cosz);
 end;
 end;
 result.lam := arctan2(xy.x, xy.y);
end;


procedure InitPerspective(var PJ : TCustomProj;H,Gamma,Omega:double; Titled : boolean);
begin
 PJ.Other.Titled:=byte(Titled);
 pj.errno:=-30*byte(H<=0);
 if pj.errno<>0 then exit;
 with PJ.PM do
 begin
  if abs(PJ.C0.phi-HALFPI)<1E-10 then mode:=byte(PJ.C0.phi<0) else
  mode:=3-byte(abs(PJ.C0.phi)<1E-10);
  C   := H/PJ.Ellps.a; // normalize by radius */
  Cp  := 1+C;
  B   := 1/Cp;
  rho := (Cp+1)/C;
  G   := Gamma;
  A   := Omega;
 end;
 PJ.fInverse := PerspInverse;
 PJ.fForward := PerspForward;
 PJ.Ellps.es:=0;
end;


function AEPolyForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // ellipsoid
var ms : double;
begin
  result.x := lp.lam;
  result.y := -PJ.PM.A;
  if abs(lp.phi)>1e-10 then
  begin
   ms  := 0;
   if abs(cos(lp.phi))>1e-10 then ms:=pj_msfn(sin(lp.phi),cos(lp.phi),PJ.ellps.es)/sin(lp.phi);
   result.x:=ms*sin(lp.lam*sin(lp.phi));
   result.y:=(pj_mlfn(lp.phi,sin(lp.phi),cos(lp.phi),PJ.PM.en)-PJ.PM.A)+ms*(1-cos(lp.lam*sin(lp.phi)));
  end;
end;

function AEPolyInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint; // ellipsoid
var XY   : T3dPoint;
    C,rho,mlp,ml,mlb,s2ph,dPhi,_phi: double;
    i : integer;
begin
  xy   := PntXY;
  xy.y := xy.y+PJ.PM.A;
  result.lam := xy.x;
  result.phi := 0;
  if abs(xy.y)<=1e-10 then exit;
  pj.errno :=-1;
  rho      := xy.y*xy.y+xy.x*xy.x;
  _phi     := xy.y;
  for i := 20 downto 0 do
  begin
   s2ph  := sin(_phi)*cos(_phi);
   if abs(cos(_phi))<1e-12 then exit;
   mlp   := sqrt(1-PJ.ellps.es*sqr(sin(_phi)));
   c     := sin(_phi)*mlp/cos(_phi);
   ml    := pj_mlfn(_phi,sin(_phi),cos(_phi),PJ.PM.en);
   mlb   := ml*ml+rho;
   mlp   := PJ.ellps.one_es/(mlp*mlp*mlp);
   dPhi := (ml+ml+c*mlb-2*xy.y*(c*ml+1))/(PJ.ellps.es*s2ph*(mlb-2.*xy.y*ml)/c+
           2*(xy.y-ml)*(c*mlp-1/s2ph)-mlp-mlp);
   _phi  := _phi+dPhi;
   if abs(dPhi)<=1e-12 then break;
 end; // for
 result.phi:=_phi;
 if i<=0 then exit;
 result.lam:=arcsin(xy.x*tan(_phi)*sqrt(1-PJ.ellps.es*sqr(sin(_phi))))/sin(_phi);
 pj.errno:=0;
end;

function ASPolyForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // spheroid
var ec : double;
begin
  result.x := lp.lam;
  result.y := PJ.PM.A;
  if abs(lp.phi)<=1e-10 then exit;
  EC := lp.lam * sin(lp.phi);
  result.x := sin(EC)*cotan(lp.phi);
  result.y := lp.phi-PJ.C0.phi+cotan(lp.phi)*(1-cos(EC));
end;

function ASPolyInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint;  // spheroid
var dphi,tp,b : double;
    i : integer;
    XY : T3dPoint;
begin
  XY := PntXY;
  result.lam := xy.x;
  result.phi := 0;
  xy.y := PJ.C0.phi+xy.y;
  if abs(xy.y)<=1e-10 then exit;
  result.phi := xy.y;
  B := xy.x*xy.x+xy.y*xy.y;
  for i:=10 downto 0 do
  begin
   tp  := tan(result.phi);
   dphi:=(xy.y*(result.phi*tp+1)-result.phi-0.5*(sqr(result.phi)+B)*tp)/((result.phi-xy.y)/tp-1);
   result.phi := result.phi-dphi;
   if abs(dphi)<=1e-10 then break;
  end;
  if i<=0 then exit;
  result.lam := arcsin(xy.x*tan(result.phi))/sin(result.phi);
end;

procedure InitPolyAmerican(var PJ : TCustomProj);
begin
 if IsInfinite(PJ.C0.phi) then PJ.C0.phi:=0;
 case byte(Pj.ellps.es<>0) of
  1: begin
      PJ.PM.en := pj_enfn(Pj.ellps.es);
      PJ.PM.A := pj_mlfn(PJ.C0.phi, sin(PJ.C0.phi), cos(PJ.C0.phi),PJ.PM.en);
      PJ.fInverse := AEPolyInverse;
      PJ.fForward := AEPolyForward;
    end;
  0: begin
      PJ.PM.A := -PJ.C0.phi;
      PJ.fInverse := ASPolyInverse;
      PJ.fForward := ASPolyForward;
     end;
 end;
end;



function EDCForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid  & ellipsoid
var rho : double;
begin
  case byte(PJ.Ellps.es<>0) of
   1: rho:=PJ.PM.c-pj_mlfn(lp.phi, sin(lp.phi),cos(lp.phi),PJ.PM.en);
   0: rho:=PJ.PM.c-lp.phi;
  end;
  result.x := rho*sin(lp.lam*PJ.PM.A);
  result.y := PJ.PM.rho0-rho*cos(lp.lam*PJ.PM.A);
end;

function EDCInverse(PntXY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid & ellipsoid
var xy : T3dPoint;
   rho : double;
begin
 xy.x := PntXY.x;
 xy.y := PJ.PM.rho0 - PntXY.y;
 rho := hypot(xy.x, xy.y);
 case byte(rho=0) of
  1: begin
      result.lam := 0.0;
      result.phi := (1-2*byte(PJ.PM.A>0))*HALFPI;
     end;
  0: begin
      if (PJ.PM.A<0) then
      begin
       rho  := -rho;
       xy.x := -xy.x;
       xy.y := -xy.y;
      end;
      result.phi := PJ.PM.c-rho;
      if PJ.Ellps.es<>0 then result.phi:= pj_inv_mlfn(result.phi,PJ.Ellps.es,PJ.PM.en,pj.errno);
      result.lam := arctan2(xy.x, xy.y)/PJ.PM.A;
     end;
 end; // case
end;

procedure EDCSpecial(lp:T3dPoint;PJ:PCustomProj);
var cosphi, sinphi : double;
begin
 sinphi := sin(lp.phi);
 cosphi := cos(lp.phi);
 with PJ^ do
 begin
  Fact.code := Fact.code or IS_ANAL_HK;
  Fact.h := 1;
  case byte(Ellps.es<>0) of
   1: Fact.k:=pj_mlfn(lp.phi, sinphi,cosphi,PJ.PM.en);
   0: Fact.k:=lp.phi;
  end;
  Fact.k := PJ.PM.A*(PJ.PM.c-Fact.k)/pj_msfn(sinphi,cosphi,Ellps.es);
 end;

end;



procedure InitEDC(var PJ : TCustomProj; B1,B2:double);
var cosphi, sinphi,ml1, m1 : double;
    secant : byte;
begin
 PJ.B1:=b1;  PJ.B2:=b2;
 pj.errno:=-byte(IsInfinite(PJ.B1) or IsInfinite(PJ.B2));
 if pj.errno=0 then pj.errno:=-21*byte(abs(PJ.B1+PJ.B2)<1E-10);
 if pj.errno<>0 then exit;
 with PJ.PM do
 begin
 en  := pj_enfn(PJ.Ellps.es);
 sinphi := sin(PJ.B1);
 A      := sinphi;
 cosphi := cos(PJ.B1);
 secant := byte(abs(PJ.B1-PJ.B2)>=1E-10);
 case byte(PJ.Ellps.es<>0) of
  1: begin
      m1  := pj_msfn(sinphi, cosphi,PJ.Ellps.es);
      ml1 := pj_mlfn(PJ.B1, sinphi, cosphi,en);
      if secant=1 then
      begin // secant cone */
       sinphi := sin(PJ.B2);
       cosphi := cos(PJ.B2);
       A := (m1-pj_msfn(sinphi,cosphi,PJ.Ellps.es))/(pj_mlfn(PJ.B2,sinphi,cosphi,en)-ml1);
      end;
      C    := ml1+m1/A;
      rho0 := c-pj_mlfn(PJ.C0.phi,sin(PJ.C0.phi),cos(PJ.C0.phi),en);
     end;
  0: begin
      if secant=1 then A:=(cosphi-cos(PJ.B2))/(PJ.B2-PJ.B1);
      c    := PJ.B1+cos(PJ.B1)/A;
      rho0 := c - PJ.C0.phi;
     end;
 end;
 end;
 Pj.fForward:=EDCForward;
 Pj.fInverse:=EDCInverse;
 Pj.fSpecial:=EDCSpecial;
end;

// Ellipsoidal Sinusoidal only //
function GnSinuEllpsForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; //ellipsoid
begin
  result.y := pj_mlfn(lp.phi,sin(lp.phi),cos(lp.phi),PJ.PM.en);
  result.x := lp.lam * cos(lp.phi)/ sqrt(1- PJ.Ellps.es *sqr(sin(lp.phi)));
end;

function GnSinuEllpsInverse(xy : T3dPoint;PJ:PCustomProj): T3dPoint; //ellipsoid
begin
  result.phi := pj_inv_mlfn(xy.y,PJ.Ellps.es,PJ.PM.en,pj.errno);
  if (abs(result.phi) < HALFPI) then
  result.lam := xy.x * sqrt(1-PJ.Ellps.es *sqr(sin(result.phi)))/cos(result.phi) else
  if Abs(result.phi)-1e-10 < HALFPI then result.lam := 0 else
  pj.errno:=-1;
end;

// General spherical sinusoidals //
function GnSinuSphForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // sphere
var phi,k,V : double;
    i   : integer;
begin
 phi:=lp.phi;
 case byte(PJ.PM.A=0) of
  1: if PJ.PM.B=1 then phi:=aasin(PJ.PM.B*sin(lp.phi));
  0: begin
      k:=PJ.PM.B*sin(phi);
      for i:=8 downto 0 do
      begin
       V:=(PJ.PM.A*phi+sin(phi)-k)/(PJ.PM.A+cos(phi));
       phi := phi-V;
       if (abs(V)<1e-7) then break;
      end;
     end;
 end;
 result.x := PJ.PM.Cx * lp.lam*(PJ.PM.A+cos(phi));
 result.y := PJ.PM.Cy * phi;
end;

function GnSinuSphInverse(xy : T3dPoint;PJ:PCustomProj): T3dPoint; //sphere
begin
  with PJ.PM do
  case byte(PJ.PM.A=0) of
   0: result.phi:=aasin((PJ.PM.A* xy.y/Cy + sin(xy.y/Cy))/PJ.PM.B);
   1: if PJ.PM.B<>1 then result.phi:=xy.y/Cy else result.phi:=aasin(sin(xy.y/Cy)/PJ.PM.B);
  end;
  result.lam := xy.x/(PJ.PM.Cx * (PJ.PM.A+ cos(xy.y/PJ.PM.Cy)));
end;

// for spheres, only //
procedure SetupGnSinuSpheroid(var PJ : TCustomProj;N,M : double);
begin
 PJ.PM.A:=M; PJ.PM.B:=N;
 PJ.Ellps.es := 0;
 PJ.PM.Cy := sqrt((M+1)/N);
 PJ.PM.Cx := PJ.PM.Cy/(M+1);
 PJ.fForward:=GnSinuSphForward;
 PJ.fInverse:=GnSinuSphInverse;
end;

procedure InitGnSinu(var PJ : TCustomProj; dN,dM : double);
begin
 pj.errno:=-99*byte((dn=0) or isinfinite(dM));
 if pj.errno=0 then SetupGnSinuSpheroid(PJ,dN,dM);
end;


procedure InitMcSinusoidal(var PJ : TCustomProj);
begin
 SetupGnSinuSpheroid(PJ,1.785398163397448309615660845,0.5);
end;

procedure InitSinu(var PJ : TCustomProj);
begin
  case byte(PJ.Ellps.es<>0) of
   1: begin
       PJ.PM.en := pj_enfn(PJ.Ellps.es);
       PJ.fForward:=GnSinuEllpsForward;
       PJ.fInverse:=GnSinuEllpsInverse;
      end;
   0: SetupGnSinuSpheroid(PJ,1,0);
  end;
end;

// ************** Eckert I-V  ****************
procedure InitEckert(var PJ : TCustomProj;PjNo : TEckMode);
begin
 case PjNo of
  1: begin
      PJ.fForward:= Eck1Forward;
      PJ.fInverse:= Eck1Inverse;
     end;
  2: begin
      PJ.fForward:= Eck2Forward;
      PJ.fInverse:= Eck2Inverse;
     end;
  3: begin
      PJ.fForward:= Eck3Forward;
      PJ.fInverse:= Eck3Inverse;
     end;
  4: begin
      PJ.fForward:= Eck4Forward;
      PJ.fInverse:= Eck4Inverse;
     end;
  5: begin
      PJ.fForward:= Eck5Forward;
      PJ.fInverse:= Eck5Inverse;
     end;
  6: SetupGnSinuSpheroid(PJ,2.570796326794896619231321691,1);
 end;
end;


function OCEAForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // spheroid
var t : double;
begin
  result.y := sin(lp.lam);
  t:=cos(lp.lam);
  result.x:=arctan((tan(lp.phi)*PJ.PM.Cy+PJ.PM.Cx*result.y)/t);
  if t<0 then result.x:=result.x+PI;
  result.x:=result.x*PJ.PM.rho0;
  result.y:=PJ.PM.rho*(PJ.PM.Cx*sin(lp.phi)-PJ.PM.Cy*cos(lp.phi)*result.y);
end;

function OCEAInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint;  // spheroid
var t  : double;
    XY : T3dPoint;
begin
  xy.y := PntXY.y/PJ.PM.rho;
  xy.x := PntXY.x/PJ.PM.rho0;
  t    := sqrt(1-xy.y*xy.y);
  result.phi:=arcsin(xy.y*PJ.PM.Cx+t*PJ.PM.Cy*(sin(xy.x)));
  result.lam:=arctan2(t*PJ.PM.Cx*sin(xy.x)-xy.y*PJ.PM.Cy,t*cos(xy.x));
end;


procedure InitOCEA(var PJ : TCustomProj; Alpha,Bc:double);
var sb, cb : double;
begin

  pj.errno:=-byte(IsInfinite(Bc) or IsInfinite(Alpha) or (PJ.C0.phi=0));
  if pj.errno<>0 then exit;

  if PJ.k0=0 then PJ.k0:=1;
 
  PJ.Lc    := Bc;
  // they do not work with alpha !!!
  // alpha is set
  {   THEIR CODE (ALL)
  double phi_0=0.0, phi_1, phi_2, lam_1, lam_2, lonz, alpha;
  alpha	= pj_param(P->params, "ralpha").f;
  lonz = pj_param(P->params, "rlonc").f;
  P->singam = atan(-cos(alpha)/(-sin(phi_0) * sin(alpha))) + lonz;
  P->sinphi = asin(cos(phi_0) * sin(alpha));
  }
  // CODE MATCHING in Delphi

  with PJ.PM do
  begin
   rho     := PJ.Ellps.a/PJ.k0;
   rho0    := PJ.Ellps.a*PJ.k0;
   sb      := arctan(-cos(alpha)/(-sin(PJ.C0.phi)* sin(alpha)))+Bc;
   Cx      := arcsin(cos(PJ.C0.phi)*sin(alpha));
   PJ.C0.lam := sb+HALFPI;
   Cy      := cos(Cx);
   Cx      := sin(Cx);
  end;
  PJ.fInverse := OCEAInverse;
  PJ.fForward := OCEAForward;
  Pj.ellps.es:=0;
end;


procedure InitOCEA(var PJ : TCustomProj; B1,B2,L1,L2:double);
var sb, cb : double;
begin
  if PJ.k0=0 then PJ.k0:=1;
  PJ.PM.rho  := PJ.Ellps.a/PJ.k0;
  PJ.PM.rho0 := PJ.Ellps.a*PJ.k0;
  pj.errno:=-byte(IsInfinite(B1) or IsInfinite(B2) or
  IsInfinite(L1) or IsInfinite(L2));
  if pj.errno<>0 then exit;
  with PJ.PM do
  begin
   sb  :=arctan2(cos(B1)*sin(B2)*cos(L1)-sin(B1)*cos(B2)*cos(L2),
          sin(B1)*cos(B2)*sin(L2)- cos(B1)*sin(B2)*sin(L1));
   Cx := arctan(-cos(sb-L1)/tan(B1));
   PJ.C0.lam := sb+ HALFPI;
   Cy      := cos(Cx);
   Cx      := sin(Cx);
  end;
  PJ.fInverse := OCEAInverse;
  PJ.fForward := OCEAForward;
  Pj.ellps.es:=0;
end;



{#define Nbf 5
#define Ntpsi 9
#define Ntphi 8
#define SEC5_TO_RAD 0.4848136811095359935899141023
#define RAD_TO_SEC5 2.062648062470963551564733573
}

function NZForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //ellipsoid
var _phi : double;
     P   : TComplex;
     i   : integer;
{COMPLEX p;
	double *C;
	int i;    }
begin
 {
COMPLEX p;
	double *C;
	int i;

	lp.phi = (lp.phi - P->phi0) * RAD_TO_SEC5;
	for (p.r = *(C = tpsi + (i = Ntpsi)); i ; --i)
		p.r = *--C + lp.phi * p.r;
	p.r *= lp.phi;
	p.i = lp.lam;
	p = pj_zpoly1(p, bf, Nbf);
	xy.x = p.i;
	xy.y = p.r;
	return xy;
}
   _phi := (lp.phi-PJ.C0.phi)*2.062648062470963551564733573;
   p.r := nzTPsi[9];
   for i:=9 downto 1 do
   p.r:= nzTPsi[i-1]+_phi* p.r;

   p.r := p.r*_phi;
   p.i := lp.lam;
   p   := pj_zpoly1(p, CmpNZ);
   result.x := p.i;
   result.y := p.r;
end;

function NZInverse(XY: T3dPoint;PJ : PCustomProj):T3dPoint; //ellipsoid
var P,F,fp,dP : TComplex;
    nn,i : integer;
    den : double;
begin
 p.r := xy.y;
 p.i := xy.x;
 for nn:=20 downto 0 do
 begin
  f   := pj_zpolyd1(p,CmpNZ,fp);
  f.r := f.r-xy.y;
  f.i := f.i-xy.x;
  den := fp.r * fp.r + fp.i * fp.i;
  dp.r := -(f.r * fp.r + f.i * fp.i) / den;
  dp.i := -(f.i * fp.r - f.r * fp.i) / den;
  p.r := p.r + dp.r;
  p.i := p.i + dp.i;
  if ((abs(dp.r)+abs(dp.i))<= 1e-10) then break;
 end;

 if nn>=0 then
 begin
  result.lam := p.i;
  result.phi := nzTPhi[8];
  for i:=9 downto 1 do
  result.phi := nzTPhi[i-1]+p.r*result.phi;
  result.phi := PJ.C0.phi+p.r*result.phi*0.4848136811095359935899141023;
 end else
 result:=InfPoint;

end;

procedure InitNewZeland(var PJ : TCustomProj);
begin
// force to International major axis //
 PJ.Ellps.a:= 6378388.0;
 PJ.Ellps.ra:=1/PJ.Ellps.a;
 PJ.C0.lam := 173*pi/180;       // E173
 PJ.C0.phi := -41*pi/180;       // S41
 PJ.x0   := 2510000;
 PJ.y0   := 6023150;
 PJ.fForward:=NZForward;
 PJ.fInverse:=NZInverse;
end;


function ED2PntForward(lp: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var dl1,dl2,t,z1,z2,sp,cp : double;
begin
 sp := sin(lp.phi);
 cp := cos(lp.phi);
 dl1  := lp.lam + PJ.PM.G;
 dl2  := lp.lam - PJ.PM.G;
 z1   := sqr(aacos(sin(PJ.B1) * sp + cos(PJ.B1) * cp * cos(dl1)));
 z2   := sqr(aacos(sin(PJ.B2) * sp + cos(PJ.B2) * cp * cos(dl2)));
 result.x := PJ.PM.rho*(z1-z2);
 t    := PJ.PM.D -(z1-z2);
 result.y := PJ.PM.rho * asqrt(4*PJ.PM.D*z2-sqr(t));
 if PJ.PM.B*sp-cp *(cos(PJ.B1)*sin(PJ.B2)*sin(dl1)-sin(PJ.B1)*cos(PJ.B2)* sin(dl2))<0 then
 result.y := -result.y;
 pj.errno:=0;
end;


function ED2PntInverse(XY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var cz1, cz2, s, d, cp, sp : double;
begin
  cz1 := cos(hypot(xy.y, xy.x + PJ.PM.Cx));
  cz2 := cos(hypot(xy.y, xy.x - PJ.PM.Cx));
  s   := cz1 + cz2;
  d   := cz1 - cz2;
  result.lam := - arctan2(d, (s * PJ.PM.Cy));
  result.phi := aacos(hypot(PJ.PM.Cy * s, d) * PJ.PM.rho0);
  if xy.y<0 then result.phi := -result.phi;
  // lam--phi now in system relative to P1--P2 base equator //
  sp := sin(result.phi);
  cp := cos(result.phi);
  result.lam := result.lam-PJ.PM.Cp;
  s := cos(result.lam);
  result.phi := aasin(sin(PJ.PM.a) * sp + cos(PJ.PM.a) * cp * s);
  result.lam := arctan2(cp * sin(result.lam),sin(PJ.PM.a)* cp * s -cos(PJ.PM.a)* sp) + PJ.PM.C;
end;

//+proj=tpeqd +ellps=WGS84 +lat_1=31 +lat_2=52 +lon_1=10 +lon_2=20
procedure InitTwoPointED(var PJ : TCustomProj; b1,b2,l1,l2:double);
var _A : double;
begin
 // get control point locations //
 if IsInfinite(b1) then PJ.B1:=0 else PJ.B1:=b1;
 if IsInfinite(b2) then PJ.B2:=0 else PJ.B2:=b2;
 if IsInfinite(L1) then PJ.L1:=0 else PJ.L1:=l1;
 if IsInfinite(L2) then PJ.L2:=0 else PJ.L2:=l2;
 pj.errno:=-25*byte((PJ.B1=PJ.B2) and (PJ.L1=PJ.L2));
 if pj.errno<>0 then exit;
 PJ.C0.lam  := adjlon(0.5*(PJ.L1+PJ.L2));
 FillChar(PJ.PM, SizeOf(PJ.PM),0);
 with PJ.PM do
 begin
  G    := adjlon(PJ.L2-PJ.L1);
  B    := cos(PJ.B1)*cos(PJ.B2)*sin(G);
  D    := aacos(sin(PJ.B1)*sin(PJ.B2)+cos(PJ.B1)*cos(PJ.B2)*cos(G));
  Cx   := 0.5 * D;
  _A   := arctan2(cos(PJ.B2)*sin(G),cos(PJ.B1)*sin(PJ.B2)-sin(PJ.B1)*cos(PJ.B2)*cos(G));
  A    := aasin(cos(PJ.B1)*sin(_A));
  Cp   := adjlon(arctan2(cos(PJ.B1)*cos(_A),sin(PJ.B1))-Cx);
  G    := G/2;
  C    := HALFPI - arctan2(sin(_A)*sin(PJ.B1),cos(_A))-G;
  Cy   := tan(Cx);
  rho0 := 0.5/sin(Cx);
  rho  := 0.5/D;
  D    := sqr(D);
 end;
 PJ.fForward:=ED2PntForward;
 PJ.fInverse:=ED2PntInverse;
 PJ.Ellps.es:=0;
end;



{
#ifndef lint
static const char SCCSID[]="@(#)PJ_ob_tran.c	4.1	94/02/15	GIE	REL";
#endif
#define PROJ_PARMS__ \

#define PJ_LIB__
#include <projects.h>
#include <string.h>
PROJ_HEAD(ob_tran, "General Oblique Transformation") "\n\tMisc Sph"
"\n\to_proj= plus parameters for projection"
"\n\to_lat_p= o_lon_p= (new pole) or"
"\n\to_alpha= o_lon_c= o_lat_c= or"
"\n\to_lon_1= o_lat_1= o_lon_2= o_lat_2=";
#define TOL 1e-10    }

var
 Link : TCustomProj;

function GOTOForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;
var  coslam, sinphi, cosphi : double;
     lp  :   T3dPoint;
begin
 lp:=PntLP;
 coslam := cos(lp.lam);
 sinphi := sin(lp.phi);
 cosphi := cos(lp.phi);
 lp.lam := adjlon(aatan2(cosphi*sin(lp.lam),PJ.PM.Cx*cosphi*coslam+PJ.PM.Cy*sinphi)+PJ.PM.A);
 lp.phi := aasin(PJ.PM.Cx*sinphi-PJ.PM.Cy*cosphi*coslam);
 result:= Link.fForward(lp, @Link);
end;

function GOTTForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;
var cosphi, coslam : double;
     lp  :   T3dPoint;
begin
  lp    :=PntLP;
  cosphi := cos(lp.phi);
  coslam := cos(lp.lam);
  lp.lam := adjlon(aatan2(cosphi*sin(lp.lam), sin(lp.phi))+PJ.PM.A);
  lp.phi := aasin(-cosphi*coslam);
  result:= Link.fForward(lp, @Link);
end;

function GOTOInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;
var coslam, sinphi, cosphi : double;
begin
  result := Link.fInverse(xy, @Link);
  if not IsInfinite(result.lam) then
  begin
   result.lam := result.lam-PJ.PM.A;
   coslam := cos(result.lam);
   sinphi := sin(result.phi);
   cosphi := cos(result.phi);
   result.phi := aasin(PJ.PM.Cx*sinphi+PJ.PM.Cy*cosphi*coslam);
   result.lam := aatan2(cosphi*sin(result.lam),PJ.PM.Cx*cosphi*coslam-PJ.PM.Cy*sinphi);
  end;
end;

function GOTTInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;
var t, cosphi : double;
begin
  result := Link.fInverse(xy, @Link);
  if not IsInfinite(result.lam) then
  begin
   cosphi := cos(result.phi);
   t      := result.lam-PJ.PM.A;
   result.lam := aatan2(cosphi*sin(t),-sin(result.phi));
   result.phi := aasin(cosphi * cos(t));
  end;
end;

{#ifndef lint
static const char SCCSID[]="@(#)PJ_mod_ster.c	4.1	94/02/15	GIE	REL";
#endif
/* based upon Snyder and Linck, USGS-NMD */
#include	<projects.h>
PROJ_HEAD(mil_os, "Miller Oblated Stereographic") "\n\tAzi(mod)";
PROJ_HEAD(lee_os, "Lee Oblated Stereographic") "\n\tAzi(mod)";
PROJ_HEAD(gs48, "Mod. Stererographics of 48 U.S.") "\n\tAzi(mod)";
PROJ_HEAD(alsk, "Mod. Stererographics of Alaska") "\n\tAzi(mod)";
PROJ_HEAD(gs50, "Mod. Stererographics of 50 U.S.") "\n\tAzi(mod)";
#define     }

function mStereoForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid
var sinlon, coslon,
    esphi, chi,
    schi, cchi, s : double;
    P : TComplex;
begin
 sinlon := sin(lp.lam);
 coslon := cos(lp.lam);
 esphi  := PJ.Ellps.e * sin(lp.phi);
 chi    := 2*arctan(tan((HALFPI+lp.phi)*0.5)*power((1-esphi)/(1+esphi),PJ.Ellps.e*0.5))-HALFPI;
 schi   := sin(chi);
 cchi   := cos(chi);
 s      := 2/(1+PJ.PM.A*schi+PJ.PM.B*cchi*coslon);
 p.r    := s * cchi * sinlon;
 p.i    := s * (PJ.PM.B*schi-PJ.PM.A*cchi*coslon);
 case PJ.PM.mode of
  1: p := pj_zpoly1(p,cmpMiller);
  2: p := pj_zpoly1(p,CmpLeeOS);
  3: p := pj_zpoly1(p,Cmp48USA);
  4: p := pj_zpoly1(p,CmpEllpsGS50);
  5: p := pj_zpoly1(p,CmpShpGS50);
  6: p := pj_zpoly1(p,CmpEllpsAlaska);
  7: p := pj_zpoly1(p,CmpSphAlaska);
 end;
 result.x := p.r;
 result.y := p.i;
end;

function mStereoInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint; // ellipsoid
var	nn  : integer;
	p, fxy, fpxy, dp : TComplex;
	den, rh, z, sinz, cosz, chi,_phi, dphi, esphi: double;
begin
 p.r := XY.x; p.i := XY.y;
 pj.errno:=-1;
 for nn := 20 downto 0 do
 begin
  case PJ.PM.mode of
   0: exit;
   1: fxy := pj_zpolyd1(p,cmpMiller,fpxy);
   2: fxy := pj_zpolyd1(p,CmpLeeOS,fpxy);
   3: fxy := pj_zpolyd1(p,Cmp48USA,fpxy);
   4: fxy := pj_zpolyd1(p,CmpEllpsGS50,fpxy);
   5: fxy := pj_zpolyd1(p,CmpShpGS50,fpxy);
   6: fxy := pj_zpolyd1(p,CmpEllpsAlaska,fpxy);
   7: fxy := pj_zpolyd1(p,CmpSphAlaska,fpxy);
  end;
  fxy.r:=fxy.r-xy.x;
  fxy.i:=fxy.i-xy.y;
  den:=fpxy.r*fpxy.r+fpxy.i*fpxy.i;
  dp.r:=-(fxy.r*fpxy.r+fxy.i*fpxy.i)/den;
  dp.i:=-(fxy.i*fpxy.r-fxy.r*fpxy.i)/den;
  p.r:=p.r+dp.r;
  p.i:=p.i+dp.i;
  if (abs(dp.r)+abs(dp.i))<=1e-14 then break;
 end; // for
 pj.errno:=0;

 if nn<>-1 then
 begin
  rh := hypot(p.r, p.i);
  z  := 2* arctan(0.5 * rh);
  sinz := sin(z);
  cosz := cos(z);
  // normalization, PS: they don't have it
  // so at point X: 0 Y: 0 latitude and longitude are different from
  // latitude-longitude of the center of the CS for the whole HEMISPHERE !!!
  result.lam := 0;
  result.phi := PJ.C0.phi;
  if abs(rh)<=1e-10 then exit;
  chi := aasin(cosz*PJ.PM.A+p.i*sinz*PJ.PM.B/rh);
  _phi := chi;
  for nn := 20 downto 0 do
  begin
   esphi:=PJ.Ellps.e*sin(_phi);
   dphi:=2*arctan(tan((HALFPI+chi)*0.5)*power((1+esphi)/(1-esphi),PJ.Ellps.e/2))-HALFPI-_phi;
   _phi:=_phi+dphi;
   if abs(dphi)<=1e-14 then break;
  end;
 end;
 if nn<>-1 then
 begin
  result.phi:=_phi;
  result.lam:=arctan2(p.r*sinz,rh*PJ.PM.B*cosz-p.i*PJ.PM.A*sinz);
 end;
end;


procedure InitSpecStereo(var PJ:TCustomProj;pType: byte);
begin
  PJ.PM.mode:=pType+1;
  with PJ do
  case pType of
   // Miller Oblated Stereographic *** OK  ***
   0: begin
       C0.lam  := pi/9;      // 20
       C0.phi  := pi/10;     // 18
       Ellps.es := 0.0;
      end;
    // Lee Oblated Stereographic *** ERROR  ***
   1: begin
       C0.lam    := -165*pi/180; //-165
       C0.phi    := -pi/18;      //-10
       Ellps.es  := 0.0;
      end;
   // 48 United States ** OK  ***
   2: begin    
       C0.lam      := -DegToRad(96);
       C0.phi      := -DegToRad(39);
       Ellps.es  := 0.0;
       Ellps.a   := 6370997;
      end;
   // 50 United States ** ERROR  ***
   3: begin
       C0.lam      := -2*pi/3;   // -120
       C0.phi      := pi/4;      // 45
       PJ.PM.mode:= 5-byte(PJ.Ellps.es<>0);
       case byte(PJ.Ellps.es=0) of
       0: begin
           Ellps.a   := 6378206.4;
           Ellps.es  := 0.00676866;
           Ellps.e   := sqrt(0.00676866);
          end;
       1: Ellps.a    := 6370997.0;
       end;
      end;
      // Alaska ** ERROR  ***
   4: begin
       C0.lam := -DegToRad(152.0);
       C0.phi := DegToRad(64.0);
                 // fixed ellipsoid/sphere
       PJ.PM.mode  := 7-byte(PJ.Ellps.es<>0);
       case byte(PJ.Ellps.es=0) of
       0: begin
           Ellps.a   := 6378206.4;
           Ellps.es  := 0.00676866;
           Ellps.e   := sqrt(0.00676866);
          end;
       1: Ellps.a    := 6370997.0;
       end;
      end;
  end;
 //general initialization
  with PJ.PM do
  case byte(PJ.Ellps.es=0) of
  0: begin
      A := PJ.Ellps.e*sin(PJ.C0.phi);
      B := 2*arctan(tan((HALFPI+PJ.C0.phi)*0.5)*power((1-A)/(1+A),PJ.Ellps.e*0.5))-HALFPI;
     end;
  1: A := PJ.C0.phi;
  end;
  PJ.PM.B := cos(PJ.PM.A);
  PJ.PM.A := sin(PJ.PM.A);
  PJ.fInverse := mStereoInverse;
  PJ.fForward := mStereoForward;
end;


//PROJ_HEAD(laea, "Lambert Azimuthal Equal Area") "\n\tAzi, Sph&Ell";

function LAEAFwdEllipsoid(PntBL:T3dPoint;PJ:PCustomProj):T3dPoint; // ellipsoid
var coslam,q, sinlam,
    sinphi : double;
    sinb   : double;
    cosb   : double;
    b      : double;
    lp     : T3dPoint;
begin
 lp:=PntBL;
 coslam:=cos(lp.lam); sinlam:=sin(lp.lam);
 sinphi:=sin(lp.phi);
 q:=pj_qsfn(sinphi, Pj.ellps.e, Pj.ellps.one_es);
 if PJ.PM.mode in [2,3] then
 begin
  sinb:=q/PJ.PM.D;
  cosb:=sqrt(1-sinb*sinb);
 end;
 case PJ.PM.mode of
  3: b:=1+PJ.PM.A*sinb+PJ.PM.B*cosb*coslam;
  2: b:=1+cosb*coslam;
  0: begin
      b:=HALFPI + lp.phi;
      q:=PJ.PM.D - q;
     end;
  1: begin
      b:=lp.phi - HALFPI;
      q:=PJ.PM.D + q;
     end;
 end;
 pj.errno:=-byte(abs(b)<1E-10);
 if pj.errno<>0 then exit;
 with  result do
 case PJ.PM.mode of
  3: begin
      b:=sqrt(2/b);
      y:=PJ.PM.Cy*b*(PJ.PM.B*sinb-PJ.PM.A*cosb*coslam);
      x:=PJ.PM.Cx*b*cosb*sinlam;
     end;
  2: begin
      b:=sqrt(2/(1+ cosb*coslam));
      y:=b*sinb*PJ.PM.Cy;
      x:=PJ.PM.Cx*b*cosb * sinlam;
     end;
  0,1: case byte(q>=0) of
	1: begin
            b:=sqrt(q);
            x:=b*sinlam;
            y:=coslam*b*(2*PJ.PM.mode-1);
           end;
        0: result:=NullPoint;
       end;
 end;
end;



function LAEAFwdSpheroid(PntBL:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
var coslam, cosphi,
    sinphi : double;
    lp     : T3dPoint;
begin
 lp:=PntBL;
 sinphi:=sin(lp.phi);
 cosphi:=cos(lp.phi);
 coslam:=cos(lp.lam);
 with result do
 case PJ.PM.mode of
  2,3: begin
        if PJ.PM.mode=2 then y:=1+cosphi*coslam else
        y:=1+PJ.PM.A*sinphi +PJ.PM.B*cosphi*coslam;
        pj.errno:=-byte(y<=1E-10);
        if pj.errno<>0 then exit;
        y:=sqrt(2/y);
        x:=y*cosphi * sin(lp.lam);
        if PJ.PM.mode=3 then y:=y*(PJ.PM.B*sinphi-PJ.PM.A*cosphi*coslam) else
        y:=y*sinphi;
       end;
  0,1: begin
        if PJ.PM.mode=0 then coslam:=-coslam;
        pj.errno:=-byte(abs(lp.phi+PJ.C0.phi)<1E-10);
        if pj.errno<>0 then exit;
        y:=FORTPI-lp.phi*0.5;
        if PJ.PM.mode=0 then y:=2*sin(y) else y:=2*cos(y);
        x :=y*sin(lp.lam);
        y :=y*coslam;
       end;
  end;
end;


function LAEAInvEllipsoid(PntXY:T3dPoint;PJ:PCustomProj):T3dPoint; // ellipsoid
var cCe, sCe, q, rho, ab : double;
    xy : T3dPoint;
begin
 xy:=PntXY;
 case PJ.PM.mode of
  2,3: begin
        XY.x := xy.x/PJ.PM.G;
        XY.y := xy.y*PJ.PM.G;
        rho:=hypot(xy.x,XY.y);
    	if rho<1E-10 then
        begin
         result.lam:=0; result.phi:=PJ.C0.phi;
         exit;
        end;
        sCe  :=2*arcsin(0.5*rho/PJ.PM.C);
        cCe  :=cos(sCe);
        sCe  :=sin(sCe);
        xy.x :=xy.x*sCe;
        case PJ.PM.mode of
         3: begin
             ab  := cCe*PJ.PM.A+xy.y*sCe*PJ.PM.B/rho;
	     q   := PJ.PM.D * ab;
             xy.y:= rho*PJ.PM.B*cCe-xy.y*PJ.PM.A*sCe;
            end;
         2: begin
             ab  :=xy.y * sCe/rho;
             q   :=PJ.PM.D * ab;
             xy.y:=rho * cCe;
            end;
	end;
       end;
  0,1: begin
        if PJ.PM.mode=0 then xy.y:=-xy.y;
        q:=xy.x * xy.x + xy.y * xy.y;
        if q=0 then
        begin
         result.lam:=0;
         result.phi:=PJ.C0.phi;
         exit;
        end;
        // q:=qp - q;
        ab:=1-q/PJ.PM.D;
        if PJ.PM.mode=1 then ab:=- ab;
       end;
  end;
  result.lam:=arctan2(xy.x, xy.y);
  result.phi:=pj_authlat(arcsin(ab),PJ.PM.apa);
  NormHALFPI(result.lam);
end;

function LAEAInvSpheroid(PntXY:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
var cosz, rh, sinz : double;
    xy : T3dPoint;
begin
 xy:=PntXY;

 rh:=hypot(xy.x, xy.y);
 result.phi:=rh*0.5;
 pj.errno:=-byte(result.phi>1);
 if pj.errno<>0 then exit;
 result.phi:=2*arcsin(result.phi);

 if PJ.PM.mode in [2,3] then
 begin
  sinz:=sin(result.phi);
  cosz:=cos(result.phi);
 end;
 with result do
 case PJ.PM.mode of
  2: begin
      phi:=0;
      if abs(rh)>1E-10 then phi:=arcsin(xy.y*sinz/rh);
      xy.x := xy.x*sinz;
      xy.y := cosz * rh;
     end;
  3: begin
      phi:=PJ.C0.phi;
      if abs(rh)>1E-10 then phi:=arcsin(cosz*PJ.PM.A+xy.y*sinz*PJ.PM.B/rh);
      xy.x := xy.x*sinz*PJ.PM.B;
      xy.y :=(cosz-sin(phi)*PJ.PM.A) * rh;
     end;
  0: begin
      xy.y:=-xy.y;
      phi:=HALFPI-phi;
     end;
  1: phi :=phi-HALFPI;
 end;
 result.lam:=0;
// if mode in [2..3] then
 result.lam:=arctan2(xy.x, xy.y);

end;


procedure InitLAEA(var PJ:TCustomProj);
var t,sinphi:double;
begin
 t:=abs(PJ.C0.phi);
 if abs(t-HALFPI)<1E-10 then PJ.PM.mode:=byte(PJ.C0.phi<0) else
 PJ.PM.mode:=3-byte(abs(t)<1E-10);
 with PJ.PM do
 case byte(PJ.ellps.es>0) of
  // ellipsoid
  1: begin
      D:=pj_qsfn(1, Pj.ellps.e, Pj.ellps.one_es);
      Cp:=0.5/(1-Pj.ellps.es);
      apa:=pj_authset(Pj.ellps.es);
      case mode of
       0,1: G:=1;
       2:   begin
             C:=sqrt(0.5*D);
             G:=1/C;
             Cx:=1;
             Cy:=0.5 * D;
	    end;
       3:   begin
             C:=sqrt(0.5*D);
             sinphi:=sin(PJ.C0.phi);
             A :=pj_qsfn(sinphi,Pj.ellps.e,Pj.ellps.one_es)/D;
             B :=sqrt(1-A*A);
             G:=cos(PJ.C0.phi)/(sqrt(1-Pj.ellps.es*sinphi*sinphi)*C*B);
             Cy:=C/G;
             Cx:=C*G;
           end;
      end;
      PJ.fForward:=LAEAFwdEllipsoid;
      PJ.fInverse:=LAEAInvEllipsoid;
    end;
 // spheroid
 0: begin
     if mode=3 then
     begin
      A:=sin(PJ.C0.phi);
      B:=cos(PJ.C0.phi);
     end;
     PJ.fForward:=LAEAFwdSpheroid;
     PJ.fInverse:=LAEAInvSpheroid;
    end;
 end; // case PJ.ellps.es>0

end;

// ************** putp1p  ****************
function PutpP1Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := 0.94745*pntBL.phi;
 result.x := 1.8949*pntBL.lam*(asqrt(1-0.30396355092701331433*sqr(pntBL.phi))-0.5);
end;

function PutpP1Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := pntXY.y/0.94745;
 result.lam := pntXY.x/(1.89490*(asqrt(1-0.30396355092701331433*sqr(result.phi))-0.5));
end;

// ************** putp2  ****************

function PutpP2Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var  V,s,c,p : double;
     i       : integer;
     lp      : T3dPoint;
begin
 lp:= pntBL;
 p := 0.6141848493043784*sin(lp.phi);
 lp.phi := lp.phi*(0.615709 + sqr(lp.phi)*(0.00909953+sqr(lp.phi)*0.0046292));
 for i:=10 downto 0 do
 begin
  c := cos(lp.phi);
  s := sin(lp.phi);
  V :=(lp.phi+s*(c-1)-p)/(1+c*(c-1)-s*s);
  lp.phi := lp.phi-V;
  if (abs(V)<1e-10) then break;
 end;
 if (i=0) then lp.phi:=1.0471975511965977*(1-2*byte(lp.phi<0));
 result.x := 1.89490 * lp.lam * (cos(lp.phi) - 0.5);
 result.y := 1.71848 * sin(lp.phi);
end;

function PutpP2Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 with result do
 begin
  phi := aasin(pntXY.y/1.71848);
  lam := pntXY.x /(1.89490*(cos(phi)-0.5));
  phi := aasin((phi + sin(phi) * (cos(phi)-1))/0.6141848493043784);
 end;
end;

// ************** putp3 3p  ****************
function PutpP3Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 0.79788456*pntBL.lam*(1-PJ.PM.G*sqr(pntBL.phi));
 result.y := 0.79788456*pntBL.phi;
end;

function PutpP3Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := pntXY.y/0.79788456;
 result.lam := pntXY.x/(0.79788456*(1-PJ.PM.G*sqr(result.phi)));
end;

// ************** putp4p ****************
function PutpP4Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var _phi : double;
begin
 _phi := aasin(0.883883476 * sin(pntBL.phi));
 result.x := 0.874038744*pntBL.lam*cos(_phi)/cos(_phi/3);
 result.y := 3.883251825*sin(_phi/3);
end;

function PutpP4Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 with result do
 begin
  phi := aasin(pntXY.y/3.883251825);
  lam := pntXY.x*cos(phi)/(0.874038744*cos(3*phi));
  phi := aasin(1.13137085 * sin(3*phi));
 end;
end;

// ************** putp5,5p ****************
function PutpP5Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 1.01346*pntBL.lam*(2-sqrt(1+1.2158542*sqr(pntBL.phi)));
 result.y := 1.01346*pntBL.phi;
end;

function PutpP5Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi:=pntXY.y/1.01346;
 result.lam:=pntXY.x/(1.01346*(2-sqrt(1+1.2158542*sqr(result.phi))));
end;

function PutpP5pForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 1.01346*pntBL.lam*(1.5-0.5*sqrt(1+1.2158542*sqr(pntBL.phi)));
 result.y := 1.01346*pntBL.phi;
end;

function PutpP5pInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi:=pntXY.y/1.01346;
 result.lam:=pntXY.x/(1.01346*(1.5-0.5*sqrt(1+1.2158542*sqr(result.phi))));
end;

// ************** putp6,6p ****************

function PutpP6Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var p,r,V,phi : double;
    i     : integer;
begin
 p   := PJ.PM.B * sin(pntBL.phi);
 phi := pntBL.phi*1.10265779;
 for i:=10 downto 0 do
 begin
  r:=sqrt(1+sqr(phi));
  V:=((PJ.PM.A-r)*phi-ln(phi+r)-p)/(PJ.PM.A-2*r);
  phi:=phi-V;
  if (abs(V)<1e-10) then break;
 end;
 if i=0 then phi := 1.732050807568877*(1-2*byte(p<0));
 result.x:=PJ.PM.Cx*pntBL.lam*(PJ.PM.D-sqrt(1+sqr(phi)));
 result.y:=PJ.PM.Cy*phi;
end;

function PutpP6Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
var r : double;
begin
 with result do
 begin
  phi:=pntXY.y/PJ.PM.Cy;
  r:=sqrt(1.+sqr(phi));
  lam:=pntXY.x/(PJ.PM.Cx*(PJ.PM.D-r));
  phi:=aasin(((PJ.PM.A-r)*phi-ln(phi+r))/PJ.PM.B);
 end;
end;




procedure InitPutp(var PJ : TCustomProj; PutpType : TPutpType);
var pIndex : integer;
begin
 case byte(PutpType) of
  0: begin
      PJ.fForward:= PutpP1Forward;
      PJ.fInverse:= PutpP1Inverse;
     end;
  1: begin
      PJ.fForward:= PutpP2Forward;
      PJ.fInverse:= PutpP2Inverse;
     end;
  2,3: begin
      PJ.PM.G:=(4-2*(pIndex-2))*0.1013211836;
      PJ.fForward:= PutpP3Forward;
      PJ.fInverse:= PutpP3Inverse;
     end;
  4: begin
      PJ.fForward:= PutpP4Forward;
      PJ.fInverse:= PutpP4Inverse;
     end;
  5: begin
      PJ.fForward:= PutpP5Forward;
      PJ.fInverse:= PutpP5Inverse;
     end;
  6: begin
      PJ.fForward:= PutpP5pForward;
      PJ.fInverse:= PutpP5pInverse;
     end;
  7,8:with PJ.PM do
      begin
       pIndex:=byte(pIndex=8);
       Cx := 1.01346-0.57017*pIndex;
       Cy := 0.91910-0.11506*pIndex;
       A  := 4.0+2*pIndex;
       B  := 2.1471437182129378784+3.4641062817870621216*pIndex;
       D  := 2.0+pIndex;
       PJ.fForward:= PutpP6Forward;
       PJ.fInverse:= PutpP6Inverse;
     end;
 end;
end;

// **************  Werenskiold I ****************

function WerenForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var _phi : double;
begin
 _phi := aasin(0.883883476 * sin(pntBL.phi));
 result.x := pntBL.lam*cos(_phi)/cos(_phi/3);
 result.y := 4.442882938*sin(_phi/3);
end;

function WerenInverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 with result do
 begin
  phi := aasin(pntXY.y/4.442882938);
  lam := pntXY.x*cos(phi)/cos(3*phi);
  phi := aasin(1.13137085*sin(3*phi));
 end;
end;

procedure InitWeren(var PJ : TCustomProj);
begin
 PJ.fForward:= WerenForward;
 PJ.fInverse:= WerenInverse;
end;


procedure Seraz0(lamda,mult:double;var Param : TProjParam);
var sdsq, _h, s, fc, sd, sq, d_1 : double;
    lam  : double;
begin
 with Param do
 begin
  lam    := lamda*pi/180;
  sd     := sin(lam);
  sdsq   := sd*sd;
  s      := apa[0]*apa[1]*cos(lam)*sqrt((1+en[2]*sdsq)/((1+en[4]*sdsq)*(1+en[1]*sdsq)));
  d_1    := 1+en[1]*sdsq;
  _h     := sqrt((1+en[1]*sdsq)/(1+en[4]*sdsq))*((1+en[4]*sdsq)/sqr(d_1)-apa[0]*apa[2]);
  sq     := sqrt(Cx*Cx+s*s);
  fc     := mult*(_h*Cx-s*s)/sq;
  en[0]  := en[0]+fc;
  A      := A+fc*cos(2*lam);
  B      := B+fc*cos(4*lam);
  fc     := mult*s*(_h+Cx)/sq;
  C      := C+fc*cos(lam);
  D      := D+fc*cos(lam*3);
 end;
end;


function SOLForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // ellipsoid
var  l, nn : integer;
     lamt, xlam, sdsq, s,c,d, lamdp, phidp, lampp, tanph,
     lamtp, cl, sd, sp, fac, sav, tanphi : double;
     lp : T3dPoint;
begin
  lp:= pntBL;
  if lp.phi>HALFPI then lp.phi:=HALFPI else
  if lp.phi<-HALFPI then lp.phi:=-HALFPI;
  if lp.phi>=0  then lampp :=HALFPI else
  lampp :=4.71238898038468985766;
  tanphi := tan(lp.phi);

  for nn := 0 to 2 do
  begin
   sav   := lampp;
   lamtp := lp.lam+PJ.PM.apa[0]*lampp;
   cl    := cos(lamtp);
   if (abs(cl)<1e-7) then lamtp:=lamtp-1e-7;
   fac   := lampp-sin(lampp)*(1-2*byte(cl<0))*HALFPI;

   for l:=50 downto 0 do
   begin
    lamt  :=lp.lam+PJ.PM.apa[0]*sav;
    c     := cos(lamt);
    if abs(c)<1e-7 then lamt:=lamt-1e-7;
    xlam  := (PJ.Ellps.one_es*tanphi*PJ.PM.apa[1]+sin(lamt)*PJ.PM.apa[2])/c;
    lamdp := arctan(xlam) + fac;
    if (abs(abs(sav)-abs(lamdp))<1e-7) then break;
    sav   := lamdp;
   end; // for l

   if (l<=0) or (nn=2) or ((lamdp>PJ.PM.Cy) and (lamdp<PJ.PM.Cp)) then break;
   if (lamdp<=PJ.PM.Cy) then lampp := 7.8539816339744830961 else
   if (lamdp>=PJ.PM.Cp) then lampp := HALFPI;
  end; // for nn

  if l>0 then
  begin
   sp    := sin(lp.phi);
   phidp := aasin((PJ.Ellps.one_es*PJ.PM.apa[2]*sp-PJ.PM.apa[1]*cos(lp.phi)*sin(lamt))/sqrt(1-PJ.Ellps.es*sp*sp));
   tanph := ln(tan(FORTPI+0.5*phidp));
   sd    := sin(lamdp);
   sdsq  := sd * sd;
   s     := PJ.PM.apa[0]*PJ.PM.apa[1]*cos(lamdp)*sqrt((1+PJ.PM.en[2]*sdsq)/
            ((1+PJ.PM.en[4]*sdsq)*(1+PJ.PM.en[1]*sdsq)));
   d     := sqrt(sqr(PJ.PM.Cx)+s*s);
   result.x:=PJ.PM.en[0]*lamdp+PJ.PM.A*sin(2*lamdp)+PJ.PM.B*sin(lamdp*4)-tanph*s/d;
   result.y:=PJ.PM.C*sd+PJ.PM.D*sin(lamdp*3)+tanph*PJ.PM.Cx/d;
  end else
  result := InfPoint;
end;


function SOLInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint;// ellipsoid
var nn : integer;
    lamt, sdsq, dd,s, lamdp, phidp, sppsq,  sd, sl, fac, scl, sav, spp : double;
begin
 lamdp := xy.x/PJ.PM.en[0];
 for nn:=50 downto 0 do
 begin
  sav  := lamdp;
  sd   := sin(lamdp);
  sdsq := sd*sd;
  s    := PJ.PM.apa[0]*PJ.PM.apa[1]*cos(lamdp)*sqrt((1+PJ.PM.en[2]*sdsq)/
          ((1+PJ.PM.en[4]*sdsq)*(1+PJ.PM.en[1]*sdsq)));
  lamdp:= xy.x+xy.y*s/PJ.PM.Cx-PJ.PM.A*sin(2*lamdp)-PJ.PM.B*sin(lamdp*4)-
          s/PJ.PM.Cx*(PJ.PM.C*sin(lamdp)+PJ.PM.D*sin(lamdp*3));
  lamdp:=lamdp/PJ.PM.en[0];
  if abs(lamdp-sav)<=1e-7 then break;
 end;
 sl    := sin(lamdp);
 fac   :=exp(sqrt(1+s*s/PJ.PM.Cx/PJ.PM.Cx)*(xy.y-PJ.PM.C*sl-PJ.PM.D*sin(lamdp*3)));
 phidp := 2*(arctan(fac)-FORTPI);
 dd    := sl * sl;
 if (abs(cos(lamdp))<1e-7) then lamdp:=lamdp-1e-7;
 spp   := sin(phidp);
 sppsq := spp*spp;

 lamt  := arctan(((1-sppsq*PJ.Ellps.rone_es)*tan(lamdp)*PJ.PM.apa[2]-
         spp*PJ.PM.apa[1]*sqrt((1+PJ.PM.en[1]*dd)*
        (1-sppsq)-sppsq*PJ.PM.en[3])/cos(lamdp))/(1-sppsq*(1+PJ.PM.en[3])));
 sl    := 1-2*byte(lamt<0);
 scl   := 1-2*byte(cos(lamdp)<0);
 lamt  := lamt-HALFPI*(1-scl)*sl;
 result.lam := lamt-PJ.PM.apa[0]*lamdp;
 if (abs(PJ.PM.apa[1])<1e-7) then
 result.phi := aasin(spp/sqrt(sqr(PJ.Ellps.one_es)+PJ.Ellps.es*sppsq)) else
 result.phi := arctan((tan(lamdp)*cos(lamt)-PJ.PM.apa[2]*sin(lamt))/
              (PJ.Ellps.one_es*PJ.PM.apa[1]));
end;

//+proj=lsat +ellps=WGS84 +lsat=3 +path=45
procedure InitSOLandsat(var PJ : TCustomProj;Lsat,Path : byte);
var lam,alf,esc, ess : double;
begin
  pj.errno:=-28*byte((Lsat<=0) or (Lsat>5));
  if pj.errno=0 then pj.errno:=-29*byte((Path<=0) or (Path>(233+18*byte(Lsat<=3))));
  if pj.errno<>0 then exit;
  FillChar(PJ.PM,SizeOf(TProjParam),0);
  if (Lsat<=3)  then
  begin
   PJ.C0.lam    := DegToRad(128.87)-TWOPI/251*Path;  //128.87d
   PJ.PM.apa[0] := 103.2669323;
   alf          := DegToRad(99.092);   //99.092d
  end else
  begin
   PJ.C0.lam  := DegToRad(129.3)-TWOPI/233*Path;     //129.3d
   PJ.PM.apa[0] := 98.8841202;
   alf        := DegToRad(98.2);    //98.2d
  end;

  with PJ.PM do
  begin
   apa[0]  :=  apa[0]/1440;
   apa[1]    := sin(alf);
   apa[2]    := cos(alf);

   if abs(apa[2])<1e-9 then apa[2] := 1e-9;

   esc    := PJ.Ellps.es * sqr(apa[2]);
   ess    := PJ.Ellps.es * sqr(apa[1]);
   en[4]  := sqr((1-esc)*PJ.Ellps.rone_es)-1;
   en[1]  := ess*PJ.Ellps.rone_es;
   en[2]  := ess * (2-PJ.Ellps.es)*sqr(PJ.Ellps.rone_es);
   en[3]  := esc * PJ.Ellps.rone_es;
   Cx     := power(PJ.Ellps.one_es,3);
   Cy     := PI * (1/248+0.5161290322580645);
   Cp     := Cy + TWOPI;
  end;

  seraz0(0,1,PJ.PM);
  lam:=9;
  while lam<=81.0001 do
  begin
   seraz0(lam,4,PJ.PM);
   lam := lam+18;
  end;
  lam:=18;
  while lam<=72.0001 do
  begin
   seraz0(lam,2,PJ.PM);
   lam := lam+18;
  end;
  seraz0(90,1,PJ.PM);
  with PJ.PM do
  begin
   A     := A/30;
   B     := B/60;
   en[0] := en[0]/30;
   C     := C/15;
   D     := D/45;
  end;
  Pj.fForward:=SOLForward;
  Pj.fInverse:=SOLInverse;
end;



function StereoForwardElps(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid
var coslam, sinlam, sinX, cosX, X, sinphi,phi,_A : double;
begin
  sinX:=0.0;
  cosX:=0.0;
  phi:=lp.phi;
  coslam := cos(lp.lam);
  sinlam := sin(lp.lam);
  sinphi := sin(phi);
  if PJ.PM.mode in [2,3] then
  begin
   X    := 2*arctan(ssfn_(phi, sinphi, PJ.Ellps.e))-HALFPI;
   sinX := sin(X);
   cosX := cos(X);
  end;

  with PJ.PM do
  case mode of
   2: begin
       A := rho0/(D*(1+C*sinX+D*cosX*coslam));
       result.y := A*(D*sinX-C*cosX*coslam);
      end;
   3: begin
       A :=2*rho0/(1+cosX*coslam);
       result.y := A*sinX;
      end;
   0: begin
       phi    := -phi;
       coslam := -coslam;
       sinphi := -sinphi;
      end;
  end;

  if PJ.PM.mode in [0,1] then
  begin
   result.x:=PJ.PM.rho0*pj_tsfn(phi,sinphi,PJ.Ellps.e);
   result.y:=-result.x*coslam;
  end else
  result.x :=PJ.PM.A*cosX;
  result.x:=result.x*sinlam;
end;


function StereoForwardSph(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
var sinphi, cosphi, coslam, sinlam,phi : double;
begin
 phi:= lp.phi;
 sinphi := sin(phi);    cosphi := cos(phi);
 coslam := cos(lp.lam); sinlam := sin(lp.lam);
 with PJ.PM do
 case mode of
  2,3: begin
        if mode=3 then result.y:=1+cosphi*coslam else
        result.y:=1+A*sinphi+B*cosphi*coslam;
        pj.errno:=-byte(result.y<=1e-10);
        if pj.errno<>0 then exit;
        result.y :=rho0/result.y;
        result.x :=result.y*cosphi*sinlam;
          // P->mode == 3) ? sinphi :   cosph0 * sinphi - sinph0 * cosphi * coslam;
        if mode=2 then result.y:=result.y*(B*sinphi-A*cosphi*coslam) else
        result.y:=result.y*sinphi;
       end;

 1,0: begin
       if mode=1 then
       begin
        coslam := -coslam;
        phi    := -phi;
       end;
       pj.errno:=-byte(abs(phi-HALFPI)<1e-8);
       if pj.errno<>0 then exit;
       result.y :=rho0*tan(FORTPI+0.5*phi);
       result.x :=sinlam*result.y;
       result.y := result.y*coslam;
     end;
 end;
end;



function StereoInverseElps(pntxy : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid
var cosphi,sinphi,tp,
    phi_l,halfe,_hpi : double;
    i   : integer;
    xy  : T3dPoint;
begin
 tp:=0.0;    phi_l:=0.0;
 halfe:=0.0; _hpi:=0.0;
 xy:=pntxy;
 PJ.PM.rho := hypot(xy.x, xy.y);
 with PJ.PM do
 case mode of
  2,3: begin
        tp := 2*arctan2(rho*D,rho0);
        cosphi:= cos(tp); sinphi := sin(tp);
        if rho=0.0 then phi_l := arcsin(cosphi*C) else
        phi_l := arcsin(cosphi*C+(xy.y*sinphi*D/rho));
        tp    := tan(0.5 * (HALFPI + phi_l));
        xy.x  := xy.x*sinphi;
        xy.y  := rho*D*cosphi-xy.y*C* sinphi;
        _hpi  := HALFPI;
        halfe := 0.5 *PJ.Ellps.e;
       end;
  0,1: begin
	if mode=1 then xy.y := -xy.y else xy.y:=xy.y;
        tp     := -rho/rho0;
        phi_l  := HALFPI-2*arctan(tp);
        _hpi   := -HALFPI;
        halfe  := -0.5*PJ.Ellps.e;
       end;
  end;
  result.phi:=0;
  for i:= 8 downto 0 do
  begin
   phi_l      := result.phi;
   sinphi     := PJ.Ellps.e* sin(phi_l);
   result.phi := 2*arctan(tp * power((1+sinphi)/(1-sinphi),halfe))-_hpi;
   if (abs(phi_l-result.phi) < 1.e-10) then
   begin
    if PJ.PM.mode=0 then result.phi:=-result.phi;
    if (xy.x=0) and (xy.y=0) then result.lam:=0 else
    result.lam := arctan2(xy.x,xy.y);
    exit;
   end;
  end;
  pj.errno:=-1;
end;


function StereoInverseSph(pntxy : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
var rh, sinc, cosc,c : double;
    xy  : T3dPoint;
begin
 xy:=pntxy;
 rh := hypot(xy.x, xy.y);
 c  := 2*arctan(rh/PJ.PM.rho0);
 sinc := sin(c);
 cosc := cos(c);
 result.lam := 0;
 case PJ.PM.mode of
  3:  begin
       if abs(rh)<=1e-10 then result.phi := 0 else
       result.phi := arcsin(xy.y*sinc/rh);
       result.lam := arctan2(xy.x*sinc, cosc*rh);
      end;
  2:  begin
       if abs(rh)<=1e-10 then result.phi:=PJ.C0.phi else
       result.phi:=arcsin(cosc*PJ.PM.A+xy.y*sinc*PJ.PM.B/rh);
       c:=cosc-PJ.PM.A*sin(result.phi);
       result.lam:=arctan2(xy.x*sinc*PJ.PM.B,c*rh);
      end;
  0,1: begin
        if PJ.PM.mode=1 then xy.y := -xy.y;
        if abs(rh)<=1e-10 then result.phi:=PJ.C0.phi else
        result.phi := arcsin((1-2*PJ.PM.mode)*cosc);
	result.lam := arctan2(xy.x, xy.y);
       end;
  end;
end;


procedure SetupStereoGraphic(var PJ:TCustomProj); // general initialization
var t : DOUBLE;
begin
  t := abs(PJ.C0.phi);
  if (t-HALFPI)<1e-10 then PJ.PM.mode:=byte(PJ.C0.phi>0) else
  PJ.PM.mode:= 2+byte(t>1e-10);

  PJ.Bts := abs(PJ.Bts);
  with PJ.PM do
  case byte(PJ.Ellps.es>0) of
   1: begin
       case mode of
        0,1: if abs(PJ.Bts-HALFPI)>=1e-10 then
             begin
              rho0 := cos(PJ.Bts)/pj_tsfn(PJ.Bts,sin(PJ.Bts),pj.Ellps.e);
              rho0 := rho0/sqrt(1-sqr(sin(PJ.Bts)*pj.Ellps.e));
	     end else
	     rho0 := 2 * PJ.k0/sqrt(power(1+pj.Ellps.e,1+pj.Ellps.e)*power(1-pj.Ellps.e,1-pj.Ellps.e));
        3:   rho0 := 2 * PJ.k0;
        2:   begin
              t     := 2*arctan(ssfn_(PJ.C0.phi,sin(PJ.C0.phi),PJ.Ellps.e)) - HALFPI;
              rho0  := 2* Pj.k0*cos(PJ.C0.phi)/sqrt(1-sqr(sin(PJ.C0.phi)*PJ.Ellps.e));
              C := sin(t);
              D := cos(t);
             end;
        end;// case mode
       PJ.fInverse := StereoInverseElps;
       PJ.fForward := StereoForwardElps;
      end;

   0: begin
       case mode of
	2,3: begin
              if mode=2 then
              begin
               A := sin(PJ.C0.phi);
               B := cos(PJ.C0.phi);
	      end;
              rho0 := 2*Pj.k0;
	     end;
        0,1: case byte(abs(PJ.Bts-HALFPI)>=1e-10) of
              1: rho0:=cos(PJ.Bts)/tan(FORTPI-0.5*PJ.Bts);
              0: rho0:=2* PJ.k0;
             end;
        end; //case mode
       PJ.fInverse := StereoInverseSph;
       PJ.fForward := StereoForwardSph;
      end;
  end;
end;

procedure InitInterStereo(var PJ:TCustomProj; Bts:double);
begin
   PJ.C0.phi:=HALFPI*(1-2*PJ.south);
   pj.errno:=-34*byte(PJ.Ellps.es=0);
   if pj.errno<>0 then exit;
   PJ.k0 := 0.994;
   PJ.x0 := 2000000;
   PJ.y0 := 2000000;
   PJ.Bts := HALFPI;
   PJ.C0.lam := 0;
   SetupStereoGraphic(PJ);
end;


procedure InitStereographic(var PJ:TCustomProj;Bts:double);
begin
  if IsInfinite(Bts) then PJ.Bts:=HALFPI else PJ.Bts:=Bts;
  SetupStereoGraphic(PJ);
end;

// Wagner 1-6,  Mollweide, Urmaev Flat-Polar Sinusoidal

function UrmfpsForward(PntLP : T3dPoint;PJ:PCustomProj): T3dPoint;   //spheroid
var phi : double;
begin
 phi      := aasin(PJ.PM.A* sin(PntLP.phi));
 result.x := PJ.PM.Cx * PntLP.lam * cos(phi);
 result.y := PJ.PM.Cy * phi;
end;

function UrmfpsInverse(PntXY : T3dPoint; PJ:PCustomProj): T3dPoint;  // spheroid
begin
 result.phi := aasin(sin(PntXY.y/PJ.PM.Cy)/PJ.PM.A);
 result.lam := PntXY.x/(PJ.PM.Cx*cos(PntXY.y/PJ.PM.Cy));
end;

//***     "Wagner II"  ***//
function Wag2Forward(PntBL:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
var phi : double;
begin
  //phi:=aasin(0.88022*sin(C_p2*PntBL.phi));
  phi:=arcsin(0.88022*sin(0.88550*PntBL.phi));
  result.x:=0.92483*PntBL.lam*cos(phi);
  result.y:=1.38725*phi;
end;

function Wag2Inverse(PntXY:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
begin
 with result do
 begin
  lam:=PntXY.x/(0.92483*cos(PntXY.y/1.38725));
  //phi:=aasin(sin(PntXY.y/1.38725)/0.88022)/0.88550;
  phi:=arcsin(sin(PntXY.y/1.38725)/0.88022)/0.88550;
 end;
end;

//***     "Wagner III"  ***//

function Wag3Forward(PntBL:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
begin
 result.x := PJ.PM.Cx*PntBL.lam*cos(2*PntBL.phi/3);
 result.y := PntBL.phi;
end;

function Wag3Inverse(PntXY:T3dPoint;PJ:PCustomProj):T3dPoint; // spheroid
begin
 result.phi := PntXY.y;
 result.lam := PntXY.x/(PJ.PM.Cx*cos(2*PntXY.y/3));
end;

function WagMollForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var i    : integer;
    k,V  : double;
    _phi : double;
begin
 k := PJ.PM.Cp*sin(pntBL.phi);
 _phi:=pntBL.phi;

 for i:=10 downto 0 do
 begin
  V:=(_phi+sin(_phi)-k)/(1+cos(_phi));
  _phi:=_phi-V;
  if abs(V)<1e-7 then break;
 end;
 _phi:=_phi*0.5;
 if i=0 then _phi :=HALFPI*(2*byte(_phi<0)-1) else
 result.x := PJ.PM.Cx * pntBL.lam * cos(_phi);
 result.y := PJ.PM.Cy * sin(_phi);
end;

function WagMollInverse(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint;// spheroid
var th,s : double;
begin
 with result do
 begin
  phi:=aasin(pntXY.y/PJ.PM.Cy);
  lam:=pntXY.x/(PJ.PM.Cx*cos(phi));
  phi:=2*phi;
  phi:=aasin((phi+sin(phi))/PJ.PM.Cp);
 end;
end;


// ************** Wagner 7  ****************
function Wag7Forward(PntBL:T3dPoint;PJ:PCustomProj):T3dPoint; // sphere
var theta, ct, D : double;
begin
 with result do
 begin
  y    := 0.90630778703664996*sin(PntBL.phi);
  x    := 2.66723*cos(arcsin(y))*sin(PntBL.lam/3);
  d    := 1/(sqrt(0.5*(1+cos(arcsin(y))*cos(PntBL.lam/3))));
  y    := y*1.24104*d;
  x    := x*d;
 end;
end;

// ************** Wagner 6  ****************
function Wag6Forward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := 0.94745*pntBL.phi;
 result.x := 0.94745*pntBL.lam*asqrt(1-0.30396355092701331433*sqr(pntBL.phi));
end;

function Wag6Inverse(pntXY: T3dPoint;PJ : PCustomProj):T3dPoint; //spheroid
begin
 result.phi := pntXY.y/0.94745;
 result.lam := pntXY.x/(0.94745*asqrt(1-0.30396355092701331433*sqr(result.phi)));
end;


procedure InitMoll(var PJ : TCustomProj; const B1 : double);
var _r : double;
begin
 if IsInfinite(B1) then exit;
  PJ.Ellps.es:=0;
 _r:=sqrt(TWOPI*sin(B1)/(2*B1+sin(2*B1)));
 PJ.PM.Cx:=2*_r/PI;
 PJ.PM.Cy:=_r/sin(B1);
 PJ.PM.Cp:=2*B1+sin(2*B1);
 Pj.fInverse:=WagMollInverse;
 Pj.fForward:=WagMollForward;
end;


procedure InitWagner(var PJ : TCustomProj; wType : TWagnerMode;Bts:double);
var _value : byte;
begin

 with PJ.PM do
 case wType of
  1: begin
      A  := 0.8660254037844386467637231707;
      Cy := 1.3160740129520434890049020011302;
      Cx := 0.8773826753;
      PJ.fForward:=UrmfpsForward;
      PJ.fInverse:=UrmfpsInverse;
     end;
  2: begin
      PJ.fForward:=Wag2Forward;
      PJ.fInverse:=Wag2Inverse;
     end;
  3: begin
      PJ.Bts:= Bts;
      if IsInfinite(PJ.Bts) then PJ.Bts:=0;
      Cx := cos(PJ.Bts)/cos(2*PJ.Bts/3);
      PJ.fForward:=Wag3Forward;
      PJ.fInverse:=Wag3Inverse;
     end;
  4: InitMoll(PJ,PI/3);
  5: begin
      PJ.Ellps.es:=0;
      Cx := 0.90977;
      Cy := 1.65014;
      Cp := 3.00896;
      Pj.fInverse:=WagMollInverse;
      Pj.fForward:=WagMollForward;
     end;
  6: begin
      PJ.fForward:= Wag6Forward;
      PJ.fInverse:= Wag6Inverse;
     end;
  7: begin
      PJ.fForward:=Wag7Forward;
      PJ.fInverse:=nil;
     end;
 end;
end;

procedure InitUrmfps(var PJ : TCustomProj; dN:double);
begin
 pj.errno:=-40*byte((dn<=0) or (dn>1));
 if pj.errno<>0 then exit;
 PJ.PM.A  := dN;
 PJ.PM.Cy := 1.139753528477/dn;
 PJ.PM.Cx := 0.8773826753;
 PJ.fForward:=UrmfpsForward;
 PJ.fInverse:=UrmfpsInverse;
end;


// WORKS
function AeqdFwdGuamElliptical(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; //  Guam elliptical
var cosphi, sinphi, t : double;
begin
 cosphi   := cos(pntBL.phi);
 sinphi   := sin(pntBL.phi);
 t        := 1/sqrt(1-Pj.ellps.es * sinphi * sinphi);
 result.x := pntBL.lam * cosphi * t;
 result.y := pj_mlfn(pntBL.phi,sinphi,cosphi,PJ.PM.en)-PJ.PM.Cx+0.5*sqr(pntBL.lam)*cosphi*sinphi*t;
end;

// WORKS
function AeqdInvGuamElliptical(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint; //  Guam elliptical
var	x2,t : double;
	i    : integer;
begin
 if PJ.PM.mode<2 then exit;
 x2:=0.5*sqr(pntXY.x);
 result.phi := PJ.C0.phi;
 for i:=0 to 2 do
 begin
  t := sqrt(1-sqr(PJ.Ellps.e*sin(result.phi)));
  result.phi := pj_inv_mlfn(PJ.PM.Cx+pntXY.y-x2*tan(result.phi)*t,PJ.Ellps.es,PJ.PM.en,pj.errno);
 end;
 result.lam := pntXY.x*t/cos(result.phi);
end;

// WORKS
function AeqdFwdElliptical(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // elliptical
var coslam,cosphi,sinphi,rho,s,H2,Az,t: double;
begin
 coslam := cos(pntBL.lam);
 cosphi := cos(pntBL.phi);
 sinphi := sin(pntBL.phi);
 with result do
 case PJ.PM.mode of
  0,1: begin
        if PJ.PM.mode=0 then coslam:=- coslam;
        rho := abs(PJ.PM.C - pj_mlfn(pntBL.phi,sinphi,cosphi,PJ.PM.en));
        x   := rho*sin(pntBL.lam);
        y   := rho * coslam;
       end;
  2,3: begin
        if (abs(pntBL.lam)<1E-10) and (abs(pntBL.phi-PJ.C0.phi)<1.e-10) then
        begin
         result:=NullPoint;
         exit;
        end;
        t  := arctan2(PJ.ellps.one_es*sinphi+PJ.ellps.es*PJ.PM.Cy*PJ.PM.A*sqrt(1-PJ.ellps.es*sqr(sinphi)),cosphi);
        Az := arctan2(sin(pntBL.lam)*cos(t),PJ.PM.B*sin(t)-PJ.PM.A*coslam*cos(t));
        case abs(sin(Az))<1.e-14 of
         true : s :=aasin(sin(pntBL.lam)*cos(t)/sin(Az));
         false: s :=aasin((PJ.PM.B*sin(t)-PJ.PM.A*coslam*cos(t))/cos(Az));
	end;
        H2:=sqr(PJ.PM.D*cos(Az));
        y:=PJ.PM.Cy*s*(1+s*s*(-H2*(1-H2)/6+s*(PJ.PM.G*PJ.PM.D*cos(Az)*(1-2*H2*H2)/8+
           s*((H2*(4-7*H2)-3*sqr(PJ.PM.G)*(1-7*H2))/120-s*PJ.PM.G*PJ.PM.D*cos(Az)/48))));
        x:=y*sin(Az);
        y:=y*cos(Az);
      end;
  end; // case
end;

// WORKS
function AeqdFwdSpherical(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint; // spherical */
var coslam,cosphi,sinphi,_phi : double;
begin
 _phi    := pntBL.phi;
 sinphi := sin(_phi);
 cosphi := cos(_phi);
 coslam := cos(pntBL.lam);

 with result do
 case PJ.PM.mode of
  2,3: begin
        if PJ.PM.mode=2 then y:=cosphi*coslam else
        y:=PJ.PM.A*sinphi+PJ.PM.B*cosphi*coslam;
        case byte(abs(abs(y)-1)<1e-14) of
         1: case byte(y<0) of
             1: pj.errno:=-1;
             0: result:=nullpoint;
            end;
         0: begin
             y := arccos(y);
             y := y/sin(y);
             x := y*cosphi*sin(pntBL.lam);
             if PJ.PM.mode=3 then y:=y*(PJ.PM.B*sinphi-PJ.PM.A*cosphi*coslam) else
             y:=y*sinphi;
	    end;
        end;//case
       end;
  0,1: begin
	if PJ.PM.mode=0 then
        begin
         _phi    := -_phi;
         coslam := -coslam;
        end;
        pj.errno :=-integer(abs(_phi-HALFPI)<1e-10);
        if pj.errno<>0 then exit;
        x := (HALFPI+_phi)*sin(pntBL.lam);
        y := (HALFPI+_phi)*coslam;
      end;
 end;
end;


function AeqdInvElliptical(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint; // elliptical
var Az,cosAz,A,C,B,E,D,F,psi,t:double;
    xy  : T3dPoint;
begin
 xy:=pntXY;
 c := hypot(xy.x, xy.y);
 if (c<1E-10) then
 begin
  result.phi := PJ.C0.phi;
  result.lam := 0;
  exit;
 end;
 if PJ.PM.mode in [2,3] then
 begin
  Az    := arctan2(xy.x,xy.y);
  cosAz := cos(Az);
  t     := PJ.PM.B*cosAz;
  B     := Pj.Ellps.es*t/Pj.Ellps.one_es;
  A     := -B*t;
  B     := 3*B*(1-A)*PJ.PM.A;
  D     := c/PJ.PM.Cy;
  E     := D*(1.-D*D*(A*(1.+A)/6.+B*(1.+3.*A)*D/24));
  F     := 1-E*E*(A/2.+B*E/6);
  psi   := aasin(PJ.PM.A*cos(E)+t*sin(E));
  result.lam := aasin(sin(Az)*sin(E)/cos(psi));
  t     := abs(psi);
  if t<1e-10 then result.phi := 0 else
  if abs(t-HALFPI)<0 then result.phi:=HALFPI else
  result.phi:=arctan((1-Pj.Ellps.es*F*PJ.PM.A/sin(psi))*tan(psi)/Pj.Ellps.one_es);
 end else
 //Polar
 case PJ.PM.mode of
  1 : begin
       result.phi := pj_inv_mlfn(PJ.PM.C+c,Pj.Ellps.es,PJ.PM.en,pj.errno);
       result.lam := arctan2(xy.x,xy.y);
      end;
  0 : begin
       result.phi:=pj_inv_mlfn(PJ.PM.C-c,Pj.Ellps.es,PJ.PM.en,pj.errno);
       result.lam := arctan2(xy.x,-xy.y);
      end
 end;
end;


function AeqdInvSpherical(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint; // spherical
var cosc, c_rh, sinc : double;
    xy  : T3dPoint;
begin
 xy:=pntXY;
 c_rh := hypot(xy.x, xy.y);
 if (c_rh<1E-10) then
 begin
  result.phi := PJ.C0.phi;
  result.lam := 0;
  exit;
 end;
 if c_rh>PI then
 begin
  pj.errno:=-integer(c_rh-1E-10>PI);
  if pj.errno<>0 then exit;
  c_rh := PI;
 end;
 sinc := sin(c_rh);
 cosc := cos(c_rh);
 with result do
 case PJ.PM.mode of
  2: begin
      phi  := aasin(xy.y * sinc/c_rh);
      xy.x := xy.x*sinc;
      xy.y := cosc * c_rh;
     end;
  3: begin
      phi  := aasin(cosc*PJ.PM.A+xy.y*sinc*PJ.PM.B/c_rh);
      xy.y := (cosc-PJ.PM.A*sin(phi))*c_rh;
      xy.x := xy.x*sinc*PJ.PM.B;
     end;
 0: begin
     phi := HALFPI-c_rh;
     lam := arctan2(xy.x,-xy.y);
    end;
 1: begin
     phi := c_rh - HALFPI;
     lam := arctan2(xy.x, xy.y);
    end;
 end;
 if PJ.PM.mode in [2,3] then result.lam:=arctan2(xy.x,xy.y);
end;

procedure InitAeqd(var PJ : TCustomProj;IsGuam : byte);
begin
 with PJ.PM do
 if (abs(abs(PJ.C0.phi)-HALFPI)<1E-10) then
 begin
  mode   := byte(PJ.C0.phi<0);
  A := sin(PJ.C0.phi);
  B := 0;
 end else
 if (abs(PJ.C0.phi)<1E-10) then
 begin
  mode   := 2;
  A := 0;
  B := 1;
 end else
 begin
  mode   := 3;
  A := sin(PJ.C0.phi);
  B := cos(PJ.C0.phi);
 end;
 if Pj.ellps.es<>0 then PJ.PM.en:= pj_enfn(Pj.ellps.es);
  with PJ.PM do
 case byte(Pj.ellps.es=0) of
  // spheroid
  1: begin
      PJ.fForward:=AeqdFwdSpherical;
      PJ.fInverse:=AeqdInvSpherical;
     end;
  // ellipsoid
  0: case IsGuam of
       1: begin
           Cx:=pj_mlfn(PJ.C0.phi,A,B,en);
           PJ.fForward:=AeqdFwdGuamElliptical;
           PJ.fInverse:=AeqdInvGuamElliptical;
          end; // 1- guam
       0: begin
           case mode of
             0: C := pj_mlfn(HALFPI,1,0,en);
             1: C := pj_mlfn(-HALFPI,-1,0,en);
           2,3: begin
                 Cy := 1/sqrt(1-Pj.ellps.es*A*A);
                 D  := Pj.ellps.e/sqrt(Pj.ellps.one_es);
                 G  := A*D;
                 D  := D*B;
		end;
           end; // case mode
           PJ.fForward:=AeqdFwdElliptical;
           PJ.fInverse:=AeqdInvElliptical;
          end;
      end;// case guam
 end; // case ellisoid
end;

function MercSphForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
begin
 pj.errno:=byte(abs(abs(lp.phi) - HALFPI) <= 1e-10);
 if pj.errno<>0 then exit;
 result.x := PJ.k0*lp.lam;
 result.y := PJ.k0*ln(tan(FORTPI+0.5*lp.phi));
end;

function MercSphInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint; // spheroid
begin
 result.phi := HALFPI-2*arctan(exp(-xy.y/PJ.k0));
 result.lam := xy.x/PJ.k0;
end;



function MercEllpsForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint;  // ellipsoid
begin
 pj.errno:=byte(abs(abs(lp.phi) - HALFPI) <= 1e-10);
 if pj.errno<>0 then exit;
 result.x := PJ.k0* lp.lam;
 result.y := -PJ.k0* ln(pj_tsfn(lp.phi, sin(lp.phi), PJ.Ellps.e));
end;

function MercEllpsInverse(XY : T3dPoint; PJ:PCustomProj): T3dPoint;  // ellipsoid
begin
 result.phi := pj_phi2(exp(-xy.y/PJ.k0),PJ.Ellps.e,pj.errno);
 pj.errno:=byte(isinfinite(result.phi));
 if pj.errno<>0 then exit;
 result.lam := xy.x /PJ.k0;
end;


function UTMForwardElps(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid
var al,als,cosphi,sinphi,t,n : double;
begin
 sinphi := sin(lp.phi);
 cosphi := cos(lp.phi);
 t      := sqr(tan(lp.phi));
 al     := cosphi*lp.lam;
 als    := sqr(al);
 al     := al/sqrt(1-PJ.Ellps.es*sinphi*sinphi);
 n      := PJ.PM.A*cosphi*cosphi;
 result.x:= PJ.k0*al*(1+als*(1-t+n+als*(5+t*(t-18)+n*(14-58*t)+als*(61+t*(t*(179-t)-479))/42)/20)/6);
 result.y:=PJ.k0*(pj_mlfn(lp.phi,sinphi,cosphi,PJ.PM.en)-PJ.PM.B+
 sinphi*al*lp.lam*0.5*(1+als*(5-t+n*(9+4*n)+als*(61+t*(t-58)+n*(270-330*t)+als*(1385+t*(t*(543-t)-3111))/56)/30)/12));
end;

function UTMForwardSph(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // spheroid
var cosphi,b:double;
begin
 cosphi   := cos(lp.phi);
 b        := cosphi*sin(lp.lam);
 pj.errno :=-byte(abs(abs(b)- 1)<=1e-10);
 if pj.errno<>0 then exit;
 result.x := PJ.PM.B*ln((1+ b)/(1-b));
 result.y := cosphi * cos(lp.lam)/sqrt(1-b*b);
 b        := abs(result.y);
 pj.errno :=-byte(b-1>1e-10);
 if pj.errno<>0 then exit;
 result.y := arccos(result.y);
 if (lp.phi<0) then result.y := -result.y;
 result.y := PJ.PM.A * (result.y - PJ.C0.phi);
end;


function UTMInverseElps(xy : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid
var con, cosphi, ds, sinphi,n, t,d : double;
begin
 result.phi := pj_inv_mlfn(PJ.PM.B+xy.y/PJ.k0, PJ.Ellps.es,PJ.PM.en,pj.errno);
 result.lam := 0;
 if abs(result.phi)<HALFPI then
 begin
  sinphi := sin(result.phi);
  cosphi := cos(result.phi);
  t      := tan(result.phi);
  n      := PJ.PM.A*cosphi*cosphi;
  con    := 1-PJ.Ellps.es*sinphi*sinphi;
  d      := xy.x*sqrt(con)/PJ.k0;
  con    := con*t;
  t      := sqr(t);
  ds     := sqr(d);
  result.phi := result.phi-0.5*(con*ds/(1-PJ.Ellps.es))*
      (1-ds*(5+t*(3-9*n)+n*(1-4*n)-ds*(61+t*(90-252*n+45*t)+46*n-ds*(1385+t*(3633+t*(4095+1574*t)))/56)/30)/12);
  result.lam :=d*(1-ds*(1+2*t+n-ds*(5+t*(28+24*t+8*n)+6*n-ds*(61+t*(662+t*(1320+720*t)))/42)/20)/6)/cosphi;
 end else
 result.phi:=sign(xy.y)*HALFPI;
end;


function UTMInverseSph(xy : T3dPoint;PJ:PCustomProj): T3dPoint; //  spheroid
var h, g : double;
begin
 h := exp(xy.x/PJ.PM.A);
 g := 0.5 * (h - 1/h);
 h := cos(PJ.C0.phi+xy.y/PJ.PM.A);
 result.phi := arcsin(sqrt((1-sqr(h))/(1+sqr(g))));
 if (xy.y<0) then result.phi := -result.phi;
 if (g=h) and (g=0) then result.lam:=0
 else result.lam:=arctan2(g,h);
end;

// general initialization

procedure InitTransMercator(var PJ:TCustomProj; Bts: double);
begin
 with PJ.PM do
 case byte(PJ.Ellps.es>0) of
  1: begin
      en  := pj_enfn(PJ.Ellps.es);
      B   := pj_mlfn(PJ.C0.phi, sin(PJ.C0.phi), cos(PJ.C0.phi),en);
      A   := PJ.Ellps.es/(1-PJ.Ellps.es);
      PJ.fInverse := UTMInverseElps;
      PJ.fForward := UTMForwardElps;
     end;
  0: begin
      A  := PJ.k0;
      B  := 0.5*PJ.k0;
      PJ.fInverse := UTMInverseSph;
      PJ.fForward := UTMForwardSph;
     end;
  end;
end;

procedure InitMercator(var PJ:TCustomProj; Bts: double);
var is_phits : boolean;
begin
  PJ.Bts:=Bts;
  is_phits:=not IsInfinite(PJ.Bts);
  if is_phits then
  begin
   pj.errno:=-24*byte(abs(PJ.Bts) >= HALFPI);
   if pj.errno<>0 then exit;
  end;
  PJ.k0:=1;
  with PJ.PM do
  case byte(Pj.Ellps.es<>0) of
  // ellipsoid
  1: begin
      if is_phits then PJ.k0:=pj_msfn(sin(Abs(PJ.Bts)),cos(Abs(PJ.Bts)),Pj.Ellps.es);
      PJ.fInverse := MercEllpsInverse;
      PJ.fForward := MercEllpsForward;
     end;
  // sphere
  0: begin
      if is_phits then PJ.k0:=cos(Abs(PJ.Bts));
      PJ.fInverse := MercSphInverse;
      PJ.fForward := MercSphForward;
     end;
  end;
end;


procedure InitUTM(var PJ:TCustomProj;uZone:byte);
var Zone : integer;
begin
  Zone:=uZone;
  pj.errno:=-34*byte(PJ.Ellps.es=0);
  if pj.errno=0 then pj.errno:=-35*byte(not(Zone in [0..59,255]));
  if pj.errno<>0 then exit;
  if  Pj.south=1 then PJ.y0 := 1E7;
  PJ.x0 := 5E5;
  // nearest central meridian input //
  if Zone=255 then
  begin
   zone := floor((adjlon(PJ.C0.lam)+PI)* 30/PI);
   if Zone<0 then zone:=0 else
   if Zone>=60 then Zone:=59;
  end else
  Zone:=Zone-1;
  PJ.C0.lam := (zone+0.5)*PI/30- PI;
  PJ.k0   := 0.9996;
  PJ.C0.phi := 0.0;
  InitTransMercator(PJ,1/0);
end;



function TSFN0(Value: double):double;
begin
 result:=tan(0.5*(HALFPI-Value));
end;

function OMercForward(LP : T3dPoint;PJ:PCustomProj): T3dPoint; // ellipsoid & spheroid */
var con, q, s, ul, us, vl, vs : double;
begin
 vl := sin(PJ.PM.B*lp.lam);
 if (abs(abs(lp.phi)-HALFPI)<=1E-10) then
 begin
  ul := sin(PJ.PM.G)*(1-2*byte(lp.phi<0));
  us := PJ.PM.A* lp.phi/PJ.PM.B;
 end else
 begin
  case byte(PJ.Ellps.es<>0) of
   1: q:=PJ.PM.C/power(pj_tsfn(lp.phi, sin(lp.phi),PJ.Ellps.e),PJ.PM.B);
   0: q:=PJ.PM.C/TSFN0(lp.phi);
  end;
  s   := 0.5*(q-1/q);
  ul  := 2*(s*sin(PJ.PM.G)-vl*cos(PJ.PM.G))/(q+1/q);
  con := cos(PJ.PM.B*lp.lam);
  if abs(con)>=1E-7 then
  begin
   us := PJ.PM.A*arctan((s*cos(PJ.PM.G)+vl*sin(PJ.PM.G))/con)/PJ.PM.B;
   if con<0 then us:=us+PI*PJ.PM.A/PJ.PM.B;
  end else
  us := PJ.PM.A*PJ.PM.B*lp.lam;
 end;
 if (abs(abs(ul)-1)<=1E-10) then exit;
 vs := 0.5*PJ.PM.A*ln((1-ul)/(1+ul))/PJ.PM.B;
 us := us-PJ.PM.rho0;
 case PJ.PM.mode of
  0: begin
      result.x := us;
      result.y := vs;
     end;
  1: begin
      result.x := vs*cos(PJ.PM.rho)+us*sin(PJ.PM.rho);
      result.y := us*cos(PJ.PM.rho)-vs*sin(PJ.PM.rho);
     end;
 end;
end;


//*
function OMercInverse(xy : T3dPoint;PJ:PCustomProj): T3dPoint; //  ellipsoid & spheroid */
var q, s, ul, us, vl, vs : double;
begin
 case PJ.PM.mode of
  0: begin
      us := xy.x;
      vs := xy.y;
     end;
  1: begin
      vs := xy.x*cos(PJ.PM.rho)-xy.y*sin(PJ.PM.rho);
      us := xy.y*cos(PJ.PM.rho)+xy.x*sin(PJ.PM.rho);
     end;
 end;
 us := us+PJ.PM.rho0;
 q  := exp(-PJ.PM.B*vs/PJ.PM.A);
 s  := 0.5 * (q-1/q);
 vl := sin(PJ.PM.B*us/PJ.PM.A);
 ul := 2*(vl*cos(PJ.PM.G)+s*sin(PJ.PM.G))/(q+1/q);
 if (abs(abs(ul)-1)<1E-10) then
 begin
  result.lam := 0;
  result.phi := HALFPI*(1-2*byte(ul<0));
 end else
 begin
  result.phi :=PJ.PM.C/sqrt((1+ul)/(1-ul));
  case byte(PJ.Ellps.Es<>0) of
   1: result.phi:=pj_phi2(power(result.phi,1/PJ.PM.B),PJ.Ellps.e,pj.errno);
   0: result.phi:=HALFPI-2*arctan(result.phi);
  end;
  result.lam:=-arctan2((s*cos(PJ.PM.G)-vl*sin(PJ.PM.G)), cos(PJ.PM.B*us/PJ.PM.A))/PJ.PM.B;
 end;
end;


procedure BeforeOMercator(var PJ : TCustomProj;var con,f,d: double);
var sinph0,cosph0,com : double;
begin
  com:=1;
  if PJ.Ellps.Es<>0 then com:=sqrt(PJ.Ellps.one_es);
  case byte(abs(PJ.C0.phi)>1E-10) of
   1: begin
       sinph0 := sin(PJ.C0.phi);
       cosph0 := cos(PJ.C0.phi);
       if PJ.Ellps.Es<>0 then
       begin
	con     := 1-PJ.Ellps.es*sinph0*sinph0;
	PJ.PM.B := sqrt(1+PJ.Ellps.es*power(cosph0,4)/PJ.Ellps.one_es);
	PJ.PM.A := PJ.PM.B* PJ.k0*com/con;
	d       := PJ.PM.B*com/(cosph0 * sqrt(con));
       end else
       begin
	PJ.PM.B := 1.0;
	PJ.PM.A := PJ.k0;
	d       := 1/cosph0;
       end;
       f     := sqr(d)-1;
       if f<=0 then f:=0 else f := (1-2*byte(PJ.C0.phi<0))*sqrt(f);
       f := f + d;
       PJ.PM.C := f;
       case byte(PJ.Ellps.Es<>0) of
	1: PJ.PM.C := PJ.PM.C*power(pj_tsfn(PJ.C0.phi, sinph0, PJ.Ellps.e),PJ.PM.B);
	0: PJ.PM.C := PJ.PM.C*TSFN0(PJ.C0.phi);
       end;
      end;
   0: begin
       PJ.PM.B := 1/com;
       PJ.PM.A := PJ.k0;
       PJ.PM.C := 1;
       d     := 1;
       f     := 1;
      end;
  end; // case
end;


// +lon_1=10 +lon_2=20 +no_rot +no_uoff
procedure InitOMercator(var PJ : TCustomProj;B1,B2,L1,L2:double;Rotate,Offset,RotConv:byte);
var con,d,h,l,f,p,j,_l,alpha : double;
begin
  PJ.k0 := 1;  PJ.PM.mode:=rotate;
  pj.errno :=-byte(IsInfinite(B1) or IsInfinite(B2)or IsInfinite(L1)or IsInfinite(L2));
  if pj.errno<>0 then exit;
  con      := abs(B1);
  pj.errno := -33*byte((abs(B1-B2)<=1E-7) or (con<=1E-7) or (abs(con-HALFPI)<=1E-7) or
  (abs(abs(PJ.C0.phi)-HALFPI)<=1E-7) or (abs(abs(B2)-HALFPI)<=1E-7));
  if pj.errno<>0 then exit;
  BeforeOMercator(PJ,con,f,d);
  case byte(PJ.Ellps.es<>0) of
    1: begin
	h := power(pj_tsfn(B1, sin(B1),PJ.Ellps.e),PJ.PM.B);
	l := power(pj_tsfn(B2, sin(B2),PJ.Ellps.e),PJ.PM.B);
       end;
    0: begin
	h := TSFN0(B1);
	l := TSFN0(B2);
       end;
   end; // case
   f   := PJ.PM.C/h;
   p   := (l-h)/(l+h);
   j   := (sqr(PJ.PM.C)-l*h)/(sqr(PJ.PM.C)+l*h);
   con := L1-L2;
   _L  := L2;
   if (con<-PI) then _L:=_L-TWOPI else
   if (con>PI) then _L:=_L+TWOPI;
   PJ.C0.lam  := adjlon(0.5*(L1+_L)-arctan(j*tan(0.5*PJ.PM.B*(L1-_L))/p)/PJ.PM.B);
   PJ.PM.G := arctan(2*sin(PJ.PM.B*adjlon(L1-PJ.C0.lam))/(f-1/f));
   alpha   := arcsin(d*sin(PJ.PM.G));
   if RotConv=1 then PJ.PM.rho:=PJ.PM.G else
   PJ.PM.rho:=alpha;
   if Offset<>0 then
   PJ.PM.rho0:=(1-2*byte(PJ.C0.phi<0))*abs(PJ.PM.A*arctan(sqrt(d*d-1)/cos(PJ.PM.rho))/PJ.PM.B);
   PJ.fInverse := OMercInverse;
   PJ.fForward := OMercForward;
end;

// +alpha=38 +lonc=45 +no_rot +no_uoff +rot_conv
procedure InitOMercator(var PJ : TCustomProj;Alpha,Lc:double;Rotate,Offset,RotConv:byte);
var con,f,d : double;
begin
 PJ.k0 := 1;  PJ.PM.mode:=rotate;
 pj.errno := -32*byte((abs(alpha)<=1E-7) or
 (abs(abs(PJ.C0.phi)-HALFPI)<=1E-7) or (abs(abs(alpha)-HALFPI)<=1E-7));
 if pj.errno<>0 then exit;
 con:=0;
 BeforeOMercator(PJ,con,f,d);
 PJ.PM.G     := arcsin(sin(Alpha)/d);
 PJ.C0.lam   := Lc-arcsin((0.5*(f-1/f))*tan(PJ.PM.G))/PJ.PM.B;

 if RotConv=1 then PJ.PM.rho:=PJ.PM.G else
 PJ.PM.rho:=alpha;

 if Offset<>0 then
 PJ.PM.rho0:=(1-2*byte(PJ.C0.phi<0))*abs(PJ.PM.A*arctan(sqrt(d*d-1)/cos(PJ.PM.rho))/PJ.PM.B);
 PJ.fInverse := OMercInverse;
 PJ.fForward := OMercForward;;
end;

// =============================================================================
// GAUSS-KRUGER
function GaussForward(lp : T3dPoint;PJ:PCustomProj): T3dPoint;
var N, X, l_ro, l_ro2, T2, n2, Long: extended;
    Zone : byte;
begin
   X:=PJ.Ellps.a*(1-PJ.Ellps.es)*(1.0050517739*lp.phi-0.5*0.0050623776*sin(2*lp.phi)+
   0.25*0.0000106245*sin(4*lp.phi)+0.0000000208*sin(6*lp.phi)/6);
   N:=PJ.Ellps.a/sqrt(1-PJ.Ellps.es*sqr(sin(lp.phi)));
   T2:=sqr(tan(lp.phi));
   n2:=PJ.Ellps.es*sqr(cos(lp.phi))/(1-PJ.Ellps.es);
   if lp.lam<0 then Long:=RadToDeg(2*pi+lp.lam) else Long:=RadToDeg(lp.lam);
   Zone:=Trunc(Long/6)+1;
   L_ro:=0.017453276125372700167260562868155*(Long-(Zone*6-3))*cos(lp.phi);
   l_ro2:=l_ro*l_ro;
   result.X:=l_ro2*(1+l_ro2*((5-T2+9*n2+4*n2*n2)+l_ro2*(61-58*t2+t2*t2+270*n2-330*n2*t2)/30)/12);
   result.X:=X+0.5*result.X*N*tan(lp.phi);
   result.Y:=1+l_ro2*(1-T2-n2+l_ro2*((5-18*t2+t2*t2+14*n2-58*n2*t2+13*n2*n2-64*n2*n2*t2)+
   l_ro2*(61-479*t2+179*t2*t2-t2*t2*t2)/42)/20)/6;
   result.Y:=l_ro*N*result.Y;
   result.X := result.X/PJ.Ellps.a;
   result.Y :=((result.Y+(5E5+Zone*1E6))/PJ.to_meter)/PJ.Ellps.a;
end;


// GAUSS-KRUGER
function GaussInverse(PntXY : T3dPoint;PJ:PCustomProj): T3dPoint;
var  L0, B, n2, t2, y, y2, cosB : extended;
     rMax, rMin, delta : extended;
     i                 : byte;
     XY                : T3dPoint;
begin
 XY.x:= (PntXy.x/PJ.Ellps.ra)/PJ.to_meter;
 XY.y:= (PntXy.y/PJ.Ellps.ra)/PJ.to_meter;
 rMax:=pi/2; rMin:=-pi/2;
 i:=0; B:=0;

 delta:=3.1574632693616299*PJ.Ellps.a*(1-PJ.Ellps.es);
 if (delta<Abs(XY.X)) then B:=Pi*(1-2*byte(XY.X<0))/2 else
 begin
  repeat
   inc(i);
   if delta>0 then rMin:=B;
   if delta<0 then rMax:=B;
   B:=(rMax+rMin)/2;
   Delta:=XY.X-PJ.Ellps.a*(1-PJ.Ellps.es)*(1.0050517739*B-0.5*0.0050623776*sin(2*B)+
   0.25*0.0000106245*sin(4*B)+0.0000000208*sin(6*B)/6);
  until (Abs(Delta)<=1e-8) or (i>253);
  B:=(rMax+rMin)/2;
 end;
 cosB:=cos(B);
 t2:=sqr(tan(B));
 n2:=PJ.Ellps.es*sqr(cosB)/(1-PJ.Ellps.es);
 y:=(1e6*Frac(XY.Y/1E6)-5e5)*sqrt(1-PJ.Ellps.es*sqr(sin(B)))/PJ.Ellps.a;
 y2:=sqr(y);
 L0:=Trunc(XY.Y/1E6)*6-3;
 result.Y:=1-y2*((1+2*t2+n2)+y2*(0.25+1.4*t2+1.2*t2*t2+3*n2/10+0.4*t2*n2))/6;
 result.Y:=DegToRad(L0+y*result.Y*57.2958333333333333333/cosB);
 result.X:=(5+3*t2+6*n2-6*n2*t2)-y2*(2+1/30+3*t2+1.5*t2*t2);
 result.X:=B-DegToRad(y2*(0.5*(1+N2)+y2*result.X/24)*57.29583333333333333333*tan(B));
end;

procedure InitGaussKruger(var PJ:TCustomProj);
begin
  PJ.C0.phi:=0; PJ.C0.lam:=0;
  PJ.x0:=0;     Pj.y0:=0;
  PJ.to_meter := 1;
  PJ.fInverse := GaussInverse;
  PJ.fForward := GaussForward;
end;


function Pz90Forward(lp : T3dPoint;PJ:PCustomProj): T3dPoint;
begin
  result:=GaussForward(lp, PJ);
  with result do
  begin
   // cite
   x := (PJ.Ellps.a*x+PJ.x0)/PJ.to_meter;
   y := (PJ.Ellps.a*y+PJ.y0)/PJ.to_meter;
   // shift
   X:=X-3.3*Y*1E-6+1.8*Z*1E-6+25;
   Y:= 3.3*X*1E-6+Y-141;
   Z:=-1.8*X*1E-6 + Z-80;
   // return
   x := (PJ.to_meter*x-PJ.x0)/PJ.Ellps.a;
   y := (PJ.to_meter*y-PJ.y0)/PJ.Ellps.a;
  end;
end;


function Pz90Inverse(PntXY : T3dPoint;PJ:PCustomProj): T3dPoint;
var fPoint : T3dPoint;
begin
  fPoint := PntXY;
  with fPoint do
  begin
    x := (x/PJ.Ellps.ra+PJ.x0)/PJ.to_meter;
    y := (y/PJ.Ellps.ra+PJ.y0)/PJ.to_meter;
    X:= X+3.3*Y*1E-6-1.8*Z*1E-6-25;
    Y:= -3.3*X*1E-6+Y+141;
    Z:= (1.8*X*1E-6+Z+80);
    x:= (x*PJ.to_meter-PJ.x0)*PJ.Ellps.ra;
    y:= (y*PJ.to_meter-PJ.y0)*PJ.Ellps.ra;
  end;
  result:=GaussInverse(fPoint, PJ);
end;

// initialize as in the Gauss-Krugerr projection
procedure InitPZ90(var PJ : TCustomProj);
begin
  PJ.C0.phi:=0; PJ.C0.lam:=0;
  PJ.x0:=0;     Pj.y0:=0;
  PJ.to_meter := 1;
  PJ.fInverse := Pz90Inverse;
  PJ.fForward := Pz90Forward;
end;

function CK95Forward(lp : T3dPoint;PJ:PCustomProj): T3dPoint;
begin
  result:=GaussForward(lp, PJ);
  with result do
  begin
   // cite
   x := (PJ.Ellps.a*x+PJ.x0)/PJ.to_meter;
   y := (PJ.Ellps.a*y+PJ.y0)/PJ.to_meter;
   // shift
   X:=(X-3.3*Y*1E-6+1.8*Z*1E-6+25)-25.9;
   Y:=(3.3*X*1E-6+Y-141)+130.94;
   Z:=(-1.8*X*1E-6+Z-80)-81.76;
   // return
   x := (PJ.to_meter*x-PJ.x0)/PJ.Ellps.a;
   y := (PJ.to_meter*y-PJ.y0)/PJ.Ellps.a;
  end;
end;


function CK95Inverse(PntXY : T3dPoint;PJ:PCustomProj): T3dPoint;
var fPoint : T3dPoint;
begin
  fPoint := PntXY;
  with fPoint do
  begin
    x := (x/PJ.Ellps.ra+PJ.x0)/PJ.to_meter;
    y := (y/PJ.Ellps.ra+PJ.y0)/PJ.to_meter;
    X := (X+3.3*Y*1E-6-1.8*Z*1E-6-25)+25.9;
    Y := (-3.3*X*1E-6+Y+141)-130.94;
    Z := (1.8*X*1E-6+Z+80)-81.76;
    x := (x*PJ.to_meter-PJ.x0)*PJ.Ellps.ra;
    y := (y*PJ.to_meter-PJ.y0)*PJ.Ellps.ra;
  end;
  result:=GaussInverse(fPoint, PJ);
end;

// initialize as in the Gauss-Krugerr projection
procedure InitCK95(var PJ : TCustomProj);
begin
  PJ.C0.phi:=0; PJ.C0.lam:=0;
  PJ.x0:=0;     Pj.y0:=0;
  PJ.to_meter := 1;
  PJ.fInverse := CK95Inverse;
  PJ.fForward := CK95Forward;
end;


function GinsForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := lp.phi*(1+sqr(lp.phi)/12);
 result.x := lp.lam*(1-0.162388*sqr(lp.phi));
 result.x := result.x*(0.87-0.000952426*power(lp.lam,4));
end;


function FaheyForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x:=tan(0.5*lp.phi);
 result.y:=1.819152*result.x;
 result.x:=0.819152*lp.lam*asqrt(1-sqr(result.x));
end;

function FaheyInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var V : double;
begin
 result.phi := 2*arctan(xy.y/1.819152);
 V:=1-sqr(xy.y/1.819152);
 result.lam := xy.x*byte(abs(V)>=TOL)/(0.819152*sqrt(V));
end;
            
procedure InitFahey(var PJ : TCustomProj);
begin
 Pj.fForward:=FaheyForward;
 Pj.fInverse:=FaheyInverse;
 Pj.Ellps.Es:=0;
end;

procedure InitGinsburg(var PJ : TCustomProj);
begin
 Pj.fForward:=GinsForward;
 Pj.Ellps.Es:=0;
end;


function GallForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x := 0.70710678118654752440*lp.lam;
 result.y := 1.70710678118654752440*tan(0.5*lp.phi);
end;

function GallInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.lam := 1.41421356237309504880*xy.x;
 result.phi := 2*arctan(xy.y*0.58578643762690495119);
end;

procedure InitGall(var PJ : TCustomProj);
begin
 Pj.fForward:=GallForward;
 Pj.fInverse:=GallInverse;
 Pj.Ellps.Es:=0;
end;

function LaskForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x:=lp.lam*(0.975534-sqr(lp.phi)*(0.0143059*sqr(lp.lam)+0.0547009*sqr(lp.phi)+0.119161));
 result.y:=lp.phi*(1.00384+sqr(lp.lam)*(0.0802894-0.0285500*sqr(lp.phi)+sqr(lp.lam)*0.000199025)+
 sqr(lp.phi)*(0.0998909-0.0491032*sqr(lp.phi)));
end;


procedure InitLask(var PJ : TCustomProj);
begin
 Pj.fForward:=LaskForward;
 Pj.Ellps.Es:=0;
end;

function DenoyForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := lp.phi;
 result.x := lp.lam*cos((0.95+abs(lp.lam)*(sqr(lp.lam)/600-1/12))*
  (lp.phi*(0.9+0.03*power(lp.phi,4))));
end;

procedure InitDenoy(var PJ : TCustomProj);
begin
 Pj.fForward:=DenoyForward;
 Pj.Ellps.Es:=0;
end;

function CrasterForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
  result.x := 0.97720502380583984317*lp.lam*(2*cos(2*lp.phi/3)-1);
  result.y := 3.06998012383946546542*sin(lp.phi/3);
end;

function CrasterInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.phi:=3*arcsin(xy.y*0.32573500793527994772);
 result.lam:=xy.x*1.02332670794648848847/(2*cos(2*result.phi/3)-1);
end;

procedure InitCraster(var PJ : TCustomProj);
begin
 Pj.fForward:=CrasterForward;
 Pj.fInverse:=CrasterInverse;
 Pj.Ellps.Es:=0;
end;


function HammerForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var d : double;
begin
 d        := sqrt(2/(1+cos(lp.phi)*cos(lp.lam*PJ.PM.A)));
 result.x := PJ.PM.B*d*cos(lp.phi)*sin(lp.lam*PJ.PM.A);
 result.y := d*sin(lp.phi)*PJ.PM.Cp;
end;


procedure InitHammer(var PJ : TCustomProj; dW, dM : double);
begin
 PJ.PM.A:=dW; PJ.PM.B:=dM;
 if IsInfinite(dW) then PJ.PM.A:=0.5;
 if IsInfinite(dM) then PJ.PM.B:=1;

 pj.errno:=-27*byte((PJ.PM.A<=0) or (PJ.PM.B<=0));
 if pj.errno<>0 then exit;
 PJ.PM.Cp   := 1/PJ.PM.B;
 PJ.PM.B    := PJ.PM.B/PJ.PM.A;
 Pj.fForward:=HammerForward;
 Pj.Ellps.Es:=0;
end;


function RPolyForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var fa : double;
begin
 case PJ.PM.mode of
  1: fa := tan(lp.lam*PJ.PM.Cy)*PJ.PM.Cx;
  0: fa := 0.5*lp.lam;
 end;
 case byte(abs(lp.phi)<1e-9) of
  1: begin
      result.x := 2*fa;
      result.y := -PJ.C0.phi;
     end;
  0: begin
      result.y := 1/tan(lp.phi);
      fa       := 2* arctan(fa * sin(lp.phi));
      result.x := sin(fa)*result.y;
      result.y := lp.phi-PJ.C0.phi+(1-cos(fa))*result.y;
     end;
 end;
end;

procedure InitRPoly(var PJ : TCustomProj; Bts:double);
begin
 PJ.Bts:= Bts;

 if IsInfinite(PJ.Bts) then PJ.Bts:=0;
 PJ.B1:=PJ.Bts;
 PJ.PM.mode:=byte(PJ.B1>1e-9);
 if PJ.PM.mode<>0 then
 begin
  PJ.PM.Cy := 0.5*sin(PJ.B1);
  PJ.PM.Cx := 0.5/PJ.PM.Cy;
 end;
 Pj.fForward:=RPolyForward;
 Pj.Ellps.Es:=0;
end;


function BoggsForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var theta,th1,c : double;
    i         : integer;
begin
 theta := lp.phi;
 if (abs(abs(lp.phi)-HALFPI)>=1e-7) then 
 begin
  c:= sin(theta)*PI;
  for i:=20 downto 0 do
  begin
   th1   := (theta+sin(theta)-c)/(1+cos(theta));
   theta := theta-th1;
   if abs(th1)<1e-7 then break;
  end;
  theta   := theta*0.5;
  result.x:= 2.00276*lp.lam/(1./cos(lp.phi)+1.11072/cos(theta));
 end else
 result.x:= 0;
 result.y := 0.49931*(lp.phi+1.4142135623730950488*sin(theta));
end;


procedure InitBoggs(var PJ : TCustomProj);
begin
 Pj.fForward:=BoggsForward;
 Pj.Ellps.Es:=0;
end;


function CollignonForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.y := asqrt(1-sin(lp.phi));
 result.x := 1.1283791670955125739*lp.lam*result.y;
 result.y := 1.77245385090551602729*(1-result.y);
end;

function CollignonInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.phi := 1-sqr(xy.y/1.77245385090551602729-1);
 pj.errno:=-byte(abs(result.phi)>1.0000001);
 if pj.errno<>0 then exit;
 result.phi := arcsin(result.phi);
 result.lam := 1- sin(result.phi);
 if result.lam>0 then
 result.lam := xy.x/(1.1283791670955125739*sqrt(result.lam)) else
 result.lam := 0;
end;

procedure InitCollignon(var PJ : TCustomProj);
begin
 Pj.fForward:=CollignonForward;
 Pj.fInverse:=CollignonInverse;
 Pj.Ellps.Es:=0;
end;


function LagrangeForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var v,c, _phi : double;
begin
 case byte(abs(abs(lp.phi)-HALFPI)<1e-10) of
  1: begin
      result.x := 0;
      result.y := 2-4*byte(lp.phi<0);
     end;
  0: begin
      _phi   := sin(lp.phi);
      v      := PJ.PM.A*power((1+_phi)/(1-_phi),PJ.PM.Cy);
      c      := 0.5*(v+1/v)+cos(lp.lam*PJ.PM.Cx);
      pj.errno:=-27*byte(C<1E-10);
      if pj.errno<>0 then exit;
      result.x:=2.*sin(lp.lam*PJ.PM.Cx)/c;
      result.y:=(v-1/v)/c;
     end;
 end
end;

procedure InitLagrange(var PJ : TCustomProj; B1,dW : double);
var phi1 : double;
begin
 pj.errno:=-byte(IsInfinite(dW) or IsInfinite(B1));
 if pj.errno=0 then pj.errno:=-27*byte(dW<=0);
 if pj.errno<>0 then exit;
 PJ.PM.Cx  := 1/dW;
 PJ.PM.Cy := 0.5/dW;
 phi1  := sin(B1);
 pj.errno:=-22*byte(abs(abs(phi1)-1)<1e-10);
 if pj.errno<>0 then exit;
 PJ.PM.A  := power((1-phi1)/(1+phi1),PJ.PM.Cy);
 Pj.fForward:=LagrangeForward;
 Pj.Ellps.Es:=0;
// PJ.B1:=B1;
end;

function EQCForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.x:=PJ.PM.A*lp.lam;
 result.y:=lp.phi;
end;

function EQCInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
 result.phi := xy.y;
 result.lam := xy.x/PJ.PM.A;
end;

procedure InitEQC(var PJ : TCustomProj; Bts:double);
begin
 PJ.Bts:=Bts;
 if IsInfinite(PJ.Bts) then PJ.Bts:=0;
 PJ.PM.A:=cos(PJ.Bts);
 pj.errno:=-24*byte(PJ.PM.A<=0);
 if pj.errno<>0 then exit;
 Pj.fForward:=EQCForward;
 Pj.fInverse:=EQCInverse;
 Pj.Ellps.Es:=0;
end;


function FocSinForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
  result.x := lp.lam*cos(lp.phi)/(PJ.PM.A+(1-PJ.PM.A)*cos(lp.phi));
  result.y := PJ.PM.A* lp.phi + (1-PJ.PM.A)* sin(lp.phi);
end;

function FocSinInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var V : double;
    i : integer;
begin
  if (PJ.PM.A<>0) then
  begin
   result.phi := xy.y;
   for i:=10 downto 0 do
   begin
    V:=(PJ.PM.A*result.phi+(1-PJ.PM.A)*sin(result.phi)-xy.y)/
       (PJ.PM.A+(1-PJ.PM.A)*cos(result.phi));
    result.phi := result.phi-V;
    if abs(V)<1e-7 then	break;
   end;
   if i<=0 then result.phi :=HALFPI*(1-2*byte(xy.y<0));
  end else
   result.phi := aasin(xy.y);
  V := cos(result.phi);
  result.lam := xy.x * (PJ.PM.A+ (1-PJ.PM.A)* V) / V;
end;

procedure InitFoucautSin(var PJ : TCustomProj;dN:double);
begin
  if IsInfinite(dN) then PJ.PM.A:=0 else PJ.PM.A:=dN;
  pj.errno:=-99*byte((dn<0) or (dn>1));
  if pj.errno<>0 then exit;
  Pj.Ellps.Es:=0;
  Pj.fForward:=FocSinForward;
  Pj.fInverse:=FocSinInverse;
end;

function McSin2Forward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var k, V, t,_phi : double;
	  i : integer;
begin
  _phi:=lp.phi;
	k :=1.41546*sin(_phi);
	for i:=10 downto 0 do
  begin
   t := _phi/1.36509;
	 V := (0.45503*sin(t)+sin(_phi)-k)/(cos(t)/3+cos(_phi));
   _phi := _phi-V;
   if abs(V)<1e-7 then	break;
	end;
	result.x := 0.22248*lp.lam*(1+3*cos(_phi)/cos(_phi/1.36509));
	result.y := 1.44492*sin(_phi/1.36509);
end;

function McSin2Inverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var t : double;
begin
  t := aasin(xy.y/1.44492);
  result.phi := 1.36509*t;
  result.lam := xy.x / (0.22248*(1+3*cos(result.phi)/cos(t)));
  result.phi := aasin((0.45503* sin(t)+sin(result.phi))/1.41546);
end;

procedure InitMcSin2(var PJ : TCustomProj);
begin
 Pj.fForward:=McSin2Forward;
 Pj.fInverse:=McSin2Inverse;
 Pj.Ellps.Es:=0;
end;


function MbtFPPForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var _phi : double;
begin
  _phi     := arcsin(0.95257934441568037152*sin(lp.phi));
  result.x := 0.92582009977255146156*lp.lam*(2*cos(2*_phi/3)-1);
  result.y := 3.40168025708304504493*sin(_phi/3);
end;

function MbtFPPInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
  result.phi := aasin(xy.y/3.40168025708304504493);
  if pj.errno<>0 then exit;
  result.lam := xy.x/(0.92582009977255146156*(2*cos(2*result.phi)-1));
  result.phi := sin(result.phi*3)/0.95257934441568037152;
  result.phi := aasin(result.phi);
end;

procedure InitMcParabolic(var PJ : TCustomProj);
begin
 Pj.fForward:=MbtFPPForward;
 Pj.fInverse:=MbtFPPInverse;
 Pj.Ellps.Es:=0;
end;

function LoximForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
  result.y:=lp.phi-PJ.B1;
  if abs(result.y)>=1e-8 then
  begin
   result.x:=FORTPI+0.5*lp.phi;
   if (abs(result.x)>1e-8) and (abs(abs(result.x)-HALFPI)>1e-8) then
   result.x:=lp.lam*result.y/ln(tan(result.x)/PJ.PM.B) else
   result.x:=0;
  end else
  result.x := lp.lam*PJ.PM.A;
end;

function LoximInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
  result.phi := xy.y+PJ.B1;
  if abs(xy.y)>=1e-8 then
  begin
   result.lam := FORTPI+0.5*result.phi;
   if (abs(result.lam)>1e-8) and (abs(abs(result.lam)-HALFPI)>1e-8) then
   result.lam := xy.x*ln(tan(result.lam)/PJ.PM.B)/xy.y  else
   result.lam := 0;
  end else
  result.lam := xy.x/PJ.PM.A;
end;

procedure InitLoximuthal(var PJ : TCustomProj;B1:double);
begin
 PJ.B1:=B1;
 if IsInfinite(PJ.B1) then PJ.B1:=0;
 pj.errno:=-22*byte(cos(PJ.B1)<1e-8);
 if pj.errno<>0 then exit;

 PJ.PM.A:=cos(PJ.B1);
 PJ.PM.B:=tan(FORTPI+0.5*PJ.B1);
 Pj.fForward:=LoximForward;
 Pj.fInverse:=LoximInverse;
 Pj.Ellps.Es:=0;
end;


  {
PROJ_HEAD(goode, "Goode Homolosine") "\n\tPCyl, Sph.";
#define Y_COR		0.05280
#define PHI_LIM	0.71093078197902358062
}



function GoodeForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
begin
	if abs(lp.phi)>0.71093078197902358062 then
  begin
   result   := _Moll.fForward(lp,@_Moll);
 	 result.y := result.y-0.05280*(1-2*byte(lp.phi>= 0.0));
	end else
  result :=_Sinu.fForward(lp,@_Sinu)
end;

function GoodeInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint;// spheroid
var _xy : T3dPoint;
begin
  _xy :=xy;
	if abs(_xy.y)>0.71093078197902358062 then
	begin
    _xy.y  :=_xy.y+0.05280*(1-2*byte(_xy.y>= 0.0));
  	result := _Moll.fInverse(_xy,@_Moll);
	end else
  result := _Sinu.fInverse(_xy,@_Sinu);
end;


procedure InitGoode(var PJ : TCustomProj);
begin
 Pj.Ellps.Es:=0;
 _Sinu:=Pj; _Moll:=Pj;
 InitMoll(_Moll,HALFPI);
 InitSinu(_Sinu);
 Pj.fForward:=GoodeForward;
 Pj.fInverse:=GoodeInverse;
end;


function NicolForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var tb,c,d,m,n,r2,sp : double;
begin
  if (abs(lp.lam) < 1e-10) then
  begin
   result.x := 0;
   result.y := lp.phi;
  end else
  if (abs(lp.phi) < 1e-10) then
  begin
   result.x := lp.lam;
   result.y := 0.;
  end else
  if (abs(abs(lp.lam) - HALFPI) < 1e-10) then
  begin
   result.x := lp.lam * cos(lp.phi);
   result.y := HALFPI * sin(lp.phi);
  end else
  if (abs(abs(lp.phi) - HALFPI) < 1e-10) then
  begin
   result.x := 0;
   result.y := lp.phi;
  end else
  begin
  tb      := HALFPI/lp.lam-lp.lam/HALFPI;
  c       := lp.phi/HALFPI;
  sp      := sin(lp.phi);
  d       := (1-c*c)/(sp-c);
  r2      := tb/d;
  r2      := r2*r2;
  m       := (tb*sp/d-0.5*tb)/(1.+r2);
  n       := (sp/r2+0.5*d)/(1.+1./r2);
  result.x:= sqrt(m*m+sqr(cos(lp.phi))/(1+r2));
  result.x:= HALFPI*(m+result.x*(1-2*byte(lp.lam<0)));
  result.y:= sqrt(n*n-(sp*sp/r2+d*sp-1)/(1.+1./r2));
  result.y:= HALFPI*(n+result.y*(1-2*byte(lp.phi>0)));
 end;
end;


procedure InitNicol(var PJ : TCustomProj);
begin
 Pj.Ellps.Es:=0;
 Pj.fForward:=NicolForward;
end;


function HatanoForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var th1, c,_phi :double;
	  i : integer;
begin
  _phi:=lp.phi;
  case byte(_phi<0) of
   1: c:=sin(_phi)*2.43763;
   0: c:=sin(_phi)*2.67595;
  end;
  for i:=20 downto 0 do
  begin
   th1  := (_phi+sin(_phi)-c)/(1+ cos(_phi));
   _phi := _phi- th1;
   if (abs(th1) < EPS) then break;
  end;
  _phi:=0.5*_phi;
  result.x := 0.85*lp.lam*cos(_phi);
  case byte(_phi<0) of
   1: result.y:=sin(_phi)*1.93052;
   0: result.y:=sin(_phi)*1.75859;
  end;
end;

function HatanoInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint;// spheroid
var th :double;
begin
 // _phi:=lp.phi;
  case byte(xy.y<0) of
   1: th:= xy.y*0.51799515156538134803;
   0: th:= xy.y*0.56863737426006061674;
  end;
  th := aasin(th);
  if pj.errno<>0 then exit;
  result.lam := 1.17647058823529411764* xy.x / cos(th);
  th :=2*th;
  case byte(xy.y<0) of
   1: result.phi:=0.41023453108141924738*(th+sin(th));
   0: result.phi:=0.37369906014686373063*(th+sin(th));
  end;
  result.phi := aasin(result.phi);
end;

procedure InitHatano(var PJ : TCustomProj);
begin
 Pj.Ellps.Es:=0;
 Pj.fForward:=HatanoForward;
 Pj.fInverse:=HatanoInverse;
end;

function McQuarForward(lp: T3dPoint; PJ : PCustomProj):T3dPoint; // spheroid
var V,_phi,_c : double;
    i         : integer;
begin
 _phi:=lp.phi;
 _c := 1.7071067811865475244* sin(_phi);
 for i:= 20 downto 0 do
 begin
  V    := (sin(0.5*_phi)+sin(_phi)-_c)/(0.5*cos(0.5*_phi)+ cos(_phi));
  _phi := _phi-V;
  if (abs(V)<1e-7) then break;
 end;
 result.x:=0.31245971410378249250*lp.lam*(1+2*cos(_phi)/cos(0.5*_phi));
 result.y:=1.87475828462269495505*sin(0.5*_phi);
end;

function McQuarInverse(XY: T3dPoint; PJ : PCustomProj):T3dPoint;// spheroid
var t :double;
begin
 with result do
 begin
  phi := 0.53340209679417701685*xy.y;
  t   := phi;
  phi := 2*aasin(t);
  lam := 3.20041258076506210122*xy.x/(1+ 2*cos(phi)/cos(0.5*phi));
  phi := aasin(0.58578643762690495119*(t+sin(phi)));
 end;
end;

procedure InitMcQuartic(var PJ : TCustomProj);
begin
 Pj.Ellps.Es:=0;
 Pj.fForward:=McQuarForward;
 Pj.fInverse:=McQuarInverse;
end;


// albert equal area

function AEAForward(pntBL: T3dPoint; PJ : PCustomProj):T3dPoint;
var rho : double;
begin
  case byte(PJ.Ellps.es<>0) of
   1: rho:=PJ.PM.c-PJ.PM.b*pj_qsfn(sin(pntBL.phi),PJ.Ellps.e,PJ.Ellps.one_es);
   0: rho:=PJ.PM.c-2*PJ.PM.b*sin(pntBL.phi);
  end;
  if rho<0 then exit;
  rho      := sqrt(rho)/PJ.PM.b;
  result.x := rho * sin(pntBL.lam*PJ.PM.b);
  result.y := PJ.PM.rho0-rho*cos(pntBL.lam*PJ.PM.b);
end;


// ellipsoid & spheroid
function AEAInverse(pntXY: T3dPoint; PJ : PCustomProj):T3dPoint;
var XY  : T3dPoint;
    _rho : double;
begin
  XY    := pntXY;
  XY.y  := PJ.PM.rho0-XY.y;
  _rho  := hypot(XY.x,XY.y);
  if _rho=0.0 then
  begin
   result.lam := 0;
   result.phi := HALFPI*(1-2*byte(PJ.PM.b<=0));
   exit;
  end;
  if PJ.PM.b<0 then
  begin
   _rho:= -_rho;
   xy.x := -xy.x;
   xy.y := -xy.y;
  end;
  result.phi :=_rho*PJ.PM.b;

  case byte(PJ.Ellps.es<>0) of
   1: begin
       result.phi := (PJ.PM.c-sqr(result.phi))/PJ.PM.b;
       if (abs(PJ.PM.A-abs(result.phi))>1e-7) then
       begin
        result.phi := phiaea(result.phi, PJ.Ellps.e, PJ.Ellps.one_es);
        if IsInfinite(result.phi) then exit;
       end else
       result.phi := pi/2-pi*byte(result.phi<0);
      end;
   0: begin
       result.phi :=(PJ.PM.c-sqr(result.phi))/(2*PJ.PM.b);
       if abs(result.Y)<=1 then result.phi := arcsin(result.phi) else
       result.phi := pi/2-pi*byte(result.phi<0);
      end;
  end;
  result.lam := arctan2(xy.x, xy.y)/PJ.PM.b;
end;


procedure SetupAlbert(var PJ : TCustomProj);
var _cosphi,_ml1,_ml2,_m2,
    _m1, _sinphi : double;
    secant     : byte;
begin
  with PJ.PM do
  begin
  if (abs(PJ.B1 + PJ.B2)<TOL) then pj.errno:=-21;
  B      := sin(PJ.B1);
  secant := byte(abs(PJ.B1-PJ.B2)>=1e-10);
  case byte(PJ.Ellps.es<>0) of
  1: begin
       en   := pj_enfn(PJ.Ellps.es);
      _m1   := pj_msfn(sin(PJ.B1),cos(PJ.B1),PJ.Ellps.es);
      _ml1  := pj_qsfn(sin(PJ.B1),PJ.Ellps.e,PJ.Ellps.one_es);
      if secant<>0 then
      begin // secant cone */
       _m2  := pj_msfn(sin(PJ.B2), cos(PJ.B2), Pj.Ellps.es);
       _ml2 := pj_qsfn(sin(PJ.B2), Pj.Ellps.e, Pj.Ellps.one_es);
       B := (_m1*_m1-_m2*_m2)/(_ml2-_ml1);
      end;
      A := 1-0.5*Pj.Ellps.one_es*ln((1-Pj.Ellps.e)/(1+Pj.Ellps.e))/Pj.Ellps.e;
      c  := _m1*_m1+b*_ml1;
      rho0 := sqrt(c-b*pj_qsfn(sin(PJ.C0.phi),Pj.Ellps.e,Pj.Ellps.one_es))/B;
     end;
  0: begin
      if secant=1 then b:=0.5*(b+sin(PJ.B2));
      c    := sqr(cos(PJ.B1))+2*b*sin(PJ.B1);
      rho0 := sqrt(c-2*b*sin(PJ.C0.phi))/b;
     end;
  end; // case
  end;
  Pj.fForward:=aeaForward;
  Pj.fInverse:=aeaInverse;
end;


  procedure InitAEA(var PJ : TCustomProj; B1,B2 : double);
  begin
   if IsInfinite(B1) then PJ.B1:=0 else PJ.B1:=B1;
   if IsInfinite(B2) then PJ.B2:=0 else PJ.B2:=B2;
   if (PJ.B1=0) and (PJ.B2=0) then
   begin
    PJ.B1:=DegToRad(45.5);
    PJ.B2:=DegToRad(29.5);
   end;
   SetupAlbert(PJ);
  end;

  procedure InitLEAC(var PJ : TCustomProj;B1 : double);
  begin
   if IsInfinite(B1) then PJ.B1:=0 else PJ.B1:=B1;
   PJ.B2:=PJ.B1;
   PJ.B1:=pi*(1-2*PJ.south)/2;
   SetupAlbert(PJ);
  end;

// *************************************************************** //
// ***                                                         *** //
// ***                                                         *** //
// ***                                                         *** //
// *************************************************************** //
{
function pj_deriv(pnt_lp:TPJPoint;h : double;var P :TCustomProj;var Der : TDerivs):byte;
var lp : TPJPoint;
    t  : TPJPoint;
begin
 lp.lam := pnt_lp.lam+h;
 lp.phi := pnt_lp.phi+h;
 result:=1;
 if (abs(lp.phi) > HALFPI) then exit;
 h :=h+h;
 t:=P.fForward(lp,@P);
 if IsInfinite(t.x) then exit;
 der.x_l := t.x;  der.y_p := t.y;
 der.x_p := -t.x; der.y_l := -t.y;
 lp.phi := lp.phi-h;
 if (abs(lp.phi) > HALFPI) then exit;
 t:=P.fForward(lp,@P);
 if IsInfinite(t.x) then exit;
 der.x_l :=der.x_l+t.x;
 der.y_p :=der.y_p-t.y;
 der.x_p :=der.x_p+t.x;
 der.y_l :=der.y_l-t.y;
 lp.lam := lp.lam-h;
 t:=P.fForward(lp,@P);
 if IsInfinite(t.x) then exit;
 der.x_l :=der.x_l-t.x;
 der.y_p :=der.y_p-t.y;
 der.x_p :=der.x_p+t.x;
 der.y_l :=der.y_l+t.y;
 lp.phi := lp.phi+h;
 t:=P.fForward(lp,@P);
 if IsInfinite(t.x) then exit;
 der.x_l :=0.5*(der.x_l-t.x)/h;
 der.y_p :=0.5*(der.y_p+t.y)/h;
 der.x_p :=0.5*(der.x_p-t.x)/h;
 der.y_l :=0.5*(der.y_l+t.y)/h;
 result:=0;
end;


//pj_factors(LP lp, PJ *P, double h, struct FACTORS *fac)
function pFactors(ptLP:TPJPoint;var h:double): byte;
var der        : TDerivs;
    cosphi,t,r : double;
    lp         : TPJPoint;
begin
 lp:=ptLP;
 result:=1;
 //check for forward and latitude or longitude overange
 t := abs(lp.phi)-HALFPI;
 if (t> 1.0e-12)or (abs(lp.lam)>10) then
 begin
  pj_errno := -14;
  exit;
 end;
 // proceed
 pj_errno := 0;
 // adjust to pi/2
 if (abs(t)<=1.0e-12) then lp.phi := HALFPI*(1-2*byte(lp.phi<0)) else
 //if FPJ.geoc=1 then lp.phi := arctan(FPJ.ellps.rone_es*tan(lp.phi));
 lp.lam :=lp.lam-FPJ.C0.lam;	// compute del lp.lam
 if FPJ.over =0 then lp.lam := adjlon(lp.lam); // adjust del longitude
 if (h<=0) then	h := 1e-5;
 // get what projection analytic values
 if Assigned(FPJ.fSpecial) then FPJ.fSpecial(lp,@FPJ);

 if (FPJ.fact.code and (IS_ANAL_XL_YL+IS_ANAL_XP_YP))<>IS_ANAL_XL_YL+IS_ANAL_XP_YP and
 pj_deriv(lp,h,FPJ,der) then exit;
 with FPJ do
 begin
 if fact.code and IS_ANAL_XL_YL=0 then
 begin
  fact.der.x_l := der.x_l;
  fact.der.y_l := der.y_l;
 end;
 if fact.code and IS_ANAL_XP_YP=0 then
 begin
  fact.der.x_p := der.x_p;
  fact.der.y_p := der.y_p;
 end;
 cosphi := cos(lp.phi);
 case  fact.code and IS_ANAL_HK of
  0: begin
      fact.h := hypot(fact.der.x_p, fact.der.y_p);
      fact.k := hypot(fact.der.x_l, fact.der.y_l)/cosphi;
      if (ellps.es>0) then
      begin
        t := 1-ellps.es*sqr(sin(lp.phi));
        fact.h :=fact.h*sqrt(t)*t/ellps.es;
        fact.k :=fact.k*sqrt(t);
        r := sqr(t)/ellps.es;
      end else
      r := 1.0;
     end;
  1: begin
      if (ellps.es>0) then r := sqr(1-ellps.es*sqr(sin(lp.phi)))/ellps.one_es else r := 1.0;
		// convergence
      if fact.code and IS_ANAL_CONV=0 then
      fact.conv := - arctan2(fact.der.y_l,fact.der.x_l);
      if fact.code and IS_ANAL_XL_YL<>0 then fact.code :=fact.code or IS_ANAL_CONV;
     end;
  end; // case

  // areal scale factor
  fact.s := (fact.der.y_p * fact.der.x_l - fact.der.x_p * fact.der.y_l) *r / cosphi;
  // meridian-parallel angle theta prime
  fact.thetap := aasin(fact.s/(fact.h * fact.k));
  // Tissot ellips axis
  t:=fact.k*fact.k+fact.h*fact.h;
  fact.a:=sqrt(t+2.*fact.s);
  t:=t-2.0*fact.s;
  fact.b:=0.5*(fact.a-asqrt(t));
  fact.a:=0.5*(fact.a+asqrt(t));
  //omega
  fact.omega:=2.*aasin((fact.a-fact.b)/(fact.a+fact.b));
  result:=0;
  end;
 end;





function TProjObject.InitGot(pType: TProjType; eType: TEllpsType): integer;
//	int i;
  //	double phip;
 //	char *name, *s;
begin

 // get name of projection to be translated */
	if (!(name = pj_param(P->params, "so_proj").s)) E_ERROR(-26);
	for (i = 0; (s = pj_list[i].id) && strcmp(name, s) ; ++i) ;
	if (!s || !(P->link = ( *pj_list[i].proj)(0))) E_ERROR(-37);
	// copy existing header into new */
	P->es = 0.; // force to spherical */
	P->link->params = P->params;
	P->link->over = P->over;
	P->link->geoc = P->geoc;
	P->link->a = P->a;
	P->link->es = P->es;
	P->link->ra = P->ra;
	P->link->lam0 = P->lam0;
	P->link->phi0 = P->phi0;
	P->link->x0 = P->x0;
	P->link->y0 = P->y0;
	P->link->k0 = P->k0;
	/* force spherical earth */
	P->link->one_es = P->link->rone_es = 1.;
	P->link->es = P->link->e = 0.;
	if (!(P->link = pj_list[i].proj(P->link))) then begin
		freeup(P);
		return 0;
	end;
	if (pj_param(P->params, "to_alpha").i) then begin
		double lamc, phic, alpha;

		lamc	= pj_param(P->params, "ro_lon_c").f;
		phic	= pj_param(P->params, "ro_lat_c").f;
		alpha	= pj_param(P->params, "ro_alpha").f;
		if (fabs(fabs(phic) - HALFPI) <= TOL)
			E_ERROR(-32);
		P->lamp = lamc + aatan2(-cos(alpha), -sin(alpha) * sin(phic));
		phip = aasin(cos(phic) * sin(alpha));
	ern else  if (pj_param(P->params, "to_lat_p").i) then
        begin // specified new pole */
		P->lamp = pj_param(P->params, "ro_lon_p").f;
		phip = pj_param(P->params, "ro_lat_p").f;
	end else
        begin // specified new "equator" points */
		double lam1, lam2, phi1, phi2, con;

		lam1 = pj_param(P->params, "ro_lon_1").f;
		phi1 = pj_param(P->params, "ro_lat_1").f;
		lam2 = pj_param(P->params, "ro_lon_2").f;
		phi2 = pj_param(P->params, "ro_lat_2").f;
		if (fabs(phi1 - phi2) <= TOL ||
			(con = fabs(phi1)) <= TOL ||
			fabs(con - HALFPI) <= TOL ||
			fabs(fabs(phi2) - HALFPI) <= TOL) E_ERROR(-33);
		P->lamp = atan2(cos(phi1) * sin(phi2) * cos(lam1) -
			sin(phi1) * cos(phi2) * cos(lam2),
			sin(phi1) * cos(phi2) * sin(lam2) -
			cos(phi1) * sin(phi2) * sin(lam1));
		phip = atan(-cos(P->lamp - lam1) / tan(phi1));
	end;
	if (fabs(phip) > TOL) then
        begin // oblique */
		P->cphip = cos(phip);
		P->sphip = sin(phip);
		P->fwd = o_forward;
		P->inv = P->link->inv ? o_inverse : 0;
	end else { /* transverse */
		P->fwd = t_forward;
		P->inv = P->link->inv ? t_inverse : 0;
	end;
end;


 }

//---------------------------------------------------------------------------------//


procedure InitSwichProjection(var PJ : TCustomProj;const PjIndex:integer = -1);
var index : integer;
begin

 if (PjIndex<0) or (PjIndex>=LenGth(ProjectionsName)) then

 begin

  for index:=0 to LenGth(ProjectionsName) do

  if (index<LenGth(ProjectionsName)) and

   (UpperCase(ProjectionsName[index].Id)=PJ.pName.Id) then break;

 end else

 index:=PjIndex;


 PJ.errno:=-5*byte(index>=LenGth(ProjectionsName));

 if PJ.errno<>0 then exit;


 // "-- ???"  ==> DOES NOT WORK !!!

 with PJ.Other do

 case index of

  000: InitAEA(PJ,PJ.B1,PJ.B2);

  001: InitAEQD(PJ,Guam);

  002: InitAiry(PJ,Bo,Cutted);

  003: InitAitoff(PJ);

  004: InitSpecStereo(PJ,4);                                            // -- ???

  005: InitGlobular(PJ,0);

  006: InitAugust(PJ);

  007: InitGlobular(PJ,1);

  008: InitBipc(PJ);

  009: InitBoggs(PJ);

  010: InitBonne90(PJ,PJ.B1);

  011: InitCassini(PJ);

  012: InitCC(PJ);

  013: InitEAC(PJ,PJ.Bts);

  014: InitChamberlin(PJ,Chamb.PT[0].P,Chamb.PT[1].P,Chamb.PT[2].P);    // íå îòëàæåíà

  015: InitCollignon(PJ);

  016: InitCraster(PJ);

  017: InitDenoy(PJ);

  18..23: InitEckert(PJ,index-17);

  024: InitEDC(PJ,PJ.B1,PJ.B2);

  025: InitEQC(PJ,PJ.Bts);

  026: InitEuler(PJ,PJ.B1,PJ.B2);

  027: InitFahey(PJ);

  028: InitFoucaut(PJ);

  029: InitFoucautSin(PJ,dN);

  030: InitGall(PJ);

  031: InitGinsburg(PJ);

  032: InitGnSinu(PJ,dN,dM);

  033: InitGnomonic(PJ);

  034: InitGoode(PJ);                // + (! Uses 2 other projections !!!!)

  035: InitSpecStereo(PJ,2);

  036: InitSpecStereo(PJ,3);         // -- ???

  037: InitHammer(PJ,dW,dM);

  038: InitHatano(PJ);

  039: InitIMWPolyconic(PJ,PJ.b1,Pj.b2,Pj.l1);    // +  XY->BL they get stuck in 0 CS!!!

  040: InitKav5(PJ);

  041: InitKav7(PJ);

  042: InitLaborde(PJ,Azimuth);

  043: InitLagrange(PJ,PJ.B1,dW);

  044: InitLarrivee(PJ);

  045: InitLask(PJ);

  46,47: InitLatlong(PJ);

  048: InitLAEA(PJ);

  049: InitLCC(PJ,PJ.B1,PJ.B2);

  050: InitLEAC(PJ,PJ.B1);

  051: InitSpecStereo(PJ,1);        // -- ???

  052: InitLoximuthal(PJ,PJ.B1);

  053: InitSOLandsat(PJ,lsat,path);

  054: InitMcSin1(PJ);

  055: InitMcSin2(PJ);

  056: InitMcParabolic(PJ);

  057: InitMcQuartic(PJ);

  058: InitMcSinusoidal(PJ);

  059: InitMercator(PJ,PJ.Bts);

  060: InitSpecStereo(PJ,0);

  061: InitMillerCyl(PJ);

  062: InitMPoly(PJ);

  063: InitMoll(PJ,PJ.B1);

  64..66: InitMurdoch(PJ,Index-63,PJ.B1,PJ.B2);

  067: InitNell(PJ);

  068: InitNellHammer(PJ);

  069: InitNicol(PJ);

  070: InitPerspective(PJ,H,Gamma,Omega,false);   // wants very small values (XY up to 9000 m and BL up to 10 sec)

  071: InitNewZeland(PJ);                         // not debugged

  //072: InitGOT(PJ);                             // separately (translator of projections to UTM)

   073: case byte(IsInfinite(Alpha)) of

        1: InitOCEA(PJ,PJ.b1,Pj.b2,Pj.l1,Pj.l2);

        0: InitOCEA(PJ,Alpha,Bo);                // + they do not work with alpha

       end;

  074: InitOEA(PJ,dN,dM,theta);

  075: case byte(IsInfinite(Alpha)) of

        1: InitOMercator(PJ,PJ.b1,Pj.b2,Pj.l1,Pj.l2,Rot,Offs,RotConv);

        0: InitOMercator(PJ,Alpha,Pj.Lc,Rot,Offs,RotConv);

       end;

  076: InitGlobular(PJ,2);

  077: InitOrthographic(PJ);

  078: InitPerspConic(PJ,PJ.b1,Pj.b2);

  079: InitPolyAmerican(PJ);

  80..88: InitPutp(PJ,TPutpType(index-80));

  089: InitQuarticAuth(PJ);

  090: InitRobinson(PJ);                 // + inaccurate (error + -0.12 sec on> 178 meridian)

  091: InitRPoly(PJ,PJ.Bts);

  092: InitSinu(PJ);

  093: InitSWMercator(PJ);

  094: InitStereographic(PJ,PJ.Bts);     // + they do not work (checked by Autocad 2005)

  095: InitTransCC(PJ);

  096: InitTransCEA(PJ);

  097: InitTissot(PJ,PJ.b1,Pj.b2);

  098: InitTransMercator(PJ,PJ.Bts);

  099: InitTwoPointED(PJ,PJ.b1,Pj.b2,Pj.l1,Pj.l2);

  100: InitPerspective(PJ,H,Gamma,Omega,true); // wants very small values (XY up to 9000 m and BL up to 10 sec)

  101: InitInterStereo(PJ,PJ.Bts);

  102: InitUrm5(PJ,Alpha,dN,dQ);

  103: InitUrmfps(PJ,dN);

  104: InitUTM(PJ,Zone);

  105..108: InitVandGriten(PJ,TVandNumb(index-104));

  109: InitVitkovsky(PJ,PJ.b1,Pj.b2);

  110..116: InitWagner(PJ,TWagnerMode(index-109),PJ.Bts);

  117: InitWeren(PJ);

  118: InitWink1(PJ,PJ.Bts);

  119: InitWink2(PJ,PJ.b1);

  120: InitWinkTripel(PJ,PJ.b1);

  121: InitLCCA(PJ);

  122: InitKROVAK(PJ,PJ.Bts);

  123: InitGeocentric(PJ);

  124: InitGaussKruger(PJ);                   // + MY (coordinates according to the law of maps of the USSR)

 end;

end;


//****************************************//
//          NAD string functions          //
//****************************************//

procedure ReaplaceString(var S : string; const what,res:string);
var P,SZ : integer;
begin
 while Pos(what,S)<>0 do
 begin
  P:=Pos(what,S);
  SZ:=LenGth(what);
  S:=Copy(S,1,P-1)+res+ Copy(S,P+Sz,LenGth(S)-P-Sz+1);
 end;
end;

procedure UncodeParam(var S : string);
begin
  ReaplaceString(S,'=',':');
  ReaplaceString(S,'proj','PJ');
  ReaplaceString(S,'ellps','ES');
  ReaplaceString(S,'lat_ts','BS');
  ReaplaceString(S,'lat_','B');
  ReaplaceString(S,'latn','BS');
  ReaplaceString(S,'lon_','L');
  ReaplaceString(S,'x_','X');
  ReaplaceString(S,'y_','Y');
  ReaplaceString(S,'units','UN');
  ReaplaceString(S,'+','');
end;

function ReadNadRecord(const Index,NadPath : string):TNadRecord;
var i       : integer;

    FNAD    : TStringList;

    S,nPath : string;

begin
 result.Index:=StrToIntDef(Index,-1);
 result.FullName:='';  nPath:=Trim(NadPath);
 if nPath='' then nPath:=GetCurrentDir;
 if not FileExists(nPath+'\nad.txt') then exit;
 FNAD:= TStringList.Create;
 FNad.LoadFromFile(nPath+'\nad.txt');
 for i:=0 to fNad.Count-1 do
 begin
  S:=Trim(fNad.Strings[i]);
  if Pos(Index+';',S)=7 then break;
 end;
 FNAD.Clear;
 result.FullName:=Copy(S, Pos(';NAME=',S)+6,Pos(';VALUE=',S)-Pos(';NAME=',S)-6);
 result.Param:=Copy(S,Pos(';VALUE=',S)+7,LenGth(S)-Pos(';VALUE=',S)-6);
 FNAD.Free;
 UncodeParam(result.Param);
end;


function GetPjAngle(const S : string): double;

var ps : integer;
begin
 ps:=Pos('D',S);

 if ps<>0 then
 result:=(StrToFloatDef(Copy(S,1,ps-1),0)+StrToFloatDef(Copy(S,ps+1,LenGth(S)-ps),0)/60)*pi/180 else
 if (Pos('N',S)>0) or (Pos('E',S)>0) or (Pos('W',S)>0) or (Pos('S',S)>0) then
 result:=DMS(S) else
 result:=StrToFloatDef(S,0)*pi/180;
end;



function CreateProjObject(const Value,NadPath: string):TCustomProj;
var Str,Par : TStringList;
    S, S0   : string;
    _V      : TNadRecord;
    i,k     : integer;
    _P      : double;
begin
 if Pos('NAD:',Value)=1 then
 begin
  _V:=ReadNadRecord(Trim(Copy(Value,5,LenGth(Value)-4)),NadPath);
  if _V.Index<100 then exit;
 end else
 if Pos('proj',Trim(Value)) in [1,2] then
 begin
  _V.Index:=0;
  _V.FullName:='#string';
  _V.Param:=Trim(Value);
  UncodeParam(_V.Param);
 end else
 exit;

 ClearProjObject(result);
 result.to_meter:=1;
 result.k0:=1;

 str := TStringList.Create;
 result.NadName:=_V.FullName;
 Str.Delimiter:=' ';
 Str.DelimitedText:=Trim(_V.Param);
 result.eType:=EllNone;
 for i:=0 to str.count-1 do
 begin
  S:=UpperCase(Trim(Str.Strings[i]));
  if Pos(':',S)<1 then continue;
  S0 := Copy(S,Pos(':',S)+1,LenGth(S)-Pos(':',S));
  with result do
  case S[1] of
   'P': if S[2]='J' then pName.Id:=S0;
   'E': if S[2]='S' then
        for k:=0 to LenGth(Ellipsoids)-1 do
        if UpperCase(Ellipsoids[TEllpsType(k)].Code)=S0 then
        begin
         eType:=TEllpsType(k);
         Ellps:=Ellipsoids[eType];
         Break;
        end;

   'B': case S[2] of
         '0': C0.phi :=GetPjAngle(S0);
         '1': B1 :=GetPjAngle(S0);
         '2': B2 :=GetPjAngle(S0);
         'T': Bts:=GetPjAngle(S0);
        end;
   'L': case S[2] of
         '0': C0.lam :=GetPjAngle(S0);
         '1': l1 :=GetPjAngle(S0);
         '2': l2 :=GetPjAngle(S0);
         'C': lc :=GetPjAngle(S0);
        end;
   'X': if S[2]='0' then x0:=StrToFloatDef(S0,0);
   'Y': if S[2]='0' then y0:=StrToFloatDef(S0,0);
   'O':;
   'Z': result.Other.Zone:=StrToIntDef(S0,1);
   'T': if S[2]='O' then
        begin
          result.DP.eDest:=ellNone;
          S:=Copy(S,3,Pos(':',S)-3);
          for k:=0 to LenGth(Ellipsoids) do
          if (k<LenGth(Ellipsoids)) and  (UpperCase(Ellipsoids[TEllpsType(k)].Code)=S) then
          result.DP.eDest:=TEllpsType(k);
          with TStringList.Create do
          try
           Delimiter:=',';
           DelimitedText:=Trim(S0);
           for k:=0 to Count-1 do
           begin
            _P:=StrToFloatDef(Strings[k],1/0);
            if IsInfinite(_P) then continue;
            SetLength(DP.Value,LenGth(DP.Value)+1);
            DP.Value[High(DP.Value)]:=_P;
           end;
           if LenGth(DP.Value)>7 then Finalize(DP.Value);
          finally
           Free;
          end;
        end;
  end;
 end;
 str.Free;
 InitSwichProjection(result);
end;

// ================= Addition procedures =======================
// CK 1942 sheet cutout
function _FormatSubquad(Value : TNomenLess100; iScale:integer):string;
begin
  result:='';
  with Value do
  case iScale of
  //   50000 ( 500 m)
  4: result:=format('-%1s', [FormatFloat('0',Q50)]);
  //   25000 ( 250 m)
  5: result:=format('-%1s-%1s', [FormatFloat('0',Q25_1), FormatFloat('0', Q25_2)]);
  //   10000 ( 100 m)
  6: result:=format('-%1s-%1s-%1s', [FormatFloat('0', Q10_1),
    FormatFloat('0', Q10_2), FormatFloat('0', Q10_3)]);
  //   5000 ( 50 m)
  7: result:=format('-%3s',[FormatFloat('000', Q05+1)]);
  end;
end;


function FormatNomenclature42(NomValue : TNomenclature42):string;
var S1 : string;
const  Value = 'ABCDEFGHIJKLMNOPQRSTUVW';
begin
 result:='';
 if NomValue.iScale=255 then exit;
 with NomValue do
 begin
  // 1000000 ( 10 km)
  S1 := format('%1d.%2s-%2s', [byte(IsSouth),Value[NomValue.Row10+1],
    FormatFloat('00', Col10)]);
  case iScale of
   //  500000 ( 5 km)
   1: result:=S1+format('-%1s', [FormatFloat('0', n500)]);
   //  200000 ( 2 km)
   2: result:=S1+format('-%2s', [FormatFloat('00', n200)]);
   //  100000 ( 1 km)
   3..7: result:=S1+format('-%3s', [FormatFloat('000', n100)]);
  end;
  result:=result+_FormatSubquad(SubQuad, iScale);
 end;
end;

function ScaleToIndex(Scale:Cardinal):byte;
begin
  case round(Scale/1000) of
    1000: result:=0;
    500:  result:=1;
    200:  result:=2;
    100:  result:=3;
    50:   result:=4;
    25:   result:=5;
    10:   result:=6;
    5:    result:=7;
    else
    result:=255;
  end;
end;

function IndexToScale(Scale:byte):Cardinal;
begin
   result:=1;
   case Scale of
    0: result:=1000;
    1:  result:=500;
    2:  result:=200;
    3:  result:=100;
    4:  result:=50;
    5:  result:=25;
    6:  result:=10;
    7:  result:=5;
   else
    exit;
  end;
  result:=result*1000;
end;

procedure PointToNomenclature42(PointRad: T3dPoint; Scale : cardinal; var Value:TNomenclature42);
var    B0, L0 : extended;
       Point  : T3dPoint;
begin
  FillChar(Value, SizeOf(TNomenclature42),0);
  Point.X:= PointRad.X*180/pi;
  Point.Y:= PointRad.Y*180/pi;
  Value.iScale:= ScaleToIndex(Scale);
  if Value.iScale=255 then exit;

  if (Abs(Point.B)>88) or (Value.iScale=255) then exit;
  B0:=3600*(Point.B+88);                L0:=3600*(Point.L+180);
  Value.IsSouth:=Point.B<0;
  Value.Row10:=Trunc(Abs(Point.B)/4);   Value.Col10:=Trunc(L0/(6*3600))+1;
  B0:=B0-14400*Trunc(B0/14400);         L0:=L0-21600*Trunc(L0/21600);
  case Value.iScale of
   1: Value.n500:=TNumberQuad(byte((1-Trunc(B0/7200))*2+Trunc(L0/10800)+1));
   2: Value.n200:=TNumber200(byte((5-Trunc(B0/2400))*6+Trunc(L0/3600)+1));
   else
   Value.n100:=TNumber100(byte((11-Trunc(B0/1200))*12+Trunc(L0/1800)+1));
  end;
  B0:=B0-1200*Trunc(B0/1200);
  L0:=L0-1800*Trunc(L0/1800);
  // already everything in seconds (rounded up to 100000 (1km) square)
  case Value.iScale of
   4: Value.SubQuad.Q50:=TNumberQuad(byte((1-Trunc(B0/600))*2+Trunc(L0/900)+1));
   5: begin
       Value.SubQuad.Q25_1:=TNumberQuad(byte((1-Trunc(B0/600))*2+Trunc(L0/900)+1));
       B0:=B0-600*Trunc(B0/600); L0:=L0-900*Trunc(L0/900);
       Value.SubQuad.Q25_2:=TNumberQuad(byte((1-Trunc(B0/300))*2+Trunc(L0/450)+1));
      end;
   6: begin
       Value.SubQuad.Q10_1:=TNumberQuad(byte((1-Trunc(B0/600))*2+Trunc(L0/900)+1));
       B0:=B0-600*Trunc(B0/600); L0:=L0-900*Trunc(L0/900);
       Value.SubQuad.Q10_2:=TNumberQuad(byte((1-Trunc(B0/300))*2+Trunc(L0/450)+1));
       B0:=B0-300*Trunc(B0/300); L0:=L0-450*Trunc(L0/450);
       Value.SubQuad.Q10_3:=byte((1-Trunc(B0/150))*2+Trunc(L0/225)+1);
      end;
   7: Value.SubQuad.Q05:=(15-Trunc(B0/75))*16+Trunc(L0/112.5);
  end;
end;


function PointToNomenclature42(PointRad: T3dPoint; Scale : cardinal): string;
var N : TNomenclature42;
begin
  result:='';
  PointToNomenclature42(PointRad, Scale, N);
  result:=FormatNomenclature42(N);
  if result='' then result:='=error scale=';
end;

// RECT1KM   : base frame in nomenclature seconds 1 km
// ScaleIndex: 0 - 500m         1 - 250m        2 - 100m        5- 50m
// sQuad     : À - 500m         À-à - 250m      À-À-à - 100m    001 - 50m
//  or       : 1 - 500m         1-1 - 250m      1-1-1 - 100m    001 - 50m

procedure DecodeSmallNomenclature(var R1KM : TQLongLat; ScaleIndex : byte; const Quad : string);
var i,n    : integer;
    K      : array[0..2] of byte;
    sQuad  : string;
begin
  R1KM.Error:=true;
  if LenGth(Quad)<1 then exit;
  fillchar(K[0], 3, 0);
  n:=0; sQuad:=Trim(Quad);
  if ScaleIndex in [0..2] then
  for i:=1 to LenGth(sQuad) do
  begin
    if n>2 then break;
    if sQuad[i] in ['À'..'Ã'] then
    begin
     K[n]:=ord(sQuad[i])-ord('À');
     inc(n);
    end else
    if sQuad[i] in ['à'..'ã'] then
    begin
     K[n]:=ord(sQuad[i])-ord('à');
     inc(n);
    end else
    if sQuad[i] in ['1'..'4'] then
    begin
     K[n]:=ord(sQuad[i])-ord('1');
     inc(n);
    end;
  end;

  // À À-à   À-À-à
  if (ScaleIndex in [0..2]) then
  begin
   if Not(K[0] in [0..3]) then exit;
   R1KM.B0:=R1KM.B0+(1-(K[0] div 2))*600;
   R1KM.L0:=R1KM.L0+(K[0] mod 2)*900;
   R1KM.B1:=R1KM.B0+600;//+2*R1KM.IsSouth;
   R1KM.L1:=R1KM.L0+900;//+2*byte(R1KM.L0<0);
  end;
  //    001
  if (ScaleIndex in [1..2])then
  begin
   if Not(K[1] in [0..3]) then exit;
   R1KM.B0:=R1KM.B0+(1-(K[1] div 2))*300;
   R1KM.L0:=R1KM.L0+(K[1] mod 2)*450;
   R1KM.B1:=R1KM.B0+ 300;//+2*R1KM.IsSouth;
   R1KM.L1:=R1KM.L0+ 450;//+2*byte(R1KM.L0<0);
  end;

  case ScaleIndex of
   2: begin
       if Not(K[2] in [0..3]) then exit;
       R1KM.B0:=R1KM.B0+(1-(K[2] div 2))*150;
       R1KM.L0:=R1KM.L0+(K[2] mod 2)*225;
       R1KM.B1:=R1KM.B0+150;//+2*R1KM.IsSouth;
       R1KM.L1:=R1KM.L0+225;//+2*byte(R1KM.L0<0);
      end;
   3: begin
       n:= StrToIntDef(sQuad,-1)-1;
       if Not(n in [0..255]) then exit;
       R1KM.B0:=R1KM.B0+(15-(n div 16))*75;
       R1KM.L0:=R1KM.L0+(n mod 16)*112.5;
       R1KM.B1:=R1KM.B0+ 75;//+2*R1KM.IsSouth;
       R1KM.L1:=R1KM.L0+ 112.5;//+2*byte(R1KM.L0<0);
      end;
  end;
  R1KM.Error:=false;
end;

function NomenclatureToRect42(const Quad : string;
  const ResultType : TCoordType = ctDMS): TQLongLat;
var Row,Col : Integer;
    sQuad   : string;
    Scale   : byte;
    ps,N    : integer;
const
  cData = 'ABCDEFGHIJKLMNOPQRSTUW';

  function Sec2Dms(Sec : double): double;
  var D, M, S : smallint;
  begin
    result:=Sec;
    D:=Trunc(Abs(Sec)/3600);
    M:=Trunc((Abs(Sec)-D*3600)/60);
    result:=D*10000+M*100+Frac(Abs(Sec)/60)*60;
  end;

begin
  FillChar(result, SizeOf(TQLongLat),0);
  sQuad   := Trim(Quad);
  result.Error:=true;
  // format check 0.À-00-00...
  if (Pos('.',sQuad)=2) then
  begin
   result.IsSouth:= byte(Pos('1.',sQuad)=1);
   Delete(sQuad,1,2);
  end;
  // minimum nomenclature  À-00 4 characters and with a dash
  ps := pos('-',sQuad);
  if (LenGth(sQuad)<4) or (ps<1) then exit;
  // check, first letter or number À-00-00...
  Row:=Pos(sQuad[1], cdata)-1;
  if row<1 then // number
  begin
   Row:= StrToIntDef(Copy(sQuad,1,2),-1)-1;
   Delete(sQuad,1,3);
  end else
  Delete(sQuad,1,2);
  // select a column
  Col:= StrToIntDef(Copy(sQuad,1,2),-1)-1;
  Delete(sQuad,1,2);
  if (Col<0) or (Row<0) or (Row>22) or (Col>60) then exit;
  case result.IsSouth of
   1 : Row:=22-Row;
   0 : Row:=Row+23;
  end;
  // -1  -01 -001 -001-À -001-À-à -001-À-À-à -001-001
  case LenGth(sQuad) of
   0: Scale := 0; // 10 km
   2: Scale := 1; // 5 km
   3: Scale := 2; // 2 km
   4: Scale := 3; // 1 km
   6: Scale := 4; // 500 m
   8: Scale := 5+2*byte(sQuad[7]<>'-');   // 250 m or 50 m
  10: Scale := 6; // 100 m
   else
    exit;
  end;
  result.Scale:= IndexToScale(Scale);

  result.Error:=false;
  result.B0:=Row*14400;
  result.L0:=Col*21600-180*3600;
  result.B1:=result.B0+14400;//+2*result.IsSouth ;
  result.L1:=result.L0+21600;//+2*byte(result.L0<0);
  // 1  01 001 001-À 001-À-à 001-À-À-à 001-001
  if Scale>0 then delete(sQuad,1,1);
  case Scale of
  0:;//plug  10 km
  1: begin   // 5 km    1
      N := ord(sQuad[1])-ord('1');
      if Not(N  in [0..3]) then exit;
      result.B0:=result.B0+(1-(N  div 2))*7200;
      result.L0:=result.L0+(N  mod 2)*10800;
      result.B1:=result.B0+ 7200;//+2*result.IsSouth ;
      result.L1:=result.L0+10800;//+2*byte(result.L0<0);
     end;
  2: begin   // 2 km   01
      N:=StrToIntDef(sQuad,-1)-1;
      if Not(N in [0..35]) then exit;
      result.B0:=result.B0+(5-(N div 6))*2400;
      result.L0:=result.L0+(N mod 6)*3600;
      result.B1:=result.B0+ 2400;//+2*result.IsSouth ;
      result.L1:=result.L0+ 3600;//+2*byte(result.L0<0);
     end;
  else   // 1 km and larger  001
    N:=StrToIntDef(Copy(sQuad,1,3),-1)-1;
    if Not(N in [0..143]) then exit;
    result.B0:=result.B0+(11-(N div 12))*1200;
    result.L0:=result.L0+(N mod 12)*1800;
    result.B1:=result.B0+ 1200;//+2*result.IsSouth ;
    result.L1:=result.L0+ 1800;//+2*byte(result.L0<0);
  end;
  if Scale>3 then
  begin
   Delete(sQuad, 1, pos('-',sQuad));
   DecodeSmallNomenclature(result, Scale-4, sQuad);
   if  result.Error then exit;
  end;
 result.Error:=false;
 result.B0:=result.B0-331200;
 result.B1:=result.B1-331200;
 with result do
 case ResultType of
   ctDMS    : begin
                B0:=Sec2DMS(B0);     L0:=Sec2DMS(L0);
                B1:=Sec2DMS(B1);     L1:=Sec2DMS(L1);
              end;
   ctDegree : begin
                B0:=result.B0/3600;  L0:=result.L0/3600;
                B1:=result.B1/3600;  L1:=result.L1/3600;
              end;
   ctRadian : begin
                B0:=pi*B0/648000;    L0:=pi*L0/648000;
                B1:=pi*B1/648000;    L1:=pi*L1/648000;
              end;
 end;
end;

// ==================


initialization
 DecimalSeparator:='.';

end.





