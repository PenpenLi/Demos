local conf = {type="skeleton", name="chat_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="imgs", 
      bones={           
           {type="b", name="图层 1", x=2.5, y=4, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="line", isArmature=0}} }
         }
      },
    {type="armature", name="chat_pop", 
      bones={           
           {type="b", name="hit_area", x=0, y=455, kx=0, ky=0, cx=268, cy=113.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="chat_pop_bg", x=0, y=455, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="chatImages/chat_pop_bg", isArmature=0}} },
           {type="b", name="chat_pop_bg_small", x=0, y=455, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="chatImages/chat_pop_bg_small", isArmature=0}} },
           {type="b", name="chat_bg_scalable", x=145.25, y=427, kx=0, ky=0, cx=27.88, cy=2.83, z=3, text={x=156,y=374, w=475, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="chat_bg_scalable_1", x=732, y=426, kx=0, ky=0, cx=4.6, cy=2.71, z=4, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="chat_bg_scalable_2", x=20.95, y=348, kx=0, ky=0, cx=12.56, cy=3.23, z=5, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_small_blue_button", x=856, y=414.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="chat_pop_button", x=26.85, y=426.5, kx=0, ky=0, cx=1, cy=1, z=7, text={x=44,y=373, w=75, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="chatButtons/pop_button", isArmature=1}} },
           {type="b", name="chat_jiahao", x=63.35, y=413, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="chat_jiahao", isArmature=0}} },
           {type="b", name="chat_jianhao", x=63.35, y=400, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="chat_jianhao", isArmature=0}} },
           {type="b", name="insert_button_1", x=47, y=83, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="shuru_tab_btn", isArmature=1}} },
           {type="b", name="insert_button_2", x=234, y=83, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="shuru_tab_btn", isArmature=1}} },
           {type="b", name="back_button", x=761, y=421, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="chatButtons/back_button", isArmature=1}} },
           {type="b", name="trumpet_descb", x=738, y=414, kx=0, ky=0, cx=1, cy=1, z=13, text={x=771,y=373, w=88, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="trumpet_img", isArmature=0}} },
           {type="b", name="text", x=64.85, y=234.85, kx=0, ky=0, cx=1, cy=1, z=14, text={x=136,y=195, w=800, h=39,lineType="single line",size=26,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="chat_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=319.99, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_5", x=70.5, y=692, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_close_button", x=1150, y=712, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="chat_bg_scalable", x=113.5, y=655, kx=0, ky=0, cx=12.16, cy=5.67, z=3, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="channel_button", x=1107, y=642, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="channel_button", isArmature=1}} },
           {type="b", name="channel_button_1", x=1107, y=531, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="channel_button", isArmature=1}} }
         }
      },
    {type="armature", name="channel_button", 
      bones={           
           {type="b", name="channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=18,y=-96, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="channel_button_normal", isArmature=0},{name="channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="chatButtons/back_button", 
      bones={           
           {type="b", name="back_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="chatButtons/back_button_normal", isArmature=0},{name="chatButtons/back_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="chatButtons/pop_button", 
      bones={           
           {type="b", name="pop_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="chatButtons/pop_button_normal", isArmature=0},{name="chatButtons/pop_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonBackgrounds/common_copy_background_img", 
      bones={           
           {type="b", name="bag_background_img_sub_3_1_1_copy_1", x=476, y=642.35, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_1_copy", x=672, y=642.35, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_1_copy_2", x=872, y=642.35, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_2_copy_1", x=476, y=0, kx=180, ky=0, cx=1, cy=1, z=3, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_2_copy", x=672, y=0, kx=180, ky=0, cx=1, cy=1, z=4, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_2_copy_2", x=872, y=0, kx=180, ky=0, cx=1, cy=1, z=5, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_1", x=0, y=642.35, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_2", x=1129, y=642.35, kx=0, ky=180, cx=1, cy=1, z=7, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_3", x=1129, y=0.35000000000002274, kx=180, ky=180, cx=1, cy=1, z=8, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_4", x=0, y=0.35000000000002274, kx=180, ky=0, cx=1, cy=1, z=9, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_1_1", x=0, y=562.35, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_1_2", x=1129, y=562.35, kx=0, ky=180, cx=1, cy=1, z=11, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_2_1", x=-0.15, y=412.35, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_2_2", x=1129, y=412.35, kx=0, ky=180, cx=1, cy=1, z=13, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_3_1", x=0, y=262.35, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_3", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_3_2", x=1129, y=262.35, kx=0, ky=180, cx=1, cy=1, z=15, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_2_3", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_1", x=80, y=642.35, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_2", x=80, y=0, kx=180, ky=0, cx=1, cy=1, z=17, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_1", x=25, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=18, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_2", x=1049, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=19, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_3", x=80, y=81, kx=0, ky=0, cx=323.33, cy=18.33, z=20, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_4", x=80, y=616.35, kx=0, ky=0, cx=323.34, cy=18.33, z=21, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_5", x=80, y=561.35, kx=0, ky=0, cx=323.33, cy=160.67, z=22, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_1", x=276, y=642.35, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_2", x=276, y=0, kx=180, ky=0, cx=1, cy=1, z=24, d={{name="commonBackgrounds/common_copy_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=84, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_tab_button", 
      bones={           
           {type="b", name="common_tab_button", x=0, y=134, kx=0, ky=0, cx=1, cy=1, z=0, text={x=31,y=22, w=40, h=91,lineType="single line",size=32,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_tab_button_normal", isArmature=0},{name="commonButtons/common_copy_tab_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="shuru_tab_btn", 
      bones={           
           {type="b", name="shuru_tab_btn", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="shuru_tab_btn_normal", isArmature=0},{name="shuru_tab_btn_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=2.5, y=4, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chat_pop", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=455, kx=0, ky=0, cx=268, cy=113.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_pop_bg", sc=1, dl=0, f={
                {x=0, y=455, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_pop_bg_small", sc=1, dl=0, f={
                {x=0, y=455, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_bg_scalable", sc=1, dl=0, f={
                {x=145.25, y=427, kx=0, ky=0, cx=27.88, cy=2.83, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_bg_scalable_1", sc=1, dl=0, f={
                {x=732, y=426, kx=0, ky=0, cx=4.6, cy=2.71, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_bg_scalable_2", sc=1, dl=0, f={
                {x=20.95, y=348, kx=0, ky=0, cx=12.56, cy=3.23, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=856, y=414.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_pop_button", sc=1, dl=0, f={
                {x=26.85, y=426.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_jiahao", sc=1, dl=0, f={
                {x=63.35, y=413, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_jianhao", sc=1, dl=0, f={
                {x=63.35, y=400, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="insert_button_1", sc=1, dl=0, f={
                {x=47, y=83, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="insert_button_2", sc=1, dl=0, f={
                {x=234, y=83, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="back_button", sc=1, dl=0, f={
                {x=761, y=421, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="trumpet_descb", sc=1, dl=0, f={
                {x=738, y=414, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text", sc=1, dl=0, f={
                {x=64.85, y=234.85, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chat_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=319.99, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=70.5, y=692, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=1150, y=712, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_bg_scalable", sc=1, dl=0, f={
                {x=113.5, y=655, kx=0, ky=0, cx=12.16, cy=5.67, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_button", sc=1, dl=0, f={
                {x=1107, y=642, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_button_1", sc=1, dl=0, f={
                {x=1107, y=531, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="channel_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="chatButtons/back_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="back_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="back_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="back_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="chatButtons/pop_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pop_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pop_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pop_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonBackgrounds/common_copy_background_img", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bag_background_img_sub_3_1_1_copy_1", sc=1, dl=0, f={
                {x=476, y=642.35, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_1_copy", sc=1, dl=0, f={
                {x=672, y=642.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_1_copy_2", sc=1, dl=0, f={
                {x=872, y=642.35, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_2_copy_1", sc=1, dl=0, f={
                {x=476, y=0, kx=180, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_2_copy", sc=1, dl=0, f={
                {x=672, y=0, kx=180, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_2_copy_2", sc=1, dl=0, f={
                {x=872, y=0, kx=180, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_1", sc=1, dl=0, f={
                {x=0, y=642.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_2", sc=1, dl=0, f={
                {x=1129, y=642.35, kx=0, ky=180, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_3", sc=1, dl=0, f={
                {x=1129, y=0.35000000000002274, kx=180, ky=180, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_4", sc=1, dl=0, f={
                {x=0, y=0.35000000000002274, kx=180, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_1_1", sc=1, dl=0, f={
                {x=0, y=562.35, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_1_2", sc=1, dl=0, f={
                {x=1129, y=562.35, kx=0, ky=180, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_2_1", sc=1, dl=0, f={
                {x=-0.15, y=412.35, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_2_2", sc=1, dl=0, f={
                {x=1129, y=412.35, kx=0, ky=180, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_3_1", sc=1, dl=0, f={
                {x=0, y=262.35, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_3_2", sc=1, dl=0, f={
                {x=1129, y=262.35, kx=0, ky=180, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_1", sc=1, dl=0, f={
                {x=80, y=642.35, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_2", sc=1, dl=0, f={
                {x=80, y=0, kx=180, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_1", sc=1, dl=0, f={
                {x=25, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_2", sc=1, dl=0, f={
                {x=1049, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_3", sc=1, dl=0, f={
                {x=80, y=81, kx=0, ky=0, cx=323.33, cy=18.33, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_4", sc=1, dl=0, f={
                {x=80, y=616.35, kx=0, ky=0, cx=323.34, cy=18.33, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_5", sc=1, dl=0, f={
                {x=80, y=561.35, kx=0, ky=0, cx=323.33, cy=160.67, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_1", sc=1, dl=0, f={
                {x=276, y=642.35, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_2", sc=1, dl=0, f={
                {x=276, y=0, kx=180, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=84, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=84, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_small_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_tab_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=134, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=134, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=134, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="shuru_tab_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="shuru_tab_btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="shuru_tab_btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="shuru_tab_btn", sc=1, dl=0, f={
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