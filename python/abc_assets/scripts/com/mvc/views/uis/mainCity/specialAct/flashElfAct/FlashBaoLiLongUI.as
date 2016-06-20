package com.mvc.views.uis.mainCity.specialAct.flashElfAct
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.Label;
   import feathers.controls.Button;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.mainCity.specialAct.flashElfAct.FlashBaoLiLongMediator;
   import com.common.managers.LoadSwfAssetsManager;
   import flash.text.TextFormat;
   
   public class FlashBaoLiLongUI extends Sprite
   {
       
      public var btn_close:SwfButton;
      
      public var tf_countDown:Label;
      
      public var btn_get:Button;
      
      private var serverId:int;
      
      public function FlashBaoLiLongUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("act_flash" + FlashBaoLiLongMediator.bgFlag));
         addChild(_loc1_);
         var _loc2_:* = 310;
         var _loc3_:* = 230;
         if(FlashBaoLiLongMediator.bgFlag == 1)
         {
            _loc2_ = 285;
            _loc3_ = 168;
         }
         else if(FlashBaoLiLongMediator.bgFlag == 2 || FlashBaoLiLongMediator.bgFlag == 3)
         {
            _loc2_ = 310;
            _loc3_ = 230;
         }
         btn_close = LoadSwfAssetsManager.getInstance().assets.getSwf("common").createButton("btn_close_b");
         btn_close.x = 1060;
         btn_close.y = 10;
         addChild(btn_close);
         var _loc4_:TextFormat = new TextFormat("FZCuYuan-M03S",25,16772608);
         tf_countDown = new Label();
         tf_countDown.x = _loc2_;
         tf_countDown.y = _loc3_;
         tf_countDown.textRendererProperties.textFormat = _loc4_;
         tf_countDown.textRendererProperties.isHTML = true;
         tf_countDown.text = "";
         addChild(tf_countDown);
         btn_get = new Button();
         btn_get.x = 202;
         btn_get.y = 550;
         btn_get.label = "领取";
         btn_get.isEnabled = false;
         btn_get.addEventListener("creationComplete",setBtn);
         addChild(btn_get);
      }
      
      private function setBtn() : void
      {
         btn_get.disabledLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",30,5855063,true);
         btn_get.maxHeight = 60;
         btn_get.minWidth = 110;
         btn_get.minTouchHeight = 60;
         btn_get.paddingTop = 5;
      }
   }
}
