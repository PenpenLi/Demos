local conf = {type="skeleton", name="banquet_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="banquet_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg_panel", x=71.8, y=677.7, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="right_background_6", x=400.3, y=643.65, kx=0, ky=0, cx=9.43, cy=7.18, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="right_image_bg", x=416.3, y=624.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="right_image_bg", isArmature=0}} },
           {type="b", name="red_juanzhou", x=107.35, y=645.2, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="red_juanzhou", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=136.35, y=554.7, kx=0, ky=0, cx=2.79, cy=5.59, z=5, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1156.8, y=708.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="common_copy_ask_button", x=1079.8, y=702.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} },
           {type="b", name="wenJiu_button", x=1036.45, y=266.65, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/heat_drink", isArmature=0}} },
           {type="b", name="mingzi_bg", x=1045.3, y=173.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_mingzi_bg", isArmature=0}} },
           {type="b", name="red_head", x=101.5, y=605, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/red_head", isArmature=0}} },
           {type="b", name="yinJiuXiaoGuo_txt", x=126, y=585, kx=0, ky=0, cx=1, cy=1, z=11, text={x=138,y=561, w=134, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="wenjiu_tili_txt", x=1079.05, y=166.10000000000002, kx=0, ky=0, cx=1, cy=1, z=12, text={x=1086,y=145, w=44, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yinJiuBiaoTi_txt", x=145, y=534, kx=0, ky=0, cx=1, cy=1, z=13, text={x=158,y=511, w=197, h=39,lineType="single line",size=26,color="fae6b4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="xiaoTieShi_txt", x=449.95, y=77.04999999999995, kx=0, ky=0, cx=1, cy=1, z=14, text={x=441,y=559, w=688, h=39,lineType="single line",size=24,color="ffb400",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_yellow_line1", x=145.5, y=509.65, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="seperate_line", isArmature=0}} },
           {type="b", name="yinJiuXiaoGuo_value_txt", x=294, y=585, kx=0, ky=0, cx=1, cy=1, z=16, text={x=304,y=561, w=55, h=39,lineType="single line",size=26,color="30ff00",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_tili_bg", x=251, y=607.5, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="wenjiu_tili_bg", x=1029.95, y=186.54999999999995, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} }
         }
      },
    {type="armature", name="headItem", 
      bones={           
           {type="b", name="hit_area", x=0, y=158, kx=0, ky=0, cx=42.5, cy=39.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="head_image", x=17.35, y=157.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="head_image", isArmature=0}} },
           {type="b", name="head_lv_bg", x=109.85, y=86.15, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="head_lv_bg", isArmature=0}} },
           {type="b", name="name_bg", x=-1.65, y=34.7, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="name_bg", isArmature=0}} },
           {type="b", name="userLv_txt", x=127, y=54, kx=0, ky=0, cx=1, cy=1, z=4, text={x=114,y=44, w=39, h=34,lineType="single line",size=22,color="ffffdb",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="userName_txt", x=13, y=12, kx=0, ky=0, cx=1, cy=1, z=5, text={x=-3,y=2, w=168, h=34,lineType="single line",size=22,color="fdf9f8",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="upgradeBtn", x=55, y=120, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="upgradeBtn", isArmature=0}} }
         }
      },
    {type="armature", name="hold_banquet_item_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=520, kx=0, ky=0, cx=80, cy=130, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="panel_juanzhou", x=0, y=520, kx=0, ky=0, cx=1.12, cy=0.89, z=1, d={{name="帮派底图", isArmature=0}} },
           {type="b", name="canyanzhe_txt", x=37.65, y=190.9, kx=0, ky=0, cx=1, cy=1, z=2, text={x=32,y=179, w=105, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="blue_button", x=67.05, y=113.2, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0}} },
           {type="b", name="yinbi_num_txt", x=40.65, y=60, kx=0, ky=0, cx=1, cy=1, z=4, text={x=163,y=60, w=80, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="juban_baoxiang_num_txt", x=247.65, y=234, kx=0, ky=0, cx=1, cy=1, z=5, text={x=249,y=219, w=48, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="juban_tili_num_txt", x=166.65, y=234, kx=0, ky=0, cx=1, cy=1, z=6, text={x=157,y=218, w=48, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="canyan_tili_num_txt", x=306.65, y=146, kx=0, ky=0, cx=1, cy=1, z=7, text={x=157,y=180, w=44, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="juban_tili_bg", x=113.5, y=262.1, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="yinbi_image", x=96.05, y=105.14999999999998, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="canjia_tili_bg", x=113.7, y=224.8, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="yuanbao_bg", x=95.35, y=105.2, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="jubanzhe_txt", x=33.65, y=232, kx=0, ky=0, cx=1, cy=1, z=12, text={x=32,y=219, w=104, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="dengji_txt", x=33.65, y=142, kx=0, ky=0, cx=1, cy=1, z=13, text={x=68,y=57, w=185, h=44,lineType="single line",size=30,color="ffea70",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="mingzi_bg", x=192.35, y=314.65, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_mingzi_bg", isArmature=0}} },
           {type="b", name="jiuyan_leixing_txt", x=39.65, y=143, kx=0, ky=0, cx=1, cy=1, z=15, text={x=196,y=287, w=106, h=39,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="hold_banquet_panel_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=725, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="panel_bg", x=76.8, y=674.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="shadow_bg", x=111.35, y=638.65, kx=0, ky=0, cx=12.96, cy=7.18, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="tieshi_word_txt", x=492.95, y=78.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, text={x=290,y=53, w=719, h=39,lineType="single line",size=24,color="ffc600",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1150, y=704, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="shengyu_value_txt", x=492.95, y=110.04999999999995, kx=0, ky=0, cx=1, cy=1, z=5, text={x=1014,y=53, w=131, h=39,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ask_button", x=1077.85, y=701, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="banquet_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_panel", sc=1, dl=0, f={
                {x=71.8, y=677.7, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_background_6", sc=1, dl=0, f={
                {x=400.3, y=643.65, kx=0, ky=0, cx=9.43, cy=7.18, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_image_bg", sc=1, dl=0, f={
                {x=416.3, y=624.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_juanzhou", sc=1, dl=0, f={
                {x=107.35, y=645.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=136.35, y=554.7, kx=0, ky=0, cx=2.79, cy=5.59, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1156.8, y=708.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1079.8, y=702.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wenJiu_button", sc=1, dl=0, f={
                {x=1036.45, y=266.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mingzi_bg", sc=1, dl=0, f={
                {x=1045.3, y=173.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_head", sc=1, dl=0, f={
                {x=101.5, y=605, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinJiuXiaoGuo_txt", sc=1, dl=0, f={
                {x=126, y=585, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wenjiu_tili_txt", sc=1, dl=0, f={
                {x=1079.05, y=166.10000000000002, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinJiuBiaoTi_txt", sc=1, dl=0, f={
                {x=145, y=534, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xiaoTieShi_txt", sc=1, dl=0, f={
                {x=449.95, y=77.04999999999995, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_yellow_line1", sc=1, dl=0, f={
                {x=145.5, y=509.65, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinJiuXiaoGuo_value_txt", sc=1, dl=0, f={
                {x=294, y=585, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_tili_bg", sc=1, dl=0, f={
                {x=251, y=607.5, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wenjiu_tili_bg", sc=1, dl=0, f={
                {x=1029.95, y=186.54999999999995, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="headItem", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=158, kx=0, ky=0, cx=42.5, cy=39.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="head_image", sc=1, dl=0, f={
                {x=17.35, y=157.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="head_lv_bg", sc=1, dl=0, f={
                {x=109.85, y=86.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=-1.65, y=34.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="userLv_txt", sc=1, dl=0, f={
                {x=127, y=54, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="userName_txt", sc=1, dl=0, f={
                {x=13, y=12, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="upgradeBtn", sc=1, dl=0, f={
                {x=55, y=120, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hold_banquet_item_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=520, kx=0, ky=0, cx=80, cy=130, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel_juanzhou", sc=1, dl=0, f={
                {x=0, y=520, kx=0, ky=0, cx=1.12, cy=0.89, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="canyanzhe_txt", sc=1, dl=0, f={
                {x=37.65, y=190.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_button", sc=1, dl=0, f={
                {x=67.05, y=113.2, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbi_num_txt", sc=1, dl=0, f={
                {x=40.65, y=60, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="juban_baoxiang_num_txt", sc=1, dl=0, f={
                {x=247.65, y=234, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="juban_tili_num_txt", sc=1, dl=0, f={
                {x=166.65, y=234, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="canyan_tili_num_txt", sc=1, dl=0, f={
                {x=306.65, y=146, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="juban_tili_bg", sc=1, dl=0, f={
                {x=113.5, y=262.1, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbi_image", sc=1, dl=0, f={
                {x=96.05, y=105.14999999999998, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="canjia_tili_bg", sc=1, dl=0, f={
                {x=113.7, y=224.8, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao_bg", sc=1, dl=0, f={
                {x=95.35, y=105.2, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jubanzhe_txt", sc=1, dl=0, f={
                {x=33.65, y=232, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dengji_txt", sc=1, dl=0, f={
                {x=33.65, y=142, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mingzi_bg", sc=1, dl=0, f={
                {x=192.35, y=314.65, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiuyan_leixing_txt", sc=1, dl=0, f={
                {x=39.65, y=143, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hold_banquet_panel_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=725, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel_bg", sc=1, dl=0, f={
                {x=76.8, y=674.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shadow_bg", sc=1, dl=0, f={
                {x=111.35, y=638.65, kx=0, ky=0, cx=12.96, cy=7.18, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tieshi_word_txt", sc=1, dl=0, f={
                {x=492.95, y=78.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1150, y=704, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengyu_value_txt", sc=1, dl=0, f={
                {x=492.95, y=110.04999999999995, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask_button", sc=1, dl=0, f={
                {x=1077.85, y=701, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      }
  }
}
 return conf;