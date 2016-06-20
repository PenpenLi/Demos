package com.mvc.views.mediator.mainCity.sign
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.sign.SignUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.mainCity.sign.SignVO;
   import com.mvc.models.proxy.mainCity.sign.SignPro;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.sign.RewardBaseUI;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import feathers.data.ListCollection;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class SignMedia extends Mediator
   {
      
      public static const NAME:String = "SignMedia";
       
      public var sign:SignUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var doubleArr:Array;
      
      public function SignMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         doubleArr = [[1,1],[3,2],[6,3],[8,4],[10,5],[11,6],[13,7],[15,8],[16,9],[18,10],[20,11],[21,12],[23,13],[25,14],[26,15],[28,15],[30,15]];
         super("SignMedia",param1);
         sign = param1 as SignUI;
         sign.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(sign.btn_close !== _loc2_)
         {
            if(sign.btn_get === _loc2_)
            {
               if(SignVO.lastRewardId < SignPro.addUpVec.length)
               {
                  if(SignVO.totalTimes >= SignPro.addUpVec[SignVO.lastRewardId].times)
                  {
                     (facade.retrieveProxy("SignPro") as SignPro).write2103();
                  }
                  else
                  {
                     Tips.show("累计次数不足以领取奖励");
                  }
               }
            }
         }
         else
         {
            if(sign.signRewardList.dataProvider)
            {
               sign.signRewardList.dataProvider.removeAll();
               sign.signRewardList.dataProvider = null;
            }
            sign.addUpContain.removeChildren(0,-1,true);
            WinTweens.closeWin(sign.spr_sign,remove);
         }
      }
      
      private function remove() : void
      {
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_SIGN_REWARDF" !== _loc2_)
         {
            if("UPDATE_SIGN_INFO" !== _loc2_)
            {
               if("UPDATE_UPADDSIGN_INFO" === _loc2_)
               {
                  showAddup();
                  sign.showUpaddProgress();
               }
            }
            else
            {
               sign.showSign();
            }
         }
         else
         {
            show();
            showAddup();
            sign.showSign();
            sign.showMonth();
            if(sign.signRewardList.dataProvider)
            {
               sign.signRewardList.scrollToDisplayIndex(SignVO.monthTimes / 5);
            }
         }
      }
      
      private function showAddup() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         sign.addUpContain.removeChildren(0,-1,true);
         _loc2_ = 0;
         while(_loc2_ < SignPro.addUpVec[SignVO.lastRewardId].rewardArr.length)
         {
            _loc1_ = new RewardBaseUI();
            _loc1_.rewardHandle(SignPro.addUpVec[SignVO.lastRewardId].rewardArr[_loc2_]);
            _loc1_.y = 115 * _loc2_;
            sign.addUpContain.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function show() : void
      {
         var _loc9_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc1_:Array = [];
         var _loc2_:* = 5;
         var _loc5_:int = Math.floor(SignPro.monRewardArr.length / _loc2_);
         var _loc3_:* = 0;
         if(SignPro.monRewardArr.length % _loc2_ > 0)
         {
            _loc5_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = new Sprite();
            _loc10_ = 0;
            while(_loc10_ < _loc2_)
            {
               if(_loc8_ * _loc2_ + _loc10_ <= SignPro.monRewardArr.length - 1)
               {
                  _loc4_ = new RewardBaseUI();
                  _loc4_.day = _loc8_ * _loc2_ + _loc10_;
                  if(doubleArr[_loc3_][0] == _loc8_ * _loc2_ + _loc10_ + 1)
                  {
                     _loc4_.addVIPDouble(doubleArr[_loc3_][1]);
                     if(doubleArr.length - 1 > _loc3_)
                     {
                        _loc3_++;
                     }
                  }
                  _loc4_.rewardHandle(SignPro.monRewardArr[_loc8_ * _loc2_ + _loc10_]);
                  _loc4_.x = 130 * _loc10_;
                  _loc6_.addChild(_loc4_);
                  displayVec.push(_loc4_);
                  _loc10_++;
                  continue;
               }
               break;
            }
            _loc1_.push({
               "icon":_loc6_,
               "label":""
            });
            _loc8_++;
         }
         var _loc7_:ListCollection = new ListCollection(_loc1_);
         sign.signRewardList.dataProvider = _loc7_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_SIGN_REWARDF","UPDATE_SIGN_INFO","UPDATE_UPADDSIGN_INFO"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         WinTweens.showCity();
         doubleArr = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("SignMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.signAssets);
      }
   }
}
