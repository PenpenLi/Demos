custom_input_pwd_dialog_view=
{
	name="custom_input_pwd_dialog_view",type=0,typeName="View",time=0,x=0,y=0,width=0,height=0,visible=1,fillParentWidth=1,fillParentHeight=1,nodeAlign=kAlignTopLeft,
	{
		name="custom_input_pwd_dialog_view_bg",type=1,typeName="Image",time=17143253,x=0,y=399,width=646,height=375,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTop,file="common/background/dialog_bg_2.png",gridLeft=128,gridRight=128,gridTop=128,gridBottom=128,
		{
			name="input_pwd_edit_text",type=1,typeName="Image",time=17143743,x=64,y=101,width=512,height=62,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="common/background/input_bg_2.png",gridLeft=33,gridRight=33,gridTop=0,gridBottom=0,
			{
				name="input_pwd_edit",type=6,typeName="EditText",time=96093140,x=16,y=0,width=498,height=76,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignLeft,fontSize=32,textAlign=kAlignLeft,colorRed=80,colorGreen=80,colorBlue=80,string=[[]]
			}
		},
		{
			name="pwd_error_icon",type=1,typeName="Image",time=17145196,x=583,y=119,width=18,height=19,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignTopLeft,file="drawable/input_error_icon.png"
		},
		{
			name="input_ok_btn",type=2,typeName="Button",time=24832192,x=63,y=66,width=244,height=85,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottomRight,file="common/button/dialog_btn_4_normal.png",file2="common/button/dialog_btn_4_press.png",
			{
				name="input_ok_texture",type=4,typeName="Text",time=24832330,x=0,y=0,width=120,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[确定]]
			}
		},
		{
			name="input_pwd_cancel_btn",type=2,typeName="Button",time=24832234,x=67,y=66,width=244,height=85,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignBottomLeft,file="common/button/dialog_btn_8_normal.png",file2="dialog/btn_neg_down.png",
			{
				name="input_pwd_cancel_texture",type=4,typeName="Text",time=24832290,x=0,y=0,width=120,height=70,visible=1,fillParentWidth=0,fillParentHeight=0,nodeAlign=kAlignCenter,fontSize=40,textAlign=kAlignCenter,colorRed=240,colorGreen=230,colorBlue=210,string=[[取消]]
			}
		}
	}
}