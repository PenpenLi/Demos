local conf = {type="skeleton", name="sevendays_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="button_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=550, kx=0, ky=0, cx=266, cy=138, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="btn1", x=412, y=538, kx=0, ky=0, cx=0.96, cy=1, z=1, d={{name="day_btn", isArmature=1}} },
           {type="b", name="text1", x=416.9, y=510.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=417,y=490, w=141, h=38,lineType="single line",size=34,color="5a2319",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="reddot1", x=538, y=551, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn2", x=562, y=538, kx=0, ky=0, cx=0.96, cy=1, z=4, d={{name="day_btn", isArmature=1}} },
           {type="b", name="text2", x=566.9, y=510.5, kx=0, ky=0, cx=1, cy=1, z=5, text={x=567,y=490, w=141, h=38,lineType="single line",size=34,color="5a2319",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="reddot2", x=688, y=551, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn3", x=712, y=538, kx=0, ky=0, cx=0.96, cy=1, z=7, d={{name="day_btn", isArmature=1}} },
           {type="b", name="text3", x=787, y=510.5, kx=0, ky=0, cx=1, cy=1, z=8, text={x=717,y=490, w=141, h=38,lineType="single line",size=34,color="5a2319",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="reddot3", x=838, y=551, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn4", x=862, y=538, kx=0, ky=0, cx=0.96, cy=1, z=10, d={{name="day_btn", isArmature=1}} },
           {type="b", name="text4", x=937, y=510.5, kx=0, ky=0, cx=1, cy=1, z=11, text={x=867,y=490, w=141, h=38,lineType="single line",size=34,color="5a2319",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="reddot4", x=988, y=551, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="day_btn", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="choseButton", isArmature=0},{name="unchoseButton", isArmature=0}} }
         }
      },
    {type="armature", name="halfprice_ui", 
      bones={           
           {type="b", name="halfpricebg", x=0, y=474, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="halfpricebg", isArmature=0}} },
           {type="b", name="goldbg1", x=80.3, y=152.25, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="gold1", x=80.3, y=158.25, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="goldbg2", x=370.2, y=152.25, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_huobi_bg", isArmature=0}} },
           {type="b", name="gold2", x=370.2, y=158.25, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="commonCurrencyImages/common_copy_gold_bg", isArmature=0}} },
           {type="b", name="yuanjialine", x=144.3, y=134.75, kx=0, ky=0, cx=1, cy=1, z=5, text={x=149,y=116, w=186, h=36,lineType="single line",size=24,color="ff0000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="yuanjia", x=144.3, y=134.75, kx=0, ky=0, cx=1, cy=1, z=6, text={x=149,y=116, w=133, h=36,lineType="single line",size=24,color="ff0000",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="xianjia", x=428.65, y=134.75, kx=0, ky=0, cx=1, cy=1, z=7, text={x=434,y=116, w=133, h=36,lineType="single line",size=24,color="42ff00",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="buybtn", x=233, y=105.64999999999998, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="commonButtons/common_copy_red_button", isArmature=1}} },
           {type="b", name="item", x=263.8, y=358.7, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="target", x=328.5, y=38.64999999999998, kx=0, ky=0, cx=1, cy=1, z=10, text={x=133,y=5, w=393, h=34,lineType="single line",size=22,color="ffc800",alignment="center",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_red_button", 
      bones={           
           {type="b", name="common_red_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, text={x=21,y=-55, w=150, h=44,lineType="single line",size=30,color="ffedb7",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_red_button_normal", isArmature=0},{name="commonButtons/common_copy_red_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="left_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=522.95, kx=0, ky=0, cx=93, cy=129.25, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="leftbg", x=0, y=522.95, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="leftbg", isArmature=0}} },
           {type="b", name="btn1", x=4.85, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot1", x=95.85, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn2", x=127.35, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot2", x=218.35, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn3", x=247.8, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot3", x=338.8, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn4", x=4.85, y=443.9, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot4", x=95.85, y=455.9, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn5", x=127.35, y=443.9, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot5", x=218.35, y=455.9, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn6", x=247.8, y=443.9, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="days_btn", isArmature=1}} },
           {type="b", name="reddot6", x=338.8, y=455.9, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="btn7", x=5.8, y=371.9500000000001, kx=0, ky=0, cx=1, cy=1, z=14, d={{name="days7_btn", isArmature=1}} },
           {type="b", name="reddot7", x=338.8, y=383.9500000000001, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="commonImages/common_copy_redIcon", isArmature=0}} },
           {type="b", name="num1", x=47.5, y=504.9, kx=0, ky=0, cx=1, cy=1, z=16, d={{name="num1", isArmature=0}} },
           {type="b", name="num2", x=169.35, y=504.9, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="num2", isArmature=0}} },
           {type="b", name="num3", x=289.8, y=504.9, kx=0, ky=0, cx=1, cy=1, z=18, d={{name="num3", isArmature=0}} },
           {type="b", name="num4", x=47.5, y=429.9, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="num4", isArmature=0}} },
           {type="b", name="num5", x=169.35, y=429.9, kx=0, ky=0, cx=1, cy=1, z=20, d={{name="num5", isArmature=0}} },
           {type="b", name="num6", x=289.8, y=429.9, kx=0, ky=0, cx=1, cy=1, z=21, d={{name="num6", isArmature=0}} },
           {type="b", name="num7", x=51.5, y=357.95000000000005, kx=0, ky=0, cx=1, cy=1, z=22, d={{name="num7", isArmature=0}} }
         }
      },
    {type="armature", name="days_btn", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="unchosebtn", isArmature=0},{name="chosebtn", isArmature=0}} }
         }
      },
    {type="armature", name="days7_btn", 
      bones={           
           {type="b", name="图层 1", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="longNomalBtn", isArmature=0},{name="longchosebtn", isArmature=0}} }
         }
      },
    {type="armature", name="render", 
      bones={           
           {type="b", name="hit_area", x=0, y=132, kx=0, ky=0, cx=159, cy=33, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderbg", x=0, y=132, kx=0, ky=0, cx=9.32, cy=1.89, z=1, d={{name="commonPanels/common_copy_item_bg_7", isArmature=0}} },
           {type="b", name="meihua", x=388.7, y=120, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="meihua", isArmature=0}} },
           {type="b", name="target_bg", x=21.95, y=128, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="commonImages/common_copy_friendNameBg", isArmature=0}} },
           {type="b", name="target", x=218.95, y=112, kx=0, ky=0, cx=1, cy=1, z=4, text={x=55,y=94, w=393, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=53.5, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=162.65, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=6, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item3", x=271.85, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=7, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="award1", x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="award1", isArmature=0}} },
           {type="b", name="award2", x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="award2", isArmature=0}} },
           {type="b", name="award3", x=466.55, y=114, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="award3", isArmature=0}} }
         }
      },
    {type="armature", name="render 副本", 
      bones={           
           {type="b", name="hit_area", x=0, y=132, kx=0, ky=0, cx=159, cy=33, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="renderbg", x=0, y=132, kx=0, ky=0, cx=1.24, cy=0.79, z=1, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} },
           {type="b", name="target", x=31.3, y=110.75, kx=0, ky=0, cx=1, cy=1, z=2, text={x=55,y=92, w=217, h=34,lineType="single line",size=22,color="67190e",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="item1", x=50.45, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=3, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item2", x=152.7, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=4, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="item3", x=252.95, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=5, d={{name="commonGrids/common_copy_grid", isArmature=0}} },
           {type="b", name="award1", x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="award1", isArmature=0}} },
           {type="b", name="award2", x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="award2", isArmature=0}} },
           {type="b", name="award3", x=466.55, y=114, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="award3", isArmature=0}} }
         }
      },
    {type="armature", name="right_ui", 
      bones={           
           {type="b", name="common_copy_hit_area", x=0, y=474, kx=0, ky=0, cx=164.5, cy=118.5, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="render1", x=11, y=465.2, kx=0, ky=0, cx=1.24, cy=0.79, z=1, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} },
           {type="b", name="render2", x=11, y=333.2, kx=0, ky=0, cx=1.24, cy=0.79, z=2, d={{name="commonPanels/common_copy_item_bg_1", isArmature=0}} }
         }
      },
    {type="armature", name="sevendays_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_panel_1", x=82, y=674, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonPanels/common_copy_panel_1", isArmature=0}} },
           {type="b", name="bg1", x=115.4, y=600.6, kx=0, ky=0, cx=12.98, cy=6.65, z=2, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="text1", x=425.6, y=699.7, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="kaifuqitianle", isArmature=0}} },
           {type="b", name="rightbg", x=512.9, y=542.65, kx=0, ky=0, cx=8.02, cy=5.78, z=4, d={{name="commonBackgroundScalables/common_copy_background_6", isArmature=0}} },
           {type="b", name="text1bg", x=129.45, y=642.6, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonImages/common_copy_friendNameBg", isArmature=0}} },
           {type="b", name="endtime", x=326.45, y=622.6, kx=0, ky=0, cx=1, cy=1, z=6, text={x=125,y=604, w=405, h=36,lineType="single line",size=24,color="ffc800",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="text2bg", x=770.25, y=642.6, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonImages/common_copy_friendNameBg", isArmature=0}} },
           {type="b", name="lingqutime", x=967.25, y=622.6, kx=0, ky=0, cx=1, cy=1, z=8, text={x=765,y=604, w=405, h=36,lineType="single line",size=24,color="ffc800",alignment="left",space=0,textType="static"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="common_copy_close_button", x=1159.4, y=699.15, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonButtons/common_copy_close_button", isArmature=1}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_close_button", 
      bones={           
           {type="b", name="common_close_button", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0},{name="commonButtons/common_copy_close_button_down", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="button_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=550, kx=0, ky=0, cx=266, cy=138, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn1", sc=1, dl=0, f={
                {x=412, y=538, kx=0, ky=0, cx=0.96, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=416.9, y=510.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot1", sc=1, dl=0, f={
                {x=538, y=551, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn2", sc=1, dl=0, f={
                {x=562, y=538, kx=0, ky=0, cx=0.96, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2", sc=1, dl=0, f={
                {x=566.9, y=510.5, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot2", sc=1, dl=0, f={
                {x=688, y=551, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn3", sc=1, dl=0, f={
                {x=712, y=538, kx=0, ky=0, cx=0.96, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text3", sc=1, dl=0, f={
                {x=787, y=510.5, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot3", sc=1, dl=0, f={
                {x=838, y=551, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn4", sc=1, dl=0, f={
                {x=862, y=538, kx=0, ky=0, cx=0.96, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text4", sc=1, dl=0, f={
                {x=937, y=510.5, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot4", sc=1, dl=0, f={
                {x=988, y=551, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="day_btn", 
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
    {type="animation", name="halfprice_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="halfpricebg", sc=1, dl=0, f={
                {x=0, y=474, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="goldbg1", sc=1, dl=0, f={
                {x=80.3, y=152.25, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold1", sc=1, dl=0, f={
                {x=80.3, y=158.25, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="goldbg2", sc=1, dl=0, f={
                {x=370.2, y=152.25, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gold2", sc=1, dl=0, f={
                {x=370.2, y=158.25, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanjialine", sc=1, dl=0, f={
                {x=144.3, y=134.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="yuanjia", sc=1, dl=0, f={
                {x=144.3, y=134.75, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xianjia", sc=1, dl=0, f={
                {x=428.65, y=134.75, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="buybtn", sc=1, dl=0, f={
                {x=233, y=105.64999999999998, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item", sc=1, dl=0, f={
                {x=263.8, y=358.7, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target", sc=1, dl=0, f={
                {x=328.5, y=38.64999999999998, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
    {type="animation", name="left_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=522.95, kx=0, ky=0, cx=93, cy=129.25, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="leftbg", sc=1, dl=0, f={
                {x=0, y=522.95, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn1", sc=1, dl=0, f={
                {x=4.85, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot1", sc=1, dl=0, f={
                {x=95.85, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn2", sc=1, dl=0, f={
                {x=127.35, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot2", sc=1, dl=0, f={
                {x=218.35, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn3", sc=1, dl=0, f={
                {x=247.8, y=516.9000000000001, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot3", sc=1, dl=0, f={
                {x=338.8, y=528.9000000000001, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn4", sc=1, dl=0, f={
                {x=4.85, y=443.9, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot4", sc=1, dl=0, f={
                {x=95.85, y=455.9, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn5", sc=1, dl=0, f={
                {x=127.35, y=443.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot5", sc=1, dl=0, f={
                {x=218.35, y=455.9, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn6", sc=1, dl=0, f={
                {x=247.8, y=443.9, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot6", sc=1, dl=0, f={
                {x=338.8, y=455.9, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btn7", sc=1, dl=0, f={
                {x=5.8, y=371.9500000000001, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="reddot7", sc=1, dl=0, f={
                {x=338.8, y=383.9500000000001, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num1", sc=1, dl=0, f={
                {x=47.5, y=504.9, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num2", sc=1, dl=0, f={
                {x=169.35, y=504.9, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num3", sc=1, dl=0, f={
                {x=289.8, y=504.9, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num4", sc=1, dl=0, f={
                {x=47.5, y=429.9, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num5", sc=1, dl=0, f={
                {x=169.35, y=429.9, kx=0, ky=0, cx=1, cy=1, z=20, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num6", sc=1, dl=0, f={
                {x=289.8, y=429.9, kx=0, ky=0, cx=1, cy=1, z=21, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="num7", sc=1, dl=0, f={
                {x=51.5, y=357.95000000000005, kx=0, ky=0, cx=1, cy=1, z=22, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="days_btn", 
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
    {type="animation", name="days7_btn", 
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
    {type="animation", name="render", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=132, kx=0, ky=0, cx=159, cy=33, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderbg", sc=1, dl=0, f={
                {x=0, y=132, kx=0, ky=0, cx=9.32, cy=1.89, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="meihua", sc=1, dl=0, f={
                {x=388.7, y=120, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target_bg", sc=1, dl=0, f={
                {x=21.95, y=128, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target", sc=1, dl=0, f={
                {x=218.95, y=112, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=53.5, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=162.65, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=271.85, y=92.7, kx=0, ky=0, cx=0.75, cy=0.75, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award1", sc=1, dl=0, f={
                {x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award2", sc=1, dl=0, f={
                {x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award3", sc=1, dl=0, f={
                {x=466.55, y=114, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="render 副本", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=132, kx=0, ky=0, cx=159, cy=33, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="renderbg", sc=1, dl=0, f={
                {x=0, y=132, kx=0, ky=0, cx=1.24, cy=0.79, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="target", sc=1, dl=0, f={
                {x=31.3, y=110.75, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item1", sc=1, dl=0, f={
                {x=50.45, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item2", sc=1, dl=0, f={
                {x=152.7, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="item3", sc=1, dl=0, f={
                {x=252.95, y=92, kx=0, ky=0, cx=0.75, cy=0.75, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award1", sc=1, dl=0, f={
                {x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award2", sc=1, dl=0, f={
                {x=478.05, y=114, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="award3", sc=1, dl=0, f={
                {x=466.55, y=114, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="right_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_copy_hit_area", sc=1, dl=0, f={
                {x=0, y=474, kx=0, ky=0, cx=164.5, cy=118.5, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render1", sc=1, dl=0, f={
                {x=11, y=465.2, kx=0, ky=0, cx=1.24, cy=0.79, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="render2", sc=1, dl=0, f={
                {x=11, y=333.2, kx=0, ky=0, cx=1.24, cy=0.79, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="sevendays_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_panel_1", sc=1, dl=0, f={
                {x=82, y=674, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg1", sc=1, dl=0, f={
                {x=115.4, y=600.6, kx=0, ky=0, cx=12.98, cy=6.65, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1", sc=1, dl=0, f={
                {x=425.6, y=699.7, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="rightbg", sc=1, dl=0, f={
                {x=512.9, y=542.65, kx=0, ky=0, cx=8.02, cy=5.78, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text1bg", sc=1, dl=0, f={
                {x=129.45, y=642.6, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="endtime", sc=1, dl=0, f={
                {x=326.45, y=622.6, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="text2bg", sc=1, dl=0, f={
                {x=770.25, y=642.6, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lingqutime", sc=1, dl=0, f={
                {x=967.25, y=622.6, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_close_button", sc=1, dl=0, f={
                {x=1159.4, y=699.15, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
      }
  }
}
 return conf;