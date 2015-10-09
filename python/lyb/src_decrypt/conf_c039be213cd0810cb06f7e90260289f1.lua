local conf = {type="skeleton", name="battle_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="battleui_1", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="stop_button", x=13.05, y=715, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="stop_button", isArmature=0}} },
           {type="b", name="diren", x=102.95, y=703, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="diren", isArmature=0}} },
           {type="b", name="diren_text", x=-440.25, y=529.8, kx=0, ky=0, cx=1, cy=1, z=3, text={x=108,y=662, w=141, h=41,lineType="single line",size=28,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="battleui_2", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="yinliang", x=1108.95, y=711.3, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="yinliang", isArmature=0}} },
           {type="b", name="baoxiang", x=940, y=713, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="baoxiang", isArmature=0}} },
           {type="b", name="baoxiang_text", x=374.7, y=540.8, kx=0, ky=0, cx=1, cy=1, z=3, text={x=967,y=661, w=141, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="yinliang_text", x=572.7, y=540.8, kx=0, ky=0, cx=1, cy=1, z=4, text={x=1138,y=661, w=134, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_small_orange_button", x=1096.8, y=688.7, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_small_orange_button", isArmature=1}} }
         }
      },
    {type="armature", name="battleui_3", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} }
         }
      },
    {type="armature", name="battleui_4", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="auto_button", x=1172, y=98, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="auto_button", isArmature=0}} },
           {type="b", name="hand_button", x=1172, y=98, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="hand_button", isArmature=0}} },
           {type="b", name="gogogo", x=1164.1, y=351.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="gogogo", isArmature=0}} }
         }
      },
    {type="armature", name="battleui_5", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_button_bg2", x=568.15, y=1.2999999999999543, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_button_bg", isArmature=0}} },
           {type="b", name="common_copy_button_bg1", x=568.15, y=1.2999999999999543, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_button_bg", isArmature=0}} },
           {type="b", name="backbutton", x=699.8, y=403, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="back_button", isArmature=0}} },
           {type="b", name="exitbutton", x=503.8, y=402.2, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="exitbutton", isArmature=0}} },
           {type="b", name="force_button", x=590.8, y=545.05, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="back_button", isArmature=0}} },
           {type="b", name="time_pic", x=387.3, y=720, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="time_pic", isArmature=0}} },
           {type="b", name="time_text", x=557.2, y=694.1, kx=0, ky=0, cx=1, cy=1, z=7, text={x=559,y=662, w=139, h=55,lineType="single line",size=38,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="common_battle_text", 
      bones={           
           {type="b", name="common_battle_bigred9", x=438.95, y=452.55, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="common_battle_bigred9", isArmature=0}} },
           {type="b", name="common_battle_bigred8", x=396.85, y=455.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_battle_bigred8", isArmature=0}} },
           {type="b", name="common_battle_bigred7", x=353.85, y=452.55, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_battle_bigred7", isArmature=0}} },
           {type="b", name="common_battle_bigred6", x=305.85, y=455.05, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="common_battle_bigred6", isArmature=0}} },
           {type="b", name="common_battle_bigred5", x=265.85, y=458.05, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="common_battle_bigred5", isArmature=0}} },
           {type="b", name="common_battle_bigred4", x=222.85, y=458.55, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="common_battle_bigred4", isArmature=0}} },
           {type="b", name="common_battle_bigred3", x=175.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="common_battle_bigred3", isArmature=0}} },
           {type="b", name="common_battle_bigred2", x=135.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="common_battle_bigred2", isArmature=0}} },
           {type="b", name="common_battle_bigred1", x=92.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="common_battle_bigred1", isArmature=0}} },
           {type="b", name="common_battle_bigred0", x=55.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="common_battle_bigred0", isArmature=0}} },
           {type="b", name="common_battle_bigred10", x=487.85, y=452.55, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="common_battle_bigred10", isArmature=0}} },
           {type="b", name="common_battle_green0", x=59, y=396.25, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="common_battle_green0", isArmature=0}} },
           {type="b", name="common_battle_green1", x=102.85, y=398.55, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="common_battle_green1", isArmature=0}} },
           {type="b", name="common_battle_green2", x=142, y=401.05, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="common_battle_green2", isArmature=0}} },
           {type="b", name="common_battle_green3", x=186, y=403.55, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="common_battle_green3", isArmature=0}} },
           {type="b", name="common_battle_green4", x=229, y=398.55, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="common_battle_green4", isArmature=0}} },
           {type="b", name="common_battle_green5", x=269, y=401.05, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="common_battle_green5", isArmature=0}} },
           {type="b", name="common_battle_green6", x=310, y=401.05, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="common_battle_green6", isArmature=0}} },
           {type="b", name="common_battle_green7", x=353.85, y=394.25, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="common_battle_green7", isArmature=0}} },
           {type="b", name="common_battle_green8", x=399, y=394.25, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="common_battle_green8", isArmature=0}} },
           {type="b", name="common_battle_green9", x=448.95, y=398.55, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="common_battle_green9", isArmature=0}} },
           {type="b", name="common_battle_green10", x=494, y=396.25, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="common_battle_green10", isArmature=0}} },
           {type="b", name="common_battle_litred9", x=63, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="common_battle_litred9", isArmature=0}} },
           {type="b", name="common_battle_litred8", x=102.85, y=350.20000000000005, kx=0, ky=0, cx=1, cy=1, z=23, d={{name="common_battle_litred8", isArmature=0}} },
           {type="b", name="common_battle_litred7", x=146, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=24, d={{name="common_battle_litred7", isArmature=0}} },
           {type="b", name="common_battle_litred6", x=183.35, y=356.25, kx=0, ky=0, cx=1, cy=1, z=25, d={{name="common_battle_litred6", isArmature=0}} },
           {type="b", name="common_battle_timerd", x=124.35, y=238.7, kx=0, ky=0, cx=1, cy=1, z=26, d={{name="common_battle_timerd", isArmature=0}} },
           {type="b", name="common_battle_blue10", x=488.95, y=281.20000000000005, kx=0, ky=0, cx=1, cy=1, z=27, d={{name="common_battle_blue10", isArmature=0}} },
           {type="b", name="common_battle_blue0", x=436.95, y=289.20000000000005, kx=0, ky=0, cx=1, cy=1, z=28, d={{name="common_battle_blue0", isArmature=0}} },
           {type="b", name="common_battle_blue1", x=380.95, y=298.20000000000005, kx=0, ky=0, cx=1, cy=1, z=29, d={{name="common_battle_blue1", isArmature=0}} },
           {type="b", name="common_battle_blue2", x=329.95, y=302.20000000000005, kx=0, ky=0, cx=1, cy=1, z=30, d={{name="common_battle_blue2", isArmature=0}} },
           {type="b", name="common_battle_blue3", x=279, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=31, d={{name="common_battle_blue3", isArmature=0}} },
           {type="b", name="common_battle_blue4", x=234, y=302.20000000000005, kx=0, ky=0, cx=1, cy=1, z=32, d={{name="common_battle_blue4", isArmature=0}} },
           {type="b", name="common_battle_blue5", x=180, y=301.20000000000005, kx=0, ky=0, cx=1, cy=1, z=33, d={{name="common_battle_blue5", isArmature=0}} },
           {type="b", name="common_battle_blue6", x=124, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=34, d={{name="common_battle_blue6", isArmature=0}} },
           {type="b", name="common_battle_blue7", x=74, y=305.20000000000005, kx=0, ky=0, cx=1, cy=1, z=35, d={{name="common_battle_blue7", isArmature=0}} },
           {type="b", name="common_battle_blue8", x=21, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=36, d={{name="common_battle_blue8", isArmature=0}} },
           {type="b", name="bloodmask", x=562.8, y=230.25, kx=0, ky=0, cx=1, cy=1, z=37, d={{name="bloodmask", isArmature=0}} },
           {type="b", name="common_battle_blue9", x=-30, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=38, d={{name="common_battle_blue9", isArmature=0}} },
           {type="b", name="common_battle_timer9", x=59, y=248.2, kx=0, ky=0, cx=1, cy=1, z=39, d={{name="common_battle_timer9", isArmature=0}} },
           {type="b", name="common_battle_timer8", x=91.65, y=249.2, kx=0, ky=0, cx=1, cy=1, z=40, d={{name="common_battle_timer8", isArmature=0}} },
           {type="b", name="common_battle_timer7", x=143.65, y=250.2, kx=0, ky=0, cx=1, cy=1, z=41, d={{name="common_battle_timer7", isArmature=0}} },
           {type="b", name="common_battle_timer6", x=173.65, y=250.2, kx=0, ky=0, cx=1, cy=1, z=42, d={{name="common_battle_timer6", isArmature=0}} },
           {type="b", name="common_battle_timer5", x=204, y=248.05, kx=0, ky=0, cx=1, cy=1, z=43, d={{name="common_battle_timer5", isArmature=0}} },
           {type="b", name="common_battle_timer4", x=237, y=247.05, kx=0, ky=0, cx=1, cy=1, z=44, d={{name="common_battle_timer4", isArmature=0}} },
           {type="b", name="common_battle_timer3", x=273, y=246.05, kx=0, ky=0, cx=1, cy=1, z=45, d={{name="common_battle_timer3", isArmature=0}} },
           {type="b", name="common_battle_timer2", x=310, y=246.05, kx=0, ky=0, cx=1, cy=1, z=46, d={{name="common_battle_timer2", isArmature=0}} },
           {type="b", name="common_battle_timer1", x=350.4, y=243.05, kx=0, ky=0, cx=1, cy=1, z=47, d={{name="common_battle_timer1", isArmature=0}} },
           {type="b", name="common_battle_timer0", x=386.75, y=245.05, kx=0, ky=0, cx=1, cy=1, z=48, d={{name="common_battle_timer0", isArmature=0}} },
           {type="b", name="common_shuxing_7h", x=1008.25, y=272.15, kx=0, ky=0, cx=1, cy=1, z=49, d={{name="common_shuxing_7h", isArmature=0}} },
           {type="b", name="common_shuxing_10h", x=1217.35, y=327.15, kx=0, ky=0, cx=1, cy=1, z=50, d={{name="common_shuxing_10h", isArmature=0}} },
           {type="b", name="shanh", x=925.25, y=375.15, kx=0, ky=0, cx=1, cy=1, z=51, d={{name="shanh", isArmature=0}} },
           {type="b", name="headimagebg1h", x=1340.25, y=516.55, kx=0, ky=0, cx=1, cy=1, z=52, d={{name="headimagebg1h", isArmature=0}} },
           {type="b", name="monsterblood_progressbar_down", x=560.9, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=53, d={{name="blood_progressbar_down", isArmature=0}} },
           {type="b", name="monsterblood_progressbar_up", x=566.9, y=325.20000000000005, kx=0, ky=0, cx=1, cy=1, z=54, d={{name="blood_progressbar_up", isArmature=0}} },
           {type="b", name="common_battle_litred5", x=222.85, y=356.25, kx=0, ky=0, cx=1, cy=1, z=55, d={{name="common_battle_litred5", isArmature=0}} },
           {type="b", name="common_battle_litred4", x=269, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=56, d={{name="common_battle_litred4", isArmature=0}} },
           {type="b", name="common_battle_litred3", x=310, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=57, d={{name="common_battle_litred3", isArmature=0}} },
           {type="b", name="common_battle_litred2", x=353.85, y=350.20000000000005, kx=0, ky=0, cx=1, cy=1, z=58, d={{name="common_battle_litred2", isArmature=0}} },
           {type="b", name="common_battle_litred1", x=399, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=59, d={{name="common_battle_litred1", isArmature=0}} },
           {type="b", name="common_battle_litred0", x=446.35, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=60, d={{name="common_battle_litred0", isArmature=0}} },
           {type="b", name="common_battle_litred10", x=494, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=61, d={{name="common_battle_litred10", isArmature=0}} },
           {type="b", name="common_battle_state4", x=397.75, y=534.1, kx=0, ky=0, cx=1, cy=1, z=62, d={{name="common_battle_state4", isArmature=0}} },
           {type="b", name="common_battle_state3", x=32.85, y=546.55, kx=0, ky=0, cx=1, cy=1, z=63, d={{name="common_battle_state3", isArmature=0}} },
           {type="b", name="common_battle_state5", x=146.75, y=555.55, kx=0, ky=0, cx=1, cy=1, z=64, d={{name="common_battle_state5", isArmature=0}} },
           {type="b", name="common_battle_state6", x=513.95, y=554.55, kx=0, ky=0, cx=1, cy=1, z=65, d={{name="common_battle_state6", isArmature=0}} },
           {type="b", name="common_battle_state2", x=295.3, y=538.55, kx=0, ky=0, cx=1, cy=1, z=66, d={{name="common_battle_state2", isArmature=0}} },
           {type="b", name="lianji_0", x=21.35, y=146.25, kx=0, ky=0, cx=1, cy=1, z=67, d={{name="lianji_0", isArmature=0}} },
           {type="b", name="lianji_1", x=81, y=147.3, kx=0, ky=0, cx=1, cy=1, z=68, d={{name="lianji_1", isArmature=0}} },
           {type="b", name="lianji_2", x=155.85, y=152.25, kx=0, ky=0, cx=1, cy=1, z=69, d={{name="lianji_2", isArmature=0}} },
           {type="b", name="lianji_3", x=244.85, y=141.75, kx=0, ky=0, cx=1, cy=1, z=70, d={{name="lianji_3", isArmature=0}} },
           {type="b", name="lianji_4", x=328.75, y=139, kx=0, ky=0, cx=1, cy=1, z=71, d={{name="lianji_4", isArmature=0}} },
           {type="b", name="lianji_5", x=403.85, y=139, kx=0, ky=0, cx=1, cy=1, z=72, d={{name="lianji_5", isArmature=0}} },
           {type="b", name="lianji_6", x=474.95, y=141.75, kx=0, ky=0, cx=1, cy=1, z=73, d={{name="lianji_6", isArmature=0}} },
           {type="b", name="lianji_7", x=552.9, y=141.75, kx=0, ky=0, cx=1, cy=1, z=74, d={{name="lianji_7", isArmature=0}} },
           {type="b", name="lianji_8", x=614.35, y=145.10000000000002, kx=0, ky=0, cx=1, cy=1, z=75, d={{name="lianji_8", isArmature=0}} },
           {type="b", name="lianji_9", x=683.3, y=152.25, kx=0, ky=0, cx=1, cy=1, z=76, d={{name="lianji_9", isArmature=0}} },
           {type="b", name="zhenwang", x=736.25, y=306.05, kx=0, ky=0, cx=1, cy=1, z=77, d={{name="zhenwang", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_small_orange_button", 
      bones={           
           {type="b", name="common_small_orange_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=4,y=-41, w=101, h=36,lineType="single line",size=24,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_small_orange_button_normal", isArmature=0},{name="commonButtons/common_copy_small_orange_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="RightProgressBar", 
      bones={           
           {type="b", name="hit_area", x=0, y=137, kx=0, ky=0, cx=142.5, cy=34.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="ZhandourenwuRight", x=0, y=137, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="ZhandourenwuRight", isArmature=0}} },
           {type="b", name="pro_down", x=25.5, y=95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="pro_down", isArmature=0}} },
           {type="b", name="pro_up", x=23, y=98, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="XuetiaoRight", isArmature=0}} },
           {type="b", name="bossname_text", x=331.75, y=93.1, kx=0, ky=0, cx=1, cy=1, z=4, text={x=300,y=90, w=156, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="bosslevel_text", x=331.75, y=35.099999999999994, kx=0, ky=0, cx=1, cy=1, z=5, text={x=300,y=38, w=156, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="RightProgressBarBoss", 
      bones={           
           {type="b", name="hit_area", x=0, y=140, kx=0, ky=0, cx=147, cy=34.25, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="bossBg", x=0, y=140, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bossBg", isArmature=0}} },
           {type="b", name="pro_down", x=37.5, y=96, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="pro_down", isArmature=0}} },
           {type="b", name="bossname_text", x=331.75, y=96.1, kx=0, ky=0, cx=1, cy=1, z=3, text={x=306,y=98, w=156, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="bosslevel_text", x=331.75, y=38.099999999999994, kx=0, ky=0, cx=1, cy=1, z=4, text={x=329,y=35, w=156, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="rolehero", 
      bones={           
           {type="b", name="hit_area", x=0, y=141.5, kx=0, ky=0, cx=36, cy=35, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="headimagebg1", x=13, y=113, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="headimagebg1", isArmature=0}} },
           {type="b", name="tip_text", x=28.75, y=122.3, kx=0, ky=0, cx=1, cy=1, z=2, text={x=-14,y=108, w=177, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} },
           {type="b", name="nuqitiao", x=23.6, y=19.5, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="nuqitiao", isArmature=0}} },
           {type="b", name="xuetiao", x=22.6, y=30.5, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="xuetiao", isArmature=0}} }
         }
      },
    {type="armature", name="skillname_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=135, kx=0, ky=0, cx=66, cy=33.75, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="qipao", x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="qipao", isArmature=0}} },
           {type="b", name="desr_text", x=226.9, y=113.9, kx=0, ky=0, cx=1, cy=1, z=2, text={x=27,y=51, w=195, h=65,lineType="single line",size=22,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="battleui_1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="stop_button", sc=1, dl=0, f={
                {x=13.05, y=715, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="diren", sc=1, dl=0, f={
                {x=102.95, y=703, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="diren_text", sc=1, dl=0, f={
                {x=-440.25, y=529.8, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="battleui_2", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang", sc=1, dl=0, f={
                {x=1108.95, y=711.3, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="baoxiang", sc=1, dl=0, f={
                {x=940, y=713, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="baoxiang_text", sc=1, dl=0, f={
                {x=374.7, y=540.8, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang_text", sc=1, dl=0, f={
                {x=572.7, y=540.8, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_small_orange_button", sc=1, dl=0, f={
                {x=1096.8, y=688.7, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="battleui_3", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="battleui_4", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="auto_button", sc=1, dl=0, f={
                {x=1172, y=98, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hand_button", sc=1, dl=0, f={
                {x=1172, y=98, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gogogo", sc=1, dl=0, f={
                {x=1164.1, y=351.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="battleui_5", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg2", sc=1, dl=0, f={
                {x=568.15, y=1.2999999999999543, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg1", sc=1, dl=0, f={
                {x=568.15, y=1.2999999999999543, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="backbutton", sc=1, dl=0, f={
                {x=699.8, y=403, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="exitbutton", sc=1, dl=0, f={
                {x=503.8, y=402.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="force_button", sc=1, dl=0, f={
                {x=590.8, y=545.05, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="time_pic", sc=1, dl=0, f={
                {x=387.3, y=720, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="time_text", sc=1, dl=0, f={
                {x=557.2, y=694.1, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="common_battle_text", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_battle_bigred9", sc=1, dl=0, f={
                {x=438.95, y=452.55, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred8", sc=1, dl=0, f={
                {x=396.85, y=455.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred7", sc=1, dl=0, f={
                {x=353.85, y=452.55, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred6", sc=1, dl=0, f={
                {x=305.85, y=455.05, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred5", sc=1, dl=0, f={
                {x=265.85, y=458.05, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred4", sc=1, dl=0, f={
                {x=222.85, y=458.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred3", sc=1, dl=0, f={
                {x=175.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred2", sc=1, dl=0, f={
                {x=135.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred1", sc=1, dl=0, f={
                {x=92.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred0", sc=1, dl=0, f={
                {x=55.85, y=463.05, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_bigred10", sc=1, dl=0, f={
                {x=487.85, y=452.55, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green0", sc=1, dl=0, f={
                {x=59, y=396.25, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green1", sc=1, dl=0, f={
                {x=102.85, y=398.55, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green2", sc=1, dl=0, f={
                {x=142, y=401.05, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green3", sc=1, dl=0, f={
                {x=186, y=403.55, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green4", sc=1, dl=0, f={
                {x=229, y=398.55, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green5", sc=1, dl=0, f={
                {x=269, y=401.05, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green6", sc=1, dl=0, f={
                {x=310, y=401.05, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green7", sc=1, dl=0, f={
                {x=353.85, y=394.25, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green8", sc=1, dl=0, f={
                {x=399, y=394.25, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green9", sc=1, dl=0, f={
                {x=448.95, y=398.55, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_green10", sc=1, dl=0, f={
                {x=494, y=396.25, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred9", sc=1, dl=0, f={
                {x=63, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred8", sc=1, dl=0, f={
                {x=102.85, y=350.20000000000005, kx=0, ky=0, cx=1, cy=1, z=23, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred7", sc=1, dl=0, f={
                {x=146, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=24, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred6", sc=1, dl=0, f={
                {x=183.35, y=356.25, kx=0, ky=0, cx=1, cy=1, z=25, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timerd", sc=1, dl=0, f={
                {x=124.35, y=238.7, kx=0, ky=0, cx=1, cy=1, z=26, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue10", sc=1, dl=0, f={
                {x=488.95, y=281.20000000000005, kx=0, ky=0, cx=1, cy=1, z=27, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue0", sc=1, dl=0, f={
                {x=436.95, y=289.20000000000005, kx=0, ky=0, cx=1, cy=1, z=28, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue1", sc=1, dl=0, f={
                {x=380.95, y=298.20000000000005, kx=0, ky=0, cx=1, cy=1, z=29, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue2", sc=1, dl=0, f={
                {x=329.95, y=302.20000000000005, kx=0, ky=0, cx=1, cy=1, z=30, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue3", sc=1, dl=0, f={
                {x=279, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=31, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue4", sc=1, dl=0, f={
                {x=234, y=302.20000000000005, kx=0, ky=0, cx=1, cy=1, z=32, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue5", sc=1, dl=0, f={
                {x=180, y=301.20000000000005, kx=0, ky=0, cx=1, cy=1, z=33, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue6", sc=1, dl=0, f={
                {x=124, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=34, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue7", sc=1, dl=0, f={
                {x=74, y=305.20000000000005, kx=0, ky=0, cx=1, cy=1, z=35, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue8", sc=1, dl=0, f={
                {x=21, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=36, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bloodmask", sc=1, dl=0, f={
                {x=562.8, y=230.25, kx=0, ky=0, cx=1, cy=1, z=37, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_blue9", sc=1, dl=0, f={
                {x=-30, y=303.20000000000005, kx=0, ky=0, cx=1, cy=1, z=38, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer9", sc=1, dl=0, f={
                {x=59, y=248.2, kx=0, ky=0, cx=1, cy=1, z=39, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer8", sc=1, dl=0, f={
                {x=91.65, y=249.2, kx=0, ky=0, cx=1, cy=1, z=40, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer7", sc=1, dl=0, f={
                {x=143.65, y=250.2, kx=0, ky=0, cx=1, cy=1, z=41, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer6", sc=1, dl=0, f={
                {x=173.65, y=250.2, kx=0, ky=0, cx=1, cy=1, z=42, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer5", sc=1, dl=0, f={
                {x=204, y=248.05, kx=0, ky=0, cx=1, cy=1, z=43, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer4", sc=1, dl=0, f={
                {x=237, y=247.05, kx=0, ky=0, cx=1, cy=1, z=44, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer3", sc=1, dl=0, f={
                {x=273, y=246.05, kx=0, ky=0, cx=1, cy=1, z=45, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer2", sc=1, dl=0, f={
                {x=310, y=246.05, kx=0, ky=0, cx=1, cy=1, z=46, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer1", sc=1, dl=0, f={
                {x=350.4, y=243.05, kx=0, ky=0, cx=1, cy=1, z=47, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_timer0", sc=1, dl=0, f={
                {x=386.75, y=245.05, kx=0, ky=0, cx=1, cy=1, z=48, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_7h", sc=1, dl=0, f={
                {x=1008.25, y=272.15, kx=0, ky=0, cx=1, cy=1, z=49, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_shuxing_10h", sc=1, dl=0, f={
                {x=1217.35, y=327.15, kx=0, ky=0, cx=1, cy=1, z=50, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shanh", sc=1, dl=0, f={
                {x=925.25, y=375.15, kx=0, ky=0, cx=1, cy=1, z=51, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="headimagebg1h", sc=1, dl=0, f={
                {x=1340.25, y=516.55, kx=0, ky=0, cx=1, cy=1, z=52, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="monsterblood_progressbar_down", sc=1, dl=0, f={
                {x=560.9, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=53, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="monsterblood_progressbar_up", sc=1, dl=0, f={
                {x=566.9, y=325.20000000000005, kx=0, ky=0, cx=1, cy=1, z=54, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred5", sc=1, dl=0, f={
                {x=222.85, y=356.25, kx=0, ky=0, cx=1, cy=1, z=55, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred4", sc=1, dl=0, f={
                {x=269, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=56, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred3", sc=1, dl=0, f={
                {x=310, y=353.20000000000005, kx=0, ky=0, cx=1, cy=1, z=57, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred2", sc=1, dl=0, f={
                {x=353.85, y=350.20000000000005, kx=0, ky=0, cx=1, cy=1, z=58, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred1", sc=1, dl=0, f={
                {x=399, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=59, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred0", sc=1, dl=0, f={
                {x=446.35, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=60, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_litred10", sc=1, dl=0, f={
                {x=494, y=347.20000000000005, kx=0, ky=0, cx=1, cy=1, z=61, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state4", sc=1, dl=0, f={
                {x=397.75, y=534.1, kx=0, ky=0, cx=1, cy=1, z=62, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state3", sc=1, dl=0, f={
                {x=32.85, y=546.55, kx=0, ky=0, cx=1, cy=1, z=63, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state5", sc=1, dl=0, f={
                {x=146.75, y=555.55, kx=0, ky=0, cx=1, cy=1, z=64, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state6", sc=1, dl=0, f={
                {x=513.95, y=554.55, kx=0, ky=0, cx=1, cy=1, z=65, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_battle_state2", sc=1, dl=0, f={
                {x=295.3, y=538.55, kx=0, ky=0, cx=1, cy=1, z=66, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_0", sc=1, dl=0, f={
                {x=21.35, y=146.25, kx=0, ky=0, cx=1, cy=1, z=67, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_1", sc=1, dl=0, f={
                {x=81, y=147.3, kx=0, ky=0, cx=1, cy=1, z=68, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_2", sc=1, dl=0, f={
                {x=155.85, y=152.25, kx=0, ky=0, cx=1, cy=1, z=69, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_3", sc=1, dl=0, f={
                {x=244.85, y=141.75, kx=0, ky=0, cx=1, cy=1, z=70, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_4", sc=1, dl=0, f={
                {x=328.75, y=139, kx=0, ky=0, cx=1, cy=1, z=71, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_5", sc=1, dl=0, f={
                {x=403.85, y=139, kx=0, ky=0, cx=1, cy=1, z=72, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_6", sc=1, dl=0, f={
                {x=474.95, y=141.75, kx=0, ky=0, cx=1, cy=1, z=73, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_7", sc=1, dl=0, f={
                {x=552.9, y=141.75, kx=0, ky=0, cx=1, cy=1, z=74, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_8", sc=1, dl=0, f={
                {x=614.35, y=145.10000000000002, kx=0, ky=0, cx=1, cy=1, z=75, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lianji_9", sc=1, dl=0, f={
                {x=683.3, y=152.25, kx=0, ky=0, cx=1, cy=1, z=76, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zhenwang", sc=1, dl=0, f={
                {x=736.25, y=306.05, kx=0, ky=0, cx=1, cy=1, z=77, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonButtons/common_copy_small_orange_button", 
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
    {type="animation", name="RightProgressBar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=137, kx=0, ky=0, cx=142.5, cy=34.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ZhandourenwuRight", sc=1, dl=0, f={
                {x=0, y=137, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pro_down", sc=1, dl=0, f={
                {x=25.5, y=95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pro_up", sc=1, dl=0, f={
                {x=23, y=98, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bossname_text", sc=1, dl=0, f={
                {x=331.75, y=93.1, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bosslevel_text", sc=1, dl=0, f={
                {x=331.75, y=35.099999999999994, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="RightProgressBarBoss", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=140, kx=0, ky=0, cx=147, cy=34.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bossBg", sc=1, dl=0, f={
                {x=0, y=140, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pro_down", sc=1, dl=0, f={
                {x=37.5, y=96, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bossname_text", sc=1, dl=0, f={
                {x=331.75, y=96.1, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bosslevel_text", sc=1, dl=0, f={
                {x=331.75, y=38.099999999999994, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="rolehero", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=141.5, kx=0, ky=0, cx=36, cy=35, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="headimagebg1", sc=1, dl=0, f={
                {x=13, y=113, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tip_text", sc=1, dl=0, f={
                {x=28.75, y=122.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nuqitiao", sc=1, dl=0, f={
                {x=23.6, y=19.5, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xuetiao", sc=1, dl=0, f={
                {x=22.6, y=30.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="skillname_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=66, cy=33.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="qipao", sc=1, dl=0, f={
                {x=0, y=135, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="desr_text", sc=1, dl=0, f={
                {x=226.9, y=113.9, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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