package com.mvc.views.mediator.mapSelect
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mapSelect.ExtenAdventureWinUI;
   import com.mvc.models.vos.mapSelect.ExtenMapVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Quad;
   import starling.events.Event;
   import com.common.util.IsAllElfDie;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import extend.SoundEvent;
   import starling.animation.Tween;
   import starling.core.Starling;
   import flash.geom.Rectangle;
   import lzm.starling.swf.display.SwfMovieClip;
   import com.common.managers.SoundManager;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.proxy.fighting.FightingPro;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.dialogue.NPCDialogue;
   import com.common.util.dialogue.Dialogue;
   import starling.display.DisplayObject;
   
   public class ExtenAdventureWinMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ExtenMapWinMedia";
       
      private var win:ExtenAdventureWinUI;
      
      private var extenMapInfo:ExtenMapVO;
      
      private var meetElf:ElfVO;
      
      private var whileBg:Quad;
      
      private var blueBg:Quad;
      
      public function ExtenAdventureWinMedia(param1:Object = null)
      {
         super("ExtenMapWinMedia",param1);
         win = param1 as ExtenAdventureWinUI;
         win.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(win.advanceBtn !== _loc3_)
         {
            if(win.exitBtn !== _loc3_)
            {
               if(win.result.getButton("fightingBtn") !== _loc3_)
               {
                  if(win.result.getButton("goAwayBtn") !== _loc3_)
                  {
                     if(win.specialElfWin.getButton("fightingBtn") === _loc3_)
                     {
                        sendNotification("switch_win",null);
                        win.specialElfWin.removeFromParent();
                        win.disposeResultTexture();
                        win.removeFromParent();
                        loadFightUI();
                     }
                  }
                  else
                  {
                     FightingConfig.isWin = false;
                     FightingConfig.selectMap = null;
                     FightingConfig.selectMap = extenMapInfo;
                     (facade.retrieveProxy("MapPro") as MapPro).write1702(extenMapInfo);
                     sendNotification("switch_win",null);
                     win.result.removeFromParent();
                     win.disposeResultTexture();
                  }
               }
               else
               {
                  sendNotification("switch_win",null);
                  win.result.removeFromParent();
                  win.disposeResultTexture();
                  win.removeFromParent();
                  loadFightUI();
               }
            }
            else
            {
               win.extenContentContainer.removeFromParent();
               WinTweens.closeWin(win.mySpr,removeSelf);
            }
         }
         else if(!IsAllElfDie.isAllElfDie())
         {
            if(PlayerVO.actionForce < extenMapInfo.needPower)
            {
               _loc2_ = Alert.show("亲，体力不足哦，是否购买？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc2_.addEventListener("close",buyPowerAlertHander);
            }
            else
            {
               PlayerVO.isAcceptPvp = false;
               if(extenMapInfo.sceneName.substr(0,6) == "shuiyu")
               {
                  playAdvanceAni2();
               }
               else
               {
                  playAdvanceAni1();
               }
            }
         }
      }
      
      private function buyPowerAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            sendNotification("switch_win",null,"load_power_panel");
         }
      }
      
      private function loadFightUI() : void
      {
         FightingConfig.computerElfVO = null;
         FightingConfig.computerElfVO = meetElf;
         FightingConfig.selectMap = extenMapInfo;
         FightingConfig.sceneName = extenMapInfo.sceneName;
         CityMapMeida.recordExtenAdvance = null;
         CityMapMeida.recordMainAdvance = null;
         win.extenContentContainer.removeFromParent();
         GetElfFactor.getBeforeFightElf();
         FightingConfig.fightingAI = 0;
         sendNotification("switch_page","load_fighting_page");
      }
      
      private function removeSelf() : void
      {
         sendNotification("switch_win",null);
         win.removeFromParent();
      }
      
      private function playAdvanceAni1() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","grass");
         whileBg = new Quad(647,405,16777215);
         whileBg.pivotX = 323.5;
         whileBg.pivotY = 202.5;
         whileBg.x = win.advanceAni1.x;
         whileBg.y = win.advanceAni1.y;
         win.addChild(whileBg);
         blueBg = new Quad(647,405,6737151);
         blueBg.pivotX = 323.5;
         blueBg.pivotY = 202.5;
         blueBg.x = win.advanceAni1.x;
         blueBg.y = win.advanceAni1.y;
         win.addChild(blueBg);
         var _loc1_:Tween = new Tween(blueBg,2);
         Starling.juggler.add(_loc1_);
         _loc1_.animate("alpha",0);
         win.addChild(win.advanceAni1);
         win.advanceAni1.gotoAndPlay(0);
         win.advanceAni1.completeFunction = removeAdvance;
         win.advanceBtn.touchable = false;
         win.exitBtn.touchable = false;
         win.advanceAni1.clipRect = new Rectangle(-325,-204,648,408);
      }
      
      private function playAdvanceAni2() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","sea");
         whileBg = new Quad(647,405,16777215);
         whileBg.pivotX = 323.5;
         whileBg.pivotY = 202.5;
         whileBg.x = win.advanceAni1.x;
         whileBg.y = win.advanceAni1.y;
         win.addChild(whileBg);
         win.addChild(win.advanceAni2);
         win.advanceAni2.gotoAndPlay(0);
         win.advanceAni2.completeFunction = removeAdvance;
         win.advanceBtn.touchable = false;
         win.exitBtn.touchable = false;
         win.advanceAni2.clipRect = new Rectangle(-325,-204,648,408);
      }
      
      private function removeAdvance(param1:SwfMovieClip) : void
      {
         SoundManager.getInstance().stopMusic();
         if(whileBg != null)
         {
            whileBg.removeFromParent(true);
         }
         if(blueBg != null)
         {
            blueBg.removeFromParent(true);
         }
         win.advanceBtn.touchable = true;
         win.exitBtn.touchable = true;
         param1.removeFromParent();
         param1.stop();
         param1.completeFunction = null;
         (facade.retrieveProxy("MapPro") as MapPro).write1201(extenMapInfo.nodeId);
         PlayerVO.isAcceptPvp = true;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         notification = param1;
         var _loc2_:* = notification.getName();
         if("update_exten_map_list" !== _loc2_)
         {
            if("exten_map_result" === _loc2_)
            {
               (facade.retrieveProxy("FightingPro") as FightingPro).write3100(function():void
               {
                  advanceResult(notification.getBody());
               });
            }
         }
         else
         {
            if(notification.getBody().isUpdateMap)
            {
               extenMapInfo = null;
               extenMapInfo = notification.getBody().extenMapInfo;
               win.upDateExtenContent(extenMapInfo);
            }
            if(win.extenContentContainer.parent == null)
            {
               win.mySpr.addChild(win.extenContentContainer);
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_exten_map_list","exten_map_result"];
      }
      
      private function advanceResult(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         if(param1.code == 1)
         {
            meetElf = GetElfFromSever.getElfInfo(param1);
            GetElfQuality.alterElfProperty(meetElf);
            (facade.retrieveProxy("IllustrationsPro") as IllustrationsPro).write1302(meetElf.elfId);
            if(meetElf.isSpecial)
            {
               win.showSpecialElfWin(meetElf);
            }
            else
            {
               win.showResult(meetElf);
            }
         }
         else if(param1.code == 2)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","getProp");
            _loc2_ = GetPropFactor.getPropVO(param1.pId);
            NPCDialogue.playDialogue(["捡到了一个【" + _loc2_.name + "】"],"您",null);
            GetPropFactor.addOrLessProp(_loc2_);
            FightingConfig.isWin = false;
            FightingConfig.selectMap = null;
            FightingConfig.selectMap = extenMapInfo;
            _loc3_ = param1.exp;
            sendNotification("update_play_expbar_info",PlayerVO.exper + _loc3_);
            (facade.retrieveProxy("MapPro") as MapPro).write1702(extenMapInfo);
         }
         else if(param1.code == 3)
         {
            Dialogue.updateDialogue("什么也没遇到",true);
            FightingConfig.isWin = false;
            FightingConfig.selectMap = extenMapInfo;
            (facade.retrieveProxy("MapPro") as MapPro).write1702(extenMapInfo);
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         win.disposeResultTexture();
         win.extenContentContainer.removeChildren(0,-1,true);
         win.extenContentContainer.removeFromParent(true);
         win.advanceAni1.dispose();
         win.advanceAni2.dispose();
         win.result.removeFromParent(true);
         win.specialElfWin.removeFromParent(true);
         facade.removeMediator("ExtenMapWinMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         extenMapInfo = null;
         meetElf = null;
      }
   }
}
