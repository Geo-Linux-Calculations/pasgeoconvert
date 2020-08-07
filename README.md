# PasGeoConvert.

28 Feb 2015  
https://gis-lab.info/forum/viewtopic.php?f=34&t=18604&start=15  
(c) Franklin1967 (https://gis-lab.info/forum/memberlist.php?mode=viewprofile&u=10600)

### Description

Convert geodetic coordinates to planar rectangular
* `MathExt.pas` is my math library. Inside there are types and basic geometric functions on which the converter to SK63 and geodesy converters are based.
* `uCk63.pas` is the source code of the CK63 converter along with the algorithm for determining the layout of all regions (along the way, you will figure out what's what, the example compiles and works)
* `uGisCalc.pas` is a geodetic library itself. In it, I collected everything from everywhere (except for SK63 - it is separately, in the module above in the text).

-----

In fact, I translated the source code of the PRJ4.0 project written in C into Pascal.
