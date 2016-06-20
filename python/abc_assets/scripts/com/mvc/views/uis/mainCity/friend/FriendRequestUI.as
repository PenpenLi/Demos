package com.mvc.views.uis.mainCity.friend
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FriendRequestUI extends Sprite
   {
       
      public var friendList:List;
      
      private var swf:Swf;
      
      public function FriendRequestUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("friend");
         addList();
      }
      
      private function addList() : void
      {
         friendList = new List();
         friendList.width = 840;
         friendList.height = 370;
         friendList.isSelectable = false;
         addChild(friendList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
