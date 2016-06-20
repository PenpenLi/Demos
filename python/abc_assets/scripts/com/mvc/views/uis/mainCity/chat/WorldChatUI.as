package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class WorldChatUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_worldChatBg:SwfSprite;
      
      public var worldInput:FeathersTextInput;
      
      public var btn_send:SwfButton;
      
      public var worldChatList:List;
      
      public var _count:int;
      
      public var btn_face:SwfButton;
      
      public function WorldChatUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_worldChatBg = swf.createSprite("spr_worldChatBg");
         btn_send = spr_worldChatBg.getButton("btn_send");
         btn_face = spr_worldChatBg.getButton("btn_face");
         worldInput = spr_worldChatBg.getChildByName("worldInput") as FeathersTextInput;
         worldInput.width = 685;
         worldInput.height = 60;
         worldInput.maxChars = 45;
         worldInput.paddingLeft = 10;
         worldInput.paddingTop = 11;
         worldInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         spr_worldChatBg.y = 520;
         spr_worldChatBg.x = 30;
         addChild(spr_worldChatBg);
         addList();
      }
      
      public function addList() : void
      {
         worldChatList = new List();
         worldChatList.width = 1136;
         worldChatList.height = 470;
         worldChatList.y = 60;
         worldChatList.isSelectable = false;
         worldChatList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         worldChatList.itemRendererProperties.paddingBottom = _loc1_;
         worldChatList.itemRendererProperties.paddingTop = _loc1_;
         addChild(worldChatList);
      }
      
      public function set update(param1:int) : void
      {
         _count = param1;
         if(param1 > 0)
         {
         }
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
