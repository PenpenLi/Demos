package com.mvc.views.uis.mainCity.hunting
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfImage;
   import feathers.data.ListCollection;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.display.SwfButton;
   
   public class HuntingSelectTickUI extends Sprite
   {
       
      public var huntingTickList:List;
      
      public var btn_close:Button;
      
      private var swf:Swf;
      
      public var mySpr:SwfSprite;
      
      private var line:SwfImage;
      
      public var huntingTickListData:ListCollection;
      
      public function HuntingSelectTickUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc2_:* = 1.515;
         _loc1_.scaleY = _loc2_;
         _loc1_.scaleX = _loc2_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         mySpr = swf.createSprite("spr_main");
         btn_close = mySpr.getButton("btn_close");
         mySpr.x = 1136 - mySpr.width >> 1;
         mySpr.y = 640 - mySpr.height >> 1;
         line = mySpr.getImage("line");
         line.visible = false;
         addChild(mySpr);
         createGoodsList();
      }
      
      private function createGoodsList() : void
      {
         huntingTickList = new List();
         huntingTickList.width = 1060;
         huntingTickList.height = 495;
         huntingTickList.x = 22;
         huntingTickList.y = 100;
         huntingTickList.isSelectable = false;
         huntingTickListData = new ListCollection();
         huntingTickList.dataProvider = huntingTickListData;
         mySpr.addChild(huntingTickList);
      }
      
      public function getBtn(param1:String) : SwfButton
      {
         return swf.createButton(param1);
      }
   }
}
