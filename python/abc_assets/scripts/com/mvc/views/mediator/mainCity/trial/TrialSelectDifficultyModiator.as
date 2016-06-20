package com.mvc.views.mediator.mainCity.trial
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.trial.TrialSelectDifficultyUI;
   import starling.display.DisplayObject;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.core.Starling;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.mainCity.trial.TrialDifficultyBtnUnit;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class TrialSelectDifficultyModiator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "TrialSelectDifficultyModiator";
       
      public var trialSelectDifficultyUI:TrialSelectDifficultyUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var difficultyListData:ListCollection;
      
      private var bossIndex:int;
      
      private var difficultyIndex:int;
      
      private var remainTimes:int;
      
      private var remainPurchaseNum:int;
      
      private var nextCostDiamond:int;
      
      public function TrialSelectDifficultyModiator(param1:Object = null)
      {
         super("TrialSelectDifficultyModiator",param1);
         trialSelectDifficultyUI = param1 as TrialSelectDifficultyUI;
         trialSelectDifficultyUI.addEventListener("triggered",triggeredHandler);
         displayVec = new Vector.<DisplayObject>([]);
         difficultyListData = new ListCollection();
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(trialSelectDifficultyUI.btn_close !== _loc3_)
         {
            if(trialSelectDifficultyUI.btn_buyPurchase === _loc3_)
            {
               if(remainPurchaseNum < 1)
               {
                  Tips.show("亲，该馆主今天购买挑战次数已用完。");
                  return;
               }
               _loc2_ = Alert.show("亲，剩余挑战次数不足哦，是否花费" + nextCostDiamond + "钻石购买，剩余购买次数" + remainPurchaseNum + "次，升级VIP可以增加购买次数哦。","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
               _loc2_.addEventListener("close",isBuyTimesAlert_closeHandler);
            }
         }
         else
         {
            trialSelectDifficultyUI.trialBossUnit.removeFromParent(true);
            trialSelectDifficultyUI.difficultyList.removeFromParent();
            WinTweens.closeWin(trialSelectDifficultyUI.spr_select_difficulty,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         removeDifficultyElfImg();
         trialSelectDifficultyUI.removeFromParent();
         if(bossIndex < 7)
         {
            sendNotification("trial_close_select_difficulty");
         }
         else
         {
            sendNotification("trial_close_select_boss");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = param1.getName();
         if("trial_update_select_difficulty" !== _loc4_)
         {
            if("trial_close_boss_info" !== _loc4_)
            {
               if("trial_difficulty_open" !== _loc4_)
               {
                  if("trial_buy_challenge_times" === _loc4_)
                  {
                     _loc2_ = param1.getBody();
                     remainTimes = _loc2_.data.times;
                     remainPurchaseNum = _loc2_.data.remainPurchaseNum;
                     nextCostDiamond = _loc2_.data.nextCostDiamond;
                     trialSelectDifficultyUI.tf_remainTimes.text = "剩余挑战次数：" + remainTimes + "/3";
                     trialSelectDifficultyUI.btn_buyPurchase.visible = false;
                  }
               }
               else
               {
                  sendNotification("switch_win",null,"load_trial_boss_info");
                  sendNotification("trial_update_boss_info",difficultyIndex,bossIndex);
                  trialSelectDifficultyUI.removeFromParent();
               }
            }
            else
            {
               (Starling.current.root as Game).addChild(trialSelectDifficultyUI);
            }
         }
         else
         {
            _loc3_ = param1.getBody();
            remainTimes = _loc3_.data.times;
            remainPurchaseNum = _loc3_.data.remainPurchaseNum;
            nextCostDiamond = _loc3_.data.nextCostDiamond;
            bossIndex = param1.getType();
            trialSelectDifficultyUI.addBoss(bossIndex);
            trialSelectDifficultyUI.spr_select_difficulty.addChild(trialSelectDifficultyUI.difficultyList);
            trialSelectDifficultyUI.tf_remainTimes.text = "剩余挑战次数：" + remainTimes + "/3";
            if(remainTimes < 1 && PlayerVO.vipRank >= 6)
            {
               trialSelectDifficultyUI.btn_buyPurchase.visible = true;
            }
            else
            {
               trialSelectDifficultyUI.btn_buyPurchase.visible = false;
            }
            updateDifficultyList(bossIndex);
         }
      }
      
      private function updateDifficultyList(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         if(difficultyListData)
         {
            difficultyListData.removeAll();
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc2_ = 0;
         while(_loc2_ < TrialMediator.bossVoVec[param1].difficultyVec.length)
         {
            _loc3_ = new TrialDifficultyBtnUnit();
            _loc3_.setDifficultyBtn(bossIndex,_loc2_);
            _loc3_.setElfImg(TrialMediator.bossVoVec[param1].difficultyVec[_loc2_].pokePicture);
            _loc3_.btn_difficulty.name = _loc2_;
            _loc3_.addEventListener("triggered",difficultyBtn_triggeredHandler);
            displayVec.push(_loc3_);
            difficultyListData.push({
               "label":"",
               "accessory":_loc3_
            });
            _loc2_++;
         }
         trialSelectDifficultyUI.difficultyList.dataProvider = difficultyListData;
      }
      
      private function difficultyBtn_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         if(trialSelectDifficultyUI.difficultyList.isScrolling)
         {
            return;
         }
         if(remainTimes < 1)
         {
            if(PlayerVO.vipRank < 6)
            {
               Tips.show("亲，该馆主今天挑战次数已用完。");
               return;
            }
            if(remainPurchaseNum < 1)
            {
               Tips.show("亲，该馆主今天购买挑战次数已用完。");
               return;
            }
            _loc2_ = Alert.show("亲，剩余挑战次数不足哦，是否花费" + nextCostDiamond + "钻石购买，剩余购买次数" + remainPurchaseNum + "次，升级VIP可以增加购买次数哦。","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
            _loc2_.addEventListener("close",isBuyTimesAlert_closeHandler);
            return;
         }
         difficultyIndex = (param1.target as SwfButton).name;
         if(TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].openLv > PlayerVO.lv)
         {
            Tips.show("亲，开放需要" + TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].openLv + "级哦。");
            return;
         }
         (facade.retrieveProxy("TrialPro") as TrialPro).write2204(TrialMediator.bossVoVec[bossIndex].difficultyVec[difficultyIndex].id);
      }
      
      private function isBuyTimesAlert_closeHandler(param1:Event, param2:Object) : void
      {
         if(param1.data.label == "好的")
         {
            if(PlayerVO.diamond >= nextCostDiamond)
            {
               (Facade.getInstance().retrieveProxy("TrialPro") as TrialPro).write2205(TrialMediator.bossVoVec[bossIndex].bossId);
            }
            else
            {
               Tips.show("亲，钻石不足哦。");
            }
         }
      }
      
      private function removeDifficultyElfImg() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < displayVec.length)
         {
            if(displayVec[_loc1_] is TrialDifficultyBtnUnit)
            {
               LogUtil("移除难度img");
               (displayVec[_loc1_] as TrialDifficultyBtnUnit).destructImg();
            }
            _loc1_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["trial_update_select_difficulty","trial_close_boss_info","trial_difficulty_open","trial_buy_challenge_times"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         removeDifficultyElfImg();
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("TrialSelectDifficultyModiator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
