local conf = {type="skeleton", name="buddy_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="buddy_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=253, kx=0, ky=0, cx=64.75, cy=63.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_item_bg_7", x=0, y=253, kx=0, ky=0, cx=3.81, cy=3.61, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="small_bg", x=13.5, y=238, kx=0, ky=0, cx=5.95, cy=5.87, z=2, d={{name="small_bg", isArmature=0}} },
           {type="b", name="buddy_name_bg", x=16.5, y=238, kx=0, ky=0, cx=1, cy=1, z=3, text={x=31,y=199, w=198, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="static"}, d={{name="buddy_name_bg", isArmature=0}} },
           {type="b", name="touxiang_bg", x=72, y=203.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="touxiang_bg", isArmature=0}} },
           {type="b", name="level_descb", x=152, y=140, kx=0, ky=0, cx=1, cy=1, z=5, text={x=143,y=107, w=50, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_circle_bg", isArmature=0}} },
           {type="b", name="zhanli_descb", x=27, y=94.6, kx=0, ky=0, cx=6.83, cy=1, z=6, text={x=40,y=62, w=181, h=34,lineType="single line",size=22,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="button", x=15.5, y=66.1, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="buddy_tab_1_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="line", x=110, y=124.60000000000002, kx=0, ky=0, cx=176.67, cy=1, z=1, d={{name="line", isArmature=0}} },
           {type="b", name="buddy_num_descb", x=122.4, y=102.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, text={x=136,y=70, w=316, h=39,lineType="single line",size=26,color="fefbdb",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="none_descb", x=251.05, y=427.15, kx=0, ky=0, cx=1, cy=1, z=3, text={x=223,y=394, w=835, h=41,lineType="single line",size=28,color="d9c39e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="buddy_tab_2_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="line", x=110, y=133, kx=0, ky=0, cx=176.67, cy=1, z=1, d={{name="line", isArmature=0}} },
           {type="b", name="my_flower", x=162, y=612, kx=0, ky=0, cx=1, cy=1, z=2, text={x=142,y=603, w=101, h=36,lineType="single line",size=24,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="my_flower_descb", x=253.95, y=649.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=303,y=608, w=61, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="buddyImages/my_flower", isArmature=0}} },
           {type="b", name="bonus_descb", x=763.95, y=614, kx=0, ky=0, cx=1, cy=1, z=4, text={x=497,y=608, w=594, h=36,lineType="single line",size=24,color="ffffff",alignment="right",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="exp", x=381.5, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, text={x=115,y=73, w=540, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="one_flower", x=759.75, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, text={x=716,y=73, w=188, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="three_flower", x=972.85, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, text={x=955,y=73, w=188, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="button_bg_1", x=659.95, y=118.10000000000002, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="button_bg", isArmature=0}} },
           {type="b", name="duihao_img_1", x=663.75, y=122.10000000000002, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="duihao_img", isArmature=0}} },
           {type="b", name="button_bg_2", x=899.95, y=118.10000000000002, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="button_bg", isArmature=0}} },
           {type="b", name="duihao_img_2", x=903.75, y=122.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="duihao_img", isArmature=0}} }
         }
      },
    {type="armature", name="buddy_tab_3_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="title_1", x=492.25, y=516, kx=0, ky=0, cx=1, cy=1, z=1, text={x=390,y=504, w=500, h=41,lineType="single line",size=28,color="ffb400",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_2", x=492.25, y=380, kx=0, ky=0, cx=1, cy=1, z=2, text={x=390,y=319, w=500, h=41,lineType="single line",size=28,color="ffb400",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="input_1", x=375, y=487, kx=0, ky=0, cx=21.2, cy=3.12, z=3, text={x=403,y=434, w=475, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="input_2", x=375, y=298, kx=0, ky=0, cx=21.2, cy=3.12, z=4, text={x=403,y=245, w=475, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="input_scale_bg", isArmature=0}} },
           {type="b", name="btn", x=544.5, y=188, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="buddy_tab_4_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=75, y=687.5, kx=0, ky=0, cx=0.99, cy=0.99, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_background_6_1", x=103.5, y=660, kx=0, ky=0, cx=13.09, cy=7.32, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="title_1", x=111, y=658, kx=0, ky=0, cx=7.2, cy=1, z=3, text={x=212,y=615, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_2", x=435, y=658, kx=0, ky=0, cx=5.69, cy=1, z=4, text={x=502,y=615, w=123, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="title_3", x=691, y=658, kx=0, ky=0, cx=10.56, cy=1, z=5, text={x=808,y=615, w=243, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="line", x=110, y=144, kx=0, ky=0, cx=176.67, cy=1, z=6, d={{name="line", isArmature=0}} },
           {type="b", name="btn_1", x=365, y=134, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="btn_2", x=718, y=134, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="buddy_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=75, y=687.5, kx=0, ky=0, cx=0.99, cy=0.99, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_background_6_1", x=103.5, y=660, kx=0, ky=0, cx=13.02, cy=7.32, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="tabBtn4", x=1175, y=238, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn3", x=1175, y=370, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn2", x=1175, y=500, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn1", x=1175, y=630, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="effect", x=1238, y=238, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1155, y=716, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="ask", x=1081, y=709, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=29,y=-110, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_red_button_normal", isArmature=0},{name="commonButtons/common_copy_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="look_player_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=637, kx=0, ky=0, cx=104.25, cy=159.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=603, kx=0, ky=0, cx=4.84, cy=7.63, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="title_descb", x=120.95, y=582, kx=0, ky=0, cx=1, cy=1, z=2, text={x=34,y=551, w=316, h=39,lineType="single line",size=26,color="fefbdb",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="zhanli_img", x=37, y=527.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=85,y=487, w=137, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="zhanli_img", isArmature=0}} },
           {type="b", name="xianhua_img", x=37, y=472, kx=0, ky=0, cx=1, cy=1, z=4, text={x=85,y=432, w=123, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="xianhua_img", isArmature=0}} },
           {type="b", name="btn_1", x=48, y=107, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_2", x=203, y=107, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="close_btn", x=340, y=637, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="shenqing_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=103, kx=0, ky=0, cx=260.5, cy=25.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="zhanli_descb", x=25, y=87, kx=0, ky=0, cx=33.07, cy=2.33, z=1, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="touxiang_bg", x=37, y=103.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="touxiang_bg", isArmature=0}} },
           {type="b", name="descb", x=183, y=62.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=168,y=33, w=190, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="time_descb", x=435, y=62.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=383,y=33, w=124, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="button_2", x=840, y=79.5, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="button_1", x=658, y=79.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-45, w=105, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="songhua_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=690, kx=0, ky=0, cx=155, cy=172.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_panel_3", x=0, y=665, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_background_6_1", x=26, y=597, kx=0, ky=0, cx=6.5, cy=6.83, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_item_bg_7_1", x=33.5, y=529, kx=0, ky=0, cx=7.62, cy=2.07, z=3, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="common_item_bg_7_2", x=33.5, y=371.55, kx=0, ky=0, cx=7.62, cy=2.07, z=4, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="common_item_bg_7_3", x=33.5, y=214.1, kx=0, ky=0, cx=7.62, cy=2.07, z=5, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="bonus_descb", x=303.95, y=544, kx=0, ky=0, cx=1, cy=1, z=6, text={x=40,y=540, w=507, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="flower_img_1", x=50, y=507, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="buddyImages/flower_img_1", isArmature=0}} },
           {type="b", name="flower_img_2", x=54, y=349.55, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="buddyImages/flower_img_2", isArmature=0}} },
           {type="b", name="flower_img_3", x=54, y=192.1, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="buddyImages/flower_img_3", isArmature=0}} },
           {type="b", name="name_descb_1", x=135, y=501.35, kx=0, ky=0, cx=9.77, cy=1.27, z=10, text={x=169,y=464, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="exp_descb_1", x=135, y=454.35, kx=0, ky=0, cx=9.77, cy=1.27, z=11, text={x=169,y=417, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="name_descb_2", x=135, y=342.35, kx=0, ky=0, cx=9.77, cy=1.27, z=12, text={x=169,y=305, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="exp_descb_2", x=135, y=295.35, kx=0, ky=0, cx=9.77, cy=1.27, z=13, text={x=169,y=258, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="name_descb_3", x=135, y=185.35, kx=0, ky=0, cx=9.77, cy=1.27, z=14, text={x=169,y=148, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="exp_descb_3", x=135, y=138.35000000000002, kx=0, ky=0, cx=9.77, cy=1.27, z=15, text={x=169,y=101, w=235, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="btn_1", x=402.5, y=484, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_2", x=400.5, y=326.55, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_3", x=402.5, y=169.10000000000002, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="silver_2", x=283.5, y=353.8, kx=0, ky=0, cx=1, cy=1, z=19, text={x=345,y=305, w=84, h=34,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="silver_3", x=283.5, y=192.1, kx=0, ky=0, cx=1, cy=1, z=20, text={x=345,y=144, w=84, h=34,lineType="single line",size=22,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="mianfei_img", x=337, y=497.35, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="mianfei_img", isArmature=0}} },
           {type="b", name="close_btn", x=543, y=689.65, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="xianhua_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=102, kx=0, ky=0, cx=260.5, cy=25.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="zhanli_descb", x=15, y=90, kx=0, ky=0, cx=33.73, cy=2.6, z=1, d={{name="commonBackgroundScalables/common_copy_bantou_jiugongge", isArmature=0}} },
           {type="b", name="descb", x=35, y=61.05, kx=0, ky=0, cx=1, cy=1, z=2, text={x=20,y=33, w=604, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="time_descb", x=647, y=61.05, kx=0, ky=0, cx=1, cy=1, z=3, text={x=632,y=33, w=124, h=44,lineType="single line",size=30,color="ff9900",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="button", x=867.2, y=78.5, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-45, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="buddy_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=253, kx=0, ky=0, cx=64.75, cy=63.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7", sc=1, dl=0, f={
                {x=0, y=253, kx=0, ky=0, cx=3.81, cy=3.61, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg", sc=1, dl=0, f={
                {x=13.5, y=238, kx=0, ky=0, cx=5.95, cy=5.87, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buddy_name_bg", sc=1, dl=0, f={
                {x=16.5, y=238, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="touxiang_bg", sc=1, dl=0, f={
                {x=72, y=203.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=152, y=140, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_descb", sc=1, dl=0, f={
                {x=27, y=94.6, kx=0, ky=0, cx=6.83, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button", sc=1, dl=0, f={
                {x=15.5, y=66.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="buddy_tab_1_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=110, y=124.60000000000002, kx=0, ky=0, cx=176.67, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buddy_num_descb", sc=1, dl=0, f={
                {x=122.4, y=102.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="none_descb", sc=1, dl=0, f={
                {x=251.05, y=427.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="buddy_tab_2_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=110, y=133, kx=0, ky=0, cx=176.67, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="my_flower", sc=1, dl=0, f={
                {x=162, y=612, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="my_flower_descb", sc=1, dl=0, f={
                {x=253.95, y=649.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bonus_descb", sc=1, dl=0, f={
                {x=763.95, y=614, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp", sc=1, dl=0, f={
                {x=381.5, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="one_flower", sc=1, dl=0, f={
                {x=759.75, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="three_flower", sc=1, dl=0, f={
                {x=972.85, y=74.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button_bg_1", sc=1, dl=0, f={
                {x=659.95, y=118.10000000000002, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="duihao_img_1", sc=1, dl=0, f={
                {x=663.75, y=122.10000000000002, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button_bg_2", sc=1, dl=0, f={
                {x=899.95, y=118.10000000000002, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="duihao_img_2", sc=1, dl=0, f={
                {x=903.75, y=122.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="buddy_tab_3_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=492.25, y=516, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=492.25, y=380, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_1", sc=1, dl=0, f={
                {x=375, y=487, kx=0, ky=0, cx=21.2, cy=3.12, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_2", sc=1, dl=0, f={
                {x=375, y=298, kx=0, ky=0, cx=21.2, cy=3.12, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=544.5, y=188, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="buddy_tab_4_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=75, y=687.5, kx=0, ky=0, cx=0.99, cy=0.99, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6_1", sc=1, dl=0, f={
                {x=103.5, y=660, kx=0, ky=0, cx=13.09, cy=7.32, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=111, y=658, kx=0, ky=0, cx=7.2, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=435, y=658, kx=0, ky=0, cx=5.69, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=691, y=658, kx=0, ky=0, cx=10.56, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=110, y=144, kx=0, ky=0, cx=176.67, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=365, y=134, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=718, y=134, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="buddy_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=75, y=687.5, kx=0, ky=0, cx=0.99, cy=0.99, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6_1", sc=1, dl=0, f={
                {x=103.5, y=660, kx=0, ky=0, cx=13.02, cy=7.32, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn4", sc=1, dl=0, f={
                {x=1175, y=238, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn3", sc=1, dl=0, f={
                {x=1175, y=370, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn2", sc=1, dl=0, f={
                {x=1175, y=500, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn1", sc=1, dl=0, f={
                {x=1175, y=630, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=1238, y=238, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1155, y=716, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1081, y=709, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_channel_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_channel_button", sc=1, dl=0, f={
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
      },
    {type="animation", name="look_player_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=637, kx=0, ky=0, cx=104.25, cy=159.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=603, kx=0, ky=0, cx=4.84, cy=7.63, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_descb", sc=1, dl=0, f={
                {x=120.95, y=582, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_img", sc=1, dl=0, f={
                {x=37, y=527.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xianhua_img", sc=1, dl=0, f={
                {x=37, y=472, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=48, y=107, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=203, y=107, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=340, y=637, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shenqing_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=103, kx=0, ky=0, cx=260.5, cy=25.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_descb", sc=1, dl=0, f={
                {x=25, y=87, kx=0, ky=0, cx=33.07, cy=2.33, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="touxiang_bg", sc=1, dl=0, f={
                {x=37, y=103.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=183, y=62.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="time_descb", sc=1, dl=0, f={
                {x=435, y=62.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button_2", sc=1, dl=0, f={
                {x=840, y=79.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button_1", sc=1, dl=0, f={
                {x=658, y=79.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="songhua_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=690, kx=0, ky=0, cx=155, cy=172.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_panel_3", sc=1, dl=0, f={
                {x=0, y=665, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6_1", sc=1, dl=0, f={
                {x=26, y=597, kx=0, ky=0, cx=6.5, cy=6.83, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7_1", sc=1, dl=0, f={
                {x=33.5, y=529, kx=0, ky=0, cx=7.62, cy=2.07, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7_2", sc=1, dl=0, f={
                {x=33.5, y=371.55, kx=0, ky=0, cx=7.62, cy=2.07, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_bg_7_3", sc=1, dl=0, f={
                {x=33.5, y=214.1, kx=0, ky=0, cx=7.62, cy=2.07, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bonus_descb", sc=1, dl=0, f={
                {x=303.95, y=544, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="flower_img_1", sc=1, dl=0, f={
                {x=50, y=507, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="flower_img_2", sc=1, dl=0, f={
                {x=54, y=349.55, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="flower_img_3", sc=1, dl=0, f={
                {x=54, y=192.1, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb_1", sc=1, dl=0, f={
                {x=135, y=501.35, kx=0, ky=0, cx=9.77, cy=1.27, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_descb_1", sc=1, dl=0, f={
                {x=135, y=454.35, kx=0, ky=0, cx=9.77, cy=1.27, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb_2", sc=1, dl=0, f={
                {x=135, y=342.35, kx=0, ky=0, cx=9.77, cy=1.27, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_descb_2", sc=1, dl=0, f={
                {x=135, y=295.35, kx=0, ky=0, cx=9.77, cy=1.27, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb_3", sc=1, dl=0, f={
                {x=135, y=185.35, kx=0, ky=0, cx=9.77, cy=1.27, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_descb_3", sc=1, dl=0, f={
                {x=135, y=138.35000000000002, kx=0, ky=0, cx=9.77, cy=1.27, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=402.5, y=484, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=400.5, y=326.55, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_3", sc=1, dl=0, f={
                {x=402.5, y=169.10000000000002, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_2", sc=1, dl=0, f={
                {x=283.5, y=353.8, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_3", sc=1, dl=0, f={
                {x=283.5, y=192.1, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mianfei_img", sc=1, dl=0, f={
                {x=337, y=497.35, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_btn", sc=1, dl=0, f={
                {x=543, y=689.65, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="xianhua_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=102, kx=0, ky=0, cx=260.5, cy=25.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_descb", sc=1, dl=0, f={
                {x=15, y=90, kx=0, ky=0, cx=33.73, cy=2.6, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=35, y=61.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="time_descb", sc=1, dl=0, f={
                {x=647, y=61.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button", sc=1, dl=0, f={
                {x=867.2, y=78.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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