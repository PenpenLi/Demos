local conf = {type="skeleton", name="langyaling_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="cards_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_red_button", x=662.95, y=121.70000000000005, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_red_button", isArmature=1}} },
           {type="b", name="cost_text", x=444, y=74.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, text={x=444,y=74, w=188, h=31,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage", x=524, y=64.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="null_point", isArmature=0}} },
           {type="b", name="common_close_button", x=1196, y=720, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_close_button", isArmature=1}} },
           {type="b", name="huobiGroup", x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="huobiGroup", isArmature=1}} },
           {type="b", name="gold_ui", x=253.05, y=645, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="null_point", isArmature=0}} },
           {type="b", name="sliver_ui", x=9.05, y=645, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="null_point", isArmature=0}} }
         }
      },
    {type="armature", name="gold_tips", 
      bones={           
           {type="b", name="common_copy_background_1", x=0, y=79, kx=0, ky=0, cx=3.23, cy=1, z=0, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="wanfanDes", x=134.2, y=62.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, text={x=15,y=27, w=225, h=30,lineType="single line",size=24,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="jinbiRollGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="jinbiRollBack", x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="jinbiRollBack", isArmature=0}} },
           {type="b", name="desc_text", x=23, y=30.049999999999955, kx=0, ky=0, cx=1, cy=1, z=2, text={x=23,y=30, w=226, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="desc_text_1", x=23, y=69.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=23,y=69, w=226, h=27,lineType="single line",size=20,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text_10", x=41, y=114.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=41,y=113, w=188, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage_10", x=123, y=104.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text_1", x=45, y=372.05, kx=0, ky=0, cx=1, cy=1, z=6, text={x=45,y=372, w=188, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage_1", x=125, y=362.05, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="null_point", isArmature=0}} },
           {type="b", name="common_blue_button", x=44, y=490, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_red_button", x=43, y=225, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_red_button", isArmature=1}} },
           {type="b", name="effect2", x=215, y=236.05, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect1", x=215, y=499, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="jinbiShowGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="jinbiShowBackGroud", x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="jinbiShowBackGroud", isArmature=0}} },
           {type="b", name="desc_text", x=45, y=124.05, kx=0, ky=0, cx=1, cy=1, z=2, text={x=45,y=123, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text", x=45, y=73.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=45,y=72, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text0", x=45, y=22.049999999999955, kx=0, ky=0, cx=1, cy=1, z=4, text={x=45,y=21, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage", x=137, y=66, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="null_point", isArmature=0}} },
           {type="b", name="effect", x=248, y=570, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="langyaling_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="jinbiRollGroup", x=760, y=48, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="null_point", isArmature=0}} },
           {type="b", name="jinbiShowGroup", x=760, y=48, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="null_point", isArmature=0}} },
           {type="b", name="yinbiShowGroup", x=250, y=48, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="null_point", isArmature=0}} },
           {type="b", name="yinbiRollGroup", x=250, y=48, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="null_point", isArmature=0}} },
           {type="b", name="wanfa_ui", x=1026, y=545, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="null_point", isArmature=0}} },
           {type="b", name="gold_ui", x=253.05, y=645, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="null_point", isArmature=0}} },
           {type="b", name="sliver_ui", x=9.05, y=645, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="null_point", isArmature=0}} },
           {type="b", name="huobiGroup", x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="huobiGroup", isArmature=1}} },
           {type="b", name="common_close_button", x=1196, y=720, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_close_button", isArmature=1}} },
           {type="b", name="ask_btn", x=1124.8, y=714.5, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="huobiGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=320, cy=13.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bantou_bg1", x=49.85, y=-8.85, kx=0, ky=0, cx=5.95, cy=1, z=1, d={{name="bantou_bg", isArmature=0}} },
           {type="b", name="bantou_bg2", x=329.85, y=-8.85, kx=0, ky=0, cx=5.95, cy=1, z=2, d={{name="bantou_bg", isArmature=0}} },
           {type="b", name="bantou_bg3", x=618.85, y=-8.85, kx=0, ky=0, cx=5.41, cy=1, z=3, d={{name="bantou_bg", isArmature=0}} },
           {type="b", name="bantou_bg4", x=879.85, y=-9.85, kx=0, ky=0, cx=5.41, cy=1, z=4, d={{name="bantou_bg", isArmature=0}} },
           {type="b", name="langyalingText", x=913, y=-51, kx=0, ky=0, cx=1, cy=1, z=5, text={x=913,y=-51, w=142, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="langyalingImage", x=859.95, y=-50.95, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="null_point", isArmature=0}} },
           {type="b", name="yingxionglingText", x=649, y=-50, kx=0, ky=0, cx=1, cy=1, z=7, text={x=649,y=-50, w=142, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yingxionglingImage", x=590.95, y=-50.95, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="null_point", isArmature=0}} },
           {type="b", name="yuanbaoText", x=372, y=-46, kx=0, ky=0, cx=1, cy=1, z=9, text={x=372,y=-50, w=148, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yuanbao", x=302.8, y=-1, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="yinliangText", x=84, y=-50, kx=0, ky=0, cx=1, cy=1, z=11, text={x=84,y=-49, w=148, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yinliang", x=18, y=0, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="common_add_bg1", x=239.45, y=-4.85, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} },
           {type="b", name="common_add_bg2", x=524.45, y=-4.85, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="sliver_tips", 
      bones={           
           {type="b", name="common_copy_background_1", x=0, y=79, kx=0, ky=0, cx=3.16, cy=1, z=0, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="wanfanDes", x=134.2, y=62.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, text={x=15,y=27, w=225, h=30,lineType="single line",size=24,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="wanfa_ui", 
      bones={           
           {type="b", name="common_copy_background_1", x=0, y=310, kx=0, ky=0, cx=3.23, cy=3.92, z=0, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="wanfanDes", x=134.2, y=293.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, text={x=20,y=-98, w=216, h=388,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="yinbiRollGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="yinbiRollBackGround", x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yinbiRollBackGround", isArmature=0}} },
           {type="b", name="desc_text", x=22, y=34.25, kx=0, ky=0, cx=1, cy=1, z=2, text={x=22,y=36, w=226, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text_10", x=43, y=111.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=43,y=111, w=188, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage_10", x=118, y=95.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text_1", x=43, y=361.05, kx=0, ky=0, cx=1, cy=1, z=5, text={x=43,y=367, w=188, h=31,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage_1", x=118, y=349.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="null_point", isArmature=0}} },
           {type="b", name="common_blue_button", x=42, y=485, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_red_button", x=42, y=228, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_red_button", isArmature=1}} },
           {type="b", name="effect2", x=215, y=239.05, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect1", x=215, y=494, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_red_button_normal", isArmature=0},{name="commonButtons/common_copy_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="yinbiShowGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="yinbiShowBackGround", x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yinbiShowBackGround", isArmature=0}} },
           {type="b", name="desc_text", x=47, y=127.05, kx=0, ky=0, cx=1, cy=1, z=2, text={x=47,y=126, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text", x=47, y=76.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=47,y=75, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="cost_text0", x=47, y=25.049999999999955, kx=0, ky=0, cx=1, cy=1, z=4, text={x=47,y=24, w=188, h=38,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="null_point", isArmature=0}} },
           {type="b", name="itemImage", x=133, y=64.05000000000001, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="null_point", isArmature=0}} },
           {type="b", name="effect", x=250, y=570, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="cards_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_button", sc=1, dl=0, f={
                {x=662.95, y=121.70000000000005, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text", sc=1, dl=0, f={
                {x=444, y=74.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage", sc=1, dl=0, f={
                {x=524, y=64.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=1196, y=720, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huobiGroup", sc=1, dl=0, f={
                {x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_ui", sc=1, dl=0, f={
                {x=253.05, y=645, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sliver_ui", sc=1, dl=0, f={
                {x=9.05, y=645, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="gold_tips", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_1", sc=1, dl=0, f={
                {x=0, y=79, kx=0, ky=0, cx=3.23, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wanfanDes", sc=1, dl=0, f={
                {x=134.2, y=62.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="jinbiRollGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinbiRollBack", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_text", sc=1, dl=0, f={
                {x=23, y=30.049999999999955, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_text_1", sc=1, dl=0, f={
                {x=23, y=69.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text_10", sc=1, dl=0, f={
                {x=41, y=114.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage_10", sc=1, dl=0, f={
                {x=123, y=104.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text_1", sc=1, dl=0, f={
                {x=45, y=372.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage_1", sc=1, dl=0, f={
                {x=125, y=362.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=44, y=490, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_button", sc=1, dl=0, f={
                {x=43, y=225, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect2", sc=1, dl=0, f={
                {x=215, y=236.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect1", sc=1, dl=0, f={
                {x=215, y=499, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="jinbiShowGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinbiShowBackGroud", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_text", sc=1, dl=0, f={
                {x=45, y=124.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text", sc=1, dl=0, f={
                {x=45, y=73.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text0", sc=1, dl=0, f={
                {x=45, y=22.049999999999955, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage", sc=1, dl=0, f={
                {x=137, y=66, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=248, y=570, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="langyaling_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinbiRollGroup", sc=1, dl=0, f={
                {x=760, y=48, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinbiShowGroup", sc=1, dl=0, f={
                {x=760, y=48, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbiShowGroup", sc=1, dl=0, f={
                {x=250, y=48, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbiRollGroup", sc=1, dl=0, f={
                {x=250, y=48, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wanfa_ui", sc=1, dl=0, f={
                {x=1026, y=545, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_ui", sc=1, dl=0, f={
                {x=253.05, y=645, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sliver_ui", sc=1, dl=0, f={
                {x=9.05, y=645, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huobiGroup", sc=1, dl=0, f={
                {x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=1196, y=720, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask_btn", sc=1, dl=0, f={
                {x=1124.8, y=714.5, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huobiGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=320, cy=13.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantou_bg1", sc=1, dl=0, f={
                {x=49.85, y=-8.85, kx=0, ky=0, cx=5.95, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantou_bg2", sc=1, dl=0, f={
                {x=329.85, y=-8.85, kx=0, ky=0, cx=5.95, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantou_bg3", sc=1, dl=0, f={
                {x=618.85, y=-8.85, kx=0, ky=0, cx=5.41, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantou_bg4", sc=1, dl=0, f={
                {x=879.85, y=-9.85, kx=0, ky=0, cx=5.41, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="langyalingText", sc=1, dl=0, f={
                {x=913, y=-51, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="langyalingImage", sc=1, dl=0, f={
                {x=859.95, y=-50.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingxionglingText", sc=1, dl=0, f={
                {x=649, y=-50, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingxionglingImage", sc=1, dl=0, f={
                {x=590.95, y=-50.95, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbaoText", sc=1, dl=0, f={
                {x=372, y=-46, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao", sc=1, dl=0, f={
                {x=302.8, y=-1, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliangText", sc=1, dl=0, f={
                {x=84, y=-50, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang", sc=1, dl=0, f={
                {x=18, y=0, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_add_bg1", sc=1, dl=0, f={
                {x=239.45, y=-4.85, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_add_bg2", sc=1, dl=0, f={
                {x=524.45, y=-4.85, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_ask_button", 
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
    {type="animation", name="sliver_tips", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_1", sc=1, dl=0, f={
                {x=0, y=79, kx=0, ky=0, cx=3.16, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wanfanDes", sc=1, dl=0, f={
                {x=134.2, y=62.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="wanfa_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_1", sc=1, dl=0, f={
                {x=0, y=310, kx=0, ky=0, cx=3.23, cy=3.92, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wanfanDes", sc=1, dl=0, f={
                {x=134.2, y=293.95, kx=0, ky=0, cx=0.43, cy=0.82, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="yinbiRollGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbiRollBackGround", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_text", sc=1, dl=0, f={
                {x=22, y=34.25, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text_10", sc=1, dl=0, f={
                {x=43, y=111.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage_10", sc=1, dl=0, f={
                {x=118, y=95.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text_1", sc=1, dl=0, f={
                {x=43, y=361.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage_1", sc=1, dl=0, f={
                {x=118, y=349.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=42, y=485, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_button", sc=1, dl=0, f={
                {x=42, y=228, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect2", sc=1, dl=0, f={
                {x=215, y=239.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect1", sc=1, dl=0, f={
                {x=215, y=494, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="yinbiShowGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=68, cy=142.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbiShowBackGround", sc=1, dl=0, f={
                {x=0, y=570, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_text", sc=1, dl=0, f={
                {x=47, y=127.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text", sc=1, dl=0, f={
                {x=47, y=76.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_text0", sc=1, dl=0, f={
                {x=47, y=25.049999999999955, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemImage", sc=1, dl=0, f={
                {x=133, y=64.05000000000001, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=250, y=570, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      }
  }
}
 return conf;