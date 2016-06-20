package com.mvc.views.mediator.mainCity.trial
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.trial.TrialSelectBossUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   
   public class TrialSelectBossMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "TrialSelectBossMediator";
      
      public static var isAllBossLoaded:Boolean;
       
      public var trialSelectBossUI:TrialSelectBossUI;
      
      public function TrialSelectBossMediator(param1:Object = null)
      {
         super("TrialSelectBossMediator",param1);
         trialSelectBossUI = param1 as TrialSelectBossUI;
         trialSelectBossUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(trialSelectBossUI.btn_close === _loc2_)
         {
            trialSelectBossUI.coverFlow.removeFromParent();
            WinTweens.closeWin(trialSelectBossUI.spr_select_boss,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("trial_close_select_boss");
         trialSelectBossUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:* = param1.getName();
         if("trial_update_boss_list" !== _loc4_)
         {
            if("trial_touch_boss_cover" !== _loc4_)
            {
               if("trial_select_boss_success" !== _loc4_)
               {
                  if("trial_close_select_difficulty" === _loc4_)
                  {
                     (Starling.current.root as Game).addChild(trialSelectBossUI);
                  }
               }
               else
               {
                  trialSelectBossUI.removeFromParent();
               }
            }
            else
            {
               _loc2_ = param1.getBody();
               LogUtil("name: " + _loc2_);
               (facade.retrieveProxy("TrialPro") as TrialPro).write2201(TrialMediator.bossVoVec[_loc2_].bossId);
            }
         }
         else
         {
            trialSelectBossUI.spr_select_boss.addChild(trialSelectBossUI.coverFlow);
            _loc3_ = WorldTime.getInstance()._sevDay;
            if(_loc3_)
            {
               trialSelectBossUI.coverFlow.selectedIndex = _loc3_ - 1;
            }
            else
            {
               trialSelectBossUI.coverFlow.selectedIndex = 6;
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["trial_update_boss_list","trial_select_boss_success","trial_touch_boss_cover","trial_close_select_difficulty"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         isAllBossLoaded = false;
         trialSelectBossUI.destructImg();
         facade.removeMediator("TrialSelectBossMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
