package com.mvc.views.uis.mainCity.trial
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.coverFlow.Cover;
   import com.common.util.coverFlow.CoverFlowBase;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.views.mediator.mainCity.trial.TrialMediator;
   
   public class TrialSelectBossUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_select_boss:SwfSprite;
      
      public var btn_close:SwfButton;
      
      private var bossCoverVec:Vector.<Cover>;
      
      private var trialBossUnitVec:Vector.<com.mvc.views.uis.mainCity.trial.TrialBossUnit>;
      
      public var coverFlow:CoverFlowBase;
      
      public function TrialSelectBossUI()
      {
         bossCoverVec = new Vector.<Cover>([]);
         trialBossUnitVec = new Vector.<com.mvc.views.uis.mainCity.trial.TrialBossUnit>([]);
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("trial");
         spr_select_boss = swf.createSprite("spr_select_boss");
         spr_select_boss.x = 1136 - spr_select_boss.width >> 1;
         spr_select_boss.y = (640 - spr_select_boss.height >> 1) + 20;
         addChild(spr_select_boss);
         btn_close = spr_select_boss.getButton("btn_close");
         showBoss();
      }
      
      private function showBoss() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc1_:* = null;
         var _loc4_:uint = WorldTime.getInstance()._sevDay;
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc3_ = new Cover();
            _loc1_ = new com.mvc.views.uis.mainCity.trial.TrialBossUnit();
            _loc1_.setBoss(_loc2_);
            if(TrialMediator.isAct && _loc2_ == _loc4_ - 1)
            {
               _loc1_.showDoubleIcon();
            }
            _loc3_.addContent(_loc1_);
            bossCoverVec.push(_loc3_);
            trialBossUnitVec.push(_loc1_);
            _loc2_++;
         }
         coverFlow = new CoverFlowBase(spr_select_boss.width - 33,spr_select_boss.height);
         coverFlow.x = 10;
         coverFlow.y = (spr_select_boss.height >> 1) + 30;
         coverFlow.addCover(bossCoverVec);
         bossCoverVec = Vector.<Cover>([]);
         _loc3_ = null;
      }
      
      public function destructImg() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < trialBossUnitVec.length)
         {
            (trialBossUnitVec[_loc1_] as com.mvc.views.uis.mainCity.trial.TrialBossUnit).removeFromParent(true);
            _loc1_++;
         }
         trialBossUnitVec = Vector.<com.mvc.views.uis.mainCity.trial.TrialBossUnit>([]);
         trialBossUnitVec = null;
      }
   }
}
