package starling.text
{
   import starling.textures.Texture;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   
   class MiniBitmapFont
   {
      
      private static const BITMAP_WIDTH:int = 128;
      
      private static const BITMAP_HEIGHT:int = 64;
      
      private static const BITMAP_DATA:Array = [2027613533,3.413039936E9,202148514,2.266925598E9,4.206886452E9,4.286853117E9,2034947,3.202703399E9,352977282,2.957757964E9,3.11365288E9,2.158068882E9,1468709156,2.268063717E9,2.779310143E9,2101025806,3.416509055E9,4.215794539E9,3.602168838E9,1038056207,1932393374,3.182285627E9,3.086802234E9,1741291262,2017257123,3.395280843E9,984074419,3.049693147E9,3.986077023E9,1055013549,1806563255,1754714962,1577746187,1124058786,3.888759258E9,2.482229043E9,2.916583666E9,3.743065328E9,866060213,1695195001,2.401582068E9,3.113347901E9,2.616521596E9,1053798161,2093370968,4.229025683E9,560451479,854767518,2.610241322E9,4.279041348E9,4.18157248E9,4.031244973E9,587139110,1081376765,962217926,783603325,3.605526425E9,4.102001916E9,289204733,2.635140255E9,3.453981695E9,3.487854373E9,2132197241,3.164775074E9,4.257640328E9,770238970,144664537,707141570,2.934433071E9,871272893,512964596,808491899,481894297,3.095982481E9,3.598364156E9,1710636358,2.904016319E9,1751040139,596966466,1363963692,465815609,315567311,4.290666159E9,4.086022551E9,179721458,2.22173497E9,3.942224988E9,1519355876,3.292323782E9,3.93342723E9,3.314199893E9,3.736227348E9,3.846038425E9,603088884,2.677349227E9,3.207069327E9,3.555275967E9,3.063054283E9,3.064577213E9,3.412044179E9,693642210,4.280513949E9,762928717,1802215333,3.774849674E9,4.22115533E9,970959395,557220237,2107226136,3.509822982E9,3.403284788E9,4.265820019E9,898597576,991077243,2091615904,3.334716888E9,633599866,4.218780109E9,2.216000376E9,834870947,2118009742,1362731961,236280636,1274945142,1458729366,797960805,3.28936972E9,2103717340,3.946406003E9,2.676522889E9,1624104606,1156993903,3.186170404E9,2.254499071E9,1204911924,1314218830,3.307086392E9,2.824275959E9,3.839865679E9,2073394964,1873329433,1754205930,1528429545,1631106062,2.263272465E9,4.220497047E9,3.522893765E9,3.641376303E9,707451487,3.452496787E9,1390653868,2.620555793E9,1027328684,3.419683476E9,3.662193703E9,765701986,3.808279132E9,786403271,3.824435837E9,713234896,4.261856399E9,3.471930731E9,3.993492879E9,1447960461,1398434593,1914230187,2.398643285E9,4.156374464E9,3.859339207E9,3.220700061E9,3.373248762E9,3.186030434E9,1315917060,2.809852481E9,4.008553903E9,4.105611953E9,1599499652,3.513857591E9,877854499,4.198259455E9,3.648560077E9,2.838035419E9,3.25559419E9,2.465578457E9,4.263505201E9,534904657,2.889261598E9,1358214576,1069250354,3.870010557E9,2.628896583E9,3.448610878E9,442343309,1024736866,4.015119133E9,3.250867279E9,1513359261,2.442089596E9,1944476762,735490552,426990058,4.234106111E9,1204305707,3.330995265E9,2.398649368E9,4.221048123E9,1724669255,3.801115709E9,3.48932879E9,3.896402933E9,3.696936939E9,2.836983295E9,3.656750393E9,3.349724512E9,3.810416287E9,3.654997608E9,4.284455103E9,2.294939563E9,4.207697932E9,642748805,2.476981639E9,2.319419898E9,572956615,3.83323894E9,964924880,2081600351,3.572458416E9,2056247513,1951368808,2133449703,2.783728628E9,512866577,913279200,1678129016,3.488578991E9,3.373952929E9,2.562996951E9,3.666058925E9,1664169178,1943591935,750675303,154399903,2.57159089E9,852654952,4.117307766E9,1971649621,4.18019582E9,1222535348,4.283953215E9,2.880662236E9,2.71741098E9,1175907705,1157322027,505963121,2.631540616E9,3.661227656E9,3.591803353E9,2.624126821E9,1948662907,3.596065103E9,1147387734,256773959,1173572460,2.361957471E9,4.210876076E9,3.08018062E9,3.46480121E9,3.821654259E9,1465302035,2.851185457E9,3.143266144E9,3.793180414E9,3.368833103E9,4.274670712E9,3.473819108E9,3.487569332E9,773123355,1618635668,2.57017619E9,2075248691,1740805534,288646743,1837597401,603556968,3.182536872E9,673184603,3.088757053E9,2.897054404E9,3.192651316E9,2.885335802E9,1057233368,1118437241,4.182126463E9,3.110464775E9,3.313191614E9,2.360987274E9,735505357,2.992631425E9,2.360928811E9,4.187834527E9,279183208,1586420003,1174008423,4.062987589E9,1162167621,1162167621,1162167621,1162167621,1174119799,787274608];
      
      private static const XML_DATA:XML = <font>
          <info face="mini" size="8" bold="0" italic="0" smooth="0"/>
          <common lineHeight="8" base="7" scaleW="128" scaleH="64" pages="1" packed="0"/>
          <chars count="191">
            <char id="195" x="1" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
            <char id="209" x="7" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
            <char id="213" x="13" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
            <char id="253" x="19" y="1" width="4" height="9" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="255" x="24" y="1" width="4" height="9" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="192" x="29" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="193" x="35" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="194" x="41" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="197" x="47" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="200" x="53" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="201" x="59" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="202" x="65" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="210" x="71" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="211" x="77" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="212" x="83" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="217" x="89" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="218" x="95" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="219" x="101" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="221" x="107" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
            <char id="206" x="113" y="1" width="3" height="8" xoffset="-1" yoffset="-1" xadvance="2"/>
            <char id="204" x="117" y="1" width="2" height="8" xoffset="-1" yoffset="-1" xadvance="2"/>
            <char id="205" x="120" y="1" width="2" height="8" xoffset="0" yoffset="-1" xadvance="2"/>
            <char id="36"  x="1" y="11" width="5" height="7" xoffset="0" yoffset="1" xadvance="6"/>
            <char id="196" x="7" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
            <char id="199" x="13" y="11" width="5" height="7" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="203" x="19" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
            <char id="214" x="25" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
            <char id="220" x="31" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
            <char id="224" x="37" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="225" x="42" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="226" x="47" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="227" x="52" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="232" x="57" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="233" x="62" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="234" x="67" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="235" x="72" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="241" x="77" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="242" x="82" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="243" x="87" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="244" x="92" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="245" x="97" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="249" x="102" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="250" x="107" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="251" x="112" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
            <char id="254" x="117" y="11" width="4" height="7" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="123" x="122" y="11" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
            <char id="125" x="1" y="19" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
            <char id="167" x="5" y="19" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
            <char id="207" x="9" y="19" width="3" height="7" xoffset="-1" yoffset="0" xadvance="2"/>
            <char id="106" x="13" y="19" width="2" height="7" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="40" x="16" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
            <char id="41" x="19" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
            <char id="91" x="22" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
            <char id="93" x="25" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
            <char id="124" x="28" y="19" width="1" height="7" xoffset="1" yoffset="1" xadvance="4"/>
            <char id="81" x="30" y="19" width="5" height="6" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="163" x="36" y="19" width="5" height="6" xoffset="0" yoffset="1" xadvance="6"/>
            <char id="177" x="42" y="19" width="5" height="6" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="181" x="48" y="19" width="5" height="6" xoffset="0" yoffset="3" xadvance="6"/>
            <char id="103" x="54" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="112" x="59" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="113" x="64" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="121" x="69" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="162" x="74" y="19" width="4" height="6" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="228" x="79" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
            <char id="229" x="84" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
            <char id="231" x="89" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="240" x="94" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
            <char id="246" x="99" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
            <char id="252" x="104" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
            <char id="238" x="109" y="19" width="3" height="6" xoffset="-1" yoffset="1" xadvance="2"/>
            <char id="59" x="113" y="19" width="2" height="6" xoffset="0" yoffset="3" xadvance="4"/>
            <char id="236" x="116" y="19" width="2" height="6" xoffset="-1" yoffset="1" xadvance="2"/>
            <char id="237" x="119" y="19" width="2" height="6" xoffset="0" yoffset="1" xadvance="2"/>
            <char id="198" x="1" y="27" width="9" height="5" xoffset="0" yoffset="2" xadvance="10"/>
            <char id="190" x="11" y="27" width="8" height="5" xoffset="0" yoffset="2" xadvance="9"/>
            <char id="87" x="20" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
            <char id="188" x="28" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
            <char id="189" x="36" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
            <char id="38" x="44" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
            <char id="164" x="51" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
            <char id="208" x="58" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
            <char id="8364" x="65" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
            <char id="65" x="72" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="66" x="78" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="67" x="84" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="68" x="90" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="69" x="96" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="70" x="102" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="71" x="108" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="72" x="114" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="75" x="120" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="77" x="1" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="78" x="7" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="79" x="13" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="80" x="19" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="82" x="25" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="83" x="31" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="84" x="37" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="85" x="43" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="86" x="49" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="88" x="55" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="89" x="61" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="90" x="67" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="50" x="73" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="51" x="79" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="52" x="85" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="53" x="91" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="54" x="97" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="56" x="103" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="57" x="109" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="48" x="115" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="47" x="121" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="64" x="1" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="92" x="7" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="37" x="13" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="43" x="19" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="35" x="25" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="42" x="31" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="165" x="37" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="169" x="43" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="174" x="49" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="182" x="55" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="216" x="61" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="247" x="67" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
            <char id="74" x="73" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="76" x="78" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="98" x="83" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="100" x="88" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="104" x="93" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="107" x="98" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="55" x="103" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="63" x="108" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="191" x="113" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="222" x="118" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="223" x="123" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
            <char id="116" x="1" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="60" x="5" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="62" x="9" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="170" x="13" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="186" x="17" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="239" x="21" y="45" width="3" height="5" xoffset="-1" yoffset="2" xadvance="2"/>
            <char id="102" x="25" y="45" width="2" height="5" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="49" x="28" y="45" width="2" height="5" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="73" x="31" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="105" x="33" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="108" x="35" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="33" x="37" y="45" width="1" height="5" xoffset="1" yoffset="2" xadvance="3"/>
            <char id="161" x="39" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="166" x="41" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="109" x="43" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
            <char id="119" x="51" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
            <char id="230" x="59" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
            <char id="97" x="67" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="99" x="72" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="101" x="77" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="110" x="82" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="111" x="87" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="115" x="92" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="117" x="97" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="118" x="102" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="120" x="107" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="122" x="112" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="215" x="117" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="248" x="122" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="114" x="1" y="51" width="3" height="4" xoffset="0" yoffset="3" xadvance="4"/>
            <char id="178" x="5" y="51" width="3" height="4" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="179" x="9" y="51" width="3" height="4" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="185" x="13" y="51" width="1" height="4" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="61" x="15" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
            <char id="171" x="21" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
            <char id="172" x="27" y="51" width="5" height="3" xoffset="0" yoffset="4" xadvance="6"/>
            <char id="187" x="33" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
            <char id="176" x="39" y="51" width="3" height="3" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="44" x="43" y="51" width="2" height="3" xoffset="0" yoffset="6" xadvance="3"/>
            <char id="58" x="46" y="51" width="1" height="3" xoffset="1" yoffset="3" xadvance="4"/>
            <char id="94" x="48" y="51" width="4" height="2" xoffset="-1" yoffset="2" xadvance="4"/>
            <char id="126" x="53" y="51" width="4" height="2" xoffset="0" yoffset="3" xadvance="5"/>
            <char id="34" x="58" y="51" width="3" height="2" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="96" x="62" y="51" width="2" height="2" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="180" x="65" y="51" width="2" height="2" xoffset="0" yoffset="2" xadvance="3"/>
            <char id="184" x="68" y="51" width="2" height="2" xoffset="0" yoffset="7" xadvance="3"/>
            <char id="39" x="71" y="51" width="1" height="2" xoffset="0" yoffset="2" xadvance="2"/>
            <char id="95" x="73" y="51" width="5" height="1" xoffset="0" yoffset="7" xadvance="6"/>
            <char id="45" x="79" y="51" width="4" height="1" xoffset="0" yoffset="4" xadvance="5"/>
            <char id="173" x="84" y="51" width="4" height="1" xoffset="0" yoffset="4" xadvance="5"/>
            <char id="168" x="89" y="51" width="3" height="1" xoffset="1" yoffset="2" xadvance="5"/>
            <char id="175" x="93" y="51" width="3" height="1" xoffset="0" yoffset="2" xadvance="4"/>
            <char id="46" x="97" y="51" width="1" height="1" xoffset="0" yoffset="6" xadvance="2"/>
            <char id="183" x="99" y="51" width="1" height="1" xoffset="0" yoffset="4" xadvance="2"/>
            <char id="32" x="6" y="56" width="0" height="0" xoffset="0" yoffset="127" xadvance="3"/>
          </chars>
        </font>;
       
      function MiniBitmapFont()
      {
         super();
      }
      
      public static function get texture() : Texture
      {
         var _loc4_:* = 0;
         var _loc1_:BitmapData = new BitmapData(128,64);
         var _loc3_:ByteArray = new ByteArray();
         var _loc2_:int = BITMAP_DATA.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.writeUnsignedInt(BITMAP_DATA[_loc4_]);
            _loc4_++;
         }
         _loc3_.uncompress();
         _loc1_.setPixels(new Rectangle(0,0,128,64),_loc3_);
         return Texture.fromBitmapData(_loc1_,false);
      }
      
      public static function get xml() : XML
      {
         return XML_DATA;
      }
   }
}
