local conf = {type="skeleton", name="yueka_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="yueka_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="duibi", x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yulan_img", isArmature=0}} },
           {type="b", name="panel", x=184.1, y=625, kx=0, ky=0, cx=0.8, cy=0.8, z=2, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="zuoce_bg", x=220.3, y=593.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="zuoce_img", isArmature=0}} },
           {type="b", name="logo", x=428.8, y=643.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="logo", isArmature=0}} },
           {type="b", name="youshang_panel", x=522.8, y=574.15, kx=0, ky=0, cx=6.01, cy=1.76, z=5, d={{name="panel1", isArmature=0}} },
           {type="b", name="youshang_touming", x=539.8, y=555.65, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="advertise", isArmature=0}} },
           {type="b", name="youxia_touming", x=523.3, y=405, kx=0, ky=0, cx=10.66, cy=6.21, z=7, d={{name="youxia_bg", isArmature=0}} },
           {type="b", name="text_bg1", x=542.8, y=334.5, kx=0, ky=0, cx=13.41, cy=1.1, z=8, d={{name="shuzi", isArmature=0}} },
           {type="b", name="text_bg2", x=542.8, y=290, kx=0, ky=0, cx=13.41, cy=1.1, z=9, d={{name="shuzi", isArmature=0}} },
           {type="b", name="text_bg4", x=542.8, y=377.5, kx=0, ky=0, cx=13.41, cy=1.1, z=10, d={{name="shuzi", isArmature=0}} },
           {type="b", name="redButton", x=694.95, y=220.2, kx=0, ky=0, cx=1.44, cy=1.18, z=11, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0}} },
           {type="b", name="blueButton", x=296.85, y=209.2, kx=0, ky=0, cx=0.95, cy=1, z=12, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="days_txt", x=272, y=566, kx=0, ky=0, cx=1, cy=1, z=13, text={x=272,y=524, w=163, h=42,lineType="single line",size=26,color="ffe58c",alignment="center",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="huode_txt", x=278, y=291.05, kx=0, ky=0, cx=1, cy=1, z=14, text={x=278,y=257, w=159, h=34,lineType="single line",size=22,color="fffed6",alignment="center",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="num_txt", x=267, y=251.05, kx=0, ky=0, cx=1, cy=1, z=15, text={x=340,y=217, w=86, h=34,lineType="single line",size=22,color="fffed6",alignment="center",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="des1_txt", x=499.3, y=348.2, kx=0, ky=0, cx=1, cy=1, z=16, text={x=562,y=344, w=456, h=36,lineType="single line",size=24,color="e6d7bc",alignment="left",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="des2_txt", x=504.3, y=307.2, kx=0, ky=0, cx=1, cy=1, z=17, text={x=563,y=299, w=469, h=36,lineType="single line",size=24,color="e6d7bc",alignment="left",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="des4_txt", x=506.3, y=263.2, kx=0, ky=0, cx=1, cy=1, z=18, text={x=562,y=253, w=471, h=36,lineType="single line",size=24,color="e6d7bc",alignment="left",space=0,textType="input"}, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="gold_img", x=297.35, y=260.2, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="num1_null", x=884.95, y=524, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="num2_null", x=766.95, y=482, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="nullsprite", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1156.8, y=710.15, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="yueka_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="duibi", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel", sc=1, dl=0, f={
                {x=184.1, y=625, kx=0, ky=0, cx=0.8, cy=0.8, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zuoce_bg", sc=1, dl=0, f={
                {x=220.3, y=593.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="logo", sc=1, dl=0, f={
                {x=428.8, y=643.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youshang_panel", sc=1, dl=0, f={
                {x=522.8, y=574.15, kx=0, ky=0, cx=6.01, cy=1.76, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youshang_touming", sc=1, dl=0, f={
                {x=539.8, y=555.65, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youxia_touming", sc=1, dl=0, f={
                {x=523.3, y=405, kx=0, ky=0, cx=10.66, cy=6.21, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg1", sc=1, dl=0, f={
                {x=542.8, y=334.5, kx=0, ky=0, cx=13.41, cy=1.1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg2", sc=1, dl=0, f={
                {x=542.8, y=290, kx=0, ky=0, cx=13.41, cy=1.1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg4", sc=1, dl=0, f={
                {x=542.8, y=377.5, kx=0, ky=0, cx=13.41, cy=1.1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="redButton", sc=1, dl=0, f={
                {x=694.95, y=220.2, kx=0, ky=0, cx=1.44, cy=1.18, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blueButton", sc=1, dl=0, f={
                {x=296.85, y=209.2, kx=0, ky=0, cx=0.95, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="days_txt", sc=1, dl=0, f={
                {x=272, y=566, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huode_txt", sc=1, dl=0, f={
                {x=278, y=291.05, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_txt", sc=1, dl=0, f={
                {x=267, y=251.05, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="des1_txt", sc=1, dl=0, f={
                {x=499.3, y=348.2, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="des2_txt", sc=1, dl=0, f={
                {x=504.3, y=307.2, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="des4_txt", sc=1, dl=0, f={
                {x=506.3, y=263.2, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_img", sc=1, dl=0, f={
                {x=297.35, y=260.2, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num1_null", sc=1, dl=0, f={
                {x=884.95, y=524, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num2_null", sc=1, dl=0, f={
                {x=766.95, y=482, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1156.8, y=710.15, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
      }
  }
}
 return conf;