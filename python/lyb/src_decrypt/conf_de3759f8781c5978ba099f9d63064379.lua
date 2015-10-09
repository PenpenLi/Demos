local conf = {type="skeleton", name="treasury_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_return_button", 
      bones={           
           {type="b", name="common_return_button", x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_return_button_normal", isArmature=0},{name="commonButtons/common_copy_return_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="render_ui", 
      bones={           
           {type="b", name="bg_m", x=0, y=121, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="component/bg_m", isArmature=0}} },
           {type="b", name="bg_j", x=0, y=121, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/bg_j", isArmature=0}} },
           {type="b", name="lvTF", x=8.85, y=82.15, kx=0, ky=0, cx=1, cy=1, z=2, text={x=13,y=9, w=103, h=60,lineType="single line",size=42,color="563826",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="lv", x=12.85, y=119.15, kx=0, ky=0, cx=1, cy=1, z=3, text={x=11,y=77, w=103, h=34,lineType="single line",size=22,color="382818",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="enable", x=34.5, y=119.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/enableImg", isArmature=0}} }
         }
      },
    {type="armature", name="treasury_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="bgTmp", x=0.85, y=243.35, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_line_down", x=0, y=545, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_line_down", isArmature=0}} },
           {type="b", name="common_copy_line_down_1", x=0, y=245, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_line_down", isArmature=0}} },
           {type="b", name="rBL", x=901, y=442.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/BL", isArmature=0}} },
           {type="b", name="lBL", x=379, y=442.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/BL", isArmature=0}} },
           {type="b", name="dggsBtn", x=394.25, y=425, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/dggsBtn", isArmature=1}} },
           {type="b", name="mfjjBtn", x=901.45, y=425, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/mfjjBtn", isArmature=1}} },
           {type="b", name="leftListTmp", x=379.8, y=370, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="rightListTmp", x=896.75, y=370, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="cost1TF", x=822.8, y=95.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, text={x=764,y=58, w=276, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="costTF", x=317.85, y=94.20000000000005, kx=0, ky=0, cx=1, cy=1, z=11, text={x=268,y=58, w=258, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_small_orange_button", x=343.95, y=165.70000000000005, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_small_orange_button", isArmature=1}} },
           {type="b", name="common_copy_small_orange_button_1", x=845.95, y=168.70000000000005, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_orange_button", isArmature=1}} },
           {type="b", name="CDLTF", x=397.8, y=265.2, kx=0, ky=0, cx=1, cy=1, z=14, text={x=239,y=200, w=315, h=60,lineType="single line",size=42,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="CDRTF", x=899.8, y=264.2, kx=0, ky=0, cx=1, cy=1, z=15, text={x=741,y=202, w=315, h=60,lineType="single line",size=42,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_ask_button", x=1113.8, y=710, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1196.75, y=714.15, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="component/dggsBtn", 
      bones={           
           {type="b", name="common_copy_huaWen2", x=-140.15, y=-94.05, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="common_copy_nameBg", x=113, y=167.2, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_nameBg", isArmature=0}} },
           {type="b", name="dggs_b", x=-170, y=148, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/dggs_b", isArmature=0}} },
           {type="b", name="countTF", x=-2.15, y=-134.85, kx=0, ky=0, cx=1, cy=1, z=3, text={x=-169,y=-141, w=331, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="nameTF", x=132.5, y=110.9, kx=0, ky=0, cx=1, cy=1, z=4, text={x=122,y=-9, w=54, h=171,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="component/mfjjBtn", 
      bones={           
           {type="b", name="common_copy_huaWen2", x=-142.2, y=-99, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="common_copy_nameBg", x=113, y=167.2, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_nameBg", isArmature=0}} },
           {type="b", name="mfjj_b", x=-134, y=170, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/mfjj_b", isArmature=0}} },
           {type="b", name="countTF", x=-2.15, y=-134.85, kx=0, ky=0, cx=1, cy=1, z=3, text={x=-169,y=-145, w=331, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="nameTF", x=127.5, y=125.9, kx=0, ky=0, cx=1, cy=1, z=4, text={x=123,y=-13, w=54, h=171,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_orange_button", 
      bones={           
           {type="b", name="common_small_orange_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=-41, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_orange_button_normal", isArmature=0},{name="commonButtons/common_copy_small_orange_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
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
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_return_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="render_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg_m", sc=1, dl=0, f={
                {x=0, y=121, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_j", sc=1, dl=0, f={
                {x=0, y=121, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lvTF", sc=1, dl=0, f={
                {x=8.85, y=82.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lv", sc=1, dl=0, f={
                {x=12.85, y=119.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="enable", sc=1, dl=0, f={
                {x=34.5, y=119.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="treasury_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bgTmp", sc=1, dl=0, f={
                {x=0.85, y=243.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_down", sc=1, dl=0, f={
                {x=0, y=545, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_down_1", sc=1, dl=0, f={
                {x=0, y=245, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rBL", sc=1, dl=0, f={
                {x=901, y=442.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lBL", sc=1, dl=0, f={
                {x=379, y=442.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dggsBtn", sc=1, dl=0, f={
                {x=394.25, y=425, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mfjjBtn", sc=1, dl=0, f={
                {x=901.45, y=425, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftListTmp", sc=1, dl=0, f={
                {x=379.8, y=370, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rightListTmp", sc=1, dl=0, f={
                {x=896.75, y=370, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost1TF", sc=1, dl=0, f={
                {x=822.8, y=95.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="costTF", sc=1, dl=0, f={
                {x=317.85, y=94.20000000000005, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_small_orange_button", sc=1, dl=0, f={
                {x=343.95, y=165.70000000000005, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_small_orange_button_1", sc=1, dl=0, f={
                {x=845.95, y=168.70000000000005, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="CDLTF", sc=1, dl=0, f={
                {x=397.8, y=265.2, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="CDRTF", sc=1, dl=0, f={
                {x=899.8, y=264.2, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1113.8, y=710, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1196.75, y=714.15, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="component/dggsBtn", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_huaWen2", sc=1, dl=0, f={
                {x=-140.15, y=-94.05, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_nameBg", sc=1, dl=0, f={
                {x=113, y=167.2, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dggs_b", sc=1, dl=0, f={
                {x=-170, y=148, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTF", sc=1, dl=0, f={
                {x=-2.15, y=-134.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nameTF", sc=1, dl=0, f={
                {x=132.5, y=110.9, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="component/mfjjBtn", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_huaWen2", sc=1, dl=0, f={
                {x=-142.2, y=-99, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_nameBg", sc=1, dl=0, f={
                {x=113, y=167.2, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mfjj_b", sc=1, dl=0, f={
                {x=-134, y=170, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTF", sc=1, dl=0, f={
                {x=-2.15, y=-134.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nameTF", sc=1, dl=0, f={
                {x=127.5, y=125.9, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_small_orange_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
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