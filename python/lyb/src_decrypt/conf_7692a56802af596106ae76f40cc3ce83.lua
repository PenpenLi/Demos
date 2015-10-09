local conf = {type="skeleton", name="family_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="bangpai_info_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70.5, y=676, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="info_bg", x=100, y=637.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="info_bg", isArmature=0}} },
           {type="b", name="huoyuedu_bg", x=398.15, y=635.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="huoyuedu_bg", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=128, y=596.5, kx=0, ky=0, cx=2.8, cy=6.16, z=4, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="title", x=123, y=596.5, kx=0, ky=0, cx=5.33, cy=1, z=5, text={x=143,y=552, w=200, h=41,lineType="single line",size=28,color="ffb400",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="level_descb", x=211.05, y=523.45, kx=0, ky=0, cx=1, cy=1, z=6, text={x=145,y=501, w=180, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="paiming_descb", x=211.05, y=490.45, kx=0, ky=0, cx=1, cy=1, z=7, text={x=145,y=467, w=180, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="renshu_descb", x=211.05, y=456.45, kx=0, ky=0, cx=1, cy=1, z=8, text={x=145,y=432, w=180, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="line", x=133, y=422.6, kx=0, ky=0, cx=6.67, cy=1, z=9, d={{name="line", isArmature=0}} },
           {type="b", name="huoyuedu_wenzi_bg", x=413.3, y=600, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="huoyuedu_wenzi_bg", isArmature=0}} },
           {type="b", name="huoyuedu_progress_bar", x=525.7, y=595.5, kx=0, ky=0, cx=1, cy=1, z=11, text={x=583,y=561, w=320, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonProgressBar/common_copy_blue_progress_bar", isArmature=1}} },
           {type="b", name="huoyuedu_jiangli", x=953.7, y=630, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="huoyuedu_jiangli", isArmature=0}} },
           {type="b", name="rizhi_img", x=1052, y=628, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="rizhi_img", isArmature=0}} },
           {type="b", name="blue_btn_1", x=147.5, y=369, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="blue_btn_2", x=147.5, y=272, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="blue_btn_3", x=147.5, y=175, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="red_btn_1", x=147.5, y=369, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="red_btn_2", x=147.5, y=272, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="red_btn_3", x=147.5, y=175, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="tanhe_descb", x=211.05, y=296.45, kx=0, ky=0, cx=1, cy=1, z=20, text={x=135,y=275, w=252, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="close_btn", x=1151, y=700, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1066, y=693, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} },
           {type="b", name="zhaoren_img", x=286, y=479.55, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="zhaoren_img", isArmature=0}} },
           {type="b", name="effect1", x=315, y=278, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="bangpai_member_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=192.5, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=7.86, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="player_bg", x=12.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, text={x=101,y=45, w=158, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_player_bg", isArmature=0}} },
           {type="b", name="level_descb", x=98.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=101,y=12, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhiwei_descb", x=262, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=234,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huoyuei_descb", x=370, y=49.95, kx=0, ky=0, cx=1, cy=1, z=5, text={x=342,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhanli_descb", x=494, y=49.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=466,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shijian_descb", x=640, y=49.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=612,y=29, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="bangpai_none_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=262.5, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=10.71, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="bg_for_search", x=0, y=93, kx=0, ky=0, cx=10.71, cy=1, z=2, d={{name="bg_for_search", isArmature=0}} },
           {type="b", name="player_bg", x=152, y=49.95, kx=0, ky=0, cx=1, cy=1, z=3, text={x=39,y=29, w=114, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangpai_name", x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=188,y=29, w=200, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bangzhu_descb", x=441.45, y=46.1, kx=0, ky=0, cx=1, cy=1, z=5, text={x=385,y=29, w=200, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_descb", x=619.45, y=43.05, kx=0, ky=0, cx=1, cy=1, z=6, text={x=563,y=29, w=200, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="renshu_descb", x=758.45, y=40.1, kx=0, ky=0, cx=1, cy=1, z=7, text={x=702,y=29, w=200, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="manyuan_descb", x=957.45, y=40.1, kx=0, ky=0, cx=1, cy=1, z=8, text={x=901,y=29, w=133, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shenqing_btn", x=902, y=74, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="quxiao_btn", x=902, y=74, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} }
         }
      },
    {type="armature", name="bangpai_none_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=70.5, y=676, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=107.5, y=640.5, kx=0, ky=0, cx=12.99, cy=7.23, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="close_btn", x=1151, y=700, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1066, y=693, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} },
           {type="b", name="title_1", x=112, y=634, kx=0, ky=0, cx=4.11, cy=1, z=5, text={x=144,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=297, y=634, kx=0, ky=0, cx=4.56, cy=1, z=6, text={x=339,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=502, y=634, kx=0, ky=0, cx=4.33, cy=1, z=7, text={x=539,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_4", x=697, y=634, kx=0, ky=0, cx=3.38, cy=1, z=8, text={x=712,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_5", x=849, y=634, kx=0, ky=0, cx=3, cy=1, z=9, text={x=856,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_6", x=984, y=634, kx=0, ky=0, cx=4.07, cy=1, z=10, text={x=1015,y=591, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="line", x=107.5, y=138, kx=0, ky=0, cx=32.27, cy=1, z=11, d={{name="line", isArmature=0}} },
           {type="b", name="input", x=130.45, y=124.60000000000002, kx=0, ky=0, cx=27.92, cy=2.71, z=12, text={x=141,y=73, w=687, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="find_button", x=852, y=120, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="found_button", x=995, y=120, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="bangpai_zhaoren_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=192.5, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=7.86, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="player_bg", x=12.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, text={x=101,y=45, w=158, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_player_bg", isArmature=0}} },
           {type="b", name="level_descb", x=98.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, text={x=101,y=12, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="paiming_descb", x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=216,y=29, w=200, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="tongyi_btn", x=590.15, y=74, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="jujue_btn", x=434.8, y=74, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="chengyuan_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=396, y=514.5, kx=0, ky=0, cx=9.57, cy=5.66, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="title_1", x=399, y=510, kx=0, ky=0, cx=5.82, cy=1, z=2, text={x=430,y=467, w=200, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=660, y=510, kx=0, ky=0, cx=2.13, cy=1, z=3, text={x=666,y=467, w=84, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=756, y=510, kx=0, ky=0, cx=2.78, cy=1, z=4, text={x=767,y=467, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_4", x=881, y=510, kx=0, ky=0, cx=2.78, cy=1, z=5, text={x=892,y=467, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_5", x=1006, y=510, kx=0, ky=0, cx=3.82, cy=1, z=6, text={x=1041,y=467, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=57, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_red_button_normal", isArmature=0},{name="commonButtons/common_copy_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=-43, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBar/common_copy_blue_progress_bar", 
      bones={           
           {type="b", name="common_blue_progress_bar_bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBar/common_copy_blue_progress_bar_bg", isArmature=0}} },
           {type="b", name="common_blue_progress_bar_fg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBar/common_copy_blue_progress_bar_fg", isArmature=0}} }
         }
      },
    {type="armature", name="huoyuedu_popup_item_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=96, kx=0, ky=0, cx=107.5, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=96, kx=0, ky=0, cx=4.39, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="huoyuedul_descb", x=17.85, y=49.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=6,y=32, w=116, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gold_descb", x=210, y=70.95, kx=0, ky=0, cx=1, cy=1, z=3, text={x=199,y=50, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silveri_descb", x=180.4, y=39.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=199,y=19, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="lingqu_btn", x=300, y=96, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_lingjiangli_img", isArmature=0}} },
           {type="b", name="yilingqu_descb", x=320, y=52.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=292,y=32, w=147, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="huoyuedu_popup_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=656, kx=0, ky=0, cx=129.5, cy=163, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_panel_3", x=0, y=632, kx=0, ky=0, cx=1, cy=0.95, z=1, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="title_bg", x=14, y=618.1, kx=0, ky=0, cx=0.97, cy=1, z=2, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="bg_1", x=28.5, y=516.5, kx=0, ky=0, cx=5.37, cy=5.98, z=3, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="huoyuedu_descb", x=266.85, y=550.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=35,y=519, w=226, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_mingzi_bg", isArmature=0}} },
           {type="b", name="title_1", x=32.5, y=510, kx=0, ky=0, cx=3, cy=1, z=5, text={x=38,y=463, w=125, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=167.5, y=510, kx=0, ky=0, cx=3.56, cy=1, z=6, text={x=180,y=463, w=137, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=327.5, y=510, kx=0, ky=0, cx=3, cy=1, z=7, text={x=344,y=463, w=104, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="common_close_button", x=444, y=656, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="rizhi_popup_item_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=93, kx=0, ky=0, cx=109.25, cy=23.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai_none_item_bg", x=0, y=93, kx=0, ky=0, cx=4.46, cy=1, z=1, d={{name="commonPanels/common_copy_item_bg", isArmature=0}} },
           {type="b", name="player_bg", x=174, y=49.95, kx=0, ky=0, cx=1, cy=1, z=2, text={x=43,y=12, w=254, h=65,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shijian_descb", x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=3, text={x=276,y=29, w=154, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rizhi_popup_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=656, kx=0, ky=0, cx=129.5, cy=163, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_panel_3", x=0, y=632, kx=0, ky=0, cx=1, cy=0.95, z=1, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="title_bg", x=14, y=618.1, kx=0, ky=0, cx=0.97, cy=1, z=2, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="bg_1", x=28.5, y=549.5, kx=0, ky=0, cx=5.37, cy=6.34, z=3, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_close_button", x=444, y=656, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
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
      },
    {type="armature", name="zhaoren_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=396, y=514.5, kx=0, ky=0, cx=9.57, cy=5.66, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="title_1", x=400, y=509, kx=0, ky=0, cx=5.82, cy=1, z=2, text={x=431,y=467, w=200, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=661, y=509, kx=0, ky=0, cx=3.07, cy=1, z=3, text={x=665,y=467, w=130, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=799, y=509, kx=0, ky=0, cx=8.44, cy=1, z=4, text={x=889,y=467, w=200, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="bangpai_info_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70.5, y=676, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="info_bg", sc=1, dl=0, f={
                {x=100, y=637.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedu_bg", sc=1, dl=0, f={
                {x=398.15, y=635.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=128, y=596.5, kx=0, ky=0, cx=2.8, cy=6.16, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=123, y=596.5, kx=0, ky=0, cx=5.33, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=211.05, y=523.45, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="paiming_descb", sc=1, dl=0, f={
                {x=211.05, y=490.45, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renshu_descb", sc=1, dl=0, f={
                {x=211.05, y=456.45, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=133, y=422.6, kx=0, ky=0, cx=6.67, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedu_wenzi_bg", sc=1, dl=0, f={
                {x=413.3, y=600, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedu_progress_bar", sc=1, dl=0, f={
                {x=525.7, y=595.5, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedu_jiangli", sc=1, dl=0, f={
                {x=953.7, y=630, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rizhi_img", sc=1, dl=0, f={
                {x=1052, y=628, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_btn_1", sc=1, dl=0, f={
                {x=147.5, y=369, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_btn_2", sc=1, dl=0, f={
                {x=147.5, y=272, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="blue_btn_3", sc=1, dl=0, f={
                {x=147.5, y=175, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_btn_1", sc=1, dl=0, f={
                {x=147.5, y=369, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_btn_2", sc=1, dl=0, f={
                {x=147.5, y=272, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_btn_3", sc=1, dl=0, f={
                {x=147.5, y=175, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tanhe_descb", sc=1, dl=0, f={
                {x=211.05, y=296.45, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1151, y=700, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1066, y=693, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhaoren_img", sc=1, dl=0, f={
                {x=286, y=479.55, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect1", sc=1, dl=0, f={
                {x=315, y=278, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="bangpai_member_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=192.5, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=7.86, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=12.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=98.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhiwei_descb", sc=1, dl=0, f={
                {x=262, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuei_descb", sc=1, dl=0, f={
                {x=370, y=49.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_descb", sc=1, dl=0, f={
                {x=494, y=49.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shijian_descb", sc=1, dl=0, f={
                {x=640, y=49.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="bangpai_none_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=262.5, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=10.71, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_for_search", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=10.71, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=152, y=49.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_name", sc=1, dl=0, f={
                {x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangzhu_descb", sc=1, dl=0, f={
                {x=441.45, y=46.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=619.45, y=43.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renshu_descb", sc=1, dl=0, f={
                {x=758.45, y=40.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="manyuan_descb", sc=1, dl=0, f={
                {x=957.45, y=40.1, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shenqing_btn", sc=1, dl=0, f={
                {x=902, y=74, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="quxiao_btn", sc=1, dl=0, f={
                {x=902, y=74, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="bangpai_none_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=70.5, y=676, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=107.5, y=640.5, kx=0, ky=0, cx=12.99, cy=7.23, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=1151, y=700, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1066, y=693, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=112, y=634, kx=0, ky=0, cx=4.11, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=297, y=634, kx=0, ky=0, cx=4.56, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=502, y=634, kx=0, ky=0, cx=4.33, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=697, y=634, kx=0, ky=0, cx=3.38, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=849, y=634, kx=0, ky=0, cx=3, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_6", sc=1, dl=0, f={
                {x=984, y=634, kx=0, ky=0, cx=4.07, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=107.5, y=138, kx=0, ky=0, cx=32.27, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input", sc=1, dl=0, f={
                {x=130.45, y=124.60000000000002, kx=0, ky=0, cx=27.92, cy=2.71, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="find_button", sc=1, dl=0, f={
                {x=852, y=120, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="found_button", sc=1, dl=0, f={
                {x=995, y=120, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="bangpai_zhaoren_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=192.5, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=7.86, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=12.45, y=87, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=98.85, y=26.15000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="paiming_descb", sc=1, dl=0, f={
                {x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tongyi_btn", sc=1, dl=0, f={
                {x=590.15, y=74, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jujue_btn", sc=1, dl=0, f={
                {x=434.8, y=74, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chengyuan_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=396, y=514.5, kx=0, ky=0, cx=9.57, cy=5.66, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=399, y=510, kx=0, ky=0, cx=5.82, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=660, y=510, kx=0, ky=0, cx=2.13, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=756, y=510, kx=0, ky=0, cx=2.78, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=881, y=510, kx=0, ky=0, cx=2.78, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=1006, y=510, kx=0, ky=0, cx=3.82, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
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
    {type="animation", name="commonButtons/common_copy_small_red_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonProgressBar/common_copy_blue_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_progress_bar_bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_progress_bar_fg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huoyuedu_popup_item_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=96, kx=0, ky=0, cx=107.5, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=96, kx=0, ky=0, cx=4.39, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedul_descb", sc=1, dl=0, f={
                {x=17.85, y=49.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_descb", sc=1, dl=0, f={
                {x=210, y=70.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silveri_descb", sc=1, dl=0, f={
                {x=180.4, y=39.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lingqu_btn", sc=1, dl=0, f={
                {x=300, y=96, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yilingqu_descb", sc=1, dl=0, f={
                {x=320, y=52.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huoyuedu_popup_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=656, kx=0, ky=0, cx=129.5, cy=163, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_panel_3", sc=1, dl=0, f={
                {x=0, y=632, kx=0, ky=0, cx=1, cy=0.95, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=14, y=618.1, kx=0, ky=0, cx=0.97, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=28.5, y=516.5, kx=0, ky=0, cx=5.37, cy=5.98, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huoyuedu_descb", sc=1, dl=0, f={
                {x=266.85, y=550.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=32.5, y=510, kx=0, ky=0, cx=3, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=167.5, y=510, kx=0, ky=0, cx=3.56, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=327.5, y=510, kx=0, ky=0, cx=3, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=444, y=656, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rizhi_popup_item_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=109.25, cy=23.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai_none_item_bg", sc=1, dl=0, f={
                {x=0, y=93, kx=0, ky=0, cx=4.46, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="player_bg", sc=1, dl=0, f={
                {x=174, y=49.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shijian_descb", sc=1, dl=0, f={
                {x=244, y=49.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rizhi_popup_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=656, kx=0, ky=0, cx=129.5, cy=163, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_panel_3", sc=1, dl=0, f={
                {x=0, y=632, kx=0, ky=0, cx=1, cy=0.95, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=14, y=618.1, kx=0, ky=0, cx=0.97, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=28.5, y=549.5, kx=0, ky=0, cx=5.37, cy=6.34, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=444, y=656, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
      },
    {type="animation", name="zhaoren_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=396, y=514.5, kx=0, ky=0, cx=9.57, cy=5.66, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=400, y=509, kx=0, ky=0, cx=5.82, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=661, y=509, kx=0, ky=0, cx=3.07, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=799, y=509, kx=0, ky=0, cx=8.44, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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