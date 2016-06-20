package com.mvc.views.uis.mainCity.specialAct.actPreview
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class ActPreviewUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_actPreview:SwfSprite;
      
      public var spr_check:SwfSprite;
      
      public var btn_yes:SwfButton;
      
      public function ActPreviewUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_actPreview = swf.createSprite("spr_actPreview");
         spr_actPreview.x = 1136 - spr_actPreview.width >> 1;
         spr_actPreview.y = 640 - spr_actPreview.height >> 1;
         addChild(spr_actPreview);
         spr_check = spr_actPreview.getSprite("spr_check");
         spr_check.getChildAt(1).visible = false;
         spr_check.addEventListener("touch",spr_check_touchHandler);
         btn_yes = spr_actPreview.getButton("btn_yes");
         btn_yes.visible = false;
      }
      
      private function spr_check_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_check);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            spr_check.getChildAt(1).visible = !spr_check.getChildAt(1).visible;
         }
      }
   }
}
