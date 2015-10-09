local conf = {type="skeleton", name="small_chat_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="small_chat_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=71, kx=0, ky=0, cx=86.25, cy=17.75, z=0, d={{name="common_copy_hit_area", isArmature=0}} },
           {type="b", name="small_chat_ui_bg", x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="small_chat_ui_bg", isArmature=0}} },
           {type="b", name="common_copy_button_bg_1", x=20.5, y=57.5, kx=0, ky=0, cx=1, cy=1, z=2, text={x=17,y=10, w=312, h=59,lineType="single line",size=20,color="ffffff",alignment="left",space=0,textType="static"}, d={{name="common_copy_button_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="small_chat_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=86.25, cy=17.75, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="small_chat_ui_bg", sc=1, dl=0, f={
                {x=0, y=71, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="common_copy_button_bg_1", sc=1, dl=0, f={
                {x=20.5, y=57.5, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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