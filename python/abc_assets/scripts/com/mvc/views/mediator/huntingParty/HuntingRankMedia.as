package com.mvc.views.mediator.huntingParty
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.huntingParty.HuntingRankUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.util.ShowHelpTip;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.util.TimeUtil;
   import com.mvc.models.vos.huntingParty.HuntRankVO;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import feathers.data.ListCollection;
   
   public class HuntingRankMedia extends Mediator
   {
      
      public static const NAME:String = "HuntingRankMedia";
       
      public var huntingRank:HuntingRankUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public var displayVec2:Vector.<DisplayObject>;
      
      public function HuntingRankMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         displayVec2 = new Vector.<DisplayObject>([]);
         super("HuntingRankMedia",param1);
         huntingRank = param1 as HuntingRankUI;
         huntingRank.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(huntingRank.btn_close !== _loc2_)
         {
            if(huntingRank.btn_help === _loc2_)
            {
               ShowHelpTip.getInstance().show(1);
            }
         }
         else
         {
            removeHandle();
            WinTweens.closeWin(huntingRank.spr_rank,dispose);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SCORERANK_UI","UPDATE_RANKSCORE_TIME"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SCORERANK_UI" !== _loc2_)
         {
            if("UPDATE_RANKSCORE_TIME" === _loc2_)
            {
               huntingRank.CDTime.text = TimeUtil.convertStringToDate(HuntRankVO.lessTime);
            }
         }
         else
         {
            huntingRank.setInfo();
            showRewardList();
            showRankList();
         }
      }
      
      private function showRewardList() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < HuntRankVO.rewardVec.length)
         {
            _loc2_ = huntingRank.setIcon(HuntRankVO.rewardVec[_loc4_]);
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec.push(_loc2_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         huntingRank.rewardList.dataProvider = _loc3_;
         showRankList();
      }
      
      private function showRankList() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec2);
         displayVec2 = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < HuntRankVO.allRankVec.length)
         {
            _loc2_ = huntingRank.setIcon2(HuntRankVO.allRankVec[_loc4_]);
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec2.push(_loc2_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         huntingRank.rankList.dataProvider = _loc3_;
      }
      
      private function removeHandle() : void
      {
         if(huntingRank.rankList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec2);
            displayVec2 = Vector.<DisplayObject>([]);
            huntingRank.rankList.dataProvider.removeAll();
            huntingRank.rankList.dataProvider = null;
         }
         if(huntingRank.rewardList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            huntingRank.rewardList.dataProvider.removeAll();
            huntingRank.rewardList.dataProvider = null;
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         facade.removeMediator("HuntingRankMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
