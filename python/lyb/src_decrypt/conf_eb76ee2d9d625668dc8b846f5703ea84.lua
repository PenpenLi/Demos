local conf = {type="skeleton", name="zhenfa_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="zhenfa_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="dibu_panel", x=77.8, y=657.65, kx=0, ky=0, cx=0.95, cy=0.95, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="youce_panel", x=357.3, y=583.65, kx=0, ky=0, cx=7.57, cy=5.13, z=2, d={{name="youce_panel", isArmature=0}} },
           {type="b", name="youshang_panel", x=374.3, y=566.65, kx=0, ky=0, cx=21.24, cy=5.26, z=3, d={{name="youshang_panel", isArmature=0}} },
           {type="b", name="youzhong_panel", x=372.8, y=378.15, kx=0, ky=0, cx=16.81, cy=3.09, z=4, d={{name="youxia_panel", isArmature=0}} },
           {type="b", name="dark1_bg", x=372.3, y=378.65, kx=0, ky=0, cx=16.43, cy=1, z=5, d={{name="dark_bg", isArmature=0}} },
           {type="b", name="youxia_panel", x=372.8, y=236.2, kx=0, ky=0, cx=16.84, cy=3.47, z=6, d={{name="youxia_panel", isArmature=0}} },
           {type="b", name="dark2_bg", x=372.3, y=237.65, kx=0, ky=0, cx=16.43, cy=1, z=7, d={{name="dark_bg", isArmature=0}} },
           {type="b", name="name_txt", x=400.95, y=510, kx=0, ky=0, cx=1, cy=1, z=8, text={x=404,y=460, w=110, h=36,lineType="single line",size=32,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="jiacheng_txt", x=384.95, y=391, kx=0, ky=0, cx=1, cy=1, z=9, text={x=392,y=342, w=115, h=30,lineType="single line",size=26,color="e9ceaf",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="jihuo_txt", x=705.95, y=538, kx=0, ky=0, cx=1, cy=1, z=10, text={x=514,y=463, w=114, h=26,lineType="single line",size=22,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="manji_txt", x=648.95, y=422, kx=0, ky=0, cx=1, cy=1, z=11, text={x=517,y=344, w=114, h=26,lineType="single line",size=22,color="e9ceaf",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="dangqian_txt", x=493.95, y=345.4, kx=0, ky=0, cx=1, cy=1, z=12, text={x=496,y=302, w=544, h=26,lineType="single line",size=22,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="xiaji_txt", x=493.95, y=305.4, kx=0, ky=0, cx=1, cy=1, z=13, text={x=496,y=262, w=544, h=26,lineType="single line",size=22,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="jihuozhenfa_txt", x=384.95, y=248.05, kx=0, ky=0, cx=1, cy=1, z=14, text={x=393,y=200, w=115, h=30,lineType="single line",size=26,color="e9ceaf",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="num_txt", x=824.95, y=196.04999999999995, kx=0, ky=0, cx=1, cy=1, z=15, text={x=692,y=124, w=114, h=26,lineType="single line",size=22,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="daoju_img", x=549.95, y=152.04999999999995, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="yinbi_img", x=655.95, y=150.04999999999995, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="blue_button", x=945.95, y=169.20000000000005, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="lignqu_txt", x=1096.95, y=188.29999999999995, kx=0, ky=0, cx=1, cy=1, z=19, text={x=970,y=128, w=85, h=30,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="zhenxing_img", x=769.45, y=560.4, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="zhenxing_img", isArmature=0}} },
           {type="b", name="zuoce_bg", x=108.85, y=582.15, kx=0, ky=0, cx=5.51, cy=11.86, z=21, d={{name="youxia_panel", isArmature=0}} },
           {type="b", name="render1", x=118.3, y=573.15, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="render", isArmature=1}} },
           {type="b", name="render2", x=118.3, y=451.15, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="render", isArmature=1}} },
           {type="b", name="logo", x=447.8, y=653.65, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="grid1", x=920.8, y=559.15, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="grid", isArmature=1}} },
           {type="b", name="grid2", x=924.8, y=506.15, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="grid", isArmature=1}} },
           {type="b", name="grid3", x=928.8, y=451.15, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="grid", isArmature=1}} },
           {type="b", name="grid4", x=867.8, y=556.15, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="grid", isArmature=1}} },
           {type="b", name="grid5", x=867.8, y=507.15, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="grid", isArmature=1}} },
           {type="b", name="grid6", x=867.8, y=451.15, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="grid", isArmature=1}} },
           {type="b", name="grid7", x=812.8, y=556.15, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="grid", isArmature=1}} },
           {type="b", name="grid8", x=805.8, y=507.15, kx=0, ky=0, cx=1, cy=1, z=32, d={{name="grid", isArmature=1}} },
           {type="b", name="grid9", x=802.8, y=450.15, kx=0, ky=0, cx=1, cy=1, z=33, d={{name="grid", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1098.8, y=683.15, kx=0, ky=0, cx=1, cy=1, z=34, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="common_copy_ask_button", x=1038.8, y=679.5, kx=0, ky=0, cx=1, cy=1, z=35, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="render", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=55, cy=28.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="panel", x=0, y=0, kx=0, ky=0, cx=2.2, cy=1.15, z=1, d={{name="youce_panel", isArmature=0}} },
           {type="b", name="pic_bg", x=4.35, y=-0.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonGrids/common_grid", isArmature=0}} },
           {type="b", name="zhenfa_txt", x=107, y=-68, kx=0, ky=0, cx=1, cy=1, z=3, text={x=106,y=-68, w=116, h=36,lineType="single line",size=20,color="512116",alignment="left",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="unactivate", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="unactivate", isArmature=0}} },
           {type="b", name="frame", x=0, y=0, kx=0, ky=0, cx=4.67, cy=2.4, z=5, d={{name="frame", isArmature=0}} }
         }
      },
    {type="armature", name="grid", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="box", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_ask_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="zhenfa_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dibu_panel", sc=1, dl=0, f={
                {x=77.8, y=657.65, kx=0, ky=0, cx=0.95, cy=0.95, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youce_panel", sc=1, dl=0, f={
                {x=357.3, y=583.65, kx=0, ky=0, cx=7.57, cy=5.13, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youshang_panel", sc=1, dl=0, f={
                {x=374.3, y=566.65, kx=0, ky=0, cx=21.24, cy=5.26, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youzhong_panel", sc=1, dl=0, f={
                {x=372.8, y=378.15, kx=0, ky=0, cx=16.81, cy=3.09, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dark1_bg", sc=1, dl=0, f={
                {x=372.3, y=378.65, kx=0, ky=0, cx=16.43, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youxia_panel", sc=1, dl=0, f={
                {x=372.8, y=236.2, kx=0, ky=0, cx=16.84, cy=3.47, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dark2_bg", sc=1, dl=0, f={
                {x=372.3, y=237.65, kx=0, ky=0, cx=16.43, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_txt", sc=1, dl=0, f={
                {x=400.95, y=510, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiacheng_txt", sc=1, dl=0, f={
                {x=384.95, y=391, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jihuo_txt", sc=1, dl=0, f={
                {x=705.95, y=538, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="manji_txt", sc=1, dl=0, f={
                {x=648.95, y=422, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dangqian_txt", sc=1, dl=0, f={
                {x=493.95, y=345.4, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xiaji_txt", sc=1, dl=0, f={
                {x=493.95, y=305.4, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jihuozhenfa_txt", sc=1, dl=0, f={
                {x=384.95, y=248.05, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_txt", sc=1, dl=0, f={
                {x=824.95, y=196.04999999999995, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="daoju_img", sc=1, dl=0, f={
                {x=549.95, y=152.04999999999995, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinbi_img", sc=1, dl=0, f={
                {x=655.95, y=150.04999999999995, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_button", sc=1, dl=0, f={
                {x=945.95, y=169.20000000000005, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lignqu_txt", sc=1, dl=0, f={
                {x=1096.95, y=188.29999999999995, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenxing_img", sc=1, dl=0, f={
                {x=769.45, y=560.4, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zuoce_bg", sc=1, dl=0, f={
                {x=108.85, y=582.15, kx=0, ky=0, cx=5.51, cy=11.86, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render1", sc=1, dl=0, f={
                {x=118.3, y=573.15, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render2", sc=1, dl=0, f={
                {x=118.3, y=451.15, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="logo", sc=1, dl=0, f={
                {x=447.8, y=653.65, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid1", sc=1, dl=0, f={
                {x=920.8, y=559.15, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid2", sc=1, dl=0, f={
                {x=924.8, y=506.15, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid3", sc=1, dl=0, f={
                {x=928.8, y=451.15, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid4", sc=1, dl=0, f={
                {x=867.8, y=556.15, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid5", sc=1, dl=0, f={
                {x=867.8, y=507.15, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid6", sc=1, dl=0, f={
                {x=867.8, y=451.15, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid7", sc=1, dl=0, f={
                {x=812.8, y=556.15, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid8", sc=1, dl=0, f={
                {x=805.8, y=507.15, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid9", sc=1, dl=0, f={
                {x=802.8, y=450.15, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1098.8, y=683.15, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1038.8, y=679.5, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=55, cy=28.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=2.2, cy=1.15, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pic_bg", sc=1, dl=0, f={
                {x=4.35, y=-0.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_txt", sc=1, dl=0, f={
                {x=107, y=-68, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="unactivate", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="frame", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=4.67, cy=2.4, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="grid", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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