package com.mvc.views.uis.mainCity.friend
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FriendSearchUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_search:SwfSprite;
      
      public var com_searchInput:FeathersTextInput;
      
      public var btn_search:SwfButton;
      
      public var friendList:List;
      
      public function FriendSearchUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("friend");
         spr_search = swf.createSprite("spr_search");
         com_searchInput = spr_search.getChildByName("com_searchInput") as FeathersTextInput;
         com_searchInput.paddingLeft = 10;
         com_searchInput.paddingTop = 4;
         com_searchInput.restrict = "^ ";
         com_searchInput.prompt = "输入玩家昵称";
         com_searchInput.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         btn_search = spr_search.getButton("btn_search");
         spr_search.x = 100;
         spr_search.y = spr_search.y + 10;
         addChild(spr_search);
         addList();
      }
      
      private function addList() : void
      {
         friendList = new List();
         friendList.width = 840;
         friendList.height = 200;
         friendList.y = 80;
         friendList.isSelectable = false;
         addChild(friendList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
