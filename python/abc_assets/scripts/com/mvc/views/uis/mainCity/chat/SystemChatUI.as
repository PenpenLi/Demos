package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import feathers.layout.VerticalLayout;
   
   public class SystemChatUI extends Sprite
   {
       
      public var systemChatList:List;
      
      public function SystemChatUI()
      {
         super();
         addList();
      }
      
      public function addList() : void
      {
         systemChatList = new List();
         systemChatList.width = 1136;
         systemChatList.height = 600;
         systemChatList.y = 40;
         systemChatList.isSelectable = false;
         systemChatList.itemRendererProperties.stateToSkinFunction = null;
         addChild(systemChatList);
         systemChatList.addEventListener("creationComplete",creatComplete);
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = -45;
         var _loc2_:* = 0;
         _loc1_.paddingLeft = _loc2_;
         _loc2_ = _loc2_;
         _loc1_.paddingBottom = _loc2_;
         _loc2_ = _loc2_;
         _loc1_.paddingRight = _loc2_;
         _loc1_.paddingTop = _loc2_;
         systemChatList.layout = _loc1_;
      }
   }
}
