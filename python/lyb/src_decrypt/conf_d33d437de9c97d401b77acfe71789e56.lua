local conf = {type="skeleton", name="vip_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="vip_pay_render", 
      bones={           
           {type="b", name="vip_pay_bg", x=0, y=133, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="component/vip_pay_bg", isArmature=0}} },
           {type="b", name="itemTmp", x=89.8, y=64.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_image_separator", x=148.3, y=68.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="pay_ttl2_TF", x=164.95, y=60.400000000000006, kx=0, ky=0, cx=1, cy=1, z=3, text={x=165,y=21, w=351, h=39,lineType="multiline",size=25,color="b33b01",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="pay_ttl1_TF", x=385.8, y=119.1, kx=0, ky=0, cx=1, cy=1, z=4, text={x=379,y=78, w=104, h=39,lineType="multiline",size=26,color="b33b01",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="pay_ttl_TF", x=164.95, y=118.65, kx=0, ky=0, cx=1, cy=1, z=5, text={x=165,y=73, w=250, h=45,lineType="multiline",size=28,color="000600",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="vip_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_1", x=75.8, y=673.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="right_bg", x=585.45, y=574.65, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/right_bg", isArmature=0}} },
           {type="b", name="right_tmp", x=617.8, y=84.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="vip_infoPage", x=114.35, y=572.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="vip_lvl_info_render", isArmature=1}} },
           {type="b", name="ttl_bg", x=118.35, y=637.15, kx=0, ky=0, cx=3.15, cy=1, z=5, d={{name="component/ttl_bg", isArmature=0}} },
           {type="b", name="vip_num1_con", x=1100.25, y=593.65, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="vip_num_con", x=301.75, y=593.2, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_progress_bar", x=353.95, y=630.2, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonProgressBars/common_progress_bar", isArmature=1}} },
           {type="b", name="common_copy_gold_bg", x=726.8, y=639.65, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="vipTtlTF", x=906.95, y=634.4, kx=0, ky=0, cx=1, cy=1, z=10, text={x=790,y=595, w=211, h=39,lineType="multiline",size=26,color="ffc800",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="vipCountTF", x=633.75, y=622.05, kx=0, ky=0, cx=1, cy=1, z=11, text={x=634,y=595, w=97, h=39,lineType="multiline",size=26,color="ffc800",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="vipMaxTF", x=811.75, y=622.05, kx=0, ky=0, cx=1, cy=1, z=12, text={x=658,y=595, w=436, h=39,lineType="multiline",size=26,color="ffc800",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="dangqianTF", x=144.95, y=638.65, kx=0, ky=0, cx=1, cy=1, z=13, text={x=145,y=595, w=59, h=39,lineType="multiline",size=26,color="ffc800",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_vip_ttl_1", x=1009.25, y=631.2, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="component/common_vip_ttl", isArmature=0}} },
           {type="b", name="common_vip_ttl", x=208.25, y=631.2, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="component/common_vip_ttl", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="vip_lvl_info_render", 
      bones={           
           {type="b", name="common_copy_niupizhi", x=0.35, y=-0.35, kx=0, ky=0, cx=5.54, cy=6.36, z=0, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="msg_bg", x=10.85, y=-58.8, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/msg_bg", isArmature=0}} },
           {type="b", name="msg_bg_1", x=10.85, y=-134.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/msg_bg", isArmature=0}} },
           {type="b", name="msg_bg_2", x=10.85, y=-212.8, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/msg_bg", isArmature=0}} },
           {type="b", name="msg_bg_3", x=10.85, y=-289.8, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/msg_bg", isArmature=0}} },
           {type="b", name="msg_bg_4", x=10.85, y=-367.8, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/msg_bg", isArmature=0}} },
           {type="b", name="common_copy_blue_button_2", x=233.85, y=-422.85, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_blue_button_1", x=28.85, y=-422.8, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="l_ttl_bg", x=14.35, y=1.15, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/l_ttl_bg", isArmature=0}} },
           {type="b", name="l_ttl_bg_up", x=62, y=-6.35, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="component/l_ttl_bg_up", isArmature=0}} },
           {type="b", name="info_TF", x=39.95, y=-73.05, kx=0, ky=0, cx=1, cy=1, z=10, text={x=28,y=-96, w=401, h=39,lineType="multiline",size=26,color="ffc800",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ttl_TF", x=115.85, y=-47.85, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="vipNum", x=196.85, y=-41.85, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="tequan", x=250.35, y=-8, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="component/tequan", isArmature=0}} },
           {type="b", name="vip", x=110.35, y=-8.5, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="component/common_vip_ttl", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBars/common_progress_bar", 
      bones={           
           {type="b", name="pro_down", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBars/common_pg_bg", isArmature=0}} },
           {type="b", name="pro_up", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBars/common_pg_bar", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="vip_pay_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="vip_pay_bg", sc=1, dl=0, f={
                {x=0, y=133, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=89.8, y=64.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_image_separator", sc=1, dl=0, f={
                {x=148.3, y=68.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pay_ttl2_TF", sc=1, dl=0, f={
                {x=164.95, y=60.400000000000006, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pay_ttl1_TF", sc=1, dl=0, f={
                {x=385.8, y=119.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pay_ttl_TF", sc=1, dl=0, f={
                {x=164.95, y=118.65, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="vip_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_1", sc=1, dl=0, f={
                {x=75.8, y=673.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_bg", sc=1, dl=0, f={
                {x=585.45, y=574.65, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="right_tmp", sc=1, dl=0, f={
                {x=617.8, y=84.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip_infoPage", sc=1, dl=0, f={
                {x=114.35, y=572.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttl_bg", sc=1, dl=0, f={
                {x=118.35, y=637.15, kx=0, ky=0, cx=3.15, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip_num1_con", sc=1, dl=0, f={
                {x=1100.25, y=593.65, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip_num_con", sc=1, dl=0, f={
                {x=301.75, y=593.2, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_progress_bar", sc=1, dl=0, f={
                {x=353.95, y=630.2, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_gold_bg", sc=1, dl=0, f={
                {x=726.8, y=639.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipTtlTF", sc=1, dl=0, f={
                {x=906.95, y=634.4, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipCountTF", sc=1, dl=0, f={
                {x=633.75, y=622.05, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipMaxTF", sc=1, dl=0, f={
                {x=811.75, y=622.05, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dangqianTF", sc=1, dl=0, f={
                {x=144.95, y=638.65, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip_ttl_1", sc=1, dl=0, f={
                {x=1009.25, y=631.2, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip_ttl", sc=1, dl=0, f={
                {x=208.25, y=631.2, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=694, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="vip_lvl_info_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_niupizhi", sc=1, dl=0, f={
                {x=0.35, y=-0.35, kx=0, ky=0, cx=5.54, cy=6.36, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg_bg", sc=1, dl=0, f={
                {x=10.85, y=-58.8, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg_bg_1", sc=1, dl=0, f={
                {x=10.85, y=-134.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg_bg_2", sc=1, dl=0, f={
                {x=10.85, y=-212.8, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg_bg_3", sc=1, dl=0, f={
                {x=10.85, y=-289.8, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msg_bg_4", sc=1, dl=0, f={
                {x=10.85, y=-367.8, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button_2", sc=1, dl=0, f={
                {x=233.85, y=-422.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button_1", sc=1, dl=0, f={
                {x=28.85, y=-422.8, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="l_ttl_bg", sc=1, dl=0, f={
                {x=14.35, y=1.15, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="l_ttl_bg_up", sc=1, dl=0, f={
                {x=62, y=-6.35, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="info_TF", sc=1, dl=0, f={
                {x=39.95, y=-73.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttl_TF", sc=1, dl=0, f={
                {x=115.85, y=-47.85, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipNum", sc=1, dl=0, f={
                {x=196.85, y=-41.85, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tequan", sc=1, dl=0, f={
                {x=250.35, y=-8, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip", sc=1, dl=0, f={
                {x=110.35, y=-8.5, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      },
    {type="animation", name="commonProgressBars/common_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pro_down", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pro_up", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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