local conf = {type="skeleton", name="shiguo_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="blood_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=133, kx=0, ky=0, cx=38.75, cy=33.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="background1", x=17, y=35.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="background", isArmature=0}} },
           {type="b", name="background2", x=17, y=22.049999999999997, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="background", isArmature=0}} },
           {type="b", name="hp_pro", x=21, y=33.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="hp_pro", isArmature=0}} },
           {type="b", name="nuqitiao", x=20, y=21.049999999999997, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="nuqitiao", isArmature=0}} },
           {type="b", name="dead", x=32.4, y=119.7, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="zhenwang", isArmature=0}} }
         }
      },
    {type="armature", name="mapcity1_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=724, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bd1_1", x=145.4, y=423.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bd1", isArmature=0}} },
           {type="b", name="bd2_1", x=331.95, y=188.1, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="bd2", isArmature=0}} },
           {type="b", name="bd3_1", x=580.15, y=468.1, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="bd3", isArmature=0}} },
           {type="b", name="bd4_1", x=800.05, y=221.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="bd4", isArmature=0}} },
           {type="b", name="bd5_1", x=1047.65, y=396.1, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="bd5", isArmature=0}} },
           {type="b", name="bd1_2", x=139.4, y=331.3, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd2_2", x=431.4, y=380.95, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd3_2", x=671.15, y=496.95, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd4_2", x=965.7, y=294.9, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd5_2", x=1155.25, y=453.1, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="baoxiangbutton", isArmature=1}} }
         }
      },
    {type="armature", name="mapcity2_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=724, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bd6_1", x=135.95, y=357.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bd6", isArmature=0}} },
           {type="b", name="bd7_1", x=463.1, y=197.54999999999995, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="bd7", isArmature=0}} },
           {type="b", name="bd8_1", x=530.45, y=459, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="bd8", isArmature=0}} },
           {type="b", name="bd9_1", x=880.55, y=208.54999999999995, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="bd9", isArmature=0}} },
           {type="b", name="bd10_1", x=1046.55, y=438.6, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="bd10", isArmature=0}} },
           {type="b", name="bd6_2", x=113.95, y=279.95, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd7_2", x=530.1, y=366.95, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd8_2", x=764.1, y=494, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd9_2", x=1036, y=358.95, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="baoxiangbutton", isArmature=1}} },
           {type="b", name="bd10_2", x=1139, y=614, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="baoxiangbutton", isArmature=1}} }
         }
      },
    {type="armature", name="baoxiangbutton", 
      bones={           
           {type="b", name="baoxiangbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="baoxiangbutton_normal", isArmature=0},{name="baoxiangbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="mapui_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="restartbg", x=839.3, y=86.20000000000005, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="restartbg", isArmature=0}} },
           {type="b", name="lefttimes_text", x=910, y=63.700000000000045, kx=0, ky=0, cx=1, cy=1, z=2, text={x=885,y=27, w=203, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="reStartbutton", x=1097.55, y=116.39999999999998, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="restartbutton", isArmature=1}} },
           {type="b", name="common_copy_ask_button", x=1121.85, y=705.55, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="public_ui", 
      bones={           
           {type="b", name="xg", x=46.05, y=273.4, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="xg", isArmature=0}} },
           {type="b", name="n9", x=-171, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="n9", isArmature=0}} },
           {type="b", name="n8", x=-126.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="n8", isArmature=0}} },
           {type="b", name="n7", x=-84.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="n7", isArmature=0}} },
           {type="b", name="n6", x=-42.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="n6", isArmature=0}} },
           {type="b", name="n5", x=-0.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="n5", isArmature=0}} },
           {type="b", name="n4", x=41.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="n4", isArmature=0}} },
           {type="b", name="n3", x=83.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="n3", isArmature=0}} },
           {type="b", name="n2", x=125.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="n2", isArmature=0}} },
           {type="b", name="n1", x=167.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="n1", isArmature=0}} },
           {type="b", name="n0", x=209.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="n0", isArmature=0}} },
           {type="b", name="hasPass", x=-62, y=197.45, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="hasPass", isArmature=0}} },
           {type="b", name="jiantou", x=281.6, y=200.55, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="jiantou", isArmature=0}} },
           {type="b", name="zhenwang", x=130.4, y=264.04999999999995, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="zhenwang", isArmature=0}} }
         }
      },
    {type="armature", name="restartbutton", 
      bones={           
           {type="b", name="resstartbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="restartbutton_normal", isArmature=0},{name="restartbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="shiguo_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1193.5, y=717, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="team_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="teamp2", x=201.1, y=350.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="teamp3", x=122.75, y=49.39999999999998, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1193.5, y=717, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button", isArmature=1}} },
           {type="b", name="common_copy_background_43", x=72.65, y=628, kx=0, ky=0, cx=26.39, cy=6.77, z=4, d={{name="commonBackgroundScalables/common_copy_background_4", isArmature=0}} },
           {type="b", name="common_copy_background_45", x=72.65, y=320, kx=0, ky=0, cx=26.39, cy=6.66, z=5, d={{name="commonBackgroundScalables/common_copy_background_4", isArmature=0}} },
           {type="b", name="common_copy_huaWen2", x=421.95, y=703.35, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="common_copy_zhanLi", x=478.35, y=690.85, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_zhanLi", isArmature=0}} },
           {type="b", name="num_text", x=122.75, y=622.85, kx=0, ky=0, cx=1, cy=1, z=8, text={x=82,y=642, w=177, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="teamKuang", x=216.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=9, d={{name="teamKuang", isArmature=0}} },
           {type="b", name="teamKuang1", x=430.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=10, d={{name="teamKuang", isArmature=0}} },
           {type="b", name="teamKuang2", x=643.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=11, d={{name="teamKuang", isArmature=0}} },
           {type="b", name="teamKuang3", x=850.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=12, d={{name="teamKuang", isArmature=0}} },
           {type="b", name="fightbutton", x=1056.5, y=540.4, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="fightbutton", isArmature=1}} },
           {type="b", name="yinxiongbg", x=48.65, y=273.9, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="yinxiongbg", isArmature=0}} },
           {type="b", name="zhanduibg", x=49.05, y=602.6, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="zhanduibg", isArmature=0}} }
         }
      },
    {type="armature", name="fightbutton", 
      bones={           
           {type="b", name="fightbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="fightbutton_normal", isArmature=0},{name="fightbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="view_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="imagep", x=657.15, y=2.4500000000000455, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="hengtiao1", x=5.7, y=293.9, kx=0, ky=0, cx=1.84, cy=1, z=2, d={{name="hengtiao", isArmature=0}} },
           {type="b", name="alphabg", x=-0.5, y=281.05, kx=0, ky=0, cx=1.34, cy=35.57, z=3, d={{name="alphabg", isArmature=0}} },
           {type="b", name="hengtiao2", x=5.7, y=42.89999999999998, kx=0, ky=0, cx=1.84, cy=1, z=4, d={{name="hengtiao", isArmature=0}} },
           {type="b", name="desr_text", x=556.9, y=142.75, kx=0, ky=0, cx=1, cy=1, z=5, text={x=330,y=7, w=719, h=148,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="namep", x=657.15, y=234.45, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="propertyp", x=463, y=190.25, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="property2p", x=700.95, y=190.25, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="level_text", x=1018, y=209.75, kx=0, ky=0, cx=1, cy=1, z=9, text={x=1045,y=205, w=214, h=76,lineType="single line",size=54,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="fightbutton", x=1087.8, y=259.55, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_fightbutton", isArmature=1}} },
           {type="b", name="xg", x=60.55, y=696.55, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="xg", isArmature=0}} },
           {type="b", name="guanumP", x=30.35, y=649.1, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="n1", x=79.9, y=696.55, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="n1", isArmature=0}} },
           {type="b", name="n0", x=110.9, y=696.55, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="n0", isArmature=0}} },
           {type="b", name="gk5x_text", x=432.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=15, text={x=332,y=200, w=135, h=39,lineType="single line",size=26,color="f9d014",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="tj5x_text", x=672.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=16, text={x=572,y=200, w=135, h=39,lineType="single line",size=26,color="f9d014",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="tj5xnum_text", x=801.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=17, text={x=701,y=200, w=135, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="desl_text", x=432.85, y=106.75, kx=0, ky=0, cx=1, cy=1, z=18, text={x=332,y=150, w=135, h=39,lineType="single line",size=26,color="f9d014",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1192.55, y=714, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonButtons/common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_fightbutton", 
      bones={           
           {type="b", name="fightbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_fightbutton_normal", isArmature=0},{name="commonButtons/common_copy_fightbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="blood_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=133, kx=0, ky=0, cx=38.75, cy=33.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background1", sc=1, dl=0, f={
                {x=17, y=35.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background2", sc=1, dl=0, f={
                {x=17, y=22.049999999999997, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hp_pro", sc=1, dl=0, f={
                {x=21, y=33.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nuqitiao", sc=1, dl=0, f={
                {x=20, y=21.049999999999997, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dead", sc=1, dl=0, f={
                {x=32.4, y=119.7, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mapcity1_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=724, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd1_1", sc=1, dl=0, f={
                {x=145.4, y=423.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd2_1", sc=1, dl=0, f={
                {x=331.95, y=188.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd3_1", sc=1, dl=0, f={
                {x=580.15, y=468.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd4_1", sc=1, dl=0, f={
                {x=800.05, y=221.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd5_1", sc=1, dl=0, f={
                {x=1047.65, y=396.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd1_2", sc=1, dl=0, f={
                {x=139.4, y=331.3, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd2_2", sc=1, dl=0, f={
                {x=431.4, y=380.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd3_2", sc=1, dl=0, f={
                {x=671.15, y=496.95, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd4_2", sc=1, dl=0, f={
                {x=965.7, y=294.9, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd5_2", sc=1, dl=0, f={
                {x=1155.25, y=453.1, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mapcity2_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=724, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd6_1", sc=1, dl=0, f={
                {x=135.95, y=357.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd7_1", sc=1, dl=0, f={
                {x=463.1, y=197.54999999999995, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd8_1", sc=1, dl=0, f={
                {x=530.45, y=459, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd9_1", sc=1, dl=0, f={
                {x=880.55, y=208.54999999999995, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd10_1", sc=1, dl=0, f={
                {x=1046.55, y=438.6, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd6_2", sc=1, dl=0, f={
                {x=113.95, y=279.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd7_2", sc=1, dl=0, f={
                {x=530.1, y=366.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd8_2", sc=1, dl=0, f={
                {x=764.1, y=494, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd9_2", sc=1, dl=0, f={
                {x=1036, y=358.95, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bd10_2", sc=1, dl=0, f={
                {x=1139, y=614, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="baoxiangbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="baoxiangbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="baoxiangbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="baoxiangbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="mapui_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="restartbg", sc=1, dl=0, f={
                {x=839.3, y=86.20000000000005, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lefttimes_text", sc=1, dl=0, f={
                {x=910, y=63.700000000000045, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reStartbutton", sc=1, dl=0, f={
                {x=1097.55, y=116.39999999999998, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1121.85, y=705.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_ask_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="public_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="xg", sc=1, dl=0, f={
                {x=46.05, y=273.4, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n9", sc=1, dl=0, f={
                {x=-171, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n8", sc=1, dl=0, f={
                {x=-126.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n7", sc=1, dl=0, f={
                {x=-84.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n6", sc=1, dl=0, f={
                {x=-42.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n5", sc=1, dl=0, f={
                {x=-0.6, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n4", sc=1, dl=0, f={
                {x=41.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n3", sc=1, dl=0, f={
                {x=83.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n2", sc=1, dl=0, f={
                {x=125.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n1", sc=1, dl=0, f={
                {x=167.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n0", sc=1, dl=0, f={
                {x=209.4, y=58.99999999999997, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hasPass", sc=1, dl=0, f={
                {x=-62, y=197.45, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiantou", sc=1, dl=0, f={
                {x=281.6, y=200.55, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenwang", sc=1, dl=0, f={
                {x=130.4, y=264.04999999999995, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="restartbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="resstartbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="resstartbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="resstartbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="shiguo_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1193.5, y=717, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="team_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamp2", sc=1, dl=0, f={
                {x=201.1, y=350.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamp3", sc=1, dl=0, f={
                {x=122.75, y=49.39999999999998, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1193.5, y=717, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_43", sc=1, dl=0, f={
                {x=72.65, y=628, kx=0, ky=0, cx=26.39, cy=6.77, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_45", sc=1, dl=0, f={
                {x=72.65, y=320, kx=0, ky=0, cx=26.39, cy=6.66, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_huaWen2", sc=1, dl=0, f={
                {x=421.95, y=703.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_zhanLi", sc=1, dl=0, f={
                {x=478.35, y=690.85, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_text", sc=1, dl=0, f={
                {x=122.75, y=622.85, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamKuang", sc=1, dl=0, f={
                {x=216.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamKuang1", sc=1, dl=0, f={
                {x=430.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamKuang2", sc=1, dl=0, f={
                {x=643.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="teamKuang3", sc=1, dl=0, f={
                {x=850.6, y=580.7, kx=0, ky=0, cx=7.14, cy=1.18, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fightbutton", sc=1, dl=0, f={
                {x=1056.5, y=540.4, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinxiongbg", sc=1, dl=0, f={
                {x=48.65, y=273.9, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanduibg", sc=1, dl=0, f={
                {x=49.05, y=602.6, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="fightbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="view_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="imagep", sc=1, dl=0, f={
                {x=657.15, y=2.4500000000000455, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hengtiao1", sc=1, dl=0, f={
                {x=5.7, y=293.9, kx=0, ky=0, cx=1.84, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="alphabg", sc=1, dl=0, f={
                {x=-0.5, y=281.05, kx=0, ky=0, cx=1.34, cy=35.57, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hengtiao2", sc=1, dl=0, f={
                {x=5.7, y=42.89999999999998, kx=0, ky=0, cx=1.84, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desr_text", sc=1, dl=0, f={
                {x=556.9, y=142.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="namep", sc=1, dl=0, f={
                {x=657.15, y=234.45, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="propertyp", sc=1, dl=0, f={
                {x=463, y=190.25, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="property2p", sc=1, dl=0, f={
                {x=700.95, y=190.25, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_text", sc=1, dl=0, f={
                {x=1018, y=209.75, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fightbutton", sc=1, dl=0, f={
                {x=1087.8, y=259.55, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xg", sc=1, dl=0, f={
                {x=60.55, y=696.55, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanumP", sc=1, dl=0, f={
                {x=30.35, y=649.1, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n1", sc=1, dl=0, f={
                {x=79.9, y=696.55, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="n0", sc=1, dl=0, f={
                {x=110.9, y=696.55, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gk5x_text", sc=1, dl=0, f={
                {x=432.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tj5x_text", sc=1, dl=0, f={
                {x=672.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tj5xnum_text", sc=1, dl=0, f={
                {x=801.85, y=142.75, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desl_text", sc=1, dl=0, f={
                {x=432.85, y=106.75, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1192.55, y=714, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_fightbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      }
  }
}
 return conf;