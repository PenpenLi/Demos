package com.mvc.views.mediator.mainCity.hunting
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.mvc.views.uis.mainCity.hunting.HuntingElfCamp;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.fighting.GotoChallenge;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.display.DisplayObject;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class HuntingMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "HuntingMediator";
      
      public static var lowEnterTime:int;
      
      public static var middleEnterTime:int;
      
      public static var heightEnterTime:int;
      
      public static var isSureHunting:Boolean;
       
      public var huntingUI:HuntingUI;
      
      private var elfCampVec:Vector.<HuntingElfCamp>;
      
      private var meetElf:ElfVO;
      
      private var specrialId:int;
      
      public function HuntingMediator(param1:Object = null)
      {
         elfCampVec = Vector.<HuntingElfCamp>([]);
         super("HuntingMediator",param1);
         huntingUI = param1 as HuntingUI;
         huntingUI.addEventListener("triggered",triggeredHandler);
      }
      
      public static function judgeSureHunting() : void
      {
         if(HuntingPro.calculatorTickNum([lowEnterTime,middleEnterTime,heightEnterTime]))
         {
            isSureHunting = true;
            Facade.getInstance().sendNotification("SHOW_HUNTING_DRAW");
         }
         else
         {
            isSureHunting = false;
            Facade.getInstance().sendNotification("HIDE_HUNTING_DRAW");
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = 0;
         var _loc4_:* = param1.target;
         if(huntingUI.btn_close !== _loc4_)
         {
            if(huntingUI.btn_playTipBtn !== _loc4_)
            {
               if(huntingUI.btn_goHuntingBtn1 !== _loc4_)
               {
                  if(huntingUI.btn_goHuntingBtn2 !== _loc4_)
                  {
                     if(huntingUI.btn_goHuntingBtn3 !== _loc4_)
                     {
                        if(huntingUI.normalElfWin.getButton("btn_fightBtn") !== _loc4_)
                        {
                           if(huntingUI.normalElfWin.getButton("btn_escapeBtn") !== _loc4_)
                           {
                              if(huntingUI.specialElfWin.getButton("btn_fightBtn") === _loc4_)
                              {
                                 huntingUI.specialElfWin.removeFromParent();
                                 huntingUI.hurntingResultBg.removeFromParent();
                                 gotoFight();
                              }
                           }
                           else
                           {
                              huntingUI.disposeResultTexture();
                              huntingUI.normalElfWin.removeFromParent();
                              huntingUI.hurntingResultBg.removeFromParent();
                           }
                        }
                        else
                        {
                           huntingUI.disposeResultTexture();
                           sendNotification("switch_win",null);
                           huntingUI.normalElfWin.removeFromParent();
                           huntingUI.hurntingResultBg.removeFromParent();
                           gotoFight();
                        }
                     }
                     else
                     {
                        if(PlayerVO.lv < 30)
                        {
                           Tips.show("玩家等级达到30级后开放");
                           return;
                        }
                        if(!AmuseMedia.once())
                        {
                           return;
                        }
                        _loc3_ = 0;
                        while(_loc3_ < PlayerVO.huntingPropVec.length)
                        {
                           if(PlayerVO.huntingPropVec[_loc3_].name != "初级狩猎券" && PlayerVO.huntingPropVec[_loc3_].name != "中级狩猎券" && PlayerVO.huntingPropVec[_loc3_].count > 0)
                           {
                              _loc2_ = true;
                              break;
                           }
                           _loc3_++;
                        }
                        if(!_loc2_)
                        {
                           showGetHeightTickAlert();
                           return;
                        }
                        if(heightEnterTime <= 0)
                        {
                        }
                        sendNotification("switch_win",null,"load_hunting_select_tick");
                     }
                  }
                  else
                  {
                     if(PlayerVO.lv < 25)
                     {
                        Tips.show("玩家等级达到25级后开放");
                        return;
                     }
                     if(!AmuseMedia.once())
                     {
                        return;
                     }
                     if(huntingUI.tf_middleTicketNum.text <= 0)
                     {
                        Tips.show("亲，中级狩猎券不足哦。");
                        return;
                     }
                     if(middleEnterTime <= 0)
                     {
                        showEnterTimerAlert(2);
                        return;
                     }
                     (facade.retrieveProxy("HuntingPro") as HuntingPro).write2901(2);
                  }
               }
               else
               {
                  if(!AmuseMedia.once())
                  {
                     return;
                  }
                  if(huntingUI.tf_lowTicketNum.text <= 0)
                  {
                     Tips.show("亲，初级狩猎券不足哦。");
                     return;
                  }
                  if(lowEnterTime <= 0)
                  {
                     showEnterTimerAlert(1);
                     return;
                  }
                  (facade.retrieveProxy("HuntingPro") as HuntingPro).write2901(1);
               }
            }
            else
            {
               huntingUI.addHelp();
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      private function showGetHeightTickAlert() : void
      {
         var getHeightTickAlert:Alert = Alert.show("3080钻十连抽可获取高级狩猎券","",new ListCollection([{"label":"前往"},{"label":"太客气了"}]));
         getHeightTickAlert.addEventListener("close",function(param1:Event):void
         {
            if(param1.data.label == "前往")
            {
               sendNotification("switch_page","LOAD_AMUSE_PAGE");
            }
         });
      }
      
      private function gotoFight() : void
      {
         FightingConfig.sceneName = "shoulie";
         FightingConfig.fightingAI = 0;
         GotoChallenge.gotoChallenge(null,null,Vector.<ElfVO>([meetElf]),true,null,null,true);
      }
      
      private function showEnterTimerAlert(param1:int) : void
      {
         enterGrade = param1;
         if(enterGrade == 1)
         {
            var diamondUse:int = 10;
         }
         if(enterGrade == 2)
         {
            diamondUse = 50;
         }
         if(enterGrade == 3)
         {
            diamondUse = 100;
         }
         var enterTimerAlert:Alert = Alert.show("亲，进入次数不足，是否花费" + diamondUse + "钻购买？","",new ListCollection([{"label":"好的"},{"label":"太客气了"}]));
         enterTimerAlert.addEventListener("close",function(param1:Event):void
         {
            if(param1.data.label == "好的")
            {
               (facade.retrieveProxy("HuntingPro") as HuntingPro).write2902(enterGrade);
            }
         });
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = param1.getName();
         if("hunting_update_elf_times" !== _loc4_)
         {
            if("hunting_show_adventure_result" !== _loc4_)
            {
               if("hunting_update_enter_times" !== _loc4_)
               {
                  if("hunting_update_entertime_and_tick" === _loc4_)
                  {
                     _loc2_ = param1.getBody();
                     specrialId = param1.getType();
                     if(_loc2_ == 1)
                     {
                        lowEnterTime = §§dup(lowEnterTime - 1);
                        huntingUI.tf_lowEnterTime.text = lowEnterTime - 1 + "/5";
                        deductTick("初级狩猎券");
                     }
                     if(_loc2_ == 2)
                     {
                        middleEnterTime = §§dup(middleEnterTime - 1);
                        huntingUI.tf_middleEnterTime.text = middleEnterTime - 1 + "/3";
                        deductTick("中级狩猎券");
                     }
                     if(_loc2_ == 3 && specrialId == 0)
                     {
                        deductTick("高级狩猎券");
                     }
                     if(_loc2_ == 3 && specrialId)
                     {
                        deductTick("");
                     }
                  }
               }
               else
               {
                  updateEnterTime(param1.getBody() as Array);
               }
            }
            else
            {
               advanceResult(param1.getBody());
            }
         }
         else
         {
            _loc3_ = param1.getBody();
            addElf(_loc3_.spiritInfo);
            updateEnterTime(_loc3_.enterTimes);
            initTickNum();
         }
      }
      
      private function initTickNum() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = PlayerVO.huntingPropVec.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(PlayerVO.huntingPropVec[_loc2_].name == "初级狩猎券")
            {
               huntingUI.tf_lowTicketNum.text = PlayerVO.huntingPropVec[_loc2_].count;
            }
            if(PlayerVO.huntingPropVec[_loc2_].name == "中级狩猎券")
            {
               huntingUI.tf_middleTicketNum.text = PlayerVO.huntingPropVec[_loc2_].count;
            }
            if(PlayerVO.huntingPropVec[_loc2_].name == "高级狩猎券")
            {
               huntingUI.tf_heightTicketNum.text = PlayerVO.huntingPropVec[_loc2_].count;
            }
            _loc2_++;
         }
      }
      
      private function deductTick(param1:String) : void
      {
         var _loc3_:* = 0;
         var _loc2_:int = PlayerVO.huntingPropVec.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == "" && PlayerVO.huntingPropVec[_loc3_].id == specrialId)
            {
               GetPropFactor.addOrLessProp(PlayerVO.huntingPropVec[_loc3_],false);
               break;
            }
            if(param1 != "" && PlayerVO.huntingPropVec[_loc3_].name == param1)
            {
               GetPropFactor.addOrLessProp(PlayerVO.huntingPropVec[_loc3_],false);
               if(param1 == "初级狩猎券")
               {
                  huntingUI.tf_lowTicketNum.text = huntingUI.tf_lowTicketNum.text - 1;
               }
               if(param1 == "中级狩猎券")
               {
                  huntingUI.tf_middleTicketNum.text = huntingUI.tf_middleTicketNum.text - 1;
               }
               if(param1 == "高级狩猎券")
               {
                  huntingUI.tf_heightTicketNum.text = huntingUI.tf_heightTicketNum.text - 1;
               }
               break;
            }
            _loc3_++;
         }
      }
      
      private function advanceResult(param1:Object) : void
      {
         meetElf = GetElfFromSever.getElfInfo(param1);
         meetElf.camp = "camp_of_computer";
         (facade.retrieveProxy("IllustrationsPro") as IllustrationsPro).write1302(meetElf.elfId);
         if(meetElf.isSpecial)
         {
            huntingUI.showSpecialElfWin(meetElf);
         }
         else
         {
            huntingUI.showNormalElf(meetElf);
         }
      }
      
      private function updateEnterTime(param1:Array) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ == 0)
            {
               lowEnterTime = param1[_loc2_];
               huntingUI.tf_lowEnterTime.text = param1[_loc2_] + "/5";
            }
            if(_loc2_ == 1)
            {
               middleEnterTime = param1[_loc2_];
               huntingUI.tf_middleEnterTime.text = param1[_loc2_] + "/3";
            }
            if(_loc2_ == 2)
            {
               heightEnterTime = param1[_loc2_];
               huntingUI.tf_heightEnterTime.fontSize = 30;
               huntingUI.tf_heightEnterTime.text = "∞";
            }
            _loc2_++;
         }
      }
      
      private function addElf(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         destroyElfCamp();
         elfCampVec = Vector.<HuntingElfCamp>([]);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = new HuntingElfCamp();
            _loc4_.addHuntingElfUnit(param1[_loc3_]);
            _loc2_ = GetElfFactor.getElfVO(param1[_loc3_][(param1[_loc3_] as Array).length - 1],false);
            _loc4_.addSpecialElf(_loc2_);
            _loc4_.x = 95 + _loc3_ * 340;
            _loc4_.y = 413;
            huntingUI.addChild(_loc4_);
            elfCampVec.push(_loc4_);
            if(_loc3_ == 0)
            {
               huntingUI.tf_lowElfName.text = _loc2_.name;
            }
            if(_loc3_ == 1)
            {
               huntingUI.tf_middleElfName.text = _loc2_.name;
            }
            if(_loc3_ == 2)
            {
               huntingUI.tf_heightElfName.text = _loc2_.name;
            }
            _loc3_++;
         }
      }
      
      private function destroyElfCamp() : void
      {
         var _loc1_:* = 0;
         _loc1_ = elfCampVec.length - 1;
         while(_loc1_ >= 0)
         {
            elfCampVec[_loc1_].removeHuntingElfUnitUI();
            elfCampVec[_loc1_].destorySpecialElfImg();
            elfCampVec[_loc1_].removeFromParent(true);
            elfCampVec.splice(_loc1_,1);
            _loc1_--;
         }
         elfCampVec = null;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["hunting_update_elf_times","hunting_show_adventure_result","hunting_update_entertime_and_tick","hunting_update_enter_times"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(Facade.getInstance().hasMediator("HuntingSelectTickMediator"))
         {
            (Facade.getInstance().retrieveMediator("HuntingSelectTickMediator") as HuntingSelectTickMediator).dispose();
         }
         judgeSureHunting();
         huntingUI.cleanHelpBg();
         huntingUI.disposeResultTexture();
         huntingUI.normalElfWin.removeFromParent(true);
         huntingUI.specialElfWin.removeFromParent(true);
         destroyElfCamp();
         ElfFrontImageManager.getInstance().dispose();
         facade.removeMediator("HuntingMediator");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.huntingAssets);
      }
   }
}
