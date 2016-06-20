package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.huntingParty.BuffVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class BuffUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var buffImg:SwfImage;
      
      private var touchBg:SwfImage;
      
      private var _buffVo:BuffVO;
      
      public function BuffUnit(param1:BuffVO)
      {
         super();
         _buffVo = param1;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         buffImg = swf.createImage("img_buff" + param1.id);
         touchBg = swf.createImage("img_icon_light");
         var _loc2_:* = -14;
         touchBg.y = _loc2_;
         touchBg.x = _loc2_;
         addChild(touchBg);
         touchBg.visible = false;
         _loc2_ = 1.25;
         touchBg.scaleY = _loc2_;
         touchBg.scaleX = _loc2_;
         addChild(buffImg);
         this.addEventListener("touch",touch);
      }
      
      private function touch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               touchBg.visible = true;
               BuffDescUI.getInstance().showInfo(_buffVo.desc,this);
            }
            if(_loc2_.phase == "ended")
            {
               touchBg.visible = false;
               BuffDescUI.getInstance().remove();
            }
         }
      }
   }
}
