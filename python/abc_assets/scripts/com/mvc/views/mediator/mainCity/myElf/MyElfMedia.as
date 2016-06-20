package com.mvc.views.mediator.mainCity.myElf
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.myElf.MyElfUI;
   import com.mvc.views.uis.mainCity.myElf.ElfContainUnitUI;
   import com.mvc.views.uis.mainCity.myElf.UnlockUnitUI;
   import flash.utils.Timer;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.myElf.ElfEvolveUI;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.massage.ane.UmengExtension;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.mvc.models.proxy.mainCity.elfCenter.ElfCenterPro;
   import com.mvc.views.uis.mainCity.myElf.ElfSkillUI;
   import com.mvc.views.uis.mainCity.myElf.ElfPreviewUI;
   import com.mvc.views.uis.mainCity.myElf.ElfStarUI;
   import com.mvc.views.uis.mainCity.myElf.ElfInfoUI;
   import com.mvc.views.uis.mainCity.myElf.ElfIndividualUI;
   import com.mvc.views.uis.mainCity.myElf.ElfBreakUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.managers.SoundManager;
   import com.common.events.EventCenter;
   import extend.SoundEvent;
   import com.mvc.views.uis.mainCity.myElf.EvolveUI;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import com.mvc.views.uis.mainCity.myElf.LockUnitUI;
   import com.common.util.WinTweens;
   import com.common.managers.ElfFrontImageManager;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.myElf.CompChildUI;
   import com.mvc.views.uis.mainCity.backPack.ComposeUI;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.mapSelect.WorldMapUI;
   import lzm.util.LSOManager;
   import starling.display.DisplayObject;
   
   public class MyElfMedia extends Mediator
   {
      
      public static const NAME:String = "MyElfMedia";
      
      public static var isJumpPage:Boolean;
      
      public static var isJumpTrain:Boolean;
      
      public static var ifChangePos:Boolean;
      
      public static var elfGap:int = 73;
      
      public static var elfToping:int = 88;
      
      public static var elflefting:int = 30;
      
      public static var currentElfIndex:int;
      
      public static var recoverTimes:int;
      
      public static var pageType:int;
       
      public var myElf:MyElfUI;
      
      public var ifExchange:Boolean;
      
      public var ifClick:Boolean;
      
      public var position:int;
      
      private var elfArray:Vector.<ElfContainUnitUI>;
      
      public var nullArray:Vector.<UnlockUnitUI>;
      
      private var keepTime:Timer;
      
      private var time:int;
      
      private var target:ElfContainUnitUI;
      
      private var targetX:Number;
      
      private var targetY:Number;
      
      private var saveStateArr:Array;
      
      private var saveEvoPromptArr:Array;
      
      private var secondOpen:String;
      
      public function MyElfMedia(param1:Object = null)
      {
         elfArray = new Vector.<ElfContainUnitUI>([]);
         nullArray = new Vector.<UnlockUnitUI>([]);
         keepTime = new Timer(10);
         super("MyElfMedia",param1);
         myElf = param1 as MyElfUI;
         myElf.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(myElf.btn_close !== _loc3_)
         {
            if(myElf.btn_break !== _loc3_)
            {
               if(myElf.btn_evolve !== _loc3_)
               {
                  if(myElf.btn_recover !== _loc3_)
                  {
                     if(myElf.btn_skill !== _loc3_)
                     {
                        if(myElf.btn_states !== _loc3_)
                        {
                           if(myElf.btn_star !== _loc3_)
                           {
                              if(myElf.btn_preview !== _loc3_)
                              {
                                 if(myElf.btn_individual === _loc3_)
                                 {
                                    openSkillPage();
                                 }
                              }
                              else
                              {
                                 pageType = 5;
                                 myElf.containAll.removeChildren();
                                 myElf.containAll.addChild(ElfPreviewUI.getInstance());
                                 ElfPreviewUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                                 UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-突破预览");
                              }
                           }
                           else
                           {
                              openStar();
                           }
                        }
                        else
                        {
                           openState();
                        }
                     }
                     else
                     {
                        pageType = 6;
                        myElf.containAll.removeChildren();
                        myElf.containAll.addChild(ElfSkillUI.getInstance());
                        ElfSkillUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                        BeginnerGuide.playBeginnerGuide();
                        UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-技能");
                     }
                  }
                  else
                  {
                     if(GetElfFactor.checkStatus())
                     {
                        Tips.show("精灵的状态已满，请下次再来！");
                        return;
                     }
                     if(recoverTimes <= 0)
                     {
                        _loc2_ = Alert.show("你确定用100金币恢复一次么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                        _loc2_.addEventListener("close",moneyRecoverSureHandler);
                        return;
                     }
                     if(MyElfMedia.ifChangePos)
                     {
                        MyElfMedia.ifChangePos = false;
                        (facade.retrieveProxy("MyElfPro") as MyElfPro).write2003();
                     }
                     (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2008("myElf");
                  }
               }
               else
               {
                  pageType = 1;
                  myElf.containAll.removeChildren();
                  myElf.containAll.addChild(ElfEvolveUI.getInstance());
                  ElfEvolveUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                  BeginnerGuide.playBeginnerGuide();
                  UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-进化");
               }
            }
            else
            {
               openBreakPage();
            }
         }
         else
         {
            remove();
         }
      }
      
      private function openStar() : void
      {
         if(PlayerVO.bagElfVec[currentElfIndex].elfId > 20000)
         {
            return Tips.show("敬请期待");
         }
         pageType = 3;
         myElf.containAll.removeChildren();
         myElf.containAll.addChild(ElfStarUI.getInstance());
         ElfStarUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-特训");
      }
      
      private function openState() : void
      {
         pageType = 0;
         myElf.containAll.removeChildren();
         myElf.containAll.addChild(ElfInfoUI.getInstance());
         ElfInfoUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-属性");
      }
      
      private function openSkillPage() : void
      {
         if(PlayerVO.bagElfVec[currentElfIndex].lv < 17)
         {
            return Tips.show("精灵等级达到17级开启");
         }
         pageType = 4;
         myElf.containAll.removeChildren();
         myElf.containAll.addChild(ElfIndividualUI.getInstance());
         ElfIndividualUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-个体值");
      }
      
      private function openBreakPage() : void
      {
         pageType = 2;
         myElf.containAll.removeChildren();
         myElf.containAll.addChild(ElfBreakUI.getInstance());
         ElfBreakUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
         BeginnerGuide.playBeginnerGuide();
         UmengExtension.getInstance().UMExtension("onEventCustom|openPage|page|精灵-突破");
      }
      
      private function moneyRecoverSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2009("myElf");
         }
      }
      
      public function addElf() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc1_:* = null;
         clean();
         GetElfFactor.seiri();
         LogUtil(" PlayerVO.bagElfVec",PlayerVO.bagElfVec,PlayerVO.pokeSpace);
         var _loc4_:Vector.<ElfVO> = PlayerVO.bagElfVec;
         elfArray = Vector.<ElfContainUnitUI>([]);
         _loc3_ = 0;
         while(_loc3_ < PlayerVO.pokeSpace)
         {
            if(_loc4_[_loc3_] != null)
            {
               _loc2_ = new ElfContainUnitUI();
               _loc2_.myElfVo = _loc4_[_loc3_];
               _loc2_.x = elflefting;
               _loc2_.y = elfGap * _loc3_ + elfToping;
               _loc2_.name = _loc3_.toString();
               myElf.elfContain.addChild(_loc2_);
               elfArray.push(_loc2_);
               _loc2_.addEventListener("touch",ontouch);
            }
            else
            {
               _loc1_ = new UnlockUnitUI();
               _loc1_.number = _loc3_ + 1;
               _loc1_.x = elflefting;
               _loc1_.y = elfGap * _loc3_ + elfToping;
               nullArray.push(_loc1_);
               myElf.elfContain.addChild(_loc1_);
            }
            _loc3_++;
         }
         if(PlayerVO.pokeSpace < 6)
         {
            myElf.addLock(PlayerVO.pokeSpace);
         }
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc3_:Touch = param1.getTouch(param1.currentTarget as ElfContainUnitUI);
         if(_loc3_)
         {
            if(_loc3_.phase == "began")
            {
               target = param1.currentTarget as ElfContainUnitUI;
               targetX = elflefting;
               targetY = elfGap * target.name + elfToping;
               time = 0;
               keepTime.addEventListener("timer",starTime);
               keepTime.start();
            }
            if(_loc3_.phase == "moved")
            {
               removeHandle(_loc3_);
            }
            if(_loc3_.phase == "ended")
            {
               target.cancelSelected();
               if(ifExchange)
               {
                  LogUtil("进入换位模式");
                  ifChangePos = true;
                  ifExchange = false;
                  _loc4_ = getIndex(target);
                  if(offsideHandle(_loc4_,target))
                  {
                     return;
                  }
                  if(elfArray[_loc4_] != target)
                  {
                     _loc5_ = new Tween(target,0.3,"easeOutBack");
                     Starling.juggler.add(_loc5_);
                     _loc5_.animate("x",elflefting);
                     _loc5_.animate("y",elfGap * _loc4_ + elfToping);
                     _loc6_ = new Tween(elfArray[_loc4_],0.3,"easeOutBack");
                     Starling.juggler.add(_loc6_);
                     _loc6_.animate("x",targetX);
                     _loc6_.animate("y",targetY);
                     seiriBag(target,_loc4_);
                     arrExchange(_loc4_,target);
                     updateCurrentElfIndex();
                  }
                  else
                  {
                     _loc2_ = new Tween(target,0.3,"easeOutBack");
                     Starling.juggler.add(_loc2_);
                     _loc2_.animate("x",targetX);
                     _loc2_.animate("y",targetY);
                  }
               }
               if(ifClick)
               {
                  LogUtil("进入点击模式");
                  ifClick = false;
                  showSelete(target);
                  keepTime.stop();
                  keepTime.removeEventListener("timer",starTime);
                  currentElfIndex = target.myElfVO.position - 1;
                  myElf.skillPrompt.visible = elfArray[currentElfIndex].skillPrompt.visible;
                  if(SoundManager.SESwitch)
                  {
                     EventCenter.addEventListener("PLAY_ELFSOUND_OVER",playSound);
                     SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + PlayerVO.bagElfVec[currentElfIndex].sound);
                  }
                  else
                  {
                     updateChildInfo();
                  }
               }
            }
         }
      }
      
      private function updateCurrentElfIndex() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < elfArray.length)
         {
            if(elfArray[_loc1_].isSelete)
            {
               currentElfIndex = _loc1_;
               break;
            }
            _loc1_++;
         }
      }
      
      private function playSound() : void
      {
         LogUtil("播放完叫声===================");
         EventCenter.removeEventListener("PLAY_ELFSOUND_OVER",playSound);
         updateChildInfo();
      }
      
      private function updateChildInfo() : void
      {
         EventCenter.addEventListener("LOAD_ELFIMG_SUCCESS",upDateChildInfo2);
         myElf.myElfVo = PlayerVO.bagElfVec[currentElfIndex];
         myElf.breakPropmpt.visible = PlayerVO.bagElfVec[currentElfIndex].isBreak;
         myElf.starPropmpt.visible = PlayerVO.bagElfVec[currentElfIndex].isStar;
         myElf.evolvePrompt.visible = PlayerVO.bagElfVec[currentElfIndex].isEvolve;
      }
      
      private function upDateChildInfo2() : void
      {
         EventCenter.removeEventListener("LOAD_ELFIMG_SUCCESS",upDateChildInfo2);
         LogUtil("更新子界面 ========== ",PlayerVO.bagElfVec[currentElfIndex].isBreak,PlayerVO.bagElfVec[currentElfIndex].isStar,PlayerVO.bagElfVec[currentElfIndex].isEvolve);
         if(pageType == 4 && PlayerVO.bagElfVec[currentElfIndex].lv < 17)
         {
            openState();
            return;
         }
         if(pageType == 3 && PlayerVO.bagElfVec[currentElfIndex].elfId > 20000)
         {
            openState();
            return;
         }
         switch(pageType)
         {
            case 0:
               ElfInfoUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 1:
               ElfEvolveUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 2:
               ElfBreakUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 3:
               ElfStarUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 4:
               ElfIndividualUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 5:
               ElfPreviewUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
            case 6:
               ElfSkillUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
               break;
         }
         return;
         §§push(LogUtil("更新子界面 over"));
      }
      
      private function checkAllElfState(param1:int) : void
      {
         if(elfArray.length <= param1)
         {
            return;
         }
         elfArray[param1].promopImg.visible = false;
         LogUtil("……………………………………该精灵提示的红点取消");
         var _loc2_:ElfVO = PlayerVO.bagElfVec[param1];
         if(ElfBreakUI.getInstance().breakIsAllMeet(_loc2_))
         {
            LogUtil(_loc2_.name,"………………………………………………可以突破……………");
            PlayerVO.bagElfVec[param1].isBreak = true;
            elfArray[param1].promopImg.visible = true;
         }
         if(ElfStarUI.getInstance().starIsAllMeet(_loc2_))
         {
            LogUtil(_loc2_.name,"………………………………………………可以升星……………");
            PlayerVO.bagElfVec[param1].isStar = true;
            elfArray[param1].promopImg.visible = true;
         }
         EvolveUI.getInstance().myElfVo = _loc2_;
         if(EvolveUI.getInstance().ifAllPass)
         {
            LogUtil(_loc2_.name,"………………………………………………可以进化……………");
            PlayerVO.bagElfVec[param1].isEvolve = true;
            elfArray[param1].promopImg.visible = true;
         }
      }
      
      private function arrExchange(param1:int, param2:ElfContainUnitUI) : void
      {
         var _loc5_:String = elfArray[param1].name;
         var _loc4_:String = param2.name;
         var _loc6_:int = elfArray.indexOf(param2);
         var _loc3_:ElfContainUnitUI = elfArray[param1];
         elfArray[_loc6_] = _loc3_;
         elfArray[param1] = param2;
         elfArray[param1].name = _loc5_;
         elfArray[_loc6_].name = _loc4_;
      }
      
      private function getIndex(param1:ElfContainUnitUI) : int
      {
         var _loc2_:int = (param1.y + param1.height / 2 - elfToping) / elfGap;
         return _loc2_;
      }
      
      private function seiriBag(param1:ElfContainUnitUI, param2:int) : void
      {
         var _loc4_:int = PlayerVO.bagElfVec[param1.name].position;
         PlayerVO.bagElfVec[param1.name].position = PlayerVO.bagElfVec[param2].position;
         PlayerVO.bagElfVec[param2].position = _loc4_;
         var _loc3_:ElfVO = PlayerVO.bagElfVec[param1.name];
         PlayerVO.bagElfVec[param1.name] = PlayerVO.bagElfVec[param2];
         PlayerVO.bagElfVec[param2] = _loc3_;
      }
      
      private function offsideHandle(param1:int, param2:ElfContainUnitUI) : Boolean
      {
         var _loc3_:* = null;
         if(param1 >= elfArray.length || param1 < 0 || param1 > 5 || param2.x < -param2.width)
         {
            _loc3_ = new Tween(param2,0.3,"easeOutBack");
            Starling.juggler.add(_loc3_);
            _loc3_.animate("x",targetX);
            _loc3_.animate("y",targetY);
            return true;
         }
         return false;
      }
      
      private function showSelete(param1:ElfContainUnitUI) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < GetElfFactor.bagElfNum())
         {
            if(elfArray.indexOf(param1) == _loc2_)
            {
               if(_loc2_ < elfArray.length)
               {
                  elfArray[_loc2_].switchBg(true);
               }
            }
            else if(_loc2_ < elfArray.length)
            {
               elfArray[_loc2_].switchBg(false);
            }
            _loc2_++;
         }
      }
      
      protected function starTime(param1:TimerEvent) : void
      {
         time = time + 1;
         if(time > 10)
         {
            ifClick = false;
            starMoveHandler();
         }
         if(time < 2)
         {
            ifClick = true;
         }
      }
      
      private function starMoveHandler() : void
      {
         keepTime.stop();
         keepTime.removeEventListener("timer",starTime);
         ifExchange = true;
         myElf.elfContain.setChildIndex(target,myElf.elfContain.numChildren - 1);
         target.selected();
      }
      
      private function removeHandle(param1:Touch) : void
      {
         var _loc2_:* = null;
         if(ifExchange)
         {
            _loc2_ = param1.getLocation(target.parent);
            target.x = _loc2_.x - target.width / 2;
            target.y = _loc2_.y - target.height / 2;
         }
      }
      
      public function clean() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < elfArray.length)
         {
            elfArray[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < nullArray.length)
         {
            nullArray[_loc2_].removeFromParent(true);
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < myElf.lockVec.length)
         {
            myElf.lockVec[_loc3_].removeFromParent(true);
            _loc3_++;
         }
         elfArray = Vector.<ElfContainUnitUI>([]);
         nullArray = Vector.<UnlockUnitUI>([]);
         myElf.lockVec = Vector.<LockUnitUI>([]);
      }
      
      public function remove() : void
      {
         WinTweens.showCity();
         clean();
         ElfEvolveUI.getInstance().cleanImg();
         if(myElf.image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(myElf.image);
         }
         if(ifChangePos)
         {
            ifChangePos = false;
            (facade.retrieveProxy("MyElfPro") as MyElfPro).write2003();
         }
         myElf.removeFromParent();
         var _loc1_:Game = Config.starling.root as Game;
         _loc1_.page.visible = true;
         ElfIndividualUI.getInstance().stopTimer();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = param1.getName();
         if("update_elf" !== _loc5_)
         {
            if("UPDATE_MYELF" !== _loc5_)
            {
               if("REMOVE_MYELF" !== _loc5_)
               {
                  if("ADD_MYELF" !== _loc5_)
                  {
                     if("UPDATE_ELFPANEL_ELF" !== _loc5_)
                     {
                        if("UNLOAD_PROP" !== _loc5_)
                        {
                           if("BREAK_SUCCESS" !== _loc5_)
                           {
                              if("STAR_SUCCESS" !== _loc5_)
                              {
                                 if("JUMP_CITY_SUCCESS" !== _loc5_)
                                 {
                                    if("UPDATA_BREAK_PROMPT" !== _loc5_)
                                    {
                                       if("UPDATA_STAR_PROMPT" !== _loc5_)
                                       {
                                          if("UPDATA_EVOLVE_PROMPT" !== _loc5_)
                                          {
                                             if("SHOW_MYELF" !== _loc5_)
                                             {
                                                if("UPDATA_SKILL_PROMPT" !== _loc5_)
                                                {
                                                   if("UPDATA_MYELF" !== _loc5_)
                                                   {
                                                      if("UPDATA_MYELF_DATA" !== _loc5_)
                                                      {
                                                         if("OPEN_CHILD_PAGE" === _loc5_)
                                                         {
                                                            secondOpen = param1.getBody() as String;
                                                         }
                                                      }
                                                      else
                                                      {
                                                         myElf.visible = true;
                                                         updataAllElfPrompt();
                                                         updateBagElf(false);
                                                         if(EvolveUI.getInstance().parent)
                                                         {
                                                            EvolveUI.getInstance().myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                                                         }
                                                      }
                                                   }
                                                   else
                                                   {
                                                      myElf.myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                                                      if(elfArray.length != 0)
                                                      {
                                                         elfArray[currentElfIndex].myElfVo = PlayerVO.bagElfVec[currentElfIndex];
                                                      }
                                                   }
                                                }
                                                else
                                                {
                                                   skillUpgrade(param1.getBody() as int);
                                                }
                                             }
                                             else
                                             {
                                                _loc3_ = param1.getBody() as Object;
                                                ElfIndividualUI.getInstance().updateSkillPointTf(_loc3_.skillDot,_loc3_.skillDotReTime);
                                                ElfIndividualUI.getInstance().updateBuySkillInfo(_loc3_);
                                                addElf();
                                                skillUpgrade(_loc3_.skillDot);
                                                if(!PlayerVO.bagElfVec[currentElfIndex])
                                                {
                                                   currentElfIndex = 0;
                                                }
                                                showSelete(elfArray[currentElfIndex]);
                                                if(PlayerVO.silver >= 800000)
                                                {
                                                   updataAllElfPrompt();
                                                }
                                                if(secondOpen == "突破")
                                                {
                                                   openBreakPage();
                                                }
                                                if(secondOpen == "个体值")
                                                {
                                                   openSkillPage();
                                                }
                                                BeginnerGuide.playBeginnerGuide();
                                                if(!evolveGuide())
                                                {
                                                   updateChildInfo();
                                                }
                                                secondOpen = "";
                                             }
                                          }
                                          else if(param1.getBody() as Boolean == false)
                                          {
                                             myElf.evolvePrompt.visible = false;
                                             PlayerVO.bagElfVec[currentElfIndex].isEvolve = false;
                                             isHasPrompt("进化");
                                          }
                                       }
                                       else if(param1.getBody() as Boolean == false)
                                       {
                                          myElf.starPropmpt.visible = false;
                                          PlayerVO.bagElfVec[currentElfIndex].isStar = false;
                                          isHasPrompt("升星");
                                       }
                                    }
                                    else if(param1.getBody() as Boolean == false)
                                    {
                                       myElf.breakPropmpt.visible = false;
                                       PlayerVO.bagElfVec[currentElfIndex].isBreak = false;
                                       isHasPrompt("突破");
                                    }
                                 }
                                 else
                                 {
                                    if(CompChildUI.getInstance().parent)
                                    {
                                       CompChildUI.getInstance().showDropList(param1.getBody() as Array);
                                    }
                                    if(ComposeUI.getInstance().parent)
                                    {
                                       ComposeUI.getInstance().showDropList(param1.getBody() as Array);
                                    }
                                 }
                              }
                              else
                              {
                                 ElfStarUI.getInstance().starSuccess();
                                 silverLess();
                              }
                           }
                           else
                           {
                              ElfBreakUI.getInstance().breakSuccess();
                              silverLess();
                           }
                        }
                        else
                        {
                           _loc2_ = param1.getBody() as PropVO;
                           if(_loc2_.type == 1 || _loc2_.type == 23)
                           {
                              myElf.carryEquip.cleanImg();
                           }
                           else if(_loc2_.type == 16 || _loc2_.type == 17)
                           {
                              myElf.hagberry.cleanImg();
                           }
                        }
                     }
                     else
                     {
                        EventCenter.addEventListener("UPDATE_BAG_SUCCESS",updateInfo);
                        saveState();
                        sendNotification("UPDATE_BAG_ELF");
                     }
                  }
                  else
                  {
                     (Config.starling.root as Game).addChild(myElf);
                  }
               }
               else
               {
                  myElf.removeFromParent();
               }
            }
            else
            {
               if(!myElf.parent)
               {
                  return;
               }
               if(!PlayerVO.bagElfVec[currentElfIndex])
               {
                  currentElfIndex = 0;
               }
               updateChildInfo();
            }
         }
         else
         {
            EventCenter.addEventListener("elf_evolve_mc_complete",eveolveAtfer);
            _loc4_ = param1.getBody() as ElfVO;
            CalculatorFactor.calculatorElf(_loc4_);
            PlayerVO.bagElfVec[_loc4_.position - 1] = _loc4_;
            PlayerVO.bagElfVec[_loc4_.position - 1].isBreak = myElf.breakPropmpt.visible;
            PlayerVO.bagElfVec[_loc4_.position - 1].isStar = myElf.starPropmpt.visible;
            PlayerVO.bagElfVec[_loc4_.position - 1].isEvolve = myElf.evolvePrompt.visible;
            EvolveUI.getInstance().remove();
            if(!PlayerVO.bagElfVec[currentElfIndex])
            {
               currentElfIndex = 0;
            }
         }
      }
      
      private function eveolveAtfer() : void
      {
         EventCenter.removeEventListener("elf_evolve_mc_complete",eveolveAtfer);
         checkAllElfState(currentElfIndex);
         updateChildInfo();
         elfArray[currentElfIndex].myElfVo = PlayerVO.bagElfVec[currentElfIndex];
      }
      
      private function evolveGuide() : Boolean
      {
         var _loc2_:* = 0;
         if(TrainPro.isSeleSkill)
         {
            TrainPro.isSeleSkill = false;
            return false;
         }
         if(CompChildUI.getInstance().parent)
         {
            return false;
         }
         var _loc1_:Game = Config.starling.root as Game;
         if(_loc1_.page is MainCityUI || _loc1_.page is CityMapUI || _loc1_.page is WorldMapUI)
         {
            LogUtil("进化引导========",LSOManager.get("isCompleteEvolution"));
            if(!LSOManager.get("isCompleteEvolution"))
            {
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc2_])
                  {
                     if(PlayerVO.bagElfVec[_loc2_].isEvolve && PlayerVO.bagElfVec[_loc2_].evolveIdArr.length == 0)
                     {
                        currentElfIndex = _loc2_;
                        showSelete(elfArray[currentElfIndex]);
                        updateChildInfo();
                        BeginnerGuide.playEvolution();
                        return true;
                     }
                  }
                  _loc2_++;
               }
            }
         }
         return false;
      }
      
      private function saveState() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         saveStateArr = [];
         saveEvoPromptArr = [];
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_])
            {
               _loc1_ = {};
               _loc1_.isBreak = PlayerVO.bagElfVec[_loc2_].isBreak;
               _loc1_.isStar = PlayerVO.bagElfVec[_loc2_].isStar;
               _loc1_.isEvolve = PlayerVO.bagElfVec[_loc2_].isEvolve;
               saveStateArr.push(_loc1_);
               saveEvoPromptArr.push(PlayerVO.bagElfVec[_loc2_].isPromptEvolve);
            }
            _loc2_++;
         }
      }
      
      private function skillUpgrade(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         LogUtil("技能点=========",param1);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_])
            {
               if(_loc2_ < elfArray.length)
               {
                  elfArray[_loc2_].skillPrompt.visible = false;
               }
               if(param1 > 0)
               {
                  _loc3_ = 0;
                  while(_loc3_ < PlayerVO.bagElfVec[_loc2_].individual.length)
                  {
                     if(PlayerVO.bagElfVec[_loc2_].lv >= 17 && PlayerVO.bagElfVec[_loc2_].individual[_loc3_] * 2 < PlayerVO.bagElfVec[_loc2_].lv && (PlayerVO.bagElfVec[_loc2_].individual[_loc3_] * 2 + 1) * 1000 < PlayerVO.silver && PlayerVO.bagElfVec[_loc2_].individual[_loc3_] < 30)
                     {
                        LogUtil("可以有了 ");
                        if(_loc2_ < elfArray.length)
                        {
                           elfArray[_loc2_].skillPrompt.visible = true;
                        }
                        break;
                     }
                     _loc3_++;
                  }
               }
            }
            _loc2_++;
         }
         if(!PlayerVO.bagElfVec[currentElfIndex])
         {
            currentElfIndex = 0;
         }
         if(currentElfIndex < elfArray.length)
         {
            myElf.skillPrompt.visible = elfArray[currentElfIndex].skillPrompt.visible;
         }
         silverLess();
      }
      
      private function updateInfo() : void
      {
         EventCenter.removeEventListener("UPDATE_BAG_SUCCESS",updateInfo);
         updateBagElf();
      }
      
      private function updateBagElf(param1:Boolean = true) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_])
            {
               if(param1)
               {
                  PlayerVO.bagElfVec[_loc2_].isBreak = saveStateArr[_loc2_].isBreak;
                  PlayerVO.bagElfVec[_loc2_].isStar = saveStateArr[_loc2_].isStar;
                  PlayerVO.bagElfVec[_loc2_].isEvolve = saveStateArr[_loc2_].isEvolve;
                  PlayerVO.bagElfVec[_loc2_].isPromptEvolve = saveEvoPromptArr[_loc2_];
               }
               if(_loc2_ < elfArray.length)
               {
                  elfArray[_loc2_].myElfVo = PlayerVO.bagElfVec[_loc2_];
               }
            }
            _loc2_++;
         }
         updateChildInfo();
      }
      
      private function updataAllElfPrompt() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               checkAllElfState(_loc1_);
            }
            _loc1_++;
         }
      }
      
      private function silverLess() : void
      {
         LogUtil(" 钱不够啦，更新一下 突破， 升星，");
         if(PlayerVO.silver < 800000)
         {
            updataAllElfPrompt();
         }
      }
      
      private function isHasPrompt(param1:String) : void
      {
         if(currentElfIndex < elfArray.length)
         {
            LogUtil("检测该精灵的是否有提示的红点……………………………………………………",param1,myElf.breakPropmpt.visible,myElf.evolvePrompt.visible,myElf.starPropmpt.visible);
            elfArray[currentElfIndex].promopImg.visible = false;
            if(myElf.breakPropmpt.visible || myElf.evolvePrompt.visible || myElf.starPropmpt.visible)
            {
               LogUtil("该精灵提示的红点显示");
               elfArray[currentElfIndex].promopImg.visible = true;
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_elf","UPDATE_MYELF_ELF","UPDATE_MYELF","REMOVE_MYELF","ADD_MYELF","UPDATE_ELFPANEL_ELF","UNLOAD_PROP","BREAK_SUCCESS","JUMP_CITY_SUCCESS","SHOW_MYELF","STAR_SUCCESS","UPDATA_BREAK_PROMPT","UPDATA_STAR_PROMPT","UPDATA_EVOLVE_PROMPT","UPDATA_MYELF","UPDATA_SKILL_PROMPT","UPDATA_MYELF_DATA","OPEN_CHILD_PAGE"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         pageType = 0;
         currentElfIndex = 0;
         facade.removeMediator("MyElfMedia");
         UI.removeFromParent();
         viewComponent = null;
         ElfFrontImageManager.getInstance().dispose();
      }
   }
}
