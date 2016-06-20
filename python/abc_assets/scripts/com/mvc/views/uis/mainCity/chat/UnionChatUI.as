package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionChatUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_union:SwfSprite;
      
      public var unionInput:FeathersTextInput;
      
      public var btn_send:SwfButton;
      
      public var unionChatList:List;
      
      public var _count:int;
      
      public var btn_face:SwfButton;
      
      public function UnionChatUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_union = swf.createSprite("spr_union");
         btn_send = spr_union.getButton("btn_send");
         btn_face = spr_union.getButton("btn_face");
         unionInput = spr_union.getChildByName("unionInput") as FeathersTextInput;
         unionInput.width = 685;
         unionInput.height = 60;
         unionInput.maxChars = 45;
         unionInput.paddingLeft = 10;
         unionInput.paddingTop = 11;
         unionInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         spr_union.y = 520;
         spr_union.x = 30;
         addChild(spr_union);
         addList();
      }
      
      public function addList() : void
      {
         unionChatList = new List();
         unionChatList.width = 1136;
         unionChatList.height = 470;
         unionChatList.y = 60;
         unionChatList.isSelectable = false;
         unionChatList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         unionChatList.itemRendererProperties.paddingBottom = _loc1_;
         unionChatList.itemRendererProperties.paddingTop = _loc1_;
         addChild(unionChatList);
      }
   }
}
