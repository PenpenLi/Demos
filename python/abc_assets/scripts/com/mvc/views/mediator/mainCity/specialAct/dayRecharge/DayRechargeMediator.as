package com.mvc.views.mediator.mainCity.specialAct.dayRecharge
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.specialAct.dayRecharge.DayRechargeUI;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import starling.display.DisplayObject;
   import com.common.util.WinTweens;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class DayRechargeMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "DayRechargeMediator";
       
      public var dayRechargeUI:DayRechargeUI;
      
      public function DayRechargeMediator(param1:Object = null)
      {
         super("DayRechargeMediator",param1);
         dayRechargeUI = param1 as DayRechargeUI;
         dayRechargeUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(dayRechargeUI.btn_close !== _loc2_)
         {
            if(dayRechargeUI.btn_recharge === _loc2_)
            {
               sendNotification("switch_win",null,"load_diamond_panel");
            }
         }
         else
         {
            dispose();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = param1.getName();
         if(ConfigConst.UPDATE_DAYRECHARGE_INFO !== _loc4_)
         {
            if(ConfigConst.UPDATE_DAYRECHARGE_STATE_INFO === _loc4_)
            {
               _loc2_ = param1.getBody();
               dayRechargeUI.updateState(_loc2_);
            }
         }
         else
         {
            _loc3_ = param1.getBody();
            dayRechargeUI.setReward(_loc3_.rewardArr);
            dayRechargeUI.setBtnByState(_loc3_.stateArr);
            dayRechargeUI.tf_rechargeDate.text = _loc3_.actTime;
            dayRechargeUI.tf_rechargeMoney.text = _loc3_.reqNum;
            dayRechargeUI.tf_rechargeNum.text = _loc3_.doTimes;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.UPDATE_DAYRECHARGE_INFO,ConfigConst.UPDATE_DAYRECHARGE_STATE_INFO];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("DayRechargeMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.dayRechargeAssets);
      }
   }
}
