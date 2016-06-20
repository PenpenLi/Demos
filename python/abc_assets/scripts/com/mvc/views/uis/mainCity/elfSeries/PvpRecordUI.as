package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.display.SwfImage;
   import starling.display.Quad;
   
   public class PvpRecordUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_pvpRecordBg:SwfSprite;
      
      public var btn_pvpClose:SwfButton;
      
      public var pvpList:List;
      
      public function PvpRecordUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function addList() : void
      {
         pvpList = new List();
         pvpList.width = 635;
         pvpList.height = 470;
         pvpList.x = 22;
         pvpList.y = 80;
         pvpList.isSelectable = false;
         spr_pvpRecordBg.addChild(pvpList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfSeries");
         spr_pvpRecordBg = swf.createSprite("spr_pvpRecordBg");
         btn_pvpClose = spr_pvpRecordBg.getButton("btn_pvpClose");
         spr_pvpRecordBg.x = 1136 - spr_pvpRecordBg.width >> 1;
         spr_pvpRecordBg.y = 640 - spr_pvpRecordBg.height >> 1;
         addChild(spr_pvpRecordBg);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
