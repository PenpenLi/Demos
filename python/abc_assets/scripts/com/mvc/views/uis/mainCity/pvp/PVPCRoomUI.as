package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PVPCRoomUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_createRoom:SwfSprite;
      
      public var sureBtn:SwfButton;
      
      public var canelBtn:SwfButton;
      
      public var inputRoomName:FeathersTextInput;
      
      public var inputRoomPsw:FeathersTextInput;
      
      public function PVPCRoomUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_createRoom = swf.createSprite("spr_createRoom") as SwfSprite;
         addChild(spr_createRoom);
         spr_createRoom.x = 1136 - spr_createRoom.width >> 1;
         spr_createRoom.y = 640 - spr_createRoom.height >> 1;
         sureBtn = spr_createRoom.getChildByName("sureBtn") as SwfButton;
         canelBtn = spr_createRoom.getChildByName("canelBtn") as SwfButton;
         inputRoomName = spr_createRoom.getChildByName("inputRoomName") as FeathersTextInput;
         inputRoomName.maxChars = 6;
         inputRoomPsw = spr_createRoom.getChildByName("inputRoomPsw") as FeathersTextInput;
         inputRoomPsw.maxChars = 6;
         inputRoomPsw.restrict = "0-9a-zA-Z";
         inputRoomPsw.prompt = "默认为无密码";
      }
   }
}
