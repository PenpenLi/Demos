local conf = {type="skeleton", name="qiandao_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=67, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=13, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=162, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=53, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
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
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=10, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="leftrender", 
      bones={           
           {type="b", name="hit_area", x=0, y=530.5500000000001, kx=0, ky=0, cx=46.91, cy=132.48, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="leftbg", x=0.1, y=529.95, kx=0, ky=0, cx=2.29, cy=6.46, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="libaobg", x=2, y=491.55000000000007, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_5", isArmature=0}} },
           {type="b", name="item3", x=41.5, y=182.60000000000008, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=41.5, y=310.55000000000007, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item1", x=41.5, y=438.55000000000007, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="world3_bg", x=50, y=469.75000000000006, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="world3_bg", isArmature=0}} },
           {type="b", name="word3", x=143, y=455.55000000000007, kx=0, ky=0, cx=1, cy=1, z=7, text={x=33,y=439, w=131, h=36,lineType="single line",size=24,color="310000",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="word2_bg", x=0.5, y=526.1, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="word2_bg", isArmature=0}} },
           {type="b", name="word2", x=158, y=504.55000000000007, kx=0, ky=0, cx=1, cy=1, z=9, text={x=3,y=486, w=184, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="qiandao_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=64.8, y=686.95, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="red", x=299.8, y=644.3, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="red", isArmature=0}} },
           {type="b", name="shop_render1", x=398.05, y=560.85, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="shop_render2", x=381.35, y=438.6, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="render", isArmature=1}} },
           {type="b", name="title_bg", x=656.85, y=606.9, kx=0, ky=0, cx=1.18, cy=1.19, z=5, d={{name="title_bg", isArmature=0}} },
           {type="b", name="biaoti_bg", x=572.85, y=665.3, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="world", x=396.95, y=77.04999999999995, kx=0, ky=0, cx=1, cy=1, z=7, text={x=375,y=58, w=520, h=36,lineType="single line",size=24,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="world1", x=729.95, y=588, kx=0, ky=0, cx=1, cy=1, z=8, text={x=674,y=563, w=135, h=39,lineType="multiline",size=26,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1146, y=707, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="render", 
      bones={           
           {type="b", name="hit_area", x=9, y=-12, kx=0, ky=0, cx=175, cy=26.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} }
         }
      },
    {type="armature", name="ui_resource", 
      bones={           
           {type="b", name="hit_area", x=9, y=95.65, kx=0, ky=0, cx=175, cy=26.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="yilingqu_bg", x=79.85, y=97.3, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yilingqu_bg", isArmature=0}} }
         }
      },
    {type="armature", name="vipNumbers", 
      bones={           
           {type="b", name="vip0", x=421.5, y=35.150000000000006, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="number_0", isArmature=0}} },
           {type="b", name="vip9", x=380.5, y=43.150000000000006, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="number_9", isArmature=0}} },
           {type="b", name="vip8", x=341.5, y=48.1, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="number_8", isArmature=0}} },
           {type="b", name="vip7", x=305.5, y=51.1, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="number_7", isArmature=0}} },
           {type="b", name="vip6", x=257.5, y=56.1, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="number_6", isArmature=0}} },
           {type="b", name="vip5", x=218.5, y=56.1, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="number_5", isArmature=0}} },
           {type="b", name="vip4", x=157.5, y=60.1, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="number_4", isArmature=0}} },
           {type="b", name="vip3", x=119.5, y=63.1, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="number_3", isArmature=0}} },
           {type="b", name="vip2", x=63.5, y=68.10000000000001, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="number_2", isArmature=0}} },
           {type="b", name="vip1", x=32.5, y=70.10000000000001, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="number_1", isArmature=0}} }
         }
      },
    {type="armature", name="vipRender", 
      bones={           
           {type="b", name="vipback", x=3, y=88, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="vipback", isArmature=0}} },
           {type="b", name="vipshuangbei", x=34, y=91, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="vipshuangbei", isArmature=0}} },
           {type="b", name="vip", x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="vip", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=67, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=67, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=162, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=-2, y=162, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=162, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_small_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="leftrender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=530.5500000000001, kx=0, ky=0, cx=46.91, cy=132.48, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftbg", sc=1, dl=0, f={
                {x=0.1, y=529.95, kx=0, ky=0, cx=2.29, cy=6.46, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="libaobg", sc=1, dl=0, f={
                {x=2, y=491.55000000000007, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=41.5, y=182.60000000000008, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=41.5, y=310.55000000000007, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=41.5, y=438.55000000000007, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="world3_bg", sc=1, dl=0, f={
                {x=50, y=469.75000000000006, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word3", sc=1, dl=0, f={
                {x=143, y=455.55000000000007, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word2_bg", sc=1, dl=0, f={
                {x=0.5, y=526.1, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word2", sc=1, dl=0, f={
                {x=158, y=504.55000000000007, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="qiandao_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=64.8, y=686.95, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red", sc=1, dl=0, f={
                {x=299.8, y=644.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_render1", sc=1, dl=0, f={
                {x=398.05, y=560.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shop_render2", sc=1, dl=0, f={
                {x=381.35, y=438.6, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=656.85, y=606.9, kx=0, ky=0, cx=1.18, cy=1.19, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="biaoti_bg", sc=1, dl=0, f={
                {x=572.85, y=665.3, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="world", sc=1, dl=0, f={
                {x=396.95, y=77.04999999999995, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="world1", sc=1, dl=0, f={
                {x=729.95, y=588, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1146, y=707, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=9, y=-12, kx=0, ky=0, cx=175, cy=26.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="ui_resource", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=9, y=95.65, kx=0, ky=0, cx=175, cy=26.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yilingqu_bg", sc=1, dl=0, f={
                {x=79.85, y=97.3, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="vipNumbers", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="vip0", sc=1, dl=0, f={
                {x=421.5, y=35.150000000000006, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip9", sc=1, dl=0, f={
                {x=380.5, y=43.150000000000006, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip8", sc=1, dl=0, f={
                {x=341.5, y=48.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip7", sc=1, dl=0, f={
                {x=305.5, y=51.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip6", sc=1, dl=0, f={
                {x=257.5, y=56.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip5", sc=1, dl=0, f={
                {x=218.5, y=56.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip4", sc=1, dl=0, f={
                {x=157.5, y=60.1, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip3", sc=1, dl=0, f={
                {x=119.5, y=63.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip2", sc=1, dl=0, f={
                {x=63.5, y=68.10000000000001, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip1", sc=1, dl=0, f={
                {x=32.5, y=70.10000000000001, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="vipRender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="vipback", sc=1, dl=0, f={
                {x=3, y=88, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipshuangbei", sc=1, dl=0, f={
                {x=34, y=91, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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