local conf = {type="skeleton", name="modalDialog_ui", frameRate=24, version=1.4,
 armatures={  
    {type="armature", name="mask_ui", 
      bones={           
           {type="b", name="mask", x=646.15, y=-338.15, kx=0, ky=0, cx=1, cy=1, z=0, d={{name="mask", isArmature=0}} }
         }
      },
    {type="armature", name="modalDialog_ui", 
      bones={           
           {type="b", name="background", x=0, y=140.04999999999995, kx=0, ky=0, cx=64, cy=1, z=0, d={{name="mengban", isArmature=0}} },
           {type="b", name="background2", x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, d={{name="background2", isArmature=0}} },
           {type="b", name="name2", x=863.45, y=187.1, kx=0, ky=0, cx=1, cy=1, z=2, d={{name="name", isArmature=0}} },
           {type="b", name="name", x=-3.5, y=179.10000000000002, kx=0, ky=0, cx=1, cy=1, z=3, d={{name="name", isArmature=0}} },
           {type="b", name="nametext2", x=363, y=138, kx=0, ky=0, cx=1, cy=1, z=4, text={x=919,y=103, w=307, h=60,lineType="multiline",size=42,color="fff8d3",alignment="center",space=0,textType="dynamic"}, d={{name="kongbai", isArmature=0}} },
           {type="b", name="nametext", x=363, y=138, kx=0, ky=0, cx=1, cy=1, z=5, text={x=53,y=102, w=302, h=61,lineType="multiline",size=42,color="fff8d3",alignment="center",space=0,textType="dynamic"}, d={{name="kongbai", isArmature=0}} },
           {type="b", name="dialog_content", x=862.4, y=56.64999999999998, kx=0, ky=0, cx=1, cy=1, z=6, text={x=185,y=14, w=908, h=89,lineType="multiline",size=28,color="ffffff",alignment="left",space=0,textType="dynamic"}, d={{name="kongbai", isArmature=0}} }
         }
      }
}, 
 animations={  
    {type="animation", name="mask_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="mask", sc=1, dl=0, f={
                {x=646.15, y=-338.15, kx=0, ky=0, cx=1, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            }
           }
         },
     {name="f2", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           }
         }
        }
      },
    {type="animation", name="modalDialog_ui", 
      mov={
     {name="f1", dr=1, to=0, twdr=NaN, lp=NaN, twe=NaN, b={
           {name="background", sc=1, dl=0, f={
                {x=0, y=140.04999999999995, kx=0, ky=0, cx=64, cy=1, z=0, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="background2", sc=1, dl=0, f={
                {x=0, y=720, kx=0, ky=0, cx=1, cy=1, z=1, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name2", sc=1, dl=0, f={
                {x=863.45, y=187.1, kx=0, ky=0, cx=1, cy=1, z=2, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="name", sc=1, dl=0, f={
                {x=-3.5, y=179.10000000000002, kx=0, ky=0, cx=1, cy=1, z=3, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nametext2", sc=1, dl=0, f={
                {x=363, y=138, kx=0, ky=0, cx=1, cy=1, z=4, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="nametext", sc=1, dl=0, f={
                {x=363, y=138, kx=0, ky=0, cx=1, cy=1, z=5, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
             }
            },
           {name="dialog_content", sc=1, dl=0, f={
                {x=862.4, y=56.64999999999998, kx=0, ky=0, cx=1, cy=1, z=6, di=0, dr=1, twe=NaN, twr=0, mv=nil, vi=1, evt=nil}
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