local conf = {type="skeleton", name="huiGu_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="huiGu_ui", 
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
           {type="b", name="common_copy_ask_button", x=1061.85, y=688.55, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
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
           {type="b", name="common_background", x=8, y=498, kx=0, ky=0, cx=1.58, cy=4.25, z=1, d={{name="component/common_background", isArmature=0}} },
           {type="b", name="huawen", x=8.35, y=203.2, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/meihuaImg", isArmature=0}} },
           {type="b", name="infoBg", x=71, y=477.75, kx=0, ky=0, cx=3.04, cy=14.07, z=3, d={{name="component/infoBg", isArmature=0}} },
           {type="b", name="common_huigu_button", x=117.35, y=83.19999999999999, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/common_huigu_button", isArmature=1}} },
           {type="b", name="tiTF", x=28, y=465.7, kx=0, ky=0, cx=1, cy=1, z=5, text={x=31,y=213, w=40, h=245,lineType="single line",size=26,color="6f3600",alignment="left",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="msg2", x=84, y=473.9, kx=0, ky=0, cx=1, cy=0.98, z=6, text={x=84,y=131, w=40, h=346,lineType="single line",size=22,color="6f3600",alignment="left",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="msgT2", x=84, y=468.05, kx=0, ky=0, cx=1, cy=0.98, z=7, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="msg1", x=122, y=474.85, kx=0, ky=0, cx=1, cy=0.98, z=8, text={x=123,y=133, w=40, h=346,lineType="single line",size=22,color="6f3600",alignment="left",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="msgT1", x=125.85, y=468.5, kx=0, ky=0, cx=1, cy=0.98, z=9, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="weikai", x=29.35, y=228.05, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/weikai", isArmature=0}} }
         }
      },
    {type="armature", name="component/common_huigu_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="component/common_huigu_button_normal", isArmature=0},{name="component/common_huigu_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="renderFr_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=504, kx=0, ky=0, cx=47.5, cy=125.5, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_item_bg_5", x=0, y=504, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg_5", isArmature=0}} },
           {type="b", name="zjBg", x=13.35, y=506, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/zjBg", isArmature=0}} },
           {type="b", name="battleTF", x=96.5, y=347.7, kx=0, ky=0, cx=1, cy=1, z=3, text={x=94,y=11, w=51, h=369,lineType="single line",size=46,color="893c2c",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="stateTF", x=30.8, y=476.15, kx=0, ky=0, cx=1, cy=1, z=4, text={x=16,y=349, w=57, h=123,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="weikai", x=29.35, y=230.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/weikai", isArmature=0}} }
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
    {type="animation", name="huiGu_ui", 
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
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1061.85, y=688.55, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="common_background", sc=1, dl=0, f={
                {x=8, y=498, kx=0, ky=0, cx=1.58, cy=4.25, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huawen", sc=1, dl=0, f={
                {x=8.35, y=203.2, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="infoBg", sc=1, dl=0, f={
                {x=71, y=477.75, kx=0, ky=0, cx=3.04, cy=14.07, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huigu_button", sc=1, dl=0, f={
                {x=117.35, y=83.19999999999999, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tiTF", sc=1, dl=0, f={
                {x=28, y=465.7, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg2", sc=1, dl=0, f={
                {x=84, y=473.9, kx=0, ky=0, cx=1, cy=0.98, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msgT2", sc=1, dl=0, f={
                {x=84, y=468.05, kx=0, ky=0, cx=1, cy=0.98, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg1", sc=1, dl=0, f={
                {x=122, y=474.85, kx=0, ky=0, cx=1, cy=0.98, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msgT1", sc=1, dl=0, f={
                {x=125.85, y=468.5, kx=0, ky=0, cx=1, cy=0.98, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weikai", sc=1, dl=0, f={
                {x=29.35, y=228.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="component/common_huigu_button", 
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
    {type="animation", name="renderFr_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=504, kx=0, ky=0, cx=47.5, cy=125.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_5", sc=1, dl=0, f={
                {x=0, y=504, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zjBg", sc=1, dl=0, f={
                {x=13.35, y=506, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="battleTF", sc=1, dl=0, f={
                {x=96.5, y=347.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="stateTF", sc=1, dl=0, f={
                {x=30.8, y=476.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weikai", sc=1, dl=0, f={
                {x=29.35, y=230.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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