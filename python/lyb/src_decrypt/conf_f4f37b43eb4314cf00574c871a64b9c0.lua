local conf = {type="skeleton", name="handofMidas_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="baojiEffect", 
      bones={           
           {type="b", name="hit_area", x=0, y=136, kx=0, ky=0, cx=77.5, cy=34, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_battle_state5", x=155, y=68, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="baoji", isArmature=0}} },
           {type="b", name="bigred1", x=249.85, y=109.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="bigred1", isArmature=0}} },
           {type="b", name="bigred0", x=198.85, y=107.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="bigred0", isArmature=0}} }
         }
      },
    {type="armature", name="common_battle_text", 
      bones={           
           {type="b", name="common_battle_bigred9", x=438.95, y=231, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="bigred9", isArmature=0}} },
           {type="b", name="common_battle_bigred8", x=396.85, y=233.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bigred8", isArmature=0}} },
           {type="b", name="common_battle_bigred7", x=353.85, y=231, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="bigred7", isArmature=0}} },
           {type="b", name="common_battle_bigred6", x=305.85, y=233.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="bigred6", isArmature=0}} },
           {type="b", name="common_battle_bigred5", x=265.85, y=236.5, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="bigred5", isArmature=0}} },
           {type="b", name="common_battle_bigred4", x=222.85, y=237, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="bigred4", isArmature=0}} },
           {type="b", name="common_battle_bigred3", x=175.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="bigred3", isArmature=0}} },
           {type="b", name="common_battle_bigred2", x=135.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="bigred2", isArmature=0}} },
           {type="b", name="common_battle_bigred1", x=92.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="bigred1", isArmature=0}} },
           {type="b", name="common_battle_bigred0", x=55.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="bigred0", isArmature=0}} },
           {type="b", name="common_battle_state5", x=37.75, y=367, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="baoji", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue2_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=11, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="handofMidas_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=425, kx=0, ky=0, cx=146, cy=106.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="background_img", x=24.85, y=379.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=58.85, y=329.2, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="currency_bg", x=87.8, y=188.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="currency_bg", isArmature=0}} },
           {type="b", name="baoji_desc_txt", x=202.95, y=219.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=160,y=201, w=331, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gold_txt", x=222.95, y=162.05, kx=0, ky=0, cx=1, cy=1, z=5, text={x=182,y=134, w=86, h=44,lineType="single line",size=26,color="59390f",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_gold_bg", x=115.95, y=184.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="common_copy_silver_bg", x=322.95, y=185.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="silver_txt", x=442.95, y=166.05, kx=0, ky=0, cx=1, cy=1, z=8, text={x=388,y=135, w=126, h=44,lineType="single line",size=26,color="57290f",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="count_txt", x=174.95, y=244.05, kx=0, ky=0, cx=1, cy=1, z=9, text={x=121,y=238, w=330, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="exchange_txt", x=179.95, y=310.05, kx=0, ky=0, cx=1, cy=1, z=10, text={x=121,y=272, w=391, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=508, y=405, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="cancel_button", x=129, y=104, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="confirm_button", x=225, y=104, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_copy_greenArrow", x=241.35, y=180, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_greenArrow", isArmature=0}} },
           {type="b", name="silver_bg", x=78.5, y=357.2, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="silver_bg", isArmature=0}} },
           {type="b", name="common_copy_silver_bg1", x=37.95, y=374, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="cur_silver_txt", x=136.95, y=350.05, kx=0, ky=0, cx=1, cy=1, z=17, text={x=94,y=324, w=153, h=36,lineType="single line",size=24,color="fff4df",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="baojiEffect", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=136, kx=0, ky=0, cx=77.5, cy=34, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state5", sc=1, dl=0, f={
                {x=155, y=68, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bigred1", sc=1, dl=0, f={
                {x=249.85, y=109.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bigred0", sc=1, dl=0, f={
                {x=198.85, y=107.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_battle_text", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_battle_bigred9", sc=1, dl=0, f={
                {x=438.95, y=231, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred8", sc=1, dl=0, f={
                {x=396.85, y=233.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred7", sc=1, dl=0, f={
                {x=353.85, y=231, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred6", sc=1, dl=0, f={
                {x=305.85, y=233.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred5", sc=1, dl=0, f={
                {x=265.85, y=236.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred4", sc=1, dl=0, f={
                {x=222.85, y=237, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred3", sc=1, dl=0, f={
                {x=175.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred2", sc=1, dl=0, f={
                {x=135.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred1", sc=1, dl=0, f={
                {x=92.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred0", sc=1, dl=0, f={
                {x=55.85, y=241.5, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state5", sc=1, dl=0, f={
                {x=37.75, y=367, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
    {type="animation", name="handofMidas_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=425, kx=0, ky=0, cx=146, cy=106.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_img", sc=1, dl=0, f={
                {x=24.85, y=379.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_3", sc=1, dl=0, f={
                {x=58.85, y=329.2, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="currency_bg", sc=1, dl=0, f={
                {x=87.8, y=188.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="baoji_desc_txt", sc=1, dl=0, f={
                {x=202.95, y=219.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_txt", sc=1, dl=0, f={
                {x=222.95, y=162.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_gold_bg", sc=1, dl=0, f={
                {x=115.95, y=184.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg", sc=1, dl=0, f={
                {x=322.95, y=185.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_txt", sc=1, dl=0, f={
                {x=442.95, y=166.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="count_txt", sc=1, dl=0, f={
                {x=174.95, y=244.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exchange_txt", sc=1, dl=0, f={
                {x=179.95, y=310.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=508, y=405, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cancel_button", sc=1, dl=0, f={
                {x=129, y=104, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="confirm_button", sc=1, dl=0, f={
                {x=225, y=104, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_greenArrow", sc=1, dl=0, f={
                {x=241.35, y=180, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_bg", sc=1, dl=0, f={
                {x=78.5, y=357.2, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg1", sc=1, dl=0, f={
                {x=37.95, y=374, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cur_silver_txt", sc=1, dl=0, f={
                {x=136.95, y=350.05, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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