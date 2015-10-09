local conf = {type="skeleton", name="batchUse_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="common_copy_greenroundbutton", 
      bones={           
           {type="b", name="common_greenroundbutton", x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, text={x=5,y=8, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_greenroundbutton_normal", isArmature=0},{name="common_copy_greenroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="main_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_blackHalfAlpha_bg", x=0, y=720, kx=0, ky=0, cx=1.6, cy=1.5, z=1, d={{name="common_copy_blackHalfAlpha_bg", isArmature=0}} },
           {type="b", name="bg", x=320, y=563.85, kx=0, ky=0, cx=16.31, cy=10.05, z=2, d={{name="common_copy_background_inner_2", isArmature=0}} },
           {type="b", name="rightButton", x=741.5, y=255.35, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="leftButton", x=431.05, y=255, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="itemTextData", x=364.05, y=524.85, kx=0, ky=0, cx=1, cy=1, z=5, text={x=360,y=490, w=190, h=31,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="dynamic"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="itemDescTextData", x=504.5, y=524.85, kx=0, ky=0, cx=1, cy=1, z=6, text={x=465,y=490, w=120, h=31,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="dynamic"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="priceTextData", x=621.55, y=526.85, kx=0, ky=0, cx=1, cy=1, z=7, text={x=585,y=490, w=174, h=31,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="dynamic"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="priceDescTextData", x=720.5, y=530.85, kx=0, ky=0, cx=1, cy=1, z=8, text={x=696,y=490, w=240, h=31,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="dynamic"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="scrollSelectPanelHolder", x=327, y=465.5, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="scrollSelectPanelHolder", isArmature=0}} },
           {type="b", name="img_red", x=375.3, y=411.15, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="img_red", isArmature=0}} },
           {type="b", name="selectTextData", x=396.5, y=415.5, kx=0, ky=0, cx=1, cy=1, z=11, text={x=357,y=410, w=176, h=29,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="selectDescTextData", x=460.5, y=442.5, kx=0, ky=0, cx=1, cy=1, z=12, text={x=442,y=410, w=124, h=29,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="selector", x=577.3, y=429.65, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="selector", isArmature=0}} },
           {type="b", name="maxIconTextData", x=734.45, y=448.5, kx=0, ky=0, cx=1, cy=1, z=14, text={x=811,y=493, w=216, h=29,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=907.3, y=602.65, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="common_copy_blueround_button", 
      bones={           
           {type="b", name="common_blueround_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=16,y=-47, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_blueround_button_normal", isArmature=0},{name="common_copy_blueround_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_close_button_normal", isArmature=0},{name="common_copy_close_button_down", isArmature=0}} },
           {type="b", name="common_close_button0", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_copy_close_button_normal", isArmature=0},{name="common_copy_close_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="common_copy_greenroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="main_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blackHalfAlpha_bg", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1.6, cy=1.5, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=320, y=563.85, kx=0, ky=0, cx=16.31, cy=10.05, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rightButton", sc=1, dl=0, f={
                {x=741.5, y=255.35, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftButton", sc=1, dl=0, f={
                {x=431.05, y=255, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTextData", sc=1, dl=0, f={
                {x=364.05, y=524.85, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemDescTextData", sc=1, dl=0, f={
                {x=504.5, y=524.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="priceTextData", sc=1, dl=0, f={
                {x=621.55, y=526.85, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="priceDescTextData", sc=1, dl=0, f={
                {x=720.5, y=530.85, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="scrollSelectPanelHolder", sc=1, dl=0, f={
                {x=327, y=465.5, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_red", sc=1, dl=0, f={
                {x=375.3, y=411.15, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectTextData", sc=1, dl=0, f={
                {x=396.5, y=415.5, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selectDescTextData", sc=1, dl=0, f={
                {x=460.5, y=442.5, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="selector", sc=1, dl=0, f={
                {x=577.3, y=429.65, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="maxIconTextData", sc=1, dl=0, f={
                {x=734.45, y=448.5, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=907.3, y=602.65, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_blueround_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button0", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button0", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button0", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch0", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         },
     {name="disable0", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      }
  }
}
 return conf;