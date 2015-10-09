local conf = {type="skeleton", name="functionOpen_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="functionOpen_ui", 
      bones={           
           {type="b", name="hit_area", x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, d={{name="commonBackgrounds/common_copy_hit_area", isArmature=0}} },
           {type="b", name="newFunctionOpen_bg", x=529.3, y=501.5, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="newFunctionOpen_bg", isArmature=0}} },
           {type="b", name="light_bg", x=400.45, y=460, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="light_bg", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="functionOpen_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="hit_area", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=320, cy=180, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="newFunctionOpen_bg", sc=1, dl=0, f={
                {x=529.3, y=501.5, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="light_bg", sc=1, dl=0, f={
                {x=400.45, y=460, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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