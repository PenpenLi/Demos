local conf = {type="skeleton", name="arena_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="arena_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=140, y=672, kx=0, ky=0, cx=0.88, cy=0.96, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_item_bg_6", x=165, y=648, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_6", isArmature=0}} },
           {type="b", name="common_background_6_1", x=616, y=556, kx=0, ky=0, cx=14.14, cy=13, z=3, d={{name="background_6", isArmature=0}} },
           {type="b", name="shuaxin_btn", x=792.45, y=99, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="shuaxin_btn", isArmature=0}} },
           {type="b", name="shuaxin_shijian_descb", x=744.45, y=86.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, text={x=618,y=61, w=163, h=34,lineType="single line",size=22,color="442301",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shuaxin_yuanbao_descb", x=1058.45, y=86.10000000000002, kx=0, ky=0, cx=1, cy=1, z=6, text={x=949,y=61, w=163, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_background_6_2", x=616, y=556, kx=0, ky=0, cx=14.14, cy=14, z=7, d={{name="background_6", isArmature=0}} },
           {type="b", name="tab_btn_bg_1", x=616, y=648, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="tab_btn_bg", isArmature=0}} },
           {type="b", name="tab_btn_bg_2", x=728, y=648, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="tab_btn_bg", isArmature=0}} },
           {type="b", name="tab_btn_bg_3", x=840, y=648, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="tab_btn_bg", isArmature=0}} },
           {type="b", name="tab_btn_bg_4", x=952, y=648, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="tab_btn_bg", isArmature=0}} },
           {type="b", name="tab_btn_1", x=617.5, y=646, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="tab_btn_1", isArmature=0}} },
           {type="b", name="tab_btn_2", x=729.5, y=646, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="tab_btn_2", isArmature=0}} },
           {type="b", name="tab_btn_4", x=953, y=646, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="tab_btn_3", isArmature=0}} },
           {type="b", name="tab_btn_3", x=841, y=646, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="tab_btn_4", isArmature=0}} },
           {type="b", name="left_title_bg", x=178, y=632, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="left_title_bg", isArmature=0}} },
           {type="b", name="saiji_descb", x=314.45, y=604.05, kx=0, ky=0, cx=1, cy=1, z=17, text={x=194,y=585, w=203, h=39,lineType="single line",size=26,color="fff3cd",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shijian_descb", x=575.05, y=558.05, kx=0, ky=0, cx=1, cy=1, z=18, text={x=377,y=537, w=203, h=39,lineType="single line",size=26,color="fff3cd",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="xinxi_title_bg", x=178, y=512.55, kx=0, ky=0, cx=1, cy=1, z=19, text={x=195,y=477, w=203, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="static"}, d={{name="xinxi_title_bg", isArmature=0}} },
           {type="b", name="zhandui_descb", x=314.45, y=445.05, kx=0, ky=0, cx=1, cy=1, z=20, text={x=195,y=428, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="jifen_descb", x=314.45, y=413.05, kx=0, ky=0, cx=1, cy=1, z=21, text={x=195,y=375, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="paiming_descb", x=314.45, y=379.05, kx=0, ky=0, cx=1, cy=1, z=22, text={x=195,y=321, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="changshu_descb", x=314.45, y=348.05, kx=0, ky=0, cx=1, cy=1, z=23, text={x=195,y=267, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rongyuzhi_descb", x=314.45, y=274.05, kx=0, ky=0, cx=1, cy=1, z=24, text={x=195,y=175, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shangdian_btn", x=450, y=220, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="goumai_btn", x=450, y=150, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="cishu_descb", x=314.45, y=244.05, kx=0, ky=0, cx=1, cy=1, z=27, text={x=195,y=105, w=385, h=34,lineType="single line",size=22,color="442301",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1083, y=691, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1020, y=684, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=-43, w=105, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="imgs", 
      bones={           
           {type="b", name="图层 2", x=17, y=115, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="rank_1_img", isArmature=0}} },
           {type="b", name="图层 3", x=115, y=118, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="rank_2_img", isArmature=0}} },
           {type="b", name="图层 4", x=199.5, y=111, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="rank_3_img", isArmature=0}} }
         }
      },
    {type="armature", name="tab_item_1", 
      bones={           
           {type="b", name="hit_area", x=0, y=106, kx=0, ky=0, cx=117.5, cy=26.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_item_bg_7", x=0, y=106, kx=0, ky=0, cx=6.91, cy=1.51, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="name_descb", x=197.5, y=78.55, kx=0, ky=0, cx=1, cy=1, z=2, text={x=109,y=53, w=239, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="jinfen_descb", x=197.5, y=49.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=109,y=22, w=239, h=31,lineType="single line",size=20,color="57290e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="btn", x=324.5, y=80.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="shengli_img", x=326.5, y=102.5, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="shengli_img", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="tab_item_2", 
      bones={           
           {type="b", name="hit_area", x=0, y=106, kx=0, ky=0, cx=117.5, cy=26.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_item_bg_7", x=0, y=106, kx=0, ky=0, cx=6.91, cy=1.51, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="name_descb", x=322.5, y=78.55, kx=0, ky=0, cx=1, cy=1, z=2, text={x=223,y=53, w=239, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="jinfen_descb", x=322.5, y=49.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=223,y=22, w=239, h=31,lineType="single line",size=20,color="57290e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rank_descb", x=131.5, y=57, kx=0, ky=0, cx=1, cy=1, z=4, text={x=3,y=18, w=106, h=68,lineType="single line",size=48,color="4d120e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="tab_item_3", 
      bones={           
           {type="b", name="hit_area", x=0, y=740, kx=0, ky=0, cx=117.5, cy=185, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_item_bg_7", x=0, y=740, kx=0, ky=0, cx=6.91, cy=4.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="common_item_bg_70", x=0, y=410, kx=0, ky=0, cx=6.91, cy=5.86, z=2, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="line_1", x=12.5, y=691, kx=0, ky=0, cx=55.63, cy=1, z=3, d={{name="line", isArmature=0}} },
           {type="b", name="line_2", x=12.5, y=653, kx=0, ky=0, cx=55.63, cy=1, z=4, d={{name="line", isArmature=0}} },
           {type="b", name="line_3", x=12.5, y=615, kx=0, ky=0, cx=55.63, cy=1, z=5, d={{name="line", isArmature=0}} },
           {type="b", name="line_4", x=12.5, y=577, kx=0, ky=0, cx=55.63, cy=1, z=6, d={{name="line", isArmature=0}} },
           {type="b", name="line_5", x=12.5, y=539, kx=0, ky=0, cx=55.63, cy=1, z=7, d={{name="line", isArmature=0}} },
           {type="b", name="line_6", x=12.5, y=501, kx=0, ky=0, cx=55.63, cy=1, z=8, d={{name="line", isArmature=0}} },
           {type="b", name="line_7", x=12.5, y=463, kx=0, ky=0, cx=55.63, cy=1, z=9, d={{name="line", isArmature=0}} },
           {type="b", name="line_8", x=12.5, y=363, kx=0, ky=0, cx=55.63, cy=1, z=10, d={{name="line", isArmature=0}} },
           {type="b", name="line_9", x=12.5, y=325, kx=0, ky=0, cx=55.63, cy=1, z=11, d={{name="line", isArmature=0}} },
           {type="b", name="line_10", x=12.5, y=287, kx=0, ky=0, cx=55.63, cy=1, z=12, d={{name="line", isArmature=0}} },
           {type="b", name="line_11", x=12.5, y=249, kx=0, ky=0, cx=55.63, cy=1, z=13, d={{name="line", isArmature=0}} },
           {type="b", name="line_12", x=12.5, y=211, kx=0, ky=0, cx=55.63, cy=1, z=14, d={{name="line", isArmature=0}} },
           {type="b", name="line_13", x=12.5, y=173, kx=0, ky=0, cx=55.63, cy=1, z=15, d={{name="line", isArmature=0}} },
           {type="b", name="line_14", x=12.5, y=135, kx=0, ky=0, cx=55.63, cy=1, z=16, d={{name="line", isArmature=0}} },
           {type="b", name="line_15", x=12.5, y=96, kx=0, ky=0, cx=55.63, cy=1, z=17, d={{name="line", isArmature=0}} },
           {type="b", name="line_16", x=12.5, y=58, kx=0, ky=0, cx=55.63, cy=1, z=18, d={{name="line", isArmature=0}} }
         }
      },
    {type="armature", name="tab_item_4", 
      bones={           
           {type="b", name="hit_area", x=0, y=78, kx=0, ky=0, cx=117.5, cy=19.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_item_bg_7", x=0, y=71, kx=0, ky=0, cx=6.91, cy=0.9, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="task_item", x=24, y=59, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="task_item", isArmature=0}} },
           {type="b", name="yiwancheng_img", x=182.5, y=79, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="yiwancheng_img", isArmature=0}} },
           {type="b", name="name_descb", x=322.5, y=39.5, kx=0, ky=0, cx=1, cy=1, z=4, text={x=80,y=21, w=240, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="jinfen_descb", x=451.5, y=46.55, kx=0, ky=0, cx=1, cy=1, z=5, text={x=346,y=22, w=100, h=31,lineType="single line",size=20,color="57290e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="zhandui_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="zhandui_bg", x=0, y=620, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="zhandui_bg", isArmature=0}} },
           {type="b", name="vs_img", x=482.5, y=690, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="vs_img", isArmature=0}} },
           {type="b", name="btn_1", x=95, y=107, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="btn_2", x=975, y=107, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="wodezhandui_img", x=75, y=218, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="wodezhandui_img", isArmature=0}} },
           {type="b", name="duishouzhandui_img", x=735, y=164, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="duishouzhandui_img", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1179, y=706, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="slot_l_3", x=314, y=352, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_6", x=164, y=352, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_9", x=14, y=352, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_2", x=368, y=456, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_5", x=218, y=456, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_8", x=68, y=456, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_1", x=422, y=560, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_4", x=272, y=560, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_7", x=122, y=560, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_9", x=1141, y=296, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_6", x=991, y=296, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_3", x=841, y=296, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="xg", x=61.55, y=681.25, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="xg", isArmature=0}} },
           {type="b", name="playerName", x=924.4, y=673.05, kx=0, ky=0, cx=1, cy=1, z=21, text={x=793,y=639, w=385, h=33,lineType="single line",size=26,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="slot_r_8", x=1087, y=400, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_5", x=937, y=400, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_2", x=787, y=400, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_7", x=1033, y=504, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_4", x=883, y=504, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_r_1", x=733, y=504, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonImages/common_copy_position_slot", isArmature=0}} },
           {type="b", name="slot_l_1_over", x=422, y=560, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="commonImages/common_copy_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_2_over", x=368, y=456, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_3_over", x=314, y=352, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_4_over", x=272, y=560, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_5_over", x=218, y=456, kx=0, ky=0, cx=1, cy=1, z=32, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_6_over", x=164, y=352, kx=0, ky=0, cx=1, cy=1, z=33, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_7_over", x=122, y=560, kx=0, ky=0, cx=1, cy=1, z=34, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_8_over", x=68, y=456, kx=0, ky=0, cx=1, cy=1, z=35, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_l_9_over", x=14, y=352, kx=0, ky=0, cx=1, cy=1, z=36, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_7_over", x=1033, y=504, kx=0, ky=0, cx=1, cy=1, z=37, d={{name="commonImages/common_copy_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_8_over", x=1087, y=400, kx=0, ky=0, cx=1, cy=1, z=38, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_9_over", x=1141, y=296, kx=0, ky=0, cx=1, cy=1, z=39, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_4_over", x=883, y=504, kx=0, ky=0, cx=1, cy=1, z=40, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_5_over", x=937, y=400, kx=0, ky=0, cx=1, cy=1, z=41, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_6_over", x=991, y=296, kx=0, ky=0, cx=1, cy=1, z=42, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_1_over", x=733, y=504, kx=0, ky=0, cx=1, cy=1, z=43, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_2_over", x=787, y=400, kx=0, ky=0, cx=1, cy=1, z=44, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="slot_r_3_over", x=841, y=296, kx=0, ky=0, cx=1, cy=1, z=45, d={{name="commonImages/common_position_slot_over", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_red_button_normal", isArmature=0},{name="commonButtons/common_copy_red_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="arena_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=140, y=672, kx=0, ky=0, cx=0.88, cy=0.96, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_6", sc=1, dl=0, f={
                {x=165, y=648, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6_1", sc=1, dl=0, f={
                {x=616, y=556, kx=0, ky=0, cx=14.14, cy=13, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuaxin_btn", sc=1, dl=0, f={
                {x=792.45, y=99, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuaxin_shijian_descb", sc=1, dl=0, f={
                {x=744.45, y=86.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuaxin_yuanbao_descb", sc=1, dl=0, f={
                {x=1058.45, y=86.10000000000002, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6_2", sc=1, dl=0, f={
                {x=616, y=556, kx=0, ky=0, cx=14.14, cy=14, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_bg_1", sc=1, dl=0, f={
                {x=616, y=648, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_bg_2", sc=1, dl=0, f={
                {x=728, y=648, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_bg_3", sc=1, dl=0, f={
                {x=840, y=648, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_bg_4", sc=1, dl=0, f={
                {x=952, y=648, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_1", sc=1, dl=0, f={
                {x=617.5, y=646, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_2", sc=1, dl=0, f={
                {x=729.5, y=646, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_4", sc=1, dl=0, f={
                {x=953, y=646, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_3", sc=1, dl=0, f={
                {x=841, y=646, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="left_title_bg", sc=1, dl=0, f={
                {x=178, y=632, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saiji_descb", sc=1, dl=0, f={
                {x=314.45, y=604.05, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shijian_descb", sc=1, dl=0, f={
                {x=575.05, y=558.05, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xinxi_title_bg", sc=1, dl=0, f={
                {x=178, y=512.55, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhandui_descb", sc=1, dl=0, f={
                {x=314.45, y=445.05, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jifen_descb", sc=1, dl=0, f={
                {x=314.45, y=413.05, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="paiming_descb", sc=1, dl=0, f={
                {x=314.45, y=379.05, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="changshu_descb", sc=1, dl=0, f={
                {x=314.45, y=348.05, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rongyuzhi_descb", sc=1, dl=0, f={
                {x=314.45, y=274.05, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shangdian_btn", sc=1, dl=0, f={
                {x=450, y=220, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="goumai_btn", sc=1, dl=0, f={
                {x=450, y=150, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cishu_descb", sc=1, dl=0, f={
                {x=314.45, y=244.05, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1083, y=691, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1020, y=684, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=17, y=115, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=115, y=118, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=199.5, y=111, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="tab_item_1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=106, kx=0, ky=0, cx=117.5, cy=26.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7", sc=1, dl=0, f={
                {x=0, y=106, kx=0, ky=0, cx=6.91, cy=1.51, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=197.5, y=78.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinfen_descb", sc=1, dl=0, f={
                {x=197.5, y=49.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=324.5, y=80.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengli_img", sc=1, dl=0, f={
                {x=326.5, y=102.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="tab_item_2", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=106, kx=0, ky=0, cx=117.5, cy=26.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7", sc=1, dl=0, f={
                {x=0, y=106, kx=0, ky=0, cx=6.91, cy=1.51, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=322.5, y=78.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinfen_descb", sc=1, dl=0, f={
                {x=322.5, y=49.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_descb", sc=1, dl=0, f={
                {x=131.5, y=57, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="tab_item_3", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=740, kx=0, ky=0, cx=117.5, cy=185, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7", sc=1, dl=0, f={
                {x=0, y=740, kx=0, ky=0, cx=6.91, cy=4.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_70", sc=1, dl=0, f={
                {x=0, y=410, kx=0, ky=0, cx=6.91, cy=5.86, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_1", sc=1, dl=0, f={
                {x=12.5, y=691, kx=0, ky=0, cx=55.63, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_2", sc=1, dl=0, f={
                {x=12.5, y=653, kx=0, ky=0, cx=55.63, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_3", sc=1, dl=0, f={
                {x=12.5, y=615, kx=0, ky=0, cx=55.63, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_4", sc=1, dl=0, f={
                {x=12.5, y=577, kx=0, ky=0, cx=55.63, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_5", sc=1, dl=0, f={
                {x=12.5, y=539, kx=0, ky=0, cx=55.63, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_6", sc=1, dl=0, f={
                {x=12.5, y=501, kx=0, ky=0, cx=55.63, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_7", sc=1, dl=0, f={
                {x=12.5, y=463, kx=0, ky=0, cx=55.63, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_8", sc=1, dl=0, f={
                {x=12.5, y=363, kx=0, ky=0, cx=55.63, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_9", sc=1, dl=0, f={
                {x=12.5, y=325, kx=0, ky=0, cx=55.63, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_10", sc=1, dl=0, f={
                {x=12.5, y=287, kx=0, ky=0, cx=55.63, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_11", sc=1, dl=0, f={
                {x=12.5, y=249, kx=0, ky=0, cx=55.63, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_12", sc=1, dl=0, f={
                {x=12.5, y=211, kx=0, ky=0, cx=55.63, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_13", sc=1, dl=0, f={
                {x=12.5, y=173, kx=0, ky=0, cx=55.63, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_14", sc=1, dl=0, f={
                {x=12.5, y=135, kx=0, ky=0, cx=55.63, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_15", sc=1, dl=0, f={
                {x=12.5, y=96, kx=0, ky=0, cx=55.63, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_16", sc=1, dl=0, f={
                {x=12.5, y=58, kx=0, ky=0, cx=55.63, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="tab_item_4", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=78, kx=0, ky=0, cx=117.5, cy=19.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=6.91, cy=0.9, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="task_item", sc=1, dl=0, f={
                {x=24, y=59, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yiwancheng_img", sc=1, dl=0, f={
                {x=182.5, y=79, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=322.5, y=39.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinfen_descb", sc=1, dl=0, f={
                {x=451.5, y=46.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="zhandui_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhandui_bg", sc=1, dl=0, f={
                {x=0, y=620, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vs_img", sc=1, dl=0, f={
                {x=482.5, y=690, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=95, y=107, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=975, y=107, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="wodezhandui_img", sc=1, dl=0, f={
                {x=75, y=218, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="duishouzhandui_img", sc=1, dl=0, f={
                {x=735, y=164, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1179, y=706, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_3", sc=1, dl=0, f={
                {x=314, y=352, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_6", sc=1, dl=0, f={
                {x=164, y=352, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_9", sc=1, dl=0, f={
                {x=14, y=352, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_2", sc=1, dl=0, f={
                {x=368, y=456, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_5", sc=1, dl=0, f={
                {x=218, y=456, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_8", sc=1, dl=0, f={
                {x=68, y=456, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_1", sc=1, dl=0, f={
                {x=422, y=560, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_4", sc=1, dl=0, f={
                {x=272, y=560, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_7", sc=1, dl=0, f={
                {x=122, y=560, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_9", sc=1, dl=0, f={
                {x=1141, y=296, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_6", sc=1, dl=0, f={
                {x=991, y=296, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_3", sc=1, dl=0, f={
                {x=841, y=296, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xg", sc=1, dl=0, f={
                {x=61.55, y=681.25, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="playerName", sc=1, dl=0, f={
                {x=924.4, y=673.05, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_8", sc=1, dl=0, f={
                {x=1087, y=400, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_5", sc=1, dl=0, f={
                {x=937, y=400, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_2", sc=1, dl=0, f={
                {x=787, y=400, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_7", sc=1, dl=0, f={
                {x=1033, y=504, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_4", sc=1, dl=0, f={
                {x=883, y=504, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_1", sc=1, dl=0, f={
                {x=733, y=504, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_1_over", sc=1, dl=0, f={
                {x=422, y=560, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_2_over", sc=1, dl=0, f={
                {x=368, y=456, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_3_over", sc=1, dl=0, f={
                {x=314, y=352, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_4_over", sc=1, dl=0, f={
                {x=272, y=560, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_5_over", sc=1, dl=0, f={
                {x=218, y=456, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_6_over", sc=1, dl=0, f={
                {x=164, y=352, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_7_over", sc=1, dl=0, f={
                {x=122, y=560, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_8_over", sc=1, dl=0, f={
                {x=68, y=456, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_l_9_over", sc=1, dl=0, f={
                {x=14, y=352, kx=0, ky=0, cx=1, cy=1, z=36, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_7_over", sc=1, dl=0, f={
                {x=1033, y=504, kx=0, ky=0, cx=1, cy=1, z=37, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_8_over", sc=1, dl=0, f={
                {x=1087, y=400, kx=0, ky=0, cx=1, cy=1, z=38, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_9_over", sc=1, dl=0, f={
                {x=1141, y=296, kx=0, ky=0, cx=1, cy=1, z=39, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_4_over", sc=1, dl=0, f={
                {x=883, y=504, kx=0, ky=0, cx=1, cy=1, z=40, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_5_over", sc=1, dl=0, f={
                {x=937, y=400, kx=0, ky=0, cx=1, cy=1, z=41, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_6_over", sc=1, dl=0, f={
                {x=991, y=296, kx=0, ky=0, cx=1, cy=1, z=42, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_1_over", sc=1, dl=0, f={
                {x=733, y=504, kx=0, ky=0, cx=1, cy=1, z=43, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_2_over", sc=1, dl=0, f={
                {x=787, y=400, kx=0, ky=0, cx=1, cy=1, z=44, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="slot_r_3_over", sc=1, dl=0, f={
                {x=841, y=296, kx=0, ky=0, cx=1, cy=1, z=45, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;