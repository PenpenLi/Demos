local conf = {type="skeleton", name="addFriend_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="addFriend_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_hit_area", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_right", x=815.65, y=540.8, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_mozhiFrame_h_right", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid", x=497.65, y=545.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid1", x=687.65, y=543.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_left", x=364.65, y=545.8, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_mozhiFrame_h_left", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_rightf", x=786.7, y=250.75, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_mozhiFrame_h_right", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_midf", x=500.6, y=244.75, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_mid2f", x=652.7, y=244.75, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_mozhiFrame_h_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_h_leftf", x=367.6, y=250.75, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_mozhiFrame_h_left", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_down", x=872.7, y=312.05, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_mozhiFrame_v_down", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid", x=867.7, y=504.8, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid1", x=867.7, y=417, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_downf", x=380.55, y=326.95, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_mozhiFrame_v_down", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid1f", x=380.55, y=446.95, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_mid3f", x=380.55, y=528.45, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_mozhiFrame_v_mid", isArmature=0}} },
           {type="b", name="common_mozhiFrame_v_topf", x=384.55, y=587, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_mozhiFrame_v_top", isArmature=0}} },
           {type="b", name="common_background_5", x=402.65, y=528.45, kx=0, ky=0, cx=2.2, cy=1.33, z=16, d={{name="commonBackgroundScalables/common_copy_background_5", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=841.9, y=561.95, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonButtons/common_copy_close_button", isArmature=1}} },
           {type="b", name="name_text", x=560.15, y=445.95, kx=0, ky=0, cx=1, cy=1, z=18, text={x=438,y=361, w=415, h=104,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_value_text", x=560.15, y=445.95, kx=0, ky=0, cx=1, cy=1, z=19, text={x=554,y=429, w=134, h=36,lineType="single line",size=24,color="0000ff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_blue_button", x=562.8, y=338.55, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_copy_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="addFriend_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_right", sc=1, dl=0, f={
                {x=815.65, y=540.8, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid", sc=1, dl=0, f={
                {x=497.65, y=545.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid1", sc=1, dl=0, f={
                {x=687.65, y=543.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_left", sc=1, dl=0, f={
                {x=364.65, y=545.8, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_rightf", sc=1, dl=0, f={
                {x=786.7, y=250.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_midf", sc=1, dl=0, f={
                {x=500.6, y=244.75, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_mid2f", sc=1, dl=0, f={
                {x=652.7, y=244.75, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_h_leftf", sc=1, dl=0, f={
                {x=367.6, y=250.75, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_down", sc=1, dl=0, f={
                {x=872.7, y=312.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid", sc=1, dl=0, f={
                {x=867.7, y=504.8, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid1", sc=1, dl=0, f={
                {x=867.7, y=417, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_downf", sc=1, dl=0, f={
                {x=380.55, y=326.95, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid1f", sc=1, dl=0, f={
                {x=380.55, y=446.95, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_mid3f", sc=1, dl=0, f={
                {x=380.55, y=528.45, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mozhiFrame_v_topf", sc=1, dl=0, f={
                {x=384.55, y=587, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_5", sc=1, dl=0, f={
                {x=402.65, y=528.45, kx=0, ky=0, cx=2.2, cy=1.33, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=841.9, y=561.95, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_text", sc=1, dl=0, f={
                {x=560.15, y=445.95, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_value_text", sc=1, dl=0, f={
                {x=560.15, y=445.95, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=562.8, y=338.55, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blue_button", sc=1, dl=0, f={
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