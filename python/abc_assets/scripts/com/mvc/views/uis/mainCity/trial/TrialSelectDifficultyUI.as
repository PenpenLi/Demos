package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.HorizontalLayout;
   
   public class TrialSelectDifficultyUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_select_difficulty:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_buyPurchase:SwfButton;
      
      public var difficultyList:List;
      
      public var trialBossUnit:com.mvc.views.uis.mainCity.trial.TrialBossUnit;
      
      public var tf_remainTimes:TextField;
      
      public function TrialSelectDifficultyUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         spr_select_difficulty = swf.createSprite("spr_select_difficulty");
         spr_select_difficulty.x = 1136 - spr_select_difficulty.width >> 1;
         spr_select_difficulty.y = (640 - spr_select_difficulty.height >> 1) + 20;
         addChild(spr_select_difficulty);
         btn_close = spr_select_difficulty.getButton("btn_close");
         btn_buyPurchase = spr_select_difficulty.getButton("btn_buyPurchase");
         tf_remainTimes = spr_select_difficulty.getTextField("tf_remainTimes");
         addDifficultyList();
      }
      
      public function addBoss(param1:int) : void
      {
         trialBossUnit = new com.mvc.views.uis.mainCity.trial.TrialBossUnit();
         trialBossUnit.setBoss(param1);
         trialBossUnit.x = 20;
         trialBossUnit.y = 110;
         spr_select_difficulty.addChild(trialBossUnit);
      }
      
      public function addDifficultyList() : void
      {
         difficultyList = new List();
         difficultyList.x = 328;
         difficultyList.y = 230;
         difficultyList.width = 490;
         difficultyList.itemRendererProperties.stateToSkinFunction = null;
         difficultyList.itemRendererProperties.padding = 0;
         difficultyList.addEventListener("initialize",changeLay);
         changeLay();
      }
      
      private function changeLay() : void
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.gap = 25;
         difficultyList.layout = _loc1_;
      }
   }
}
