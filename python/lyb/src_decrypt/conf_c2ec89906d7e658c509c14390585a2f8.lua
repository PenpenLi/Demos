local conf = {type="skeleton", name="hero_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="heroAsserts/otherImgs", 
      bones={           
           {type="b", name="图层 7", x=27.9, y=421.85, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="yuanfen_duihao", isArmature=0}} },
           {type="b", name="图层 24", x=316.9, y=538.25, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="xiaozi_bg", isArmature=0}} },
           {type="b", name="图层 31", x=43.45, y=561.3, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="touxiang_bg", isArmature=0}} },
           {type="b", name="图层 32", x=184.95, y=547.3, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="touxiang_mask", isArmature=0}} },
           {type="b", name="图层 2", x=-62, y=696.2, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="skill_type_2", isArmature=0}} },
           {type="b", name="图层 3", x=26.95, y=696.2, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="skill_type_4", isArmature=0}} },
           {type="b", name="图层 4", x=104.95, y=700.2, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="skill_type_3", isArmature=0}} },
           {type="b", name="图层 6", x=189.9, y=778.1500000000001, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="skill_miaoshu_1", isArmature=0}} },
           {type="b", name="图层 8", x=205.9, y=726.2, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="skill_miaoshu_2", isArmature=0}} },
           {type="b", name="图层 9", x=213.9, y=682.2, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="skill_miaoshu_3", isArmature=0}} },
           {type="b", name="图层 10", x=232.9, y=632.25, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="skill_miaoshu_4", isArmature=0}} }
         }
      },
    {type="armature", name="heroPro_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderGroup", x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="renderGroup", isArmature=1}} },
           {type="b", name="name_bg", x=60, y=640, kx=0, ky=0, cx=1, cy=1, z=2, text={x=66,y=408, w=34, h=210,lineType="multiline",size=30,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="hero_name_bg", isArmature=0}} },
           {type="b", name="progress_bar_bg", x=164, y=45, kx=0, ky=0, cx=64.67, cy=1, z=3, d={{name="progress_bar_bg", isArmature=0}} },
           {type="b", name="progress_fg", x=164, y=42.60000000000002, kx=0, ky=0, cx=64.67, cy=1, z=4, d={{name="progress_fg", isArmature=0}} },
           {type="b", name="zhanli_bg", x=140.25, y=99.39999999999998, kx=0, ky=0, cx=3.52, cy=1, z=5, d={{name="zhanli_bg", isArmature=0}} },
           {type="b", name="level_descb", x=2, y=108, kx=0, ky=0, cx=1, cy=1, z=6, text={x=194,y=19, w=318, h=34,lineType="single line",size=22,color="fff6e5",alignment="center",space=0,textType="dynamic"}, d={{name="level_progress", isArmature=0}} },
           {type="b", name="max_img", x=114.5, y=67, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="max_img", isArmature=0}} },
           {type="b", name="level_up_btn", x=635, y=69, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="ask", x=1040, y=688, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1105, y=695, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="effect1", x=628.95, y=69, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="heroProRender/heroYuanfenItemRender", 
      bones={           
           {type="b", name="hit_area", x=0, y=212, kx=0, ky=0, cx=110.75, cy=53, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg_1", x=26, y=160, kx=0, ky=0, cx=5.3, cy=1, z=1, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="bg_2", x=26, y=119, kx=0, ky=0, cx=8, cy=2.5, z=2, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="descb_1", x=102, y=192, kx=0, ky=0, cx=1, cy=1, z=3, text={x=35,y=157, w=207, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2", x=151, y=172, kx=0, ky=0, cx=1, cy=1, z=4, text={x=154,y=156, w=254, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3", x=37, y=106, kx=0, ky=0, cx=1, cy=1, z=5, text={x=42,y=124, w=290, h=36,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="weijihuoImg", x=309, y=197.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="weijihuoImg", isArmature=0}} },
           {type="b", name="yimanji_img", x=309, y=197, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="yimanji_img", isArmature=0}} },
           {type="b", name="upgradeBtn", x=356, y=189.5, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="heroComponent/upgradeBtn2", isArmature=0}} },
           {type="b", name="effect", x=411, y=207, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="prop_detail_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=515, kx=0, ky=0, cx=62.5, cy=128.75, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=515, kx=0, ky=0, cx=3.16, cy=6.52, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_copy_image_separator", x=13.25, y=313, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="title_1", x=64.15, y=480.45, kx=0, ky=0, cx=1, cy=1, z=3, text={x=47,y=451, w=150, h=36,lineType="single line",size=24,color="ffe6a0",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_2", x=64.15, y=284.45, kx=0, ky=0, cx=1, cy=1, z=4, text={x=47,y=255, w=150, h=36,lineType="single line",size=24,color="ffe6a0",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_1", x=64.15, y=444.45, kx=0, ky=0, cx=1, cy=1, z=5, text={x=65,y=418, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_2", x=64.15, y=410.45, kx=0, ky=0, cx=1, cy=1, z=6, text={x=65,y=386, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_3", x=64.15, y=371.45, kx=0, ky=0, cx=1, cy=1, z=7, text={x=65,y=354, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_4", x=64.15, y=341.45, kx=0, ky=0, cx=1, cy=1, z=8, text={x=65,y=322, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_5", x=64.15, y=249.45, kx=0, ky=0, cx=1, cy=1, z=9, text={x=65,y=222, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_6", x=64.15, y=213.45, kx=0, ky=0, cx=1, cy=1, z=10, text={x=65,y=190, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_7", x=64.15, y=184.45, kx=0, ky=0, cx=1, cy=1, z=11, text={x=65,y=158, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_8", x=64.15, y=151.45, kx=0, ky=0, cx=1, cy=1, z=12, text={x=65,y=126, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_9", x=64.15, y=118.45, kx=0, ky=0, cx=1, cy=1, z=13, text={x=65,y=94, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_10", x=64.15, y=85.44999999999999, kx=0, ky=0, cx=1, cy=1, z=14, text={x=65,y=62, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_11", x=64.15, y=50.44999999999999, kx=0, ky=0, cx=1, cy=1, z=15, text={x=65,y=30, w=150, h=34,lineType="single line",size=22,color="fff5d7",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="renderGroup", 
      bones={           
           {type="b", name="common_copy_background_5", x=655, y=-50, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="图层 2", x=672, y=-64.95, kx=0, ky=0, cx=0.96, cy=1, z=1, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=753.85, y=-66.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="titleTF", x=1069.05, y=-74.95, kx=0, ky=0, cx=1, cy=1, z=3, text={x=792,y=-115, w=259, h=44,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="tabBtn4", x=1126, y=-519, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn3", x=1126, y=-387, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn2", x=1126, y=-257, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} },
           {type="b", name="tabBtn1", x=1126, y=-127, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_channel_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_channel_button", 
      bones={           
           {type="b", name="common_channel_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=29,y=-110, w=35, h=86,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonButtons/common_copy_channel_button_normal", isArmature=0},{name="commonButtons/common_copy_channel_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="shengxing_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=128.5, y=647.5, kx=0, ky=0, cx=0.9, cy=0.9, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg_1", x=508, y=610, kx=0, ky=0, cx=7.34, cy=6.34, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="small_bg_1", x=538, y=558, kx=0, ky=0, cx=14.32, cy=1, z=3, d={{name="small_bg", isArmature=0}} },
           {type="b", name="small_bg_2", x=538, y=500.9, kx=0, ky=0, cx=14.32, cy=1, z=4, d={{name="small_bg", isArmature=0}} },
           {type="b", name="small_bg_3", x=538, y=443.8, kx=0, ky=0, cx=14.32, cy=1, z=5, d={{name="small_bg", isArmature=0}} },
           {type="b", name="small_bg_4", x=538, y=386.7, kx=0, ky=0, cx=14.32, cy=1, z=6, d={{name="small_bg", isArmature=0}} },
           {type="b", name="small_bg_5", x=538, y=330, kx=0, ky=0, cx=14.32, cy=1, z=7, d={{name="small_bg", isArmature=0}} },
           {type="b", name="line_2", x=529, y=281.55, kx=0, ky=0, cx=93.33, cy=1, z=8, d={{name="ver_line", isArmature=0}} },
           {type="b", name="line_3", x=529, y=172.20000000000005, kx=0, ky=0, cx=93.33, cy=1, z=9, d={{name="ver_line", isArmature=0}} },
           {type="b", name="levelUpArrow", x=824, y=439, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="levelUpArrow0", x=824, y=496.5, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="levelUpArrow1", x=824, y=554, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="levelUpArrow2", x=824, y=382, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="levelUpArrow3", x=824, y=325, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="title_1", x=601.55, y=549.35, kx=0, ky=0, cx=1, cy=1, z=15, text={x=569,y=518, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_2", x=601.55, y=492.35, kx=0, ky=0, cx=1, cy=1, z=16, text={x=569,y=460, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_3", x=601.55, y=422.4, kx=0, ky=0, cx=1, cy=1, z=17, text={x=569,y=403, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_4", x=601.55, y=362.4, kx=0, ky=0, cx=1, cy=1, z=18, text={x=569,y=346, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_5", x=601.55, y=306.4, kx=0, ky=0, cx=1, cy=1, z=19, text={x=569,y=289, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1_1", x=743.7, y=549.35, kx=0, ky=0, cx=1, cy=1, z=20, text={x=710,y=518, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2_1", x=743.7, y=492.35, kx=0, ky=0, cx=1, cy=1, z=21, text={x=710,y=460, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3_1", x=743.7, y=422.4, kx=0, ky=0, cx=1, cy=1, z=22, text={x=710,y=403, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_4_1", x=743.7, y=360.4, kx=0, ky=0, cx=1, cy=1, z=23, text={x=710,y=346, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_5_1", x=743.7, y=302.4, kx=0, ky=0, cx=1, cy=1, z=24, text={x=710,y=289, w=143, h=36,lineType="single line",size=24,color="fff6e5",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1_2", x=960.75, y=549.35, kx=0, ky=0, cx=1, cy=1, z=25, text={x=898,y=518, w=143, h=36,lineType="single line",size=24,color="46ff4f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2_2", x=962.2, y=492.4, kx=0, ky=0, cx=1, cy=1, z=26, text={x=900,y=460, w=143, h=36,lineType="single line",size=24,color="46ff4f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3_2", x=962.2, y=426.65, kx=0, ky=0, cx=1, cy=1, z=27, text={x=900,y=403, w=143, h=36,lineType="single line",size=24,color="46ff4f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_4_2", x=962.2, y=366.65, kx=0, ky=0, cx=1, cy=1, z=28, text={x=900,y=346, w=143, h=36,lineType="single line",size=24,color="46ff4f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_5_2", x=962.2, y=316.65, kx=0, ky=0, cx=1, cy=1, z=29, text={x=900,y=289, w=143, h=36,lineType="single line",size=24,color="46ff4f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silver_descb", x=597.55, y=152.39999999999998, kx=0, ky=0, cx=1, cy=1, z=30, text={x=567,y=113, w=400, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silver", x=674.6, y=146.85000000000002, kx=0, ky=0, cx=1, cy=1, z=31, text={x=739,y=113, w=193, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="cailiao_descb", x=597.55, y=265.4, kx=0, ky=0, cx=1, cy=1, z=32, text={x=567,y=221, w=244, h=36,lineType="single line",size=24,color="fdf4fa",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_need_descb", x=933.55, y=221.4, kx=0, ky=0, cx=1, cy=1, z=33, text={x=903,y=183, w=205, h=36,lineType="single line",size=24,color="fdf4fa",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_small_blue_button", x=876.65, y=162.14999999999998, kx=0, ky=0, cx=1, cy=1, z=34, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1100.5, y=680, kx=0, ky=0, cx=1, cy=1, z=35, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="shengxing_title", x=502.95, y=636.05, kx=0, ky=0, cx=1, cy=1, z=36, d={{name="shengxing_title", isArmature=0}} },
           {type="b", name="jinjie_title", x=502.95, y=636.05, kx=0, ky=0, cx=1, cy=1, z=37, d={{name="jinjie_title", isArmature=0}} }
         }
      },
    {type="armature", name="shipin_jinjie_render", 
      bones={           
           {type="b", name="common_copy_background_5", x=0, y=660, kx=0, ky=0, cx=1.07, cy=1, z=0, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_copy_biaoti_bg", x=17, y=645.05, kx=0, ky=0, cx=1.02, cy=1, z=1, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=95.5, y=643.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="common_copy_item_bg_7", x=22, y=587.05, kx=0, ky=0, cx=7.06, cy=4.14, z=3, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="jinjie_bg", x=39, y=579.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="shipin_jinjie_bg", isArmature=0}} },
           {type="b", name="grid_1", x=94, y=576.5, kx=0, ky=0, cx=1, cy=1, z=5, text={x=64,y=442, w=163, h=28,lineType="single line",size=18,color="fdf0c9",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="grid_2", x=323, y=576.5, kx=0, ky=0, cx=1, cy=1, z=6, text={x=296,y=442, w=163, h=28,lineType="single line",size=18,color="fdf0c9",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg", x=26, y=294, kx=0, ky=0, cx=9.48, cy=4, z=7, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_title_bg", x=28, y=290.55, kx=0, ky=0, cx=9.79, cy=1, z=8, text={x=45,y=256, w=163, h=31,lineType="single line",size=20,color="fdf0c9",alignment="left",space=0,textType="dynamic"}, d={{name="zhuangbei_cailiao_title_bg", isArmature=0}} },
           {type="b", name="huafei", x=139.15, y=96.45000000000005, kx=0, ky=0, cx=1, cy=1, z=9, text={x=90,y=88, w=129, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huafei_descb", x=206.45, y=128.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, text={x=262,y=88, w=129, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="btn", x=167.5, y=84.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="arrow", x=214.5, y=551, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="strengthenImages/arrow", isArmature=0}} },
           {type="b", name="prop_descb_1_1", x=114.15, y=391.3, kx=0, ky=0, cx=1, cy=1, z=13, text={x=71,y=415, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_2", x=114.15, y=333.3, kx=0, ky=0, cx=1, cy=1, z=14, text={x=71,y=387, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_3", x=114.15, y=281.3, kx=0, ky=0, cx=1, cy=1, z=15, text={x=71,y=359, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_4", x=114.15, y=235.3, kx=0, ky=0, cx=1, cy=1, z=16, text={x=71,y=331, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_5", x=114.15, y=177.3, kx=0, ky=0, cx=1, cy=1, z=17, text={x=71,y=303, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_1", x=166.15, y=391.3, kx=0, ky=0, cx=1, cy=1, z=18, text={x=303,y=415, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_2", x=166.15, y=333.3, kx=0, ky=0, cx=1, cy=1, z=19, text={x=303,y=387, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_3", x=166.15, y=281.3, kx=0, ky=0, cx=1, cy=1, z=20, text={x=303,y=359, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_4", x=166.15, y=235.3, kx=0, ky=0, cx=1, cy=1, z=21, text={x=303,y=331, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_5", x=166.15, y=177.3, kx=0, ky=0, cx=1, cy=1, z=22, text={x=303,y=303, w=150, h=28,lineType="single line",size=18,color="fff8e3",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="shipin_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=550, kx=0, ky=0, cx=111.25, cy=137.51, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=0, y=550, kx=0, ky=0, cx=5.43, cy=6.71, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="bg1", x=20, y=520, kx=0, ky=0, cx=8.1, cy=3.81, z=2, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="bg2", x=20, y=356, kx=0, ky=0, cx=8.1, cy=1.43, z=3, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="bg3", x=20, y=252, kx=0, ky=0, cx=8.1, cy=3.81, z=4, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="bg4", x=20, y=88, kx=0, ky=0, cx=8.1, cy=1.43, z=5, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="common_copy_grid1", x=32, y=509, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_copy_grid2", x=32, y=241, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="name1", x=55.55, y=390.65, kx=0, ky=0, cx=1, cy=1, z=8, text={x=17,y=364, w=130, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="name2", x=17.4, y=130.3, kx=0, ky=0, cx=1, cy=1, z=9, text={x=17,y=96, w=130, h=36,lineType="single line",size=24,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_1", x=164.15, y=494.3, kx=0, ky=0, cx=1, cy=1, z=10, text={x=148,y=480, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_2", x=164.15, y=454.3, kx=0, ky=0, cx=1, cy=1, z=11, text={x=148,y=451, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_3", x=164.15, y=422.3, kx=0, ky=0, cx=1, cy=1, z=12, text={x=148,y=422, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_4", x=164.15, y=392.3, kx=0, ky=0, cx=1, cy=1, z=13, text={x=148,y=393, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_5", x=164.15, y=362.3, kx=0, ky=0, cx=1, cy=1, z=14, text={x=148,y=364, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_1", x=164.15, y=226.3, kx=0, ky=0, cx=1, cy=1, z=15, text={x=148,y=212, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_2", x=164.15, y=186.3, kx=0, ky=0, cx=1, cy=1, z=16, text={x=148,y=183, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_3", x=164.15, y=154.3, kx=0, ky=0, cx=1, cy=1, z=17, text={x=148,y=154, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_4", x=164.15, y=124.3, kx=0, ky=0, cx=1, cy=1, z=18, text={x=148,y=125, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_5", x=164.15, y=94.3, kx=0, ky=0, cx=1, cy=1, z=19, text={x=148,y=96, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2", x=36, y=32.299999999999955, kx=0, ky=0, cx=1, cy=1, z=20, text={x=36,y=37, w=163, h=36,lineType="single line",size=24,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1", x=52.15, y=306.3, kx=0, ky=0, cx=1, cy=1, z=21, text={x=36,y=305, w=163, h=36,lineType="single line",size=24,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="btn1", x=311, y=359, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn2", x=311, y=91, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="red_btn_1", x=311, y=473.5, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="red_btn_2", x=311, y=206, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="none_2_1", x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=26, text={x=113,y=146, w=220, h=44,lineType="single line",size=30,color="57290f",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="none_2_2", x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=27, text={x=23,y=109, w=400, h=31,lineType="single line",size=20,color="57290f",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="none_1_1", x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=28, text={x=113,y=413, w=220, h=44,lineType="single line",size=30,color="57290f",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="none_1_2", x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=29, text={x=23,y=376, w=400, h=31,lineType="single line",size=20,color="57290f",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="effect_1", x=411, y=367, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect_2", x=411, y=99, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-45, w=105, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="shipin_xilian_chenggong_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_5", x=422, y=586, kx=0, ky=0, cx=1.31, cy=0.68, z=1, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_copy_biaoti_bg", x=439, y=573.05, kx=0, ky=0, cx=1.29, cy=1, z=2, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=580, y=571.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg", x=446.5, y=508.95, kx=0, ky=0, cx=12.04, cy=6.43, z=4, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg2", x=446.5, y=226.95, kx=0, ky=0, cx=12.04, cy=1.74, z=5, text={x=463,y=169, w=285, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="btn_xilian", x=892.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_xilian_quxiao", x=750.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="zhuangbei_cailiao_bg0", x=454.45, y=501.45, kx=0, ky=0, cx=2.56, cy=5.8, z=8, d={{name="zhuangbei_cailiao_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_1", x=574, y=499.45, kx=0, ky=0, cx=10.36, cy=1, z=9, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_2", x=574, y=448.2, kx=0, ky=0, cx=10.36, cy=1, z=10, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_3", x=574, y=396.95, kx=0, ky=0, cx=10.36, cy=1, z=11, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_4", x=574, y=345.7, kx=0, ky=0, cx=10.36, cy=1, z=12, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_5", x=574, y=294.45, kx=0, ky=0, cx=10.36, cy=1, z=13, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_1", x=602.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=14, text={x=586,y=459, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_2", x=602.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=15, text={x=586,y=408, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_3", x=602.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=16, text={x=586,y=357, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_4", x=602.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=17, text={x=586,y=305, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_5", x=602.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=18, text={x=586,y=254, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_1", x=774.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=19, text={x=758,y=459, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_2", x=774.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=20, text={x=758,y=408, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_3", x=774.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=21, text={x=758,y=357, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_4", x=774.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=22, text={x=758,y=305, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_5", x=774.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=23, text={x=758,y=254, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="arrow_1", x=774.15, y=495.45, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="arrow_2", x=774.15, y=444.2, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="arrow_3", x=774.15, y=392.95, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="arrow_4", x=774.15, y=341.7, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="arrow_5", x=774.15, y=290.45, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="heroAsserts/levelUpArrow", isArmature=0}} },
           {type="b", name="grid", x=458.95, y=487.5, kx=0, ky=0, cx=1, cy=1, z=29, text={x=461,y=350, w=104, h=28,lineType="single line",size=18,color="feefd3",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="detail_btn", x=458.95, y=314.1, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="shipin_xilian_shuxing_layer", x=107.4, y=586, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="shipin_xilian_shuxing_layer", isArmature=1}} }
         }
      },
    {type="armature", name="shipin_xilian_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_5", x=422, y=586, kx=0, ky=0, cx=1.31, cy=0.68, z=1, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_copy_biaoti_bg", x=439, y=573.05, kx=0, ky=0, cx=1.29, cy=1, z=2, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=580, y=571.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg", x=446.5, y=508.95, kx=0, ky=0, cx=12.04, cy=6.43, z=4, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg2", x=446.5, y=226.95, kx=0, ky=0, cx=12.04, cy=1.74, z=5, text={x=485,y=169, w=129, h=36,lineType="single line",size=24,color="feefd3",alignment="left",space=0,textType="dynamic"}, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="huafei_descb", x=566.45, y=206.04999999999995, kx=0, ky=0, cx=1, cy=1, z=6, text={x=622,y=169, w=129, h=36,lineType="single line",size=24,color="feefd3",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="huafei_gold_descb", x=716, y=207, kx=0, ky=0, cx=1, cy=1, z=7, text={x=776,y=169, w=129, h=36,lineType="single line",size=24,color="feefd3",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="btn_xilian", x=892.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="zhuangbei_cailiao_bg0", x=454.45, y=501.45, kx=0, ky=0, cx=2.56, cy=5.8, z=9, d={{name="zhuangbei_cailiao_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_1", x=574, y=499.45, kx=0, ky=0, cx=10.36, cy=1, z=10, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_2", x=574, y=448.2, kx=0, ky=0, cx=10.36, cy=1, z=11, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_3", x=574, y=396.95, kx=0, ky=0, cx=10.36, cy=1, z=12, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_4", x=574, y=345.7, kx=0, ky=0, cx=10.36, cy=1, z=13, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="shuxing_bg_5", x=574, y=294.45, kx=0, ky=0, cx=10.36, cy=1, z=14, d={{name="shuxing_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_1", x=602.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=15, text={x=586,y=459, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_2", x=602.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=16, text={x=586,y=408, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_3", x=602.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=17, text={x=586,y=357, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_4", x=602.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=18, text={x=586,y=305, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_1_5", x=602.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=19, text={x=586,y=254, w=250, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_1", x=654.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=20, text={x=662,y=459, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_2", x=654.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=21, text={x=662,y=408, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_3", x=654.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=22, text={x=662,y=357, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_4", x=654.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=23, text={x=662,y=305, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb_2_5", x=654.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=24, text={x=662,y=254, w=250, h=34,lineType="single line",size=22,color="220901",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="btn_1", x=915, y=504.45, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="grid", x=458.95, y=487.5, kx=0, ky=0, cx=1, cy=1, z=26, text={x=461,y=350, w=104, h=28,lineType="single line",size=18,color="feefd3",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="detail_btn", x=458.95, y=314.1, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="shipin_xilian_shuxing_layer", x=107.4, y=586, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="shipin_xilian_shuxing_layer", isArmature=1}} }
         }
      },
    {type="armature", name="shipin_xilian_shuxing_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=68.75, cy=111.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=0, kx=0, ky=0, cx=3.48, cy=5.63, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="title_1", x=6, y=-4, kx=0, ky=0, cx=5.84, cy=1, z=2, text={x=38,y=-47, w=200, h=36,lineType="single line",size=24,color="fae6b4",alignment="center",space=0,textType="static"}, d={{name="commonPanels/common_copy_title_bg", isArmature=0}} },
           {type="b", name="item_bg_1", x=9, y=-57, kx=0, ky=0, cx=2.68, cy=1.06, z=3, text={x=17,y=-90, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_2", x=9, y=-95.2, kx=0, ky=0, cx=2.68, cy=1.06, z=4, text={x=17,y=-129, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_3", x=9, y=-133.4, kx=0, ky=0, cx=2.68, cy=1.06, z=5, text={x=17,y=-167, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_4", x=9, y=-171.6, kx=0, ky=0, cx=2.68, cy=1.06, z=6, text={x=17,y=-205, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_5", x=9, y=-209.8, kx=0, ky=0, cx=2.68, cy=1.06, z=7, text={x=17,y=-243, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_6", x=9, y=-248, kx=0, ky=0, cx=2.68, cy=1.06, z=8, text={x=17,y=-281, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_7", x=9, y=-286.2, kx=0, ky=0, cx=2.68, cy=1.06, z=9, text={x=17,y=-320, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_8", x=9, y=-324.4, kx=0, ky=0, cx=2.68, cy=1.06, z=10, text={x=17,y=-358, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_9", x=9, y=-362.6, kx=0, ky=0, cx=2.68, cy=1.06, z=11, text={x=17,y=-396, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_10", x=9, y=-401, kx=0, ky=0, cx=2.68, cy=1.06, z=12, text={x=17,y=-434, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="left",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_1_shangxian", x=9, y=-57, kx=0, ky=0, cx=2.68, cy=1.06, z=13, text={x=17,y=-90, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_2_shangxian", x=9, y=-95.2, kx=0, ky=0, cx=2.68, cy=1.06, z=14, text={x=17,y=-129, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_3_shangxian", x=9, y=-133.4, kx=0, ky=0, cx=2.68, cy=1.06, z=15, text={x=17,y=-167, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_4_shangxian", x=9, y=-171.6, kx=0, ky=0, cx=2.68, cy=1.06, z=16, text={x=17,y=-205, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_5_shangxian", x=9, y=-209.8, kx=0, ky=0, cx=2.68, cy=1.06, z=17, text={x=17,y=-243, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_6_shangxian", x=9, y=-248, kx=0, ky=0, cx=2.68, cy=1.06, z=18, text={x=17,y=-281, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_7_shangxian", x=9, y=-286.2, kx=0, ky=0, cx=2.68, cy=1.06, z=19, text={x=17,y=-320, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_8_shangxian", x=9, y=-324.4, kx=0, ky=0, cx=2.68, cy=1.06, z=20, text={x=17,y=-358, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_9_shangxian", x=9, y=-362.6, kx=0, ky=0, cx=2.68, cy=1.06, z=21, text={x=17,y=-396, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} },
           {type="b", name="item_bg_10_shangxian", x=9, y=-401, kx=0, ky=0, cx=2.68, cy=1.06, z=22, text={x=17,y=-434, w=240, h=34,lineType="single line",size=22,color="fff3cd",alignment="right",space=0,textType="dynamic"}, d={{name="shuxing_item_bg", isArmature=0}} }
         }
      },
    {type="armature", name="skill_detail_layer", 
      bones={           
           {type="b", name="hit_area", x=0, y=500, kx=0, ky=0, cx=95, cy=125, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_background_1", x=0, y=500, kx=0, ky=0, cx=4.81, cy=6.33, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="common_image_separator_1", x=14, y=356, kx=0, ky=0, cx=1.45, cy=1, z=2, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="common_image_separator_2", x=14, y=173, kx=0, ky=0, cx=1.45, cy=1, z=3, d={{name="commonImages/common_copy_image_separator", isArmature=0}} },
           {type="b", name="skill_name", x=177.45, y=417.55, kx=0, ky=0, cx=1, cy=1, z=4, text={x=134,y=430, w=202, h=44,lineType="single line",size=30,color="ff00ff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_level", x=171.45, y=404.55, kx=0, ky=0, cx=1, cy=1, z=5, text={x=134,y=404, w=206, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_cd", x=171.45, y=368.55, kx=0, ky=0, cx=1, cy=1, z=6, text={x=134,y=368, w=206, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_descb", x=65.45, y=232.65, kx=0, ky=0, cx=1, cy=1, z=7, text={x=22,y=38, w=336, h=272,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_title_descb", x=65.45, y=272.65, kx=0, ky=0, cx=1, cy=1, z=8, text={x=22,y=314, w=336, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_level_need", x=20, y=91.60000000000002, kx=0, ky=0, cx=1, cy=1, z=9, text={x=20,y=89, w=120, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="skill_silverl_need", x=121.5, y=129.10000000000002, kx=0, ky=0, cx=1, cy=1, z=10, text={x=171,y=89, w=144, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="skill_upgrade", x=57.45, y=129.60000000000002, kx=0, ky=0, cx=1, cy=1, z=11, text={x=20,y=129, w=158, h=36,lineType="single line",size=24,color="fff5d7",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_grid", x=20, y=479, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="common_blue_button", x=124, y=70, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="yimanji_img", x=126, y=146.64999999999998, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="yimanji_img", isArmature=0}} }
         }
      },
    {type="armature", name="wuxing_detail_layer", 
      bones={           
           {type="b", name="common_copy_background_1", x=0, y=170, kx=0, ky=0, cx=5.44, cy=2.15, z=0, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="descb_2", x=20.15, y=122.5, kx=0, ky=0, cx=1, cy=1, z=1, text={x=15,y=13, w=400, h=104,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1", x=20.15, y=160.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=15,y=126, w=400, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="xinxi_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=580, kx=0, ky=0, cx=112.5, cy=145, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="equip_bg", x=7, y=569, kx=0, ky=0, cx=5.35, cy=3.48, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="equip_bg_2", x=7, y=273, kx=0, ky=0, cx=5.35, cy=3.12, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="background_1", x=14, y=522, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_2", x=14, y=465, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_3", x=14, y=408, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_4", x=226.5, y=522, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_5", x=226.5, y=465, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_6", x=226.5, y=408, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="prop_background", isArmature=0}} },
           {type="b", name="background_7", x=14, y=351, kx=0, ky=0, cx=2, cy=1, z=9, d={{name="prop_background", isArmature=0}} },
           {type="b", name="title_1", x=35.15, y=507.45, kx=0, ky=0, cx=1, cy=1, z=10, text={x=18,y=475, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_2", x=33.15, y=452.4, kx=0, ky=0, cx=1, cy=1, z=11, text={x=18,y=418, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_3", x=35.15, y=397.1, kx=0, ky=0, cx=1, cy=1, z=12, text={x=18,y=361, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_4", x=249.15, y=507.45, kx=0, ky=0, cx=1, cy=1, z=13, text={x=231,y=475, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_5", x=264.15, y=465, kx=0, ky=0, cx=1, cy=1, z=14, text={x=231,y=418, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_6", x=243.15, y=400.05, kx=0, ky=0, cx=1, cy=1, z=15, text={x=231,y=361, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="title_7", x=29.15, y=397.1, kx=0, ky=0, cx=1, cy=1, z=16, text={x=18,y=304, w=81, h=39,lineType="single line",size=26,color="67190e",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_1", x=133.15, y=512.45, kx=0, ky=0, cx=1, cy=1, z=17, text={x=108,y=479, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_2", x=133.15, y=459.4, kx=0, ky=0, cx=1, cy=1, z=18, text={x=108,y=418, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_3", x=133.15, y=396.1, kx=0, ky=0, cx=1, cy=1, z=19, text={x=108,y=361, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_4", x=352.15, y=514.45, kx=0, ky=0, cx=1, cy=1, z=20, text={x=320,y=475, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_5", x=358.65, y=465, kx=0, ky=0, cx=1, cy=1, z=21, text={x=320,y=418, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="descb_6", x=354.65, y=398.45, kx=0, ky=0, cx=1, cy=1, z=22, text={x=320,y=361, w=115, h=36,lineType="single line",size=24,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="line", x=26.5, y=231, kx=0, ky=0, cx=66.67, cy=1, z=23, text={x=13,y=232, w=81, h=39,lineType="single line",size=26,color="eddcbb",alignment="center",space=0,textType="dynamic"}, d={{name="line", isArmature=0}} },
           {type="b", name="line1", x=26.5, y=527, kx=0, ky=0, cx=66.67, cy=1, z=24, text={x=13,y=528, w=81, h=39,lineType="single line",size=26,color="eddcbb",alignment="center",space=0,textType="dynamic"}, d={{name="line", isArmature=0}} },
           {type="b", name="jinjie_btn", x=173.5, y=519, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="jinjie_btn", isArmature=0}} },
           {type="b", name="shengxing_btn", x=318, y=356.15, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="xiangxi_btn", x=318.5, y=566.7, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="xiangxi_btn", isArmature=0}} },
           {type="b", name="skill_bg_1", x=12, y=224.55, kx=0, ky=0, cx=3.12, cy=1.46, z=28, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="skill_name_1", x=94, y=207.6, kx=0, ky=0, cx=1, cy=1, z=29, text={x=100,y=180, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_level_1", x=94, y=183.6, kx=0, ky=0, cx=1, cy=1, z=30, text={x=100,y=155, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_silver_1", x=94, y=159.60000000000002, kx=0, ky=0, cx=1, cy=1, z=31, text={x=137,y=131, w=90, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_btn_1", x=174.5, y=212.55, kx=0, ky=0, cx=1, cy=1, z=32, d={{name="skill_btn", isArmature=1}} },
           {type="b", name="skill_silver_bg_1", x=97.35, y=184.2, kx=0, ky=0, cx=1, cy=1, z=33, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="skill_bg_2", x=228, y=225, kx=0, ky=0, cx=3.12, cy=1.46, z=34, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="skill_name_2", x=310, y=208.05, kx=0, ky=0, cx=1, cy=1, z=35, text={x=316,y=180, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_level_2", x=310, y=184.05, kx=0, ky=0, cx=1, cy=1, z=36, text={x=316,y=155, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_silver_2", x=310, y=160.05, kx=0, ky=0, cx=1, cy=1, z=37, text={x=353,y=131, w=90, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_btn_2", x=390.5, y=213, kx=0, ky=0, cx=1, cy=1, z=38, d={{name="skill_btn", isArmature=1}} },
           {type="b", name="skill_silver_bg_2", x=313.35, y=184.65, kx=0, ky=0, cx=1, cy=1, z=39, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="skill_bg_3", x=12, y=123, kx=0, ky=0, cx=3.12, cy=1.46, z=40, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="skill_name_3", x=94, y=106.05, kx=0, ky=0, cx=1, cy=1, z=41, text={x=100,y=78, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_level_3", x=94, y=82.05000000000001, kx=0, ky=0, cx=1, cy=1, z=42, text={x=100,y=53, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_silver_3", x=94, y=58.049999999999955, kx=0, ky=0, cx=1, cy=1, z=43, text={x=137,y=29, w=90, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_btn_3", x=174.5, y=111, kx=0, ky=0, cx=1, cy=1, z=44, d={{name="skill_btn", isArmature=1}} },
           {type="b", name="skill_silver_bg_3", x=97.35, y=82.64999999999998, kx=0, ky=0, cx=1, cy=1, z=45, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="skill_bg_4", x=228, y=123, kx=0, ky=0, cx=3.12, cy=1.46, z=46, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="skill_name_4", x=301, y=106.05, kx=0, ky=0, cx=1, cy=1, z=47, text={x=316,y=78, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_level_4", x=301, y=82.05000000000001, kx=0, ky=0, cx=1, cy=1, z=48, text={x=316,y=53, w=109, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_silver_4", x=310, y=58.049999999999955, kx=0, ky=0, cx=1, cy=1, z=49, text={x=353,y=29, w=90, h=31,lineType="single line",size=18,color="541b09",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_zhanduimingzi_bg", isArmature=0}} },
           {type="b", name="skill_btn_4", x=390.5, y=111, kx=0, ky=0, cx=1, cy=1, z=50, d={{name="skill_btn", isArmature=1}} },
           {type="b", name="skill_silver_bg_4", x=322.35, y=82.64999999999998, kx=0, ky=0, cx=1, cy=1, z=51, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="effect1", x=194, y=230.45, kx=0, ky=0, cx=1, cy=1, z=52, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect2", x=410, y=230.45, kx=0, ky=0, cx=1, cy=1, z=53, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect3", x=194, y=128.5, kx=0, ky=0, cx=1, cy=1, z=54, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect4", x=410, y=128.5, kx=0, ky=0, cx=1, cy=1, z=55, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect5", x=410, y=286.5, kx=0, ky=0, cx=1, cy=1, z=56, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect7", x=203.5, y=530, kx=0, ky=0, cx=1, cy=1, z=57, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect8", x=404.5, y=348.95, kx=0, ky=0, cx=1, cy=1, z=58, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="skill_btn", 
      bones={           
           {type="b", name="skill_btn", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="skill_btn_normal", isArmature=0},{name="skill_btn_down", isArmature=0}} }
         }
      },
    {type="armature", name="yuanfen_render", 
      bones={           
           {type="b", name="common_copy_background_5", x=0, y=417, kx=0, ky=0, cx=1.14, cy=0.63, z=0, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_copy_biaoti_bg", x=17, y=404.05, kx=0, ky=0, cx=1.12, cy=1, z=1, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=115, y=402.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg", x=22.5, y=345.95, kx=0, ky=0, cx=10.4, cy=4.4, z=3, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg2", x=22.5, y=148.95, kx=0, ky=0, cx=10.4, cy=2.93, z=4, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_title_bg", x=23.5, y=343.95, kx=0, ky=0, cx=10.75, cy=1, z=5, text={x=36,y=306, w=481, h=34,lineType="single line",size=22,color="220901",alignment="left",space=0,textType="dynamic"}, d={{name="zhuangbei_cailiao_title_bg", isArmature=0}} },
           {type="b", name="btn", x=393, y=130.95, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="descb", x=56.15, y=123.35000000000002, kx=0, ky=0, cx=1, cy=1, z=7, text={x=35,y=103, w=163, h=34,lineType="single line",size=22,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huafei_descb", x=395.45, y=72.05000000000001, kx=0, ky=0, cx=1, cy=1, z=8, text={x=451,y=32, w=129, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="levelUpArrow", x=206.25, y=343.95, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="heroAsserts/levelUpArrow", isArmature=0}} }
         }
      },
    {type="armature", name="zhuangbei_jinjie_render", 
      bones={           
           {type="b", name="common_copy_background_5", x=0, y=609, kx=0, ky=0, cx=1.06, cy=0.92, z=0, d={{name="commonPanels/common_copy_panel_3", isArmature=0}} },
           {type="b", name="common_copy_biaoti_bg", x=17, y=594.05, kx=0, ky=0, cx=1.02, cy=1, z=1, d={{name="commonImages/common_copy_biaoti_bg", isArmature=0}} },
           {type="b", name="titleBg", x=95.5, y=592.05, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="common_copy_item_bg_7", x=22, y=536.05, kx=0, ky=0, cx=7.06, cy=2.99, z=3, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="jinjie_bg", x=39, y=521.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="jinjie_bg", isArmature=0}} },
           {type="b", name="grid_1", x=94, y=510.5, kx=0, ky=0, cx=1, cy=1, z=5, text={x=67,y=350, w=163, h=54,lineType="single line",size=18,color="fdf0c9",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="grid_2", x=323, y=510.5, kx=0, ky=0, cx=1, cy=1, z=6, text={x=296,y=350, w=163, h=54,lineType="single line",size=18,color="fdf0c9",alignment="center",space=0,textType="dynamic"}, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_bg", x=26, y=326, kx=0, ky=0, cx=9.48, cy=4, z=7, d={{name="xiaobeijing", isArmature=0}} },
           {type="b", name="zhuangbei_cailiao_title_bg", x=28, y=322.55, kx=0, ky=0, cx=9.79, cy=1, z=8, text={x=45,y=288, w=163, h=31,lineType="single line",size=20,color="fdf0c9",alignment="left",space=0,textType="dynamic"}, d={{name="zhuangbei_cailiao_title_bg", isArmature=0}} },
           {type="b", name="huafei", x=139.15, y=118.45, kx=0, ky=0, cx=1, cy=1, z=9, text={x=90,y=110, w=129, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huafei_descb", x=206.45, y=150.05, kx=0, ky=0, cx=1, cy=1, z=10, text={x=262,y=110, w=129, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="btn", x=167.5, y=106.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="tail_descb", x=240.15, y=20.549999999999955, kx=0, ky=0, cx=1, cy=1, z=12, text={x=8,y=9, w=511, h=36,lineType="single line",size=20,color="380e00",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="arrow", x=214.5, y=478.1, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="strengthenImages/arrow", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="zhuangbei_render", 
      bones={           
           {type="b", name="hit_area", x=0, y=588.05, kx=0, ky=0, cx=112.5, cy=147.01, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_6", x=0, y=588.05, kx=0, ky=0, cx=5.49, cy=6.33, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="background_1", x=9, y=582.05, kx=0, ky=0, cx=6.35, cy=1.79, z=2, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="background_2", x=9, y=454.44999999999993, kx=0, ky=0, cx=6.35, cy=1.79, z=3, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="background_3", x=9, y=328.84999999999997, kx=0, ky=0, cx=6.35, cy=1.79, z=4, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="background_4", x=9, y=202.24999999999991, kx=0, ky=0, cx=6.35, cy=1.79, z=5, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="effect_1", x=411, y=582.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect_2", x=411, y=454.44999999999993, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect_3", x=411, y=328.84999999999997, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="effect_4", x=411, y=202.24999999999991, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="grid_1", x=19.5, y=572.55, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="grid_2", x=19.5, y=444.94999999999993, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="grid_3", x=19.5, y=319.34999999999997, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="grid_4", x=19.5, y=192.74999999999991, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="btn_1", x=317, y=567.05, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_2", x=317, y=439.44999999999993, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_3", x=317, y=313.84999999999997, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="btn_4", x=317, y=187.24999999999991, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="name_descb1", x=150.15, y=554.3499999999999, kx=0, ky=0, cx=1, cy=1, z=18, text={x=134,y=525, w=200, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb2", x=150.15, y=428.35, kx=0, ky=0, cx=1, cy=1, z=19, text={x=134,y=397, w=200, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb3", x=150.15, y=295.4, kx=0, ky=0, cx=1, cy=1, z=20, text={x=134,y=271, w=200, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb4", x=150.15, y=169.39999999999998, kx=0, ky=0, cx=1, cy=1, z=21, text={x=134,y=145, w=200, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb1", x=150.15, y=515.3499999999999, kx=0, ky=0, cx=1, cy=1, z=22, text={x=134,y=491, w=163, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb2", x=150.15, y=382.35, kx=0, ky=0, cx=1, cy=1, z=23, text={x=134,y=363, w=163, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb3", x=150.15, y=262.4, kx=0, ky=0, cx=1, cy=1, z=24, text={x=134,y=237, w=163, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="prop_descb4", x=150.15, y=128.39999999999998, kx=0, ky=0, cx=1, cy=1, z=25, text={x=134,y=111, w=163, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="silver_descb1", x=317, y=510.0499999999999, kx=0, ky=0, cx=1, cy=1, z=26, text={x=365,y=475, w=107, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="silver_descb2", x=317, y=382.4, kx=0, ky=0, cx=1, cy=1, z=27, text={x=365,y=347, w=107, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="silver_descb3", x=323, y=256.74999999999994, kx=0, ky=0, cx=1, cy=1, z=28, text={x=371,y=221, w=107, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="silver_descb4", x=317, y=130.09999999999997, kx=0, ky=0, cx=1, cy=1, z=29, text={x=365,y=95, w=107, h=31,lineType="single line",size=20,color="57290f",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="strength_all", x=298, y=67.04999999999995, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} },
           {type="b", name="strength_all_descb", x=159.5, y=56.049999999999955, kx=0, ky=0, cx=1, cy=1, z=31, text={x=16,y=23, w=272, h=34,lineType="single line",size=22,color="ff9600",alignment="left",space=0,textType="dynamic"}, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=6,y=-48, w=121, h=39,lineType="single line",size=26,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="heroAsserts/otherImgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 7", sc=1, dl=0, f={
                {x=27.9, y=421.85, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 24", sc=1, dl=0, f={
                {x=316.9, y=538.25, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 31", sc=1, dl=0, f={
                {x=43.45, y=561.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 32", sc=1, dl=0, f={
                {x=184.95, y=547.3, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=-62, y=696.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=26.95, y=696.2, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=104.95, y=700.2, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6", sc=1, dl=0, f={
                {x=189.9, y=778.1500000000001, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 8", sc=1, dl=0, f={
                {x=205.9, y=726.2, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 9", sc=1, dl=0, f={
                {x=213.9, y=682.2, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 10", sc=1, dl=0, f={
                {x=232.9, y=632.25, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 7", sc=1, dl=0, f={
                {x=27.9, y=421.85, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 24", sc=1, dl=0, f={
                {x=316.9, y=538.25, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 31", sc=1, dl=0, f={
                {x=43.45, y=561.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 32", sc=1, dl=0, f={
                {x=184.95, y=547.3, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=-62, y=696.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 3", sc=1, dl=0, f={
                {x=26.95, y=696.2, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 4", sc=1, dl=0, f={
                {x=104.95, y=700.2, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 6", sc=1, dl=0, f={
                {x=189.9, y=778.1500000000001, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 8", sc=1, dl=0, f={
                {x=205.9, y=726.2, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 9", sc=1, dl=0, f={
                {x=213.9, y=682.2, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 10", sc=1, dl=0, f={
                {x=232.9, y=632.25, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="heroPro_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderGroup", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_bg", sc=1, dl=0, f={
                {x=60, y=640, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress_bar_bg", sc=1, dl=0, f={
                {x=164, y=45, kx=0, ky=0, cx=64.67, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress_fg", sc=1, dl=0, f={
                {x=164, y=42.60000000000002, kx=0, ky=0, cx=64.67, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhanli_bg", sc=1, dl=0, f={
                {x=140.25, y=99.39999999999998, kx=0, ky=0, cx=3.52, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=2, y=108, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="max_img", sc=1, dl=0, f={
                {x=114.5, y=67, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_up_btn", sc=1, dl=0, f={
                {x=635, y=69, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ask", sc=1, dl=0, f={
                {x=1040, y=688, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1105, y=695, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect1", sc=1, dl=0, f={
                {x=628.95, y=69, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="heroProRender/heroYuanfenItemRender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=212, kx=0, ky=0, cx=110.75, cy=53, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=26, y=160, kx=0, ky=0, cx=5.3, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_2", sc=1, dl=0, f={
                {x=26, y=119, kx=0, ky=0, cx=8, cy=2.5, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=102, y=192, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=151, y=172, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3", sc=1, dl=0, f={
                {x=37, y=106, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="weijihuoImg", sc=1, dl=0, f={
                {x=309, y=197.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yimanji_img", sc=1, dl=0, f={
                {x=309, y=197, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="upgradeBtn", sc=1, dl=0, f={
                {x=356, y=189.5, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=411, y=207, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="prop_detail_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=515, kx=0, ky=0, cx=62.5, cy=128.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=515, kx=0, ky=0, cx=3.16, cy=6.52, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_image_separator", sc=1, dl=0, f={
                {x=13.25, y=313, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=64.15, y=480.45, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=64.15, y=284.45, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_1", sc=1, dl=0, f={
                {x=64.15, y=444.45, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_2", sc=1, dl=0, f={
                {x=64.15, y=410.45, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_3", sc=1, dl=0, f={
                {x=64.15, y=371.45, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_4", sc=1, dl=0, f={
                {x=64.15, y=341.45, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_5", sc=1, dl=0, f={
                {x=64.15, y=249.45, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_6", sc=1, dl=0, f={
                {x=64.15, y=213.45, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_7", sc=1, dl=0, f={
                {x=64.15, y=184.45, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_8", sc=1, dl=0, f={
                {x=64.15, y=151.45, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_9", sc=1, dl=0, f={
                {x=64.15, y=118.45, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_10", sc=1, dl=0, f={
                {x=64.15, y=85.44999999999999, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_11", sc=1, dl=0, f={
                {x=64.15, y=50.44999999999999, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="renderGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=655, y=-50, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 2", sc=1, dl=0, f={
                {x=672, y=-64.95, kx=0, ky=0, cx=0.96, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=753.85, y=-66.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleTF", sc=1, dl=0, f={
                {x=1069.05, y=-74.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn4", sc=1, dl=0, f={
                {x=1126, y=-519, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn3", sc=1, dl=0, f={
                {x=1126, y=-387, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn2", sc=1, dl=0, f={
                {x=1126, y=-257, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tabBtn1", sc=1, dl=0, f={
                {x=1126, y=-127, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
    {type="animation", name="shengxing_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=128.5, y=647.5, kx=0, ky=0, cx=0.9, cy=0.9, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg_1", sc=1, dl=0, f={
                {x=508, y=610, kx=0, ky=0, cx=7.34, cy=6.34, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg_1", sc=1, dl=0, f={
                {x=538, y=558, kx=0, ky=0, cx=14.32, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg_2", sc=1, dl=0, f={
                {x=538, y=500.9, kx=0, ky=0, cx=14.32, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg_3", sc=1, dl=0, f={
                {x=538, y=443.8, kx=0, ky=0, cx=14.32, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg_4", sc=1, dl=0, f={
                {x=538, y=386.7, kx=0, ky=0, cx=14.32, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_bg_5", sc=1, dl=0, f={
                {x=538, y=330, kx=0, ky=0, cx=14.32, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_2", sc=1, dl=0, f={
                {x=529, y=281.55, kx=0, ky=0, cx=93.33, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line_3", sc=1, dl=0, f={
                {x=529, y=172.20000000000005, kx=0, ky=0, cx=93.33, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow", sc=1, dl=0, f={
                {x=824, y=439, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow0", sc=1, dl=0, f={
                {x=824, y=496.5, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow1", sc=1, dl=0, f={
                {x=824, y=554, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow2", sc=1, dl=0, f={
                {x=824, y=382, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow3", sc=1, dl=0, f={
                {x=824, y=325, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=601.55, y=549.35, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=601.55, y=492.35, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=601.55, y=422.4, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=601.55, y=362.4, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=601.55, y=306.4, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1_1", sc=1, dl=0, f={
                {x=743.7, y=549.35, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2_1", sc=1, dl=0, f={
                {x=743.7, y=492.35, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3_1", sc=1, dl=0, f={
                {x=743.7, y=422.4, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_4_1", sc=1, dl=0, f={
                {x=743.7, y=360.4, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_5_1", sc=1, dl=0, f={
                {x=743.7, y=302.4, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1_2", sc=1, dl=0, f={
                {x=960.75, y=549.35, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2_2", sc=1, dl=0, f={
                {x=962.2, y=492.4, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3_2", sc=1, dl=0, f={
                {x=962.2, y=426.65, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_4_2", sc=1, dl=0, f={
                {x=962.2, y=366.65, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_5_2", sc=1, dl=0, f={
                {x=962.2, y=316.65, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb", sc=1, dl=0, f={
                {x=597.55, y=152.39999999999998, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver", sc=1, dl=0, f={
                {x=674.6, y=146.85000000000002, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cailiao_descb", sc=1, dl=0, f={
                {x=597.55, y=265.4, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_need_descb", sc=1, dl=0, f={
                {x=933.55, y=221.4, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_small_blue_button", sc=1, dl=0, f={
                {x=876.65, y=162.14999999999998, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1100.5, y=680, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengxing_title", sc=1, dl=0, f={
                {x=502.95, y=636.05, kx=0, ky=0, cx=1, cy=1, z=36, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_title", sc=1, dl=0, f={
                {x=502.95, y=636.05, kx=0, ky=0, cx=1, cy=1, z=37, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shipin_jinjie_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=0, y=660, kx=0, ky=0, cx=1.07, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti_bg", sc=1, dl=0, f={
                {x=17, y=645.05, kx=0, ky=0, cx=1.02, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=95.5, y=643.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_7", sc=1, dl=0, f={
                {x=22, y=587.05, kx=0, ky=0, cx=7.06, cy=4.14, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_bg", sc=1, dl=0, f={
                {x=39, y=579.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_1", sc=1, dl=0, f={
                {x=94, y=576.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_2", sc=1, dl=0, f={
                {x=323, y=576.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg", sc=1, dl=0, f={
                {x=26, y=294, kx=0, ky=0, cx=9.48, cy=4, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_title_bg", sc=1, dl=0, f={
                {x=28, y=290.55, kx=0, ky=0, cx=9.79, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei", sc=1, dl=0, f={
                {x=139.15, y=96.45000000000005, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei_descb", sc=1, dl=0, f={
                {x=206.45, y=128.04999999999995, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=167.5, y=84.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow", sc=1, dl=0, f={
                {x=214.5, y=551, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_1", sc=1, dl=0, f={
                {x=114.15, y=391.3, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_2", sc=1, dl=0, f={
                {x=114.15, y=333.3, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_3", sc=1, dl=0, f={
                {x=114.15, y=281.3, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_4", sc=1, dl=0, f={
                {x=114.15, y=235.3, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_5", sc=1, dl=0, f={
                {x=114.15, y=177.3, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_1", sc=1, dl=0, f={
                {x=166.15, y=391.3, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_2", sc=1, dl=0, f={
                {x=166.15, y=333.3, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_3", sc=1, dl=0, f={
                {x=166.15, y=281.3, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_4", sc=1, dl=0, f={
                {x=166.15, y=235.3, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_5", sc=1, dl=0, f={
                {x=166.15, y=177.3, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shipin_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=550, kx=0, ky=0, cx=111.25, cy=137.51, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=0, y=550, kx=0, ky=0, cx=5.43, cy=6.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg1", sc=1, dl=0, f={
                {x=20, y=520, kx=0, ky=0, cx=8.1, cy=3.81, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg2", sc=1, dl=0, f={
                {x=20, y=356, kx=0, ky=0, cx=8.1, cy=1.43, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg3", sc=1, dl=0, f={
                {x=20, y=252, kx=0, ky=0, cx=8.1, cy=3.81, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg4", sc=1, dl=0, f={
                {x=20, y=88, kx=0, ky=0, cx=8.1, cy=1.43, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid1", sc=1, dl=0, f={
                {x=32, y=509, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid2", sc=1, dl=0, f={
                {x=32, y=241, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name1", sc=1, dl=0, f={
                {x=55.55, y=390.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name2", sc=1, dl=0, f={
                {x=17.4, y=130.3, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_1", sc=1, dl=0, f={
                {x=164.15, y=494.3, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_2", sc=1, dl=0, f={
                {x=164.15, y=454.3, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_3", sc=1, dl=0, f={
                {x=164.15, y=422.3, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_4", sc=1, dl=0, f={
                {x=164.15, y=392.3, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_5", sc=1, dl=0, f={
                {x=164.15, y=362.3, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_1", sc=1, dl=0, f={
                {x=164.15, y=226.3, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_2", sc=1, dl=0, f={
                {x=164.15, y=186.3, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_3", sc=1, dl=0, f={
                {x=164.15, y=154.3, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_4", sc=1, dl=0, f={
                {x=164.15, y=124.3, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_5", sc=1, dl=0, f={
                {x=164.15, y=94.3, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2", sc=1, dl=0, f={
                {x=36, y=32.299999999999955, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1", sc=1, dl=0, f={
                {x=52.15, y=306.3, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn1", sc=1, dl=0, f={
                {x=311, y=359, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn2", sc=1, dl=0, f={
                {x=311, y=91, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_btn_1", sc=1, dl=0, f={
                {x=311, y=473.5, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="red_btn_2", sc=1, dl=0, f={
                {x=311, y=206, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="none_2_1", sc=1, dl=0, f={
                {x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="none_2_2", sc=1, dl=0, f={
                {x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="none_1_1", sc=1, dl=0, f={
                {x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="none_1_2", sc=1, dl=0, f={
                {x=328.5, y=369.55, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_1", sc=1, dl=0, f={
                {x=411, y=367, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_2", sc=1, dl=0, f={
                {x=411, y=99, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="name1", sc=1, dl=0, f={
                {x=55.55, y=390.65, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name2", sc=1, dl=0, f={
                {x=17.4, y=130.3, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="shipin_xilian_chenggong_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=422, y=586, kx=0, ky=0, cx=1.31, cy=0.68, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti_bg", sc=1, dl=0, f={
                {x=439, y=573.05, kx=0, ky=0, cx=1.29, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=580, y=571.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg", sc=1, dl=0, f={
                {x=446.5, y=508.95, kx=0, ky=0, cx=12.04, cy=6.43, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg2", sc=1, dl=0, f={
                {x=446.5, y=226.95, kx=0, ky=0, cx=12.04, cy=1.74, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_xilian", sc=1, dl=0, f={
                {x=892.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_xilian_quxiao", sc=1, dl=0, f={
                {x=750.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg0", sc=1, dl=0, f={
                {x=454.45, y=501.45, kx=0, ky=0, cx=2.56, cy=5.8, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_1", sc=1, dl=0, f={
                {x=574, y=499.45, kx=0, ky=0, cx=10.36, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_2", sc=1, dl=0, f={
                {x=574, y=448.2, kx=0, ky=0, cx=10.36, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_3", sc=1, dl=0, f={
                {x=574, y=396.95, kx=0, ky=0, cx=10.36, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_4", sc=1, dl=0, f={
                {x=574, y=345.7, kx=0, ky=0, cx=10.36, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_5", sc=1, dl=0, f={
                {x=574, y=294.45, kx=0, ky=0, cx=10.36, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_1", sc=1, dl=0, f={
                {x=602.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_2", sc=1, dl=0, f={
                {x=602.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_3", sc=1, dl=0, f={
                {x=602.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_4", sc=1, dl=0, f={
                {x=602.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_5", sc=1, dl=0, f={
                {x=602.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_1", sc=1, dl=0, f={
                {x=774.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_2", sc=1, dl=0, f={
                {x=774.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_3", sc=1, dl=0, f={
                {x=774.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_4", sc=1, dl=0, f={
                {x=774.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_5", sc=1, dl=0, f={
                {x=774.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_1", sc=1, dl=0, f={
                {x=774.15, y=495.45, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_2", sc=1, dl=0, f={
                {x=774.15, y=444.2, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_3", sc=1, dl=0, f={
                {x=774.15, y=392.95, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_4", sc=1, dl=0, f={
                {x=774.15, y=341.7, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow_5", sc=1, dl=0, f={
                {x=774.15, y=290.45, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid", sc=1, dl=0, f={
                {x=458.95, y=487.5, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="detail_btn", sc=1, dl=0, f={
                {x=458.95, y=314.1, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shipin_xilian_shuxing_layer", sc=1, dl=0, f={
                {x=107.4, y=586, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shipin_xilian_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=422, y=586, kx=0, ky=0, cx=1.31, cy=0.68, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti_bg", sc=1, dl=0, f={
                {x=439, y=573.05, kx=0, ky=0, cx=1.29, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=580, y=571.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg", sc=1, dl=0, f={
                {x=446.5, y=508.95, kx=0, ky=0, cx=12.04, cy=6.43, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg2", sc=1, dl=0, f={
                {x=446.5, y=226.95, kx=0, ky=0, cx=12.04, cy=1.74, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei_descb", sc=1, dl=0, f={
                {x=566.45, y=206.04999999999995, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei_gold_descb", sc=1, dl=0, f={
                {x=716, y=207, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_xilian", sc=1, dl=0, f={
                {x=892.95, y=217.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg0", sc=1, dl=0, f={
                {x=454.45, y=501.45, kx=0, ky=0, cx=2.56, cy=5.8, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_1", sc=1, dl=0, f={
                {x=574, y=499.45, kx=0, ky=0, cx=10.36, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_2", sc=1, dl=0, f={
                {x=574, y=448.2, kx=0, ky=0, cx=10.36, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_3", sc=1, dl=0, f={
                {x=574, y=396.95, kx=0, ky=0, cx=10.36, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_4", sc=1, dl=0, f={
                {x=574, y=345.7, kx=0, ky=0, cx=10.36, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shuxing_bg_5", sc=1, dl=0, f={
                {x=574, y=294.45, kx=0, ky=0, cx=10.36, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_1", sc=1, dl=0, f={
                {x=602.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_2", sc=1, dl=0, f={
                {x=602.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_3", sc=1, dl=0, f={
                {x=602.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_4", sc=1, dl=0, f={
                {x=602.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_1_5", sc=1, dl=0, f={
                {x=602.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_1", sc=1, dl=0, f={
                {x=654.15, y=466.3, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_2", sc=1, dl=0, f={
                {x=654.15, y=408.3, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_3", sc=1, dl=0, f={
                {x=654.15, y=356.3, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_4", sc=1, dl=0, f={
                {x=654.15, y=310.3, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb_2_5", sc=1, dl=0, f={
                {x=654.15, y=252.3, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=915, y=504.45, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid", sc=1, dl=0, f={
                {x=458.95, y=487.5, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="detail_btn", sc=1, dl=0, f={
                {x=458.95, y=314.1, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shipin_xilian_shuxing_layer", sc=1, dl=0, f={
                {x=107.4, y=586, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shipin_xilian_shuxing_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=68.75, cy=111.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=3.48, cy=5.63, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=6, y=-4, kx=0, ky=0, cx=5.84, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_1", sc=1, dl=0, f={
                {x=9, y=-57, kx=0, ky=0, cx=2.68, cy=1.06, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_2", sc=1, dl=0, f={
                {x=9, y=-95.2, kx=0, ky=0, cx=2.68, cy=1.06, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_3", sc=1, dl=0, f={
                {x=9, y=-133.4, kx=0, ky=0, cx=2.68, cy=1.06, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_4", sc=1, dl=0, f={
                {x=9, y=-171.6, kx=0, ky=0, cx=2.68, cy=1.06, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_5", sc=1, dl=0, f={
                {x=9, y=-209.8, kx=0, ky=0, cx=2.68, cy=1.06, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_6", sc=1, dl=0, f={
                {x=9, y=-248, kx=0, ky=0, cx=2.68, cy=1.06, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_7", sc=1, dl=0, f={
                {x=9, y=-286.2, kx=0, ky=0, cx=2.68, cy=1.06, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_8", sc=1, dl=0, f={
                {x=9, y=-324.4, kx=0, ky=0, cx=2.68, cy=1.06, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_9", sc=1, dl=0, f={
                {x=9, y=-362.6, kx=0, ky=0, cx=2.68, cy=1.06, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_10", sc=1, dl=0, f={
                {x=9, y=-401, kx=0, ky=0, cx=2.68, cy=1.06, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_1_shangxian", sc=1, dl=0, f={
                {x=9, y=-57, kx=0, ky=0, cx=2.68, cy=1.06, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_2_shangxian", sc=1, dl=0, f={
                {x=9, y=-95.2, kx=0, ky=0, cx=2.68, cy=1.06, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_3_shangxian", sc=1, dl=0, f={
                {x=9, y=-133.4, kx=0, ky=0, cx=2.68, cy=1.06, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_4_shangxian", sc=1, dl=0, f={
                {x=9, y=-171.6, kx=0, ky=0, cx=2.68, cy=1.06, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_5_shangxian", sc=1, dl=0, f={
                {x=9, y=-209.8, kx=0, ky=0, cx=2.68, cy=1.06, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_6_shangxian", sc=1, dl=0, f={
                {x=9, y=-248, kx=0, ky=0, cx=2.68, cy=1.06, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_7_shangxian", sc=1, dl=0, f={
                {x=9, y=-286.2, kx=0, ky=0, cx=2.68, cy=1.06, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_8_shangxian", sc=1, dl=0, f={
                {x=9, y=-324.4, kx=0, ky=0, cx=2.68, cy=1.06, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_9_shangxian", sc=1, dl=0, f={
                {x=9, y=-362.6, kx=0, ky=0, cx=2.68, cy=1.06, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item_bg_10_shangxian", sc=1, dl=0, f={
                {x=9, y=-401, kx=0, ky=0, cx=2.68, cy=1.06, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="skill_detail_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=500, kx=0, ky=0, cx=95, cy=125, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_background_1", sc=1, dl=0, f={
                {x=0, y=500, kx=0, ky=0, cx=4.81, cy=6.33, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_1", sc=1, dl=0, f={
                {x=14, y=356, kx=0, ky=0, cx=1.45, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_image_separator_2", sc=1, dl=0, f={
                {x=14, y=173, kx=0, ky=0, cx=1.45, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_name", sc=1, dl=0, f={
                {x=177.45, y=417.55, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level", sc=1, dl=0, f={
                {x=171.45, y=404.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_cd", sc=1, dl=0, f={
                {x=171.45, y=368.55, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_descb", sc=1, dl=0, f={
                {x=65.45, y=232.65, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_title_descb", sc=1, dl=0, f={
                {x=65.45, y=272.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level_need", sc=1, dl=0, f={
                {x=20, y=91.60000000000002, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silverl_need", sc=1, dl=0, f={
                {x=121.5, y=129.10000000000002, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_upgrade", sc=1, dl=0, f={
                {x=57.45, y=129.60000000000002, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_grid", sc=1, dl=0, f={
                {x=20, y=479, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_button", sc=1, dl=0, f={
                {x=124, y=70, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yimanji_img", sc=1, dl=0, f={
                {x=126, y=146.64999999999998, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="wuxing_detail_layer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_1", sc=1, dl=0, f={
                {x=0, y=170, kx=0, ky=0, cx=5.44, cy=2.15, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=20.15, y=122.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=20.15, y=160.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="xinxi_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580, kx=0, ky=0, cx=112.5, cy=145, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="equip_bg", sc=1, dl=0, f={
                {x=7, y=569, kx=0, ky=0, cx=5.35, cy=3.48, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="equip_bg_2", sc=1, dl=0, f={
                {x=7, y=273, kx=0, ky=0, cx=5.35, cy=3.12, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_1", sc=1, dl=0, f={
                {x=14, y=522, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_2", sc=1, dl=0, f={
                {x=14, y=465, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_3", sc=1, dl=0, f={
                {x=14, y=408, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_4", sc=1, dl=0, f={
                {x=226.5, y=522, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_5", sc=1, dl=0, f={
                {x=226.5, y=465, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_6", sc=1, dl=0, f={
                {x=226.5, y=408, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_7", sc=1, dl=0, f={
                {x=14, y=351, kx=0, ky=0, cx=2, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_1", sc=1, dl=0, f={
                {x=35.15, y=507.45, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_2", sc=1, dl=0, f={
                {x=33.15, y=452.4, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_3", sc=1, dl=0, f={
                {x=35.15, y=397.1, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_4", sc=1, dl=0, f={
                {x=249.15, y=507.45, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_5", sc=1, dl=0, f={
                {x=264.15, y=465, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_6", sc=1, dl=0, f={
                {x=243.15, y=400.05, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title_7", sc=1, dl=0, f={
                {x=29.15, y=397.1, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_1", sc=1, dl=0, f={
                {x=133.15, y=512.45, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_2", sc=1, dl=0, f={
                {x=133.15, y=459.4, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_3", sc=1, dl=0, f={
                {x=133.15, y=396.1, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_4", sc=1, dl=0, f={
                {x=352.15, y=514.45, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_5", sc=1, dl=0, f={
                {x=358.65, y=465, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb_6", sc=1, dl=0, f={
                {x=354.65, y=398.45, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=26.5, y=231, kx=0, ky=0, cx=66.67, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line1", sc=1, dl=0, f={
                {x=26.5, y=527, kx=0, ky=0, cx=66.67, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_btn", sc=1, dl=0, f={
                {x=173.5, y=519, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shengxing_btn", sc=1, dl=0, f={
                {x=318, y=356.15, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xiangxi_btn", sc=1, dl=0, f={
                {x=318.5, y=566.7, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_bg_1", sc=1, dl=0, f={
                {x=12, y=224.55, kx=0, ky=0, cx=3.12, cy=1.46, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_name_1", sc=1, dl=0, f={
                {x=94, y=207.6, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level_1", sc=1, dl=0, f={
                {x=94, y=183.6, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_1", sc=1, dl=0, f={
                {x=94, y=159.60000000000002, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_btn_1", sc=1, dl=0, f={
                {x=174.5, y=212.55, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_bg_1", sc=1, dl=0, f={
                {x=97.35, y=184.2, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_bg_2", sc=1, dl=0, f={
                {x=228, y=225, kx=0, ky=0, cx=3.12, cy=1.46, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_name_2", sc=1, dl=0, f={
                {x=310, y=208.05, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level_2", sc=1, dl=0, f={
                {x=310, y=184.05, kx=0, ky=0, cx=1, cy=1, z=36, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_2", sc=1, dl=0, f={
                {x=310, y=160.05, kx=0, ky=0, cx=1, cy=1, z=37, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_btn_2", sc=1, dl=0, f={
                {x=390.5, y=213, kx=0, ky=0, cx=1, cy=1, z=38, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_bg_2", sc=1, dl=0, f={
                {x=313.35, y=184.65, kx=0, ky=0, cx=1, cy=1, z=39, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_bg_3", sc=1, dl=0, f={
                {x=12, y=123, kx=0, ky=0, cx=3.12, cy=1.46, z=40, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_name_3", sc=1, dl=0, f={
                {x=94, y=106.05, kx=0, ky=0, cx=1, cy=1, z=41, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level_3", sc=1, dl=0, f={
                {x=94, y=82.05000000000001, kx=0, ky=0, cx=1, cy=1, z=42, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_3", sc=1, dl=0, f={
                {x=94, y=58.049999999999955, kx=0, ky=0, cx=1, cy=1, z=43, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_btn_3", sc=1, dl=0, f={
                {x=174.5, y=111, kx=0, ky=0, cx=1, cy=1, z=44, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_bg_3", sc=1, dl=0, f={
                {x=97.35, y=82.64999999999998, kx=0, ky=0, cx=1, cy=1, z=45, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_bg_4", sc=1, dl=0, f={
                {x=228, y=123, kx=0, ky=0, cx=3.12, cy=1.46, z=46, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_name_4", sc=1, dl=0, f={
                {x=301, y=106.05, kx=0, ky=0, cx=1, cy=1, z=47, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_level_4", sc=1, dl=0, f={
                {x=301, y=82.05000000000001, kx=0, ky=0, cx=1, cy=1, z=48, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_4", sc=1, dl=0, f={
                {x=310, y=58.049999999999955, kx=0, ky=0, cx=1, cy=1, z=49, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_btn_4", sc=1, dl=0, f={
                {x=390.5, y=111, kx=0, ky=0, cx=1, cy=1, z=50, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="skill_silver_bg_4", sc=1, dl=0, f={
                {x=322.35, y=82.64999999999998, kx=0, ky=0, cx=1, cy=1, z=51, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect1", sc=1, dl=0, f={
                {x=194, y=230.45, kx=0, ky=0, cx=1, cy=1, z=52, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect2", sc=1, dl=0, f={
                {x=410, y=230.45, kx=0, ky=0, cx=1, cy=1, z=53, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect3", sc=1, dl=0, f={
                {x=194, y=128.5, kx=0, ky=0, cx=1, cy=1, z=54, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect4", sc=1, dl=0, f={
                {x=410, y=128.5, kx=0, ky=0, cx=1, cy=1, z=55, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect5", sc=1, dl=0, f={
                {x=410, y=286.5, kx=0, ky=0, cx=1, cy=1, z=56, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect7", sc=1, dl=0, f={
                {x=203.5, y=530, kx=0, ky=0, cx=1, cy=1, z=57, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect8", sc=1, dl=0, f={
                {x=404.5, y=348.95, kx=0, ky=0, cx=1, cy=1, z=58, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="skill_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="skill_btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="skill_btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="skill_btn", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="yuanfen_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=0, y=417, kx=0, ky=0, cx=1.14, cy=0.63, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti_bg", sc=1, dl=0, f={
                {x=17, y=404.05, kx=0, ky=0, cx=1.12, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=115, y=402.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg", sc=1, dl=0, f={
                {x=22.5, y=345.95, kx=0, ky=0, cx=10.4, cy=4.4, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg2", sc=1, dl=0, f={
                {x=22.5, y=148.95, kx=0, ky=0, cx=10.4, cy=2.93, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_title_bg", sc=1, dl=0, f={
                {x=23.5, y=343.95, kx=0, ky=0, cx=10.75, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=393, y=130.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="descb", sc=1, dl=0, f={
                {x=56.15, y=123.35000000000002, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei_descb", sc=1, dl=0, f={
                {x=395.45, y=72.05000000000001, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="levelUpArrow", sc=1, dl=0, f={
                {x=206.25, y=343.95, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="zhuangbei_jinjie_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_background_5", sc=1, dl=0, f={
                {x=0, y=609, kx=0, ky=0, cx=1.06, cy=0.92, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti_bg", sc=1, dl=0, f={
                {x=17, y=594.05, kx=0, ky=0, cx=1.02, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="titleBg", sc=1, dl=0, f={
                {x=95.5, y=592.05, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_item_bg_7", sc=1, dl=0, f={
                {x=22, y=536.05, kx=0, ky=0, cx=7.06, cy=2.99, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jinjie_bg", sc=1, dl=0, f={
                {x=39, y=521.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_1", sc=1, dl=0, f={
                {x=94, y=510.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_2", sc=1, dl=0, f={
                {x=323, y=510.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_bg", sc=1, dl=0, f={
                {x=26, y=326, kx=0, ky=0, cx=9.48, cy=4, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhuangbei_cailiao_title_bg", sc=1, dl=0, f={
                {x=28, y=322.55, kx=0, ky=0, cx=9.79, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei", sc=1, dl=0, f={
                {x=139.15, y=118.45, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huafei_descb", sc=1, dl=0, f={
                {x=206.45, y=150.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=167.5, y=106.10000000000002, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tail_descb", sc=1, dl=0, f={
                {x=240.15, y=20.549999999999955, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="arrow", sc=1, dl=0, f={
                {x=214.5, y=478.1, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="zhuangbei_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=588.05, kx=0, ky=0, cx=112.5, cy=147.01, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_6", sc=1, dl=0, f={
                {x=0, y=588.05, kx=0, ky=0, cx=5.49, cy=6.33, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_1", sc=1, dl=0, f={
                {x=9, y=582.05, kx=0, ky=0, cx=6.35, cy=1.79, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_2", sc=1, dl=0, f={
                {x=9, y=454.44999999999993, kx=0, ky=0, cx=6.35, cy=1.79, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_3", sc=1, dl=0, f={
                {x=9, y=328.84999999999997, kx=0, ky=0, cx=6.35, cy=1.79, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background_4", sc=1, dl=0, f={
                {x=9, y=202.24999999999991, kx=0, ky=0, cx=6.35, cy=1.79, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_1", sc=1, dl=0, f={
                {x=411, y=582.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_2", sc=1, dl=0, f={
                {x=411, y=454.44999999999993, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_3", sc=1, dl=0, f={
                {x=411, y=328.84999999999997, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect_4", sc=1, dl=0, f={
                {x=411, y=202.24999999999991, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_1", sc=1, dl=0, f={
                {x=19.5, y=572.55, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_2", sc=1, dl=0, f={
                {x=19.5, y=444.94999999999993, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_3", sc=1, dl=0, f={
                {x=19.5, y=319.34999999999997, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grid_4", sc=1, dl=0, f={
                {x=19.5, y=192.74999999999991, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_1", sc=1, dl=0, f={
                {x=317, y=567.05, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_2", sc=1, dl=0, f={
                {x=317, y=439.44999999999993, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_3", sc=1, dl=0, f={
                {x=317, y=313.84999999999997, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn_4", sc=1, dl=0, f={
                {x=317, y=187.24999999999991, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb1", sc=1, dl=0, f={
                {x=150.15, y=554.3499999999999, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb2", sc=1, dl=0, f={
                {x=150.15, y=428.35, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb3", sc=1, dl=0, f={
                {x=150.15, y=295.4, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb4", sc=1, dl=0, f={
                {x=150.15, y=169.39999999999998, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb1", sc=1, dl=0, f={
                {x=150.15, y=515.3499999999999, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb2", sc=1, dl=0, f={
                {x=150.15, y=382.35, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb3", sc=1, dl=0, f={
                {x=150.15, y=262.4, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prop_descb4", sc=1, dl=0, f={
                {x=150.15, y=128.39999999999998, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb1", sc=1, dl=0, f={
                {x=317, y=510.0499999999999, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb2", sc=1, dl=0, f={
                {x=317, y=382.4, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb3", sc=1, dl=0, f={
                {x=323, y=256.74999999999994, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="silver_descb4", sc=1, dl=0, f={
                {x=317, y=130.09999999999997, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strength_all", sc=1, dl=0, f={
                {x=298, y=67.04999999999995, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="strength_all_descb", sc=1, dl=0, f={
                {x=159.5, y=56.049999999999955, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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