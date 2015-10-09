local conf = {type="skeleton", name="hero_team_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="blood_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=133, kx=0, ky=0, cx=38.75, cy=33.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="dead", x=28, y=132.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="dead", isArmature=0}} },
           {type="b", name="background1", x=3, y=38, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="background", isArmature=0}} },
           {type="b", name="hp_pro", x=10, y=30.90000000000001, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="hp_pro", isArmature=0}} }
         }
      },
    {type="armature", name="chosen_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=85, kx=0, ky=0, cx=52, cy=21.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="right_list_bg", x=0, y=85, kx=0, ky=0, cx=2.08, cy=0.85, z=1, text={x=91,y=26, w=110, h=31,lineType="single line",size=20,color="512116",alignment="left",space=0,textType="static"}, d={{name="right_list_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=11, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="imgs", 
      bones={           
           {type="b", name="图层 2", x=33.5, y=165.05, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="selected_img", isArmature=0}} },
           {type="b", name="图层 3", x=33.5, y=258.1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="lock", isArmature=0}} }
         }
      },
    {type="armature", name="peibing_kapai_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70.5, y=676, kx=0, ky=0, cx=1, cy=0.96, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=901, y=596, kx=0, ky=0, cx=2.8, cy=6.28, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="bg_2", x=107, y=598, kx=0, ky=0, cx=9.9, cy=6.19, z=3, d={{name="left_bg", isArmature=0}} },
           {type="b", name="bg_3", x=125, y=579.5, kx=0, ky=0, cx=21.65, cy=14.21, z=4, d={{name="small_bg", isArmature=0}} },
           {type="b", name="common_biaoti_bg", x=86.95, y=666, kx=0, ky=0, cx=2.31, cy=1, z=5, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=470.9, y=666, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="title_bg", x=906, y=594, kx=0, ky=0, cx=4.89, cy=1.04, z=7, text={x=936,y=549, w=162, h=39,lineType="single line",size=26,color="ffeac5",alignment="center",space=0,textType="static"}, d={{name="commonGrids/common_copy_grid_7", isArmature=0}} },
           {type="b", name="close_btn", x=1155, y=708, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1070, y=701, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="peibing_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70.5, y=676, kx=0, ky=0, cx=1, cy=0.96, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=107, y=643.5, kx=0, ky=0, cx=3.23, cy=6.89, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="bg_2", x=387.75, y=643.5, kx=0, ky=0, cx=10, cy=6.15, z=3, d={{name="left_bg", isArmature=0}} },
           {type="b", name="zhanli_bg", x=387.75, y=121, kx=0, ky=0, cx=3.36, cy=1, z=4, d={{name="zhanli_bg", isArmature=0}} },
           {type="b", name="btn_right", x=1066.5, y=154, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_fightbutton_normal", isArmature=0}} },
           {type="b", name="btn_left", x=824.6, y=121.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="bg_3", x=998, y=622.5, kx=0, ky=0, cx=1.83, cy=5.79, z=7, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="title_bg", x=109, y=642, kx=0, ky=0, cx=5.78, cy=1.04, z=8, d={{name="commonGrids/common_copy_grid_7", isArmature=0}} },
           {type="b", name="slot_l_3", x=720, y=258, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_6", x=570, y=258, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_9", x=420, y=258, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_2", x=774, y=362, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_5", x=624, y=362, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_8", x=474, y=362, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_1", x=828, y=466, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_4", x=678, y=466, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_7", x=528, y=466, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_1_over", x=828, y=466, kx=0, ky=0, cx=1, cy=1, z=18, text={x=940,y=411, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_2_over", x=774, y=362, kx=0, ky=0, cx=1, cy=1, z=19, text={x=886,y=307, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_3_over", x=720, y=258, kx=0, ky=0, cx=1, cy=1, z=20, text={x=832,y=203, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_4_over", x=678, y=466, kx=0, ky=0, cx=1, cy=1, z=21, text={x=790,y=411, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_5_over", x=624, y=362, kx=0, ky=0, cx=1, cy=1, z=22, text={x=736,y=307, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_6_over", x=570, y=258, kx=0, ky=0, cx=1, cy=1, z=23, text={x=682,y=203, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_7_over", x=528, y=466, kx=0, ky=0, cx=1, cy=1, z=24, text={x=640,y=411, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_8_over", x=474, y=362, kx=0, ky=0, cx=1, cy=1, z=25, text={x=586,y=307, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_9_over", x=420, y=258, kx=0, ky=0, cx=1, cy=1, z=26, text={x=532,y=203, w=26, h=116,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="tab_2", x=0, y=525, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonButtons/common_copy_tab_button", isArmature=1}} },
           {type="b", name="tab_1", x=0, y=652, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="commonButtons/common_copy_tab_button", isArmature=1}} },
           {type="b", name="close_btn", x=1155, y=708, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1070, y=701, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} },
           {type="b", name="zhenfa_descb", x=531.8, y=590.05, kx=0, ky=0, cx=1, cy=1, z=31, text={x=412,y=579, w=410, h=41,lineType="single line",size=28,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhenfa_descb_1", x=647.95, y=590.05, kx=0, ky=0, cx=1, cy=1, z=32, text={x=520,y=582, w=410, h=31,lineType="single line",size=20,color="4a1205",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb", x=645.8, y=185.1, kx=0, ky=0, cx=1, cy=1, z=33, text={x=635,y=146, w=327, h=34,lineType="single line",size=22,color="ffd200",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_tab_button", 
      bones={           
           {type="b", name="common_tab_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_tab_button_normal", isArmature=0},{name="commonButtons/common_copy_tab_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="right_list_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=140, kx=0, ky=0, cx=34.25, cy=35, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="right_list_bg", x=0, y=140, kx=0, ky=0, cx=1.37, cy=1.4, z=1, d={{name="right_list_bg", isArmature=0}} },
           {type="b", name="bg", x=15.55, y=136, kx=0, ky=0, cx=1, cy=1, z=2, text={x=6,y=4, w=126, h=31,lineType="single line",size=20,color="512116",alignment="center",space=0,textType="static"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="blood_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=133, kx=0, ky=0, cx=38.75, cy=33.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dead", sc=1, dl=0, f={
                {x=28, y=132.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background1", sc=1, dl=0, f={
                {x=3, y=38, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hp_pro", sc=1, dl=0, f={
                {x=10, y=30.90000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chosen_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=85, kx=0, ky=0, cx=52, cy=21.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_list_bg", sc=1, dl=0, f={
                {x=0, y=85, kx=0, ky=0, cx=2.08, cy=0.85, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_small_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=33.5, y=165.05, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=33.5, y=258.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=33.5, y=165.05, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=33.5, y=258.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="peibing_kapai_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70.5, y=676, kx=0, ky=0, cx=1, cy=0.96, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=901, y=596, kx=0, ky=0, cx=2.8, cy=6.28, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=107, y=598, kx=0, ky=0, cx=9.9, cy=6.19, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_3", sc=1, dl=0, f={
                {x=125, y=579.5, kx=0, ky=0, cx=21.65, cy=14.21, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_biaoti_bg", sc=1, dl=0, f={
                {x=86.95, y=666, kx=0, ky=0, cx=2.31, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=470.9, y=666, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=906, y=594, kx=0, ky=0, cx=4.89, cy=1.04, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1155, y=708, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1070, y=701, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="peibing_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70.5, y=676, kx=0, ky=0, cx=1, cy=0.96, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=107, y=643.5, kx=0, ky=0, cx=3.23, cy=6.89, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=387.75, y=643.5, kx=0, ky=0, cx=10, cy=6.15, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_bg", sc=1, dl=0, f={
                {x=387.75, y=121, kx=0, ky=0, cx=3.36, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_right", sc=1, dl=0, f={
                {x=1066.5, y=154, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_left", sc=1, dl=0, f={
                {x=824.6, y=121.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_3", sc=1, dl=0, f={
                {x=998, y=622.5, kx=0, ky=0, cx=1.83, cy=5.79, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=109, y=642, kx=0, ky=0, cx=5.78, cy=1.04, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_3", sc=1, dl=0, f={
                {x=720, y=258, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_6", sc=1, dl=0, f={
                {x=570, y=258, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_9", sc=1, dl=0, f={
                {x=420, y=258, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_2", sc=1, dl=0, f={
                {x=774, y=362, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_5", sc=1, dl=0, f={
                {x=624, y=362, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_8", sc=1, dl=0, f={
                {x=474, y=362, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_1", sc=1, dl=0, f={
                {x=828, y=466, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_4", sc=1, dl=0, f={
                {x=678, y=466, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_7", sc=1, dl=0, f={
                {x=528, y=466, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_1_over", sc=1, dl=0, f={
                {x=828, y=466, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_2_over", sc=1, dl=0, f={
                {x=774, y=362, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_3_over", sc=1, dl=0, f={
                {x=720, y=258, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_4_over", sc=1, dl=0, f={
                {x=678, y=466, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_5_over", sc=1, dl=0, f={
                {x=624, y=362, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_6_over", sc=1, dl=0, f={
                {x=570, y=258, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_7_over", sc=1, dl=0, f={
                {x=528, y=466, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_8_over", sc=1, dl=0, f={
                {x=474, y=362, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_9_over", sc=1, dl=0, f={
                {x=420, y=258, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_2", sc=1, dl=0, f={
                {x=0, y=525, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_1", sc=1, dl=0, f={
                {x=0, y=652, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1155, y=708, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1070, y=701, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_descb", sc=1, dl=0, f={
                {x=531.8, y=590.05, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenfa_descb_1", sc=1, dl=0, f={
                {x=647.95, y=590.05, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=645.8, y=185.1, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      },
    {type="animation", name="commonButtons/common_copy_tab_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_tab_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="right_list_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=140, kx=0, ky=0, cx=34.25, cy=35, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_list_bg", sc=1, dl=0, f={
                {x=0, y=140, kx=0, ky=0, cx=1.37, cy=1.4, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=15.55, y=136, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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