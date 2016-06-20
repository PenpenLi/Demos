package com.mvc.views.uis.mainCity.friend
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FriendListUI extends Sprite
   {
       
      public var friList:List;
      
      private var swf:Swf;
      
      public function FriendListUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("friend");
         addList();
      }
      
      private function addList() : void
      {
         friList = new List();
         friList.width = 840;
         friList.height = 370;
         friList.isSelectable = false;
         addChild(friList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
