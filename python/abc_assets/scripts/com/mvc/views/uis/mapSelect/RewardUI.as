package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.mapSelect.MapVO;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.common.themes.Tips;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.animation.Tween;
   
   public class RewardUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mapSelect.RewardUI;
       
      private var mySpr:SwfSprite;
      
      private var swf:Swf;
      
      private var needStarTFOfNormal:TextField;
      
      private var needStarTFOfGood:TextField;
      
      private var needStarTFOfBest:TextField;
      
      private var currentStarTF:TextField;
      
      private var rewardBtn0:SwfButton;
      
      private var rewardBtn1:SwfButton;
      
      private var rewardBtn2:SwfButton;
      
      private var openBall0:SwfImage;
      
      private var openBall1:SwfImage;
      
      private var openBall2:SwfImage;
      
      private var recoverBtn:SwfButton;
      
      private var _currentCity:MapVO;
      
      public var currentStar:int;
      
      public var getReward:Array;
      
      public var isGetReward:Boolean;
      
      public function RewardUI()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mapSelect.RewardUI
      {
         return instance || new com.mvc.views.uis.mapSelect.RewardUI();
      }
      
      public function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         mySpr = swf.createSprite("spr_reward");
         needStarTFOfNormal = mySpr.getTextField("needStar1TF");
         needStarTFOfGood = mySpr.getTextField("needStar2TF");
         needStarTFOfBest = mySpr.getTextField("needStar3TF");
         currentStarTF = mySpr.getTextField("currentStarTF");
         rewardBtn0 = mySpr.getButton("reward1Btn");
         rewardBtn1 = mySpr.getButton("reward2Btn");
         rewardBtn2 = mySpr.getButton("reward3Btn");
         openBall0 = mySpr.getImage("openBallOfNormal");
         openBall1 = mySpr.getImage("openBallOfGood");
         openBall2 = mySpr.getImage("openBallOfBest");
         currentStarTF.text = "";
         needStarTFOfNormal.text = "";
         needStarTFOfGood.text = "";
         needStarTFOfBest.text = "";
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         addChild(mySpr);
         recoverBtn = swf.createButton("btn_bombBtn_b");
         var _loc2_:* = 0.8;
         recoverBtn.scaleY = _loc2_;
         recoverBtn.scaleX = _loc2_;
         recoverBtn.x = 10;
         recoverBtn.y = 565;
         addChild(recoverBtn);
         this.addEventListener("triggered",click);
         _loc1_.addEventListener("touch",closeTouch);
      }
      
      private function click(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(recoverBtn !== _loc2_)
         {
            if(rewardBtn0 !== _loc2_)
            {
               if(rewardBtn1 !== _loc2_)
               {
                  if(rewardBtn2 === _loc2_)
                  {
                     if(_currentCity.thirdBox <= currentStarTF.text)
                     {
                        (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1709(_currentCity.id,3);
                     }
                     else
                     {
                        Tips.show("星星数量不够");
                     }
                  }
               }
               else if(_currentCity.secondBox <= currentStarTF.text)
               {
                  (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1709(_currentCity.id,2);
               }
               else
               {
                  Tips.show("星星数量不够");
               }
            }
            else if(_currentCity.firstBox <= currentStarTF.text)
            {
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1709(_currentCity.id,1);
            }
            else
            {
               Tips.show("星星数量不够");
            }
         }
         else
         {
            close();
         }
      }
      
      private function closeTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.target as Quad);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            close();
         }
      }
      
      public function bomb(param1:MapVO) : void
      {
         _currentCity = param1;
         needStarTFOfNormal.text = param1.firstBox;
         needStarTFOfGood.text = param1.secondBox;
         needStarTFOfBest.text = param1.thirdBox;
         recoverBtn.touchable = true;
         (Starling.current.root as DisplayObjectContainer).addChild(this);
         mySpr.y = 230;
         mySpr.x = -800;
         var _loc2_:Tween = new Tween(mySpr,0.5,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.animate("x",235);
      }
      
      public function setShow() : void
      {
         var _loc1_:* = 0;
         currentStarTF.text = currentStar;
         isGetReward = false;
         _loc1_ = 0;
         while(_loc1_ < getReward.length)
         {
            var _loc2_:* = getReward[_loc1_];
            if(0 !== _loc2_)
            {
               if(1 !== _loc2_)
               {
                  if(2 === _loc2_)
                  {
                     setElfBall(_loc1_,true);
                  }
               }
               else
               {
                  isGetReward = true;
                  setElfBall(_loc1_,false);
               }
            }
            else
            {
               setElfBall(_loc1_,false);
            }
            _loc1_++;
         }
      }
      
      private function setElfBall(param1:int, param2:Boolean) : void
      {
         (this["rewardBtn" + param1] as SwfButton).visible = !param2;
         (this["openBall" + param1] as SwfImage).visible = param2;
      }
      
      public function close() : void
      {
         recoverBtn.touchable = false;
         var t:Tween = new Tween(mySpr,0.5,"easeIn");
         Starling.juggler.add(t);
         t.animate("x",-800);
         t.onComplete = function():void
         {
            if(getReward.indexOf(1) == -1)
            {
               isGetReward = false;
            }
            dispatchEventWith("close_alert");
            removeFromParent();
         };
      }
      
      override public function dispose() : void
      {
         instance = null;
         this.removeFromParent();
         super.dispose();
      }
   }
}
