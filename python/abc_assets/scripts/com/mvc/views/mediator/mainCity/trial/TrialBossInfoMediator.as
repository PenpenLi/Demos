package com.mvc.views.mediator.mainCity.trial
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.trial.TrialBossInfoUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.elfSeries.SelePlayElfMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetTrialInfo;
   import starling.display.DisplayObject;
   
   public class TrialBossInfoMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "TrialBossInfoMediator";
      
      public static var difficultyId:int;
      
      public static var bossId:int;
       
      public var trialBossInfoUI:TrialBossInfoUI;
      
      private var bossIndex:int;
      
      private var difficultyIndex:int;
      
      private var bossElfVoVec:Vector.<ElfVO>;
      
      public function TrialBossInfoMediator(param1:Object = null)
      {
         super("TrialBossInfoMediator",param1);
         trialBossInfoUI = param1 as TrialBossInfoUI;
         trialBossInfoUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(trialBossInfoUI.btn_close !== _loc2_)
         {
            if(trialBossInfoUI.btn_challenge === _loc2_)
            {
               if(!facade.hasMediator("SelePlayElfMedia"))
               {
                  facade.registerMediator(new SelePlayElfMedia(new SelePlayElfUI()));
               }
               sendNotification("SEND_RIVAL_DATA",TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex],"试炼");
               sendNotification("switch_win",null,"LOAD_SERIES_PLAYELF");
            }
         }
         else
         {
            WinTweens.closeWin(trialBossInfoUI.spr_bossInfo,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         trialBossInfoUI.removeFromParent();
         sendNotification("trial_close_boss_info");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("trial_update_boss_info" === _loc2_)
         {
            bossIndex = param1.getType();
            difficultyIndex = param1.getBody();
            LogUtil("diffindex: " + difficultyIndex);
            difficultyId = TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].id;
            bossId = TrialMediator.bossVoVec[bossIndex].bossId;
            trialBossInfoUI.tf_bossName.text = TrialMediator.bossVoVec[bossIndex].bossName;
            trialBossInfoUI.tf_bossDesc.text = TrialMediator.bossVoVec[bossIndex].bossDesc;
            trialBossInfoUI.tf_difficultyLv.text = TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].difficultyLv;
            bossElfVoVec = TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].elfVOVec;
            if(bossElfVoVec.length == 0)
            {
               bossElfVoVec = GetTrialInfo.getDifficultyElfVoVec(difficultyId);
               TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].elfVOVec = bossElfVoVec;
            }
            trialBossInfoUI.updateElfCamp(bossElfVoVec);
            trialBossInfoUI.updateDropRrward(TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].dropPropIdArr);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["trial_update_boss_info"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("TrialBossInfoMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
