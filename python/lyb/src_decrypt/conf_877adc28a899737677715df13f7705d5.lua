local conf = {type="skeleton", name="fiveElements_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="fiveElements_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_1", x=75.8, y=673.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=115.95, y=584.6, kx=0, ky=0, cx=12.89, cy=6.24, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="itemTmp", x=136.85, y=72.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="ttl_bg", x=91, y=659.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/ttlBg", isArmature=0}} },
           {type="b", name="ttl_bg_1", x=381.95, y=660.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/ttlBg", isArmature=0}} },
           {type="b", name="ttl_bg_2", x=717.95, y=659.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/ttlBg", isArmature=0}} },
           {type="b", name="common_copy_biaoti", x=479.8, y=649.65, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="ttlTF", x=565.8, y=604.15, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="countTF", x=144.85, y=644.15, kx=0, ky=0, cx=1, cy=1, z=9, text={x=148,y=613, w=135, h=36,lineType="single line",size=24,color="ffffff",alignment="right",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="countTmp", x=279.8, y=612.2, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_small_blue_button", x=325, y=656.15, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_copy_ask_button", x=1061.85, y=688.55, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="renderBl_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=502, kx=0, ky=0, cx=47.5, cy=125.5, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=502, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/battle_bg", isArmature=0}} },
           {type="b", name="common_copy_small_blue_button", x=27.85, y=99.75, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_copy_tili_bg", x=23, y=162.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="tiTF", x=85.85, y=157.2, kx=0, ky=0, cx=1, cy=1, z=4, text={x=88,y=115, w=69, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="ttlTF", x=17.85, y=188.15, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="itemTmp", x=72.8, y=180.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="easy", x=0.3, y=496, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/easy", isArmature=0}} },
           {type="b", name="hard", x=0.35, y=496, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/hard", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="renderFr_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=502.05, kx=0, ky=0, cx=47.5, cy=125.5, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_item_bg_5", x=0, y=502.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg_5", isArmature=0}} },
           {type="b", name="sx_2", x=15.85, y=471.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/jin", isArmature=0}} },
           {type="b", name="sx_3", x=15.85, y=474.7, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/mu", isArmature=0}} },
           {type="b", name="sx_4", x=15.85, y=473.7, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/shui", isArmature=0}} },
           {type="b", name="sx_5", x=15.85, y=474.7, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/huo", isArmature=0}} },
           {type="b", name="sx_6", x=14.85, y=473.7, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/tu", isArmature=0}} },
           {type="b", name="common_copy_huaWenImg", x=13, y=342.45000000000005, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_huaWenImg", isArmature=0}} },
           {type="b", name="common_copy_shuxing_2", x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_shuxing_2", isArmature=0}} },
           {type="b", name="common_copy_shuxing_3", x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_shuxing_3", isArmature=0}} },
           {type="b", name="common_copy_shuxing_4", x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_shuxing_4", isArmature=0}} },
           {type="b", name="common_copy_shuxing_5", x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_shuxing_5", isArmature=0}} },
           {type="b", name="common_copy_shuxing_6", x=19.8, y=331.20000000000005, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_shuxing_6", isArmature=0}} },
           {type="b", name="common_copy_shuxing_2_1", x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_shuxing_2", isArmature=0}} },
           {type="b", name="common_copy_shuxing_3_1", x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_shuxing_3", isArmature=0}} },
           {type="b", name="common_copy_shuxing_4_1", x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_shuxing_4", isArmature=0}} },
           {type="b", name="common_copy_shuxing_5_1", x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_copy_shuxing_5", isArmature=0}} },
           {type="b", name="common_copy_shuxing_6_1", x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_copy_shuxing_6", isArmature=0}} },
           {type="b", name="common_copy_shuxing_2_2", x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonImages/common_copy_shuxing_2", isArmature=0}} },
           {type="b", name="common_copy_shuxing_3_2", x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonImages/common_copy_shuxing_3", isArmature=0}} },
           {type="b", name="common_copy_shuxing_4_2", x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="commonImages/common_copy_shuxing_4", isArmature=0}} },
           {type="b", name="common_copy_shuxing_5_2", x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonImages/common_copy_shuxing_5", isArmature=0}} },
           {type="b", name="common_copy_shuxing_6_2", x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonImages/common_copy_shuxing_6", isArmature=0}} },
           {type="b", name="restrainTF", x=16.85, y=98.25, kx=0, ky=0, cx=1, cy=1, z=23, text={x=17,y=65, w=85, h=31,lineType="single line",size=20,color="3a2915",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="battleTF", x=18.85, y=162.2, kx=0, ky=0, cx=1, cy=1, z=24, text={x=17,y=130, w=85, h=31,lineType="single line",size=20,color="31291c",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="stateTF", x=138.8, y=477.2, kx=0, ky=0, cx=1, cy=1, z=25, text={x=140,y=365, w=25, h=110,lineType="single line",size=20,color="000000",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="enableImg", x=0.3, y=502.1, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="component/enableImg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="fiveElements_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_1", sc=1, dl=0, f={
                {x=75.8, y=673.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=115.95, y=584.6, kx=0, ky=0, cx=12.89, cy=6.24, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=136.85, y=72.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttl_bg", sc=1, dl=0, f={
                {x=91, y=659.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttl_bg_1", sc=1, dl=0, f={
                {x=381.95, y=660.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttl_bg_2", sc=1, dl=0, f={
                {x=717.95, y=659.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti", sc=1, dl=0, f={
                {x=479.8, y=649.65, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlTF", sc=1, dl=0, f={
                {x=565.8, y=604.15, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTF", sc=1, dl=0, f={
                {x=144.85, y=644.15, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTmp", sc=1, dl=0, f={
                {x=279.8, y=612.2, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_small_blue_button", sc=1, dl=0, f={
                {x=325, y=656.15, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1061.85, y=688.55, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="renderBl_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=502, kx=0, ky=0, cx=47.5, cy=125.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=502, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_small_blue_button", sc=1, dl=0, f={
                {x=27.85, y=99.75, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_tili_bg", sc=1, dl=0, f={
                {x=23, y=162.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tiTF", sc=1, dl=0, f={
                {x=85.85, y=157.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlTF", sc=1, dl=0, f={
                {x=17.85, y=188.15, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=72.8, y=180.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="easy", sc=1, dl=0, f={
                {x=0.3, y=496, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hard", sc=1, dl=0, f={
                {x=0.35, y=496, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="renderFr_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=502.05, kx=0, ky=0, cx=47.5, cy=125.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_5", sc=1, dl=0, f={
                {x=0, y=502.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sx_2", sc=1, dl=0, f={
                {x=15.85, y=471.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sx_3", sc=1, dl=0, f={
                {x=15.85, y=474.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sx_4", sc=1, dl=0, f={
                {x=15.85, y=473.7, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sx_5", sc=1, dl=0, f={
                {x=15.85, y=474.7, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sx_6", sc=1, dl=0, f={
                {x=14.85, y=473.7, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_huaWenImg", sc=1, dl=0, f={
                {x=13, y=342.45000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_2", sc=1, dl=0, f={
                {x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_3", sc=1, dl=0, f={
                {x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_4", sc=1, dl=0, f={
                {x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_5", sc=1, dl=0, f={
                {x=18.8, y=330.20000000000005, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_6", sc=1, dl=0, f={
                {x=19.8, y=331.20000000000005, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_2_1", sc=1, dl=0, f={
                {x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_3_1", sc=1, dl=0, f={
                {x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_4_1", sc=1, dl=0, f={
                {x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_5_1", sc=1, dl=0, f={
                {x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_6_1", sc=1, dl=0, f={
                {x=105.8, y=144.2, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_2_2", sc=1, dl=0, f={
                {x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_3_2", sc=1, dl=0, f={
                {x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_4_2", sc=1, dl=0, f={
                {x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_5_2", sc=1, dl=0, f={
                {x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_shuxing_6_2", sc=1, dl=0, f={
                {x=105.8, y=177.2, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="restrainTF", sc=1, dl=0, f={
                {x=16.85, y=98.25, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="battleTF", sc=1, dl=0, f={
                {x=18.85, y=162.2, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="stateTF", sc=1, dl=0, f={
                {x=138.8, y=477.2, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="enableImg", sc=1, dl=0, f={
                {x=0.3, y=502.1, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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