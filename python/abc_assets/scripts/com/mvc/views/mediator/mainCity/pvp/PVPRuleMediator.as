package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPRuleUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.RewardHandle;
   import starling.text.TextField;
   import starling.display.DisplayObject;
   
   public class PVPRuleMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPRuleMediator";
       
      public var pvpRuleUI:PVPRuleUI;
      
      public function PVPRuleMediator(param1:Object = null)
      {
         super("PVPRuleMediator",param1);
         pvpRuleUI = param1 as PVPRuleUI;
         pvpRuleUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpRuleUI.closeBtn === _loc2_)
         {
            WinTweens.closeWin(pvpRuleUI.spr_rule,removeWindow);
         }
      }
      
      private function removeWindow() : void
      {
         pvpRuleUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("check_pvp_rank_reward" === _loc3_)
         {
            _loc2_ = param1.getBody();
            pvpRuleUI.scrollContainer.removeChildren(0,-1,true);
            RewardHandle.showReward(_loc2_.data.reward,pvpRuleUI.scrollContainer,0.8);
            (pvpRuleUI.spr_rankRewardTips.getChildByName("maxRank") as TextField).text = _loc2_.data.bestRank;
            (pvpRuleUI.spr_rankRewardTips.getChildByName("rank") as TextField).text = "保持当前排名：（第" + _loc2_.data.rank + "名），可领取奖励为：";
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["check_pvp_rank_reward"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         pvpRuleUI.scrollContainer.removeChildren(0,-1,true);
         facade.removeMediator("PVPRuleMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
