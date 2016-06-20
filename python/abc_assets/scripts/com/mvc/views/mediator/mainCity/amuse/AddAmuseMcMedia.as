package com.mvc.views.mediator.mainCity.amuse
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.amuse.AddAmuseMcUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.events.EventCenter;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.amuse.AmuseElfInfoUI;
   import starling.display.Image;
   import starling.utils.deg2rad;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import starling.display.DisplayObject;
   
   public class AddAmuseMcMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "addAmuseMcMedia";
       
      private var addAmuseMcUI:AddAmuseMcUI;
      
      private var rewardArr:Array;
      
      private var rewardNum:int;
      
      private var sendRewardTimes:int = 1;
      
      private var elfVo:ElfVO;
      
      public function AddAmuseMcMedia(param1:Object = null)
      {
         super("addAmuseMcMedia",param1);
         addAmuseMcUI = param1 as AddAmuseMcUI;
         addAmuseMcUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(addAmuseMcUI.drawBtn2 !== _loc2_)
         {
            if(addAmuseMcUI.yesBtn2 === _loc2_)
            {
               ElfFrontImageManager.getInstance().dispose();
               removeAmuseMc(true);
               removeReward();
               addAmuseMcUI.addOrRemoveBtn(false);
               if(LoadPageCmd.lastPage is MainCityUI)
               {
                  sendNotification("switch_page","load_maincity_page");
                  sendNotification("switch_win",null,"load_limit_specialelf");
               }
               else
               {
                  sendNotification("switch_page","LOAD_AMUSE_PAGE");
               }
            }
         }
         else if(AmusePro.writeType == "2501" && AmuseMedia.once() || AmusePro.writeType == "2502" && AmuseMedia.ten())
         {
            drawAgain();
         }
      }
      
      private function mcComplete(param1:SwfMovieClip) : void
      {
         mc = param1;
         LogUtil("Mc complete");
         mc.stop(true);
         mc.removeFromParent();
         var bg:Quad = new Quad(1136,640,16777215);
         addAmuseMcUI.addChild(bg);
         var t:Tween = new Tween(bg,1);
         t.animate("alpha",1,0);
         Starling.juggler.add(t);
         var t2:Tween = new Tween(bg,1);
         t.animate("alpha",0,1);
         t2.delay = 1.5;
         t.nextTween = t2;
         t.onComplete = function():void
         {
            bg.removeFromParent(true);
            showReward();
         };
      }
      
      public function showReward() : void
      {
         var _loc3_:* = NaN;
         var _loc1_:* = NaN;
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         LogUtil(rewardArr.length + " length");
         if(rewardArr.length != 0)
         {
            if(rewardNum == 1)
            {
               addAmuseMcUI.showRewardMc(rewardArr);
            }
            else
            {
               _loc2_ = 0;
               _loc4_ = 160;
               _loc5_ = 185;
               _loc6_ = 0;
               while(_loc6_ < sendRewardTimes)
               {
                  if(_loc6_ % 5 == 0 && _loc6_ != 0)
                  {
                     _loc2_ = _loc2_ + 1;
                  }
                  if(sendRewardTimes >= 6 && _loc6_ >= 5)
                  {
                     _loc2_ = 1;
                     _loc3_ = 170 * (_loc6_ % 5) + 145;
                     _loc1_ = _loc5_ * _loc2_ + _loc4_;
                     if(_loc6_ == 10)
                     {
                        _loc3_ = 995;
                     }
                  }
                  else
                  {
                     _loc3_ = 170 * (_loc6_ % 5) + 225;
                     _loc1_ = _loc5_ * _loc2_ + _loc4_;
                  }
                  _loc6_++;
               }
               sendRewardTimes = sendRewardTimes + 1;
               addAmuseMcUI.showRewardMc(rewardArr,_loc3_,_loc1_ + 40,true);
            }
         }
         else
         {
            if(rewardNum != 1)
            {
            }
            EventCenter.removeEventListener("amuse_send_reward",showReward);
            sendRewardTimes = 1;
            addAmuseMcUI.addOrRemoveBtn(true);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["send_rewardArr","SHOW_Drew_ELF","remove_amuse_last_resource"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("send_rewardArr" !== _loc2_)
         {
            if("remove_amuse_last_resource" !== _loc2_)
            {
               if("SHOW_Drew_ELF" === _loc2_)
               {
                  elfVo = param1.getBody() as ElfVO;
                  if(!facade.hasMediator("AmuseElfInfoMedia"))
                  {
                     facade.registerMediator(new AmuseElfInfoMedia(new AmuseElfInfoUI()));
                  }
                  sendNotification("switch_win",addAmuseMcUI,"LOAD_AMUSEELFINFO_WIN");
                  sendNotification("send_draw_elf_data",elfVo);
               }
            }
            else
            {
               ElfFrontImageManager.getInstance().dispose();
               removeAmuseMc();
               removeReward();
               addAmuseMcUI.addOrRemoveBtn(false);
            }
         }
         else
         {
            PlayerVO.isAcceptPvp = false;
            rewardArr = param1.getBody() as Array;
            LogUtil(rewardArr + " reward");
            rewardNum = rewardArr.length;
            if(addAmuseMcUI.rewardQuad.parent)
            {
               addAmuseMcUI.rewardQuad.removeFromParent();
            }
            playBallAni();
            EventCenter.addEventListener("amuse_send_reward",showReward);
         }
      }
      
      private function playBallAni() : void
      {
         var targetBall:Image = addAmuseMcUI.selectAmuseMc();
         targetBall.rotation = 0;
         Starling.juggler.removeTweens(targetBall);
         var t:Tween = new Tween(targetBall,0.8,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",targetBall.x,0);
         var t2:Tween = new Tween(targetBall,0.8,"easeIn");
         t2.animate("scaleY",30,1);
         t2.animate("scaleX",30,1);
         t2.animate("rotation",deg2rad(-720));
         t2.delay = 0.1;
         t.nextTween = t2;
         t.onComplete = function():void
         {
            addAmuseMcUI.rewardQuad.alpha = 0;
            addAmuseMcUI.addChild(addAmuseMcUI.rewardQuad);
            var t:Tween = new Tween(addAmuseMcUI.rewardQuad,0.9);
            t.animate("alpha",1,0);
            Starling.juggler.add(t);
            var t2:Tween = new Tween(addAmuseMcUI.rewardQuad,0.5);
            t2.animate("alpha",0.8,1);
            t.nextTween = t2;
            t2.onComplete = function():void
            {
               showReward();
            };
         };
         t2.onComplete = function():void
         {
            targetBall.alpha = 1;
            var _loc1_:* = 1;
            targetBall.scaleY = _loc1_;
            targetBall.scaleX = _loc1_;
            targetBall.removeFromParent();
         };
      }
      
      private function removeReward() : void
      {
         var _loc1_:* = 0;
         _loc1_ = addAmuseMcUI.rewardUnitUIVec.length - 1;
         while(_loc1_ >= 0)
         {
            addAmuseMcUI.rewardUnitUIVec[_loc1_].removeFromParent(true);
            addAmuseMcUI.rewardUnitUIVec[_loc1_] = null;
            _loc1_--;
         }
         addAmuseMcUI.rewardUnitUIVec = Vector.<DropPropUnitUI>([]);
      }
      
      private function drawAgain() : void
      {
         switch(AmusePro._recrId - 1)
         {
            case 0:
               (facade.retrieveProxy("AmusePro") as AmusePro).write2501(1);
               break;
            case 2:
               if(LoadPageCmd.lastPage is MainCityUI)
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2501(3,true);
               }
               else
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2501(3);
               }
               break;
            case 3:
               (facade.retrieveProxy("AmusePro") as AmusePro).write2502(4);
            case 5:
               if(LoadPageCmd.lastPage is MainCityUI)
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2502(6,true);
               }
               else
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2502(6);
               }
               break;
            case 6:
               (facade.retrieveProxy("AmusePro") as AmusePro).write2501(7);
               break;
            case 7:
               (facade.retrieveProxy("AmusePro") as AmusePro).write2502(8);
               break;
            default:
               (facade.retrieveProxy("AmusePro") as AmusePro).write2502(4);
         }
      }
      
      private function removeAmuseMc(param1:Boolean = false, param2:Boolean = true) : void
      {
         var _loc3_:* = 0;
         addAmuseMcUI.lightMc.stop();
         addAmuseMcUI.lightMc.removeFromParent(param1);
         addAmuseMcUI.ball1.removeFromParent(param1);
         addAmuseMcUI.ball2.removeFromParent(param1);
         addAmuseMcUI.ball3.removeFromParent(param1);
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < addAmuseMcUI.elfLightMcVec.length)
            {
               LogUtil(addAmuseMcUI.elfLightMcVec[_loc3_] + " " + _loc3_ + "看看扭蛋发光vec" + param1);
               addAmuseMcUI.elfLightMcVec[_loc3_].stop();
               addAmuseMcUI.elfLightMcVec[_loc3_].removeFromParent(param1);
               addAmuseMcUI.elfLightMcVec[_loc3_] = null;
               _loc3_++;
            }
            addAmuseMcUI.elfLightMcVec = Vector.<SwfMovieClip>([]);
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         ElfFrontImageManager.getInstance().dispose();
         addAmuseMcUI.elfLightMcVec = null;
         addAmuseMcUI.rewardUnitUIVec = null;
         facade.removeMediator("addAmuseMcMedia");
         UI.removeFromParent();
         UI.dispose();
         viewComponent = null;
      }
   }
}
