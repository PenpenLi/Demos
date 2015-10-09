local conf = {type="skeleton", name="skillcard_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="basiclCardUI", 
      bones={           
           {type="b", name="hit_area", x=0, y=416, kx=0, ky=0, cx=86.25, cy=104, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg1", x=0, y=416, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="myBg", isArmature=0}} },
           {type="b", name="bg2", x=0, y=416, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="enemyBg", isArmature=0}} },
           {type="b", name="skillImage", x=95.95, y=125, kx=0, ky=0, cx=1, cy=1, z=3, text={x=93,y=129, w=126, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="mylingxing", x=0, y=415, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="mylingxing", isArmature=0}} },
           {type="b", name="des", x=306.9, y=109.89999999999998, kx=0, ky=0, cx=1, cy=1, z=5, text={x=107,y=47, w=200, h=65,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhenfaBg_1", x=185, y=415, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="zhenfaBg_1", isArmature=0}} },
           {type="b", name="zhenfaBg_2", x=186, y=416, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="zhenfaBg_2", isArmature=0}} },
           {type="b", name="zhenfa", x=237.95, y=343, kx=0, ky=0, cx=1, cy=1, z=8, text={x=235,y=339, w=96, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="type", x=17.95, y=334, kx=0, ky=0, cx=1, cy=1, z=9, text={x=18,y=333, w=126, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="skillName", x=29.95, y=143, kx=0, ky=0, cx=1, cy=1, z=10, text={x=24,y=122, w=126, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="detailSkillCard", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="lock", x=595, y=650, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="lock", isArmature=0}} },
           {type="b", name="dec2", x=1166.9, y=337.9, kx=0, ky=0, cx=1, cy=1, z=2, text={x=747,y=255, w=425, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="dec1", x=585.95, y=300.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=586,y=298, w=150, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="cardRange2", x=751.95, y=365, kx=0, ky=0, cx=1, cy=1, z=4, text={x=751,y=363, w=350, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="cardRange1", x=585.95, y=365.05, kx=0, ky=0, cx=1, cy=1, z=5, text={x=586,y=363, w=150, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="toWhom2", x=751.95, y=427, kx=0, ky=0, cx=1, cy=1, z=6, text={x=751,y=425, w=350, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="toWhom1", x=585.95, y=427.05, kx=0, ky=0, cx=1, cy=1, z=7, text={x=586,y=425, w=150, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="cardType2", x=751.95, y=487, kx=0, ky=0, cx=1, cy=1, z=8, text={x=751,y=485, w=350, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="cardType1", x=585.95, y=487.05, kx=0, ky=0, cx=1, cy=1, z=9, text={x=586,y=485, w=150, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="zhenfaImage", x=751.95, y=100, kx=0, ky=0, cx=1, cy=1, z=10, text={x=751,y=98, w=197, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="nullPoint", isArmature=0}} },
           {type="b", name="common_copy_blue_button", x=543.8, y=130, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="skillcard_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=55, y=676, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=90, y=645, kx=0, ky=0, cx=12.8, cy=7.26, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="tab_btn_2", x=1165, y=492, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tab_btn_1", x=1165, y=627, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="close_btn", x=1135, y=697, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="pageText", x=610, y=72.04999999999995, kx=0, ky=0, cx=1, cy=1, z=6, text={x=554,y=56, w=114, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="typeUI", 
      bones={           
           {type="b", name="type_3", x=227, y=63, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="type_3", isArmature=0}} },
           {type="b", name="type_2", x=133.85, y=71, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="type_2", isArmature=0}} },
           {type="b", name="type_1", x=27.35, y=62.14999999999998, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="type_1", isArmature=0}} },
           {type="b", name="zhenfa_4", x=532.95, y=239.45, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="zhenfa_4", isArmature=0}} },
           {type="b", name="zhenfa_3", x=370, y=239.45, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="zhenfa_3", isArmature=0}} },
           {type="b", name="zhenfa_2", x=202, y=239.45, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="zhenfa_2", isArmature=0}} },
           {type="b", name="zhenfa_1", x=0, y=239.45, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="zhenfa_1", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="basiclCardUI", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=416, kx=0, ky=0, cx=86.25, cy=104, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg1", sc=1, dl=0, f={
                {x=0, y=416, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg2", sc=1, dl=0, f={
                {x=0, y=416, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skillImage", sc=1, dl=0, f={
                {x=95.95, y=125, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mylingxing", sc=1, dl=0, f={
                {x=0, y=415, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="des", sc=1, dl=0, f={
                {x=306.9, y=109.89999999999998, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfaBg_1", sc=1, dl=0, f={
                {x=185, y=415, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfaBg_2", sc=1, dl=0, f={
                {x=186, y=416, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa", sc=1, dl=0, f={
                {x=237.95, y=343, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type", sc=1, dl=0, f={
                {x=17.95, y=334, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skillName", sc=1, dl=0, f={
                {x=29.95, y=143, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
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
    {type="animation", name="detailSkillCard", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lock", sc=1, dl=0, f={
                {x=595, y=650, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dec2", sc=1, dl=0, f={
                {x=1166.9, y=337.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dec1", sc=1, dl=0, f={
                {x=585.95, y=300.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cardRange2", sc=1, dl=0, f={
                {x=751.95, y=365, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cardRange1", sc=1, dl=0, f={
                {x=585.95, y=365.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="toWhom2", sc=1, dl=0, f={
                {x=751.95, y=427, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="toWhom1", sc=1, dl=0, f={
                {x=585.95, y=427.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cardType2", sc=1, dl=0, f={
                {x=751.95, y=487, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cardType1", sc=1, dl=0, f={
                {x=585.95, y=487.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfaImage", sc=1, dl=0, f={
                {x=751.95, y=100, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=543.8, y=130, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="skillcard_ui", 
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
                {x=90, y=645, kx=0, ky=0, cx=12.8, cy=7.26, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_2", sc=1, dl=0, f={
                {x=1165, y=492, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="pageText", sc=1, dl=0, f={
                {x=610, y=72.04999999999995, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="typeUI", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="type_3", sc=1, dl=0, f={
                {x=227, y=63, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_2", sc=1, dl=0, f={
                {x=133.85, y=71, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="type_1", sc=1, dl=0, f={
                {x=27.35, y=62.14999999999998, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_4", sc=1, dl=0, f={
                {x=532.95, y=239.45, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_3", sc=1, dl=0, f={
                {x=370, y=239.45, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_2", sc=1, dl=0, f={
                {x=202, y=239.45, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_1", sc=1, dl=0, f={
                {x=0, y=239.45, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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