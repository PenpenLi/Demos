local conf = {type="skeleton", name="bag_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="bag_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=163.75, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_2", x=0, y=695, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_2", isArmature=0}} },
           {type="b", name="common_background_2", x=38, y=657, kx=0, ky=0, cx=6.29, cy=6.33, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="common_blue_button_1", x=78, y=120, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button_2", x=315.95, y=120, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_grid", x=65, y=642, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_grid_1", x=184, y=642, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_grid_2", x=65, y=525, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_black_lock", x=101.5, y=608, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_black_lock", isArmature=0}} },
           {type="b", name="common_grid_over", x=63, y=642, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonGrids/common_copy_grid_over", isArmature=0}} },
           {type="b", name="bag_item_number", x=296, y=160.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, text={x=240,y=144, w=114, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_close_button", x=540, y=720, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="placeholder", x=331.3, y=693, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="placeholder", isArmature=0}} },
           {type="b", name="tab_btn_2", x=567, y=500, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tab_btn_1", x=567, y=627, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonBackgrounds/common_copy_background_img", 
      bones={           
           {type="b", name="bag_background_img_sub_4_1", x=0, y=642.35, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_2", x=556, y=642.35, kx=0, ky=180, cx=1, cy=1, z=1, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_3", x=556, y=0.35000000000002274, kx=180, ky=180, cx=1, cy=1, z=2, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_4_4", x=0, y=0.35000000000002274, kx=180, ky=0, cx=1, cy=1, z=3, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_4", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_1_1", x=0, y=562.35, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_1_2", x=556, y=562.35, kx=0, ky=180, cx=1, cy=1, z=5, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_2_1", x=-0.15, y=412.35, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_2_2", x=556, y=412.35, kx=0, ky=180, cx=1, cy=1, z=7, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_3_1", x=0, y=262.35, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_3", isArmature=0}} },
           {type="b", name="bag_background_img_sub_2_3_2", x=556, y=262.35, kx=0, ky=180, cx=1, cy=1, z=9, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_2_3", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_1", x=80, y=642.35, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_1_2", x=80, y=0, kx=180, ky=0, cx=1, cy=1, z=11, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_3_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_1", x=25, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=12, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_2", x=476, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=13, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_3", x=80, y=81, kx=0, ky=0, cx=132, cy=18.33, z=14, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_4", x=80, y=616.35, kx=0, ky=0, cx=132, cy=18.33, z=15, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_1_5", x=80, y=561.35, kx=0, ky=0, cx=132, cy=160.67, z=16, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_1", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_1", x=276, y=642.35, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} },
           {type="b", name="bag_background_img_sub_3_2_2", x=276, y=0, kx=180, ky=0, cx=1, cy=1, z=18, d={{name="commonBackgrounds/common_background_img_sub/common_copy_background_img_sub_3_2", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_page_button", 
      bones={           
           {type="b", name="common_page_button", x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_page_button_normal", isArmature=0},{name="commonButtons/common_copy_page_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="currency_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=50, kx=0, ky=0, cx=50, cy=12.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=50, kx=0, ky=0, cx=2.53, cy=0.63, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="bag_item_name", x=57.45, y=6.549999999999997, kx=0, ky=0, cx=1, cy=1, z=2, text={x=0,y=6, w=200, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="detail_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=645, kx=0, ky=0, cx=95, cy=161.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=645, kx=0, ky=0, cx=4.81, cy=8.16, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_image_separator_1", x=14, y=405, kx=0, ky=0, cx=1.45, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="bag_item_name", x=65.45, y=571.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=22,y=581, w=202, h=47,lineType="single line",size=32,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_category_name", x=59.45, y=536.55, kx=0, ky=0, cx=1, cy=1, z=4, text={x=22,y=533, w=94, h=39,lineType="single line",size=26,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_category_descb", x=161.45, y=540.55, kx=0, ky=0, cx=1, cy=1, z=5, text={x=99,y=533, w=164, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_overlay", x=65.45, y=504, kx=0, ky=0, cx=1, cy=1, z=6, text={x=22,y=489, w=83, h=39,lineType="single line",size=26,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_overlay_descrb", x=153.45, y=502.6, kx=0, ky=0, cx=1, cy=1, z=7, text={x=99,y=489, w=118, h=39,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_output", x=71.45, y=471.6, kx=0, ky=0, cx=1, cy=1, z=8, text={x=22,y=444, w=83, h=39,lineType="single line",size=26,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_output_descb", x=151.45, y=471.6, kx=0, ky=0, cx=1, cy=1, z=9, text={x=99,y=408, w=252, h=75,lineType="single line",size=26,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_specification", x=65.45, y=329.65, kx=0, ky=0, cx=1, cy=1, z=10, text={x=22,y=218, w=336, h=171,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_grid", x=257, y=630, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_blue_button", x=40, y=80, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button_1", x=206, y=80, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="equip_detail_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=645, kx=0, ky=0, cx=95, cy=161.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=645, kx=0, ky=0, cx=4.81, cy=8.16, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_image_separator_1", x=14, y=475, kx=0, ky=0, cx=1.45, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="common_image_separator_2", x=14, y=247, kx=0, ky=0, cx=1.45, cy=1, z=3, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="bag_item_name", x=57.45, y=601.55, kx=0, ky=0, cx=1, cy=1, z=4, text={x=22,y=581, w=200, h=47,lineType="single line",size=32,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_strengthen_level", x=193.45, y=601.55, kx=0, ky=0, cx=1, cy=1, z=5, text={x=160,y=580, w=80, h=39,lineType="single line",size=26,color="fff000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_mark", x=34, y=512, kx=0, ky=0, cx=1, cy=1, z=6, text={x=22,y=485, w=271, h=39,lineType="single line",size=26,color="ffd200",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_equiped_descb", x=32.45, y=567, kx=0, ky=0, cx=1, cy=1, z=7, text={x=22,y=543, w=121, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_increase_descb", x=234.45, y=512.6, kx=0, ky=0, cx=1, cy=1, z=8, text={x=219,y=485, w=155, h=39,lineType="single line",size=26,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_add_green", x=64.45, y=409.6, kx=0, ky=0, cx=1, cy=1, z=9, text={x=22,y=256, w=336, h=205,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_add_yellow", x=54.45, y=367.65, kx=0, ky=0, cx=1, cy=1, z=10, text={x=22,y=386, w=336, h=36,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_specification", x=25.45, y=217.7, kx=0, ky=0, cx=1, cy=1, z=11, text={x=22,y=90, w=336, h=137,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_grid", x=257, y=630, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_blue_button", x=124, y=80, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button2", x=124, y=80, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_image_increase", x=175.5, y=522.7, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_image_increase", isArmature=0}} },
           {type="b", name="common_image_decrease", x=175.5, y=522.7, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_copy_image_decrease", isArmature=0}} }
         }
      },
    {type="armature", name="equip_detail_ui_small", 
      bones={           
           {type="b", name="hit_area", x=0, y=425, kx=0, ky=0, cx=95, cy=106.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=425, kx=0, ky=0, cx=4.81, cy=5.38, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_image_separator_1", x=14, y=255, kx=0, ky=0, cx=1.45, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="bag_item_name", x=57.45, y=381.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=22,y=361, w=200, h=47,lineType="single line",size=32,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_strengthen_level", x=193.45, y=381.55, kx=0, ky=0, cx=1, cy=1, z=4, text={x=160,y=360, w=66, h=36,lineType="single line",size=24,color="fff000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_mark", x=34, y=292, kx=0, ky=0, cx=1, cy=1, z=5, text={x=22,y=265, w=166, h=39,lineType="single line",size=26,color="ffd200",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_equiped_descb", x=32.45, y=347, kx=0, ky=0, cx=1, cy=1, z=6, text={x=22,y=323, w=121, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_increase_descb", x=234.45, y=292.6, kx=0, ky=0, cx=1, cy=1, z=7, text={x=219,y=265, w=155, h=39,lineType="single line",size=26,color="00ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_add_green", x=64.45, y=189.6, kx=0, ky=0, cx=1, cy=1, z=8, text={x=22,y=36, w=336, h=205,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_prop_add_yellow", x=54.45, y=147.64999999999998, kx=0, ky=0, cx=1, cy=1, z=9, text={x=22,y=166, w=336, h=36,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="bag_item_specification", x=25.45, y=220.7, kx=0, ky=0, cx=1, cy=1, z=10, text={x=22,y=93, w=336, h=137,lineType="single line",size=24,color="e1d2a0",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_grid", x=257, y=410, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_blue_button", x=124, y=88, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_blue_button2", x=124, y=88, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="common_image_increase", x=175.5, y=302.7, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_copy_image_increase", isArmature=0}} },
           {type="b", name="common_image_decrease", x=175.5, y=302.7, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_image_decrease", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=15,y=-43, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="bag_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=163.75, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_2", sc=1, dl=0, f={
                {x=0, y=695, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_2", sc=1, dl=0, f={
                {x=38, y=657, kx=0, ky=0, cx=6.29, cy=6.33, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button_1", sc=1, dl=0, f={
                {x=78, y=120, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button_2", sc=1, dl=0, f={
                {x=315.95, y=120, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid", sc=1, dl=0, f={
                {x=65, y=642, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_1", sc=1, dl=0, f={
                {x=184, y=642, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_2", sc=1, dl=0, f={
                {x=65, y=525, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_black_lock", sc=1, dl=0, f={
                {x=101.5, y=608, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_over", sc=1, dl=0, f={
                {x=63, y=642, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_number", sc=1, dl=0, f={
                {x=296, y=160.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=540, y=720, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="placeholder", sc=1, dl=0, f={
                {x=331.3, y=693, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_2", sc=1, dl=0, f={
                {x=567, y=500, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tab_btn_1", sc=1, dl=0, f={
                {x=567, y=627, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonBackgrounds/common_copy_background_img", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="bag_background_img_sub_4_1", sc=1, dl=0, f={
                {x=0, y=642.35, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_2", sc=1, dl=0, f={
                {x=556, y=642.35, kx=0, ky=180, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_3", sc=1, dl=0, f={
                {x=556, y=0.35000000000002274, kx=180, ky=180, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_4_4", sc=1, dl=0, f={
                {x=0, y=0.35000000000002274, kx=180, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_1_1", sc=1, dl=0, f={
                {x=0, y=562.35, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_1_2", sc=1, dl=0, f={
                {x=556, y=562.35, kx=0, ky=180, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_2_1", sc=1, dl=0, f={
                {x=-0.15, y=412.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_2_2", sc=1, dl=0, f={
                {x=556, y=412.35, kx=0, ky=180, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_3_1", sc=1, dl=0, f={
                {x=0, y=262.35, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_2_3_2", sc=1, dl=0, f={
                {x=556, y=262.35, kx=0, ky=180, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_1", sc=1, dl=0, f={
                {x=80, y=642.35, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_1_2", sc=1, dl=0, f={
                {x=80, y=0, kx=180, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_1", sc=1, dl=0, f={
                {x=25, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_2", sc=1, dl=0, f={
                {x=476, y=562.35, kx=0, ky=0, cx=18.33, cy=160.67, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_3", sc=1, dl=0, f={
                {x=80, y=81, kx=0, ky=0, cx=132, cy=18.33, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_4", sc=1, dl=0, f={
                {x=80, y=616.35, kx=0, ky=0, cx=132, cy=18.33, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_1_5", sc=1, dl=0, f={
                {x=80, y=561.35, kx=0, ky=0, cx=132, cy=160.67, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_1", sc=1, dl=0, f={
                {x=276, y=642.35, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img_sub_3_2_2", sc=1, dl=0, f={
                {x=276, y=0, kx=180, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=-2, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=100, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_page_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=26, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="currency_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=50, kx=0, ky=0, cx=50, cy=12.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=50, kx=0, ky=0, cx=2.53, cy=0.63, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_name", sc=1, dl=0, f={
                {x=57.45, y=6.549999999999997, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="detail_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=645, kx=0, ky=0, cx=95, cy=161.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=645, kx=0, ky=0, cx=4.81, cy=8.16, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_1", sc=1, dl=0, f={
                {x=14, y=405, kx=0, ky=0, cx=1.45, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_name", sc=1, dl=0, f={
                {x=65.45, y=571.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_category_name", sc=1, dl=0, f={
                {x=59.45, y=536.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_category_descb", sc=1, dl=0, f={
                {x=161.45, y=540.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_overlay", sc=1, dl=0, f={
                {x=65.45, y=504, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_overlay_descrb", sc=1, dl=0, f={
                {x=153.45, y=502.6, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_output", sc=1, dl=0, f={
                {x=71.45, y=471.6, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_output_descb", sc=1, dl=0, f={
                {x=151.45, y=471.6, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_specification", sc=1, dl=0, f={
                {x=65.45, y=329.65, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid", sc=1, dl=0, f={
                {x=257, y=630, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=40, y=80, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button_1", sc=1, dl=0, f={
                {x=206, y=80, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="equip_detail_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=645, kx=0, ky=0, cx=95, cy=161.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=645, kx=0, ky=0, cx=4.81, cy=8.16, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_1", sc=1, dl=0, f={
                {x=14, y=475, kx=0, ky=0, cx=1.45, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_2", sc=1, dl=0, f={
                {x=14, y=247, kx=0, ky=0, cx=1.45, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_name", sc=1, dl=0, f={
                {x=57.45, y=601.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_strengthen_level", sc=1, dl=0, f={
                {x=193.45, y=601.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_mark", sc=1, dl=0, f={
                {x=34, y=512, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_equiped_descb", sc=1, dl=0, f={
                {x=32.45, y=567, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_increase_descb", sc=1, dl=0, f={
                {x=234.45, y=512.6, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_add_green", sc=1, dl=0, f={
                {x=64.45, y=409.6, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_add_yellow", sc=1, dl=0, f={
                {x=54.45, y=367.65, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_specification", sc=1, dl=0, f={
                {x=25.45, y=217.7, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid", sc=1, dl=0, f={
                {x=257, y=630, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=124, y=80, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button2", sc=1, dl=0, f={
                {x=124, y=80, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_increase", sc=1, dl=0, f={
                {x=175.5, y=522.7, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_decrease", sc=1, dl=0, f={
                {x=175.5, y=522.7, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="equip_detail_ui_small", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=425, kx=0, ky=0, cx=95, cy=106.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=425, kx=0, ky=0, cx=4.81, cy=5.38, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_1", sc=1, dl=0, f={
                {x=14, y=255, kx=0, ky=0, cx=1.45, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_name", sc=1, dl=0, f={
                {x=57.45, y=381.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_strengthen_level", sc=1, dl=0, f={
                {x=193.45, y=381.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_mark", sc=1, dl=0, f={
                {x=34, y=292, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_equiped_descb", sc=1, dl=0, f={
                {x=32.45, y=347, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_increase_descb", sc=1, dl=0, f={
                {x=234.45, y=292.6, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_add_green", sc=1, dl=0, f={
                {x=64.45, y=189.6, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_prop_add_yellow", sc=1, dl=0, f={
                {x=54.45, y=147.64999999999998, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_item_specification", sc=1, dl=0, f={
                {x=25.45, y=220.7, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid", sc=1, dl=0, f={
                {x=257, y=410, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=124, y=88, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button2", sc=1, dl=0, f={
                {x=124, y=88, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_increase", sc=1, dl=0, f={
                {x=175.5, y=302.7, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_decrease", sc=1, dl=0, f={
                {x=175.5, y=302.7, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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