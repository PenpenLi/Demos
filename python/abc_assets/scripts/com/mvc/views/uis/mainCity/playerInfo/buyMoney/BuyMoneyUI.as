package com.mvc.views.uis.mainCity.playerInfo.buyMoney
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class BuyMoneyUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var buyMoneySpr:SwfSprite;
      
      public var buyCloseBtn:Button;
      
      public var useBtn:Button;
      
      public var remainTimeTf:TextField;
      
      public var totalTimeTf:TextField;
      
      public var diamondTextInput:FeathersTextInput;
      
      public var getMoneyTf:TextField;
      
      public var payDiamondTf:TextField;
      
      public function BuyMoneyUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         buyMoneySpr = swf.createSprite("spr_buyMoney_s");
         buyMoneySpr.x = 1136 - buyMoneySpr.width >> 1;
         buyMoneySpr.y = 640 - buyMoneySpr.height >> 1;
         addChild(buyMoneySpr);
         buyCloseBtn = buyMoneySpr.getButton("buyCloseBtn");
         useBtn = buyMoneySpr.getButton("useBtn");
         remainTimeTf = buyMoneySpr.getTextField("remainTimeTf");
         totalTimeTf = buyMoneySpr.getTextField("totalTimeTf");
         getMoneyTf = buyMoneySpr.getTextField("getMoneyTf");
         payDiamondTf = buyMoneySpr.getTextField("payDiamondTf");
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChildAt(_loc1_,0);
      }
      
      public function calculatePayAndGet(param1:int) : void
      {
         payDiamondTf.text = Math.round(Math.pow(param1 + 1,0.6906) * 10.325);
         getMoneyTf.text = Math.round(Math.pow(param1 + 1,0.5456) * 5000);
      }
   }
}
