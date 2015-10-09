local conf = {type="skeleton", name="getReward_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="getReward_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="common_copy_line_down1", x=0, y=240, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="common_copy_line_down", isArmature=0}} },
           {type="b", name="common_copy_line_down2", x=0, y=480, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="common_copy_line_down", isArmature=0}} },
           {type="b", name="yingxiongkaiqi", x=449, y=545, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="yingxiongkaiqi", isArmature=0}} }
         }
      }
}, 
 animations={  
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
            },
           {name="yingxiongkaiqi", sc=1, dl=0, f={
                {x=449, y=545, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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