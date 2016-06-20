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
   
   public class RankPanleUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_rankPanleBg:SwfSprite;
      
      public var btn_rankClose:SwfButton;
      
      public var rankList:List;
      
      public function RankPanleUI()
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
         rankList = new List();
         rankList.width = 635;
         rankList.height = 470;
         rankList.x = 22;
         rankList.y = 81;
         rankList.isSelectable = false;
         spr_rankPanleBg.addChild(rankList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfSeries");
         spr_rankPanleBg = swf.createSprite("spr_rankPanleBg");
         btn_rankClose = spr_rankPanleBg.getButton("btn_rankClose");
         spr_rankPanleBg.x = 1136 - spr_rankPanleBg.width >> 1;
         spr_rankPanleBg.y = 640 - spr_rankPanleBg.height >> 1;
         addChild(spr_rankPanleBg);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
