local conf = {type="skeleton", name="meeting_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="choose_proposal_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_1", x=167.95, y=527, kx=0, ky=0, cx=12.16, cy=5.52, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="personImgTmp", x=166, y=99.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_biaoti", x=584.8, y=508.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_biaoti", isArmature=0}} },
           {type="b", name="ttlNameTF", x=685.75, y=504.25, kx=0, ky=0, cx=1, cy=1, z=4, text={x=700,y=464, w=182, h=40,lineType="multiline",size=27,color="fafafa",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="proposal_1", x=443.35, y=450, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="proposal_render", isArmature=1}} },
           {type="b", name="proposal_2", x=443.35, y=280.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="proposal_render", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1083.05, y=558, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonButtons/common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_copy_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_return_button", 
      bones={           
           {type="b", name="common_return_button", x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_return_button_normal", isArmature=0},{name="commonButtons/common_copy_return_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="harmonious_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="personImgTmp", x=1280, y=1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="dlgBg", x=0, y=140, kx=0, ky=0, cx=64.04, cy=1, z=2, d={{name="component/dlgBg", isArmature=0}} },
           {type="b", name="dlgTtlBg", x=1.55, y=173.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/dlgTtlBg", isArmature=0}} },
           {type="b", name="ttlNameTF", x=52.7, y=146.35000000000002, kx=0, ky=0, cx=1, cy=1, z=4, text={x=60,y=108, w=439, h=47,lineType="multiline",size=32,color="ffffdf",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="infoTF", x=52.7, y=93.35000000000002, kx=0, ky=0, cx=1, cy=1, z=5, text={x=57,y=18, w=823, h=78,lineType="multiline",size=26,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="itemTF", x=210.85, y=57.14999999999998, kx=0, ky=0, cx=1, cy=1, z=6, text={x=211,y=14, w=378, h=39,lineType="multiline",size=26,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="itemInfoTF", x=55.85, y=57.14999999999998, kx=0, ky=0, cx=1, cy=1, z=7, text={x=56,y=14, w=152, h=39,lineType="multiline",size=26,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="component_ZD_button", x=1081.9, y=102, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/component_ZD_button", isArmature=1}} },
           {type="b", name="component_HL_button", x=876.9, y=102, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="component/component_HL_button", isArmature=1}} },
           {type="b", name="component_HL_button_1", x=1081.9, y=102, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/component_HL_button", isArmature=1}} }
         }
      },
    {type="armature", name="component/component_ZD_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=0,y=-49, w=187, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/component_ZD_button_normal", isArmature=0},{name="component/component_ZD_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="component/component_HL_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=0,y=-49, w=187, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="component/component_HL_button_normal", isArmature=0},{name="component/component_HL_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="itemRender", 
      bones={           
           {type="b", name="hit_area", x=-65, y=65, kx=0, ky=0, cx=32.51, cy=32.5, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="edge", x=-54.9, y=-34.150000000000006, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="img", x=-46.9, y=-23.15000000000001, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="start1", x=-52.4, y=-10.599999999999994, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_star_small", isArmature=0}} },
           {type="b", name="start2", x=-33.9, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonImages/common_copy_star_kong_small", isArmature=0}} },
           {type="b", name="start3", x=-12.9, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_star_kong_small", isArmature=0}} },
           {type="b", name="start4", x=8.1, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_star_kong_small", isArmature=0}} },
           {type="b", name="start5", x=29.1, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_star_kong_small", isArmature=0}} },
           {type="b", name="countTF", x=42.1, y=-31.15000000000001, kx=0, ky=0, cx=1, cy=1, z=8, text={x=-46,y=-31, w=92, h=26,lineType="multiline",size=16,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="nameTF", x=-60.9, y=-32.150000000000006, kx=0, ky=0, cx=1, cy=1, z=9, text={x=-66,y=-64, w=133, h=31,lineType="multiline",size=20,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="typeTF", x=41.95, y=21, kx=0, ky=0, cx=1, cy=1, z=10, text={x=-41,y=18, w=82, h=31,lineType="multiline",size=20,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="ewaiImg", x=-64.65, y=64.65, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="component/ewaiImg", isArmature=0}} },
           {type="b", name="effectTmp", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="meeting_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="bgTmp", x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="countTF", x=481.85, y=67.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, text={x=484,y=27, w=327, h=39,lineType="multiline",size=26,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="common_copy_blue_button", x=549.8, y=139.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="person_1", x=233.8, y=550.4, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_2", x=385.8, y=531.9, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_3", x=796.8, y=527.9, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_4", x=964.8, y=542.4, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_5", x=145.85, y=422.9, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_6", x=317.8, y=403.9, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_7", x=882.8, y=404.9, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_8", x=1050.75, y=446.9, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_9", x=46.85, y=294.95, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_10", x=230.8, y=268.95, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_11", x=959.8, y=262.95, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="officer_render", isArmature=1}} },
           {type="b", name="person_12", x=1157.75, y=307.95, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="officer_render", isArmature=1}} },
           {type="b", name="ttlBg", x=432.3, y=237.2, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="component/ttlBg", isArmature=0}} },
           {type="b", name="officeLvTTF", x=499.9, y=228.05, kx=0, ky=0, cx=1, cy=1, z=17, text={x=406,y=190, w=475, h=39,lineType="multiline",size=26,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_ask_button", x=1113.8, y=711, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="commonButtons/common_copy_ask_button", isArmature=1}} },
           {type="b", name="common_copy_close_button", x=1195, y=714, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="pageTmp", x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_ask_button", 
      bones={           
           {type="b", name="common_ask_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_ask_button_normal", isArmature=0},{name="commonButtons/common_copy_ask_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="officer_render", 
      bones={           
           {type="b", name="hit_area", x=-17.95, y=-0.15, kx=0, ky=0, cx=32, cy=63.92, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="shadow", x=-21, y=-183.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/shadow", isArmature=0}} },
           {type="b", name="personTmp", x=44.85, y=-252.85, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="agreeImg", x=0, y=-12.85, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/smileImg", isArmature=0}} },
           {type="b", name="opposeImg", x=-0.15, y=-12.85, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/angerImg", isArmature=0}} },
           {type="b", name="smileImg", x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/smileImg", isArmature=0}} },
           {type="b", name="simpleImg", x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/simpleImg", isArmature=0}} },
           {type="b", name="angerImg", x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/angerImg", isArmature=0}} }
         }
      },
    {type="armature", name="proposal_render", 
      bones={           
           {type="b", name="tianBg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="component/tianBg", isArmature=0}} },
           {type="b", name="btn", x=503.8, y=-20.35, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/tianBtn", isArmature=0}} },
           {type="b", name="common_copy_friendNameBg", x=175.15, y=-114.25, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonImages/common_copy_friendNameBg", isArmature=0}} },
           {type="b", name="rew2TF", x=401.4, y=-114.5, kx=0, ky=0, cx=1, cy=1, z=3, text={x=404,y=-149, w=149, h=34,lineType="multiline",size=22,color="422515",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="img2", x=357.8, y=-149.8, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="rew1TF", x=239.8, y=-114.85, kx=0, ky=0, cx=1, cy=1, z=5, text={x=242,y=-149, w=149, h=34,lineType="multiline",size=22,color="422515",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="img1", x=188.8, y=-148.8, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="rewardPTF", x=30.75, y=-116.75, kx=0, ky=0, cx=1, cy=1, z=7, text={x=37,y=-147, w=459, h=34,lineType="multiline",size=22,color="422515",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rewardTF", x=30.75, y=-117.75, kx=0, ky=0, cx=1, cy=1, z=8, text={x=37,y=-148, w=157, h=34,lineType="multiline",size=22,color="422515",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="infoTF", x=30.75, y=-51.75, kx=0, ky=0, cx=1, cy=1, z=9, text={x=37,y=-114, w=459, h=66,lineType="multiline",size=22,color="422515",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ttlNameTF", x=30.75, y=-11.75, kx=0, ky=0, cx=1, cy=1, z=10, text={x=37,y=-51, w=384, h=40,lineType="multiline",size=27,color="000000",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="result_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="yuanhuan", x=666.3, y=364.65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/yuanhuan", isArmature=0}} },
           {type="b", name="common_copy_blue_button", x=575.95, y=189.70000000000005, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_line_horizon", x=356.3, y=339, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_line_horizon", isArmature=0}} },
           {type="b", name="itemTmp", x=666.8, y=260.15, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="jiangliPTTF", x=380, y=253, kx=0, ky=0, cx=1, cy=1, z=5, text={x=396,y=235, w=539, h=39,lineType="multiline",size=26,color="fbfbfa",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="jiangliTTF", x=380, y=300, kx=0, ky=0, cx=1, cy=1, z=6, text={x=396,y=282, w=539, h=39,lineType="multiline",size=26,color="fbfbfa",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ttlTTF", x=397, y=379.05, kx=0, ky=0, cx=1, cy=1, z=7, text={x=406,y=352, w=522, h=52,lineType="multiline",size=36,color="fbfbfa",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="proposalPerfImg", x=667, y=553.05, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/proposalPerfImg", isArmature=0}} },
           {type="b", name="proposalSuccImg", x=668, y=535, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="component/proposalSuccImg", isArmature=0}} },
           {type="b", name="proposalFailImg", x=654, y=561.05, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/proposalFailImg", isArmature=0}} }
         }
      },
    {type="armature", name="vote_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="infoTF", x=491.75, y=149, kx=-1.31, ky=0, cx=1, cy=1, z=1, text={x=349,y=109, w=577, h=36,lineType="multiline",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_blue_button", x=544.95, y=100.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonButtons/common_copy_blue_button", isArmature=1}} },
           {type="b", name="common_copy_background_4", x=405.35, y=662.65, kx=0, ky=0, cx=5.76, cy=1.27, z=3, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="rewardPTF", x=501.75, y=618, kx=-1.31, ky=0, cx=1, cy=1, z=4, text={x=429,y=577, w=404, h=36,lineType="multiline",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="rewardTF", x=501.75, y=651, kx=-1.31, ky=0, cx=1, cy=1, z=5, text={x=430,y=613, w=404, h=36,lineType="multiline",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="ttlNameTF", x=501.75, y=658, kx=-1.31, ky=0, cx=1, cy=1, z=6, text={x=445,y=618, w=373, h=36,lineType="multiline",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=14,y=-56, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="choose_proposal_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_1", sc=1, dl=0, f={
                {x=167.95, y=527, kx=0, ky=0, cx=12.16, cy=5.52, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="personImgTmp", sc=1, dl=0, f={
                {x=166, y=99.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_biaoti", sc=1, dl=0, f={
                {x=584.8, y=508.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlNameTF", sc=1, dl=0, f={
                {x=685.75, y=504.25, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="proposal_1", sc=1, dl=0, f={
                {x=443.35, y=450, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="proposal_2", sc=1, dl=0, f={
                {x=443.35, y=280.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1083.05, y=558, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_close_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_return_button", 
      mov={
     {name="normal", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_return_button", sc=1, dl=0, f={
                {x=0, y=87, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="harmonious_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="personImgTmp", sc=1, dl=0, f={
                {x=1280, y=1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dlgBg", sc=1, dl=0, f={
                {x=0, y=140, kx=0, ky=0, cx=64.04, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dlgTtlBg", sc=1, dl=0, f={
                {x=1.55, y=173.04999999999995, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlNameTF", sc=1, dl=0, f={
                {x=52.7, y=146.35000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="infoTF", sc=1, dl=0, f={
                {x=52.7, y=93.35000000000002, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTF", sc=1, dl=0, f={
                {x=210.85, y=57.14999999999998, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemInfoTF", sc=1, dl=0, f={
                {x=55.85, y=57.14999999999998, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="component_ZD_button", sc=1, dl=0, f={
                {x=1081.9, y=102, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="component_HL_button", sc=1, dl=0, f={
                {x=876.9, y=102, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="component_HL_button_1", sc=1, dl=0, f={
                {x=1081.9, y=102, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="component/component_ZD_button", 
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
    {type="animation", name="component/component_HL_button", 
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
    {type="animation", name="itemRender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-65, y=65, kx=0, ky=0, cx=32.51, cy=32.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="edge", sc=1, dl=0, f={
                {x=-54.9, y=-34.150000000000006, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img", sc=1, dl=0, f={
                {x=-46.9, y=-23.15000000000001, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="start1", sc=1, dl=0, f={
                {x=-52.4, y=-10.599999999999994, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="start2", sc=1, dl=0, f={
                {x=-33.9, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="start3", sc=1, dl=0, f={
                {x=-12.9, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="start4", sc=1, dl=0, f={
                {x=8.1, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="start5", sc=1, dl=0, f={
                {x=29.1, y=-9.099999999999994, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTF", sc=1, dl=0, f={
                {x=42.1, y=-31.15000000000001, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nameTF", sc=1, dl=0, f={
                {x=-60.9, y=-32.150000000000006, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="typeTF", sc=1, dl=0, f={
                {x=41.95, y=21, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ewaiImg", sc=1, dl=0, f={
                {x=-64.65, y=64.65, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effectTmp", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="meeting_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bgTmp", sc=1, dl=0, f={
                {x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="countTF", sc=1, dl=0, f={
                {x=481.85, y=67.20000000000005, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=549.8, y=139.20000000000005, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_1", sc=1, dl=0, f={
                {x=233.8, y=550.4, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_2", sc=1, dl=0, f={
                {x=385.8, y=531.9, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_3", sc=1, dl=0, f={
                {x=796.8, y=527.9, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_4", sc=1, dl=0, f={
                {x=964.8, y=542.4, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_5", sc=1, dl=0, f={
                {x=145.85, y=422.9, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_6", sc=1, dl=0, f={
                {x=317.8, y=403.9, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_7", sc=1, dl=0, f={
                {x=882.8, y=404.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_8", sc=1, dl=0, f={
                {x=1050.75, y=446.9, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_9", sc=1, dl=0, f={
                {x=46.85, y=294.95, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_10", sc=1, dl=0, f={
                {x=230.8, y=268.95, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_11", sc=1, dl=0, f={
                {x=959.8, y=262.95, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="person_12", sc=1, dl=0, f={
                {x=1157.75, y=307.95, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlBg", sc=1, dl=0, f={
                {x=432.3, y=237.2, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="officeLvTTF", sc=1, dl=0, f={
                {x=499.9, y=228.05, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_ask_button", sc=1, dl=0, f={
                {x=1113.8, y=711, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1195, y=714, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pageTmp", sc=1, dl=0, f={
                {x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
    {type="animation", name="officer_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-17.95, y=-0.15, kx=0, ky=0, cx=32, cy=63.92, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shadow", sc=1, dl=0, f={
                {x=-21, y=-183.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="personTmp", sc=1, dl=0, f={
                {x=44.85, y=-252.85, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="agreeImg", sc=1, dl=0, f={
                {x=0, y=-12.85, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="opposeImg", sc=1, dl=0, f={
                {x=-0.15, y=-12.85, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="smileImg", sc=1, dl=0, f={
                {x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="simpleImg", sc=1, dl=0, f={
                {x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="angerImg", sc=1, dl=0, f={
                {x=1, y=-13, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="proposal_render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="tianBg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn", sc=1, dl=0, f={
                {x=503.8, y=-20.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_friendNameBg", sc=1, dl=0, f={
                {x=175.15, y=-114.25, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rew2TF", sc=1, dl=0, f={
                {x=401.4, y=-114.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img2", sc=1, dl=0, f={
                {x=357.8, y=-149.8, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rew1TF", sc=1, dl=0, f={
                {x=239.8, y=-114.85, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="img1", sc=1, dl=0, f={
                {x=188.8, y=-148.8, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rewardPTF", sc=1, dl=0, f={
                {x=30.75, y=-116.75, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rewardTF", sc=1, dl=0, f={
                {x=30.75, y=-117.75, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="infoTF", sc=1, dl=0, f={
                {x=30.75, y=-51.75, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlNameTF", sc=1, dl=0, f={
                {x=30.75, y=-11.75, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="result_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanhuan", sc=1, dl=0, f={
                {x=666.3, y=364.65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=575.95, y=189.70000000000005, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_line_horizon", sc=1, dl=0, f={
                {x=356.3, y=339, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=666.8, y=260.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiangliPTTF", sc=1, dl=0, f={
                {x=380, y=253, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiangliTTF", sc=1, dl=0, f={
                {x=380, y=300, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlTTF", sc=1, dl=0, f={
                {x=397, y=379.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="proposalPerfImg", sc=1, dl=0, f={
                {x=667, y=553.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="proposalSuccImg", sc=1, dl=0, f={
                {x=668, y=535, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="proposalFailImg", sc=1, dl=0, f={
                {x=654, y=561.05, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="vote_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="infoTF", sc=1, dl=0, f={
                {x=491.75, y=149, kx=-1.31, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_blue_button", sc=1, dl=0, f={
                {x=544.95, y=100.04999999999995, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_4", sc=1, dl=0, f={
                {x=405.35, y=662.65, kx=0, ky=0, cx=5.76, cy=1.27, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rewardPTF", sc=1, dl=0, f={
                {x=501.75, y=618, kx=-1.31, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rewardTF", sc=1, dl=0, f={
                {x=501.75, y=651, kx=-1.31, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlNameTF", sc=1, dl=0, f={
                {x=501.75, y=658, kx=-1.31, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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