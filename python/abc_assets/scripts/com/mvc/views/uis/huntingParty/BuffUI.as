package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfScale9Image;
   import feathers.controls.List;
   import feathers.layout.VerticalLayout;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import lzm.util.TimeUtil;
   import starling.display.Quad;
   
   public class BuffUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_buff:SwfSprite;
      
      public var time:TextField;
      
      public var diaTxt:TextField;
      
      public var btn_close:SwfButton;
      
      public var btn_invoke:SwfButton;
      
      public var bg9:SwfScale9Image;
      
      public var buffList:List;
      
      public var btn_f5:SwfButton;
      
      private var buffImg:com.mvc.views.uis.huntingParty.BuffUnit;
      
      private var desc:TextField;
      
      public function BuffUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function addList() : void
      {
         buffList = new List();
         buffList.x = bg9.x;
         buffList.y = bg9.y + 3;
         buffList.width = bg9.width;
         buffList.height = bg9.height - 6;
         buffList.isSelectable = false;
         buffList.itemRendererProperties.stateToSkinFunction = null;
         spr_buff.addChild(buffList);
         buffList.addEventListener("creationComplete",creatComplete);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = -30;
         _loc1_.paddingBottom = -20;
         buffList.layout = _loc1_;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_buff = swf.createSprite("spr_buff");
         time = spr_buff.getTextField("time");
         diaTxt = spr_buff.getTextField("diaTxt");
         diaTxt.text = "200";
         btn_close = spr_buff.getButton("btn_close");
         btn_invoke = spr_buff.getButton("btn_invoke");
         btn_f5 = spr_buff.getButton("btn_f5");
         bg9 = spr_buff.getScale9Image("bg9");
         desc = spr_buff.getTextField("desc");
         spr_buff.x = 1136 - spr_buff.width >> 1;
         spr_buff.y = 640 - spr_buff.height >> 1;
         addChild(spr_buff);
      }
      
      public function setInfo() : void
      {
         if(buffImg)
         {
            buffImg.removeFromParent(true);
         }
         if(HuntPartyVO.buffObj)
         {
            switchState(false);
            buffImg = new com.mvc.views.uis.huntingParty.BuffUnit(HuntPartyVO.buffObj);
            buffImg.pivotX = buffImg.width / 2;
            buffImg.pivotY = buffImg.height / 2;
            var _loc1_:* = 1.2;
            buffImg.scaleY = _loc1_;
            buffImg.scaleX = _loc1_;
            buffImg.x = 243;
            buffImg.y = 327;
            spr_buff.addChild(buffImg);
            desc.text = HuntPartyVO.buffObj.desc;
            LogUtil("desc.text=",desc.text);
         }
         else
         {
            switchState(true);
         }
      }
      
      public function updateTime() : void
      {
         time.text = "剩余时间:" + TimeUtil.convertStringToDate(HuntPartyVO.buffObj.time);
      }
      
      public function switchState(param1:Boolean) : void
      {
         btn_invoke.visible = param1;
         btn_f5.visible = !param1;
         time.visible = !param1;
      }
   }
}
