package com.mvc.views.uis.mainCity.playerInfo.buyDiamond
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class BuyDiamondUI extends Sprite
   {
       
      public var buyDiamondSpr:SwfSprite;
      
      public var buyCloseBtn:Button;
      
      private var swf:Swf;
      
      public var nowVIPLvTf:TextField;
      
      public var nextVIPLvTf:TextField;
      
      public var upgradeDiamondTf:TextField;
      
      public var cumulativeDiamondTf:TextField;
      
      public var nextLvDiamondTf:TextField;
      
      public var switchMc:SwfMovieClip;
      
      public var VIPPowerSpr:SwfSprite;
      
      public var leftBtn:Button;
      
      public var rightBtn:Button;
      
      public var selectedVIPTf:TextField;
      
      public var leftVIPTf:TextField;
      
      public var rightVIPTf:TextField;
      
      public var rechargeSpr:SwfSprite;
      
      public var privilegeSpr:SwfSprite;
      
      public var VIPProgressBarSpr:SwfSprite;
      
      public var rightImg:Image;
      
      public var leftImg:Image;
      
      public var tfImg:Image;
      
      public function BuyDiamondUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         buyDiamondSpr = swf.createSprite("spr_buyDiamond_s");
         buyDiamondSpr.x = 1136 - buyDiamondSpr.width >> 1;
         buyDiamondSpr.y = 640 - buyDiamondSpr.height >> 1;
         addChild(buyDiamondSpr);
         VIPProgressBarSpr = buyDiamondSpr.getChildByName("VIPProgressBar") as SwfSprite;
         VIPPowerSpr = swf.createSprite("spr_VIPPower_s");
         rechargeSpr = buyDiamondSpr.getSprite("rechargeSpr");
         privilegeSpr = buyDiamondSpr.getSprite("privilegeSpr");
         privilegeSpr.visible = false;
         buyCloseBtn = buyDiamondSpr.getButton("buyCloseBtn");
         leftBtn = VIPPowerSpr.getButton("leftBtn");
         rightBtn = VIPPowerSpr.getButton("rightBtn");
         nowVIPLvTf = buyDiamondSpr.getTextField("nowVIPLvTf");
         nextVIPLvTf = buyDiamondSpr.getTextField("nextVIPLvTf");
         upgradeDiamondTf = buyDiamondSpr.getTextField("upgradeDiamondTf");
         cumulativeDiamondTf = buyDiamondSpr.getTextField("cumulativeDiamondTf");
         nextLvDiamondTf = buyDiamondSpr.getTextField("nextLvDiamondTf");
         selectedVIPTf = VIPPowerSpr.getTextField("selectedVIPTf");
         leftVIPTf = VIPPowerSpr.getTextField("leftVIPTf");
         rightVIPTf = VIPPowerSpr.getTextField("rightVIPTf");
         nowVIPLvTf.fontName = "img_VIP";
         nextVIPLvTf.fontName = "img_VIP";
         selectedVIPTf.fontName = "img_VIP";
         leftVIPTf.fontName = "img_VIP";
         rightVIPTf.fontName = "img_VIP";
         nowVIPLvTf.color = 16777215;
         nextVIPLvTf.color = 16777215;
         selectedVIPTf.color = 16777215;
         leftVIPTf.color = 16777215;
         rightVIPTf.color = 16777215;
         cumulativeDiamondTf.fontName = "img_font";
         nextLvDiamondTf.fontName = "img_font";
         switchMc = buyDiamondSpr.getMovie("switchMc");
         switchMc.gotoAndStop(0);
         rightImg = VIPPowerSpr.getImage("rightImg");
         leftImg = VIPPowerSpr.getImage("leftImg");
         tfImg = buyDiamondSpr.getImage("tfImg");
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChildAt(_loc1_,0);
      }
   }
}
