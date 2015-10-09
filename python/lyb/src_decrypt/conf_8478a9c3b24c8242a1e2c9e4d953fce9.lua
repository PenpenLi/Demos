local conf = {type="skeleton", name="tianXiang_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="tianXiang_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1201, y=717, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="common_copy_ask_button", x=1131.05, y=710, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="left_arrow", x=18.5, y=395.7, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="left_arrow", isArmature=0}} },
           {type="b", name="right_arrow", x=1206.4, y=393.7, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="right_arrow", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="info_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=56, kx=0, ky=0, cx=320, cy=14, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="silver_txt", x=961.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=1, text={x=859,y=7, w=93, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="hasStar_txt", x=1119.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=2, text={x=1079,y=7, w=78, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="hasStar_desc", x=1003.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=3, text={x=966,y=7, w=78, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="star_txt", x=783.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=4, text={x=746,y=7, w=79, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="curStar_txt", x=321.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=5, text={x=206,y=9, w=395, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="need_desc", x=675.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=6, text={x=637,y=9, w=80, h=36,lineType="single line",size=24,color="fffecf",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="tianXiang_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1201, y=717, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1131.05, y=710, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_arrow", sc=1, dl=0, f={
                {x=18.5, y=395.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_arrow", sc=1, dl=0, f={
                {x=1206.4, y=393.7, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="info_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=56, kx=0, ky=0, cx=320, cy=14, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_txt", sc=1, dl=0, f={
                {x=961.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hasStar_txt", sc=1, dl=0, f={
                {x=1119.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hasStar_desc", sc=1, dl=0, f={
                {x=1003.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="star_txt", sc=1, dl=0, f={
                {x=783.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="curStar_txt", sc=1, dl=0, f={
                {x=321.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="need_desc", sc=1, dl=0, f={
                {x=675.05, y=19.9, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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