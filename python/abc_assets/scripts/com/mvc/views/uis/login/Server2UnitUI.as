package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import com.mvc.models.vos.login.ServerVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class Server2UnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_myServer:SwfSprite;
      
      private var lv:TextField;
      
      private var playerName:TextField;
      
      private var vip:TextField;
      
      private var _serverVo:ServerVO;
      
      public var index:int;
      
      private var serverName:TextField;
      
      public function Server2UnitUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         spr_myServer = swf.createSprite("spr_myServer");
         lv = spr_myServer.getTextField("lv");
         playerName = spr_myServer.getTextField("palyerName");
         vip = spr_myServer.getTextField("vip");
         serverName = spr_myServer.getTextField("serverName");
         vip.fontName = "img_serverVIP";
         addChild(spr_myServer);
      }
      
      public function set myServerVo(param1:ServerVO) : void
      {
         _serverVo = param1;
         var _loc2_:Image = GetPlayerRelatedPicFactor.getHeadPic(param1.headId,0.81);
         _loc2_.x = 48;
         spr_myServer.addChildAt(_loc2_,1);
         if(param1.rankVip > 0)
         {
            vip.text = "VIP." + param1.rankVip;
         }
         lv.text = param1.playerLv;
         playerName.text = param1.playerName;
         serverName.text = param1.serverId + "区  " + param1.serverName;
         if(param1.clientnum >= 0 && param1.clientnum < 20)
         {
            serverName.color = 4759296;
         }
         else if(param1.clientnum >= 20 && param1.clientnum < 500)
         {
            serverName.color = 16711680;
         }
         else
         {
            serverName.color = 15820288;
         }
         this.addEventListener("touch",touch);
      }
      
      private function touch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
         }
      }
   }
}
