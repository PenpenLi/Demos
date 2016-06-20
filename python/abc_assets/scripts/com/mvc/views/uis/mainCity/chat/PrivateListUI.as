package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.Swf;
   import starling.core.Starling;
   import starling.animation.Tween;
   import org.puremvc.as3.patterns.facade.Facade;
   import lzm.starling.swf.display.SwfSprite;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PrivateListUI extends Sprite
   {
       
      public var chatList:List;
      
      private var swf:Swf;
      
      public function PrivateListUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         addList();
      }
      
      private function addList() : void
      {
         chatList = new List();
         chatList.width = 700;
         chatList.height = 550;
         chatList.x = 5;
         chatList.y = 60;
         addChild(chatList);
      }
      
      public function bombAni() : void
      {
         Starling.juggler.removeTweens(this);
         var _loc1_:Tween = new Tween(this,0);
         _loc1_.moveTo(0,0);
         Starling.juggler.add(_loc1_);
      }
      
      public function recoverAni() : void
      {
         Starling.juggler.removeTweens(this);
         var _loc1_:Tween = new Tween(this,0);
         _loc1_.moveTo(-500,0);
         Starling.juggler.add(_loc1_);
         _loc1_.onComplete = complete;
      }
      
      private function complete() : void
      {
         this.removeFromParent();
         Facade.getInstance().sendNotification("SHOW_CHAT_INDEX",1);
      }
      
      public function getNotReadSpr(param1:ChatVO, param2:ChatVO) : SwfSprite
      {
         var _loc3_:SwfSprite = swf.createSprite("spr_notRead");
         if(param1.notReadNum > 0)
         {
            _loc3_.getTextField("notReadNum").text = param1.notReadNum > 99?"99+":param1.notReadNum;
         }
         else
         {
            _loc3_.getImage("NotReadImg").visible = false;
         }
         _loc3_.getTextField("time").text = param2.postTime;
         return _loc3_;
      }
   }
}
