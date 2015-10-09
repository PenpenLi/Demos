local conf = {type="skeleton", name="hero_house_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="heroAsserts/otherImgs", 
      bones={           
           {type="b", name="图层 8", x=66.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="simple_grade_1", isArmature=0}} },
           {type="b", name="图层 9", x=114.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="simple_grade_2", isArmature=0}} },
           {type="b", name="图层 10", x=168.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="simple_grade_3", isArmature=0}} },
           {type="b", name="图层 11", x=220.85, y=622.75, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="simple_grade_4", isArmature=0}} },
           {type="b", name="图层 12", x=276.9, y=622.75, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="simple_grade_5", isArmature=0}} },
           {type="b", name="图层 13", x=324.9, y=626.75, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="simple_grade_6", isArmature=0}} },
           {type="b", name="图层 14", x=53.4, y=560.85, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="simple_grade_line_1", isArmature=0}} },
           {type="b", name="图层 15", x=37.4, y=522.85, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="simple_grade_line_2", isArmature=0}} },
           {type="b", name="图层 16", x=65.35, y=488.85, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="simple_grade_line_3", isArmature=0}} },
           {type="b", name="图层 17", x=85.35, y=442.9, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="simple_grade_line_4", isArmature=0}} },
           {type="b", name="图层 18", x=101.35, y=414.9, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="simple_grade_line_5", isArmature=0}} },
           {type="b", name="图层 19", x=121.35, y=386.9, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="simple_grade_line_6", isArmature=0}} },
           {type="b", name="图层 24", x=316.9, y=361.85, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="xiaozi_bg", isArmature=0}} }
         }
      },
    {type="armature", name="heroHouse_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonImages/common_copy_hit_area", isArmature=0}} },
           {type="b", name="cardCon", x=70.95, y=624.95, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="title", x=540.5, y=71.35000000000002, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="yeqian_bg", isArmature=0}} },
           {type="b", name="pageTF", x=563.8, y=56.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, text={x=553,y=19, w=175, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="heroNumTF", x=84.95, y=675, kx=0, ky=0, cx=1, cy=1, z=4, text={x=85,y=644, w=300, h=41,lineType="single line",size=28,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="close_button", x=1178, y=706, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="commonButtons/common_copy_close_button_normal", isArmature=0}} },
           {type="b", name="common_copy_rightArrow_button", x=1186, y=410.5, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="commonSingleImgButtons/common_copy_rightArrow_button", isArmature=0}} },
           {type="b", name="common_copy_leftArrow_button", x=0, y=410.5, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="commonSingleImgButtons/common_copy_leftArrow_button", isArmature=0}} }
         }
      },
    {type="armature", name="heroHouseRender/heroCardRender", 
      bones={           
           {type="b", name="cardCon", x=15.95, y=577.9499999999999, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="hero_card_fg", x=0, y=591.05, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="hero_card_fg", isArmature=0}} },
           {type="b", name="grade_descb", x=133, y=164.59999999999997, kx=0, ky=0, cx=1, cy=1, z=2, text={x=119,y=139, w=44, h=36,lineType="single line",size=24,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="level_descb", x=83, y=104.34999999999997, kx=0, ky=0, cx=1, cy=1, z=3, text={x=38,y=78, w=117, h=36,lineType="single line",size=24,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="hero_card_mask", x=17.5, y=573.55, kx=0, ky=0, cx=9.44, cy=34.69, z=4, d={{name="hero_card_mask", isArmature=0}} },
           {type="b", name="progress_bar", x=33, y=221.04999999999995, kx=0, ky=0, cx=0.68, cy=1, z=5, d={{name="commonProgressBar/common_copy_blue_progress_bar", isArmature=1}} },
           {type="b", name="progress_descb", x=83.85, y=211.69999999999993, kx=0, ky=0, cx=1, cy=1, z=6, text={x=36,y=189, w=128, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="name_descb", x=75, y=247.4, kx=0, ky=0, cx=1, cy=1, z=7, text={x=36,y=221, w=128, h=36,lineType="single line",size=24,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="commonImages/common_copy_button_bg", isArmature=0}} },
           {type="b", name="kejihuo_img", x=32.5, y=377.1, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="kejihuo_img", isArmature=0}} },
           {type="b", name="effect", x=142.35, y=592.0999999999999, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="commonImages/common_copy_redIcon", isArmature=0}} }
         }
      },
    {type="armature", name="commonProgressBar/common_copy_blue_progress_bar", 
      bones={           
           {type="b", name="common_blue_progress_bar_bg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="commonProgressBar/common_copy_blue_progress_bar_bg", isArmature=0}} },
           {type="b", name="common_blue_progress_bar_fg", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="commonProgressBar/common_copy_blue_progress_bar_fg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="heroAsserts/otherImgs", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 8", sc=1, dl=0, f={
                {x=66.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 9", sc=1, dl=0, f={
                {x=114.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 10", sc=1, dl=0, f={
                {x=168.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 11", sc=1, dl=0, f={
                {x=220.85, y=622.75, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 12", sc=1, dl=0, f={
                {x=276.9, y=622.75, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 13", sc=1, dl=0, f={
                {x=324.9, y=626.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 14", sc=1, dl=0, f={
                {x=53.4, y=560.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 15", sc=1, dl=0, f={
                {x=37.4, y=522.85, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 16", sc=1, dl=0, f={
                {x=65.35, y=488.85, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 17", sc=1, dl=0, f={
                {x=85.35, y=442.9, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 18", sc=1, dl=0, f={
                {x=101.35, y=414.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 19", sc=1, dl=0, f={
                {x=121.35, y=386.9, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 24", sc=1, dl=0, f={
                {x=316.9, y=361.85, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="图层 8", sc=1, dl=0, f={
                {x=66.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 9", sc=1, dl=0, f={
                {x=114.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 10", sc=1, dl=0, f={
                {x=168.95, y=622.75, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 11", sc=1, dl=0, f={
                {x=220.85, y=622.75, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 12", sc=1, dl=0, f={
                {x=276.9, y=622.75, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 13", sc=1, dl=0, f={
                {x=324.9, y=626.75, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 14", sc=1, dl=0, f={
                {x=53.4, y=560.85, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 15", sc=1, dl=0, f={
                {x=37.4, y=522.85, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 16", sc=1, dl=0, f={
                {x=65.35, y=488.85, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 17", sc=1, dl=0, f={
                {x=85.35, y=442.9, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 18", sc=1, dl=0, f={
                {x=101.35, y=414.9, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 19", sc=1, dl=0, f={
                {x=121.35, y=386.9, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="图层 24", sc=1, dl=0, f={
                {x=316.9, y=361.85, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="heroHouse_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="cardCon", sc=1, dl=0, f={
                {x=70.95, y=624.95, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="title", sc=1, dl=0, f={
                {x=540.5, y=71.35000000000002, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pageTF", sc=1, dl=0, f={
                {x=563.8, y=56.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="heroNumTF", sc=1, dl=0, f={
                {x=84.95, y=675, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="close_button", sc=1, dl=0, f={
                {x=1178, y=706, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_rightArrow_button", sc=1, dl=0, f={
                {x=1186, y=410.5, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_leftArrow_button", sc=1, dl=0, f={
                {x=0, y=410.5, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="heroHouseRender/heroCardRender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="cardCon", sc=1, dl=0, f={
                {x=15.95, y=577.9499999999999, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_card_fg", sc=1, dl=0, f={
                {x=0, y=591.05, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="grade_descb", sc=1, dl=0, f={
                {x=133, y=164.59999999999997, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="level_descb", sc=1, dl=0, f={
                {x=83, y=104.34999999999997, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="hero_card_mask", sc=1, dl=0, f={
                {x=17.5, y=573.55, kx=0, ky=0, cx=9.44, cy=34.69, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress_bar", sc=1, dl=0, f={
                {x=33, y=221.04999999999995, kx=0, ky=0, cx=0.68, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="progress_descb", sc=1, dl=0, f={
                {x=83.85, y=211.69999999999993, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name_descb", sc=1, dl=0, f={
                {x=75, y=247.4, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="kejihuo_img", sc=1, dl=0, f={
                {x=32.5, y=377.1, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effect", sc=1, dl=0, f={
                {x=142.35, y=592.0999999999999, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="commonProgressBar/common_copy_blue_progress_bar", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_progress_bar_bg", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_blue_progress_bar_fg", sc=1, dl=0, f={
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