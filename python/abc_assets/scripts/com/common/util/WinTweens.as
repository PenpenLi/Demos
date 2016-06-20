package com.common.util
{
   import starling.display.Quad;
   import starling.display.DisplayObject;
   import starling.animation.Tween;
   import com.common.events.EventCenter;
   import starling.core.Starling;
   import starling.display.Sprite;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.MainCityMedia;
   import com.mvc.views.uis.mainCity.chat.ChatBtnUI;
   
   public class WinTweens
   {
      
      private static var rootClass:Game;
      
      private static var bg:Quad;
      
      private static const posX:int = 2;
      
      private static const posY:int = 3;
      
      public static const time:Number = 0.25;
      
      public static var isHideAll:Boolean;
       
      public function WinTweens()
      {
         super();
      }
      
      public static function initWinTween() : void
      {
         rootClass = Config.starling.root as Game;
      }
      
      public static function openWin(param1:DisplayObject, param2:Number = 0.25) : void
      {
         target = param1;
         time = param2;
         if(!Config.isOpenAni)
         {
            EventCenter.dispatchEvent("WIN_PLAY_COMPLETE");
            return;
         }
         var X:int = target.width / 2;
         var Y:int = target.height / 3;
         target.pivotX = X;
         target.pivotY = Y;
         target.x = target.x + X;
         target.y = target.y + Y;
         var t:Tween = new Tween(target,time,"easeOutBack");
         Starling.juggler.add(t);
         t.animate("scaleX",1,0);
         t.animate("scaleY",1,0);
         target.touchable = false;
         t.onComplete = function():void
         {
            target.touchable = true;
            target.pivotX = 0;
            target.pivotY = 0;
            target.x = target.x - X;
            target.y = target.y - Y;
            EventCenter.dispatchEvent("WIN_PLAY_COMPLETE");
         };
      }
      
      public static function closeWin(param1:Sprite, param2:Function) : void
      {
         target = param1;
         remove = param2;
         if(!Config.isOpenAni)
         {
            return;
            §§push(remove());
         }
         else
         {
            var X:int = target.width / 2;
            var Y:int = target.height / 3;
            target.pivotX = X;
            target.pivotY = Y;
            target.x = target.x + X;
            target.y = target.y + Y;
            target.touchable = false;
            var t:Tween = new Tween(target,0.25,"easeInBack");
            Starling.juggler.add(t);
            t.animate("scaleX",0);
            t.animate("scaleY",0);
            t.onComplete = function():void
            {
               target.touchable = true;
               target.pivotX = 0;
               target.pivotY = 0;
               target.scaleX = 1;
               target.scaleY = 1;
               target.x = target.x - X;
               target.y = target.y - Y;
            };
            return;
         }
      }
      
      public static function hideCity() : void
      {
         var _loc2_:* = 0;
         LogUtil("========================隐藏弹窗界面下所有不可见的内容");
         var _loc1_:Game = Config.starling.root as Game;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc1_.getChildAt(_loc2_).visible = false;
            _loc2_++;
         }
         isHideAll = true;
      }
      
      public static function showCity() : void
      {
         var _loc2_:* = 0;
         var _loc1_:Game = Config.starling.root as Game;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc1_.getChildAt(_loc2_).visible = true;
            LogUtil("显示" + _loc2_);
            _loc2_++;
         }
         if(_loc1_.page is MainCityUI && _loc1_.page.visible == true)
         {
            (GameFacade.getInstance().retrieveMediator("MainCityMedia") as MainCityMedia).mainCity.scene.scrollContainer.isEnabled = true;
            ChatBtnUI.getInstance().show();
         }
         GameFacade.getInstance().sendNotification("UPDATE_MAINCITYCHAT_NEWS");
         isHideAll = false;
      }
   }
}
