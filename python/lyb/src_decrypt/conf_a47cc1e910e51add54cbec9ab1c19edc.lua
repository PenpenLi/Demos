local conf = {type="skeleton", name="heroScene_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="currency_bg_ui", 
      bones={           
           {type="b", name="currency_bg", x=0, y=50, kx=0, ky=0, cx=1, cy=1, z=0, text={x=8,y=6, w=130, h=31,lineType="single line",size=20,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="currency_bg", isArmature=0}} }
         }
      },
    {type="armature", name="hero_card_ui", 
      bones={           
           {type="b", name="hero_cardBg", x=0, y=323, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_summon_card", isArmature=0}} },
           {type="b", name="hero_name_text", x=34.45, y=191.55, kx=0, ky=0, cx=1, cy=1, z=1, text={x=-88,y=171, w=175, h=43,lineType="single line",size=14,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_grid", x=-33, y=356, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="hero_item_num_text", x=18.45, y=301.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=-8,y=288, w=41, h=31,lineType="single line",size=20,color="efef00",alignment="right",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="hero_name_bg", x=53, y=447.35, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="hero_name_bg", isArmature=1}} }
         }
      },
    {type="armature", name="hero_left_button", 
      bones={           
           {type="b", name="common_bluelonground_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="hero_left_button_normal", isArmature=0},{name="hero_left_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="hero_right_button", 
      bones={           
           {type="b", name="common_bluelonground_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="hero_right_button_normal", isArmature=0},{name="hero_right_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="hero_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=480, kx=0, ky=0, cx=200, cy=120, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bg", isArmature=0}} },
           {type="b", name="card_big_bg", x=0, y=417.6, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="card_big_bg", isArmature=1}} },
           {type="b", name="card_position", x=73.35, y=410.85, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="hero_card", isArmature=1}} },
           {type="b", name="title", x=264.05, y=477.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="title", isArmature=0}} },
           {type="b", name="common_copy_bluelonground_button", x=401.45, y=61.25, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_bluelonground_button", isArmature=1}} },
           {type="b", name="score_icon", x=302.95, y=90.7, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="scoreIcon", isArmature=0}} },
           {type="b", name="rCountText", x=169.5, y=116.60000000000002, kx=0, ky=0, cx=1, cy=1, z=7, text={x=107,y=90, w=126, h=26,lineType="single line",size=16,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="rCount", x=281.65, y=116.60000000000002, kx=0, ky=0, cx=1, cy=1, z=8, text={x=219,y=90, w=27, h=26,lineType="single line",size=16,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="gFreeRefreshTime", x=126.3, y=25.649999999999977, kx=0, ky=0, cx=1, cy=1, z=9, text={x=66,y=2, w=126, h=28,lineType="single line",size=18,color="00ffff",alignment="right",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="gFreeRefreshText", x=246, y=12.449999999999989, kx=0, ky=0, cx=1, cy=1, z=10, text={x=195,y=0, w=57, h=31,lineType="single line",size=20,color="ffff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="aFreeRefreshTime", x=558.2, y=30, kx=0, ky=0, cx=1, cy=1, z=11, text={x=498,y=3, w=126, h=28,lineType="single line",size=18,color="00ffff",alignment="right",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="aFreeRefreshText", x=681.5, y=17.149999999999977, kx=0, ky=0, cx=1, cy=1, z=12, text={x=626,y=1, w=57, h=31,lineType="single line",size=20,color="ffff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="general_refresh_btn", x=74.35, y=89, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="普通刷新按钮/general_refresh_btn", isArmature=1}} },
           {type="b", name="refesh_gold_putong", x=182.8, y=71.14999999999998, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="refesh_gold", isArmature=0}} },
           {type="b", name="advanced_refresh_btn", x=506.85, y=87, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="高级刷新按钮/advanced_refresh_btn", isArmature=1}} },
           {type="b", name="img_firstGradeHero", x=608.8, y=153, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="img_firstGradeHero", isArmature=0}} },
           {type="b", name="img_firstSuccess", x=516.45, y=114, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="img_firstSuccess", isArmature=0}} },
           {type="b", name="img_againSuccess", x=440.45, y=114.14999999999998, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="img_againSuccess", isArmature=0}} },
           {type="b", name="img_numPos", x=499.95, y=92, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="container", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=716.35, y=79.19999999999999, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="common_copy_close_button", isArmature=1}} },
           {type="b", name="common_copy_silver_bg", x=132, y=457, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="common_copy_silver_bg", isArmature=1}} },
           {type="b", name="refesh_gold_gaoji", x=615.3, y=72.14999999999998, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="refesh_gold", isArmature=0}} },
           {type="b", name="bag_silver_descb", x=190.45, y=458.7, kx=0, ky=0, cx=1, cy=1, z=23, text={x=132,y=428, w=138, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_gold_descb", x=93.35, y=458.65, kx=0, ky=0, cx=1, cy=1, z=24, text={x=11,y=427, w=147, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_blueround_button_1", x=682.7, y=475.1, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="common_copy_gold_bg1", x=12, y=457, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="common_copy_gold_bg", isArmature=0}} },
           {type="b", name="hero_money_value_text", x=460.5, y=107.55, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="rule_text", x=598.65, y=459, kx=0, ky=0, cx=1, cy=1, z=28, text={x=555,y=432, w=109, h=31,lineType="single line",size=20,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="card_big_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=266.67, cy=100.33, z=0, d={{name="common_border_inner09", isArmature=0}} },
           {type="b", name="line1", x=45, y=-2, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_separate_horizontal_line", isArmature=0}} },
           {type="b", name="line2", x=45, y=-297.85, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_separate_horizontal_line", isArmature=0}} }
         }
      },
    {type="armature", name="hero_card", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="card_bg", isArmature=1}} },
           {type="b", name="common_greenroundbutton", x=31.5, y=-219.9, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_greenroundbutton", isArmature=1}} },
           {type="b", name="silver_bg", x=19.85, y=-184.3, kx=0, ky=0, cx=1, cy=1, z=2, text={x=60,y=-216, w=84, h=26,lineType="single line",size=16,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="silver_bg", isArmature=1}} },
           {type="b", name="common_copy_silver_bg", x=25, y=-190.3, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_silver_bg", isArmature=1}} },
           {type="b", name="hero_name_bg", x=132, y=-27.3, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="hero_name_bg", isArmature=1}} },
           {type="b", name="tatter_desc_bg", x=11.85, y=14.75, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="tatter_desc_bg", isArmature=1}} },
           {type="b", name="tatter_desc_text_bg1", x=162, y=-9.6, kx=0, ky=0, cx=1, cy=1, z=6, text={x=29,y=-11, w=156, h=26,lineType="single line",size=16,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="tatter_desc_text_bg2", x=162, y=-31.3, kx=0, ky=0, cx=1, cy=1, z=7, text={x=29,y=-32, w=156, h=26,lineType="single line",size=16,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="already_recruit", x=-12.65, y=-164.3, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="already_recruit", isArmature=1}} }
         }
      },
    {type="armature", name="card_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="cardBg", isArmature=0}} }
         }
      },
    {type="armature", name="common_greenroundbutton", 
      bones={           
           {type="b", name="btn", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=5,y=-45, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_greenroundbutton_normal", isArmature=0},{name="common_greenroundbutton_down", isArmature=0},{name="garyButton", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_silver_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="silver", isArmature=0}} }
         }
      },
    {type="armature", name="hero_name_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="heroNameBg", isArmature=0}} }
         }
      },
    {type="armature", name="already_recruit", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="already_recruit2", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_bluelonground_button", 
      bones={           
           {type="b", name="common_bluelonground_button", x=-76, y=26, kx=0, ky=0, cx=1, cy=1, z=0, text={x=-28,y=-18, w=114, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_bluelonground_button_normal", isArmature=0},{name="common_copy_bluelonground_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_bluebutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_close_button_normal", isArmature=0},{name="common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_blueround_button", 
      bones={           
           {type="b", name="common_blueround_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=7,y=-44, w=100, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_blueround_button_normal", isArmature=0},{name="common_copy_blueround_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="rule_bg", 
      bones={           
           {type="b", name="bg", x=0, y=310, kx=0, ky=0, cx=12.4, cy=6.89, z=0, d={{name="common_border_inner01", isArmature=0}} }
         }
      },
    {type="armature", name="rule_pop", 
      bones={           
           {type="b", name="hit_area", x=0, y=310, kx=0, ky=0, cx=139.5, cy=77.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_popup_panel_bg", x=0, y=310, kx=0, ky=0, cx=12.4, cy=6.89, z=1, d={{name="common_border_inner01", isArmature=0}} },
           {type="b", name="descb", x=110.5, y=266.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=20,y=25, w=520, h=260,lineType="single line",size=18,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="silver_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="needSilverBg", isArmature=0}} }
         }
      },
    {type="armature", name="tatter_desc_bg", 
      bones={           
           {type="b", name="bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="tatter_bg", isArmature=0}} }
         }
      },
    {type="armature", name="高级刷新按钮/advanced_refresh_btn", 
      bones={           
           {type="b", name="btn", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=10,y=-41, w=98, h=28,lineType="single line",size=18,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="高级刷新按钮/advanced_refresh_btn_normal", isArmature=0},{name="高级刷新按钮/advanced_refresh_btn_touch", isArmature=0}} },
           {type="b", name="btn_text", x=138.7, y=-18.05, kx=0, ky=0, cx=1, cy=1, z=1, text={x=128,y=-41, w=52, h=28,lineType="single line",size=18,color="ffffff",alignment="right",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="btn_text2", x=103.55, y=-36, kx=0, ky=0, cx=1, cy=1, z=2, text={x=31,y=-41, w=131, h=28,lineType="single line",size=18,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="积分兑换按钮/score_btn", 
      bones={           
           {type="b", name="btn", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="积分兑换按钮/score_btn_normal", isArmature=0},{name="积分兑换按钮/score_btn_touch", isArmature=0}} }
         }
      },
    {type="armature", name="普通刷新按钮/general_refresh_btn", 
      bones={           
           {type="b", name="btn", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=18,y=-44, w=163, h=28,lineType="single line",size=18,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="普通刷新按钮/general_refresh_btn_normal", isArmature=0},{name="普通刷新按钮/general_refresh_btn_touch", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="currency_bg_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="currency_bg", sc=1, dl=0, f={
                {x=0, y=50, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hero_card_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hero_cardBg", sc=1, dl=0, f={
                {x=0, y=323, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_name_text", sc=1, dl=0, f={
                {x=34.45, y=191.55, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid", sc=1, dl=0, f={
                {x=-33, y=356, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_item_num_text", sc=1, dl=0, f={
                {x=18.45, y=301.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_name_bg", sc=1, dl=0, f={
                {x=53, y=447.35, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hero_left_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="hero_right_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="hero_ui", 
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
           {name="card_big_bg", sc=1, dl=0, f={
                {x=0, y=417.6, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="card_position", sc=1, dl=0, f={
                {x=73.35, y=410.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=264.05, y=477.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_bluelonground_button", sc=1, dl=0, f={
                {x=401.45, y=61.25, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="score_icon", sc=1, dl=0, f={
                {x=302.95, y=90.7, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rCountText", sc=1, dl=0, f={
                {x=169.5, y=116.60000000000002, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rCount", sc=1, dl=0, f={
                {x=281.65, y=116.60000000000002, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gFreeRefreshTime", sc=1, dl=0, f={
                {x=126.3, y=25.649999999999977, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gFreeRefreshText", sc=1, dl=0, f={
                {x=246, y=12.449999999999989, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="aFreeRefreshTime", sc=1, dl=0, f={
                {x=558.2, y=30, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="aFreeRefreshText", sc=1, dl=0, f={
                {x=681.5, y=17.149999999999977, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="general_refresh_btn", sc=1, dl=0, f={
                {x=74.35, y=89, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="refesh_gold_putong", sc=1, dl=0, f={
                {x=182.8, y=71.14999999999998, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="advanced_refresh_btn", sc=1, dl=0, f={
                {x=506.85, y=87, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_firstGradeHero", sc=1, dl=0, f={
                {x=608.8, y=153, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_firstSuccess", sc=1, dl=0, f={
                {x=516.45, y=114, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_againSuccess", sc=1, dl=0, f={
                {x=440.45, y=114.14999999999998, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_numPos", sc=1, dl=0, f={
                {x=499.95, y=92, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=716.35, y=79.19999999999999, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg", sc=1, dl=0, f={
                {x=132, y=457, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="refesh_gold_gaoji", sc=1, dl=0, f={
                {x=615.3, y=72.14999999999998, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_silver_descb", sc=1, dl=0, f={
                {x=190.45, y=458.7, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_gold_descb", sc=1, dl=0, f={
                {x=93.35, y=458.65, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button_1", sc=1, dl=0, f={
                {x=682.7, y=475.1, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_gold_bg1", sc=1, dl=0, f={
                {x=12, y=457, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_money_value_text", sc=1, dl=0, f={
                {x=460.5, y=107.55, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rule_text", sc=1, dl=0, f={
                {x=598.65, y=459, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="card_big_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=266.67, cy=100.33, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line1", sc=1, dl=0, f={
                {x=45, y=-2, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line2", sc=1, dl=0, f={
                {x=45, y=-297.85, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hero_card", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_greenroundbutton", sc=1, dl=0, f={
                {x=31.5, y=-219.9, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_bg", sc=1, dl=0, f={
                {x=19.85, y=-184.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg", sc=1, dl=0, f={
                {x=25, y=-190.3, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_name_bg", sc=1, dl=0, f={
                {x=132, y=-27.3, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tatter_desc_bg", sc=1, dl=0, f={
                {x=11.85, y=14.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tatter_desc_text_bg1", sc=1, dl=0, f={
                {x=162, y=-9.6, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tatter_desc_text_bg2", sc=1, dl=0, f={
                {x=162, y=-31.3, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="already_recruit", sc=1, dl=0, f={
                {x=-12.65, y=-164.3, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="card_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_greenroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=2, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_silver_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="hero_name_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="already_recruit", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_bluelonground_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=-76, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=-76, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_bluelonground_button", sc=1, dl=0, f={
                {x=-76, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
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
    {type="animation", name="rule_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=310, kx=0, ky=0, cx=12.4, cy=6.89, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rule_pop", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=310, kx=0, ky=0, cx=139.5, cy=77.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_popup_panel_bg", sc=1, dl=0, f={
                {x=0, y=310, kx=0, ky=0, cx=12.4, cy=6.89, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=110.5, y=266.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="silver_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="tatter_desc_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="高级刷新按钮/advanced_refresh_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_text", sc=1, dl=0, f={
                {x=138.7, y=-18.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_text2", sc=1, dl=0, f={
                {x=103.55, y=-36, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_text", sc=1, dl=0, f={
                {x=138.7, y=-18.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_text2", sc=1, dl=0, f={
                {x=103.55, y=-36, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="积分兑换按钮/score_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="普通刷新按钮/general_refresh_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      }
  }
}
 return conf;