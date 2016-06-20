package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntingRewardUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.util.ShowHelpTip;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetHuntingParty;
   import starling.display.Sprite;
   import lzm.starling.display.Button;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.huntingParty.HuntingPartyPro;
   
   public class HuntingRewardMedia extends Mediator
   {
      
      public static const NAME:String = "HuntingRewardMedia";
       
      public var huntingReward:HuntingRewardUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function HuntingRewardMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("HuntingRewardMedia",param1);
         huntingReward = param1 as HuntingRewardUI;
         huntingReward.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(huntingReward.btn_close !== _loc2_)
         {
            if(huntingReward.btn_help === _loc2_)
            {
               ShowHelpTip.getInstance().show(1);
            }
         }
         else
         {
            clean();
            WinTweens.closeWin(huntingReward.spr_reward,dispose);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SCOREREWARD_UI"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SCOREREWARD_UI" === _loc2_)
         {
            showList(param1.getBody() as int);
         }
      }
      
      private function showList(param1:int) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ < GetHuntingParty.rewardVec.length)
         {
            _loc3_ = huntingReward.setIcon(GetHuntingParty.rewardVec[_loc5_]);
            _loc6_ = new Sprite();
            switch(GetHuntingParty.rewardVec[_loc5_].state)
            {
               case 0:
                  _loc7_ = huntingReward.getBtn("btn_btn_noGet");
                  _loc7_.enabled = false;
                  break;
               case 1:
                  _loc7_ = huntingReward.getBtn("btn_btn_get_b");
                  _loc7_.enabled = true;
                  break;
               case 2:
                  _loc7_ = huntingReward.getBtn("btn_btn_getten");
                  _loc7_.enabled = false;
                  break;
            }
            _loc7_.x = -30;
            _loc7_.name = _loc5_.toString();
            _loc7_.addEventListener("triggered",getReward);
            _loc6_.addChild(_loc7_);
            _loc2_.push({
               "icon":_loc3_,
               "label":"",
               "accessory":_loc6_
            });
            displayVec.push(_loc3_,_loc6_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         huntingReward.rewardList.dataProvider = _loc4_;
         if(huntingReward.rewardList.dataProvider)
         {
            huntingReward.rewardList.scrollToDisplayIndex(param1);
         }
      }
      
      private function getReward(param1:Event) : void
      {
         var _loc2_:int = (param1.target as Button).name;
         (facade.retrieveProxy("HuntingPartyPro") as HuntingPartyPro).write4105(GetHuntingParty.rewardVec[_loc2_].rewardId);
      }
      
      private function clean() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         if(huntingReward.rewardList.dataProvider)
         {
            huntingReward.rewardList.dataProvider.removeAll();
            huntingReward.rewardList.dataProvider = null;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HuntingRewardMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
