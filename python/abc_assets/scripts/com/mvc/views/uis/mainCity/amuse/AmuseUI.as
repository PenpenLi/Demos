package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import flash.utils.Timer;
   import lzm.starling.display.Button;
   import starling.display.Quad;
   import feathers.controls.ScrollContainer;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   import starling.core.Starling;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.TiledColumnsLayout;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import flash.geom.Rectangle;
   import starling.animation.Tween;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class AmuseUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_amuseBg:SwfSprite;
      
      public var drawSpr:SwfSprite;
      
      public var btn_mainClose:SwfButton;
      
      public var btn_preview:SwfButton;
      
      public var btn_extractionTen0:SwfButton;
      
      public var btn_extractionTen1:SwfButton;
      
      public var btn_extractionTen2:SwfButton;
      
      public var btn_extractionOne0:SwfButton;
      
      public var btn_extractionOne1:SwfButton;
      
      public var btn_extractionOne2:SwfButton;
      
      public var promptTen0:TextField;
      
      public var promptTen1:TextField;
      
      public var promptTen2:TextField;
      
      public var prompt0:TextField;
      
      public var prompt1:TextField;
      
      public var prompt2:TextField;
      
      public var spendDiamTen0:TextField;
      
      public var spendDiamTen1:TextField;
      
      public var spendDiamTen2:TextField;
      
      private var spendDiam_old0:SwfSprite;
      
      private var spendDiam_old1:SwfSprite;
      
      private var spendDiam_old2:SwfSprite;
      
      private var spendDiamTen_old0:SwfSprite;
      
      private var spendDiamTen_old1:SwfSprite;
      
      private var spendDiamTen_old2:SwfSprite;
      
      public var spendDiam0:TextField;
      
      public var spendDiam1:TextField;
      
      public var spendDiam2:TextField;
      
      private var countDownTimer:Timer;
      
      public var spr_playTipBg_s:SwfSprite;
      
      private var tipTf:TextField;
      
      public var btn_playTip:Button;
      
      public var btn_scoreRecharge:Button;
      
      private var helpBg:Quad;
      
      public var spr_0:SwfSprite;
      
      public var spr_1:SwfSprite;
      
      public var spr_2:SwfSprite;
      
      public var spr_actTime_s:SwfSprite;
      
      public var spr_horn0:SwfSprite;
      
      public var spr_horn1:SwfSprite;
      
      public var tf_drawNum0:TextField;
      
      public var tf_drawNum1:TextField;
      
      private var actRewardContainerVec:Vector.<ScrollContainer>;
      
      private var preRewardContainerVec:Vector.<ScrollContainer>;
      
      public function AmuseUI()
      {
         countDownTimer = new Timer(1000);
         actRewardContainerVec = new Vector.<ScrollContainer>([]);
         preRewardContainerVec = new Vector.<ScrollContainer>([]);
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuse");
         spr_amuseBg = swf.createSprite("spr_amuseBg");
         addChild(spr_amuseBg);
         drawSpr = spr_amuseBg.getSprite("drawSpr");
         spr_0 = drawSpr.getSprite("spr_0");
         spr_1 = drawSpr.getSprite("spr_1");
         spr_2 = drawSpr.getSprite("spr_2");
         if(PlayerVO.vipRank < 10)
         {
            spr_2.visible = false;
            spr_0.x = spr_0.x + 135;
            spr_1.x = spr_1.x + 250;
         }
         spendDiam_old0 = spr_0.getSprite("spendDiam_old0");
         spendDiam_old0.visible = false;
         spendDiam_old1 = spr_1.getSprite("spendDiam_old1");
         spendDiam_old1.visible = false;
         spendDiam_old2 = spr_2.getSprite("spendDiam_old2");
         spendDiam_old2.visible = false;
         spendDiamTen_old0 = spr_0.getSprite("spendDiamTen_old0");
         spendDiamTen_old0.getTextField("tf_oldPrice").text = "原价：45000";
         spendDiamTen_old0.visible = false;
         spendDiamTen_old1 = spr_1.getSprite("spendDiamTen_old1");
         spendDiamTen_old1.getTextField("tf_oldPrice").text = "原价：3080";
         spendDiamTen_old1.visible = false;
         spendDiamTen_old2 = spr_2.getSprite("spendDiamTen_old2");
         spendDiamTen_old2.getTextField("tf_oldPrice").text = "原价：4500";
         spendDiamTen_old2.visible = false;
         spr_horn0 = spr_1.getSprite("spr_horn0");
         spr_horn0.visible = false;
         spr_horn1 = spr_2.getSprite("spr_horn1");
         spr_horn1.visible = false;
         btn_mainClose = drawSpr.getButton("btn_mainClose");
         btn_mainClose.name = "btn_close";
         btn_preview = drawSpr.getButton("btn_preview");
         btn_preview.visible = false;
         btn_playTip = drawSpr.getButton("btn_playTip");
         btn_playTip.visible = false;
         btn_scoreRecharge = drawSpr.getButton("btn_scoreRecharge");
         btn_extractionTen0 = spr_0.getButton("btn_extractionTen0");
         btn_extractionTen1 = spr_1.getButton("btn_extractionTen1");
         btn_extractionTen2 = spr_2.getButton("btn_extractionTen2");
         btn_extractionOne0 = spr_0.getButton("btn_extractionOne0");
         btn_extractionOne0.name = "btn_extractionOne0";
         btn_extractionOne1 = spr_1.getButton("btn_extractionOne1");
         btn_extractionOne2 = spr_2.getButton("btn_extractionOne2");
         promptTen0 = spr_0.getTextField("promptTen0");
         promptTen1 = spr_1.getTextField("promptTen1");
         if(PlayerVO.recruitTimes[4] > 0)
         {
            promptTen1.text = "十连抽必出 高级狩猎券";
         }
         else
         {
            promptTen1.text = "首次十连必出史诗精灵";
         }
         promptTen2 = spr_2.getTextField("promptTen2");
         spendDiamTen0 = spr_0.getTextField("spendDiamTen0");
         spendDiamTen1 = spr_1.getTextField("spendDiamTen1");
         spendDiamTen2 = spr_2.getTextField("spendDiamTen2");
         prompt0 = spr_0.getTextField("prompt0");
         prompt1 = spr_1.getTextField("prompt1");
         prompt2 = spr_2.getTextField("prompt2");
         spendDiam0 = spr_0.getTextField("spendDiam0");
         spendDiam1 = spr_1.getTextField("spendDiam1");
         spendDiam2 = spr_2.getTextField("spendDiam2");
         tf_drawNum0 = spr_horn0.getTextField("tf_drawNum");
         tf_drawNum1 = spr_horn1.getTextField("tf_drawNum");
         spr_playTipBg_s = swf.createSprite("spr_playTipBg_s");
         tipTf = spr_playTipBg_s.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         tipTf.text = "";
         addPreviewReward();
      }
      
      public function addHelp() : void
      {
         if(!helpBg)
         {
            helpBg = new Quad(1136,640,0);
            helpBg.alpha = 0.7;
            spr_playTipBg_s.addChildAt(helpBg,0);
         }
         addChild(spr_playTipBg_s);
         spr_playTipBg_s.addEventListener("touch",playTipImg_touchHandler);
      }
      
      public function clean() : void
      {
         spr_playTipBg_s.removeFromParent(true);
         spr_playTipBg_s = null;
      }
      
      private function playTipImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_playTipBg_s);
         if(_loc2_ != null && _loc2_.phase == "ended")
         {
            spr_playTipBg_s.removeFromParent();
            spr_playTipBg_s.removeEventListener("touch",playTipImg_touchHandler);
         }
      }
      
      public function showTime() : void
      {
         var _loc2_:* = false;
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < AmusePro.onceTimeVec.length)
         {
            if(AmusePro.onceTimeVec[_loc1_] <= 0)
            {
               if(_loc1_ == 0)
               {
                  if(AmusePro.recruitFreeTimes == 0)
                  {
                     (this["prompt0"] as TextField).text = "免费次数已用完";
                  }
                  else
                  {
                     (this["prompt0"] as TextField).text = "免费抽取（剩余" + AmusePro.recruitFreeTimes + "次）";
                  }
               }
               else
               {
                  (this["prompt" + _loc1_] as TextField).text = "免费抽取";
               }
            }
            else
            {
               _loc2_ = true;
            }
            _loc1_++;
         }
         if(_loc2_)
         {
            countDownEvent(null,false);
            countDownTimer.addEventListener("timer",countDownEvent);
            countDownTimer.start();
            LogUtil("扭蛋机的计时器开启");
         }
      }
      
      private function jsmaxTime() : int
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < AmusePro.onceTimeVec.length)
         {
            _loc1_.push(AmusePro.onceTimeVec[_loc2_]);
            _loc2_++;
         }
         _loc1_.sort(16);
         return _loc1_[_loc1_.length - 1];
      }
      
      protected function countDownEvent(param1:TimerEvent = null, param2:Boolean = true) : void
      {
         var _loc3_:* = 0;
         if(jsmaxTime() <= 0)
         {
            stopTimer();
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < AmusePro.onceTimeVec.length)
         {
            if(param2 && AmusePro.onceTimeVec[_loc3_])
            {
               var _loc4_:* = AmusePro.onceTimeVec;
               var _loc5_:* = _loc3_;
               var _loc6_:* = _loc4_[_loc5_] - 1;
               _loc4_[_loc5_] = _loc6_;
            }
            if(AmusePro.onceTimeVec[_loc3_] > 0)
            {
               (this["prompt" + _loc3_] as TextField).text = "单抽下次免费：" + TimeUtil.convertStringToDate(AmusePro.onceTimeVec[_loc3_]);
            }
            else if(_loc3_ == 0)
            {
               if(AmusePro.recruitFreeTimes == 0)
               {
                  (this["prompt0"] as TextField).text = "免费次数已用完";
               }
               else
               {
                  (this["prompt0"] as TextField).text = "免费抽取（剩余" + AmusePro.recruitFreeTimes + "次）";
               }
            }
            else
            {
               (this["prompt" + _loc3_] as TextField).text = "免费抽取";
            }
            _loc3_++;
         }
      }
      
      public function stopTimer() : void
      {
         LogUtil("扭蛋机的计时器关闭");
         countDownTimer.stop();
         countDownTimer.removeEventListener("timer",countDownEvent);
      }
      
      public function updateCost(param1:Array) : void
      {
         spendDiamTen0.text = param1[1];
         spendDiamTen1.text = param1[3];
         spendDiamTen2.text = param1[5];
         if(param1[1] < 45000)
         {
            spendDiamTen_old0.visible = true;
         }
         else if(param1[1] == 45000)
         {
            spendDiamTen_old0.visible = false;
         }
         if(param1[3] < 3080)
         {
            spendDiamTen_old1.visible = true;
         }
         else if(param1[3] == 3080)
         {
            spendDiamTen_old1.visible = false;
         }
         if(param1[5] < 4500)
         {
            spendDiamTen_old2.visible = true;
         }
         else if(param1[5] == 4500)
         {
            spendDiamTen_old2.visible = false;
         }
      }
      
      public function updateDiscountTime() : void
      {
         if(!spr_actTime_s)
         {
            spr_actTime_s = swf.createSprite("spr_actTime_s");
            spr_actTime_s.x = 1136 - spr_actTime_s.width >> 1;
            spr_actTime_s.y = 85;
            spr_amuseBg.addChild(spr_actTime_s);
         }
         var tf_time:TextField = spr_actTime_s.getTextField("tf_time");
         if(AmusePro.discountLessTime > 0)
         {
            tf_time.text = "扭蛋折扣活动结束倒计时：" + TimeUtil.convertStringToDate2(AmusePro.discountLessTime);
         }
         else if(AmusePro.tenDrawLessTime > 0)
         {
            tf_time.text = "累计十连必出道具活动结束倒计时：" + TimeUtil.convertStringToDate2(AmusePro.tenDrawLessTime);
         }
         else
         {
            spr_actTime_s.removeFromParent(true);
            spr_actTime_s = null;
            Starling.current.juggler.delayCall(function():void
            {
               (Facade.getInstance().retrieveProxy("AmusePro") as AmusePro).write2500();
            },2);
         }
      }
      
      public function showTenDrawReward(param1:Array) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         removeActRewardContainer();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            (this["spr_horn" + _loc2_] as SwfSprite).visible = true;
            if(param1[_loc2_].nowTimes == param1[_loc2_].times)
            {
               (this["tf_drawNum" + _loc2_] as TextField).text = "（" + param1[_loc2_].nowTimes + "/" + param1[_loc2_].times + "）" + "下次十连必出";
            }
            else
            {
               (this["tf_drawNum" + _loc2_] as TextField).text = "十连抽已累计：（" + param1[_loc2_].nowTimes + "/" + param1[_loc2_].times + "）";
            }
            _loc3_ = new ScrollContainer();
            _loc3_.x = 38;
            _loc3_.y = 6;
            _loc3_.width = 175;
            _loc3_.height = 55;
            setHorizontalLayout(_loc3_);
            addTenDrawReward(param1[_loc2_],_loc3_);
            (this["spr_horn" + _loc2_] as SwfSprite).addChild(_loc3_);
            actRewardContainerVec.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function addTenDrawReward(param1:Object, param2:ScrollContainer) : void
      {
         var _loc7_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = 0;
         var _loc5_:* = null;
         if(param1.hasOwnProperty("pId"))
         {
            _loc4_ = 0;
            while(_loc4_ < param1.pId.length)
            {
               _loc7_ = new AmuseScoreRechargeGoodUnit();
               var _loc8_:* = 0.43;
               _loc7_.scaleY = _loc8_;
               _loc7_.scaleX = _loc8_;
               _loc3_ = GetPropFactor.getPropVO(param1.pId[_loc4_]);
               _loc7_.addPropSpr(_loc3_);
               param2.addChild(_loc7_);
               _loc4_++;
            }
         }
         if(param1.hasOwnProperty("spId"))
         {
            _loc6_ = 0;
            while(_loc6_ < param1.spId.length)
            {
               _loc7_ = new AmuseScoreRechargeGoodUnit();
               _loc8_ = 0.43;
               _loc7_.scaleY = _loc8_;
               _loc7_.scaleX = _loc8_;
               _loc5_ = GetElfFactor.getElfVO(param1.spId[_loc6_],false);
               _loc7_.addElfImg(_loc5_);
               param2.addChild(_loc7_);
               _loc6_++;
            }
         }
      }
      
      private function setHorizontalLayout(param1:ScrollContainer) : void
      {
         var _loc2_:HorizontalLayout = new HorizontalLayout();
         _loc2_.horizontalAlign = "center";
         _loc2_.verticalAlign = "middle";
         _loc2_.gap = 8;
         param1.layout = _loc2_;
         param1.verticalScrollPolicy = "off";
      }
      
      private function setTiledColumnsLayout(param1:ScrollContainer) : void
      {
         var _loc2_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc2_.horizontalAlign = "center";
         _loc2_.verticalAlign = "middle";
         _loc2_.gap = 10;
         param1.layout = _loc2_;
         param1.horizontalScrollPolicy = "off";
         param1.verticalScrollPolicy = "off";
      }
      
      private function removeActRewardContainer() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < actRewardContainerVec.length)
         {
            actRewardContainerVec[_loc1_].removeChildren(0,-1,true);
            actRewardContainerVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         actRewardContainerVec = Vector.<ScrollContainer>([]);
      }
      
      private function removePreRewardContainer() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < preRewardContainerVec.length)
         {
            preRewardContainerVec[_loc1_].removeChildren(0,-1,true);
            preRewardContainerVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         preRewardContainerVec = Vector.<ScrollContainer>([]);
         if(ExtendElfUnitTips.instance)
         {
            ExtendElfUnitTips.getInstance().removeElfTips();
         }
         if(FirstRchRewardTips.instance)
         {
            FirstRchRewardTips.getInstance().removePropTips();
         }
      }
      
      public function addPreviewReward() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc1_:* = null;
         removePreRewardContainer();
         _loc2_ = 0;
         while(_loc2_ < AmusePro.onceTimeVec.length)
         {
            _loc3_ = new ScrollContainer();
            _loc3_.x = 45;
            _loc3_.y = 160;
            _loc3_.width = 270;
            _loc3_.height = 185;
            _loc1_ = new Rectangle(0,0,_loc3_.width,_loc3_.height);
            _loc3_.clipRect = _loc1_;
            setTiledColumnsLayout(_loc3_);
            addPreReward(AmusePro.amusePreviewArr[_loc2_],_loc3_);
            (this["spr_" + _loc2_] as SwfSprite).addChild(_loc3_);
            preRewardContainerVec.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function showPreContainerTween() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < preRewardContainerVec.length)
         {
            preContainerTween(preRewardContainerVec[_loc1_],preRewardContainerVec[_loc1_].clipRect);
            _loc1_++;
         }
      }
      
      private function preContainerTween(param1:ScrollContainer, param2:Rectangle) : void
      {
         var _loc3_:Tween = new Tween(param1,0.5);
         Starling.current.juggler.add(_loc3_);
         _loc3_.animate("alpha",1,0);
      }
      
      private function addPreReward(param1:Array, param2:ScrollContainer) : void
      {
         var _loc6_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = null;
         _loc4_ = 0;
         while(_loc4_ < 6)
         {
            _loc6_ = new AmuseScoreRechargeGoodUnit();
            if(param1[0] is PropVO)
            {
               var _loc7_:* = 0.6;
               _loc6_.scaleY = _loc7_;
               _loc6_.scaleX = _loc7_;
               _loc3_ = GetPropFactor.getPropVO((param1[0] as PropVO).id);
               _loc6_.addPropSpr(_loc3_);
            }
            if(param1[0] is ElfVO)
            {
               _loc7_ = 0.6;
               _loc6_.scaleY = _loc7_;
               _loc6_.scaleX = _loc7_;
               _loc5_ = GetElfFactor.getElfVO((param1[0] as ElfVO).elfId,false);
               _loc6_.addElfImg(_loc5_);
            }
            param2.addChild(_loc6_);
            param1.push(param1.shift());
            _loc4_++;
         }
      }
   }
}
