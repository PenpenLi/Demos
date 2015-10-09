local conf = {type="skeleton", name="storyLine_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="allStar_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=344, kx=0, ky=0, cx=133, cy=86, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bag_background_img", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=33.5, y=294, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="passCount_back", x=70.35, y=274.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_friendNameBg", isArmature=0}} },
           {type="b", name="passCount_desc_txt", x=141.2, y=239, kx=0, ky=0, cx=1, cy=1, z=4, text={x=141,y=238, w=250, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item_list", x=74.2, y=113.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="confirm_button", x=200, y=69, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="title_bg", x=96.75, y=344, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="strongPointName_txt", x=170.05, y=310.05, kx=0, ky=0, cx=1, cy=1, z=8, text={x=155,y=297, w=219, h=44,lineType="single line",size=30,color="feefd3",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="mopUp_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=366, kx=0, ky=0, cx=136.5, cy=91.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bag_background_img", x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_4", isArmature=0}} },
           {type="b", name="common_copy_item_bg_3", x=30.85, y=304, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonPanels/common_copy_item_bg_3", isArmature=0}} },
           {type="b", name="passCount_desc_txt", x=116.2, y=231, kx=0, ky=0, cx=1, cy=1, z=3, text={x=123,y=224, w=266, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="saoDangQuan_txt", x=116.2, y=113, kx=0, ky=0, cx=1, cy=1, z=4, text={x=123,y=108, w=266, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="mopUp10_button", x=296, y=75, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="mopUp1_button", x=96, y=75, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="cost_value_txt", x=397.95, y=171.85, kx=0, ky=0, cx=1, cy=1, z=7, text={x=332,y=168, w=142, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="cost_desc_txt", x=190.95, y=160.7, kx=0, ky=0, cx=1, cy=1, z=8, text={x=123,y=168, w=144, h=44,lineType="single line",size=30,color="67190e",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_tili_bg", x=264.85, y=220.65, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="title_bg", x=88.75, y=354.7, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="strongPointName_txt", x=163.05, y=321.05, kx=0, ky=0, cx=1, cy=1, z=11, text={x=148,y=308, w=219, h=44,lineType="single line",size=30,color="feefd3",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=468, y=366, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} }
         }
      },
    {type="armature", name="mopUpResult_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=645.05, kx=0, ky=0, cx=120, cy=161.26, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bag_background_img", x=0, y=645.05, kx=0, ky=0, cx=6.08, cy=8.16, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="fetch_button", x=155.95, y=105.64999999999998, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_yellow_line1", x=7, y=570.05, kx=0, ky=0, cx=1.91, cy=1, z=3, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="title_txt", x=155.95, y=575.0999999999999, kx=0, ky=0, cx=1, cy=1, z=4, text={x=147,y=583, w=190, h=38,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=9,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="resource_ui", 
      bones={           
           {type="b", name="yeqian_bg", x=581, y=-239.45, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="storyLine/yeqian_bg", isArmature=0}} },
           {type="b", name="upgradeBtn", x=495.3, y=-134.85000000000002, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="upgradeBtn", isArmature=0}} },
           {type="b", name="lock", x=502.3, y=-243.35, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="lock", isArmature=0}} }
         }
      },
    {type="armature", name="result_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=226, kx=0, ky=0, cx=117, cy=56.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="line", x=2.35, y=4.5, kx=0, ky=0, cx=1.91, cy=1, z=1, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="times_txt", x=31, y=187, kx=0, ky=0, cx=1, cy=1, z=2, text={x=10,y=177, w=128, h=38,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="obtain_txt", x=31, y=147, kx=0, ky=0, cx=1, cy=1, z=3, text={x=10,y=134, w=103, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="exp_txt", x=151, y=147, kx=0, ky=0, cx=1, cy=1, z=4, text={x=103,y=134, w=180, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silver_txt", x=328, y=147, kx=0, ky=0, cx=1, cy=1, z=5, text={x=280,y=134, w=178, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="storyLine_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1171.1, y=705.9, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="allStar_text", x=102, y=570, kx=0, ky=0, cx=1, cy=1, z=2, text={x=101,y=569, w=80, h=36,lineType="single line",size=24,color="fffccb",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="allstarImage", x=-128.45, y=613.7, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="allstarImage", isArmature=0}} },
           {type="b", name="havetakenImage", x=-162.1, y=720, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="havetakenImage", isArmature=0}} }
         }
      },
    {type="armature", name="strongPoint_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="starbg", x=34.5, y=78.20000000000005, kx=0, ky=0, cx=3.01, cy=1, z=1, d={{name="starsback", isArmature=0}} },
           {type="b", name="darkstar1", x=160.85, y=111.70000000000005, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="hero_frame/common_copy_big_card_star_empty", isArmature=0}} },
           {type="b", name="darkstar2", x=254.85, y=111.70000000000005, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="hero_frame/common_copy_big_card_star_empty", isArmature=0}} },
           {type="b", name="darkstar3", x=340.85, y=114.20000000000005, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="hero_frame/common_copy_big_card_star_empty", isArmature=0}} },
           {type="b", name="brightstar1", x=160.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="hero_frame/common_copy_big_card_star", isArmature=0}} },
           {type="b", name="brightstar2", x=254.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="hero_frame/common_copy_big_card_star", isArmature=0}} },
           {type="b", name="brightstar3", x=340.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="hero_frame/common_copy_big_card_star", isArmature=0}} },
           {type="b", name="redbg", x=116.95, y=691, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="background_1", x=596.1, y=677, kx=0, ky=0, cx=7.34, cy=8.04, z=9, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="background_4", x=611.05, y=294.95, kx=0, ky=0, cx=6.94, cy=1.46, z=10, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="background_3", x=611.05, y=504.95, kx=0, ky=0, cx=6.94, cy=2.58, z=11, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="background_2", x=611.05, y=626.95, kx=0, ky=0, cx=6.94, cy=1.46, z=12, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="tili_consume_txt", x=1040.1, y=94.14999999999998, kx=0, ky=0, cx=1, cy=1, z=13, text={x=932,y=88, w=181, h=36,lineType="single line",size=24,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="strongPointName_txt", x=190.4, y=673.4, kx=0, ky=0, cx=1, cy=1, z=14, text={x=147,y=644, w=282, h=49,lineType="single line",size=34,color="fffcd1",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="strongPoint_desc", x=817.8, y=654.25, kx=0, ky=0, cx=1, cy=1, z=15, text={x=826,y=633, w=185, h=41,lineType="single line",size=28,color="fff8bc",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="dropOut", x=630.85, y=462.55, kx=0, ky=0, cx=1, cy=1, z=16, text={x=621,y=441, w=92, h=44,lineType="single line",size=30,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shuoMing", x=630.85, y=590.85, kx=0, ky=0, cx=1, cy=1, z=17, text={x=621,y=569, w=92, h=41,lineType="single line",size=28,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="storyLineDesc", x=719.35, y=588.6, kx=0, ky=0, cx=1, cy=1, z=18, text={x=703,y=529, w=430, h=79,lineType="multiline",size=26,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="boss_bg", x=167.25, y=251.95, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="storyLine/boss_bg", isArmature=0}} },
           {type="b", name="jingying_bg", x=167.95, y=252.55, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="storyLine/jingying_bg", isArmature=0}} },
           {type="b", name="common_copy_silver_bg0", x=714.8, y=486.95, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="item2", x=833, y=427, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item1", x=701, y=427, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="silver_txt", x=803.9, y=453.35, kx=0, ky=0, cx=1, cy=1, z=24, text={x=783,y=437, w=135, h=39,lineType="single line",size=26,color="fffad4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="exp_txt", x=991.5, y=453.45, kx=0, ky=0, cx=1, cy=1, z=25, text={x=978,y=437, w=143, h=39,lineType="single line",size=26,color="fffad4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1177.1, y=713, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="mopUp_button", x=611.85, y=117.75, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="mopUp10_button", x=775.85, y=117.75, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="enter_button", x=1063.75, y=176.64999999999998, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="commonButtons/common_copy_fightbutton_normal", isArmature=0}} },
           {type="b", name="mopup10Condition_txt", x=886.1, y=135.14999999999998, kx=0, ky=0, cx=1, cy=1, z=30, text={x=778,y=113, w=129, h=31,lineType="single line",size=20,color="fffad4",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="mopupCondition_txt", x=693.1, y=102.14999999999998, kx=0, ky=0, cx=1, cy=1, z=31, text={x=639,y=88, w=272, h=36,lineType="single line",size=24,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="saoDangQuan_txt", x=693.1, y=159.14999999999998, kx=0, ky=0, cx=1, cy=1, z=32, text={x=619,y=127, w=272, h=36,lineType="single line",size=24,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="shuoMing1", x=630.85, y=255.9, kx=0, ky=0, cx=1, cy=1, z=33, text={x=621,y=234, w=92, h=41,lineType="single line",size=28,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="storyLineDesc1", x=719.35, y=253.65, kx=0, ky=0, cx=1, cy=1, z=34, text={x=703,y=194, w=430, h=79,lineType="multiline",size=26,color="fffad4",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=13,y=-45, w=101, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="allStar_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=344, kx=0, ky=0, cx=133, cy=86, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img", sc=1, dl=0, f={
                {x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_3", sc=1, dl=0, f={
                {x=33.5, y=294, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="passCount_back", sc=1, dl=0, f={
                {x=70.35, y=274.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="passCount_desc_txt", sc=1, dl=0, f={
                {x=141.2, y=239, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_list", sc=1, dl=0, f={
                {x=74.2, y=113.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="confirm_button", sc=1, dl=0, f={
                {x=200, y=69, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=96.75, y=344, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strongPointName_txt", sc=1, dl=0, f={
                {x=170.05, y=310.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mopUp_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=366, kx=0, ky=0, cx=136.5, cy=91.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img", sc=1, dl=0, f={
                {x=0, y=344, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_3", sc=1, dl=0, f={
                {x=30.85, y=304, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="passCount_desc_txt", sc=1, dl=0, f={
                {x=116.2, y=231, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saoDangQuan_txt", sc=1, dl=0, f={
                {x=116.2, y=113, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopUp10_button", sc=1, dl=0, f={
                {x=296, y=75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopUp1_button", sc=1, dl=0, f={
                {x=96, y=75, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_value_txt", sc=1, dl=0, f={
                {x=397.95, y=171.85, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cost_desc_txt", sc=1, dl=0, f={
                {x=190.95, y=160.7, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_tili_bg", sc=1, dl=0, f={
                {x=264.85, y=220.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_bg", sc=1, dl=0, f={
                {x=88.75, y=354.7, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strongPointName_txt", sc=1, dl=0, f={
                {x=163.05, y=321.05, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=468, y=366, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mopUpResult_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=645.05, kx=0, ky=0, cx=120, cy=161.26, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bag_background_img", sc=1, dl=0, f={
                {x=0, y=645.05, kx=0, ky=0, cx=6.08, cy=8.16, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fetch_button", sc=1, dl=0, f={
                {x=155.95, y=105.64999999999998, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_yellow_line1", sc=1, dl=0, f={
                {x=7, y=570.05, kx=0, ky=0, cx=1.91, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_txt", sc=1, dl=0, f={
                {x=155.95, y=575.0999999999999, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="resource_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="yeqian_bg", sc=1, dl=0, f={
                {x=581, y=-239.45, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="upgradeBtn", sc=1, dl=0, f={
                {x=495.3, y=-134.85000000000002, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lock", sc=1, dl=0, f={
                {x=502.3, y=-243.35, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="result_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=226, kx=0, ky=0, cx=117, cy=56.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=2.35, y=4.5, kx=0, ky=0, cx=1.91, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="times_txt", sc=1, dl=0, f={
                {x=31, y=187, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="obtain_txt", sc=1, dl=0, f={
                {x=31, y=147, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_txt", sc=1, dl=0, f={
                {x=151, y=147, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_txt", sc=1, dl=0, f={
                {x=328, y=147, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="storyLine_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1171.1, y=705.9, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="allStar_text", sc=1, dl=0, f={
                {x=102, y=570, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="allstarImage", sc=1, dl=0, f={
                {x=-128.45, y=613.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="havetakenImage", sc=1, dl=0, f={
                {x=-162.1, y=720, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="strongPoint_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="starbg", sc=1, dl=0, f={
                {x=34.5, y=78.20000000000005, kx=0, ky=0, cx=3.01, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="darkstar1", sc=1, dl=0, f={
                {x=160.85, y=111.70000000000005, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="darkstar2", sc=1, dl=0, f={
                {x=254.85, y=111.70000000000005, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="darkstar3", sc=1, dl=0, f={
                {x=340.85, y=114.20000000000005, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="brightstar1", sc=1, dl=0, f={
                {x=160.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="brightstar2", sc=1, dl=0, f={
                {x=254.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="brightstar3", sc=1, dl=0, f={
                {x=340.85, y=114.70000000000005, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="redbg", sc=1, dl=0, f={
                {x=116.95, y=691, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_1", sc=1, dl=0, f={
                {x=596.1, y=677, kx=0, ky=0, cx=7.34, cy=8.04, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_4", sc=1, dl=0, f={
                {x=611.05, y=294.95, kx=0, ky=0, cx=6.94, cy=1.46, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_3", sc=1, dl=0, f={
                {x=611.05, y=504.95, kx=0, ky=0, cx=6.94, cy=2.58, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_2", sc=1, dl=0, f={
                {x=611.05, y=626.95, kx=0, ky=0, cx=6.94, cy=1.46, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili_consume_txt", sc=1, dl=0, f={
                {x=1040.1, y=94.14999999999998, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strongPointName_txt", sc=1, dl=0, f={
                {x=190.4, y=673.4, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strongPoint_desc", sc=1, dl=0, f={
                {x=817.8, y=654.25, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dropOut", sc=1, dl=0, f={
                {x=630.85, y=462.55, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuoMing", sc=1, dl=0, f={
                {x=630.85, y=590.85, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="storyLineDesc", sc=1, dl=0, f={
                {x=719.35, y=588.6, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="boss_bg", sc=1, dl=0, f={
                {x=167.25, y=251.95, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jingying_bg", sc=1, dl=0, f={
                {x=167.95, y=252.55, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_silver_bg0", sc=1, dl=0, f={
                {x=714.8, y=486.95, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=833, y=427, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=701, y=427, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_txt", sc=1, dl=0, f={
                {x=803.9, y=453.35, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exp_txt", sc=1, dl=0, f={
                {x=991.5, y=453.45, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1177.1, y=713, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopUp_button", sc=1, dl=0, f={
                {x=611.85, y=117.75, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopUp10_button", sc=1, dl=0, f={
                {x=775.85, y=117.75, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="enter_button", sc=1, dl=0, f={
                {x=1063.75, y=176.64999999999998, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopup10Condition_txt", sc=1, dl=0, f={
                {x=886.1, y=135.14999999999998, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="mopupCondition_txt", sc=1, dl=0, f={
                {x=693.1, y=102.14999999999998, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="saoDangQuan_txt", sc=1, dl=0, f={
                {x=693.1, y=159.14999999999998, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuoMing1", sc=1, dl=0, f={
                {x=630.85, y=255.9, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="storyLineDesc1", sc=1, dl=0, f={
                {x=719.35, y=253.65, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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