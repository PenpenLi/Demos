package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.login.ServerVO;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ServerUintUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_serverUnit:SwfSprite;
      
      public var serverId:TextField;
      
      public var serverName:TextField;
      
      public var serverState:TextField;
      
      private var busy:SwfImage;
      
      private var full:SwfImage;
      
      private var normal:SwfImage;
      
      public var index:int;
      
      private var newServer:SwfImage;
      
      public function ServerUintUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         spr_serverUnit = swf.createSprite("spr_serverUnit");
         serverId = spr_serverUnit.getTextField("serverId");
         serverName = spr_serverUnit.getTextField("serverName");
         serverState = spr_serverUnit.getTextField("serverState");
         busy = spr_serverUnit.getImage("busy");
         full = spr_serverUnit.getImage("full");
         normal = spr_serverUnit.getImage("normal");
         newServer = spr_serverUnit.getImage("newServer");
         newServer.visible = false;
         busy.visible = false;
         full.visible = false;
         normal.visible = false;
         addChild(spr_serverUnit);
         serverName.autoScale = true;
      }
      
      public function set myServer(param1:ServerVO) : void
      {
         serverId.text = param1.serverId + "区";
         serverName.x = serverId.x + serverId.width + 10;
         serverName.text = param1.serverName;
         if(param1.clientnum >= 0 && param1.clientnum < 20)
         {
            serverState.text = "流畅";
            serverState.color = 4759296;
            normal.visible = true;
         }
         else if(param1.clientnum >= 20 && param1.clientnum < 500)
         {
            serverState.text = "火爆";
            serverState.color = 16711680;
            full.visible = true;
         }
         else
         {
            serverState.text = "拥挤";
            serverState.color = 15820288;
            busy.visible = true;
         }
         if(index == 0)
         {
            newServer.visible = true;
            serverState.text = "推荐";
            serverState.color = 4759296;
            busy.visible = false;
            full.visible = false;
            normal.visible = true;
            if(param1.clientnum > 2500)
            {
               serverState.text = "拥挤";
               serverState.color = 15820288;
               full.visible = false;
               normal.visible = false;
               busy.visible = true;
            }
         }
      }
   }
}
