local conf = {type="skeleton", name="shadow_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="button_ui", 
      bones={           
           {type="b", name="card_bg", x=0, y=511, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="yxz/heroImage_render_bg", isArmature=0}} },
           {type="b", name="not_open_word_bg", x=234.9, y=446.7, kx=0, ky=0, cx=0.7, cy=0.71, z=1, d={{name="not_open_word_bg", isArmature=0}} },
           {type="b", name="ciShuYongWan_bg", x=205, y=491.65, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="yxz/ciShuYongWan_bg", isArmature=0}} },
           {type="b", name="renWuDiTu_bg", x=195.85, y=382.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="renWuDiTu_bg", isArmature=0}} },
           {type="b", name="renWuZheZhao_bg", x=212, y=242.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="renWuZheZhao_bg", isArmature=0}} },
           {type="b", name="yingxiongkaiqi", x=341, y=431.95, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="yingxiongkaiqi", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="heroBiog_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=193, kx=0, ky=0, cx=50, cy=25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="heroName_bg", x=218.45, y=195.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yxz/heroName_bg", isArmature=0}} }
         }
      },
    {type="armature", name="heroImage_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="book_bg", x=60, y=543, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yxz/book_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1194.25, y=718, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="tili", x=762, y=128, kx=0, ky=0, cx=1, cy=1, z=3, text={x=692,y=127, w=147, h=36,lineType="single line",size=24,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text3", x=546.95, y=131.60000000000002, kx=0, ky=0, cx=1, cy=1, z=4, text={x=554,y=127, w=135, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text_bg3", x=551.3, y=159.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="yxz/txt_bg", isArmature=0}} },
           {type="b", name="cishu", x=715.05, y=159.95000000000005, kx=0, ky=0, cx=1, cy=1, z=6, text={x=693,y=176, w=69, h=36,lineType="single line",size=24,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text2", x=552.1, y=193.25, kx=0, ky=0, cx=1, cy=1, z=7, text={x=554,y=176, w=136, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text_bg2", x=551.3, y=209.7, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="yxz/txt_bg", isArmature=0}} },
           {type="b", name="text_bg1", x=551.3, y=261.7, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="yxz/txt_bg", isArmature=0}} },
           {type="b", name="text1", x=552.1, y=244.25, kx=0, ky=0, cx=1, cy=1, z=10, text={x=553,y=228, w=136, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="left_arrow", x=69.5, y=659.65, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="yxz/left_arrow", isArmature=0}} },
           {type="b", name="right_arrow", x=1160.45, y=659.65, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="yxz/right_arrow", isArmature=0}} },
           {type="b", name="mopUp_button", x=942.45, y=190.20000000000005, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="yxz/yxzSaoDang", isArmature=0}} },
           {type="b", name="enter_button", x=1070.8, y=221.65, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_fightbutton_normal", isArmature=0}} },
           {type="b", name="zhuan_bg", x=1091.3, y=525, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="yxz/zhuan_bg", isArmature=0}} },
           {type="b", name="wenZiDiTu_bg", x=551.3, y=437.65, kx=0, ky=0, cx=10.79, cy=1.43, z=16, d={{name="wenZiDiTu_bg", isArmature=0}} },
           {type="b", name="hero_desc", x=586.1, y=405.25, kx=0, ky=0, cx=1, cy=1, z=17, text={x=566,y=362, w=596, h=65,lineType="multiline",size=22,color="010000",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="saoDangQuan_txt", x=860, y=92, kx=0, ky=0, cx=1, cy=1, z=18, text={x=788,y=97, w=172, h=31,lineType="single line",size=20,color="4f2413",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="saoDangDesc_txt", x=997, y=92, kx=0, ky=0, cx=1, cy=1, z=19, text={x=895,y=94, w=180, h=36,lineType="single line",size=24,color="4f2413",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="noticeHero_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1190, y=715, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_close_button", isArmature=1}} },
           {type="b", name="common_copy_blue_button", x=1043, y=103, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_huaWen2", x=424.3, y=666.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_huaWen2", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="button_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="card_bg", sc=1, dl=0, f={
                {x=0, y=511, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="not_open_word_bg", sc=1, dl=0, f={
                {x=234.9, y=446.7, kx=0, ky=0, cx=0.7, cy=0.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ciShuYongWan_bg", sc=1, dl=0, f={
                {x=205, y=491.65, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renWuDiTu_bg", sc=1, dl=0, f={
                {x=195.85, y=382.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renWuZheZhao_bg", sc=1, dl=0, f={
                {x=212, y=242.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingxiongkaiqi", sc=1, dl=0, f={
                {x=341, y=431.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="heroBiog_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=193, kx=0, ky=0, cx=50, cy=25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="heroName_bg", sc=1, dl=0, f={
                {x=218.45, y=195.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="heroImage_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="book_bg", sc=1, dl=0, f={
                {x=60, y=543, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1194.25, y=718, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili", sc=1, dl=0, f={
                {x=762, y=128, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text3", sc=1, dl=0, f={
                {x=546.95, y=131.60000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg3", sc=1, dl=0, f={
                {x=551.3, y=159.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cishu", sc=1, dl=0, f={
                {x=715.05, y=159.95000000000005, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=552.1, y=193.25, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg2", sc=1, dl=0, f={
                {x=551.3, y=209.7, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg1", sc=1, dl=0, f={
                {x=551.3, y=261.7, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=552.1, y=244.25, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_arrow", sc=1, dl=0, f={
                {x=69.5, y=659.65, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_arrow", sc=1, dl=0, f={
                {x=1160.45, y=659.65, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopUp_button", sc=1, dl=0, f={
                {x=942.45, y=190.20000000000005, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="enter_button", sc=1, dl=0, f={
                {x=1070.8, y=221.65, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuan_bg", sc=1, dl=0, f={
                {x=1091.3, y=525, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wenZiDiTu_bg", sc=1, dl=0, f={
                {x=551.3, y=437.65, kx=0, ky=0, cx=10.79, cy=1.43, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_desc", sc=1, dl=0, f={
                {x=586.1, y=405.25, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saoDangQuan_txt", sc=1, dl=0, f={
                {x=860, y=92, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saoDangDesc_txt", sc=1, dl=0, f={
                {x=997, y=92, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="noticeHero_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1190, y=715, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=1043, y=103, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_huaWen2", sc=1, dl=0, f={
                {x=424.3, y=666.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
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
      }
  }
}
 return conf;