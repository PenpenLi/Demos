local conf = {type="skeleton", name="common_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="common_gonggao_panel", 
      bones={           
           {type="b", name="hit_area", x=0, y=363, kx=0, ky=0, cx=137.5, cy=88.75, z=0, d={{name="commonBackgrounds/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_4", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=34.5, y=315.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="common_background_6", x=69, y=225.7, kx=0, ky=0, cx=4.78, cy=1, z=3, d={{name="commonBackgroundScalables/common_background_6", isArmature=0}} },
           {type="b", name="common_close_button", x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_close_button_normal", isArmature=0}} },
           {type="b", name="common_small_blue_button", x=197, y=79.19999999999999, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_small_blue_button_normal", isArmature=0}} },
           {type="b", name="common_content", x=331, y=201.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=87,y=162, w=351, h=39,lineType="single line",size=26,color="ffebd6",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="common_descb", x=331, y=292.35, kx=0, ky=0, cx=1, cy=1, z=7, text={x=114,y=237, w=351, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_input_panel", 
      bones={           
           {type="b", name="hit_area", x=0, y=363, kx=0, ky=0, cx=137.5, cy=88.75, z=0, d={{name="commonBackgrounds/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_4", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=34.5, y=315.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="common_close_button", x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_close_button_normal", isArmature=0}} },
           {type="b", name="common_blueround_button", x=62, y=87, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_blueround_button_1", x=276, y=87, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_descb", x=331, y=211.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=61,y=111, w=410, h=171,lineType="single line",size=24,color="d6d6d6",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="common_input_bg", x=72, y=178, kx=0, ky=0, cx=15.6, cy=2.38, z=7, d={{name="commonBackgrounds/common_scale_bg", isArmature=0}} },
           {type="b", name="common_input", x=88, y=147.15, kx=0, ky=0, cx=1, cy=1, z=8, text={x=88,y=138, w=355, h=36,lineType="single line",size=24,color="000000",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_popup_panel", 
      bones={           
           {type="b", name="hit_area", x=0, y=363, kx=0, ky=0, cx=137.5, cy=90, z=0, d={{name="commonBackgrounds/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_4", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=34.5, y=309.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="common_close_button", x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_close_button_normal", isArmature=0}} },
           {type="b", name="common_blueround_button", x=276.5, y=80, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_blueround_button_1", x=62, y=80, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_descb", x=331, y=205.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=61,y=110, w=410, h=171,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_small_loading", 
      bones={           
           {type="b", name="hit_area", x=0, y=960, kx=0, ky=0, cx=320, cy=240, z=0, d={{name="commonBackgrounds/common_hit_area", isArmature=0}} },
           {type="b", name="common_blackHalfAlpha_bg", x=0, y=960, kx=0, ky=0, cx=1, cy=1, z=1, text={x=390,y=434, w=500, h=36,lineType="single line",size=24,color="d6d6d6",alignment="center",space=0,textType="static"}, d={{name="commonBackgrounds/common_blackHalfAlpha_bg", isArmature=0}} },
           {type="b", name="effect", x=635.5, y=604.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonBackgroundScalables/commonBackgroundScalables", 
      bones={           
           {type="b", name="common_background_1", x=0, y=298.35, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonBackgroundScalables/common_background_1", isArmature=0}} },
           {type="b", name="common_background_2", x=69, y=298.35, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonBackgroundScalables/common_background_2", isArmature=0}} },
           {type="b", name="common_background_3", x=143.35, y=322, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonBackgroundScalables/common_background_3", isArmature=0}} },
           {type="b", name="common_background_4", x=259.35, y=298.35, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonBackgroundScalables/common_background_4", isArmature=0}} },
           {type="b", name="common_background_6", x=-218.6, y=176.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonBackgroundScalables/common_background_6", isArmature=0}} },
           {type="b", name="common_background_7", x=-83, y=184.00000000000003, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonBackgroundScalables/common_background_7", isArmature=0}} },
           {type="b", name="common_blue_bg", x=384.5, y=284.40000000000003, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="common_blue_bg", isArmature=0}} },
           {type="b", name="common_blue_over", x=460.5, y=302.40000000000003, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_blue_over", isArmature=0}} },
           {type="b", name="common_red_background", x=552.35, y=289, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonBackgroundScalables/common_red_background", isArmature=0}} },
           {type="b", name="common_item_num_bg", x=207, y=366.35, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_item_num_bg", isArmature=0}} },
           {type="b", name="common_grid_fg", x=243.35, y=160.40000000000003, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonGrids/common_grid_fg", isArmature=0}} },
           {type="b", name="图层 2", x=86.5, y=186.90000000000003, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonBackgroundScalables/common_bantou_jiugongge", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_page_button", 
      bones={           
           {type="b", name="common_page_button", x=0, y=31, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_page_button_normal", isArmature=0},{name="commonButtons/common_page_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/commonButtons", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=362, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_blue_button", isArmature=1}} },
           {type="b", name="common_return_button", x=250.95, y=114, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_return_button", isArmature=1}} },
           {type="b", name="common_close_button", x=196.6, y=362, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_close_button", isArmature=1}} },
           {type="b", name="common_ask_button", x=290.85, y=356.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_ask_button", isArmature=1}} },
           {type="b", name="common_page_button", x=396.55, y=88, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_page_button2", isArmature=1}} },
           {type="b", name="common_tab_button", x=118, y=162, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_tab_button", isArmature=1}} },
           {type="b", name="common_channel_button", x=0, y=162, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_channel_button", isArmature=1}} },
           {type="b", name="common_big_blue_button", x=0, y=272, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_big_blue_button", isArmature=1}} },
           {type="b", name="common_small_blue_button", x=365.85, y=328.7, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_small_blue_button", isArmature=1}} },
           {type="b", name="common_small_orange_button", x=501.8, y=334.7, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_small_orange_button", isArmature=1}} },
           {type="b", name="common_red_button", x=403.85, y=249.7, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_red_button", isArmature=1}} },
           {type="b", name="common_small_red_button", x=581.75, y=307.2, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_small_red_button", isArmature=1}} },
           {type="b", name="common_fightbutton", x=473.85, y=159.55, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_fightbutton", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_blue_button_normal", isArmature=0},{name="commonButtons/common_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_return_button", 
      bones={           
           {type="b", name="common_return_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_return_button_normal", isArmature=0},{name="commonButtons/common_return_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_close_button_normal", isArmature=0},{name="commonButtons/common_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_ask_button_normal", isArmature=0},{name="commonButtons/common_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_page_button2", 
      bones={           
           {type="b", name="common_page_button2", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_page_button_normal2", isArmature=0},{name="commonButtons/common_page_button_down2", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_tab_button", 
      bones={           
           {type="b", name="common_tab_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_tab_button_normal", isArmature=0},{name="commonButtons/common_tab_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=28,y=-108, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_channel_button_normal", isArmature=0},{name="commonButtons/common_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_big_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_big_blue_button_normal", isArmature=0},{name="commonButtons/common_big_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=16,y=-45, w=101, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_small_blue_button_normal", isArmature=0},{name="commonButtons/common_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_small_orange_button", 
      bones={           
           {type="b", name="common_small_orange_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=-41, w=101, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_small_orange_button_normal", isArmature=0},{name="commonButtons/common_small_orange_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_red_button_normal", isArmature=0},{name="commonButtons/common_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-45, w=105, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_small_red_button_normal", isArmature=0},{name="commonButtons/common_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_fightbutton", 
      bones={           
           {type="b", name="fightbutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_fightbutton_normal", isArmature=0},{name="commonButtons/common_fightbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonCurrencyImages/commonCurrencyImages", 
      bones={           
           {type="b", name="common_silver_bg", x=0, y=55.85, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonCurrencyImages/common_silver_bg", isArmature=0}} },
           {type="b", name="common_exp_bg", x=335.5, y=54.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonCurrencyImages/common_exp_bg", isArmature=0}} },
           {type="b", name="common_youqing_bg", x=240, y=55.85, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonCurrencyImages/common_youqing_bg", isArmature=0}} },
           {type="b", name="common_add_bg", x=287.5, y=55, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_add_bg", isArmature=0}} },
           {type="b", name="common_linglongling_bg", x=180, y=55.85, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonCurrencyImages/common_linglongling_bg", isArmature=0}} },
           {type="b", name="common_shengwang_bg", x=392.5, y=52, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonCurrencyImages/common_shengwang_bg", isArmature=0}} },
           {type="b", name="common_gold_bg", x=60, y=55.85, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonCurrencyImages/common_gold_bg", isArmature=0}} },
           {type="b", name="common_honor_bg", x=450.35, y=47, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonCurrencyImages/common_honor_bg", isArmature=0}} },
           {type="b", name="common_tili_bg", x=120, y=55.85, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonCurrencyImages/common_tili_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonGrids/commonGrids", 
      bones={           
           {type="b", name="common_grid", x=0, y=328.54999999999995, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonGrids/common_grid", isArmature=0}} },
           {type="b", name="common_grid_over", x=117.7, y=328.54999999999995, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonGrids/common_grid_over", isArmature=0}} },
           {type="b", name="common_grid_1", x=7.95, y=463.9, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonGrids/common_grid_1", isArmature=0}} },
           {type="b", name="common_grid_2", x=133.9, y=459.9, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonGrids/common_grid_2", isArmature=0}} },
           {type="b", name="common_grid_3", x=268.85, y=471.5499999999999, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonGrids/common_big_grid_3", isArmature=0}} },
           {type="b", name="common_grid_4", x=441.8, y=449.9, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonGrids/common_grid_3", isArmature=0}} },
           {type="b", name="common_grid_5", x=566.75, y=479.5499999999999, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonGrids/common_big_grid_5", isArmature=0}} },
           {type="b", name="common_grid_6", x=732.7, y=469.5499999999999, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonGrids/common_big_grid_6", isArmature=0}} },
           {type="b", name="common_grid_7", x=-12.05, y=178, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonGrids/common_grid_4", isArmature=0}} },
           {type="b", name="common_grid_8", x=108.9, y=195.65, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonGrids/common_big_grid_8", isArmature=0}} },
           {type="b", name="common_grid_9", x=284.85, y=221.65, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonGrids/common_big_grid_9", isArmature=0}} },
           {type="b", name="common_grid_10", x=499.8, y=176, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonGrids/common_grid_5", isArmature=0}} },
           {type="b", name="common_grid_11", x=677.7, y=190, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonGrids/common_grid_6", isArmature=0}} },
           {type="b", name="common_grid_12", x=753.65, y=463.9, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_round_grid_1", isArmature=0}} },
           {type="b", name="common_round_grid_2", x=855.65, y=459.9, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_round_grid_2", isArmature=0}} },
           {type="b", name="common_round_grid_3", x=957.65, y=459.9, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_round_grid_3", isArmature=0}} },
           {type="b", name="common_round_grid_4", x=1059.65, y=455.9, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_round_grid_4", isArmature=0}} },
           {type="b", name="common_round_grid_5", x=1161.5, y=455.9, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_round_grid_5", isArmature=0}} },
           {type="b", name="common_round_grid_6", x=1263.5, y=459.9, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonImages/common_round_grid_6", isArmature=0}} },
           {type="b", name="common_round_grid_7", x=591.45, y=260.95, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonGrids/common_grid_7", isArmature=0}} }
         }
      },
    {type="armature", name="commonImages/common_tfImgs", 
      bones={           
           {type="b", name="图层 2", x=230, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_tfImg6", isArmature=0}} },
           {type="b", name="图层 3", x=114, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_tfImg5", isArmature=0}} },
           {type="b", name="图层 4", x=-2, y=15.650000000000006, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_tfImg4", isArmature=0}} },
           {type="b", name="图层 5", x=215, y=80.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_tfImg3", isArmature=0}} },
           {type="b", name="图层 6", x=112, y=81.65, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_tfImg2", isArmature=0}} },
           {type="b", name="图层 7", x=-1, y=82.65, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_tfImg1", isArmature=0}} }
         }
      },
    {type="armature", name="commonImages/commonImages", 
      bones={           
           {type="b", name="common_image_increase", x=0, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonImages/common_image_increase", isArmature=0}} },
           {type="b", name="common_huobi_bg2", x=1719.25, y=1670.1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_huobi_bg2", isArmature=0}} },
           {type="b", name="common_checkNormal", x=3, y=2945.9, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_checkNormal", isArmature=0}} },
           {type="b", name="common_checkSelect", x=75, y=2945.9, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_checkSelect", isArmature=0}} },
           {type="b", name="common_headerBg", x=188.95, y=2929.5499999999997, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_headerBg", isArmature=0}} },
           {type="b", name="common_headerBg2", x=354.3, y=2929.5499999999997, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_headerBg2", isArmature=0}} },
           {type="b", name="common_newFontImg", x=-1, y=2856.85, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_newFontImg", isArmature=0}} },
           {type="b", name="common_star_kong_small", x=95.5, y=3014.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_star_kong_small", isArmature=0}} },
           {type="b", name="common_rightImg", x=241.85, y=3058, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_rightImg", isArmature=0}} },
           {type="b", name="common_joinWar", x=112.85, y=3044, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_joinWar", isArmature=0}} },
           {type="b", name="common_xuanzhong_img", x=359.8, y=3075.9, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_xuanzhong_img", isArmature=0}} },
           {type="b", name="common_not_open", x=372.3, y=3137, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_not_open", isArmature=0}} },
           {type="b", name="common_zhanli_bg", x=970.5, y=3057.7999999999997, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_zhanli_bg", isArmature=0}} },
           {type="b", name="common_image_decrease", x=50, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_image_decrease", isArmature=0}} },
           {type="b", name="common_image_separator", x=116.85, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonImages/common_image_separator", isArmature=0}} },
           {type="b", name="common_yellow_line1", x=178.5, y=3078.5, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_yellow_line1", isArmature=0}} },
           {type="b", name="common_black_lock", x=515.6, y=3103.35, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonImages/common_black_lock", isArmature=0}} },
           {type="b", name="common_puzzle", x=577.5, y=3114.5, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonImages/common_puzzle", isArmature=0}} },
           {type="b", name="common_star_1", x=0, y=3035.85, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonImages/common_star_1", isArmature=0}} },
           {type="b", name="common_star_small", x=73.35, y=3016.5, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonImages/common_star_small", isArmature=0}} },
           {type="b", name="common_button_bg", x=736.15, y=3075.85, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="common_huaWen1", x=-1, y=3293.5, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonImages/common_huaWen1", isArmature=0}} },
           {type="b", name="common_huaWen2", x=28.85, y=3198, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonImages/common_huaWen2", isArmature=0}} },
           {type="b", name="common_biaoti_new", x=-319.6, y=3238.85, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="common_biaoti_new", isArmature=0}} },
           {type="b", name="common_biaoti", x=-257, y=3307.7999999999997, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="commonImages/common_biaoti", isArmature=0}} },
           {type="b", name="common_biaoti_bg", x=-298.5, y=3170.85, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonImages/common_biaoti_bg", isArmature=0}} },
           {type="b", name="common_zhanLi", x=354.3, y=3285.5, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="commonImages/common_zhanLi", isArmature=0}} },
           {type="b", name="common_lvImg", x=95.5, y=2844.4, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonImages/common_lvImg", isArmature=0}} },
           {type="b", name="common_nameBg", x=561.45, y=3307.0499999999997, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="commonImages/common_nameBg", isArmature=0}} },
           {type="b", name="common_starBg", x=657.3, y=3230.5, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="commonImages/common_starBg", isArmature=0}} },
           {type="b", name="common_friendNameBg", x=433.15, y=3367.45, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonImages/common_friendNameBg", isArmature=0}} },
           {type="b", name="common_huaWenImg", x=-87.05, y=2418.5, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="commonImages/common_huaWenImg", isArmature=0}} },
           {type="b", name="common_input_bg", x=-45.15, y=2088.3999999999996, kx=0, ky=0, cx=1, cy=1, z=32, d={{name="commonImages/common_input_bg", isArmature=0}} },
           {type="b", name="common_begin_game", x=395.8, y=2418.5, kx=0, ky=0, cx=1, cy=1, z=33, d={{name="commonImages/common_begin_game", isArmature=0}} },
           {type="b", name="common_round_mask", x=706.95, y=2509.1, kx=0, ky=0, cx=1, cy=1, z=34, d={{name="commonImages/common_round_mask", isArmature=0}} },
           {type="b", name="common_shuxing_1", x=-76.5, y=2586.5, kx=0, ky=0, cx=1, cy=1, z=35, d={{name="commonImages/common_shuxing_2", isArmature=0}} },
           {type="b", name="common_shuxing_2", x=75, y=2586.5, kx=0, ky=0, cx=1, cy=1, z=36, d={{name="commonImages/common_shuxing_3", isArmature=0}} },
           {type="b", name="common_shuxing_3", x=33.85, y=2758, kx=0, ky=0, cx=1, cy=1, z=37, d={{name="commonImages/common_shuxing_4", isArmature=0}} },
           {type="b", name="common_shuxing_4", x=137.85, y=2752.85, kx=0, ky=0, cx=1, cy=1, z=38, d={{name="commonImages/common_shuxing_5", isArmature=0}} },
           {type="b", name="common_shuxing_10", x=-236.15, y=2582, kx=0, ky=0, cx=1, cy=1, z=39, d={{name="commonImages/common_shuxing_1", isArmature=0}} },
           {type="b", name="common_hero_star_empty", x=468.85, y=2986.85, kx=0, ky=0, cx=1, cy=1, z=40, d={{name="commonImages/common_hero_star_empty", isArmature=0}} },
           {type="b", name="common_hero_star", x=561.45, y=3024.85, kx=0, ky=0, cx=1, cy=1, z=41, d={{name="commonImages/common_hero_star", isArmature=0}} },
           {type="b", name="hero_frame_left", x=2219.2, y=3474.6, kx=0, ky=0, cx=1, cy=1, z=42, d={{name="hero_frame/common_hero_frame_left", isArmature=0}} },
           {type="b", name="hero_frame_right", x=1730.9, y=3474.6, kx=0, ky=0, cx=1, cy=1, z=43, d={{name="hero_frame/common_hero_frame_right", isArmature=0}} },
           {type="b", name="hero_frame_pattern", x=914.55, y=2612.75, kx=0, ky=0, cx=1, cy=1, z=44, d={{name="hero_frame/common_hero_frame_pattern", isArmature=0}} },
           {type="b", name="hero_frame_mozhi", x=-288.95, y=2856.85, kx=0, ky=0, cx=1, cy=1, z=45, d={{name="hero_frame/common_hero_frame_mozhi", isArmature=0}} },
           {type="b", name="hero_frame_top", x=1713.5, y=3558.6, kx=0, ky=0, cx=1, cy=1, z=46, d={{name="hero_frame/common_hero_frame_top", isArmature=0}} },
           {type="b", name="hero_frame_bottom", x=1730.9, y=2642.85, kx=0, ky=0, cx=1, cy=1, z=47, d={{name="hero_frame/common_hero_frame_bottom", isArmature=0}} },
           {type="b", name="common_greenArrow", x=662.35, y=2922.85, kx=0, ky=0, cx=1, cy=1, z=48, d={{name="commonImages/common_greenArrow", isArmature=0}} },
           {type="b", name="common_line_down", x=321.95, y=2741.4, kx=0, ky=0, cx=1, cy=1, z=49, d={{name="common_line_down", isArmature=0}} },
           {type="b", name="common_line_vertical", x=740.6, y=2818.85, kx=0, ky=0, cx=1, cy=1, z=50, d={{name="commonImages/common_line_vertical", isArmature=0}} },
           {type="b", name="common_line_horizon", x=740.6, y=2818.85, kx=0, ky=0, cx=1, cy=1, z=51, d={{name="commonImages/common_line_horizon", isArmature=0}} },
           {type="b", name="common_redIcon", x=-308, y=3307.7999999999997, kx=0, ky=0, cx=1, cy=1, z=52, d={{name="commonImages/common_redIcon", isArmature=0}} },
           {type="b", name="common_xiaomodi", x=-266, y=2719.85, kx=0, ky=0, cx=1, cy=1, z=53, d={{name="commonImages/common_xiaomodi", isArmature=0}} },
           {type="b", name="图层 2", x=409, y=3443.75, kx=0, ky=0, cx=1, cy=1, z=54, d={{name="commonImages/common_currency_moji", isArmature=0}} },
           {type="b", name="图层 3", x=667.75, y=3443.75, kx=0, ky=0, cx=1, cy=1, z=55, d={{name="commonImages/common_yeqian_bg", isArmature=0}} },
           {type="b", name="图层 4", x=805.3, y=3437.75, kx=0, ky=0, cx=1, cy=1, z=56, d={{name="commonImages/common_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="图层 6", x=782.3, y=3400.75, kx=0, ky=0, cx=1, cy=1, z=57, d={{name="commonImages/common_mingzi_bg", isArmature=0}} },
           {type="b", name="图层 6_2", x=903.3, y=3404.45, kx=0, ky=0, cx=1, cy=1, z=58, d={{name="commonImages/common_mingzi_bg_2", isArmature=0}} },
           {type="b", name="图层 5", x=957.15, y=3251.5, kx=0, ky=0, cx=1, cy=1, z=59, d={{name="commonImages/common_small_name_bg", isArmature=0}} },
           {type="b", name="图层 7", x=966.15, y=3204.5, kx=0, ky=0, cx=1, cy=1, z=60, d={{name="commonImages/common_circle_bg", isArmature=0}} },
           {type="b", name="common_huobi_bg", x=901.8, y=3444.75, kx=0, ky=0, cx=1, cy=1, z=61, d={{name="commonImages/common_huobi_bg", isArmature=0}} },
           {type="b", name="图层 10", x=1043.55, y=3291.5, kx=0, ky=0, cx=1, cy=1, z=62, d={{name="commonImages/linghunshi_fg", isArmature=0}} },
           {type="b", name="图层 11", x=1157.55, y=3291.5, kx=0, ky=0, cx=1, cy=1, z=63, d={{name="commonImages/linghunshi_mask", isArmature=0}} },
           {type="b", name="图层 16", x=1494.9, y=1821.05, kx=0, ky=0, cx=1, cy=1, z=64, d={{name="hero_frame/common_big_card_color_3", isArmature=0}} },
           {type="b", name="图层 17", x=1606.9, y=1809.05, kx=0, ky=0, cx=1, cy=1, z=65, d={{name="hero_frame/common_big_card_color_5", isArmature=0}} },
           {type="b", name="图层 18", x=1730.9, y=1821.05, kx=0, ky=0, cx=1, cy=1, z=66, d={{name="hero_frame/common_big_card_color_6", isArmature=0}} },
           {type="b", name="图层 19", x=1875, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=67, d={{name="hero_frame/common_big_card_color_8", isArmature=0}} },
           {type="b", name="图层 20", x=1979, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=68, d={{name="hero_frame/common_big_card_color_9", isArmature=0}} },
           {type="b", name="图层 21", x=2119.05, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=69, d={{name="hero_frame/common_big_card_color_10", isArmature=0}} },
           {type="b", name="图层 22", x=1512.4, y=1669.6999999999998, kx=0, ky=0, cx=1, cy=1, z=70, d={{name="hero_frame/common_big_card_star", isArmature=0}} },
           {type="b", name="图层 23", x=1628.5, y=1669.6999999999998, kx=0, ky=0, cx=1, cy=1, z=71, d={{name="hero_frame/common_big_card_star_empty", isArmature=0}} },
           {type="b", name="图层 24", x=1297.95, y=3273.7999999999997, kx=0, ky=0, cx=1, cy=1, z=72, d={{name="commonImages/common_lingjiangli_img", isArmature=0}} },
           {type="b", name="图层 25", x=1063.4, y=3173.85, kx=0, ky=0, cx=1, cy=1, z=73, d={{name="commonImages/common_player_bg", isArmature=0}} },
           {type="b", name="图层 26", x=966.15, y=2897.9, kx=0, ky=0, cx=1, cy=1, z=74, d={{name="commonImages/common_red_bg", isArmature=0}} },
           {type="b", name="图层 27", x=997.15, y=2469, kx=0, ky=0, cx=1, cy=1, z=75, d={{name="hero_frame/common_big_card_color_bg_1_1", isArmature=0}} },
           {type="b", name="图层 29", x=1113.9, y=2469, kx=0, ky=0, cx=1, cy=1, z=76, d={{name="hero_frame/common_big_card_color_bg_1_3", isArmature=0}} },
           {type="b", name="图层 30", x=1118.8, y=2358.45, kx=0, ky=0, cx=1, cy=1, z=77, d={{name="hero_frame/common_big_card_color_bg_1_4", isArmature=0}} },
           {type="b", name="图层 31", x=1385.45, y=2230.35, kx=0, ky=0, cx=1, cy=1, z=78, d={{name="hero_frame/common_big_card_color_bg_2_1", isArmature=0}} },
           {type="b", name="图层 33", x=1546.2, y=2165.3999999999996, kx=0, ky=0, cx=1, cy=1, z=79, d={{name="hero_frame/common_big_card_color_bg_2_3", isArmature=0}} },
           {type="b", name="图层 34", x=1530.15, y=1589.6999999999998, kx=0, ky=0, cx=1, cy=1, z=80, d={{name="hero_frame/common_big_card_color_bg_2_4", isArmature=0}} },
           {type="b", name="图层 35", x=2447.6, y=2741.4, kx=0, ky=0, cx=1, cy=1, z=81, d={{name="hero_frame/common_big_card_color_bg_3_1", isArmature=0}} },
           {type="b", name="图层 37", x=2850.25, y=2719.85, kx=0, ky=0, cx=1, cy=1, z=82, d={{name="hero_frame/common_big_card_color_bg_3_3", isArmature=0}} },
           {type="b", name="图层 38", x=2704.1, y=2000.4, kx=0, ky=0, cx=1, cy=1, z=83, d={{name="hero_frame/common_big_card_color_bg_3_4", isArmature=0}} },
           {type="b", name="图层 39", x=2483.6, y=3961.85, kx=0, ky=0, cx=1, cy=1, z=84, d={{name="hero_frame/common_big_card_color_bg_4_1", isArmature=0}} },
           {type="b", name="图层 41", x=2704.1, y=3934.6, kx=0, ky=0, cx=1, cy=1, z=85, d={{name="hero_frame/common_big_card_color_bg_4_3", isArmature=0}} },
           {type="b", name="图层 42", x=2662.2, y=3238.5, kx=0, ky=0, cx=1, cy=1, z=86, d={{name="hero_frame/common_big_card_color_bg_4_4", isArmature=0}} },
           {type="b", name="图层 43", x=2191.55, y=4476.2, kx=0, ky=0, cx=1, cy=1, z=87, d={{name="hero_frame/common_big_card_color_bg_5_1", isArmature=0}} },
           {type="b", name="图层 45", x=2402.15, y=4370.7, kx=0, ky=0, cx=1, cy=1, z=88, d={{name="hero_frame/common_big_card_color_bg_5_3", isArmature=0}} },
           {type="b", name="图层 46", x=2366.15, y=3735.2, kx=0, ky=0, cx=1, cy=1, z=89, d={{name="hero_frame/common_big_card_color_bg_5_4", isArmature=0}} },
           {type="b", name="图层 47", x=1009.3, y=3580.45, kx=0, ky=0, cx=1, cy=1, z=90, d={{name="commonImages/common_position_slot", isArmature=0}} },
           {type="b", name="图层 48", x=1151.55, y=3585.7, kx=0, ky=0, cx=1, cy=1, z=91, d={{name="commonImages/common_position_slot_over", isArmature=0}} },
           {type="b", name="lvse_duihao", x=805.3, y=3164.85, kx=0, ky=0, cx=1, cy=1, z=92, d={{name="commonImages/lvse_duihao", isArmature=0}} }
         }
      },
    {type="armature", name="commonNumbers/commonNumbers", 
      bones={           
           {type="b", name="common_number9", x=403.35, y=80.65000000000002, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonNumbers/common_number9", isArmature=0}} },
           {type="b", name="common_number8", x=314.35, y=73.65000000000002, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonNumbers/common_number8", isArmature=0}} },
           {type="b", name="common_number7", x=221.35, y=71.65000000000002, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonNumbers/common_number7", isArmature=0}} },
           {type="b", name="common_number6", x=124.35, y=69.65000000000002, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonNumbers/common_number6", isArmature=0}} },
           {type="b", name="common_number5", x=13.35, y=77.65000000000002, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonNumbers/common_number5", isArmature=0}} },
           {type="b", name="common_number4", x=407.35, y=193.6, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonNumbers/common_number4", isArmature=0}} },
           {type="b", name="common_number3", x=329.35, y=198.6, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonNumbers/common_number3", isArmature=0}} },
           {type="b", name="common_number2", x=242.35, y=200.6, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonNumbers/common_number2", isArmature=0}} },
           {type="b", name="common_number1", x=140.35, y=184.6, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonNumbers/common_number1", isArmature=0}} },
           {type="b", name="common_number0", x=18, y=187.6, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonNumbers/common_number0", isArmature=0}} }
         }
      },
    {type="armature", name="commonNumbers/commonVips", 
      bones={           
           {type="b", name="common_vip9", x=403.35, y=170.29999999999995, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonNumbers/common_vip9", isArmature=0}} },
           {type="b", name="common_vip8", x=314.35, y=163.29999999999995, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonNumbers/common_vip8", isArmature=0}} },
           {type="b", name="common_vip7", x=221.35, y=161.29999999999995, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonNumbers/common_vip7", isArmature=0}} },
           {type="b", name="common_vip6", x=124.35, y=159.29999999999995, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonNumbers/common_vip6", isArmature=0}} },
           {type="b", name="common_vip5", x=13.35, y=167.29999999999995, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonNumbers/common_vip5", isArmature=0}} },
           {type="b", name="common_vip4", x=407.35, y=283.24999999999994, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonNumbers/common_vip4", isArmature=0}} },
           {type="b", name="common_vip3", x=329.35, y=288.24999999999994, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonNumbers/common_vip3", isArmature=0}} },
           {type="b", name="common_vip2", x=242.35, y=290.24999999999994, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonNumbers/common_vip2", isArmature=0}} },
           {type="b", name="common_vip1", x=140.35, y=274.24999999999994, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonNumbers/common_vip1", isArmature=0}} },
           {type="b", name="common_vip0", x=18, y=277.24999999999994, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonNumbers/common_vip0", isArmature=0}} },
           {type="b", name="common_mainui_vip9", x=298.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonNumbers/common_mainui_vip9", isArmature=0}} },
           {type="b", name="common_mainui_vip8", x=270.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonNumbers/common_mainui_vip8", isArmature=0}} },
           {type="b", name="common_mainui_vip7", x=244.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonNumbers/common_mainui_vip7", isArmature=0}} },
           {type="b", name="common_mainui_vip6", x=222.35, y=108.74999999999996, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonNumbers/common_mainui_vip6", isArmature=0}} },
           {type="b", name="common_mainui_vip5", x=176.35, y=108.74999999999996, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonNumbers/common_mainui_vip5", isArmature=0}} },
           {type="b", name="common_mainui_vip4", x=141.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonNumbers/common_mainui_vip4", isArmature=0}} },
           {type="b", name="common_mainui_vip3", x=110.35, y=110.74999999999996, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonNumbers/common_mainui_vip3", isArmature=0}} },
           {type="b", name="common_mainui_vip2", x=78.35, y=110.74999999999996, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonNumbers/common_mainui_vip2", isArmature=0}} },
           {type="b", name="common_mainui_vip1", x=45.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonNumbers/common_mainui_vip1", isArmature=0}} },
           {type="b", name="common_mainui_vip0", x=15.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonNumbers/common_mainui_vip0", isArmature=0}} },
           {type="b", name="common_mainui_vip", x=330.7, y=110.79999999999995, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="commonNumbers/common_mainui_vip", isArmature=0}} },
           {type="b", name="common_mainui_vip_normal", x=13.35, y=64.64999999999998, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonNumbers/common_mainui_vip_normal", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBar/common_blue_progress_bar", 
      bones={           
           {type="b", name="common_blue_progress_bar_bg", x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBar/common_blue_progress_bar_bg", isArmature=0}} },
           {type="b", name="common_blue_progress_bar_fg", x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBar/common_blue_progress_bar_fg", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBar/common_red_progress_bar", 
      bones={           
           {type="b", name="common_red_progress_bar_bg", x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBar/common_red_progress_bar_bg", isArmature=0}} },
           {type="b", name="common_red_progress_bar_fg", x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBar/common_red_progress_bar_fg", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBars/commonPgs", 
      bones={           
           {type="b", name="common_pg_star", x=218.3, y=21.65000000000001, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBars/common_pg_star", isArmature=0}} },
           {type="b", name="common_exp_progress_bar", x=-184.65, y=88.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBars/common_exp_progress_bar", isArmature=1}} }
         }
      },
    {type="armature", name="commonProgressBars/common_exp_progress_bar", 
      bones={           
           {type="b", name="pro_down", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBars/common_pg_bg", isArmature=0}} },
           {type="b", name="pro_up", x=63, y=-42, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBars/common_pg_bar", isArmature=0}} }
         }
      },
    {type="armature", name="commonSingleImgButtons/commonSingleImgButtons", 
      bones={           
           {type="b", name="common_leftArrow_button", x=55.7, y=295.15, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonSingleImgButtons/common_leftArrow_button", isArmature=0}} },
           {type="b", name="common_rightArrow_button", x=59.7, y=174.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonSingleImgButtons/common_rightArrow_button", isArmature=0}} }
         }
      },
    {type="armature", name="huobiGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=118, kx=0, ky=0, cx=258.75, cy=29.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="tili_bantou", x=828, y=106, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_huobi_bg2", isArmature=0}} },
           {type="b", name="tiliText", x=902.95, y=54, kx=0, ky=0, cx=1, cy=1, z=2, text={x=859,y=68, w=142, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="tili", x=798, y=117, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_tili_bg", isArmature=0}} },
           {type="b", name="yuanbao_bantou", x=603, y=106, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_huobi_bg2", isArmature=0}} },
           {type="b", name="yuanbaoText", x=673.95, y=56, kx=0, ky=0, cx=1, cy=1, z=5, text={x=634,y=65, w=148, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="yuanbao", x=563, y=117, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonCurrencyImages/common_gold_bg", isArmature=0}} },
           {type="b", name="yingliang_bantou", x=346, y=106, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_huobi_bg2", isArmature=0}} },
           {type="b", name="yinliangText", x=383, y=65.4, kx=0, ky=0, cx=1, cy=1, z=8, text={x=383,y=65, w=156, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_button_bg", isArmature=0}} },
           {type="b", name="yinliang", x=309, y=118, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonCurrencyImages/common_silver_bg", isArmature=0}} },
           {type="b", name="jia_tili", x=981, y=111, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonCurrencyImages/common_add_bg", isArmature=0}} },
           {type="b", name="jia_yuanbao", x=750, y=111, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonCurrencyImages/common_add_bg", isArmature=0}} },
           {type="b", name="jia_yingliang", x=503, y=111, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonCurrencyImages/common_add_bg", isArmature=0}} }
         }
      },
    {type="armature", name="loading_show_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="img_3", x=1195, y=187, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="loadingImages/img_3", isArmature=0}} },
           {type="b", name="img_2", x=1050, y=435, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="loadingImages/img_2", isArmature=0}} },
           {type="b", name="img_1", x=1080, y=395, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="loadingImages/img_1", isArmature=0}} },
           {type="b", name="progress", x=45, y=70, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="loadingImages/progress_bg", isArmature=0}} },
           {type="b", name="progress_descb", x=520.95, y=84.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, text={x=390,y=0, w=500, h=47,lineType="single line",size=32,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="loadingImages/imgs", 
      bones={           
           {type="b", name="图层 3", x=60.5, y=472, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="loadingImages/img_5", isArmature=0}} },
           {type="b", name="图层 4", x=129.5, y=472, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="loadingImages/img_6", isArmature=0}} },
           {type="b", name="图层 5", x=186, y=472, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="loadingImages/img_7", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="common_gonggao_panel", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=363, kx=0, ky=0, cx=137.5, cy=88.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="common_background_6", sc=1, dl=0, f={
                {x=69, y=225.7, kx=0, ky=0, cx=4.78, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=197, y=79.19999999999999, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_content", sc=1, dl=0, f={
                {x=331, y=201.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_descb", sc=1, dl=0, f={
                {x=331, y=292.35, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_input_panel", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=363, kx=0, ky=0, cx=137.5, cy=88.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=62, y=87, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blueround_button_1", sc=1, dl=0, f={
                {x=276, y=87, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_descb", sc=1, dl=0, f={
                {x=331, y=211.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_input_bg", sc=1, dl=0, f={
                {x=72, y=178, kx=0, ky=0, cx=15.6, cy=2.38, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_input", sc=1, dl=0, f={
                {x=88, y=147.15, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_popup_panel", 
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
                {x=34.5, y=309.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=478, y=363, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blueround_button", sc=1, dl=0, f={
                {x=276.5, y=80, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blueround_button_1", sc=1, dl=0, f={
                {x=62, y=80, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_descb", sc=1, dl=0, f={
                {x=331, y=205.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_small_loading", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=960, kx=0, ky=0, cx=320, cy=240, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blackHalfAlpha_bg", sc=1, dl=0, f={
                {x=0, y=960, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=635.5, y=604.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonBackgroundScalables/commonBackgroundScalables", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=298.35, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_2", sc=1, dl=0, f={
                {x=69, y=298.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_3", sc=1, dl=0, f={
                {x=143.35, y=322, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_4", sc=1, dl=0, f={
                {x=259.35, y=298.35, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6", sc=1, dl=0, f={
                {x=-218.6, y=176.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_7", sc=1, dl=0, f={
                {x=-83, y=184.00000000000003, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_bg", sc=1, dl=0, f={
                {x=384.5, y=284.40000000000003, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_over", sc=1, dl=0, f={
                {x=460.5, y=302.40000000000003, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_background", sc=1, dl=0, f={
                {x=552.35, y=289, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_item_num_bg", sc=1, dl=0, f={
                {x=207, y=366.35, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_fg", sc=1, dl=0, f={
                {x=243.35, y=160.40000000000003, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=86.5, y=186.90000000000003, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_background_3", sc=1, dl=0, f={
                {x=143.35, y=322, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_4", sc=1, dl=0, f={
                {x=259.35, y=298.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_6", sc=1, dl=0, f={
                {x=-218.6, y=176.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_7", sc=1, dl=0, f={
                {x=-83, y=184.00000000000003, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_bg", sc=1, dl=0, f={
                {x=384.5, y=284.40000000000003, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_over", sc=1, dl=0, f={
                {x=460.5, y=302.40000000000003, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_background", sc=1, dl=0, f={
                {x=552.35, y=289, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_fg", sc=1, dl=0, f={
                {x=243.35, y=160.40000000000003, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=86.5, y=186.90000000000003, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_page_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button", sc=1, dl=0, f={
                {x=0, y=31, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=31, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/commonButtons", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=362, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_return_button", sc=1, dl=0, f={
                {x=250.95, y=114, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_close_button", sc=1, dl=0, f={
                {x=196.6, y=362, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_ask_button", sc=1, dl=0, f={
                {x=290.85, y=356.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_page_button", sc=1, dl=0, f={
                {x=396.55, y=88, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_tab_button", sc=1, dl=0, f={
                {x=118, y=162, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_channel_button", sc=1, dl=0, f={
                {x=0, y=162, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_big_blue_button", sc=1, dl=0, f={
                {x=0, y=272, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=365.85, y=328.7, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=501.8, y=334.7, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_button", sc=1, dl=0, f={
                {x=403.85, y=249.7, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_red_button", sc=1, dl=0, f={
                {x=581.75, y=307.2, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_fightbutton", sc=1, dl=0, f={
                {x=473.85, y=159.55, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_blue_button", 
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
    {type="animation", name="commonButtons/common_return_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_ask_button", 
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
    {type="animation", name="commonButtons/common_page_button2", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_page_button2", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_tab_button", 
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
    {type="animation", name="commonButtons/common_channel_button", 
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
    {type="animation", name="commonButtons/common_big_blue_button", 
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
    {type="animation", name="commonButtons/common_small_blue_button", 
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
    {type="animation", name="commonButtons/common_small_orange_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_small_orange_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_red_button", 
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
    {type="animation", name="commonButtons/common_small_red_button", 
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
    {type="animation", name="commonButtons/common_fightbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="fightbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonCurrencyImages/commonCurrencyImages", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_silver_bg", sc=1, dl=0, f={
                {x=0, y=55.85, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_exp_bg", sc=1, dl=0, f={
                {x=335.5, y=54.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_youqing_bg", sc=1, dl=0, f={
                {x=240, y=55.85, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_add_bg", sc=1, dl=0, f={
                {x=287.5, y=55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_linglongling_bg", sc=1, dl=0, f={
                {x=180, y=55.85, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shengwang_bg", sc=1, dl=0, f={
                {x=392.5, y=52, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_gold_bg", sc=1, dl=0, f={
                {x=60, y=55.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_honor_bg", sc=1, dl=0, f={
                {x=450.35, y=47, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_tili_bg", sc=1, dl=0, f={
                {x=120, y=55.85, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonGrids/commonGrids", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_grid", sc=1, dl=0, f={
                {x=0, y=328.54999999999995, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_over", sc=1, dl=0, f={
                {x=117.7, y=328.54999999999995, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_1", sc=1, dl=0, f={
                {x=7.95, y=463.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_2", sc=1, dl=0, f={
                {x=133.9, y=459.9, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_3", sc=1, dl=0, f={
                {x=268.85, y=471.5499999999999, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_4", sc=1, dl=0, f={
                {x=441.8, y=449.9, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_5", sc=1, dl=0, f={
                {x=566.75, y=479.5499999999999, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_6", sc=1, dl=0, f={
                {x=732.7, y=469.5499999999999, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_7", sc=1, dl=0, f={
                {x=-12.05, y=178, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_8", sc=1, dl=0, f={
                {x=108.9, y=195.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_9", sc=1, dl=0, f={
                {x=284.85, y=221.65, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_10", sc=1, dl=0, f={
                {x=499.8, y=176, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_11", sc=1, dl=0, f={
                {x=677.7, y=190, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_grid_12", sc=1, dl=0, f={
                {x=753.65, y=463.9, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_2", sc=1, dl=0, f={
                {x=855.65, y=459.9, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_3", sc=1, dl=0, f={
                {x=957.65, y=459.9, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_4", sc=1, dl=0, f={
                {x=1059.65, y=455.9, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_5", sc=1, dl=0, f={
                {x=1161.5, y=455.9, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_6", sc=1, dl=0, f={
                {x=1263.5, y=459.9, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_grid_7", sc=1, dl=0, f={
                {x=591.45, y=260.95, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonImages/common_tfImgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=230, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=114, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=-2, y=15.650000000000006, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 5", sc=1, dl=0, f={
                {x=215, y=80.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6", sc=1, dl=0, f={
                {x=112, y=81.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 7", sc=1, dl=0, f={
                {x=-1, y=82.65, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 2", sc=1, dl=0, f={
                {x=230, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=114, y=22.65000000000001, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=-2, y=15.650000000000006, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 5", sc=1, dl=0, f={
                {x=215, y=80.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6", sc=1, dl=0, f={
                {x=112, y=81.65, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 7", sc=1, dl=0, f={
                {x=-1, y=82.65, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonImages/commonImages", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_image_increase", sc=1, dl=0, f={
                {x=0, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huobi_bg2", sc=1, dl=0, f={
                {x=1719.25, y=1670.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_checkNormal", sc=1, dl=0, f={
                {x=3, y=2945.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_checkSelect", sc=1, dl=0, f={
                {x=75, y=2945.9, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_headerBg", sc=1, dl=0, f={
                {x=188.95, y=2929.5499999999997, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_headerBg2", sc=1, dl=0, f={
                {x=354.3, y=2929.5499999999997, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_newFontImg", sc=1, dl=0, f={
                {x=-1, y=2856.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_star_kong_small", sc=1, dl=0, f={
                {x=95.5, y=3014.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_rightImg", sc=1, dl=0, f={
                {x=241.85, y=3058, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_joinWar", sc=1, dl=0, f={
                {x=112.85, y=3044, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_xuanzhong_img", sc=1, dl=0, f={
                {x=359.8, y=3075.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_not_open", sc=1, dl=0, f={
                {x=372.3, y=3137, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_zhanli_bg", sc=1, dl=0, f={
                {x=970.5, y=3057.7999999999997, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_decrease", sc=1, dl=0, f={
                {x=50, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator", sc=1, dl=0, f={
                {x=116.85, y=3095.85, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_yellow_line1", sc=1, dl=0, f={
                {x=178.5, y=3078.5, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_black_lock", sc=1, dl=0, f={
                {x=515.6, y=3103.35, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_puzzle", sc=1, dl=0, f={
                {x=577.5, y=3114.5, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_star_1", sc=1, dl=0, f={
                {x=0, y=3035.85, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_star_small", sc=1, dl=0, f={
                {x=73.35, y=3016.5, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_button_bg", sc=1, dl=0, f={
                {x=736.15, y=3075.85, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huaWen1", sc=1, dl=0, f={
                {x=-1, y=3293.5, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huaWen2", sc=1, dl=0, f={
                {x=28.85, y=3198, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_biaoti_new", sc=1, dl=0, f={
                {x=-319.6, y=3238.85, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_biaoti", sc=1, dl=0, f={
                {x=-257, y=3307.7999999999997, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_biaoti_bg", sc=1, dl=0, f={
                {x=-298.5, y=3170.85, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_zhanLi", sc=1, dl=0, f={
                {x=354.3, y=3285.5, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_lvImg", sc=1, dl=0, f={
                {x=95.5, y=2844.4, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_nameBg", sc=1, dl=0, f={
                {x=561.45, y=3307.0499999999997, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_starBg", sc=1, dl=0, f={
                {x=657.3, y=3230.5, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_friendNameBg", sc=1, dl=0, f={
                {x=433.15, y=3367.45, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huaWenImg", sc=1, dl=0, f={
                {x=-87.05, y=2418.5, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_input_bg", sc=1, dl=0, f={
                {x=-45.15, y=2088.3999999999996, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_begin_game", sc=1, dl=0, f={
                {x=395.8, y=2418.5, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_round_mask", sc=1, dl=0, f={
                {x=706.95, y=2509.1, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_1", sc=1, dl=0, f={
                {x=-76.5, y=2586.5, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_2", sc=1, dl=0, f={
                {x=75, y=2586.5, kx=0, ky=0, cx=1, cy=1, z=36, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_3", sc=1, dl=0, f={
                {x=33.85, y=2758, kx=0, ky=0, cx=1, cy=1, z=37, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_4", sc=1, dl=0, f={
                {x=137.85, y=2752.85, kx=0, ky=0, cx=1, cy=1, z=38, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_10", sc=1, dl=0, f={
                {x=-236.15, y=2582, kx=0, ky=0, cx=1, cy=1, z=39, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_hero_star_empty", sc=1, dl=0, f={
                {x=468.85, y=2986.85, kx=0, ky=0, cx=1, cy=1, z=40, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_hero_star", sc=1, dl=0, f={
                {x=561.45, y=3024.85, kx=0, ky=0, cx=1, cy=1, z=41, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_left", sc=1, dl=0, f={
                {x=2219.2, y=3474.6, kx=0, ky=0, cx=1, cy=1, z=42, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_right", sc=1, dl=0, f={
                {x=1730.9, y=3474.6, kx=0, ky=0, cx=1, cy=1, z=43, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_pattern", sc=1, dl=0, f={
                {x=914.55, y=2612.75, kx=0, ky=0, cx=1, cy=1, z=44, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_mozhi", sc=1, dl=0, f={
                {x=-288.95, y=2856.85, kx=0, ky=0, cx=1, cy=1, z=45, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_top", sc=1, dl=0, f={
                {x=1713.5, y=3558.6, kx=0, ky=0, cx=1, cy=1, z=46, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_frame_bottom", sc=1, dl=0, f={
                {x=1730.9, y=2642.85, kx=0, ky=0, cx=1, cy=1, z=47, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_greenArrow", sc=1, dl=0, f={
                {x=662.35, y=2922.85, kx=0, ky=0, cx=1, cy=1, z=48, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_line_down", sc=1, dl=0, f={
                {x=321.95, y=2741.4, kx=0, ky=0, cx=1, cy=1, z=49, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_line_vertical", sc=1, dl=0, f={
                {x=740.6, y=2818.85, kx=0, ky=0, cx=1, cy=1, z=50, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_line_horizon", sc=1, dl=0, f={
                {x=740.6, y=2818.85, kx=0, ky=0, cx=1, cy=1, z=51, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_redIcon", sc=1, dl=0, f={
                {x=-308, y=3307.7999999999997, kx=0, ky=0, cx=1, cy=1, z=52, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_xiaomodi", sc=1, dl=0, f={
                {x=-266, y=2719.85, kx=0, ky=0, cx=1, cy=1, z=53, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=409, y=3443.75, kx=0, ky=0, cx=1, cy=1, z=54, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=667.75, y=3443.75, kx=0, ky=0, cx=1, cy=1, z=55, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=805.3, y=3437.75, kx=0, ky=0, cx=1, cy=1, z=56, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6", sc=1, dl=0, f={
                {x=782.3, y=3400.75, kx=0, ky=0, cx=1, cy=1, z=57, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6_2", sc=1, dl=0, f={
                {x=903.3, y=3404.45, kx=0, ky=0, cx=1, cy=1, z=58, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 5", sc=1, dl=0, f={
                {x=957.15, y=3251.5, kx=0, ky=0, cx=1, cy=1, z=59, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 7", sc=1, dl=0, f={
                {x=966.15, y=3204.5, kx=0, ky=0, cx=1, cy=1, z=60, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_huobi_bg", sc=1, dl=0, f={
                {x=901.8, y=3444.75, kx=0, ky=0, cx=1, cy=1, z=61, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 10", sc=1, dl=0, f={
                {x=1043.55, y=3291.5, kx=0, ky=0, cx=1, cy=1, z=62, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 11", sc=1, dl=0, f={
                {x=1157.55, y=3291.5, kx=0, ky=0, cx=1, cy=1, z=63, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 16", sc=1, dl=0, f={
                {x=1494.9, y=1821.05, kx=0, ky=0, cx=1, cy=1, z=64, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 17", sc=1, dl=0, f={
                {x=1606.9, y=1809.05, kx=0, ky=0, cx=1, cy=1, z=65, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 18", sc=1, dl=0, f={
                {x=1730.9, y=1821.05, kx=0, ky=0, cx=1, cy=1, z=66, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 19", sc=1, dl=0, f={
                {x=1875, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=67, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 20", sc=1, dl=0, f={
                {x=1979, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=68, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 21", sc=1, dl=0, f={
                {x=2119.05, y=1829.05, kx=0, ky=0, cx=1, cy=1, z=69, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 22", sc=1, dl=0, f={
                {x=1512.4, y=1669.6999999999998, kx=0, ky=0, cx=1, cy=1, z=70, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 23", sc=1, dl=0, f={
                {x=1628.5, y=1669.6999999999998, kx=0, ky=0, cx=1, cy=1, z=71, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 24", sc=1, dl=0, f={
                {x=1297.95, y=3273.7999999999997, kx=0, ky=0, cx=1, cy=1, z=72, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 25", sc=1, dl=0, f={
                {x=1063.4, y=3173.85, kx=0, ky=0, cx=1, cy=1, z=73, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 26", sc=1, dl=0, f={
                {x=966.15, y=2897.9, kx=0, ky=0, cx=1, cy=1, z=74, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 27", sc=1, dl=0, f={
                {x=997.15, y=2469, kx=0, ky=0, cx=1, cy=1, z=75, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 29", sc=1, dl=0, f={
                {x=1113.9, y=2469, kx=0, ky=0, cx=1, cy=1, z=76, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 30", sc=1, dl=0, f={
                {x=1118.8, y=2358.45, kx=0, ky=0, cx=1, cy=1, z=77, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 31", sc=1, dl=0, f={
                {x=1385.45, y=2230.35, kx=0, ky=0, cx=1, cy=1, z=78, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 33", sc=1, dl=0, f={
                {x=1546.2, y=2165.3999999999996, kx=0, ky=0, cx=1, cy=1, z=79, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 34", sc=1, dl=0, f={
                {x=1530.15, y=1589.6999999999998, kx=0, ky=0, cx=1, cy=1, z=80, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 35", sc=1, dl=0, f={
                {x=2447.6, y=2741.4, kx=0, ky=0, cx=1, cy=1, z=81, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 37", sc=1, dl=0, f={
                {x=2850.25, y=2719.85, kx=0, ky=0, cx=1, cy=1, z=82, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 38", sc=1, dl=0, f={
                {x=2704.1, y=2000.4, kx=0, ky=0, cx=1, cy=1, z=83, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 39", sc=1, dl=0, f={
                {x=2483.6, y=3961.85, kx=0, ky=0, cx=1, cy=1, z=84, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 41", sc=1, dl=0, f={
                {x=2704.1, y=3934.6, kx=0, ky=0, cx=1, cy=1, z=85, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 42", sc=1, dl=0, f={
                {x=2662.2, y=3238.5, kx=0, ky=0, cx=1, cy=1, z=86, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 43", sc=1, dl=0, f={
                {x=2191.55, y=4476.2, kx=0, ky=0, cx=1, cy=1, z=87, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 45", sc=1, dl=0, f={
                {x=2402.15, y=4370.7, kx=0, ky=0, cx=1, cy=1, z=88, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 46", sc=1, dl=0, f={
                {x=2366.15, y=3735.2, kx=0, ky=0, cx=1, cy=1, z=89, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 47", sc=1, dl=0, f={
                {x=1009.3, y=3580.45, kx=0, ky=0, cx=1, cy=1, z=90, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 48", sc=1, dl=0, f={
                {x=1151.55, y=3585.7, kx=0, ky=0, cx=1, cy=1, z=91, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lvse_duihao", sc=1, dl=0, f={
                {x=805.3, y=3164.85, kx=0, ky=0, cx=1, cy=1, z=92, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonNumbers/commonNumbers", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_number9", sc=1, dl=0, f={
                {x=403.35, y=80.65000000000002, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number8", sc=1, dl=0, f={
                {x=314.35, y=73.65000000000002, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number7", sc=1, dl=0, f={
                {x=221.35, y=71.65000000000002, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number6", sc=1, dl=0, f={
                {x=124.35, y=69.65000000000002, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number5", sc=1, dl=0, f={
                {x=13.35, y=77.65000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number4", sc=1, dl=0, f={
                {x=407.35, y=193.6, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number3", sc=1, dl=0, f={
                {x=329.35, y=198.6, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number2", sc=1, dl=0, f={
                {x=242.35, y=200.6, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number1", sc=1, dl=0, f={
                {x=140.35, y=184.6, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_number0", sc=1, dl=0, f={
                {x=18, y=187.6, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonNumbers/commonVips", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_vip9", sc=1, dl=0, f={
                {x=403.35, y=170.29999999999995, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip8", sc=1, dl=0, f={
                {x=314.35, y=163.29999999999995, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip7", sc=1, dl=0, f={
                {x=221.35, y=161.29999999999995, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip6", sc=1, dl=0, f={
                {x=124.35, y=159.29999999999995, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip5", sc=1, dl=0, f={
                {x=13.35, y=167.29999999999995, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip4", sc=1, dl=0, f={
                {x=407.35, y=283.24999999999994, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip3", sc=1, dl=0, f={
                {x=329.35, y=288.24999999999994, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip2", sc=1, dl=0, f={
                {x=242.35, y=290.24999999999994, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip1", sc=1, dl=0, f={
                {x=140.35, y=274.24999999999994, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_vip0", sc=1, dl=0, f={
                {x=18, y=277.24999999999994, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip9", sc=1, dl=0, f={
                {x=298.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip8", sc=1, dl=0, f={
                {x=270.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip7", sc=1, dl=0, f={
                {x=244.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip6", sc=1, dl=0, f={
                {x=222.35, y=108.74999999999996, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip5", sc=1, dl=0, f={
                {x=176.35, y=108.74999999999996, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip4", sc=1, dl=0, f={
                {x=141.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip3", sc=1, dl=0, f={
                {x=110.35, y=110.74999999999996, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip2", sc=1, dl=0, f={
                {x=78.35, y=110.74999999999996, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip1", sc=1, dl=0, f={
                {x=45.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip0", sc=1, dl=0, f={
                {x=15.35, y=109.74999999999996, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip", sc=1, dl=0, f={
                {x=330.7, y=110.79999999999995, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_mainui_vip_normal", sc=1, dl=0, f={
                {x=13.35, y=64.64999999999998, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBar/common_blue_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_progress_bar_bg", sc=1, dl=0, f={
                {x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_progress_bar_fg", sc=1, dl=0, f={
                {x=0, y=33, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBar/common_red_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_red_progress_bar_bg", sc=1, dl=0, f={
                {x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_red_progress_bar_fg", sc=1, dl=0, f={
                {x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBars/commonPgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_pg_star", sc=1, dl=0, f={
                {x=218.3, y=21.65000000000001, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_exp_progress_bar", sc=1, dl=0, f={
                {x=-184.65, y=88.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBars/common_exp_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="pro_down", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pro_up", sc=1, dl=0, f={
                {x=63, y=-42, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonSingleImgButtons/commonSingleImgButtons", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_leftArrow_button", sc=1, dl=0, f={
                {x=55.7, y=295.15, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_rightArrow_button", sc=1, dl=0, f={
                {x=59.7, y=174.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_leftArrow_button", sc=1, dl=0, f={
                {x=55.7, y=295.15, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_rightArrow_button", sc=1, dl=0, f={
                {x=59.7, y=174.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="huobiGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=118, kx=0, ky=0, cx=258.75, cy=29.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili_bantou", sc=1, dl=0, f={
                {x=828, y=106, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tiliText", sc=1, dl=0, f={
                {x=902.95, y=54, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili", sc=1, dl=0, f={
                {x=798, y=117, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao_bantou", sc=1, dl=0, f={
                {x=603, y=106, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbaoText", sc=1, dl=0, f={
                {x=673.95, y=56, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao", sc=1, dl=0, f={
                {x=563, y=117, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingliang_bantou", sc=1, dl=0, f={
                {x=346, y=106, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliangText", sc=1, dl=0, f={
                {x=383, y=65.4, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang", sc=1, dl=0, f={
                {x=309, y=118, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_tili", sc=1, dl=0, f={
                {x=981, y=111, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_yuanbao", sc=1, dl=0, f={
                {x=750, y=111, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_yingliang", sc=1, dl=0, f={
                {x=503, y=111, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="loading_show_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_3", sc=1, dl=0, f={
                {x=1195, y=187, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_2", sc=1, dl=0, f={
                {x=1050, y=435, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img_1", sc=1, dl=0, f={
                {x=1080, y=395, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress", sc=1, dl=0, f={
                {x=45, y=70, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress_descb", sc=1, dl=0, f={
                {x=520.95, y=84.10000000000002, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="loadingImages/imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 3", sc=1, dl=0, f={
                {x=60.5, y=472, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=129.5, y=472, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 5", sc=1, dl=0, f={
                {x=186, y=472, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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