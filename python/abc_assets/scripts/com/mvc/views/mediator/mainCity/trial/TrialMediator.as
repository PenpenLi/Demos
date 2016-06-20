package com.mvc.views.mediator.mainCity.trial
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.mainCity.trial.TrialBossVO;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.NpcImageManager;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetTrialInfo;
   
   public class TrialMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "TrialMediator";
      
      public static var bossVoVec:Vector.<TrialBossVO>;
      
      public static var trialReward:Object;
      
      public static var isAct:Boolean;
       
      public var trialUI:TrialUI;
      
      public function TrialMediator(param1:Object = null)
      {
         super("TrialMediator",param1);
         trialUI = param1 as TrialUI;
         trialUI.addEventListener("triggered",triggeredHandler);
         bossVoVec = GetTrialInfo.getTrialInfo();
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(trialUI.btn_close !== _loc2_)
         {
            if(trialUI.btn_leagu !== _loc2_)
            {
               if(trialUI.btn_treasure === _loc2_)
               {
                  (facade.retrieveProxy("TrialPro") as TrialPro).write2201(TrialMediator.bossVoVec[7].bossId);
                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|试炼宝藏");
               }
            }
            else
            {
               if(PlayerVO.lv < 24)
               {
                  Tips.show("玩家等级达到24级后开放");
                  return;
               }
               sendNotification("switch_win",null,"load_trial_select_boss");
               trialUI.spr_trial.removeFromParent();
               UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|试炼道馆");
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("trial_close_select_boss" !== _loc3_)
         {
            if("trial_show_treasure_success" !== _loc3_)
            {
               if("trial_act_info" === _loc3_)
               {
                  _loc2_ = param1.getBody();
                  isAct = _loc2_.isAct;
                  if(isAct)
                  {
                     trialUI.tf_actLeagu.text = "掉落翻倍活动：\n" + _loc2_.actTime;
                  }
               }
            }
            else
            {
               trialUI.spr_trial.removeFromParent();
            }
         }
         else
         {
            trialUI.addChild(trialUI.spr_trial);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["trial_close_select_boss","trial_show_treasure_success","trial_act_info"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(facade.hasMediator("SelePlayElfMedia"))
         {
            sendNotification("REMOVE_SELEPLAYELF_MEDIA");
         }
         if(Facade.getInstance().hasMediator("TrialSelectBossMediator"))
         {
            (Facade.getInstance().retrieveMediator("TrialSelectBossMediator") as TrialSelectBossMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrialSelectDifficultyModiator"))
         {
            (Facade.getInstance().retrieveMediator("TrialSelectDifficultyModiator") as TrialSelectDifficultyModiator).dispose();
         }
         if(Facade.getInstance().hasMediator("TrialBossInfoMediator"))
         {
            (Facade.getInstance().retrieveMediator("TrialBossInfoMediator") as TrialBossInfoMediator).dispose();
         }
         bossVoVec = Vector.<TrialBossVO>([]);
         bossVoVec = null;
         NpcImageManager.getInstance().dispose();
         ElfFrontImageManager.getInstance().dispose();
         facade.removeMediator("TrialMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.trialAssets);
      }
   }
}
