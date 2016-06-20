package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   
   public class TrialUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_trial:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_leagu:SwfButton;
      
      public var btn_treasure:SwfButton;
      
      private var leaguImg:Image;
      
      private var treasureImg:Image;
      
      private var img_trialBigBg:Image;
      
      public var tf_actLeagu:TextField;
      
      public function TrialUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         img_trialBigBg = swf.createImage("img_trialBigBg");
         addChild(img_trialBigBg);
         spr_trial = swf.createSprite("spr_trial");
         spr_trial.x = 1136 - spr_trial.width >> 1;
         spr_trial.y = (640 - spr_trial.height >> 1) + 20;
         addChild(spr_trial);
         btn_close = spr_trial.getButton("btn_close");
         btn_leagu = spr_trial.getButton("btn_leagu");
         btn_treasure = spr_trial.getButton("btn_treasure");
         addImgToBtn();
         tf_actLeagu = (btn_leagu.skin as Sprite).getChildByName("tf_act") as TextField;
         var _loc1_:TextField = (btn_treasure.skin as Sprite).getChildByName("tf_act") as TextField;
      }
      
      private function addImgToBtn() : void
      {
         NpcImageManager.getInstance().getImg(["xi1ba1"],addLeaguImg);
      }
      
      private function addLeaguImg() : void
      {
         leaguImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("xi1ba1"));
         leaguImg.x = 40;
         leaguImg.y = 80;
         var _loc1_:* = 0.5;
         leaguImg.scaleY = _loc1_;
         leaguImg.scaleX = _loc1_;
         (btn_leagu.skin as Sprite).addChild(leaguImg);
         ElfFrontImageManager.getInstance().getImg(["img_miao1miao1"],showMaoMao);
      }
      
      private function showMaoMao() : void
      {
         treasureImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("img_miao1miao1"));
         treasureImg.x = 40;
         treasureImg.y = 80;
         (btn_treasure.skin as Sprite).addChild(treasureImg);
      }
      
      public function disposeImage() : void
      {
         leaguImg.removeFromParent(true);
         treasureImg.removeFromParent(true);
      }
   }
}
