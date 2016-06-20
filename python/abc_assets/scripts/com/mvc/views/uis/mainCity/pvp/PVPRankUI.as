package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.display.SwfImage;
   import starling.display.Quad;
   
   public class PVPRankUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_rankPanleBg:SwfSprite;
      
      public var closeBtn:SwfButton;
      
      public var rankList:List;
      
      public function PVPRankUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("pvp");
         spr_rankPanleBg = swf.createSprite("spr_rank");
         closeBtn = spr_rankPanleBg.getButton("closeBtn");
         spr_rankPanleBg.x = 1136 - spr_rankPanleBg.width >> 1;
         spr_rankPanleBg.y = 640 - spr_rankPanleBg.height >> 1;
         addChild(spr_rankPanleBg);
      }
      
      private function addList() : void
      {
         rankList = new List();
         rankList.width = 645;
         rankList.height = 450;
         rankList.x = 12;
         rankList.y = 90;
         rankList.isSelectable = false;
         spr_rankPanleBg.addChild(rankList);
      }
      
      public function getImage(param1:String) : SwfImage
      {
         return swf.createImage(param1);
      }
   }
}
