local conf = {type="skeleton", name="server_merge_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="avatar_select_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=480, kx=0, ky=0, cx=200, cy=120, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bg", isArmature=0}} },
           {type="b", name="title", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="title", isArmature=0}} },
           {type="b", name="pos", x=27, y=60.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_left_button", x=-15, y=276, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_left_button", isArmature=1}} },
           {type="b", name="common_copy_right_button", x=764, y=276, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_right_button", isArmature=1}} }
         }
      },
    {type="armature", name="avatar_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=355, kx=0, ky=0, cx=62, cy=88.75, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="avatar_bg", x=4, y=355, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="avatar_bg", isArmature=0}} },
           {type="b", name="level_descb", x=28, y=265.05, kx=0, ky=0, cx=1, cy=1, z=2, text={x=24,y=249, w=220, h=26,lineType="single line",size=16,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb", x=28, y=284.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=24,y=271, w=220, h=26,lineType="single line",size=16,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="pos", x=124, y=75.60000000000002, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_blueround_button", x=68, y=56, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_blueround_button", isArmature=1}} }
         }
      },
    {type="armature", name="common_copy_left_button", 
      bones={           
           {type="b", name="common_copy_left_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_left_button_normal", isArmature=0},{name="common_copy_left_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_right_button", 
      bones={           
           {type="b", name="common_copy_right_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_right_button_normal", isArmature=0},{name="common_copy_right_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="name_select_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=480, kx=0, ky=0, cx=200, cy=120, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bg", isArmature=0}} },
           {type="b", name="input_bg", x=291.95, y=343.55, kx=0, ky=0, cx=1, cy=1, z=2, text={x=404,y=207, w=240, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=717, y=76, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_close_button", isArmature=1}} },
           {type="b", name="common_copy_blueround_button", x=562, y=165, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="common_copy_greenroundbutton", x=379, y=165, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_greenroundbutton", isArmature=1}} },
           {type="b", name="createrole_random_button", x=684.3, y=244.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="createrole_random_button", isArmature=1}} },
           {type="b", name="pos", x=23, y=57, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_bluebutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_close_button_normal", isArmature=0},{name="common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_blueround_button", 
      bones={           
           {type="b", name="common_copy_blueround_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=5,y=-45, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_blueround_button_normal", isArmature=0},{name="common_copy_blueround_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_greenroundbutton", 
      bones={           
           {type="b", name="common_copy_greenroundbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=5,y=-46, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_greenroundbutton_normal", isArmature=0},{name="common_copy_greenroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="createrole_random_button", 
      bones={           
           {type="b", name="createrole_random_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="createrole_random_button_normal", isArmature=0},{name="createrole_random_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="avatar_select_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=200, cy=120, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pos", sc=1, dl=0, f={
                {x=27, y=60.05000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_left_button", sc=1, dl=0, f={
                {x=-15, y=276, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_right_button", sc=1, dl=0, f={
                {x=764, y=276, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="avatar_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=355, kx=0, ky=0, cx=62, cy=88.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="avatar_bg", sc=1, dl=0, f={
                {x=4, y=355, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=28, y=265.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=28, y=284.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pos", sc=1, dl=0, f={
                {x=124, y=75.60000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=68, y=56, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_left_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_right_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="name_select_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=200, cy=120, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_bg", sc=1, dl=0, f={
                {x=291.95, y=343.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=717, y=76, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=562, y=165, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=379, y=165, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="createrole_random_button", sc=1, dl=0, f={
                {x=684.3, y=244.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pos", sc=1, dl=0, f={
                {x=23, y=57, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_bluebutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_bluebutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_bluebutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_blueround_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_greenroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="createrole_random_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="createrole_random_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="createrole_random_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="createrole_random_button", sc=1, dl=0, f={
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