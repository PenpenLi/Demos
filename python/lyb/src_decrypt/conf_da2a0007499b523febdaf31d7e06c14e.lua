local conf = {type="skeleton", name="trackItem_ui", frameRate=24, version=1.4,
 armatures={  
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
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=11, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="trackItem_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=117, kx=0, ky=0, cx=92.75, cy=29.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_mingzi_bg", x=249.35, y=44.7, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_mingzi_bg", isArmature=0}} },
           {type="b", name="strongPointName_txt", x=220.95, y=10.75, kx=0, ky=0, cx=1, cy=1, z=2, text={x=124,y=17, w=108, h=34,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="action_txt", x=368.95, y=10.75, kx=0, ky=0, cx=1, cy=1, z=3, text={x=247,y=18, w=108, h=34,lineType="single line",size=22,color="00ff00",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="alertInfo_txt", x=118.9, y=74, kx=0, ky=0, cx=1, cy=1, z=4, text={x=95,y=66, w=277, h=36,lineType="single line",size=24,color="822a00",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="trackItem_resource", 
      bones={           
           {type="b", name="hit_area", x=0, y=120, kx=0, ky=0, cx=97, cy=30, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="zhandou_bg", x=59, y=68.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="zhandou_bg", isArmature=0}} },
           {type="b", name="alertInfo_bg", x=26, y=60.55, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="alertInfo_bg", isArmature=0}} },
           {type="b", name="saodang_bg", x=22, y=113.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="saodang_bg", isArmature=0}} },
           {type="b", name="qianwang_bg", x=118, y=113.15, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="qianwang_bg", isArmature=0}} },
           {type="b", name="weikaiqi_bg", x=270.5, y=110.15, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="weikaiqi_bg", isArmature=0}} }
         }
      },
    {type="armature", name="trackItem_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=642, kx=0, ky=0, cx=104.25, cy=160.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_5", x=0, y=642, kx=0, ky=0, cx=5.28, cy=8.13, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_copy_background_2", x=16.35, y=487, kx=0, ky=0, cx=4.67, cy=5.71, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="itemType_txt", x=197.05, y=507, kx=0, ky=0, cx=1, cy=1, z=3, text={x=27,y=504, w=255, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_biaoti", x=18.5, y=483, kx=0, ky=0, cx=8.38, cy=1, z=4, d={{name="commonGrids/common_copy_grid_7", isArmature=0}} },
           {type="b", name="common_copy_equipe_bg", x=283, y=611, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="itemName_txt", x=201.95, y=587.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=26,y=568, w=180, h=44,lineType="single line",size=30,color="ff00ff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huodetujing_txt", x=156.95, y=461.1, kx=0, ky=0, cx=1, cy=1, z=7, text={x=130,y=440, w=172, h=39,lineType="single line",size=26,color="ff8a00",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
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
    {type="animation", name="commonButtons/common_copy_small_blue_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=46, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="trackItem_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=117, kx=0, ky=0, cx=92.75, cy=29.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_mingzi_bg", sc=1, dl=0, f={
                {x=249.35, y=44.7, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strongPointName_txt", sc=1, dl=0, f={
                {x=220.95, y=10.75, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="action_txt", sc=1, dl=0, f={
                {x=368.95, y=10.75, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="alertInfo_txt", sc=1, dl=0, f={
                {x=118.9, y=74, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="trackItem_resource", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=97, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhandou_bg", sc=1, dl=0, f={
                {x=59, y=68.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="alertInfo_bg", sc=1, dl=0, f={
                {x=26, y=60.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saodang_bg", sc=1, dl=0, f={
                {x=22, y=113.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="qianwang_bg", sc=1, dl=0, f={
                {x=118, y=113.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weikaiqi_bg", sc=1, dl=0, f={
                {x=270.5, y=110.15, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="trackItem_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=642, kx=0, ky=0, cx=104.25, cy=160.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_5", sc=1, dl=0, f={
                {x=0, y=642, kx=0, ky=0, cx=5.28, cy=8.13, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_2", sc=1, dl=0, f={
                {x=16.35, y=487, kx=0, ky=0, cx=4.67, cy=5.71, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemType_txt", sc=1, dl=0, f={
                {x=197.05, y=507, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti", sc=1, dl=0, f={
                {x=18.5, y=483, kx=0, ky=0, cx=8.38, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_equipe_bg", sc=1, dl=0, f={
                {x=283, y=611, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemName_txt", sc=1, dl=0, f={
                {x=201.95, y=587.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huodetujing_txt", sc=1, dl=0, f={
                {x=156.95, y=461.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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