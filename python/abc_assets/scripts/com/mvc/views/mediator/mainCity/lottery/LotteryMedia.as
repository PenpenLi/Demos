package com.mvc.views.mediator.mainCity.lottery
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.lottery.LotteryUI;
   import com.mvc.views.uis.mainCity.lottery.LotteryLightUI;
   import lzm.starling.swf.display.SwfSprite;
   import flash.utils.Timer;
   import feathers.controls.Label;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.lotteryUi.LotteryPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.lottery.LotteryVO;
   import lzm.util.TimeUtil;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.lottery.LotteryItemUI;
   import starling.utils.deg2rad;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.util.RewardHandle;
   import flash.text.TextFormat;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class LotteryMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "LotteryMedia";
       
      public var _lottery:LotteryUI;
      
      private var _lotteryLightUI:LotteryLightUI;
      
      private var _lastItem:SwfSprite;
      
      private var _index:int;
      
      private var _ectorRadian:int;
      
      private var _overIndex:int;
      
      private var _circleNun:int;
      
      private var _goodLength:int;
      
      private var _countDownNum:int;
      
      private var _rotunAngle:int = 360;
      
      private var _countDownTimer:Timer;
      
      public var _prompt:Label;
      
      private var _displayVec:Vector.<DisplayObject>;
      
      private var _ifOver:Boolean = false;
      
      private var _colourAry:Array;
      
      public function LotteryMedia(param1:Object = null)
      {
         _colourAry = [13205491,14962051,16295546,16758867,5626974,4367288,4495565,5863885,8092621,7888322];
         super("LotteryMedia",param1);
         _lottery = param1 as LotteryUI;
         _displayVec = new Vector.<DisplayObject>([]);
         _lottery.addEventListener("triggered",clickHandler);
         _lastItem = _lottery.spr_turntable;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(_lottery.btn_close !== _loc2_)
         {
            if(_lottery.btn_recharge !== _loc2_)
            {
               if(_lotteryLightUI.btn_start === _loc2_)
               {
                  if(_ifOver)
                  {
                     return;
                  }
                  _ifOver = true;
                  (facade.retrieveProxy("LotteryPro") as LotteryPro).write4002();
               }
            }
            else
            {
               sendNotification("switch_win",null,"load_diamond_panel");
            }
         }
         else
         {
            if(_ifOver)
            {
               return;
            }
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("show_lottery_viewlist" !== _loc2_)
         {
            if("show_lottery_effect" !== _loc2_)
            {
               if("show_lottery_close" !== _loc2_)
               {
                  if("show_lottery_residue_time" !== _loc2_)
                  {
                     if("LOAD_LOTTERY_CLICKBTN" === _loc2_)
                     {
                        refreshData();
                     }
                  }
                  else
                  {
                     setTextCountDown();
                  }
               }
               else
               {
                  _ifOver = false;
               }
            }
            else
            {
               showTurnPointer();
               showTurnEffec();
            }
         }
         else
         {
            setShowData();
            showList();
            showItew();
         }
      }
      
      private function setShowData() : void
      {
         _goodLength = LotteryVO.rewardList.length;
         _ectorRadian = _rotunAngle / _goodLength;
         _countDownNum = LotteryVO.endTime - LotteryVO.startTime;
      }
      
      private function setTextCountDown() : void
      {
         if(LotteryPro.LotteryLessTime >= 0)
         {
            _lottery.timeText.text = TimeUtil.convertStringToDate(LotteryPro.LotteryLessTime);
         }
         else
         {
            _lottery.timeText.text = "时间未到！";
            _ifOver = true;
         }
      }
      
      private function showList() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(_displayVec);
         _displayVec = Vector.<DisplayObject>([]);
         _loc4_ = 0;
         while(_loc4_ < LotteryVO.payList.length)
         {
            _loc2_ = new Sprite();
            addName(_loc2_,LotteryVO.payList[_loc4_]);
            _loc1_.push({"label":"累计充值  <font color=\'#00EC00\'>" + LotteryVO.payList[_loc4_] + "</font>" + " 元增加一次"});
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         _lottery.lotteryList.dataProvider = _loc3_;
         _lottery.xplain.text = "活动规则\n活动时间内累计充值达到指定额度既可获得一次抽奖机会，抽奖机会限定于活动时间内使用，若无使用完活动结束后作废。 ";
         _lottery.count.text = LotteryVO.upTotalRes;
         _lottery.sumText.text = LotteryVO.currentTimes;
         _lottery.timeText.text = TimeUtil.convertStringToDate(_countDownNum);
         _lottery.diamondText.text = PlayerVO.diamond;
      }
      
      private function showItew() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         if(_lotteryLightUI)
         {
            _lottery.spr_lotteryBg.removeChild(_lotteryLightUI);
            _lotteryLightUI = null;
         }
         _lotteryLightUI = new LotteryLightUI(getStyle(_goodLength));
         _lottery.spr_lotteryBg.addChild(_lotteryLightUI);
         _lotteryLightUI.x = 165;
         _lotteryLightUI.y = 162;
         _lotteryLightUI.setLight();
         _loc2_ = 0;
         while(_loc2_ < _goodLength)
         {
            _loc1_ = new LotteryItemUI(getStyle(_goodLength),LotteryVO.rewardList[_loc2_]);
            _lastItem.addChild(_loc1_);
            _loc1_.rotation = deg2rad(_loc2_ * _rotunAngle / _goodLength);
            _loc1_.alignPivot("center","bottom");
            _loc1_.setImgColour(_colourAry[_loc2_]);
            _loc2_++;
         }
      }
      
      private function showTurnPointer() : void
      {
         _lotteryLightUI.btn_start.touchable = false;
         _lottery.diamondText.text = PlayerVO.diamond;
         LotteryVO.currentTimes = LotteryVO.currentTimes - 1;
         _lottery.sumText.text = LotteryVO.currentTimes;
         _overIndex = _rotunAngle - _ectorRadian * _index;
         _index = Math.random() * 10;
         var t:Tween = new Tween(_lotteryLightUI.spr_roundPointer,6,"easeOut");
         Starling.juggler.add(t);
         t.animate("rotation",deg2rad(_ectorRadian * _index + 1080));
         t.onUpdate = function():*
         {
            var /*UnknownSlot*/:* = §§dup(function():void
            {
               _lotteryLightUI.setLight();
            });
            return function():void
            {
               _lotteryLightUI.setLight();
            };
         }();
      }
      
      private function showTurnEffec() : void
      {
         var t:Tween = new Tween(_lastItem,10,"easeOut");
         Starling.juggler.add(t);
         t.animate("rotation",deg2rad(_index * _ectorRadian - getLottery() * _ectorRadian + 1440));
         t.onComplete = function():void
         {
            RewardHandle.Reward(LotteryPro.reward.reward);
            if(LotteryPro.reward.reward.diamond)
            {
               _lottery.diamondText.text = PlayerVO.diamond;
            }
            _lotteryLightUI.btn_start.touchable = true;
            _ifOver = false;
         };
      }
      
      private function refreshData() : void
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:int = _lottery.diamondText.text;
         if(_loc2_ != PlayerVO.diamond)
         {
            _loc1_ = (PlayerVO.diamond - _loc2_) / 10;
            _loc4_ = 0;
            while(_loc4_ < LotteryVO.payList.length)
            {
               if(LotteryVO.payList[_loc4_] > LotteryVO.upTotalRes && LotteryVO.payList[_loc4_] <= LotteryVO.upTotalRes)
               {
                  _loc3_++;
               }
               _loc4_++;
            }
            LotteryVO.upTotalRes = LotteryVO.upTotalRes + _loc1_;
            _lottery.count.text = LotteryVO.upTotalRes;
            LotteryVO.currentTimes = LotteryVO.currentTimes + _loc3_;
            _lottery.sumText.text = LotteryVO.currentTimes;
            _lottery.diamondText.text = PlayerVO.diamond;
         }
      }
      
      private function addName(param1:Sprite, param2:int) : void
      {
         _prompt = getLabel();
         param1.addChild(_prompt);
         _prompt.x = 25;
         _prompt.y = -10;
         _prompt.width = 320;
         _prompt.text = "累计充值  <font color=\'#00EC00\'>" + param2 + "</font>" + " 元增加一次";
      }
      
      private function getLabel() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.textRendererProperties.wordWrap = false;
         _loc1_.textRendererProperties.isHTML = true;
         _loc1_.textRendererProperties.textFormat = new TextFormat("FZCuYuan-M03S",25,10634246,true);
         return _loc1_;
      }
      
      private function getStyle(param1:int) : int
      {
         var _loc2_:* = 0;
         if(param1 == 10)
         {
            _loc2_ = 2;
         }
         else if(param1 == 8)
         {
            _loc2_ = 1;
         }
         return _loc2_;
      }
      
      private function getLottery() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < _goodLength)
         {
            if(LotteryVO.rewardList[_loc2_].id == LotteryPro.reward.id)
            {
               _loc1_ = _loc2_;
               return _loc1_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["show_lottery_viewlist","show_lottery_effect","show_lottery_close","show_lottery_residue_time","LOAD_LOTTERY_CLICKBTN"];
      }
      
      public function dispose() : void
      {
         _index = 0;
         DisposeDisplay.dispose(_displayVec);
         _displayVec = null;
         facade.removeMediator("LotteryMedia");
         UI.dispose();
         LoadSwfAssetsManager.getInstance().removeAsset(Config.lotteryAssets);
         viewComponent = null;
      }
   }
}
