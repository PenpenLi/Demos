local conf = {type="skeleton", name="faction_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="huobiGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=60.15, kx=0, ky=0, cx=305, cy=15, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="yingliang_bantou", x=585.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="yinliangText", x=627, y=12.15, kx=0, ky=0, cx=1, cy=1, z=2, text={x=626,y=11, w=156, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yinliang", x=553.8, y=56.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="jia_yingliang", x=776.5, y=52.15, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} },
           {type="b", name="tili_bantou", x=868.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="jia_tili", x=1066.5, y=52.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} },
           {type="b", name="tiliText", x=1145, y=16.15, kx=0, ky=0, cx=1, cy=1, z=7, text={x=919,y=11, w=142, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="tili", x=841.8, y=57.15, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="shengwang_bantou", x=325.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="shengwangText", x=265, y=17.15, kx=0, ky=0, cx=1, cy=1, z=10, text={x=350,y=12, w=156, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shengwang", x=296.45, y=58.3, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonCurrencyImages/common_copy_shengwang_bg", isArmature=0}} },
           {type="b", name="guanzhi_bantou", x=22.85, y=48.15, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="guanzhiText", x=31, y=17.15, kx=0, ky=0, cx=1, cy=1, z=13, text={x=72,y=12, w=81, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shengguan", x=151, y=60.3, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="guanzhi", x=5.35, y=56.65, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="guanzhi", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="huobiGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=60.15, kx=0, ky=0, cx=305, cy=15, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingliang_bantou", sc=1, dl=0, f={
                {x=585.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliangText", sc=1, dl=0, f={
                {x=627, y=12.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang", sc=1, dl=0, f={
                {x=553.8, y=56.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_yingliang", sc=1, dl=0, f={
                {x=776.5, y=52.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili_bantou", sc=1, dl=0, f={
                {x=868.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_tili", sc=1, dl=0, f={
                {x=1066.5, y=52.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tiliText", sc=1, dl=0, f={
                {x=1145, y=16.15, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili", sc=1, dl=0, f={
                {x=841.8, y=57.15, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengwang_bantou", sc=1, dl=0, f={
                {x=325.8, y=48.15, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengwangText", sc=1, dl=0, f={
                {x=265, y=17.15, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengwang", sc=1, dl=0, f={
                {x=296.45, y=58.3, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanzhi_bantou", sc=1, dl=0, f={
                {x=22.85, y=48.15, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanzhiText", sc=1, dl=0, f={
                {x=31, y=17.15, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengguan", sc=1, dl=0, f={
                {x=151, y=60.3, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guanzhi", sc=1, dl=0, f={
                {x=5.35, y=56.65, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;