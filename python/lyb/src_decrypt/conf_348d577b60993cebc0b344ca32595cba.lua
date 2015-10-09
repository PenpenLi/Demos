local conf = {type="skeleton", name="rank_list_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="detail_ui", 
      bones={           
           {type="b", name="detail_bg", x=0, y=465, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="detail_bg", isArmature=0}} },
           {type="b", name="name_bg", x=44, y=387, kx=0, ky=0, cx=1, cy=1, z=1, text={x=24,y=354, w=279, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="imgs/name_bg", isArmature=0}} },
           {type="b", name="level_descb", x=163, y=334.1, kx=0, ky=0, cx=1, cy=1, z=2, text={x=73,y=317, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb", x=163, y=305.1, kx=0, ky=0, cx=1, cy=1, z=3, text={x=73,y=288, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="detail_ui_bangpai", 
      bones={           
           {type="b", name="detail_bg", x=0, y=465, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="detail_bg", isArmature=0}} },
           {type="b", name="name_bg", x=44, y=387, kx=0, ky=0, cx=1, cy=1, z=1, text={x=24,y=354, w=279, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="imgs/name_bg", isArmature=0}} },
           {type="b", name="shili_descb", x=163, y=329.1, kx=0, ky=0, cx=1, cy=1, z=2, text={x=66,y=312, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_descb", x=163, y=295.1, kx=0, ky=0, cx=1, cy=1, z=3, text={x=66,y=278, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangzhong_descb", x=163, y=261.1, kx=0, ky=0, cx=1, cy=1, z=4, text={x=66,y=244, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangzhu_descb", x=163, y=227.1, kx=0, ky=0, cx=1, cy=1, z=5, text={x=66,y=210, w=200, h=34,lineType="single line",size=22,color="000000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="图层 3", x=65.5, y=200.6, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="gaoshi_bg", isArmature=0}} },
           {type="b", name="descb", x=65.5, y=151.60000000000002, kx=0, ky=0, cx=2.38, cy=1.28, z=7, text={x=74,y=50, w=190, h=96,lineType="single line",size=22,color="ffecda",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} }
         }
      },
    {type="armature", name="images", 
      bones={           
           {type="b", name="图层 2", x=0, y=251, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="renwu_bg", isArmature=0}} },
           {type="b", name="图层 3", x=250, y=76.05000000000001, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="rank_1", isArmature=0}} },
           {type="b", name="图层 4", x=250, y=179.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="rank_2", isArmature=0}} },
           {type="b", name="图层 5", x=250, y=128.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="rank_3", isArmature=0}} }
         }
      },
    {type="armature", name="rank_item_title", 
      bones={           
           {type="b", name="title_1", x=173.1, y=-80, kx=0, ky=0, cx=1.78, cy=1, z=0, text={x=180,y=-123, w=67, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=253.1, y=-80, kx=0, ky=0, cx=5.11, cy=1, z=1, text={x=274,y=-123, w=190, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=482.1, y=-80, kx=0, ky=0, cx=3, cy=1, z=2, text={x=498,y=-123, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_4", x=617.1, y=-80, kx=0, ky=0, cx=10.69, cy=1, z=3, text={x=712,y=-123, w=292, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rank_item_title_bangpai", 
      bones={           
           {type="b", name="title_1", x=173.1, y=-80, kx=0, ky=0, cx=1.78, cy=1, z=0, text={x=180,y=-123, w=67, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=253.1, y=-80, kx=0, ky=0, cx=4.98, cy=1, z=1, text={x=271,y=-123, w=190, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=476.1, y=-80, kx=0, ky=0, cx=6, cy=1, z=2, text={x=560,y=-123, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_4", x=746.1, y=-80, kx=0, ky=0, cx=3.82, cy=1, z=3, text={x=758,y=-123, w=150, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_5", x=918.1, y=-80, kx=0, ky=0, cx=4, cy=1, z=4, text={x=924,y=-123, w=170, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rank_item_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=231.25, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=9.44, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="player_bg", x=90.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, text={x=179,y=49, w=158, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_player_bg", isArmature=0}} },
           {type="b", name="level_descb", x=176.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=179,y=8, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rank_descb", x=28, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=10,y=29, w=68, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb", x=332, y=49.95, kx=0, ky=0, cx=1, cy=1, z=5, text={x=304,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rank_item_ui_bangpai", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=231.25, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=9.44, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="bangpai_descb", x=104.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=2, text={x=117,y=49, w=182, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangpai_level_descb", x=104.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=117,y=8, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="player_bg", x=328.45, y=87, kx=0, ky=0, cx=1, cy=1, z=4, text={x=417,y=49, w=158, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_player_bg", isArmature=0}} },
           {type="b", name="level_descb", x=404.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=5, text={x=417,y=8, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rank_descb", x=28, y=49.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=10,y=29, w=68, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1", x=610, y=49.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=582,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2", x=782, y=49.95, kx=0, ky=0, cx=1, cy=1, z=8, text={x=754,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rank_list_detail_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg_1", x=131, y=616.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="detail_bg_1", isArmature=0}} },
           {type="b", name="bg_2", x=170, y=595, kx=0, ky=0, cx=11.46, cy=6.46, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="rank_list_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="title_bg_1", x=170, y=580, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="title_bg", isArmature=0}} },
           {type="b", name="title_bg_2", x=379.35, y=580, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="title_bg", isArmature=0}} },
           {type="b", name="title_bg_3", x=588.7, y=580, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="title_bg", isArmature=0}} },
           {type="b", name="title_bg_4", x=798.05, y=580, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="title_bg", isArmature=0}} },
           {type="b", name="title_bg_5", x=1007.4, y=580, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="title_bg", isArmature=0}} },
           {type="b", name="title_1", x=199, y=478, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="title_1", isArmature=0}} },
           {type="b", name="title_2", x=408.5, y=478, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="title_2", isArmature=0}} },
           {type="b", name="title_3", x=618, y=478, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="title_3", isArmature=0}} },
           {type="b", name="title_4", x=827.5, y=478, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="title_4", isArmature=0}} },
           {type="b", name="title_5", x=1037, y=478, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="title_5", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="rank_pop_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="bangdan_img", x=40, y=695, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="bangdan_img", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="xiugaigonggao_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=363, kx=0, ky=0, cx=137.5, cy=90, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_4", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=34.5, y=315.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="common_close_button", x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="common_blueround_button", x=170.5, y=87, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="input", x=71, y=219.45, kx=0, ky=0, cx=15.6, cy=2.37, z=5, text={x=82,y=171, w=369, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="common_descb", x=159.95, y=263.05, kx=0, ky=0, cx=1, cy=1, z=6, text={x=61,y=243, w=410, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="detail_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="detail_bg", sc=1, dl=0, f={
                {x=0, y=465, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=44, y=387, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=163, y=334.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=163, y=305.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="detail_ui_bangpai", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="detail_bg", sc=1, dl=0, f={
                {x=0, y=465, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=44, y=387, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shili_descb", sc=1, dl=0, f={
                {x=163, y=329.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=163, y=295.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangzhong_descb", sc=1, dl=0, f={
                {x=163, y=261.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangzhu_descb", sc=1, dl=0, f={
                {x=163, y=227.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=65.5, y=200.6, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=65.5, y=151.60000000000002, kx=0, ky=0, cx=2.38, cy=1.28, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="images", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=0, y=251, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=250, y=76.05000000000001, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=250, y=179.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 5", sc=1, dl=0, f={
                {x=250, y=128.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_item_title", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="title_1", sc=1, dl=0, f={
                {x=173.1, y=-80, kx=0, ky=0, cx=1.78, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=253.1, y=-80, kx=0, ky=0, cx=5.11, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=482.1, y=-80, kx=0, ky=0, cx=3, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=617.1, y=-80, kx=0, ky=0, cx=10.69, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_item_title_bangpai", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="title_1", sc=1, dl=0, f={
                {x=173.1, y=-80, kx=0, ky=0, cx=1.78, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=253.1, y=-80, kx=0, ky=0, cx=4.98, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=476.1, y=-80, kx=0, ky=0, cx=6, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=746.1, y=-80, kx=0, ky=0, cx=3.82, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=918.1, y=-80, kx=0, ky=0, cx=4, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_item_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=231.25, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=9.44, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=90.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=176.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_descb", sc=1, dl=0, f={
                {x=28, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=332, y=49.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_item_ui_bangpai", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=231.25, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=9.44, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_descb", sc=1, dl=0, f={
                {x=104.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_level_descb", sc=1, dl=0, f={
                {x=104.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=328.45, y=87, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=404.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_descb", sc=1, dl=0, f={
                {x=28, y=49.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=610, y=49.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=782, y=49.95, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_list_detail_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=131, y=616.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=170, y=595, kx=0, ky=0, cx=11.46, cy=6.46, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_list_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg_1", sc=1, dl=0, f={
                {x=170, y=580, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg_2", sc=1, dl=0, f={
                {x=379.35, y=580, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg_3", sc=1, dl=0, f={
                {x=588.7, y=580, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg_4", sc=1, dl=0, f={
                {x=798.05, y=580, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg_5", sc=1, dl=0, f={
                {x=1007.4, y=580, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=199, y=478, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=408.5, y=478, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=618, y=478, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=827.5, y=478, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=1037, y=478, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rank_pop_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=690, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1070, y=683, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangdan_img", sc=1, dl=0, f={
                {x=40, y=695, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_ask_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="xiugaigonggao_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=363, kx=0, ky=0, cx=137.5, cy=90, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_4", sc=1, dl=0, f={
                {x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_3", sc=1, dl=0, f={
                {x=34.5, y=315.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blueround_button", sc=1, dl=0, f={
                {x=170.5, y=87, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input", sc=1, dl=0, f={
                {x=71, y=219.45, kx=0, ky=0, cx=15.6, cy=2.37, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_descb", sc=1, dl=0, f={
                {x=159.95, y=263.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;