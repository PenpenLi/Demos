local conf = {type="skeleton", name="regist_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="common_copy_bluelonground_button", 
      bones={           
           {type="b", name="common_bluelonground_button", x=-0.5, y=60, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=9, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_bluelonground_button_normal", isArmature=0},{name="common_copy_bluelonground_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_blueroundbutton", 
      bones={           
           {type="b", name="common_blueroundbutton", x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, text={x=17,y=9, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_blueroundbutton_normal", isArmature=0},{name="common_copy_blueroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_orringeroundbutton", 
      bones={           
           {type="b", name="common_orringeroundbutton", x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, text={x=13,y=8, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_orringeroundbutton_normal", isArmature=0},{name="common_copy_orringeroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="main", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="hit_area", isArmature=0}} },
           {type="b", name="beijing", x=0, y=240, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="beijing", isArmature=0}} },
           {type="b", name="input_bg", x=368.5, y=402.55, kx=0, ky=0, cx=8.35, cy=1, z=2, d={{name="input_bg", isArmature=0}} },
           {type="b", name="input_bg_1", x=368.5, y=304.6, kx=0, ky=0, cx=8.35, cy=1, z=3, d={{name="input_bg", isArmature=0}} },
           {type="b", name="nullSprite", x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="inputText", x=412, y=351, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="inputTextmm", x=412, y=269, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="nullSprite", isArmature=0}} },
           {type="b", name="common_blue_button", x=734.5, y=148.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="common_copy_bluelonground_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=-0.5, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_blueroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueroundbutton", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueroundbutton", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueroundbutton", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_orringeroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_orringeroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_orringeroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_orringeroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="main", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="beijing", sc=1, dl=0, f={
                {x=0, y=240, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_bg", sc=1, dl=0, f={
                {x=368.5, y=402.55, kx=0, ky=0, cx=8.35, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_bg_1", sc=1, dl=0, f={
                {x=368.5, y=304.6, kx=0, ky=0, cx=8.35, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nullSprite", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="inputText", sc=1, dl=0, f={
                {x=412, y=351, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="inputTextmm", sc=1, dl=0, f={
                {x=412, y=269, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=734.5, y=148.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_blue_button", 
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