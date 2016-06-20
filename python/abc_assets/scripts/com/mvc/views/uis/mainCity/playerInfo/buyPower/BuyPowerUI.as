package com.mvc.views.uis.mainCity.playerInfo.buyPower
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class BuyPowerUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var buyPowerSpr:SwfSprite;
      
      public var buyCloseBtn:Button;
      
      public var useBtn:Button;
      
      public var remainTimeTf:TextField;
      
      public var totalTimeTf:TextField;
      
      public var diamondTextInput:FeathersTextInput;
      
      public var getPowerTf:TextField;
      
      public var payDiamondTf:TextField;
      
      public function BuyPowerUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         buyPowerSpr = swf.createSprite("spr_buyPower_s");
         buyPowerSpr.x = 1136 - buyPowerSpr.width >> 1;
         buyPowerSpr.y = 640 - buyPowerSpr.height >> 1;
         addChild(buyPowerSpr);
         buyCloseBtn = buyPowerSpr.getButton("buyCloseBtn");
         useBtn = buyPowerSpr.getButton("useBtn");
         remainTimeTf = buyPowerSpr.getTextField("remainTimeTf");
         totalTimeTf = buyPowerSpr.getTextField("totalTimeTf");
         getPowerTf = buyPowerSpr.getTextField("getPowerTf");
         getPowerTf.text = "100";
         payDiamondTf = buyPowerSpr.getTextField("payDiamondTf");
      }
      
      public function calculatePayAndGet(param1:int) : void
      {
         payDiamondTf.text = PlayerVO.vipInfoVO.acFrVec[param1];
      }
   }
}
