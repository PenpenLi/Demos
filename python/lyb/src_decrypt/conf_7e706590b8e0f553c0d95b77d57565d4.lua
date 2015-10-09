local conf = {type="skeleton", name="selectServe_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="common_bluelonground_button", 
      bones={           
         }
      },
    {type="armature", name="commonButtons/common_copy_blue2_button", 
      bones={           
           {type="b", name="common_blue2_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=11, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue2_button_normal", isArmature=0},{name="commonButtons/common_copy_blue2_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=158, kx=0, ky=0, cx=1, cy=1, z=0, text={x=16,y=52, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_page_button2", 
      bones={           
           {type="b", name="common_page_button2", x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_page_button_normal2", isArmature=0},{name="commonButtons/common_copy_page_button_down2", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=8,y=-54, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="serverList_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_hit_area", isArmature=0}} },
           {type="b", name="beijing", x=0, y=235, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="beijing", isArmature=0}} },
           {type="b", name="nullSprite", x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="selectServe_server_buttton", x=487.95, y=465.35, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="selectServe_server_buttton", isArmature=1}} },
           {type="b", name="selectServe_server_buttton_normal_1", x=175.45, y=534, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="selectServe_server_buttton_normal", isArmature=0}} },
           {type="b", name="selectServe_server_buttton_normal_2", x=487.95, y=534.35, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="selectServe_server_buttton_normal", isArmature=0}} },
           {type="b", name="selectServe_server_buttton_normal_3", x=172.9, y=463.35, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="selectServe_server_buttton_normal", isArmature=0}} },
           {type="b", name="serverList_state_1", x=433.2, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="serverList_state_1", isArmature=0}} },
           {type="b", name="serverList_state_text_1", x=472.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=8, text={x=469,y=62, w=58, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="serverList_state_2", x=541.1, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="serverList_state_2", isArmature=0}} },
           {type="b", name="serverList_state_text_2", x=529.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, text={x=573,y=62, w=60, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="serverList_state_3", x=646.9, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="serverList_state_3", isArmature=0}} },
           {type="b", name="serverList_state_text_3", x=586.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=12, text={x=678,y=62, w=65, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="serverList_state_4", x=748.8, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="serverList_state_4", isArmature=0}} },
           {type="b", name="serverList_state_text_4", x=643.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=14, text={x=782,y=62, w=61, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="selectServe_state_text", x=241, y=614.05, kx=0, ky=0, cx=1, cy=1, z=15, text={x=395,y=491, w=51, h=31,lineType="single line",size=20,color="00ff00",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="selectServe_long_bg", x=185.8, y=559.65, kx=0, ky=0, cx=43.09, cy=1, z=16, d={{name="selectServe_long_bg", isArmature=0}} },
           {type="b", name="common_tab_button_2", x=412.05, y=604.65, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="selectServe_tab_button", isArmature=1}} },
           {type="b", name="common_tab_button_1", x=219.95, y=604.65, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="selectServe_tab_button", isArmature=1}} },
           {type="b", name="common_copy_title_1", x=425, y=700, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="title_textpic", x=535, y=682, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="title_textpic", isArmature=0}} },
           {type="b", name="newServer", x=484.1, y=534.35, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="newServer", isArmature=0}} },
           {type="b", name="recommend", x=171.95, y=535, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="recommend", isArmature=0}} }
         }
      },
    {type="armature", name="selectServe_server_buttton", 
      bones={           
           {type="b", name="selectServe_server_buttton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=50,y=-50, w=201, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="selectServe_server_buttton_normal", isArmature=0},{name="selectServe_server_buttton_down", isArmature=0}} }
         }
      },
    {type="armature", name="selectServe_tab_button", 
      bones={           
           {type="b", name="selectServe_tab_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=2,y=-44, w=170, h=36,lineType="single line",size=24,color="fa8d18",alignment="center",space=0,textType="static"}, d={{name="selectServe_tab_button_normal", isArmature=0},{name="selectServe_tab_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="serverLogin_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_hit_area", isArmature=0}} },
           {type="b", name="login_server_bg", x=628.5, y=321, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_input_bg", isArmature=0}} },
           {type="b", name="login_select_button", x=1098.5, y=292, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="login_select_button", isArmature=1}} },
           {type="b", name="login_server_text", x=682.05, y=294.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=681,y=246, w=209, h=47,lineType="single line",size=32,color="000000",alignment="right",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="login_state_text", x=1004.95, y=275.5, kx=0, ky=0, cx=1, cy=1, z=4, text={x=919,y=245, w=111, h=47,lineType="single line",size=32,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_button_bg", isArmature=0}} },
           {type="b", name="back_button", x=30, y=105, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_big_blue_button", x=777, y=170, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_big_blue_button", isArmature=1}} },
           {type="b", name="common_copy_begin_game", x=830.5, y=140, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_begin_game", isArmature=0}} }
         }
      },
    {type="armature", name="login_select_button", 
      bones={           
           {type="b", name="login_select_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="login_select_button_normal", isArmature=0},{name="login_select_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_big_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_big_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_big_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="common_bluelonground_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_blue2_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue2_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue2_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue2_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_channel_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=158, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=158, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=158, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_page_button2", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="serverList_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="beijing", sc=1, dl=0, f={
                {x=0, y=235, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nullSprite", sc=1, dl=0, f={
                {x=0, y=715, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_server_buttton", sc=1, dl=0, f={
                {x=487.95, y=465.35, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_server_buttton_normal_1", sc=1, dl=0, f={
                {x=175.45, y=534, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_server_buttton_normal_2", sc=1, dl=0, f={
                {x=487.95, y=534.35, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_server_buttton_normal_3", sc=1, dl=0, f={
                {x=172.9, y=463.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_1", sc=1, dl=0, f={
                {x=433.2, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_text_1", sc=1, dl=0, f={
                {x=472.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_2", sc=1, dl=0, f={
                {x=541.1, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_text_2", sc=1, dl=0, f={
                {x=529.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_3", sc=1, dl=0, f={
                {x=646.9, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_text_3", sc=1, dl=0, f={
                {x=586.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_4", sc=1, dl=0, f={
                {x=748.8, y=97.64999999999998, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="serverList_state_text_4", sc=1, dl=0, f={
                {x=643.1, y=90.04999999999995, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_state_text", sc=1, dl=0, f={
                {x=241, y=614.05, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectServe_long_bg", sc=1, dl=0, f={
                {x=185.8, y=559.65, kx=0, ky=0, cx=43.09, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_tab_button_2", sc=1, dl=0, f={
                {x=412.05, y=604.65, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_tab_button_1", sc=1, dl=0, f={
                {x=219.95, y=604.65, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_title_1", sc=1, dl=0, f={
                {x=425, y=700, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_textpic", sc=1, dl=0, f={
                {x=535, y=682, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="newServer", sc=1, dl=0, f={
                {x=484.1, y=534.35, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="recommend", sc=1, dl=0, f={
                {x=171.95, y=535, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="selectServe_server_buttton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_server_buttton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_server_buttton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_server_buttton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="selectServe_tab_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="selectServe_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="serverLogin_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="login_server_bg", sc=1, dl=0, f={
                {x=628.5, y=321, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="login_select_button", sc=1, dl=0, f={
                {x=1098.5, y=292, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="login_server_text", sc=1, dl=0, f={
                {x=682.05, y=294.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="login_state_text", sc=1, dl=0, f={
                {x=1004.95, y=275.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="back_button", sc=1, dl=0, f={
                {x=30, y=105, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_big_blue_button", sc=1, dl=0, f={
                {x=777, y=170, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_begin_game", sc=1, dl=0, f={
                {x=830.5, y=140, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="login_select_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="login_select_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="login_select_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="login_select_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
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
    {type="animation", name="commonButtons/common_big_blue_button", 
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
      }
  }
}
 return conf;