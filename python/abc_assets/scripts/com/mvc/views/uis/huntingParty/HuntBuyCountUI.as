package com.mvc.views.uis.huntingParty
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import starling.display.Quad;
   
   public class HuntBuyCountUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_buyCount:SwfSprite;
      
      public var diaTxt:TextField;
      
      public var countTxt:TextField;
      
      public var btn_use:SwfButton;
      
      public var btn_cancle:SwfButton;
      
      public function HuntBuyCountUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("huntingParty");
         spr_buyCount = swf.createSprite("spr_buyCount");
         diaTxt = spr_buyCount.getTextField("diaTxt");
         countTxt = spr_buyCount.getTextField("countTxt");
         btn_use = spr_buyCount.getButton("btn_use");
         btn_cancle = spr_buyCount.getButton("btn_cancle");
         spr_buyCount.x = 1136 - spr_buyCount.width >> 1;
         spr_buyCount.y = 640 - spr_buyCount.height >> 1;
         addChild(spr_buyCount);
      }
      
      public function setInfo() : void
      {
         diaTxt.text = HuntPartyVO.buyCountDia;
      }
      
      public function removeHandle() : void
      {
      }
   }
}
