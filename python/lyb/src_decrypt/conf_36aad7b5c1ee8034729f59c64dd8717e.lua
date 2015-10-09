local conf = {type="skeleton", name="yongbing_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="select_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=620, kx=0, ky=0, cx=120, cy=155, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=620, kx=0, ky=0, cx=6.08, cy=7.85, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_copy_line_horizon", x=10, y=77, kx=0, ky=0, cx=1, cy=1, z=2, text={x=330,y=20, w=131, h=39,lineType="single line",size=26,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_line_horizon", isArmature=0}} },
           {type="b", name="btn", x=174, y=68.10000000000002, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="tab_ui_1_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=210, kx=0, ky=0, cx=233.75, cy=52.5, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=210, kx=0, ky=0, cx=9.54, cy=2.26, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="yongbing_circle", x=40.45, y=172, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="yongbing_circle", isArmature=0}} },
           {type="b", name="yongbing_plus", x=77.95, y=145, kx=0, ky=0, cx=1, cy=1, z=3, text={x=48,y=42, w=118, h=39,lineType="single line",size=26,color="ddd8b6",alignment="center",space=0,textType="dynamic"}, d={{name="yongbing_plus", isArmature=0}} },
           {type="b", name="descb_1", x=559.95, y=151.9, kx=0, ky=0, cx=1, cy=1, z=4, text={x=211,y=130, w=150, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2", x=559.95, y=107.9, kx=0, ky=0, cx=1, cy=1, z=5, text={x=211,y=86, w=150, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3", x=559.95, y=61.94999999999999, kx=0, ky=0, cx=1, cy=1, z=6, text={x=211,y=42, w=271, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_11", x=689.95, y=151.9, kx=0, ky=0, cx=1, cy=1, z=7, text={x=341,y=129, w=150, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_22", x=689.95, y=107.9, kx=0, ky=0, cx=1, cy=1, z=8, text={x=405,y=85, w=150, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_33", x=689.95, y=61.94999999999999, kx=0, ky=0, cx=1, cy=1, z=9, text={x=422,y=41, w=150, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_4", x=559.95, y=157.9, kx=0, ky=0, cx=1, cy=1, z=10, text={x=211,y=107, w=200, h=39,lineType="single line",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_5", x=559.95, y=111.9, kx=0, ky=0, cx=1, cy=1, z=11, text={x=370,y=71, w=485, h=75,lineType="multiline",size=26,color="ffb400",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="btn", x=677.15, y=138.5, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=8,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="tab_ui_2_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=222, kx=0, ky=0, cx=52, cy=55.5, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=222, kx=0, ky=0, cx=2.12, cy=2.39, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="descb", x=18, y=44.94999999999999, kx=0, ky=0, cx=1, cy=1, z=2, text={x=18,y=10, w=172, h=34,lineType="single line",size=22,color="fef9e9",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_red_bg", isArmature=0}} },
           {type="b", name="name_descb", x=149.45, y=180.1, kx=0, ky=0, cx=1, cy=1, z=3, text={x=12,y=176, w=185, h=39,lineType="single line",size=22,color="ffb400",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="yongbing_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70.5, y=684, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=126, y=604.5, kx=0, ky=0, cx=11.95, cy=6.16, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="tabBtn2", x=1102, y=479, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="channel_button", isArmature=1}} },
           {type="b", name="tabBtn1", x=1102, y=590, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="channel_button", isArmature=1}} },
           {type="b", name="titleBg", x=472.5, y=662, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="titleTF", x=637.2, y=87.25, kx=0, ky=0, cx=1, cy=1, z=6, text={x=281,y=55, w=720, h=36,lineType="single line",size=24,color="ffb400",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="close_btn", x=1153, y=712, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1068, y=705, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="channel_button", 
      bones={           
           {type="b", name="channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=18,y=-96, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="channel_button_normal", isArmature=0},{name="channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="select_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=620, kx=0, ky=0, cx=120, cy=155, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=620, kx=0, ky=0, cx=6.08, cy=7.85, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_horizon", sc=1, dl=0, f={
                {x=10, y=77, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=174, y=68.10000000000002, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
    {type="animation", name="tab_ui_1_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=210, kx=0, ky=0, cx=233.75, cy=52.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=210, kx=0, ky=0, cx=9.54, cy=2.26, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yongbing_circle", sc=1, dl=0, f={
                {x=40.45, y=172, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yongbing_plus", sc=1, dl=0, f={
                {x=77.95, y=145, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=559.95, y=151.9, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=559.95, y=107.9, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3", sc=1, dl=0, f={
                {x=559.95, y=61.94999999999999, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_11", sc=1, dl=0, f={
                {x=689.95, y=151.9, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_22", sc=1, dl=0, f={
                {x=689.95, y=107.9, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_33", sc=1, dl=0, f={
                {x=689.95, y=61.94999999999999, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_4", sc=1, dl=0, f={
                {x=559.95, y=157.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_5", sc=1, dl=0, f={
                {x=559.95, y=111.9, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=677.15, y=138.5, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="tab_ui_2_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=222, kx=0, ky=0, cx=52, cy=55.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=222, kx=0, ky=0, cx=2.12, cy=2.39, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=18, y=44.94999999999999, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=149.45, y=180.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="yongbing_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70.5, y=684, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=126, y=604.5, kx=0, ky=0, cx=11.95, cy=6.16, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn2", sc=1, dl=0, f={
                {x=1102, y=479, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn1", sc=1, dl=0, f={
                {x=1102, y=590, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=472.5, y=662, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleTF", sc=1, dl=0, f={
                {x=637.2, y=87.25, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1153, y=712, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1068, y=705, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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