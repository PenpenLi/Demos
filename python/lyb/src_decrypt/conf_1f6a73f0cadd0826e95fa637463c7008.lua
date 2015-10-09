local conf = {type="skeleton", name="guanzhi_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_small_orange_button", 
      bones={           
           {type="b", name="common_small_orange_button", x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=4, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_orange_button_normal", isArmature=0},{name="commonButtons/common_copy_small_orange_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="guanzhi_card", 
      bones={           
           {type="b", name="hit_area", x=0, y=486, kx=0, ky=0, cx=46, cy=121.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=486, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg_5", isArmature=0}} },
           {type="b", name="name_descb", x=41, y=386.05, kx=0, ky=0, cx=1, cy=1, z=2, text={x=22,y=66, w=66, h=355,lineType="multiline",size=60,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="container", isArmature=0}} },
           {type="b", name="pos_descb", x=156.05, y=418.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=133,y=294, w=35, h=169,lineType="multiline",size=30,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="container", isArmature=0}} },
           {type="b", name="buff_descb", x=68.05, y=198.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=23,y=65, w=174, h=184,lineType="single line",size=26,color="901d02",alignment="left",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="premise_descb", x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=5, text={x=14,y=91, w=120, h=36,lineType="single line",size=24,color="57290f",alignment="left",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="premise_descb_1", x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=6, text={x=17,y=91, w=150, h=36,lineType="single line",size=24,color="57290f",alignment="center",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="shengwang_descb", x=110.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=7, text={x=98,y=92, w=92, h=36,lineType="single line",size=24,color="ac5100",alignment="left",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="count", x=68.05, y=129.05, kx=0, ky=0, cx=1, cy=1, z=8, text={x=0,y=116, w=190, h=36,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="kaiqi_descb", x=68.05, y=157.05, kx=0, ky=0, cx=1, cy=1, z=9, text={x=-4,y=140, w=190, h=34,lineType="single line",size=22,color="ff00ff",alignment="center",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="yihuode_descb", x=68.05, y=111.05, kx=0, ky=0, cx=1, cy=1, z=10, text={x=-3,y=31, w=190, h=44,lineType="single line",size=30,color="67190e",alignment="center",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="button", x=26, y=81, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="current_pos", x=-5.5, y=473, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="current_pos", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="guanzhi_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70, y=670, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="图层 3", x=109.5, y=598, kx=0, ky=0, cx=12.93, cy=6.34, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="descb", x=482.1, y=616, kx=0, ky=0, cx=1, cy=1, z=3, text={x=97,y=607, w=1085, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="static"}, d={{name="container", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1090, y=683, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_small_orange_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="guanzhi_card", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=486, kx=0, ky=0, cx=46, cy=121.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=486, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=41, y=386.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pos_descb", sc=1, dl=0, f={
                {x=156.05, y=418.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buff_descb", sc=1, dl=0, f={
                {x=68.05, y=198.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="premise_descb", sc=1, dl=0, f={
                {x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="premise_descb_1", sc=1, dl=0, f={
                {x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengwang_descb", sc=1, dl=0, f={
                {x=110.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="count", sc=1, dl=0, f={
                {x=68.05, y=129.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kaiqi_descb", sc=1, dl=0, f={
                {x=68.05, y=157.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yihuode_descb", sc=1, dl=0, f={
                {x=68.05, y=111.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button", sc=1, dl=0, f={
                {x=26, y=81, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="current_pos", sc=1, dl=0, f={
                {x=-5.5, y=473, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="name_descb", sc=1, dl=0, f={
                {x=41, y=386.05, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pos_descb", sc=1, dl=0, f={
                {x=156.05, y=418.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buff_descb", sc=1, dl=0, f={
                {x=68.05, y=198.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="premise_descb", sc=1, dl=0, f={
                {x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="premise_descb_1", sc=1, dl=0, f={
                {x=69.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengwang_descb", sc=1, dl=0, f={
                {x=110.05, y=101.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="count", sc=1, dl=0, f={
                {x=68.05, y=129.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kaiqi_descb", sc=1, dl=0, f={
                {x=68.05, y=157.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yihuode_descb", sc=1, dl=0, f={
                {x=68.05, y=111.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button", sc=1, dl=0, f={
                {x=26, y=81, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="current_pos", sc=1, dl=0, f={
                {x=-5.5, y=473, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="guanzhi_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70, y=670, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=109.5, y=598, kx=0, ky=0, cx=12.93, cy=6.34, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=482.1, y=616, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1090, y=683, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;