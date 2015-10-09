local conf = {type="skeleton", name="xunbao_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="roll_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=319.99, cy=179.99, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_blue_button3", x=545, y=260, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button2", x=675, y=260, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button1", x=410, y=260, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="typeGroup", 
      bones={           
           {type="b", name="type_5", x=540.3, y=149, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="type_5", isArmature=0}} },
           {type="b", name="type_4", x=413.35, y=145, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="type_4", isArmature=0}} },
           {type="b", name="type_3", x=277.35, y=142, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="type_3", isArmature=0}} },
           {type="b", name="type_2", x=146.35, y=145, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="type_2", isArmature=0}} },
           {type="b", name="type_1", x=41.35, y=155.95, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="type_1", isArmature=0}} },
           {type="b", name="roll_6", x=451.95, y=80.49999999999999, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="roll_6", isArmature=0}} },
           {type="b", name="roll_5", x=353, y=92.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="roll_5", isArmature=0}} },
           {type="b", name="roll_4", x=261, y=88.49999999999999, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="roll_4", isArmature=0}} },
           {type="b", name="roll_3", x=187, y=92.5, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="roll_3", isArmature=0}} },
           {type="b", name="roll_2", x=107, y=89.49999999999999, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="roll_2", isArmature=0}} },
           {type="b", name="roll_1", x=36, y=84.94999999999999, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="roll_1", isArmature=0}} }
         }
      },
    {type="armature", name="xunbao_ui", 
      bones={           
           {type="b", name="pointGroup", x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="pointGroup", isArmature=1}} },
           {type="b", name="ask_btn", x=1095, y=703, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_ask_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1190, y=710, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_close_button", isArmature=1}} },
           {type="b", name="title", x=395, y=720, kx=0, ky=0, cx=1, cy=1, z=3, text={x=520,y=667, w=239, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_biaoti_new", isArmature=0}} }
         }
      },
    {type="armature", name="pointGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=319.99, cy=179.99, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="point_0", x=43.85, y=-148.85, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="beginEnd", isArmature=0}} },
           {type="b", name="point_1", x=116.85, y=-214.85, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_2", x=206.85, y=-260.85, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_3", x=115.85, y=-304.85, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_4", x=23.85, y=-349.85, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_5", x=112.85, y=-394.8, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_6", x=202.85, y=-440.8, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_7", x=113.85, y=-486.8, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_8", x=202.85, y=-532.8, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_9", x=294.8, y=-578.8, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_10", x=384.8, y=-623.8, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_11", x=473.8, y=-577.85, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_12", x=562.8, y=-534.85, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_13", x=650.8, y=-580.8, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_14", x=740.8, y=-535.85, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_15", x=830.8, y=-489.8, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_16", x=920.8, y=-536.85, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_17", x=1009.8, y=-492.8, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_18", x=1101.3, y=-447.3, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_19", x=1011.8, y=-400.8, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_20", x=1103.75, y=-353.85, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_21", x=1013.8, y=-306.8, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_22", x=926.3, y=-259.3, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_23", x=836.8, y=-213.85, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_24", x=745.8, y=-167.8, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="back_2", isArmature=0}} },
           {type="b", name="point_25", x=654.8, y=-214.8, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="back_1", isArmature=0}} },
           {type="b", name="point_26", x=564.8, y=-167.85, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="back_3", isArmature=0}} },
           {type="b", name="point_27", x=442.8, y=-214.85, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="beginEnd", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="roll_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=319.99, cy=179.99, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button3", sc=1, dl=0, f={
                {x=545, y=260, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button2", sc=1, dl=0, f={
                {x=675, y=260, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button1", sc=1, dl=0, f={
                {x=410, y=260, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="typeGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="type_5", sc=1, dl=0, f={
                {x=540.3, y=149, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_4", sc=1, dl=0, f={
                {x=413.35, y=145, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_3", sc=1, dl=0, f={
                {x=277.35, y=142, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_2", sc=1, dl=0, f={
                {x=146.35, y=145, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_1", sc=1, dl=0, f={
                {x=41.35, y=155.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_6", sc=1, dl=0, f={
                {x=451.95, y=80.49999999999999, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_5", sc=1, dl=0, f={
                {x=353, y=92.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_4", sc=1, dl=0, f={
                {x=261, y=88.49999999999999, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_3", sc=1, dl=0, f={
                {x=187, y=92.5, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_2", sc=1, dl=0, f={
                {x=107, y=89.49999999999999, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roll_1", sc=1, dl=0, f={
                {x=36, y=84.94999999999999, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="xunbao_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pointGroup", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask_btn", sc=1, dl=0, f={
                {x=1095, y=703, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1190, y=710, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=395, y=720, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="pointGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=319.99, cy=179.99, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_0", sc=1, dl=0, f={
                {x=43.85, y=-148.85, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_1", sc=1, dl=0, f={
                {x=116.85, y=-214.85, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_2", sc=1, dl=0, f={
                {x=206.85, y=-260.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_3", sc=1, dl=0, f={
                {x=115.85, y=-304.85, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_4", sc=1, dl=0, f={
                {x=23.85, y=-349.85, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_5", sc=1, dl=0, f={
                {x=112.85, y=-394.8, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_6", sc=1, dl=0, f={
                {x=202.85, y=-440.8, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_7", sc=1, dl=0, f={
                {x=113.85, y=-486.8, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_8", sc=1, dl=0, f={
                {x=202.85, y=-532.8, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_9", sc=1, dl=0, f={
                {x=294.8, y=-578.8, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_10", sc=1, dl=0, f={
                {x=384.8, y=-623.8, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_11", sc=1, dl=0, f={
                {x=473.8, y=-577.85, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_12", sc=1, dl=0, f={
                {x=562.8, y=-534.85, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_13", sc=1, dl=0, f={
                {x=650.8, y=-580.8, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_14", sc=1, dl=0, f={
                {x=740.8, y=-535.85, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_15", sc=1, dl=0, f={
                {x=830.8, y=-489.8, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_16", sc=1, dl=0, f={
                {x=920.8, y=-536.85, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_17", sc=1, dl=0, f={
                {x=1009.8, y=-492.8, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_18", sc=1, dl=0, f={
                {x=1101.3, y=-447.3, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_19", sc=1, dl=0, f={
                {x=1011.8, y=-400.8, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_20", sc=1, dl=0, f={
                {x=1103.75, y=-353.85, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_21", sc=1, dl=0, f={
                {x=1013.8, y=-306.8, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_22", sc=1, dl=0, f={
                {x=926.3, y=-259.3, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_23", sc=1, dl=0, f={
                {x=836.8, y=-213.85, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_24", sc=1, dl=0, f={
                {x=745.8, y=-167.8, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_25", sc=1, dl=0, f={
                {x=654.8, y=-214.8, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_26", sc=1, dl=0, f={
                {x=564.8, y=-167.85, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="point_27", sc=1, dl=0, f={
                {x=442.8, y=-214.85, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
      }
  }
}
 return conf;