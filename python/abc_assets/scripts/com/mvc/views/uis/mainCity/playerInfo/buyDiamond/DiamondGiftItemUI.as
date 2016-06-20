package com.mvc.views.uis.mainCity.playerInfo.buyDiamond
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.controls.Button;
   
   public class DiamondGiftItemUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var diamondItemBtn:SwfButton;
      
      public var giftBagNameTf:TextField;
      
      public var giftBagInfoTf:TextField;
      
      public var giftBagPriceTf:TextField;
      
      public var formSpr:SwfSprite;
      
      public var doubleIcon:SwfImage;
      
      public function DiamondGiftItemUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         diamondItemBtn = swf.createButton("btn_buyDiamondItem_b");
         addChild(diamondItemBtn);
         giftBagNameTf = (diamondItemBtn.skin as Sprite).getChildByName("giftBagNameTf") as TextField;
         giftBagNameTf.vAlign = "bottom";
         giftBagNameTf.fontName = "img_VIP";
         giftBagNameTf.color = 16777215;
         giftBagInfoTf = (diamondItemBtn.skin as Sprite).getChildByName("giftBagInfoTf") as TextField;
         giftBagInfoTf.vAlign = "top";
         giftBagInfoTf.autoScale = true;
         giftBagPriceTf = (diamondItemBtn.skin as Sprite).getChildByName("giftBagPriceTf") as TextField;
         giftBagPriceTf.fontName = "img_font";
         formSpr = (diamondItemBtn.skin as Sprite).getChildByName("formSpr") as SwfSprite;
         if(Pocketmon._description == "egame")
         {
            _loc1_ = new Button();
            _loc1_.label = "购买";
            var _loc2_:* = 0.5;
            _loc1_.scaleY = _loc2_;
            _loc1_.scaleX = _loc2_;
            _loc1_.x = diamondItemBtn.width - 80;
            _loc1_.y = 10;
            (diamondItemBtn.skin as Sprite).addChild(_loc1_);
         }
         addDoubleIcon();
      }
      
      private function addDoubleIcon() : void
      {
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         doubleIcon = _loc1_.createImage("img_doubleIcon");
         doubleIcon.x = 0;
         doubleIcon.y = 0;
         doubleIcon.touchable = false;
         (diamondItemBtn.skin as Sprite).addChild(doubleIcon);
         _loc1_ = null;
      }
   }
}
