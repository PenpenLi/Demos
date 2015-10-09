local conf = {type="skeleton", name="create_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="createrole_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="banshenxiangImage", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="mozhiditu", x=825, y=720, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="mozhiditu", isArmature=0}} },
           {type="b", name="common_big_blue_button", x=899, y=171, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_big_blue_button", isArmature=1}} },
           {type="b", name="common_copy_huaWen2", x=832.3, y=258.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} },
           {type="b", name="goonGameImage", x=955.95, y=144.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="goonGameImage", isArmature=0}} },
           {type="b", name="roller", x=1163, y=254.7, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="roller", isArmature=0}} },
           {type="b", name="input_name", x=971.95, y=214, kx=0, ky=0, cx=1, cy=1, z=7, text={x=971,y=210, w=175, h=35,lineType="single line",size=23,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_button_bg", isArmature=0}} },
           {type="b", name="jueliImage", x=1040, y=670, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="jueliHead", isArmature=0}} },
           {type="b", name="wushuangImage", x=890, y=670, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="wushuangHead", isArmature=0}} },
           {type="b", name="bantouImage1", x=890, y=670, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="bantouImage", isArmature=0}} },
           {type="b", name="bantouImage2", x=1039, y=670, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="bantouImage", isArmature=0}} },
           {type="b", name="poemImage", x=1170, y=630, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="common_button_bg", isArmature=0}} },
           {type="b", name="tipsText", x=878.95, y=271, kx=0, ky=0, cx=1, cy=1, z=13, text={x=878,y=271, w=310, h=26,lineType="single line",size=22,color="ffd953",alignment="center",space=0,textType="static"}, d={{name="nullSprite", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_big_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_big_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_big_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="createrole_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="banshenxiangImage", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mozhiditu", sc=1, dl=0, f={
                {x=825, y=720, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_big_blue_button", sc=1, dl=0, f={
                {x=899, y=171, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_huaWen2", sc=1, dl=0, f={
                {x=832.3, y=258.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="goonGameImage", sc=1, dl=0, f={
                {x=955.95, y=144.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="roller", sc=1, dl=0, f={
                {x=1163, y=254.7, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_name", sc=1, dl=0, f={
                {x=971.95, y=214, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jueliImage", sc=1, dl=0, f={
                {x=1040, y=670, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wushuangImage", sc=1, dl=0, f={
                {x=890, y=670, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantouImage1", sc=1, dl=0, f={
                {x=890, y=670, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bantouImage2", sc=1, dl=0, f={
                {x=1039, y=670, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="poemImage", sc=1, dl=0, f={
                {x=1170, y=630, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tipsText", sc=1, dl=0, f={
                {x=878.95, y=271, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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