daily_sign_dialog=
{
	name="daily_sign_dialog",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignCenter,
	{
		name="add_icon",type=1,typeName="Image",time=112439901,x=0,y=-28,width=36,height=36,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,file="common/button/add_btn.png"
	},
	{
		name="sign_title",type=1,typeName="Image",time=103174558,x=0,y=371,width=349,height=77,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="dailytask/normal_title.png"
	},
	{
		name="btn1",type=2,typeName="Button",time=103174649,x=0,y=837,width=244,height=85,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/button/dialog_btn_4_normal.png",file2="common/button/dialog_btn_4_press.png",
		{
			name="text",type=4,typeName="Text",time=103174721,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=38,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[领取]]
		}
	},
	{
		name="vip_time",type=0,typeName="View",time=103175163,x=4,y=883,width=248,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,
		{
			name="text",type=4,typeName="Text",time=103175184,x=0,y=0,width=200,height=150,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=28,textAlign=kAlignLeft,colorRed=240,colorGreen=230,colorBlue=210,string=[[会员剩余天数:]]
		},
		{
			name="time",type=4,typeName="Text",time=103175409,x=-40,y=0,width=100,height=40,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignRight,fontSize=28,textAlign=kAlignLeft,colorRed=80,colorGreen=215,colorBlue=60,string=[[0天]]
		}
	},
	{
		name="item_view",type=0,typeName="View",time=112446650,x=0,y=0,width=349,height=320,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter
	}
}