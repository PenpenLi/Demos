local conf = {type="skeleton", name="main_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="guangboGroup", 
      bones={           
           {type="b", name="guangbo_bg", x=0, y=37, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="guangbo_bg", isArmature=0}} },
           {type="b", name="guangboText", x=607, y=14, kx=0, ky=0, cx=1, cy=1, z=1, text={x=1,y=-1, w=770, h=28,lineType="single line",size=18,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="huobiGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=118, kx=0, ky=0, cx=258.75, cy=29.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="tili_bantou", x=828, y=106, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="mainui_huobi_bg", isArmature=0}} },
           {type="b", name="tiliText", x=913, y=74, kx=0, ky=0, cx=1, cy=1, z=2, text={x=859,y=68, w=142, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="tili", x=798.3, y=117, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonCurrencyImages/common_copy_tili_bg", isArmature=0}} },
           {type="b", name="yuanbao_bantou", x=602.8, y=106, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="mainui_huobi_bg", isArmature=0}} },
           {type="b", name="yuanbaoText", x=654, y=76, kx=0, ky=0, cx=1, cy=1, z=5, text={x=634,y=65, w=148, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yuanbao", x=563.8, y=117, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="yingliang_bantou", x=345.85, y=106, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="mainui_huobi_bg", isArmature=0}} },
           {type="b", name="yinliangText", x=275, y=75, kx=0, ky=0, cx=1, cy=1, z=8, text={x=383,y=65, w=156, h=44,lineType="single line",size=30,color="ffffff",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yinliang", x=308.8, y=118, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonCurrencyImages/common_copy_silver_bg", isArmature=0}} },
           {type="b", name="jia_tili", x=981.5, y=111, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} },
           {type="b", name="jia_yuanbao", x=750.5, y=111, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} },
           {type="b", name="jia_yingliang", x=502.5, y=111, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonCurrencyImages/common_copy_add_bg", isArmature=0}} }
         }
      },
    {type="armature", name="mainui_1", 
      bones={           
           {type="b", name="hit_area", x=0, y=724.65, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="chongzhi", x=1209.8, y=729.3, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="shezhi", isArmature=0}} }
         }
      },
    {type="armature", name="mainui_2", 
      bones={           
           {type="b", name="hit_area", x=0, y=715, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="chat_background", x=61.3, y=79.54999999999995, kx=0, ky=0, cx=8.06, cy=1.15, z=1, d={{name="chat_background", isArmature=0}} },
           {type="b", name="liaotiandi", x=9.1, y=86, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="liaotian", isArmature=0}} },
           {type="b", name="gantanhaoButton", x=590, y=280, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="gantanhaoButton", isArmature=1}} },
           {type="b", name="buddy_commend_button", x=483, y=280, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="buddy_commend_button", isArmature=0}} },
           {type="b", name="buddy_request_button", x=360.35, y=282.7, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="buddy_request_button", isArmature=0}} }
         }
      },
    {type="armature", name="gantanhaoButton", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=25, cy=25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="buttonBack", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="gantanhao", isArmature=0}} }
         }
      },
    {type="armature", name="mainui_3", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="gongneng", x=1215, y=65, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="menuHGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=108.5, kx=0, ky=0, cx=168.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="huanjing", x=570, y=108.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="huanjing", isArmature=1}} },
           {type="b", name="lunjian", x=455, y=108.5, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="lunjian", isArmature=1}} },
           {type="b", name="shilian", x=347.85, y=109, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="shilian", isArmature=1}} },
           {type="b", name="shili", x=233, y=108.5, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="shili", isArmature=1}} },
           {type="b", name="yingxiongzhi", x=124.85, y=108.5, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="yingxiongzhi", isArmature=1}} },
           {type="b", name="juqing", x=0, y=108.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="juqing", isArmature=1}} }
         }
      },
    {type="armature", name="huanjing", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="lunjian", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="juqing", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="menuHGroup2", 
      bones={           
           {type="b", name="hit_area", x=0, y=108, kx=0, ky=0, cx=137.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="sevendays", x=443, y=108, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="firstpay", isArmature=1}} },
           {type="b", name="firstpay", x=329, y=108, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="firstpay", isArmature=1}} },
           {type="b", name="monthcard", x=216.5, y=108, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="monthcard", isArmature=1}} },
           {type="b", name="huodong", x=107.85, y=108, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="huodong", isArmature=1}} },
           {type="b", name="langyabang", x=0, y=108, kx=0, ky=0, cx=0.88, cy=1, z=5, d={{name="langyabang", isArmature=1}} }
         }
      },
    {type="armature", name="firstpay", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=11, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="huodong", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="langyabang", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="menuLeftVGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=542, kx=0, ky=0, cx=29.75, cy=135.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="qiandao", x=0, y=109, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="qiandao", isArmature=1}} },
           {type="b", name="haoyou", x=0, y=216, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="haoyou", isArmature=1}} },
           {type="b", name="youjian", x=-0.15, y=318, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="youjian", isArmature=1}} },
           {type="b", name="shangcheng", x=0, y=434, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="shangcheng", isArmature=1}} },
           {type="b", name="langyaling", x=0, y=542, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="langyaling", isArmature=1}} }
         }
      },
    {type="armature", name="haoyou", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="langyaling", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="menuVGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=432, kx=0, ky=0, cx=29.75, cy=108, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="bangpai", x=-0.5, y=108, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="bangpai", isArmature=1}} },
           {type="b", name="beibao", x=0, y=216, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="beibao", isArmature=1}} },
           {type="b", name="renwu", x=0, y=324, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="renwu", isArmature=1}} },
           {type="b", name="yingxiong", x=0, y=432, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="yingxiong", isArmature=1}} }
         }
      },
    {type="armature", name="bangpai", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="beibao", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="monthcard", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=11, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="qiandao", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="qianghua", 
      bones={           
           {type="b", name="hit_area", x=0, y=108, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=102, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="renwu", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="shangcheng", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="shili", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="shilian", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="tiliTip", 
      bones={           
           {type="b", name="hit_area", x=0, y=180, kx=0, ky=0, cx=71, cy=45, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_background_4", x=0, y=180, kx=0, ky=0, cx=3.6, cy=2.28, z=1, d={{name="commonBackgroundScalables/common_copy_background_1", isArmature=0}} },
           {type="b", name="tiliText", x=28, y=136, kx=0, ky=0, cx=1, cy=1, z=2, text={x=24,y=131, w=214, h=34,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huifuText", x=28, y=100, kx=0, ky=0, cx=1, cy=1, z=3, text={x=24,y=95, w=214, h=34,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="danyaoText", x=27, y=26, kx=0, ky=0, cx=1, cy=1, z=4, text={x=24,y=23, w=253, h=34,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="huifuDescText", x=25, y=64, kx=0, ky=0, cx=1, cy=1, z=5, text={x=24,y=58, w=253, h=34,lineType="single line",size=22,color="e1d2a0",alignment="left",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="userInfoGroup", 
      bones={           
           {type="b", name="hit_area", x=0, y=135.15, kx=0, ky=0, cx=80, cy=33.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="head_bg", x=0, y=135.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="head_bg", isArmature=0}} },
           {type="b", name="common_copy_mainui_vip", x=124.85, y=123.3, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonNumbers/common_copy_mainui_vip", isArmature=0}} },
           {type="b", name="head_lv_bg", x=-0.15, y=136.3, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="head_lv_bg", isArmature=0}} },
           {type="b", name="userNameText", x=29, y=16.150000000000006, kx=0, ky=0, cx=1, cy=1, z=4, text={x=1,y=3, w=144, h=34,lineType="single line",size=22,color="ffe7c5",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="userLvText", x=16, y=107.15, kx=0, ky=0, cx=1, cy=1, z=5, text={x=3,y=96, w=39, h=34,lineType="single line",size=22,color="ffffdb",alignment="center",space=0,textType="input"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="redIcon", x=5, y=64.15, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="yingxiong", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="yingxiongzhi", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="youjian", 
      bones={           
           {type="b", name="hit_area", x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="effect", x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="guangboGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="guangbo_bg", sc=1, dl=0, f={
                {x=0, y=37, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="guangboText", sc=1, dl=0, f={
                {x=607, y=14, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
                {x=913, y=74, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tili", sc=1, dl=0, f={
                {x=798.3, y=117, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao_bantou", sc=1, dl=0, f={
                {x=602.8, y=106, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbaoText", sc=1, dl=0, f={
                {x=654, y=76, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanbao", sc=1, dl=0, f={
                {x=563.8, y=117, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingliang_bantou", sc=1, dl=0, f={
                {x=345.85, y=106, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliangText", sc=1, dl=0, f={
                {x=275, y=75, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yinliang", sc=1, dl=0, f={
                {x=308.8, y=118, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_tili", sc=1, dl=0, f={
                {x=981.5, y=111, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_yuanbao", sc=1, dl=0, f={
                {x=750.5, y=111, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jia_yingliang", sc=1, dl=0, f={
                {x=502.5, y=111, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mainui_1", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=724.65, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chongzhi", sc=1, dl=0, f={
                {x=1209.8, y=729.3, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mainui_2", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=715, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="chat_background", sc=1, dl=0, f={
                {x=61.3, y=79.54999999999995, kx=0, ky=0, cx=8.06, cy=1.15, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="liaotiandi", sc=1, dl=0, f={
                {x=9.1, y=86, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gantanhaoButton", sc=1, dl=0, f={
                {x=590, y=280, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buddy_commend_button", sc=1, dl=0, f={
                {x=483, y=280, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buddy_request_button", sc=1, dl=0, f={
                {x=360.35, y=282.7, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="gantanhaoButton", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=25, cy=25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buttonBack", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="mainui_3", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gongneng", sc=1, dl=0, f={
                {x=1215, y=65, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="menuHGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=108.5, kx=0, ky=0, cx=168.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huanjing", sc=1, dl=0, f={
                {x=570, y=108.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lunjian", sc=1, dl=0, f={
                {x=455, y=108.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shilian", sc=1, dl=0, f={
                {x=347.85, y=109, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shili", sc=1, dl=0, f={
                {x=233, y=108.5, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingxiongzhi", sc=1, dl=0, f={
                {x=124.85, y=108.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="juqing", sc=1, dl=0, f={
                {x=0, y=108.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huanjing", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="lunjian", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="juqing", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="menuHGroup2", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=108, kx=0, ky=0, cx=137.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sevendays", sc=1, dl=0, f={
                {x=443, y=108, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="firstpay", sc=1, dl=0, f={
                {x=329, y=108, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="monthcard", sc=1, dl=0, f={
                {x=216.5, y=108, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huodong", sc=1, dl=0, f={
                {x=107.85, y=108, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="langyabang", sc=1, dl=0, f={
                {x=0, y=108, kx=0, ky=0, cx=0.88, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="firstpay", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=11, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="huodong", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="langyabang", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="menuLeftVGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=542, kx=0, ky=0, cx=29.75, cy=135.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="qiandao", sc=1, dl=0, f={
                {x=0, y=109, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="haoyou", sc=1, dl=0, f={
                {x=0, y=216, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="youjian", sc=1, dl=0, f={
                {x=-0.15, y=318, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="shangcheng", sc=1, dl=0, f={
                {x=0, y=434, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="langyaling", sc=1, dl=0, f={
                {x=0, y=542, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="haoyou", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="langyaling", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="menuVGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=432, kx=0, ky=0, cx=29.75, cy=108, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bangpai", sc=1, dl=0, f={
                {x=-0.5, y=108, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="beibao", sc=1, dl=0, f={
                {x=0, y=216, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renwu", sc=1, dl=0, f={
                {x=0, y=324, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yingxiong", sc=1, dl=0, f={
                {x=0, y=432, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="bangpai", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="beibao", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="monthcard", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=11, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="qiandao", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="qianghua", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=108, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=102, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="renwu", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shangcheng", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shili", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="shilian", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=27, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="tiliTip", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=180, kx=0, ky=0, cx=71, cy=45, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_background_4", sc=1, dl=0, f={
                {x=0, y=180, kx=0, ky=0, cx=3.6, cy=2.28, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="tiliText", sc=1, dl=0, f={
                {x=28, y=136, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huifuText", sc=1, dl=0, f={
                {x=28, y=100, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="danyaoText", sc=1, dl=0, f={
                {x=27, y=26, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="huifuDescText", sc=1, dl=0, f={
                {x=25, y=64, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="userInfoGroup", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=135.15, kx=0, ky=0, cx=80, cy=33.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="head_bg", sc=1, dl=0, f={
                {x=0, y=135.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_mainui_vip", sc=1, dl=0, f={
                {x=124.85, y=123.3, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="head_lv_bg", sc=1, dl=0, f={
                {x=-0.15, y=136.3, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="userNameText", sc=1, dl=0, f={
                {x=29, y=16.150000000000006, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="userLvText", sc=1, dl=0, f={
                {x=16, y=107.15, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="redIcon", sc=1, dl=0, f={
                {x=5, y=64.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="yingxiong", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="yingxiongzhi", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=26.25, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="youjian", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=29.75, cy=27, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=9, y=-6, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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