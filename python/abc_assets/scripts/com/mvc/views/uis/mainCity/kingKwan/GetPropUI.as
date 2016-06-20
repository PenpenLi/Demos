package com.mvc.views.uis.mainCity.kingKwan
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class GetPropUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_getRewardBg:SwfSprite;
      
      public var btn_ok:SwfButton;
      
      public var panel:ScrollContainer;
      
      public var rewardTitleImg:Image;
      
      public var rewardTitleImg2:Image;
      
      public function GetPropUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addPanel();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_getRewardBg = swf.createSprite("spr_getRewardBg");
         btn_ok = spr_getRewardBg.getButton("btn_ok");
         spr_getRewardBg.x = 1136 - spr_getRewardBg.width >> 1;
         spr_getRewardBg.y = 640 - spr_getRewardBg.height >> 1;
         rewardTitleImg = spr_getRewardBg.getChildByName("rewardTitleImg") as Image;
         rewardTitleImg2 = swf.createImage("img_rewardBgTittle2");
         rewardTitleImg2.x = rewardTitleImg.x;
         rewardTitleImg2.y = rewardTitleImg.y;
         addChild(spr_getRewardBg);
      }
      
      private function addPanel() : void
      {
         panel = new ScrollContainer();
         panel.width = spr_getRewardBg.width;
         panel.height = 290;
         panel.x = 0;
         panel.y = 170;
         panel.scrollBarDisplayMode = "none";
      }
   }
}
