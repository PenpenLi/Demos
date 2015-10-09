local conf = {type="skeleton", name="huanHua_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue2_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=11, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_panel", 
      bones={           
           {type="b", name="hit_area", x=0, y=340, kx=0, ky=0, cx=61, cy=85, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="scaleBg3", x=0, y=340, kx=0, ky=0, cx=3.09, cy=4.3, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="moXingDiTu_bg", x=19.85, y=308.15, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="moXingDiTu_bg", isArmature=0}} },
           {type="b", name="blue_button", x=58, y=71.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=65, kx=0, ky=0, cx=126.25, cy=16.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_biaoti", x=6.5, y=55, kx=0, ky=0, cx=10.89, cy=1, z=1, d={{name="commonGrids/common_copy_grid_7", isArmature=0}} },
           {type="b", name="title_txt", x=51.95, y=33.1, kx=0, ky=0, cx=1, cy=1, z=2, text={x=29,y=12, w=184, h=36,lineType="single line",size=24,color="ffb600",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="desc_txt", x=394.05, y=10, kx=0, ky=0, cx=1, cy=1, z=3, text={x=229,y=15, w=258, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_resource", 
      bones={           
           {type="b", name="hit_area", x=0, y=378, kx=0, ky=0, cx=125.75, cy=94.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="weiHuoDe_bg", x=291, y=308.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="weiHuoDe_bg", isArmature=0}} },
           {type="b", name="weDaCheng_bg", x=286.5, y=368.15, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="weDaCheng_bg", isArmature=0}} },
           {type="b", name="renWuDiTu_bg", x=9.85, y=347.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="renWuDiTu_bg", isArmature=0}} },
           {type="b", name="renWuXuanZhong_bg", x=146.35, y=354.15, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="renWuXuanZhong_bg", isArmature=0}} },
           {type="b", name="gou_bg", x=54.3, y=329, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="gou_bg", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_resource1", 
      bones={           
           {type="b", name="hit_area", x=0, y=174, kx=0, ky=0, cx=126.5, cy=43.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="scaleBg1", x=0, y=174, kx=0, ky=0, cx=4.6, cy=1.58, z=1, d={{name="scaleBg", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_resource2", 
      bones={           
           {type="b", name="hit_area", x=0, y=279, kx=0, ky=0, cx=126.5, cy=69.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="scaleBg2", x=0, y=279, kx=0, ky=0, cx=4.6, cy=2.54, z=1, d={{name="scaleBg", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_resource3", 
      bones={           
           {type="b", name="hit_area", x=0, y=378, kx=0, ky=0, cx=126.5, cy=94.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="scaleBg3", x=0, y=378, kx=0, ky=0, cx=4.6, cy=3.44, z=1, d={{name="scaleBg", isArmature=0}} }
         }
      },
    {type="armature", name="huanHua_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=682.15, kx=0, ky=0, cx=152.25, cy=169.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_2", x=0, y=671.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_2", isArmature=0}} },
           {type="b", name="common_copy_background_2", x=32, y=596.15, kx=0, ky=0, cx=6.43, cy=6.73, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="ttlBg", x=16.5, y=656.3, kx=0, ky=0, cx=1.17, cy=1, z=3, d={{name="component/ttlBg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=533.8, y=685.3, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      }
}, 
 animations={  
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
    {type="animation", name="commonButtons/common_copy_blue_button", 
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
    {type="animation", name="huanHua_panel", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=340, kx=0, ky=0, cx=61, cy=85, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scaleBg3", sc=1, dl=0, f={
                {x=0, y=340, kx=0, ky=0, cx=3.09, cy=4.3, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="moXingDiTu_bg", sc=1, dl=0, f={
                {x=19.85, y=308.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_button", sc=1, dl=0, f={
                {x=58, y=71.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="huanHua_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=65, kx=0, ky=0, cx=126.25, cy=16.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti", sc=1, dl=0, f={
                {x=6.5, y=55, kx=0, ky=0, cx=10.89, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_txt", sc=1, dl=0, f={
                {x=51.95, y=33.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desc_txt", sc=1, dl=0, f={
                {x=394.05, y=10, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanHua_resource", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=378, kx=0, ky=0, cx=125.75, cy=94.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weiHuoDe_bg", sc=1, dl=0, f={
                {x=291, y=308.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weDaCheng_bg", sc=1, dl=0, f={
                {x=286.5, y=368.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renWuDiTu_bg", sc=1, dl=0, f={
                {x=9.85, y=347.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renWuXuanZhong_bg", sc=1, dl=0, f={
                {x=146.35, y=354.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gou_bg", sc=1, dl=0, f={
                {x=54.3, y=329, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanHua_resource1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=174, kx=0, ky=0, cx=126.5, cy=43.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scaleBg1", sc=1, dl=0, f={
                {x=0, y=174, kx=0, ky=0, cx=4.6, cy=1.58, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanHua_resource2", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=279, kx=0, ky=0, cx=126.5, cy=69.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scaleBg2", sc=1, dl=0, f={
                {x=0, y=279, kx=0, ky=0, cx=4.6, cy=2.54, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanHua_resource3", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=378, kx=0, ky=0, cx=126.5, cy=94.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scaleBg3", sc=1, dl=0, f={
                {x=0, y=378, kx=0, ky=0, cx=4.6, cy=3.44, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanHua_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=682.15, kx=0, ky=0, cx=152.25, cy=169.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_2", sc=1, dl=0, f={
                {x=0, y=671.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_2", sc=1, dl=0, f={
                {x=32, y=596.15, kx=0, ky=0, cx=6.43, cy=6.73, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlBg", sc=1, dl=0, f={
                {x=16.5, y=656.3, kx=0, ky=0, cx=1.17, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=533.8, y=685.3, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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