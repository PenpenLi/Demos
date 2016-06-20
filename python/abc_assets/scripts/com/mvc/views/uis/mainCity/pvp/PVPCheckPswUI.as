package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import starling.text.TextField;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PVPCheckPswUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_inputPsw:SwfSprite;
      
      public var sureBtn:SwfButton;
      
      public var canelBtn:SwfButton;
      
      public var inputRoomPsw:FeathersTextInput;
      
      public var tf_roomName:TextField;
      
      public function PVPCheckPswUI()
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
         spr_inputPsw = swf.createSprite("spr_inputPsw") as SwfSprite;
         addChild(spr_inputPsw);
         spr_inputPsw.x = 1136 - spr_inputPsw.width >> 1;
         spr_inputPsw.y = 640 - spr_inputPsw.height >> 1;
         sureBtn = spr_inputPsw.getChildByName("sureBtn") as SwfButton;
         canelBtn = spr_inputPsw.getChildByName("canelBtn") as SwfButton;
         inputRoomPsw = spr_inputPsw.getChildByName("inputRoomPsw") as FeathersTextInput;
         inputRoomPsw.maxChars = 6;
         inputRoomPsw.restrict = "0-9a-zA-Z";
         tf_roomName = spr_inputPsw.getTextField("tf_roomName");
      }
   }
}
