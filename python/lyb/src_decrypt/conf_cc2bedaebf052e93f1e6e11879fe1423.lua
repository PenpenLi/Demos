local conf = {type="skeleton", name="activity_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="activity_gift_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_inner_1", x=26, y=621, kx=0, ky=0, cx=18.97, cy=15.13, z=1, d={{name="common_copy_background_inner_1", isArmature=0}} },
           {type="b", name="common_copy_button_bg", x=34, y=629, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="placeHolder_1", x=56, y=543.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="baoxiangPanel", isArmature=1}} },
           {type="b", name="placeHolder_2", x=301, y=558.5, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="leftButton", x=2.8, y=362, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_left_button", isArmature=1}} },
           {type="b", name="rightButton", x=744.8, y=362, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="common_copy_right_button", isArmature=1}} },
           {type="b", name="allGainButton", x=317.5, y=115.20000000000005, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_copy_greenlongroundbutton", isArmature=1}} }
         }
      },
    {type="armature", name="activity_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=709, kx=0, ky=0, cx=268.25, cy=177, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background", x=0, y=652, kx=0, ky=0, cx=20.29, cy=12.75, z=1, d={{name="common_copy_background", isArmature=0}} },
           {type="b", name="common_copy_background_inner_1", x=26, y=622, kx=0, ky=0, cx=18.97, cy=15.13, z=2, d={{name="common_copy_background_inner_1", isArmature=0}} },
           {type="b", name="common_copy_background_inner_2", x=782, y=622, kx=0, ky=0, cx=5.74, cy=15.13, z=3, d={{name="common_copy_background_inner_1", isArmature=0}} },
           {type="b", name="common_copy_title_3", x=201.5, y=710, kx=0, ky=0, cx=1.44, cy=1, z=4, d={{name="common_copy_title_3", isArmature=0}} },
           {type="b", name="common_copy_title_attachment_1", x=349.5, y=708, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_title_attachment_1", isArmature=0}} },
           {type="b", name="title", x=450, y=675.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="title", isArmature=0}} },
           {type="b", name="common_copy_button_bg_1", x=794, y=605, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=985, y=687, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="activity_ui_bg", 
      bones={           
           {type="b", name="common_copy_border_inner01", x=0, y=480, kx=0, ky=0, cx=17.78, cy=10.67, z=0, d={{name="common_copy_border_inner01", isArmature=0}} },
           {type="b", name="common_copy_border_inner02", x=616, y=412, kx=0, ky=0, cx=2.68, cy=7.02, z=1, d={{name="common_copy_border_inner02", isArmature=0}} },
           {type="b", name="common_copy_border_inner03", x=15, y=412, kx=0, ky=0, cx=2.32, cy=1.5, z=2, d={{name="common_copy_border_inner03", isArmature=0}} }
         }
      },
    {type="armature", name="baoxiangPanel", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=48.25, cy=96.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_inner_3", x=0, y=0, kx=0, ky=0, cx=4.95, cy=10.16, z=1, d={{name="common_copy_background_inner_3", isArmature=0}} },
           {type="b", name="common_copy_line", x=6.5, y=-288.95, kx=0, ky=0, cx=36, cy=1, z=2, d={{name="common_copy_horizon_line", isArmature=0}} },
           {type="b", name="common_copy_line_1", x=6.5, y=-180, kx=0, ky=0, cx=36.27, cy=1, z=3, d={{name="common_copy_horizon_line", isArmature=0}} },
           {type="b", name="background", x=24, y=15, kx=0, ky=0, cx=1, cy=1, z=4, text={x=23,y=-266, w=148, h=65,lineType="multiline",size=22,color="00ff00",alignment="center",space=0,textType="dynamic"}, d={{name="baoxiangditu", isArmature=0}} },
           {type="b", name="button", x=30.5, y=-306.95, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="gridHolder", x=58, y=-45.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=38,y=-167, w=118, h=36,lineType="single line",size=24,color="00ff00",alignment="center",space=0,textType="dynamic"}, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="timeState3", x=46.5, y=-307.95, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="timeState3", isArmature=0}} },
           {type="b", name="timeState4", x=46.5, y=-307.95, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="timeState4", isArmature=0}} }
         }
      },
    {type="armature", name="cd_key_bonus_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_bottom_dark", x=50, y=595, kx=0, ky=0, cx=22.32, cy=17.35, z=1, d={{name="common_copy_background_bottom_dark", isArmature=0}} },
           {type="b", name="common_copy_bluelonground_button", x=317, y=135.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_bluelonground_button", isArmature=1}} },
           {type="b", name="descb_1", x=77.45, y=492.55, kx=0, ky=0, cx=1, cy=1, z=3, text={x=53,y=512, w=685, h=36,lineType="single line",size=24,color="d8c58d",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2", x=77.45, y=447.55, kx=0, ky=0, cx=1, cy=1, z=4, text={x=69,y=321, w=654, h=137,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3", x=144.45, y=265.5, kx=0, ky=0, cx=1, cy=1, z=5, text={x=121,y=241, w=550, h=36,lineType="single line",size=24,color="ffc000",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="text_bg", x=72.5, y=227.05, kx=0, ky=0, cx=20.87, cy=2.42, z=6, text={x=96,y=174, w=600, h=31,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_background_input", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_bluelonground_button", 
      bones={           
           {type="b", name="common_copy_bluelonground_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=-49, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_bluelonground_button_normal", isArmature=0},{name="common_copy_bluelonground_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_bluebutton", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_close_button_normal", isArmature=0},{name="common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_greenlongroundbutton", 
      bones={           
           {type="b", name="common_greenlongroundbutton", x=-0.5, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=-49, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_greenlongroundbutton_normal", isArmature=0},{name="common_copy_greenlongroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_greenroundbutton", 
      bones={           
           {type="b", name="common_copy_greenroundbutton", x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, text={x=5,y=8, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_greenroundbutton_normal", isArmature=0},{name="common_copy_greenroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_item", 
      bones={           
           {type="b", name="common_copy_item_over", x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_item_over", isArmature=0}} },
           {type="b", name="common_copy_item_bg", x=3, y=57, kx=0, ky=0, cx=1, cy=1, z=1, text={x=13,y=15, w=131, h=28,lineType="single line",size=18,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_item_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_left_button", 
      bones={           
           {type="b", name="common_left_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_left_button_normal", isArmature=0},{name="common_copy_left_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_newgreenlongroundbutton", 
      bones={           
           {type="b", name="common_newgreenlongroundbutton", x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, text={x=-1,y=8, w=150, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_newgreenlongroundbutton_normal", isArmature=0},{name="common_copy_newgreenlongroundbutton_down", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_right_button", 
      bones={           
           {type="b", name="common_right_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_copy_right_button_normal", isArmature=0},{name="common_copy_right_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="download_gift_scroll_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=120.35, kx=0, ky=0, cx=176.25, cy=30, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="level_gift_scroll_item_bg", x=0, y=120, kx=0, ky=0, cx=22.74, cy=3.87, z=1, d={{name="common_copy_background_bottom_dark", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_1", x=0, y=20, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_jinsibian_1", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_2", x=633, y=20, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_jinsibian_2", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_3", x=0, y=120.35, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_jinsibian_3", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_4", x=633, y=120, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_jinsibian_4", isArmature=0}} },
           {type="b", name="common_copy_box_3_normal", x=47, y=120.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=9,y=14, w=140, h=31,lineType="single line",size=20,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_box_3_normal", isArmature=0}} },
           {type="b", name="common_copy_grid", x=157, y=98.35, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="common_copy_grid_1", x=252, y=98.35, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="unfetched_img", x=369.95, y=100.35, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="unfetched_img", isArmature=0}} },
           {type="b", name="img", x=543, y=90.35, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="common_copy_blueround_button", isArmature=1}} }
         }
      },
    {type="armature", name="download_gift_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_button_bg", x=39, y=577, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb", x=75.5, y=610.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=107,y=555, w=566, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="family_boss_battle_end_popup", 
      bones={           
           {type="b", name="hit_area", x=0, y=265, kx=0, ky=0, cx=114.75, cy=66.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_inner_3", x=0, y=265, kx=0, ky=0, cx=11.77, cy=6.97, z=1, d={{name="common_copy_background_inner_3", isArmature=0}} },
           {type="b", name="common_copy_blueround_button", x=80, y=103, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="common_copy_blueround_button_1", x=254, y=103, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="boss_hurt_text", x=131.1, y=188.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=3,y=177, w=452, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="boss_get2_text", x=131.1, y=127.95, kx=0, ky=0, cx=1, cy=1, z=5, text={x=5,y=112, w=451, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="boss_get1_text", x=131.1, y=158.95, kx=0, ky=0, cx=1, cy=1, z=6, text={x=4,y=145, w=451, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="boss_fail_victor_text", x=131.1, y=216.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=5,y=212, w=450, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="imgs", 
      bones={           
           {type="b", name="finished_img", x=0, y=113.95, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="finished_img", isArmature=0}} },
           {type="b", name="unfinished_img", x=0, y=58, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="unfinished_img", isArmature=0}} },
           {type="b", name="unfetched_img", x=106, y=113.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="unfetched_img", isArmature=0}} }
         }
      },
    {type="armature", name="level_gift_scroll_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=120.35, kx=0, ky=0, cx=176.25, cy=30, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="level_gift_scroll_item_bg", x=0, y=120, kx=0, ky=0, cx=22.74, cy=3.87, z=1, d={{name="common_copy_background_bottom_dark", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_1", x=0, y=20, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_jinsibian_1", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_2", x=633, y=20, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_jinsibian_2", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_3", x=0, y=120.35, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_copy_jinsibian_3", isArmature=0}} },
           {type="b", name="common_copy_jinsibian_4", x=633, y=120, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_copy_jinsibian_4", isArmature=0}} },
           {type="b", name="common_copy_box_3_normal", x=47, y=120.35, kx=0, ky=0, cx=1, cy=1, z=6, text={x=9,y=14, w=140, h=31,lineType="single line",size=20,color="e1d2a0",alignment="center",space=0,textType="static"}, d={{name="common_copy_box_3_normal", isArmature=0}} },
           {type="b", name="common_copy_grid", x=157, y=98.35, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="common_copy_grid_1", x=252, y=98.35, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="common_copy_grid", isArmature=0}} },
           {type="b", name="img", x=543, y=90.35, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="common_copy_blueround_button", isArmature=1}} }
         }
      },
    {type="armature", name="level_gift_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_button_bg", x=43, y=607, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="univeral_boss_battle_end_popup", 
      bones={           
           {type="b", name="hit_area", x=0, y=265, kx=0, ky=0, cx=114.75, cy=66.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_inner_3", x=0, y=265, kx=0, ky=0, cx=11.77, cy=6.97, z=1, d={{name="common_copy_background_inner_3", isArmature=0}} },
           {type="b", name="common_copy_blueround_button", x=80, y=103, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="common_copy_blueround_button_1", x=254, y=103, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_copy_blueround_button", isArmature=1}} },
           {type="b", name="common_copy_button_bg", x=47.5, y=232.5, kx=0, ky=0, cx=1, cy=1, z=4, text={x=15,y=206, w=430, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_button_bg_1", x=50, y=186.9, kx=0, ky=0, cx=1, cy=1, z=5, text={x=15,y=176, w=430, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="bonus_1_img", x=20.6, y=159.9, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="bonus_1_img", isArmature=0}} },
           {type="b", name="common_copy_exp_img", x=89.05, y=171.95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=146,y=123, w=120, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_exp_bg", isArmature=0}} },
           {type="b", name="common_copy_silver_bg", x=256, y=171, kx=0, ky=0, cx=1, cy=1, z=8, text={x=314,y=123, w=110, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_silver_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_copy_blueround_button", 
      bones={           
           {type="b", name="common_copy_blueround_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=16,y=-50, w=100, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_blueround_button_normal", isArmature=0},{name="common_copy_blueround_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="universal_boss_rank_item", 
      bones={           
           {type="b", name="hit_area", x=0, y=30, kx=0, ky=0, cx=83.75, cy=7.5, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="universal_boss_rank_item_bg", x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="universal_boss_rank_item_bg", isArmature=0}} },
           {type="b", name="rank_descb", x=16, y=30, kx=0, ky=0, cx=1, cy=1, z=2, text={x=4,y=-3, w=64, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb", x=103, y=30, kx=0, ky=0, cx=1, cy=1, z=3, text={x=70,y=-2, w=123, h=34,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="damage_descb", x=226, y=30, kx=0, ky=0, cx=1, cy=1, z=4, text={x=210,y=-2, w=115, h=34,lineType="single line",size=22,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="universal_boss_rank_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=439, kx=0, ky=0, cx=87.25, cy=109.75, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_inner_1", x=0, y=439, kx=0, ky=0, cx=8.95, cy=11.26, z=1, d={{name="common_copy_background_inner_1", isArmature=0}} },
           {type="b", name="common_copy_horizon_line_2", x=8, y=385, kx=0, ky=0, cx=18.56, cy=1, z=2, d={{name="common_copy_horizon_line_2", isArmature=0}} },
           {type="b", name="rank_img_1", x=27, y=423, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="rank_img_1", isArmature=0}} },
           {type="b", name="rank_img_2", x=99, y=423, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="rank_img_2", isArmature=0}} },
           {type="b", name="rank_img_3", x=243, y=423, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="rank_img_3", isArmature=0}} },
           {type="b", name="common_copy_button_bg", x=7, y=369, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="activity_gift_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_inner_1", sc=1, dl=0, f={
                {x=26, y=621, kx=0, ky=0, cx=18.97, cy=15.13, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg", sc=1, dl=0, f={
                {x=34, y=629, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="placeHolder_1", sc=1, dl=0, f={
                {x=56, y=543.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="placeHolder_2", sc=1, dl=0, f={
                {x=301, y=558.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftButton", sc=1, dl=0, f={
                {x=2.8, y=362, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rightButton", sc=1, dl=0, f={
                {x=744.8, y=362, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="allGainButton", sc=1, dl=0, f={
                {x=317.5, y=115.20000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="activity_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=709, kx=0, ky=0, cx=268.25, cy=177, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background", sc=1, dl=0, f={
                {x=0, y=652, kx=0, ky=0, cx=20.29, cy=12.75, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_inner_1", sc=1, dl=0, f={
                {x=26, y=622, kx=0, ky=0, cx=18.97, cy=15.13, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_inner_2", sc=1, dl=0, f={
                {x=782, y=622, kx=0, ky=0, cx=5.74, cy=15.13, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_title_3", sc=1, dl=0, f={
                {x=201.5, y=710, kx=0, ky=0, cx=1.44, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_title_attachment_1", sc=1, dl=0, f={
                {x=349.5, y=708, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=450, y=675.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg_1", sc=1, dl=0, f={
                {x=794, y=605, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=985, y=687, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="activity_ui_bg", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_border_inner01", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=17.78, cy=10.67, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_border_inner02", sc=1, dl=0, f={
                {x=616, y=412, kx=0, ky=0, cx=2.68, cy=7.02, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_border_inner03", sc=1, dl=0, f={
                {x=15, y=412, kx=0, ky=0, cx=2.32, cy=1.5, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="baoxiangPanel", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=48.25, cy=96.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_inner_3", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=4.95, cy=10.16, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line", sc=1, dl=0, f={
                {x=6.5, y=-288.95, kx=0, ky=0, cx=36, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_1", sc=1, dl=0, f={
                {x=6.5, y=-180, kx=0, ky=0, cx=36.27, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background", sc=1, dl=0, f={
                {x=24, y=15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="button", sc=1, dl=0, f={
                {x=30.5, y=-306.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gridHolder", sc=1, dl=0, f={
                {x=58, y=-45.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="timeState3", sc=1, dl=0, f={
                {x=46.5, y=-307.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="timeState4", sc=1, dl=0, f={
                {x=46.5, y=-307.95, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="cd_key_bonus_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_bottom_dark", sc=1, dl=0, f={
                {x=50, y=595, kx=0, ky=0, cx=22.32, cy=17.35, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_bluelonground_button", sc=1, dl=0, f={
                {x=317, y=135.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=77.45, y=492.55, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=77.45, y=447.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3", sc=1, dl=0, f={
                {x=144.45, y=265.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text_bg", sc=1, dl=0, f={
                {x=72.5, y=227.05, kx=0, ky=0, cx=20.87, cy=2.42, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="common_copy_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_bluelonground_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="common_copy_greenlongroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenlongroundbutton", sc=1, dl=0, f={
                {x=-0.5, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenlongroundbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_greenlongroundbutton", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_greenroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_greenroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_item_over", sc=1, dl=0, f={
                {x=0, y=60, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg", sc=1, dl=0, f={
                {x=3, y=57, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_left_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_left_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_newgreenlongroundbutton", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_newgreenlongroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_newgreenlongroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_newgreenlongroundbutton", sc=1, dl=0, f={
                {x=0, y=54, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="common_copy_right_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_right_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="download_gift_scroll_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120.35, kx=0, ky=0, cx=176.25, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_gift_scroll_item_bg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=22.74, cy=3.87, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_1", sc=1, dl=0, f={
                {x=0, y=20, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_2", sc=1, dl=0, f={
                {x=633, y=20, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_3", sc=1, dl=0, f={
                {x=0, y=120.35, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_4", sc=1, dl=0, f={
                {x=633, y=120, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_box_3_normal", sc=1, dl=0, f={
                {x=47, y=120.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid", sc=1, dl=0, f={
                {x=157, y=98.35, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid_1", sc=1, dl=0, f={
                {x=252, y=98.35, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="unfetched_img", sc=1, dl=0, f={
                {x=369.95, y=100.35, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img", sc=1, dl=0, f={
                {x=543, y=90.35, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="download_gift_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg", sc=1, dl=0, f={
                {x=39, y=577, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=75.5, y=610.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="family_boss_battle_end_popup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=265, kx=0, ky=0, cx=114.75, cy=66.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_inner_3", sc=1, dl=0, f={
                {x=0, y=265, kx=0, ky=0, cx=11.77, cy=6.97, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=80, y=103, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button_1", sc=1, dl=0, f={
                {x=254, y=103, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="boss_hurt_text", sc=1, dl=0, f={
                {x=131.1, y=188.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="boss_get2_text", sc=1, dl=0, f={
                {x=131.1, y=127.95, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="boss_get1_text", sc=1, dl=0, f={
                {x=131.1, y=158.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="boss_fail_victor_text", sc=1, dl=0, f={
                {x=131.1, y=216.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="imgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="finished_img", sc=1, dl=0, f={
                {x=0, y=113.95, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="unfinished_img", sc=1, dl=0, f={
                {x=0, y=58, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="unfetched_img", sc=1, dl=0, f={
                {x=106, y=113.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="level_gift_scroll_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120.35, kx=0, ky=0, cx=176.25, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_gift_scroll_item_bg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=22.74, cy=3.87, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_1", sc=1, dl=0, f={
                {x=0, y=20, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_2", sc=1, dl=0, f={
                {x=633, y=20, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_3", sc=1, dl=0, f={
                {x=0, y=120.35, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_jinsibian_4", sc=1, dl=0, f={
                {x=633, y=120, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_box_3_normal", sc=1, dl=0, f={
                {x=47, y=120.35, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid", sc=1, dl=0, f={
                {x=157, y=98.35, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid_1", sc=1, dl=0, f={
                {x=252, y=98.35, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img", sc=1, dl=0, f={
                {x=543, y=90.35, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="level_gift_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=708, kx=0, ky=0, cx=268.25, cy=177, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg", sc=1, dl=0, f={
                {x=43, y=607, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="univeral_boss_battle_end_popup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=265, kx=0, ky=0, cx=114.75, cy=66.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_inner_3", sc=1, dl=0, f={
                {x=0, y=265, kx=0, ky=0, cx=11.77, cy=6.97, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=80, y=103, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blueround_button_1", sc=1, dl=0, f={
                {x=254, y=103, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg", sc=1, dl=0, f={
                {x=47.5, y=232.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg_1", sc=1, dl=0, f={
                {x=50, y=186.9, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bonus_1_img", sc=1, dl=0, f={
                {x=20.6, y=159.9, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_exp_img", sc=1, dl=0, f={
                {x=89.05, y=171.95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg", sc=1, dl=0, f={
                {x=256, y=171, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_copy_blueround_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_blueround_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="universal_boss_rank_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=30, kx=0, ky=0, cx=83.75, cy=7.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="universal_boss_rank_item_bg", sc=1, dl=0, f={
                {x=0, y=30, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_descb", sc=1, dl=0, f={
                {x=16, y=30, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=103, y=30, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="damage_descb", sc=1, dl=0, f={
                {x=226, y=30, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="universal_boss_rank_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=439, kx=0, ky=0, cx=87.25, cy=109.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_inner_1", sc=1, dl=0, f={
                {x=0, y=439, kx=0, ky=0, cx=8.95, cy=11.26, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_horizon_line_2", sc=1, dl=0, f={
                {x=8, y=385, kx=0, ky=0, cx=18.56, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_img_1", sc=1, dl=0, f={
                {x=27, y=423, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_img_2", sc=1, dl=0, f={
                {x=99, y=423, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rank_img_3", sc=1, dl=0, f={
                {x=243, y=423, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg", sc=1, dl=0, f={
                {x=7, y=369, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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