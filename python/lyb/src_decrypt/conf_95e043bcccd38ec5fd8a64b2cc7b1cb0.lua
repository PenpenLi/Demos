local conf = {type="skeleton", name="task_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_small_orange_button", 
      bones={           
           {type="b", name="common_small_orange_button", x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, text={x=26,y=4, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_orange_button_normal", isArmature=0},{name="commonButtons/common_copy_small_orange_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="task_ui", 
      bones={           
           {type="b", name="hit_area", x=197, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="ink_1", x=570.15, y=669.85, kx=0, ky=0, cx=0.55, cy=1, z=1, d={{name="ink_r", isArmature=1}} },
           {type="b", name="ink_2", x=1164.7, y=649.3, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="ink_c", isArmature=1}} },
           {type="b", name="ink_3", x=592.5, y=46.450000000000045, kx=0, ky=0, cx=0.56, cy=1, z=3, d={{name="ink_r", isArmature=1}} },
           {type="b", name="ink_4", x=596.95, y=647.85, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="ink_c", isArmature=1}} },
           {type="b", name="renwu_bg", x=594.95, y=682.6, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonPanels/common_copy_panel_2", isArmature=0}} },
           {type="b", name="bg", x=625.4, y=648.9, kx=0, ky=0, cx=6.46, cy=7.29, z=6, d={{name="bg", isArmature=0}} },
           {type="b", name="notaskui", x=653, y=625, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="noTaskUI", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1143.4, y=697.2, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="channel_1", x=1163, y=590.05, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="channel_2", x=1163, y=454.05, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="render2", x=633.9, y=469.85, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} },
           {type="b", name="render1", x=633.9, y=642.85, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} },
           {type="b", name="xiaohongdian", x=1230.45, y=450.05, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="ink_r", 
      bones={           
           {type="b", name="ink_r_rig", x=517.05, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_copy_mozhiFrame_h_right", isArmature=0}} },
           {type="b", name="ink_r_mid", x=132.9, y=0, kx=0, ky=0, cx=1.92, cy=1, z=1, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="ink_r_lef", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_mozhiFrame_h_left", isArmature=0}} }
         }
      },
    {type="armature", name="ink_c", 
      bones={           
           {type="b", name="ink_c_down", x=0, y=-480.7, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_copy_mozhiFrame_v_down", isArmature=0}} },
           {type="b", name="ink_c_mid", x=0, y=-94, kx=0, ky=0, cx=1, cy=3.25, z=1, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="ink_c_up", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_mozhiFrame_v_top", isArmature=0}} }
         }
      },
    {type="armature", name="noTaskUI", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=118.75, cy=137.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg1", x=0, y=0, kx=0, ky=0, cx=6.01, cy=6.96, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="bg2", x=5, y=-5, kx=0, ky=0, cx=10.33, cy=1.04, z=2, d={{name="commonGrids/common_copy_grid_7", isArmature=0}} },
           {type="b", name="meiyourenwu", x=28, y=-175, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="wenzhibeijing", isArmature=0}} },
           {type="b", name="meiyourenwu2", x=28, y=-381, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="wenzhibeijing", isArmature=0}} },
           {type="b", name="label1", x=140, y=-110, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_currency_moji", isArmature=0}} },
           {type="b", name="label2", x=140, y=-320, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_currency_moji", isArmature=0}} },
           {type="b", name="image1", x=124.5, y=-380.3, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonCurrencyImages/common_copy_exp_bg", isArmature=0}} },
           {type="b", name="text1", x=35, y=-49, kx=0, ky=0, cx=1, cy=1, z=8, text={x=37,y=-49, w=409, h=40,lineType="multiline",size=30,color="ab9986",alignment="center",space=0,textType="input"}, d={{name="nillpoint", isArmature=0}} },
           {type="b", name="text2", x=136, y=-154, kx=0, ky=0, cx=1, cy=1, z=9, text={x=135,y=-154, w=202, h=39,lineType="multiline",size=30,color="ab9986",alignment="center",space=0,textType="input"}, d={{name="nillpoint", isArmature=0}} },
           {type="b", name="text3", x=136, y=-364, kx=0, ky=0, cx=1, cy=1, z=10, text={x=135,y=-364, w=202, h=39,lineType="multiline",size=30,color="ab9986",alignment="center",space=0,textType="input"}, d={{name="nillpoint", isArmature=0}} },
           {type="b", name="text4", x=136, y=-220, kx=0, ky=0, cx=1, cy=1, z=11, text={x=135,y=-220, w=202, h=39,lineType="multiline",size=30,color="ffffff",alignment="center",space=0,textType="input"}, d={{name="nillpoint", isArmature=0}} },
           {type="b", name="text5", x=198, y=-427, kx=0, ky=0, cx=1, cy=1, z=12, text={x=197,y=-427, w=233, h=39,lineType="multiline",size=30,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="nillpoint", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="taskrender", 
      bones={           
           {type="b", name="hit_area", x=0, y=167.05, kx=0, ky=0, cx=128.25, cy=41.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="background", x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} },
           {type="b", name="common_friendNameBg", x=76.2, y=69.70000000000002, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_friendNameBg", isArmature=0}} },
           {type="b", name="img", x=4.15, y=143.20000000000002, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonSingleImgButtons/common_copy_leftArrow_button", isArmature=0}} },
           {type="b", name="word2", x=212.45, y=167.10000000000002, kx=0, ky=0, cx=1, cy=1, z=4, text={x=382,y=100, w=124, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="word3", x=212.45, y=167.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, text={x=114,y=31, w=70, h=36,lineType="single line",size=24,color="461e08",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gift1", x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=6, text={x=167,y=34, w=157, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gift2", x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=7, text={x=167,y=34, w=157, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="condition", x=212.45, y=77.10000000000001, kx=0, ky=0, cx=1, cy=1, z=8, text={x=114,y=66, w=270, h=70,lineType="multiline",size=24,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gift_number1", x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=9, text={x=167,y=34, w=150, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gift_number2", x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=10, text={x=167,y=34, w=150, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="botton", x=365.75, y=77.95000000000002, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=-44, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="taskResource", 
      bones={           
           {type="b", name="hit_area", x=0, y=167, kx=0, ky=0, cx=128.25, cy=41.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="word4", x=1.5, y=164.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="gift_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_small_orange_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="task_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=197, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_1", sc=1, dl=0, f={
                {x=570.15, y=669.85, kx=0, ky=0, cx=0.55, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_2", sc=1, dl=0, f={
                {x=1164.7, y=649.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_3", sc=1, dl=0, f={
                {x=592.5, y=46.450000000000045, kx=0, ky=0, cx=0.56, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_4", sc=1, dl=0, f={
                {x=596.95, y=647.85, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renwu_bg", sc=1, dl=0, f={
                {x=594.95, y=682.6, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=625.4, y=648.9, kx=0, ky=0, cx=6.46, cy=7.29, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="notaskui", sc=1, dl=0, f={
                {x=653, y=625, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1143.4, y=697.2, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_1", sc=1, dl=0, f={
                {x=1163, y=590.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_2", sc=1, dl=0, f={
                {x=1163, y=454.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render2", sc=1, dl=0, f={
                {x=633.9, y=469.85, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render1", sc=1, dl=0, f={
                {x=633.9, y=642.85, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xiaohongdian", sc=1, dl=0, f={
                {x=1230.45, y=450.05, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="ink_r", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="ink_r_rig", sc=1, dl=0, f={
                {x=517.05, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_r_mid", sc=1, dl=0, f={
                {x=132.9, y=0, kx=0, ky=0, cx=1.92, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_r_lef", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="ink_c", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="ink_c_down", sc=1, dl=0, f={
                {x=0, y=-480.7, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_c_mid", sc=1, dl=0, f={
                {x=0, y=-94, kx=0, ky=0, cx=1, cy=3.25, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ink_c_up", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="noTaskUI", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=118.75, cy=137.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=6.01, cy=6.96, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg2", sc=1, dl=0, f={
                {x=5, y=-5, kx=0, ky=0, cx=10.33, cy=1.04, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meiyourenwu", sc=1, dl=0, f={
                {x=28, y=-175, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meiyourenwu2", sc=1, dl=0, f={
                {x=28, y=-381, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="label1", sc=1, dl=0, f={
                {x=140, y=-110, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="label2", sc=1, dl=0, f={
                {x=140, y=-320, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="image1", sc=1, dl=0, f={
                {x=124.5, y=-380.3, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=35, y=-49, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=136, y=-154, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text3", sc=1, dl=0, f={
                {x=136, y=-364, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text4", sc=1, dl=0, f={
                {x=136, y=-220, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text5", sc=1, dl=0, f={
                {x=198, y=-427, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_channel_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=-2, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="taskrender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=128.25, cy=41.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_friendNameBg", sc=1, dl=0, f={
                {x=76.2, y=69.70000000000002, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img", sc=1, dl=0, f={
                {x=4.15, y=143.20000000000002, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word2", sc=1, dl=0, f={
                {x=212.45, y=167.10000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word3", sc=1, dl=0, f={
                {x=212.45, y=167.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gift1", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gift2", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="condition", sc=1, dl=0, f={
                {x=212.45, y=77.10000000000001, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gift_number1", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gift_number2", sc=1, dl=0, f={
                {x=0, y=167.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="botton", sc=1, dl=0, f={
                {x=365.75, y=77.95000000000002, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_small_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="taskResource", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=167, kx=0, ky=0, cx=128.25, cy=41.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word4", sc=1, dl=0, f={
                {x=1.5, y=164.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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