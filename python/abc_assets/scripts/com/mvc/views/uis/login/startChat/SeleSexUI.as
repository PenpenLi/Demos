package com.mvc.views.uis.login.startChat
{
   import starling.display.Sprite;
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.common.util.dialogue.StartDialogue;
   
   public class SeleSexUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.login.startChat.SeleSexUI;
       
      private var manImg:Image;
      
      private var womanImg:Image;
      
      private var swf:Swf;
      
      private var bg:Quad;
      
      public function SeleSexUI()
      {
         super();
      }
      
      public static function getInstance() : com.mvc.views.uis.login.startChat.SeleSexUI
      {
         return instance || new com.mvc.views.uis.login.startChat.SeleSexUI();
      }
      
      public function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("startChat");
         manImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("player01"));
         manImg.x = 1136;
         manImg.y = 75;
         manImg.name = "1";
         addChild(manImg);
         var _loc1_:Tween = new Tween(manImg,0.5,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("x",300);
         womanImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("player04"));
         womanImg.y = 75;
         womanImg.x = -200;
         womanImg.name = "0";
         addChild(womanImg);
         var _loc2_:Tween = new Tween(womanImg,0.5,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("x",600);
         this.addEventListener("touch",seleSex);
      }
      
      private function seleSex(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc3_:Touch = param1.getTouch(param1.target as Image);
         if(_loc3_)
         {
            if(_loc3_.phase == "ended")
            {
               PlayerVO.sex = (param1.target as Image).name;
               _loc2_ = "";
               if(PlayerVO.sex == 0)
               {
                  _loc2_ = "女";
               }
               else
               {
                  _loc2_ = "男";
               }
               _loc4_ = Alert.show("你确定选择【" + _loc2_ + "】性别么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc4_.addEventListener("close",seleSexSureHandler);
            }
         }
      }
      
      private function seleSexSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            if(PlayerVO.sex == 0)
            {
               PlayerVO.headPtId = 100004;
               PlayerVO.trainPtId = 100004;
            }
            else
            {
               PlayerVO.headPtId = 100001;
               PlayerVO.trainPtId = 100001;
            }
            remove();
            StartDialogue.getInstance().playDialogue();
         }
      }
      
      public function remove() : void
      {
         manImg.texture.dispose();
         manImg.removeFromParent();
         manImg = null;
         womanImg.texture.dispose();
         womanImg.removeFromParent();
         womanImg = null;
         bg.removeFromParent();
         this.removeFromParent(true);
      }
   }
}
