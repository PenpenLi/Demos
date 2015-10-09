local conf = {type="skeleton", name="friendFight_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="friendDownItem_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=135, kx=0, ky=0, cx=84.5, cy=33, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="itemBg", x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="itemBg", isArmature=0}} },
           {type="b", name="name1_bg", x=76.9, y=124, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="name1_bg", isArmature=0}} },
           {type="b", name="maoxianze1", x=30.4, y=37.099999999999994, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="maoxianze1", isArmature=0}} },
           {type="b", name="common_lvImg", x=9.45, y=118.95, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_lvImg", isArmature=0}} },
           {type="b", name="level_num_text", x=160.05, y=105.95, kx=0, ky=0, cx=1, cy=1, z=5, text={x=44,y=91, w=52, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_num_text", x=247.05, y=99.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=124,y=81, w=211, h=41,lineType="single line",size=28,color="000000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhanli_num_text", x=243.05, y=54.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=116,y=40, w=218, h=36,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="youqing_num_text", x=243.05, y=23.950000000000003, kx=0, ky=0, cx=1, cy=1, z=8, text={x=116,y=9, w=218, h=36,lineType="single line",size=24,color="ff0000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="friendFight_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_right", x=892.7, y=655.8, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_mozhiFrame_h_right", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid", x=352.6, y=654.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid1", x=552.65, y=654.8, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid2", x=752.7, y=654.8, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_left", x=219.6, y=654.8, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_mozhiFrame_h_left", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_rightf", x=876.7, y=110.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_mozhiFrame_h_right", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_midf", x=336.6, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid1f", x=536.65, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid2f", x=736.7, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_leftf", x=203.6, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_mozhiFrame_h_left", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_down", x=1010.7, y=183, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_mozhiFrame_v_down", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid", x=1010.7, y=303, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid1", x=1010.7, y=303, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid2", x=1010.7, y=423, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid3", x=1010.7, y=543.05, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_top", x=1010.7, y=637.05, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_copy_mozhiFrame_v_top", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_downf", x=241.5, y=194.95000000000005, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_copy_mozhiFrame_v_down", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_midf", x=241.5, y=314.95, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid1f", x=241.5, y=314.95, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid2f", x=241.5, y=434.95, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid3f", x=241.5, y=555, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_topf", x=241.5, y=649, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonImages/common_copy_mozhiFrame_v_top", isArmature=0}} },
           {type="b", name="common_background_5", x=268.65, y=631.5, kx=0, ky=0, cx=3.42, cy=2.43, z=23, d={{name="commonBackgroundScalables/common_copy_background_5", isArmature=0}} },
           {type="b", name="common_image_separator", x=306.9, y=425.95, kx=0, ky=0, cx=1.95, cy=1, z=24, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=977.9, y=649, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonButtons/common_copy_close_button", isArmature=1}} },
           {type="b", name="youqing_num_text", x=516.15, y=138.79999999999995, kx=0, ky=0, cx=1, cy=1, z=26, text={x=383,y=103, w=546, h=36,lineType="single line",size=24,color="714f20",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_huaWen2", x=435.8, y=670.65, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="titleP", x=552.65, y=618.8, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="nullSprite", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="friendUpItem_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=135, kx=0, ky=0, cx=84.5, cy=33, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="itemBg", x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="itemBg", isArmature=0}} },
           {type="b", name="name_bg", x=70.9, y=124.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="name_bg", isArmature=0}} },
           {type="b", name="maoxianze", x=32.05, y=36.099999999999994, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="maoxianze", isArmature=0}} },
           {type="b", name="common_lvImg", x=9.45, y=118.95, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_lvImg", isArmature=0}} },
           {type="b", name="level_num_text", x=160.05, y=105.95, kx=0, ky=0, cx=1, cy=1, z=5, text={x=44,y=92, w=52, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_num_text", x=247.05, y=99.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=124,y=81, w=211, h=41,lineType="single line",size=28,color="000000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhanli_num_text", x=243.05, y=54.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=116,y=40, w=218, h=36,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="youqing_num_text", x=243.05, y=23.950000000000003, kx=0, ky=0, cx=1, cy=1, z=8, text={x=116,y=9, w=218, h=36,lineType="single line",size=24,color="ff0000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="friendDownItem_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=84.5, cy=33, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemBg", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name1_bg", sc=1, dl=0, f={
                {x=76.9, y=124, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="maoxianze1", sc=1, dl=0, f={
                {x=30.4, y=37.099999999999994, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_lvImg", sc=1, dl=0, f={
                {x=9.45, y=118.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_num_text", sc=1, dl=0, f={
                {x=160.05, y=105.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_num_text", sc=1, dl=0, f={
                {x=247.05, y=99.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_num_text", sc=1, dl=0, f={
                {x=243.05, y=54.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youqing_num_text", sc=1, dl=0, f={
                {x=243.05, y=23.950000000000003, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="friendFight_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_right", sc=1, dl=0, f={
                {x=892.7, y=655.8, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid", sc=1, dl=0, f={
                {x=352.6, y=654.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid1", sc=1, dl=0, f={
                {x=552.65, y=654.8, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid2", sc=1, dl=0, f={
                {x=752.7, y=654.8, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_left", sc=1, dl=0, f={
                {x=219.6, y=654.8, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_rightf", sc=1, dl=0, f={
                {x=876.7, y=110.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_midf", sc=1, dl=0, f={
                {x=336.6, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid1f", sc=1, dl=0, f={
                {x=536.65, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid2f", sc=1, dl=0, f={
                {x=736.7, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_leftf", sc=1, dl=0, f={
                {x=203.6, y=109.70000000000005, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_down", sc=1, dl=0, f={
                {x=1010.7, y=183, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid", sc=1, dl=0, f={
                {x=1010.7, y=303, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid1", sc=1, dl=0, f={
                {x=1010.7, y=303, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid2", sc=1, dl=0, f={
                {x=1010.7, y=423, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid3", sc=1, dl=0, f={
                {x=1010.7, y=543.05, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_top", sc=1, dl=0, f={
                {x=1010.7, y=637.05, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_downf", sc=1, dl=0, f={
                {x=241.5, y=194.95000000000005, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_midf", sc=1, dl=0, f={
                {x=241.5, y=314.95, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid1f", sc=1, dl=0, f={
                {x=241.5, y=314.95, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid2f", sc=1, dl=0, f={
                {x=241.5, y=434.95, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid3f", sc=1, dl=0, f={
                {x=241.5, y=555, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_topf", sc=1, dl=0, f={
                {x=241.5, y=649, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_5", sc=1, dl=0, f={
                {x=268.65, y=631.5, kx=0, ky=0, cx=3.42, cy=2.43, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator", sc=1, dl=0, f={
                {x=306.9, y=425.95, kx=0, ky=0, cx=1.95, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=977.9, y=649, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youqing_num_text", sc=1, dl=0, f={
                {x=516.15, y=138.79999999999995, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huaWen2", sc=1, dl=0, f={
                {x=435.8, y=670.65, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleP", sc=1, dl=0, f={
                {x=552.65, y=618.8, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
      },
    {type="animation", name="friendUpItem_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=84.5, cy=33, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemBg", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=70.9, y=124.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="maoxianze", sc=1, dl=0, f={
                {x=32.05, y=36.099999999999994, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_lvImg", sc=1, dl=0, f={
                {x=9.45, y=118.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_num_text", sc=1, dl=0, f={
                {x=160.05, y=105.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_num_text", sc=1, dl=0, f={
                {x=247.05, y=99.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_num_text", sc=1, dl=0, f={
                {x=243.05, y=54.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youqing_num_text", sc=1, dl=0, f={
                {x=243.05, y=23.950000000000003, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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