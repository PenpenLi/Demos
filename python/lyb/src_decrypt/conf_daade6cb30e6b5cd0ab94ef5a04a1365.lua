local conf = {type="skeleton", name="battleOver_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="batte_over_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="pageTmp", x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="zzBtn", x=1118.95, y=460, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/zzBtn", isArmature=0}} },
           {type="b", name="fhBtn", x=1117.9, y=129.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/fhBtn", isArmature=0}} }
         }
      },
    {type="armature", name="commonButtons/common_copy_blue_button", 
      bones={           
           {type="b", name="common_blue_button", x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, text={x=8,y=14, w=150, h=44,lineType="single line",size=30,color="ffffff",alignment="center",space=0,textType="static"}, d={{name="commonButtons/common_copy_blue_button_normal", isArmature=0},{name="commonButtons/common_copy_blue_button_down", isArmature=0}} }
         }
      },
    {type="armature", name="headRender", 
      bones={           
           {type="b", name="hit_area", x=-100, y=202.15, kx=0, ky=0, cx=50.1, cy=49.44, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="effectTmp", x=-2.45, y=92.35, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="bg", x=-72.2, y=160.8, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/headBg", isArmature=0}} },
           {type="b", name="bgE", x=-85.95, y=170.8, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/headBgE", isArmature=0}} },
           {type="b", name="headTmp", x=-82.85, y=43.95000000000002, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="prgBg", x=-75.3, y=65.20000000000002, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/prgBg", isArmature=0}} },
           {type="b", name="jdB", x=-71.35, y=50.45000000000002, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/jdB", isArmature=0}} },
           {type="b", name="jd", x=-71.35, y=50.45000000000002, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/jd", isArmature=0}} },
           {type="b", name="expTF", x=55.5, y=1, kx=0, ky=0, cx=1, cy=1, z=8, text={x=-50,y=0, w=104, h=31,lineType="multiline",size=20,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="lvTF", x=63.8, y=81.35000000000001, kx=0, ky=0, cx=1, cy=1, z=9, text={x=7,y=44, w=73, h=31,lineType="multiline",size=20,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="effectXTmp", x=0.55, y=198.35, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="lvup", x=-96.7, y=128.8, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="component/lvup", isArmature=0}} }
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
           {type="b", name="countTF", x=37.1, y=-31.15000000000001, kx=0, ky=0, cx=1, cy=1, z=8, text={x=-51,y=-31, w=92, h=26,lineType="multiline",size=16,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="nameTF", x=-60.9, y=-32.150000000000006, kx=0, ky=0, cx=1, cy=1, z=9, text={x=-66,y=-64, w=133, h=31,lineType="multiline",size=20,color="ffffff",alignment="center",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="typeTF", x=41.95, y=21, kx=0, ky=0, cx=1, cy=1, z=10, text={x=-41,y=18, w=82, h=31,lineType="multiline",size=20,color="ffffff",alignment="right",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="effectTmp", x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="sb_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="itemTmp", x=638.8, y=126.20000000000005, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="line", x=378.45, y=236.15, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/line", isArmature=0}} },
           {type="b", name="jiantou", x=612.8, y=314.65, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/jiantou", isArmature=0}} },
           {type="b", name="btnTmp", x=637.8, y=316.2, kx=0, ky=0, cx=1, cy=1, z=4, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="sb", x=481.95, y=694.55, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/sb", isArmature=0}} },
           {type="b", name="ttlTF", x=768.8, y=371.15, kx=0, ky=0, cx=1, cy=1, z=6, text={x=368,y=108, w=537, h=105,lineType="multiline",size=30,color="ffa500",alignment="center",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} }
         }
      },
    {type="armature", name="sl_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="component/common_hit_area", isArmature=0}} },
           {type="b", name="line1", x=341.45, y=308.15, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="component/line", isArmature=0}} },
           {type="b", name="effectTmp", x=0, y=364.95, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="zJJYBg", x=301.3, y=492.15, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="component/zJJYBg", isArmature=0}} },
           {type="b", name="zJJYTF", x=316.8, y=481.15, kx=0, ky=0, cx=1, cy=1, z=4, text={x=318,y=438, w=438, h=41,lineType="multiline",size=26,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="lvup", x=763.3, y=483.65, kx=0, ky=0, cx=1, cy=1, z=5, d={{name="component/lvup", isArmature=0}} },
           {type="b", name="Star_b_3", x=802.95, y=244.65, kx=0, ky=0, cx=1, cy=1, z=6, d={{name="component/Star_b", isArmature=0}} },
           {type="b", name="Star_3", x=802.95, y=244.65, kx=0, ky=0, cx=1, cy=1, z=7, d={{name="component/Star", isArmature=0}} },
           {type="b", name="Star_b_2", x=601.95, y=278.65, kx=0, ky=0, cx=1, cy=1, z=8, d={{name="component/Star_b", isArmature=0}} },
           {type="b", name="Star_2", x=601.95, y=280.65, kx=0, ky=0, cx=1, cy=1, z=9, d={{name="component/Star", isArmature=0}} },
           {type="b", name="Star_b_1", x=395, y=244.65, kx=0, ky=0, cx=1, cy=1, z=10, d={{name="component/Star_b", isArmature=0}} },
           {type="b", name="Star_1", x=394, y=245.65, kx=0, ky=0, cx=1, cy=1, z=11, d={{name="component/Star", isArmature=0}} },
           {type="b", name="gnlTmp", x=603.8, y=301.15, kx=0, ky=0, cx=1, cy=1, z=12, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="itemTmp", x=606.8, y=187.20000000000005, kx=0, ky=0, cx=1, cy=1, z=13, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="msgTF_3", x=348.8, y=102.14999999999998, kx=0, ky=0, cx=1, cy=1, z=14, text={x=350,y=59, w=710, h=41,lineType="multiline",size=28,color="ffc600",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="xingImg_3", x=300.3, y=98.64999999999998, kx=0, ky=0, cx=1, cy=1, z=15, d={{name="component/xingImg", isArmature=0}} },
           {type="b", name="msgTF_2", x=348.8, y=161.14999999999998, kx=0, ky=0, cx=1, cy=1, z=16, text={x=350,y=118, w=710, h=41,lineType="multiline",size=28,color="ffc600",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="xingImg_2", x=300.3, y=158.64999999999998, kx=0, ky=0, cx=1, cy=1, z=17, d={{name="component/xingImg", isArmature=0}} },
           {type="b", name="msgTF_1", x=348.8, y=218.15, kx=0, ky=0, cx=1, cy=1, z=18, text={x=350,y=175, w=710, h=41,lineType="multiline",size=28,color="ffc600",alignment="left",space=0,textType="dynamic"}, d={{name="component/placeholder", isArmature=0}} },
           {type="b", name="xingImg_1", x=300.3, y=216.65, kx=0, ky=0, cx=1, cy=1, z=19, d={{name="component/xingImg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="batte_over_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=721, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="pageTmp", sc=1, dl=0, f={
                {x=0, y=1, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zzBtn", sc=1, dl=0, f={
                {x=1118.95, y=460, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="fhBtn", sc=1, dl=0, f={
                {x=1117.9, y=129.14999999999998, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="touch", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=1, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="disable", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="common_blue_button", sc=1, dl=0, f={
                {x=0, y=68, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         }
        }
      },
    {type="animation", name="headRender", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=-100, y=202.15, kx=0, ky=0, cx=50.1, cy=49.44, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effectTmp", sc=1, dl=0, f={
                {x=-2.45, y=92.35, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bg", sc=1, dl=0, f={
                {x=-72.2, y=160.8, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="bgE", sc=1, dl=0, f={
                {x=-85.95, y=170.8, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="headTmp", sc=1, dl=0, f={
                {x=-82.85, y=43.95000000000002, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="prgBg", sc=1, dl=0, f={
                {x=-75.3, y=65.20000000000002, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jdB", sc=1, dl=0, f={
                {x=-71.35, y=50.45000000000002, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jd", sc=1, dl=0, f={
                {x=-71.35, y=50.45000000000002, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="expTF", sc=1, dl=0, f={
                {x=55.5, y=1, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lvTF", sc=1, dl=0, f={
                {x=63.8, y=81.35000000000001, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effectXTmp", sc=1, dl=0, f={
                {x=0.55, y=198.35, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lvup", sc=1, dl=0, f={
                {x=-96.7, y=128.8, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
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
                {x=37.1, y=-31.15000000000001, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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
           {name="effectTmp", sc=1, dl=0, f={
                {x=0, y=0, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="sb_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=638.8, y=126.20000000000005, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line", sc=1, dl=0, f={
                {x=378.45, y=236.15, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="jiantou", sc=1, dl=0, f={
                {x=612.8, y=314.65, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="btnTmp", sc=1, dl=0, f={
                {x=637.8, y=316.2, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="sb", sc=1, dl=0, f={
                {x=481.95, y=694.55, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="ttlTF", sc=1, dl=0, f={
                {x=768.8, y=371.15, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="sl_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="line1", sc=1, dl=0, f={
                {x=341.45, y=308.15, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="effectTmp", sc=1, dl=0, f={
                {x=0, y=364.95, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zJJYBg", sc=1, dl=0, f={
                {x=301.3, y=492.15, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="zJJYTF", sc=1, dl=0, f={
                {x=316.8, y=481.15, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="lvup", sc=1, dl=0, f={
                {x=763.3, y=483.65, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_b_3", sc=1, dl=0, f={
                {x=802.95, y=244.65, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_3", sc=1, dl=0, f={
                {x=802.95, y=244.65, kx=0, ky=0, cx=1, cy=1, z=7, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_b_2", sc=1, dl=0, f={
                {x=601.95, y=278.65, kx=0, ky=0, cx=1, cy=1, z=8, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_2", sc=1, dl=0, f={
                {x=601.95, y=280.65, kx=0, ky=0, cx=1, cy=1, z=9, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_b_1", sc=1, dl=0, f={
                {x=395, y=244.65, kx=0, ky=0, cx=1, cy=1, z=10, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="Star_1", sc=1, dl=0, f={
                {x=394, y=245.65, kx=0, ky=0, cx=1, cy=1, z=11, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="gnlTmp", sc=1, dl=0, f={
                {x=603.8, y=301.15, kx=0, ky=0, cx=1, cy=1, z=12, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="itemTmp", sc=1, dl=0, f={
                {x=606.8, y=187.20000000000005, kx=0, ky=0, cx=1, cy=1, z=13, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msgTF_3", sc=1, dl=0, f={
                {x=348.8, y=102.14999999999998, kx=0, ky=0, cx=1, cy=1, z=14, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xingImg_3", sc=1, dl=0, f={
                {x=300.3, y=98.64999999999998, kx=0, ky=0, cx=1, cy=1, z=15, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msgTF_2", sc=1, dl=0, f={
                {x=348.8, y=161.14999999999998, kx=0, ky=0, cx=1, cy=1, z=16, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xingImg_2", sc=1, dl=0, f={
                {x=300.3, y=158.64999999999998, kx=0, ky=0, cx=1, cy=1, z=17, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="msgTF_1", sc=1, dl=0, f={
                {x=348.8, y=218.15, kx=0, ky=0, cx=1, cy=1, z=18, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="xingImg_1", sc=1, dl=0, f={
                {x=300.3, y=216.65, kx=0, ky=0, cx=1, cy=1, z=19, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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