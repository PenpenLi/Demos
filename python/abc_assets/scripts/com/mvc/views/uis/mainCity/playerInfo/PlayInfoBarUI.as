package com.mvc.views.uis.mainCity.playerInfo
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import feathers.display.Scale9Image;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class PlayInfoBarUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var buyPowerBtn:Button;
      
      public var buyMoneyBtn:Button;
      
      public var buyDiamondBtn:Button;
      
      public var headBtn:Button;
      
      public var nowPowerTf:TextField;
      
      public var maxPowerTf:TextField;
      
      public var moneyTf:TextField;
      
      public var diamondTf:TextField;
      
      public var vipTf:TextField;
      
      public var levelTf:TextField;
      
      public var expProgressBar:Scale9Image;
      
      public var trainerPicImg:Image;
      
      public var powerBarSpr:SwfSprite;
      
      public var moneyBarSpr:SwfSprite;
      
      public var diamondBarSpr:SwfSprite;
      
      public var vipSpr:SwfSprite;
      
      public var worldTime:SwfImage;
      
      public function PlayInfoBarUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         var _loc1_:SwfSprite = swf.createSprite("spr_Information_bar_s");
         powerBarSpr = _loc1_.getChildByName("powerBarSpr") as SwfSprite;
         moneyBarSpr = _loc1_.getChildByName("moneyBarSpr") as SwfSprite;
         diamondBarSpr = _loc1_.getChildByName("diamondBarSpr") as SwfSprite;
         vipSpr = _loc1_.getChildByName("vipSpr") as SwfSprite;
         headBtn = _loc1_.getButton("headBtn");
         buyPowerBtn = powerBarSpr.getChildByName("buyPowerBtn") as Button;
         buyMoneyBtn = moneyBarSpr.getChildByName("buyMoneyBtn") as Button;
         buyDiamondBtn = diamondBarSpr.getChildByName("buyDiamondBtn") as Button;
         nowPowerTf = powerBarSpr.getChildByName("nowPowerTf") as TextField;
         nowPowerTf.autoScale = true;
         maxPowerTf = powerBarSpr.getChildByName("maxPowerTf") as TextField;
         maxPowerTf.autoScale = true;
         moneyTf = moneyBarSpr.getChildByName("moneyTf") as TextField;
         moneyTf.autoScale = true;
         diamondTf = diamondBarSpr.getChildByName("diamondTf") as TextField;
         diamondTf.autoScale = true;
         vipTf = vipSpr.getChildByName("vipTf") as TextField;
         vipTf.width = vipTf.width + 100;
         levelTf = (headBtn.skin as Sprite).getChildByName("levelTf") as TextField;
         worldTime = powerBarSpr.getImage("worldTime");
         nowPowerTf.touchable = false;
         maxPowerTf.touchable = false;
         levelTf.fontName = "img_font";
         moneyTf.fontName = "img_font";
         diamondTf.fontName = "img_font";
         nowPowerTf.fontName = "img_font";
         maxPowerTf.fontName = "img_font";
         vipTf.fontName = "img_vipBarTf";
         moneyTf.pivotX = moneyTf.width / 2;
         moneyTf.x = moneyTf.x + moneyTf.width / 2;
         diamondTf.pivotX = diamondTf.width / 2;
         diamondTf.x = diamondTf.x + diamondTf.width / 2;
         nowPowerTf.pivotX = nowPowerTf.width / 2;
         nowPowerTf.x = nowPowerTf.x + nowPowerTf.width / 2;
         var _loc2_:SwfSprite = (headBtn.skin as Sprite).getChildByName("expProgressBar") as SwfSprite;
         expProgressBar = _loc2_.getChildByName("progerssBar") as Scale9Image;
         trainerPicImg = (headBtn.skin as Sprite).getChildByName("headPicImg") as Image;
         this.blendMode = "none";
      }
   }
}
