forestall_dialog_view=
{
	name="forestall_dialog_view",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="forestall_full_screen_bg",type=1,typeName="Image",time=15580215,x=0,y=0,width=480,height=800,visible=0,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="drawable/transparent_blank.png"
	},
	{
		name="forestall_content_view",type=0,typeName="View",time=15580274,x=0,y=0,width=656,height=364,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,
		{
			name="Image1",type=1,typeName="Image",time=97842042,x=0,y=0,width=480,height=33,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,file="common/background/dialog_bg_3.png",gridLeft=128,gridRight=128,gridTop=128,gridBottom=128
		},
		{
			name="forestall_cancel_btn",type=2,typeName="Button",time=24821010,x=0,y=189,width=571,height=97,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/button/dialog_btn_6_normal.png",file2="common/button/dialog_btn_6_press.png",gridLeft=64,gridRight=64,gridTop=0,gridBottom=0,
			{
				name="forestall_cancel_text",type=4,typeName="Text",time=24821121,x=0,y=0,width=170,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=38,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[不抢]]
			}
		},
		{
			name="forestall_sure_btn",type=2,typeName="Button",time=24821189,x=0,y=55,width=571,height=97,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/button/dialog_btn_2_normal.png",file2="common/button/dialog_btn_2_press.png",gridLeft=64,gridRight=64,gridTop=0,gridBottom=0,
			{
				name="forestall_sure_text",type=4,typeName="Text",time=24821250,x=0,y=0,width=497,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=38,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[抢先行]]
			}
		}
	}
}