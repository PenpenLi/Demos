local conf = {type="skeleton", name="shop_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="batchBuy_ui", 
      bones={           
           {type="b", name="hit_area", x=-0.65, y=363, kx=0, ky=0, cx=138, cy=91, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_4", x=10, y=343, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=41.5, y=301.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="common_close_button", x=474, y=363.3, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="itemName_txt", x=411, y=212.65, kx=0, ky=0, cx=1, cy=1, z=4, text={x=188,y=235, w=208, h=39,lineType="single line",size=26,color="00fffc",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="common_copy_scale_bg", x=240.85, y=219.35, kx=0, ky=0, cx=5.48, cy=2.29, z=5, d={{name="commonBackgrounds/common_copy_scale_bg", isArmature=0}} },
           {type="b", name="itemName_descb", x=331, y=212.65, kx=0, ky=0, cx=1, cy=1, z=6, text={x=103,y=235, w=86, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="itemCount_txt", x=495, y=151.65, kx=0, ky=0, cx=1, cy=1, z=7, text={x=277,y=172, w=60, h=39,lineType="single line",size=26,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="itemCount_descb", x=331, y=150.65, kx=0, ky=0, cx=1, cy=1, z=8, text={x=103,y=173, w=86, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="itemPrice_txt", x=463, y=86.65000000000003, kx=0, ky=0, cx=1, cy=1, z=9, text={x=248,y=110, w=131, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="itemPrice_descb", x=331, y=87.65000000000003, kx=0, ky=0, cx=1, cy=1, z=10, text={x=103,y=110, w=86, h=39,lineType="single line",size=26,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="add_button_bg", x=386.5, y=214.95, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="add_button_bg", isArmature=0}} },
           {type="b", name="sub_button_bg", x=187.5, y=214.95, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="sub_button_bg", isArmature=0}} },
           {type="b", name="buy_button", x=208, y=73.44999999999999, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_page_button", 
      bones={           
           {type="b", name="common_page_button", x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_page_button_normal", isArmature=0},{name="commonButtons/common_copy_page_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="shop_resource", 
      bones={           
           {type="b", name="hit_area", x=-12, y=231.35, kx=0, ky=0, cx=68.75, cy=53.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="sellout", x=-21.4, y=247.7, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="sellout", isArmature=0}} }
         }
      },
    {type="armature", name="shop_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="shop_bg", x=53.95, y=673, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="red", x=281.95, y=637.6, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="red", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1138, y=707, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="world", x=814.95, y=76, kx=0, ky=0, cx=1, cy=1, z=4, text={x=373,y=53, w=463, h=39,lineType="single line",size=26,color="000000",alignment="center",space=0,textType="static"}, d={{name="kongyuanjian", isArmature=0}} },
           {type="b", name="vip", x=1022.95, y=76, kx=0, ky=0, cx=1, cy=1, z=5, text={x=981,y=53, w=156, h=39,lineType="single line",size=26,color="000000",alignment="left",space=0,textType="static"}, d={{name="kongyuanjian", isArmature=0}} },
           {type="b", name="shop_render1", x=327.5, y=609.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="shop_render", isArmature=1}} },
           {type="b", name="shop_render2", x=592.5, y=608.55, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="shop_render", isArmature=1}} },
           {type="b", name="shop_render3", x=327.3, y=371, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="shop_render", isArmature=1}} },
           {type="b", name="channel_2", x=1164.95, y=468.05, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="channel_1", x=1164.95, y=607.05, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="refresh", x=839.95, y=100.5, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} }
         }
      },
    {type="armature", name="shop_render", 
      bones={           
           {type="b", name="hit_area", x=-12, y=0, kx=0, ky=0, cx=68.75, cy=53.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="background", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="background", isArmature=0}} },
           {type="b", name="bottom", x=34, y=-165.45, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="ico", x=47, y=-172.85, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_copy_shengwang_bg", isArmature=0}} },
           {type="b", name="grid", x=78, y=-58, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item_price", x=145.9, y=-195.85, kx=0, ky=0, cx=1, cy=1, z=5, text={x=94,y=-216, w=104, h=39,lineType="single line",size=26,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="kongyuanjian", isArmature=0}} },
           {type="b", name="item_name", x=201, y=-35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=28,y=-48, w=208, h=30,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="static"}, d={{name="kongyuanjian", isArmature=0}} },
           {type="b", name="9zhe", x=4.35, y=-5.3, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="9zhe_img", isArmature=0}} },
           {type="b", name="nobility", x=60, y=-187, kx=0, ky=0, cx=1, cy=1, z=8, text={x=21,y=-200, w=212, h=29,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="static"}, d={{name="kongyuanjian", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=-43, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="batchBuy_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-0.65, y=363, kx=0, ky=0, cx=138, cy=91, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_4", sc=1, dl=0, f={
                {x=10, y=343, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_3", sc=1, dl=0, f={
                {x=41.5, y=301.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=474, y=363.3, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemName_txt", sc=1, dl=0, f={
                {x=411, y=212.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_scale_bg", sc=1, dl=0, f={
                {x=240.85, y=219.35, kx=0, ky=0, cx=5.48, cy=2.29, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemName_descb", sc=1, dl=0, f={
                {x=331, y=212.65, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemCount_txt", sc=1, dl=0, f={
                {x=495, y=151.65, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemCount_descb", sc=1, dl=0, f={
                {x=331, y=150.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemPrice_txt", sc=1, dl=0, f={
                {x=463, y=86.65000000000003, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemPrice_descb", sc=1, dl=0, f={
                {x=331, y=87.65000000000003, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="add_button_bg", sc=1, dl=0, f={
                {x=386.5, y=214.95, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sub_button_bg", sc=1, dl=0, f={
                {x=187.5, y=214.95, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buy_button", sc=1, dl=0, f={
                {x=208, y=73.44999999999999, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_page_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="shop_resource", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-12, y=231.35, kx=0, ky=0, cx=68.75, cy=53.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sellout", sc=1, dl=0, f={
                {x=-21.4, y=247.7, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shop_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_bg", sc=1, dl=0, f={
                {x=53.95, y=673, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red", sc=1, dl=0, f={
                {x=281.95, y=637.6, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1138, y=707, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="world", sc=1, dl=0, f={
                {x=814.95, y=76, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip", sc=1, dl=0, f={
                {x=1022.95, y=76, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_render1", sc=1, dl=0, f={
                {x=327.5, y=609.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_render2", sc=1, dl=0, f={
                {x=592.5, y=608.55, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_render3", sc=1, dl=0, f={
                {x=327.3, y=371, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_2", sc=1, dl=0, f={
                {x=1164.95, y=468.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="channel_1", sc=1, dl=0, f={
                {x=1164.95, y=607.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="refresh", sc=1, dl=0, f={
                {x=839.95, y=100.5, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shop_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-12, y=0, kx=0, ky=0, cx=68.75, cy=53.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bottom", sc=1, dl=0, f={
                {x=34, y=-165.45, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ico", sc=1, dl=0, f={
                {x=47, y=-172.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid", sc=1, dl=0, f={
                {x=78, y=-58, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_price", sc=1, dl=0, f={
                {x=145.9, y=-195.85, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_name", sc=1, dl=0, f={
                {x=201, y=-35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="9zhe", sc=1, dl=0, f={
                {x=4.35, y=-5.3, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nobility", sc=1, dl=0, f={
                {x=60, y=-187, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_small_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
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