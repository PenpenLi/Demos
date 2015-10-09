local conf = {type="skeleton", name="strengthen_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="imgs", 
      bones={           
           {type="b", name="图层 2", x=55, y=107, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="xiaozi_bg", isArmature=0}} },
           {type="b", name="图层 3", x=142.85, y=111.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="level_is_not_enough", isArmature=1}} }
         }
      },
    {type="armature", name="jinjie_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg_2", x=538, y=633.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="strengthen_detail_bg", isArmature=0}} },
           {type="b", name="descb", x=793.45, y=275.65, kx=0, ky=0, cx=1, cy=1, z=2, text={x=655,y=325, w=380, h=36,lineType="single line",size=24,color="ff0000",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="arrow_1", x=797.5, y=448.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="strengthenImages/arrow", isArmature=0}} },
           {type="b", name="btn_1", x=749.5, y=128.70000000000005, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="jinjie_bg_1", x=572, y=620, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="jinjie_bg", isArmature=0}} },
           {type="b", name="jinjie_bg_2", x=906, y=620, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="jinjie_bg", isArmature=0}} },
           {type="b", name="name_bg_1", x=590.5, y=481.15, kx=0, ky=0, cx=1, cy=1, z=7, text={x=591,y=445, w=172, h=36,lineType="single line",size=24,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="name_bg", isArmature=0}} },
           {type="b", name="name_bg_2", x=924.95, y=481.15, kx=0, ky=0, cx=1, cy=1, z=8, text={x=925,y=445, w=172, h=36,lineType="single line",size=24,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="name_bg", isArmature=0}} },
           {type="b", name="left_descb_1", x=596.45, y=438.1, kx=0, ky=0, cx=1, cy=1, z=9, text={x=593,y=407, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="left_descb_2", x=596.45, y=398.1, kx=0, ky=0, cx=1, cy=1, z=10, text={x=593,y=379, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="left_descb_3", x=596.45, y=363.1, kx=0, ky=0, cx=1, cy=1, z=11, text={x=593,y=351, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="left_descb_4", x=596.45, y=343.1, kx=0, ky=0, cx=1, cy=1, z=12, text={x=593,y=323, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="left_descb_5", x=596.45, y=324.1, kx=0, ky=0, cx=1, cy=1, z=13, text={x=593,y=295, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="right_descb_1", x=934.45, y=438.1, kx=0, ky=0, cx=1, cy=1, z=14, text={x=927,y=407, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="right_descb_2", x=934.45, y=398.1, kx=0, ky=0, cx=1, cy=1, z=15, text={x=927,y=379, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="right_descb_3", x=934.45, y=363.1, kx=0, ky=0, cx=1, cy=1, z=16, text={x=927,y=351, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="right_descb_4", x=934.45, y=343.1, kx=0, ky=0, cx=1, cy=1, z=17, text={x=927,y=323, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="right_descb_5", x=934.45, y=324.1, kx=0, ky=0, cx=1, cy=1, z=18, text={x=927,y=295, w=203, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="center_descb_1", x=793.45, y=507.65, kx=0, ky=0, cx=1, cy=1, z=19, text={x=770,y=474, w=150, h=31,lineType="single line",size=20,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="center_descb_2", x=793.45, y=478.15, kx=0, ky=0, cx=1, cy=1, z=20, text={x=770,y=444, w=150, h=31,lineType="single line",size=20,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bottom_descb_1", x=600.45, y=274.7, kx=0, ky=0, cx=1, cy=1, z=21, text={x=577,y=250, w=150, h=31,lineType="single line",size=20,color="fef9e9",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bottom_descb_2", x=706.45, y=159.10000000000002, kx=0, ky=0, cx=1, cy=1, z=22, text={x=748,y=130, w=347, h=36,lineType="single line",size=24,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="level_is_not_enough", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="level_not_enough_bg", isArmature=0}} },
           {type="b", name="descb_2", x=36.7, y=-85.05, kx=0, ky=0, cx=1, cy=1, z=1, text={x=4,y=-88, w=100, h=31,lineType="single line",size=20,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1", x=33.7, y=-57.45, kx=0, ky=0, cx=1, cy=1, z=2, text={x=4,y=-58, w=100, h=31,lineType="single line",size=20,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="name_item", 
      bones={           
           {type="b", name="name_item_bg", x=0, y=72, kx=0, ky=0, cx=5.57, cy=1, z=0, text={x=18,y=19, w=242, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="static"}, d={{name="name_item_bg", isArmature=0}} },
           {type="b", name="name_item_level_bg", x=173.9, y=66, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="name_item_level_bg", isArmature=0}} }
         }
      },
    {type="armature", name="name_item_follow", 
      bones={           
           {type="b", name="common_copy_background_6", x=0, y=235, kx=0, ky=0, cx=4.7, cy=2.87, z=0, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} }
         }
      },
    {type="armature", name="strengthen_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg_2", x=538, y=633.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="strengthen_detail_bg", isArmature=0}} },
           {type="b", name="descb", x=793.45, y=275.65, kx=0, ky=0, cx=1, cy=1, z=2, text={x=655,y=325, w=380, h=36,lineType="single line",size=24,color="ff0000",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_descb", x=706.45, y=271.1, kx=0, ky=0, cx=1, cy=1, z=3, text={x=595,y=254, w=203, h=36,lineType="single line",size=24,color="fef9e9",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb", x=706.45, y=229.1, kx=0, ky=0, cx=1, cy=1, z=4, text={x=595,y=212, w=203, h=36,lineType="single line",size=24,color="fef9e9",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silver_descb", x=706.45, y=193.1, kx=0, ky=0, cx=1, cy=1, z=5, text={x=748,y=164, w=347, h=36,lineType="single line",size=24,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_s_descb", x=972, y=267.1, kx=0, ky=0, cx=1, cy=1, z=6, text={x=916,y=254, w=150, h=36,lineType="single line",size=24,color="02ff0e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_s_descb", x=972, y=230.1, kx=0, ky=0, cx=1, cy=1, z=7, text={x=916,y=212, w=150, h=36,lineType="single line",size=24,color="02ff0e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="arrow_1", x=800.5, y=297.65, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="strengthenImages/arrow", isArmature=0}} },
           {type="b", name="arrow_2", x=800.5, y=254.65, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="strengthenImages/arrow", isArmature=0}} },
           {type="b", name="btn_1", x=622, y=153.70000000000005, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="btn_2", x=875, y=153.70000000000005, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="circle_bg", x=701.5, y=578.6, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="circle_bg", isArmature=0}} },
           {type="b", name="name_bg", x=759, y=348.15, kx=0, ky=0, cx=1, cy=1, z=13, text={x=759,y=314, w=172, h=36,lineType="single line",size=24,color="fdf0c9",alignment="center",space=0,textType="static"}, d={{name="name_bg", isArmature=0}} },
           {type="b", name="prop_descb0", x=968.45, y=19.100000000000023, kx=0, ky=0, cx=1, cy=1, z=14, text={x=869,y=56, w=203, h=34,lineType="single line",size=22,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=8,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="strengthen_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=55, y=676, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=90, y=634, kx=0, ky=0, cx=5.18, cy=7.07, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="tab_btn_2", x=1165, y=500, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tab_btn_1", x=1165, y=627, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="close_btn", x=1135, y=697, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1050, y=690, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=55, y=107, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=142.85, y=111.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="jinjie_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=538, y=633.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=793.45, y=275.65, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_1", sc=1, dl=0, f={
                {x=797.5, y=448.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=749.5, y=128.70000000000005, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_bg_1", sc=1, dl=0, f={
                {x=572, y=620, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_bg_2", sc=1, dl=0, f={
                {x=906, y=620, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg_1", sc=1, dl=0, f={
                {x=590.5, y=481.15, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg_2", sc=1, dl=0, f={
                {x=924.95, y=481.15, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_descb_1", sc=1, dl=0, f={
                {x=596.45, y=438.1, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_descb_2", sc=1, dl=0, f={
                {x=596.45, y=398.1, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_descb_3", sc=1, dl=0, f={
                {x=596.45, y=363.1, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_descb_4", sc=1, dl=0, f={
                {x=596.45, y=343.1, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_descb_5", sc=1, dl=0, f={
                {x=596.45, y=324.1, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_descb_1", sc=1, dl=0, f={
                {x=934.45, y=438.1, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_descb_2", sc=1, dl=0, f={
                {x=934.45, y=398.1, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_descb_3", sc=1, dl=0, f={
                {x=934.45, y=363.1, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_descb_4", sc=1, dl=0, f={
                {x=934.45, y=343.1, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_descb_5", sc=1, dl=0, f={
                {x=934.45, y=324.1, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="center_descb_1", sc=1, dl=0, f={
                {x=793.45, y=507.65, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="center_descb_2", sc=1, dl=0, f={
                {x=793.45, y=478.15, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bottom_descb_1", sc=1, dl=0, f={
                {x=600.45, y=274.7, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bottom_descb_2", sc=1, dl=0, f={
                {x=706.45, y=159.10000000000002, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="level_is_not_enough", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=36.7, y=-85.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=33.7, y=-57.45, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="name_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="name_item_bg", sc=1, dl=0, f={
                {x=0, y=72, kx=0, ky=0, cx=5.57, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_item_level_bg", sc=1, dl=0, f={
                {x=173.9, y=66, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="name_item_follow", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=0, y=235, kx=0, ky=0, cx=4.7, cy=2.87, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="strengthen_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=538, y=633.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=793.45, y=275.65, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=706.45, y=271.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb", sc=1, dl=0, f={
                {x=706.45, y=229.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb", sc=1, dl=0, f={
                {x=706.45, y=193.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_s_descb", sc=1, dl=0, f={
                {x=972, y=267.1, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_s_descb", sc=1, dl=0, f={
                {x=972, y=230.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_1", sc=1, dl=0, f={
                {x=800.5, y=297.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_2", sc=1, dl=0, f={
                {x=800.5, y=254.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=622, y=153.70000000000005, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=875, y=153.70000000000005, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="circle_bg", sc=1, dl=0, f={
                {x=701.5, y=578.6, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=759, y=348.15, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb0", sc=1, dl=0, f={
                {x=968.45, y=19.100000000000023, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_blue_button", 
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
    {type="animation", name="strengthen_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=55, y=676, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=90, y=634, kx=0, ky=0, cx=5.18, cy=7.07, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_2", sc=1, dl=0, f={
                {x=1165, y=500, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_1", sc=1, dl=0, f={
                {x=1165, y=627, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1135, y=697, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1050, y=690, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;