package com.mvc.views.uis.login.notice
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import lzm.util.OSUtil;
   import starling.core.Starling;
   
   public class LoginNoticeUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.login.notice.LoginNoticeUI;
       
      private var swf:Swf;
      
      private var spr_notice:SwfSprite;
      
      private var btn_close:SwfButton;
      
      public function LoginNoticeUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.login.notice.LoginNoticeUI
      {
         return instance || new com.mvc.views.uis.login.notice.LoginNoticeUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         spr_notice = swf.createSprite("spr_notice");
         btn_close = spr_notice.getButton("btn_close");
         spr_notice.y = 55;
         spr_notice.x = 135;
         addChild(spr_notice);
         btn_close.addEventListener("triggered",onClose);
      }
      
      public function onClose(param1:Event) : void
      {
         e = param1;
         LogUtil("etInstance().parent==========",getInstance().parent);
         if(getInstance().parent)
         {
            if(Game.httpView)
            {
               Game.httpView.dispose();
               Game.httpView = null;
            }
            removeFromParent(true);
            instance = null;
         }
         if(OSUtil.isIPhone())
         {
            Starling.juggler.delayCall(function():void
            {
               Pocketmon.sdkTool.login();
            },0.1);
         }
         else
         {
            Pocketmon.sdkTool.login();
         }
      }
   }
}
