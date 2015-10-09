local conf = {type="skeleton", name="huodong_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="bangding_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="panel", x=277.95, y=570.05, kx=0, ky=0, cx=0.69, cy=0.67, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="logo", x=459.8, y=604.65, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="logo", isArmature=0}} },
           {type="b", name="touming_xia", x=434.35, y=370, kx=0, ky=0, cx=12, cy=3.93, z=3, d={{name="youxia_bg", isArmature=0}} },
           {type="b", name="phone2_txt", x=478, y=249.05, kx=0, ky=0, cx=1, cy=1, z=4, text={x=488,y=234, w=111, h=30,lineType="single line",size=26,color="710100",alignment="center",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="phone1_txt", x=478, y=324.05, kx=0, ky=0, cx=1, cy=1, z=5, text={x=480,y=307, w=111, h=30,lineType="single line",size=26,color="710100",alignment="center",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="input2_box", x=604.8, y=279.7, kx=0, ky=0, cx=4.74, cy=1, z=6, d={{name="inputbox", isArmature=0}} },
           {type="b", name="input1_box", x=604.8, y=353.7, kx=0, ky=0, cx=4.74, cy=1, z=7, d={{name="inputbox", isArmature=0}} },
           {type="b", name="input_txt2", x=633, y=267.65, kx=0, ky=0, cx=1, cy=1, z=8, text={x=629,y=229, w=322, h=45,lineType="single line",size=40,color="ffe8ce",alignment="left",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="input_txt1", x=633, y=341.65, kx=0, ky=0, cx=1, cy=1, z=9, text={x=629,y=301, w=322, h=45,lineType="single line",size=40,color="ffe8ce",alignment="left",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="redButton", x=669.95, y=198.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} },
           {type="b", name="touming_shang", x=453.5, y=519.65, kx=0, ky=0, cx=14.46, cy=3.21, z=11, d={{name="notTake_diban", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1015.8, y=609.15, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonButtons/common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="chongjiyouli_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=580.05, kx=0, ky=0, cx=220.49, cy=145, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=580.05, kx=0, ky=0, cx=10.76, cy=7.07, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="render1", x=15, y=560.05, kx=0, ky=0, cx=12.53, cy=1.71, z=2, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="render2", x=15, y=432.0499999999999, kx=0, ky=0, cx=12.53, cy=1.71, z=3, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} }
         }
      },
    {type="armature", name="chongzhifanhuan", 
      bones={           
           {type="b", name="hit_area", x=0, y=580.7, kx=0, ky=0, cx=220.5, cy=145.18, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=580.7, kx=0, ky=0, cx=10.72, cy=7.08, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="panel", x=13.8, y=565.85, kx=0, ky=0, cx=1, cy=1.15, z=2, d={{name="renderbg", isArmature=0}} },
           {type="b", name="txt_bg", x=34.5, y=547.35, kx=0, ky=0, cx=17.74, cy=4.03, z=3, d={{name="notTake_diban", isArmature=0}} },
           {type="b", name="first_phone", x=69.95, y=275.70000000000005, kx=0, ky=0, cx=1, cy=1, z=4, text={x=27,y=252, w=107, h=46,lineType="single line",size=30,color="ffe8ce",alignment="center",space=0,textType="input"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="second_phone", x=99.95, y=237.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, text={x=32,y=181, w=126, h=44,lineType="single line",size=30,color="ffe8ce",alignment="center",space=0,textType="input"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="putbox1", x=168.85, y=239.35, kx=0, ky=0, cx=5.32, cy=1, z=6, d={{name="inputbox", isArmature=0}} },
           {type="b", name="putbox2", x=169.85, y=314.35, kx=0, ky=0, cx=5.32, cy=1, z=7, d={{name="inputbox", isArmature=0}} },
           {type="b", name="input1", x=171, y=279.70000000000005, kx=0, ky=0, cx=1, cy=1, z=8, text={x=194,y=254, w=365, h=57,lineType="single line",size=40,color="ffe8ce",alignment="left",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="input2", x=171, y=216.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, text={x=196,y=180, w=365, h=57,lineType="single line",size=40,color="ffe8ce",alignment="left",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} }
         }
      },
    {type="armature", name="chongzhifanhuanAD_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=580.05, kx=0, ky=0, cx=220.49, cy=145, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=580.05, kx=0, ky=0, cx=10.76, cy=7.07, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="bg2", x=21.35, y=358.79999999999995, kx=0, ky=0, cx=10.1, cy=4.24, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="fengexian1", x=40, y=309.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=3, d={{name="fengexian", isArmature=0}} },
           {type="b", name="fengexian2", x=40, y=259.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=4, d={{name="fengexian", isArmature=0}} },
           {type="b", name="fengexian3", x=40, y=209.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=5, d={{name="fengexian", isArmature=0}} },
           {type="b", name="fengexian4", x=40, y=159.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=6, d={{name="fengexian", isArmature=0}} },
           {type="b", name="fengexian5", x=40, y=109.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=7, d={{name="fengexian", isArmature=0}} },
           {type="b", name="fengexian6", x=40, y=59.049999999999955, kx=0, ky=0, cx=33.12, cy=1, z=8, d={{name="fengexian", isArmature=0}} },
           {type="b", name="text1", x=40, y=305.04999999999995, kx=0, ky=0, cx=1, cy=1, z=9, text={x=40,y=304, w=101, h=36,lineType="single line",size=24,color="e3d3ba",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text2", x=40, y=281.34999999999997, kx=0, ky=0, cx=1, cy=1, z=10, text={x=40,y=260, w=568, h=36,lineType="single line",size=24,color="e3d3ba",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text3", x=40, y=233.34999999999997, kx=0, ky=0, cx=1, cy=1, z=11, text={x=40,y=212, w=307, h=36,lineType="single line",size=24,color="e3d3ba",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text4", x=40, y=161.34999999999997, kx=0, ky=0, cx=1, cy=1, z=12, text={x=40,y=161, w=470, h=36,lineType="single line",size=24,color="e3d3ba",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text5", x=40, y=127.49999999999994, kx=0, ky=0, cx=1, cy=1, z=13, text={x=40,y=109, w=173, h=36,lineType="single line",size=24,color="e3d3ba",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text6", x=40, y=81.24999999999994, kx=0, ky=0, cx=1, cy=1, z=14, text={x=40,y=61, w=264, h=36,lineType="single line",size=24,color="e3d3ba",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text7", x=40, y=27.84999999999991, kx=0, ky=0, cx=1, cy=1, z=15, text={x=40,y=9, w=120, h=36,lineType="single line",size=24,color="e3d3ba",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text8", x=343.85, y=29.299999999999955, kx=0, ky=0, cx=1, cy=1, z=16, text={x=163,y=9, w=131, h=36,lineType="single line",size=24,color="ffde03",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ad", x=19, y=561.05, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="chongzhifanhuanad", isArmature=0}} }
         }
      },
    {type="armature", name="fundItem_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=120, kx=0, ky=0, cx=213, cy=30, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="meihua", x=585.75, y=108, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="meihua", isArmature=0}} },
           {type="b", name="text1", x=227.95, y=60, kx=0, ky=0, cx=1, cy=1, z=3, text={x=43,y=41, w=371, h=36,lineType="single line",size=24,color="480202",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text2", x=629.8, y=95.95, kx=0, ky=0, cx=1, cy=1, z=4, text={x=499,y=76, w=244, h=34,lineType="single line",size=22,color="480202",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=414, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="award1", x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="award1", isArmature=0}} },
           {type="b", name="btn", x=702.55, y=87.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="GeneralWelfare", 
      bones={           
           {type="b", name="hit_area", x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="fengexian", x=9.5, y=526.45, kx=0, ky=0, cx=23.32, cy=1, z=1, d={{name="bg_frame", isArmature=0}} },
           {type="b", name="bg", x=13.5, y=522.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="GeneralWelfarebg", isArmature=0}} },
           {type="b", name="renwu", x=637.9, y=653.95, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="renwu", isArmature=0}} },
           {type="b", name="laohuji", x=21.45, y=519.2, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="laohuji", isArmature=0}} },
           {type="b", name="ad1", x=278.1, y=488.55, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="quanmingad1", isArmature=0}} },
           {type="b", name="ad2", x=278.1, y=433.45, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="quanmingad2", isArmature=0}} },
           {type="b", name="num1", x=42.2, y=464.45, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="num_1", isArmature=0}} },
           {type="b", name="num2", x=104.15, y=464.45, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="num_7", isArmature=0}} },
           {type="b", name="num3", x=166.15, y=464.45, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="num_2", isArmature=0}} },
           {type="b", name="num4", x=224.1, y=464.45, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="num_3", isArmature=0}} }
         }
      },
    {type="armature", name="getReward_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_line_down1", x=0, y=240, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_copy_line_down", isArmature=0}} },
           {type="b", name="common_copy_line_down2", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_line_down", isArmature=0}} }
         }
      },
    {type="armature", name="growthFoudContainer", 
      bones={           
           {type="b", name="hit_area", x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="kaifu_btn", x=19.95, y=578.1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="jijin_btn", isArmature=1}} },
           {type="b", name="reddot1", x=149.95, y=588.1, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="kaifujijin", x=33.9, y=565.1, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="kaifujiji", isArmature=0}} },
           {type="b", name="quanming_btn", x=174.35, y=578.1, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="jijin_btn", isArmature=1}} },
           {type="b", name="quanmingfuli", x=189.85, y=565.1, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="quanmingfuli", isArmature=0}} },
           {type="b", name="reddot2", x=304.35, y=588.1, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="growthFoudContainer1", 
      bones={           
           {type="b", name="hit_area", x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="kaifu_btn", x=18.35, y=580.1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="jijin_btn1", isArmature=1}} },
           {type="b", name="quanming_btn", x=169.9, y=579.15, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="jijin_btn1", isArmature=1}} }
         }
      },
    {type="armature", name="huodong_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=716, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=71.1, y=682.95, kx=0, ky=0, cx=1.01, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1157.7, y=705.55, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_close_button", isArmature=1}} },
           {type="b", name="rightbg", x=296.15, y=644.2, kx=0, ky=0, cx=10.76, cy=7.07, z=3, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="leftbg", x=111.25, y=644, kx=0, ky=0, cx=2.09, cy=7.07, z=4, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="leftrender1", x=116.95, y=642.85, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="leftrender", isArmature=1}} },
           {type="b", name="leftrender2", x=116.95, y=479.95, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="leftrender", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="huodongComItem", 
      bones={           
           {type="b", name="hit_area", x=0, y=120, kx=0, ky=0, cx=212.99, cy=30, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderbg", x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="meihua", x=610.9, y=108, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="meihua", isArmature=0}} },
           {type="b", name="text1", x=189, y=60, kx=0, ky=0, cx=1, cy=1, z=3, text={x=39,y=41, w=274, h=36,lineType="single line",size=24,color="480202",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=295.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=420.25, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item3", x=545.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=6, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="text2", x=770.1, y=95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=707,y=77, w=128, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="award1", x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="award1", isArmature=0}} },
           {type="b", name="btn", x=704.1, y=74.5, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="jijin_btn", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="choseButton", isArmature=0},{name="unchoseButton", isArmature=0}} }
         }
      },
    {type="armature", name="jijin_btn1", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="choseButton", isArmature=0},{name="unchoseButton", isArmature=0}} }
         }
      },
    {type="armature", name="KaifuFund", 
      bones={           
           {type="b", name="hit_area", x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="fengexian", x=9.5, y=526.45, kx=0, ky=0, cx=23.32, cy=1, z=1, d={{name="bg_frame", isArmature=0}} },
           {type="b", name="ad", x=13.5, y=522.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="ad", isArmature=0}} },
           {type="b", name="renwu", x=637.9, y=653.95, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="renwu", isArmature=0}} },
           {type="b", name="buybutton", x=514.7, y=432.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonButtons/common_copy_small_red_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_red_button", 
      bones={           
           {type="b", name="common_small_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=12,y=-44, w=105, h=36,lineType="single line",size=24,color="ffdd69",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_red_button_normal", isArmature=0},{name="commonButtons/common_copy_small_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="KaifuGift", 
      bones={           
           {type="b", name="hit_area", x=0, y=622, kx=0, ky=0, cx=220.5, cy=155.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="ad_bg", x=9.5, y=570.2, kx=0, ky=0, cx=23.32, cy=1.16, z=1, d={{name="bg_frame", isArmature=0}} },
           {type="b", name="ad", x=16.5, y=618, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="songliad", isArmature=0}} }
         }
      },
    {type="armature", name="leftrender", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=40.5, cy=40.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="frame", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="frame", isArmature=0}} },
           {type="b", name="reddot", x=15, y=-14, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="libaoduihuan_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=580.5, kx=0, ky=0, cx=219.78, cy=145.12, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bg", x=0, y=580.5, kx=0, ky=0, cx=10.72, cy=7.08, z=1, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="word", x=136.95, y=566.55, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="guanggaoword", isArmature=0}} },
           {type="b", name="libaoma", x=26.5, y=282.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="libaoma", isArmature=0}} },
           {type="b", name="inputbox", x=224.45, y=282.05, kx=0, ky=0, cx=5.32, cy=1, z=4, d={{name="inputbox", isArmature=0}} },
           {type="b", name="input", x=237.95, y=253.75, kx=0, ky=0, cx=1, cy=1, z=5, text={x=238,y=224, w=379, h=68,lineType="single line",size=48,color="430606",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="botton", x=305.45, y=161.10000000000002, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=20,y=-53, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="numbers", 
      bones={           
           {type="b", name="num_9", x=396, y=61, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="num_9", isArmature=0}} },
           {type="b", name="num_8", x=352, y=61, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="num_8", isArmature=0}} },
           {type="b", name="num_7", x=308, y=61, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="num_7", isArmature=0}} },
           {type="b", name="num_6", x=262, y=61, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="num_6", isArmature=0}} },
           {type="b", name="num_5", x=220, y=61, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="num_5", isArmature=0}} },
           {type="b", name="num_4", x=176, y=61, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="num_4", isArmature=0}} },
           {type="b", name="num_3", x=132, y=61, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="num_3", isArmature=0}} },
           {type="b", name="num_2", x=88, y=61, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="num_2", isArmature=0}} },
           {type="b", name="num_1", x=44, y=61, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="num_1", isArmature=0}} },
           {type="b", name="num_0", x=0, y=61, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="num_0", isArmature=0}} }
         }
      },
    {type="armature", name="qitianqiandao_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=580.7, kx=0, ky=0, cx=220.5, cy=145.18, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="item1", x=-69.55, y=408.1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="qiandao_item", isArmature=1}} },
           {type="b", name="item2", x=147.4, y=408.1, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="qiandao_item", isArmature=1}} },
           {type="b", name="item3", x=-69.55, y=125.15000000000003, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="qiandao_item", isArmature=1}} }
         }
      },
    {type="armature", name="qiandao_item", 
      bones={           
           {type="b", name="hit_area", x=85.95, y=158, kx=0, ky=0, cx=50.25, cy=66.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="panel_bg_not", x=84.85, y=159.15, kx=0, ky=0, cx=2.97, cy=3.81, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="panel_bg", x=84.85, y=159.15, kx=0, ky=0, cx=2.27, cy=2.93, z=2, d={{name="get_bg", isArmature=0}} },
           {type="b", name="diban_bg_not", x=96.5, y=101.65, kx=0, ky=0, cx=4.62, cy=5.21, z=3, d={{name="notTake_diban", isArmature=0}} },
           {type="b", name="diban_bg", x=96.5, y=101.65, kx=0, ky=0, cx=4.62, cy=5.21, z=4, d={{name="take_bg", isArmature=0}} },
           {type="b", name="huawen_bg", x=112.35, y=77.65, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="背景花纹", isArmature=0}} },
           {type="b", name="number_bg", x=115.85, y=-56.85, kx=0, ky=0, cx=3.89, cy=1.03, z=6, d={{name="shuzi", isArmature=0}} },
           {type="b", name="tianshu_txt", x=112.95, y=126, kx=0, ky=0, cx=1, cy=1, z=7, text={x=144,y=100, w=106, h=47,lineType="single line",size=32,color="710100",alignment="left",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="name_txt", x=108.95, y=76, kx=0, ky=0, cx=1, cy=1, z=8, text={x=121,y=62, w=131, h=36,lineType="single line",size=24,color="ffdec7",alignment="center",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="fenshu_txt", x=112.95, y=126, kx=0, ky=0, cx=1, cy=1, z=9, text={x=118,y=-98, w=134, h=44,lineType="single line",size=30,color="ffdd69",alignment="center",space=0,textType="static"}, d={{name="txt_null", isArmature=0}} },
           {type="b", name="gold_image", x=154.35, y=25.15, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="haveTaken", x=189, y=11, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="haveTaken", isArmature=0}} }
         }
      },
    {type="armature", name="render", 
      bones={           
           {type="b", name="hit_area", x=0, y=120, kx=0, ky=0, cx=213, cy=30, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderbg", x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="target", x=31.3, y=60, kx=0, ky=0, cx=1, cy=1, z=2, text={x=37,y=41, w=217, h=36,lineType="single line",size=24,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=264.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=3, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=392.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item3", x=517.5, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="award1", x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="award1", isArmature=0}} },
           {type="b", name="btn", x=702.55, y=87.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="render1", 
      bones={           
           {type="b", name="hit_area", x=0, y=120, kx=0, ky=0, cx=212.99, cy=30, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderbg", x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="meihua", x=610.9, y=108, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="meihua", isArmature=0}} },
           {type="b", name="target", x=189, y=60, kx=0, ky=0, cx=1, cy=1, z=3, text={x=39,y=41, w=274, h=36,lineType="single line",size=24,color="480202",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=295.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=420.25, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item3", x=545.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=6, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="text", x=770.1, y=95, kx=0, ky=0, cx=1, cy=1, z=7, text={x=707,y=77, w=128, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="gotocharge", x=704.1, y=74.5, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_small_blue_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_blue_button", 
      bones={           
           {type="b", name="common_small_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=16,y=-45, w=101, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_small_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="Vipwelfare_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=580, kx=0, ky=0, cx=220.49, cy=145, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="render", x=15, y=470, kx=0, ky=0, cx=12.53, cy=1.71, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="bg", x=0, y=580, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="vipbg1", isArmature=0}} },
           {type="b", name="progressBarbg", x=66.5, y=553, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/l_ttl_bg", isArmature=0}} },
           {type="b", name="vipbg", x=22, y=560, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="vipbg", isArmature=0}} },
           {type="b", name="vip", x=38.3, y=541.95, kx=0, ky=0, cx=0.79, cy=0.79, z=5, d={{name="commonNumbers/common_copy_mainui_vip_normal", isArmature=0}} },
           {type="b", name="vipNum1", x=108.25, y=542.25, kx=0, ky=0, cx=0.77, cy=0.77, z=6, d={{name="commonNumbers/common_copy_vip1", isArmature=0}} },
           {type="b", name="vipNum2", x=122.95, y=542.25, kx=0, ky=0, cx=0.77, cy=0.77, z=7, d={{name="commonNumbers/common_copy_vip1", isArmature=0}} },
           {type="b", name="gold", x=625.7, y=551.3, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="text1", x=457.8, y=510.3, kx=0, ky=0, cx=1, cy=1, z=9, text={x=458,y=510, w=77, h=36,lineType="single line",size=24,color="ede4d4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text10", x=493.8, y=528.3, kx=0, ky=0, cx=1, cy=1, z=10, text={x=494,y=528, w=353, h=36,lineType="single line",size=24,color="ede4d4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text2", x=544, y=510.3, kx=0, ky=0, cx=1, cy=1, z=11, text={x=533,y=510, w=89, h=36,lineType="single line",size=24,color="ffd200",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text3", x=660.1, y=510.3, kx=0, ky=0, cx=1, cy=1, z=12, text={x=693,y=510, w=101, h=36,lineType="single line",size=24,color="ede4d4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text4", x=779.9, y=504.15, kx=0, ky=0, cx=1, cy=1, z=13, text={x=791,y=510, w=71, h=36,lineType="single line",size=24,color="ffd200",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text5", x=507.9, y=486.4, kx=0, ky=0, cx=1, cy=1, z=14, text={x=458,y=486, w=13, h=36,lineType="single line",size=24,color="ede4d4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text6", x=444.5, y=504.25, kx=0, ky=0, cx=1, cy=1, z=15, text={x=466,y=486, w=71, h=36,lineType="single line",size=24,color="ffd200",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text7", x=645.8, y=486.4, kx=0, ky=0, cx=1, cy=1, z=16, text={x=542,y=486, w=101, h=36,lineType="single line",size=24,color="ede4d4",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text8", x=629.8, y=504.25, kx=0, ky=0, cx=1, cy=1, z=17, text={x=650,y=486, w=125, h=36,lineType="single line",size=24,color="ff03f6",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text9", x=764, y=504.3, kx=0, ky=0, cx=1, cy=1, z=18, text={x=782,y=486, w=13, h=36,lineType="single line",size=24,color="ede4d4",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="progressBar", x=172, y=543.5, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonProgressBars/common_progress_bar", isArmature=1}} }
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
    {type="animation", name="bangding_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel", sc=1, dl=0, f={
                {x=277.95, y=570.05, kx=0, ky=0, cx=0.69, cy=0.67, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="logo", sc=1, dl=0, f={
                {x=459.8, y=604.65, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="touming_xia", sc=1, dl=0, f={
                {x=434.35, y=370, kx=0, ky=0, cx=12, cy=3.93, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="phone2_txt", sc=1, dl=0, f={
                {x=478, y=249.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="phone1_txt", sc=1, dl=0, f={
                {x=478, y=324.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input2_box", sc=1, dl=0, f={
                {x=604.8, y=279.7, kx=0, ky=0, cx=4.74, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input1_box", sc=1, dl=0, f={
                {x=604.8, y=353.7, kx=0, ky=0, cx=4.74, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_txt2", sc=1, dl=0, f={
                {x=633, y=267.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input_txt1", sc=1, dl=0, f={
                {x=633, y=341.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="redButton", sc=1, dl=0, f={
                {x=669.95, y=198.20000000000005, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="touming_shang", sc=1, dl=0, f={
                {x=453.5, y=519.65, kx=0, ky=0, cx=14.46, cy=3.21, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1015.8, y=609.15, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chongjiyouli_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580.05, kx=0, ky=0, cx=220.49, cy=145, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=580.05, kx=0, ky=0, cx=10.76, cy=7.07, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render1", sc=1, dl=0, f={
                {x=15, y=560.05, kx=0, ky=0, cx=12.53, cy=1.71, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render2", sc=1, dl=0, f={
                {x=15, y=432.0499999999999, kx=0, ky=0, cx=12.53, cy=1.71, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chongzhifanhuan", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580.7, kx=0, ky=0, cx=220.5, cy=145.18, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=580.7, kx=0, ky=0, cx=10.72, cy=7.08, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel", sc=1, dl=0, f={
                {x=13.8, y=565.85, kx=0, ky=0, cx=1, cy=1.15, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="txt_bg", sc=1, dl=0, f={
                {x=34.5, y=547.35, kx=0, ky=0, cx=17.74, cy=4.03, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="first_phone", sc=1, dl=0, f={
                {x=69.95, y=275.70000000000005, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="second_phone", sc=1, dl=0, f={
                {x=99.95, y=237.70000000000005, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="putbox1", sc=1, dl=0, f={
                {x=168.85, y=239.35, kx=0, ky=0, cx=5.32, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="putbox2", sc=1, dl=0, f={
                {x=169.85, y=314.35, kx=0, ky=0, cx=5.32, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input1", sc=1, dl=0, f={
                {x=171, y=279.70000000000005, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input2", sc=1, dl=0, f={
                {x=171, y=216.70000000000005, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="chongzhifanhuanAD_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580.05, kx=0, ky=0, cx=220.49, cy=145, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=580.05, kx=0, ky=0, cx=10.76, cy=7.07, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg2", sc=1, dl=0, f={
                {x=21.35, y=358.79999999999995, kx=0, ky=0, cx=10.1, cy=4.24, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian1", sc=1, dl=0, f={
                {x=40, y=309.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian2", sc=1, dl=0, f={
                {x=40, y=259.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian3", sc=1, dl=0, f={
                {x=40, y=209.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian4", sc=1, dl=0, f={
                {x=40, y=159.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian5", sc=1, dl=0, f={
                {x=40, y=109.04999999999995, kx=0, ky=0, cx=33.12, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian6", sc=1, dl=0, f={
                {x=40, y=59.049999999999955, kx=0, ky=0, cx=33.12, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=40, y=305.04999999999995, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=40, y=281.34999999999997, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text3", sc=1, dl=0, f={
                {x=40, y=233.34999999999997, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text4", sc=1, dl=0, f={
                {x=40, y=161.34999999999997, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text5", sc=1, dl=0, f={
                {x=40, y=127.49999999999994, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text6", sc=1, dl=0, f={
                {x=40, y=81.24999999999994, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text7", sc=1, dl=0, f={
                {x=40, y=27.84999999999991, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text8", sc=1, dl=0, f={
                {x=343.85, y=29.299999999999955, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad", sc=1, dl=0, f={
                {x=19, y=561.05, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="fundItem_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=213, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meihua", sc=1, dl=0, f={
                {x=585.75, y=108, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=227.95, y=60, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=629.8, y=95.95, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=414, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award1", sc=1, dl=0, f={
                {x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=702.55, y=87.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="GeneralWelfare", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian", sc=1, dl=0, f={
                {x=9.5, y=526.45, kx=0, ky=0, cx=23.32, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=13.5, y=522.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renwu", sc=1, dl=0, f={
                {x=637.9, y=653.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="laohuji", sc=1, dl=0, f={
                {x=21.45, y=519.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad1", sc=1, dl=0, f={
                {x=278.1, y=488.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad2", sc=1, dl=0, f={
                {x=278.1, y=433.45, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num1", sc=1, dl=0, f={
                {x=42.2, y=464.45, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num2", sc=1, dl=0, f={
                {x=104.15, y=464.45, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num3", sc=1, dl=0, f={
                {x=166.15, y=464.45, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num4", sc=1, dl=0, f={
                {x=224.1, y=464.45, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="getReward_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_down1", sc=1, dl=0, f={
                {x=0, y=240, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_down2", sc=1, dl=0, f={
                {x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="growthFoudContainer", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kaifu_btn", sc=1, dl=0, f={
                {x=19.95, y=578.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot1", sc=1, dl=0, f={
                {x=149.95, y=588.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kaifujijin", sc=1, dl=0, f={
                {x=33.9, y=565.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="quanming_btn", sc=1, dl=0, f={
                {x=174.35, y=578.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="quanmingfuli", sc=1, dl=0, f={
                {x=189.85, y=565.1, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot2", sc=1, dl=0, f={
                {x=304.35, y=588.1, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="growthFoudContainer1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kaifu_btn", sc=1, dl=0, f={
                {x=18.35, y=580.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="quanming_btn", sc=1, dl=0, f={
                {x=169.9, y=579.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huodong_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=716, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=71.1, y=682.95, kx=0, ky=0, cx=1.01, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1157.7, y=705.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rightbg", sc=1, dl=0, f={
                {x=296.15, y=644.2, kx=0, ky=0, cx=10.76, cy=7.07, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftbg", sc=1, dl=0, f={
                {x=111.25, y=644, kx=0, ky=0, cx=2.09, cy=7.07, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftrender1", sc=1, dl=0, f={
                {x=116.95, y=642.85, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftrender2", sc=1, dl=0, f={
                {x=116.95, y=479.95, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f10", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_close_button", 
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
    {type="animation", name="huodongComItem", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=212.99, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderbg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meihua", sc=1, dl=0, f={
                {x=610.9, y=108, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=189, y=60, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=295.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=420.25, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=545.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=770.1, y=95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award1", sc=1, dl=0, f={
                {x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=704.1, y=74.5, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="jijin_btn", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="jijin_btn1", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 1", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="KaifuFund", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=660, kx=0, ky=0, cx=220.5, cy=165, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fengexian", sc=1, dl=0, f={
                {x=9.5, y=526.45, kx=0, ky=0, cx=23.32, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad", sc=1, dl=0, f={
                {x=13.5, y=522.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renwu", sc=1, dl=0, f={
                {x=637.9, y=653.95, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buybutton", sc=1, dl=0, f={
                {x=514.7, y=432.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="KaifuGift", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=622, kx=0, ky=0, cx=220.5, cy=155.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad_bg", sc=1, dl=0, f={
                {x=9.5, y=570.2, kx=0, ky=0, cx=23.32, cy=1.16, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ad", sc=1, dl=0, f={
                {x=16.5, y=618, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="leftrender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=40.5, cy=40.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="frame", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot", sc=1, dl=0, f={
                {x=15, y=-14, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="libaoduihuan_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580.5, kx=0, ky=0, cx=219.78, cy=145.12, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=580.5, kx=0, ky=0, cx=10.72, cy=7.08, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="word", sc=1, dl=0, f={
                {x=136.95, y=566.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="libaoma", sc=1, dl=0, f={
                {x=26.5, y=282.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="inputbox", sc=1, dl=0, f={
                {x=224.45, y=282.05, kx=0, ky=0, cx=5.32, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="input", sc=1, dl=0, f={
                {x=237.95, y=253.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="botton", sc=1, dl=0, f={
                {x=305.45, y=161.10000000000002, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="numbers", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="num_9", sc=1, dl=0, f={
                {x=396, y=61, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_8", sc=1, dl=0, f={
                {x=352, y=61, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_7", sc=1, dl=0, f={
                {x=308, y=61, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_6", sc=1, dl=0, f={
                {x=262, y=61, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_5", sc=1, dl=0, f={
                {x=220, y=61, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_4", sc=1, dl=0, f={
                {x=176, y=61, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_3", sc=1, dl=0, f={
                {x=132, y=61, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_2", sc=1, dl=0, f={
                {x=88, y=61, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_1", sc=1, dl=0, f={
                {x=44, y=61, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num_0", sc=1, dl=0, f={
                {x=0, y=61, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="qitianqiandao_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580.7, kx=0, ky=0, cx=220.5, cy=145.18, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=-69.55, y=408.1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=147.4, y=408.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=-69.55, y=125.15000000000003, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="qiandao_item", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=85.95, y=158, kx=0, ky=0, cx=50.25, cy=66.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel_bg_not", sc=1, dl=0, f={
                {x=84.85, y=159.15, kx=0, ky=0, cx=2.97, cy=3.81, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="panel_bg", sc=1, dl=0, f={
                {x=84.85, y=159.15, kx=0, ky=0, cx=2.27, cy=2.93, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="diban_bg_not", sc=1, dl=0, f={
                {x=96.5, y=101.65, kx=0, ky=0, cx=4.62, cy=5.21, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="diban_bg", sc=1, dl=0, f={
                {x=96.5, y=101.65, kx=0, ky=0, cx=4.62, cy=5.21, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huawen_bg", sc=1, dl=0, f={
                {x=112.35, y=77.65, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="number_bg", sc=1, dl=0, f={
                {x=115.85, y=-56.85, kx=0, ky=0, cx=3.89, cy=1.03, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tianshu_txt", sc=1, dl=0, f={
                {x=112.95, y=126, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_txt", sc=1, dl=0, f={
                {x=108.95, y=76, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fenshu_txt", sc=1, dl=0, f={
                {x=112.95, y=126, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold_image", sc=1, dl=0, f={
                {x=154.35, y=25.15, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="haveTaken", sc=1, dl=0, f={
                {x=189, y=11, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=213, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderbg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target", sc=1, dl=0, f={
                {x=31.3, y=60, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=264.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=392.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=517.5, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award1", sc=1, dl=0, f={
                {x=704.05, y=108, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=702.55, y=87.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="render1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=212.99, cy=30, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderbg", sc=1, dl=0, f={
                {x=0, y=120, kx=0, ky=0, cx=12.53, cy=1.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meihua", sc=1, dl=0, f={
                {x=610.9, y=108, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target", sc=1, dl=0, f={
                {x=189, y=60, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=295.15, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=420.25, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=545.35, y=108, kx=0, ky=0, cx=0.91, cy=0.91, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text", sc=1, dl=0, f={
                {x=770.1, y=95, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gotocharge", sc=1, dl=0, f={
                {x=704.1, y=74.5, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="Vipwelfare_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=580, kx=0, ky=0, cx=220.49, cy=145, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render", sc=1, dl=0, f={
                {x=15, y=470, kx=0, ky=0, cx=12.53, cy=1.71, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=0, y=580, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progressBarbg", sc=1, dl=0, f={
                {x=66.5, y=553, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipbg", sc=1, dl=0, f={
                {x=22, y=560, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vip", sc=1, dl=0, f={
                {x=38.3, y=541.95, kx=0, ky=0, cx=0.79, cy=0.79, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipNum1", sc=1, dl=0, f={
                {x=108.25, y=542.25, kx=0, ky=0, cx=0.77, cy=0.77, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="vipNum2", sc=1, dl=0, f={
                {x=122.95, y=542.25, kx=0, ky=0, cx=0.77, cy=0.77, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold", sc=1, dl=0, f={
                {x=625.7, y=551.3, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=457.8, y=510.3, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text10", sc=1, dl=0, f={
                {x=493.8, y=528.3, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=544, y=510.3, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text3", sc=1, dl=0, f={
                {x=660.1, y=510.3, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text4", sc=1, dl=0, f={
                {x=779.9, y=504.15, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text5", sc=1, dl=0, f={
                {x=507.9, y=486.4, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text6", sc=1, dl=0, f={
                {x=444.5, y=504.25, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text7", sc=1, dl=0, f={
                {x=645.8, y=486.4, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text8", sc=1, dl=0, f={
                {x=629.8, y=504.25, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text9", sc=1, dl=0, f={
                {x=764, y=504.3, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progressBar", sc=1, dl=0, f={
                {x=172, y=543.5, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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