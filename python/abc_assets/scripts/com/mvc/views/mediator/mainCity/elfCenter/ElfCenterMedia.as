package com.mvc.views.mediator.mainCity.elfCenter
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfCenter.ElfCenterUI;
   import flash.utils.Timer;
   import starling.animation.Tween;
   import starling.events.Event;
   import extend.SoundEvent;
   import starling.core.Starling;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.proxy.mainCity.elfCenter.ElfCenterPro;
   import feathers.data.ListCollection;
   import org.puremvc.as3.interfaces.INotification;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   import starling.text.TextField;
   import starling.display.DisplayObject;
   
   public class ElfCenterMedia extends Mediator
   {
      
      public static const NAME:String = "ElfCenterMedia";
       
      public var elfCenter:ElfCenterUI;
      
      private var globle:Function;
      
      private var countDownTimer:Timer;
      
      private var timeCD:int;
      
      private var count:int;
      
      private var glint:Tween;
      
      private var sound:String;
      
      public function ElfCenterMedia(param1:Object = null)
      {
         countDownTimer = new Timer(1000);
         super("ElfCenterMedia",param1);
         elfCenter = param1 as ElfCenterUI;
         elfCenter.addEventListener("triggered",clickHandler);
      }
      
      private function onchange(param1:Event, param2:int, param3:Boolean = false) : void
      {
         e = param1;
         i = param2;
         isAll = param3;
         elfCenter.btn_Recover.enabled = false;
         elfCenter.btn_close.enabled = false;
         elfCenter.btn_recoverAll.enabled = false;
         if(elfCenter.mc_cartoon.currentFrame % 15 == 0)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
         }
         if(elfCenter.mc_cartoon.currentFrame == i)
         {
            SoundEvent.dispatchEvent("play_music_and_stop_bg",{
               "musicName":"recover",
               "isContinuePlayBGM":true
            });
            elfCenter.mc_cartoon.gotoAndStop(i);
            glint = new Tween(elfCenter.mc_cartoon,0.5);
            Starling.juggler.add(glint);
            glint.animate("alpha",1,0);
            glint.repeatCount = 5;
            glint.onComplete = function():void
            {
               elfCenter.mc_cartoon.visible = false;
               elfCenter.btn_Recover.enabled = true;
               elfCenter.btn_close.enabled = true;
               elfCenter.btn_recoverAll.enabled = true;
               if(!isAll)
               {
                  BeginnerGuide.playBeginnerGuide();
                  Tips.show("恢复成功  剩余次数:" + elfCenter.count.text);
               }
               else
               {
                  sendNotification("UPDATE_COM_ELF");
               }
               elfCenter.prompt.text = "你的精灵都恢复精神了! 欢迎下次再来哦!";
               textPlayAni();
               sendNotification("UPDATE_BAG_ELF");
               PlayerVO.isAcceptPvp = true;
            };
            elfCenter.mc_cartoon.removeEventListener("enterFrame",globle);
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         e = param1;
         var _loc3_:* = e.target;
         if(elfCenter.btn_close !== _loc3_)
         {
            if(elfCenter.btn_Recover !== _loc3_)
            {
               if(elfCenter.btn_buyBtn !== _loc3_)
               {
                  if(elfCenter.btn_playTip !== _loc3_)
                  {
                     if(elfCenter.btn_recoverAll === _loc3_)
                     {
                        var recoveAllSure:Alert = Alert.show("全体恢复将会消耗10颗钻石! 确定要用么?","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                        recoveAllSure.addEventListener("close",recoveAllSureHandler);
                     }
                  }
                  else
                  {
                     elfCenter.addHelp();
                  }
               }
               else
               {
                  var buySure:Alert = Alert.show("你确定用100金币购买一次恢复机会么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  buySure.addEventListener("close",buySureHandler);
               }
            }
            else
            {
               if(GetElfFactor.checkStatus() && Config.isCompleteBeginner)
               {
                  Tips.show("精灵的状态已满，请下次再来哦！");
                  return;
               }
               if(count <= 0)
               {
                  Tips.show("亲，剩余回复次数不足哦。");
                  return;
               }
               LogUtil("=================================",PlayerVO.bagElfVec);
               PlayerVO.isAcceptPvp = false;
               elfCenter.mc_cartoon.visible = true;
               elfCenter.mc_cartoon.gotoAndPlay(0);
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
               globle = §§dup(function(param1:Event):void
               {
                  onchange(param1,GetElfFactor.seriesElfNum(PlayerVO.bagElfVec) * 15 - 1);
               });
               elfCenter.mc_cartoon.addEventListener("enterFrame",function(param1:Event):void
               {
                  onchange(param1,GetElfFactor.seriesElfNum(PlayerVO.bagElfVec) * 15 - 1);
               });
               (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2008("elfCenter");
            }
         }
         else
         {
            elfCenter.clean();
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      private function buySureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            if(PlayerVO.silver < 100)
            {
               Tips.show("金币不足");
               return;
            }
            (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2009("elfCenter");
         }
      }
      
      private function recoveAllSureHandler(param1:Event, param2:Object) : void
      {
         e = param1;
         data = param2;
         if(data.label == "确定")
         {
            if(PlayerVO.diamond < 10)
            {
               Tips.show("钻石不足");
               return;
            }
            PlayerVO.isAcceptPvp = false;
            elfCenter.mc_cartoon.visible = true;
            elfCenter.mc_cartoon.gotoAndPlay(0);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
            globle = §§dup(function(param1:Event):void
            {
               onchange(param1,89,true);
            });
            elfCenter.mc_cartoon.addEventListener("enterFrame",function(param1:Event):void
            {
               onchange(param1,89,true);
            });
            (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2021();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_ELFCENTER" !== _loc2_)
         {
            if("SEND_COUNT_DOWN" !== _loc2_)
            {
               if("elfcenter_buy_recover" !== _loc2_)
               {
                  if("ELF_RECOVER" === _loc2_)
                  {
                     count = param1.getBody() as int;
                     if(count <= 0)
                     {
                        elfCenter.btn_buyBtn.visible = true;
                     }
                     elfCenter.count.text = count + "/" + PlayerVO.vipInfoVO.pmCenter;
                  }
               }
               else
               {
                  count = count + 1;
                  elfCenter.count.text = count + "/" + PlayerVO.vipInfoVO.pmCenter;
                  elfCenter.btn_buyBtn.visible = false;
               }
            }
            else
            {
               timeCD = param1.getBody() as int;
               if(count < PlayerVO.vipInfoVO.pmCenter && timeCD >= 0)
               {
                  elfCenter.showDown(true);
                  countDownTimer.addEventListener("timer",countDownEvent);
                  countDownTimer.start();
                  LogUtil("精灵中心的计时器开启");
               }
            }
         }
         else
         {
            count = param1.getBody() as int;
            elfCenter.prompt.text = "你好, 这里是精灵中心, 要让你的精灵休息一下么？";
            textPlayAni();
            elfCenter.count.text = count + "/" + PlayerVO.vipInfoVO.pmCenter;
            if(count <= 0)
            {
               elfCenter.btn_buyBtn.visible = true;
            }
         }
      }
      
      protected function countDownEvent(param1:TimerEvent) : void
      {
         if(timeCD > 0)
         {
            timeCD = timeCD - 1;
            elfCenter.countDown.text = TimeUtil.convertStringToDate(timeCD);
         }
         else
         {
            count = §§dup(count + 1);
            if(count + 1 < PlayerVO.vipInfoVO.pmCenter)
            {
               timeCD = 900;
               elfCenter.count.text = count + "/" + PlayerVO.vipInfoVO.pmCenter;
               elfCenter.btn_buyBtn.visible = false;
            }
            else
            {
               elfCenter.count.text = count + "/" + PlayerVO.vipInfoVO.pmCenter;
               countDownTimer.stop();
               countDownTimer.removeEventListener("timer",countDownEvent);
               elfCenter.showDown(false);
               LogUtil("精灵中心的计时器关闭");
            }
         }
      }
      
      private function textPlayAni() : void
      {
         Starling.juggler.removeTweens(elfCenter.prompt);
         var t:Tween = new Tween(elfCenter.prompt,elfCenter.prompt.text.length / 15);
         Starling.juggler.add(t);
         elfCenter.mc_mouth.gotoAndPlay(0);
         elfCenter.mc_eye.gotoAndPlay(0);
         t.onUpdate = playTextAni;
         t.onUpdateArgs = [elfCenter.prompt.text,t,elfCenter.prompt];
         t.onComplete = function():void
         {
            if(elfCenter.mc_mouth)
            {
               elfCenter.mc_mouth.gotoAndStop(10);
            }
         };
      }
      
      private function playTextAni(param1:String, param2:Tween, param3:TextField) : void
      {
         var _loc4_:int = param1.length * param2.progress;
         param3.text = param1.substr(0,_loc4_);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_ELFCENTER","SEND_COUNT_DOWN","elfcenter_buy_recover","ELF_RECOVER"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         LogUtil("精灵中心的计时器关闭dispose");
         countDownTimer.stop();
         countDownTimer.removeEventListener("timer",countDownEvent);
         countDownTimer = null;
         Starling.juggler.removeTweens(elfCenter.prompt);
         elfCenter.mc_eye.stop();
         elfCenter.mc_eye.removeFromParent(true);
         elfCenter.mc_mouth.stop();
         elfCenter.mc_mouth.removeFromParent(true);
         facade.removeMediator("ElfCenterMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
