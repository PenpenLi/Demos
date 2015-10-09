local conf = {type="skeleton", name="operate_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=11, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="main", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_1", x=76.8, y=682.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=461.3, y=649.65, kx=0, ky=0, cx=8.8, cy=7.23, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1162.75, y=705.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="moji4", x=778.95, y=597.15, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="moji_bg", isArmature=0}} },
           {type="b", name="moji3", x=477.95, y=596.15, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="moji_bg", isArmature=0}} },
           {type="b", name="moji2", x=778.95, y=637.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="moji_bg", isArmature=0}} },
           {type="b", name="moji1", x=477.95, y=636.15, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="moji_bg", isArmature=0}} },
           {type="b", name="common_copy_blue_progress_bar", x=133.3, y=188.04999999999995, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonProgressBar/common_copy_blue_progress_bar", isArmature=1}} },
           {type="b", name="levelText", x=344, y=609, kx=0, ky=0, cx=1, cy=1, z=9, text={x=344,y=600, w=103, h=39,lineType="single line",size=26,color="ffcc01",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="privilegeText", x=870, y=608.95, kx=0, ky=0, cx=1, cy=1, z=10, text={x=870,y=600, w=111, h=34,lineType="single line",size=22,color="fff4e5",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="privilegeText_desc", x=806, y=609.95, kx=0, ky=0, cx=1, cy=1, z=11, text={x=804,y=600, w=81, h=34,lineType="single line",size=22,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="IDText", x=807, y=571.95, kx=0, ky=0, cx=1, cy=1, z=12, text={x=849,y=561, w=187, h=34,lineType="single line",size=22,color="fff4e5",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="IDText_desc", x=790, y=571.95, kx=0, ky=0, cx=1, cy=1, z=13, text={x=804,y=561, w=57, h=34,lineType="single line",size=22,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="guanzhiText", x=559, y=573, kx=0, ky=0, cx=1, cy=1, z=14, text={x=567,y=561, w=179, h=34,lineType="single line",size=22,color="fff4e5",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="guanzhiText_desc", x=493, y=573, kx=0, ky=0, cx=1, cy=1, z=15, text={x=501,y=561, w=75, h=34,lineType="single line",size=22,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangpaiText", x=569, y=603.95, kx=0, ky=0, cx=1, cy=1, z=16, text={x=567,y=600, w=178, h=34,lineType="single line",size=22,color="fff4e5",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangpaiText_desc", x=503, y=603.95, kx=0, ky=0, cx=1, cy=1, z=17, text={x=501,y=600, w=71, h=34,lineType="single line",size=22,color="ffc000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="userNameText", x=170.05, y=615, kx=0, ky=0, cx=1, cy=1, z=18, text={x=159,y=600, w=173, h=39,lineType="single line",size=26,color="fff4e5",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shezhi", x=1085.9, y=640, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="shezhi", isArmature=0}} },
           {type="b", name="exp_descb", x=298, y=430, kx=0, ky=0, cx=1, cy=1, z=20, text={x=140,y=152, w=281, h=36,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huanhuaButton", x=279, y=139.04999999999995, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="changeNameButton", x=139, y=139.04999999999995, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="render1", x=471.9, y=549.65, kx=0, ky=0, cx=6.35, cy=1, z=23, d={{name="scaleBg", isArmature=0}} },
           {type="b", name="render2", x=471.9, y=426.65, kx=0, ky=0, cx=6.35, cy=1, z=24, d={{name="scaleBg", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBar/common_copy_blue_progress_bar", 
      bones={           
           {type="b", name="common_blue_progress_bar_bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBar/common_copy_blue_progress_bar_bg", isArmature=0}} },
           {type="b", name="common_blue_progress_bar_fg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBar/common_copy_blue_progress_bar_fg", isArmature=0}} }
         }
      },
    {type="armature", name="render", 
      bones={           
           {type="b", name="hit_area", x=0, y=118, kx=0, ky=0, cx=174.75, cy=29.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="scaleBg", x=0, y=114.65, kx=0, ky=0, cx=6.35, cy=1, z=1, d={{name="scaleBg", isArmature=0}} },
           {type="b", name="meihua_bg", x=483.95, y=117, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="meihua_bg", isArmature=0}} },
           {type="b", name="function_descb", x=325, y=78.95, kx=0, ky=0, cx=1, cy=1, z=3, text={x=123,y=7, w=406, h=65,lineType="multiline",size=20,color="000000",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="titleText", x=184.05, y=93.6, kx=0, ky=0, cx=1, cy=1, z=4, text={x=123,y=70, w=267, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="goButton", x=540, y=85.3, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="setting_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="returnLoginButton", x=967.45, y=450.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="setting/returnLoginButton", isArmature=0}} },
           {type="b", name="guanwang_bg", x=809.45, y=465, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="guanwang_bg", isArmature=0}} },
           {type="b", name="weixin_bg", x=485.45, y=450.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="setting/weixin_bg", isArmature=0}} },
           {type="b", name="weibo_bg", x=650.45, y=449.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="setting/weibo_bg", isArmature=0}} },
           {type="b", name="soundButton", x=327.85, y=451.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="setting/soundButton", isArmature=0}} },
           {type="b", name="gmButton", x=165.85, y=453.55, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="setting/gmButton", isArmature=0}} },
           {type="b", name="fobbidenButton", x=330.85, y=440.2, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="setting/fobbidenButton", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="main", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_1", sc=1, dl=0, f={
                {x=76.8, y=682.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=461.3, y=649.65, kx=0, ky=0, cx=8.8, cy=7.23, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1162.75, y=705.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="moji4", sc=1, dl=0, f={
                {x=778.95, y=597.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="moji3", sc=1, dl=0, f={
                {x=477.95, y=596.15, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="moji2", sc=1, dl=0, f={
                {x=778.95, y=637.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="moji1", sc=1, dl=0, f={
                {x=477.95, y=636.15, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_progress_bar", sc=1, dl=0, f={
                {x=133.3, y=188.04999999999995, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelText", sc=1, dl=0, f={
                {x=344, y=609, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="privilegeText", sc=1, dl=0, f={
                {x=870, y=608.95, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="privilegeText_desc", sc=1, dl=0, f={
                {x=806, y=609.95, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="IDText", sc=1, dl=0, f={
                {x=807, y=571.95, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="IDText_desc", sc=1, dl=0, f={
                {x=790, y=571.95, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanzhiText", sc=1, dl=0, f={
                {x=559, y=573, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanzhiText_desc", sc=1, dl=0, f={
                {x=493, y=573, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpaiText", sc=1, dl=0, f={
                {x=569, y=603.95, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpaiText_desc", sc=1, dl=0, f={
                {x=503, y=603.95, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="userNameText", sc=1, dl=0, f={
                {x=170.05, y=615, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shezhi", sc=1, dl=0, f={
                {x=1085.9, y=640, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_descb", sc=1, dl=0, f={
                {x=298, y=430, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huanhuaButton", sc=1, dl=0, f={
                {x=279, y=139.04999999999995, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="changeNameButton", sc=1, dl=0, f={
                {x=139, y=139.04999999999995, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render1", sc=1, dl=0, f={
                {x=471.9, y=549.65, kx=0, ky=0, cx=6.35, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render2", sc=1, dl=0, f={
                {x=471.9, y=426.65, kx=0, ky=0, cx=6.35, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBar/common_copy_blue_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_progress_bar_bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_progress_bar_fg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=118, kx=0, ky=0, cx=174.75, cy=29.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scaleBg", sc=1, dl=0, f={
                {x=0, y=114.65, kx=0, ky=0, cx=6.35, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meihua_bg", sc=1, dl=0, f={
                {x=483.95, y=117, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="function_descb", sc=1, dl=0, f={
                {x=325, y=78.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleText", sc=1, dl=0, f={
                {x=184.05, y=93.6, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="goButton", sc=1, dl=0, f={
                {x=540, y=85.3, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="setting_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="returnLoginButton", sc=1, dl=0, f={
                {x=967.45, y=450.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanwang_bg", sc=1, dl=0, f={
                {x=809.45, y=465, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weixin_bg", sc=1, dl=0, f={
                {x=485.45, y=450.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weibo_bg", sc=1, dl=0, f={
                {x=650.45, y=449.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="soundButton", sc=1, dl=0, f={
                {x=327.85, y=451.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gmButton", sc=1, dl=0, f={
                {x=165.85, y=453.55, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fobbidenButton", sc=1, dl=0, f={
                {x=330.85, y=440.2, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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