package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.SelePlayElfUI;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.mvc.models.vos.mainCity.kingKwan.KingVO;
   import flash.utils.Timer;
   import com.mvc.models.vos.mainCity.train.TrialDifficultyVO;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.themes.Tips;
   import com.common.util.IsAllElfDie;
   import com.mvc.models.proxy.mainCity.kingKwan.KingKwanPro;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.proxy.mainCity.trial.TrialPro;
   import com.mvc.views.uis.mainCity.mining.MiningConfig;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.common.util.fighting.GotoChallenge;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.Sprite;
   import flash.geom.Point;
   import starling.animation.Tween;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import starling.core.Starling;
   import extend.SoundEvent;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.common.util.DisposeDisplay;
   import feathers.data.ListCollection;
   import feathers.layout.VerticalLayout;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import flash.events.TimerEvent;
   
   public class SelePlayElfMedia extends Mediator
   {
      
      public static const NAME:String = "SelePlayElfMedia";
      
      public static var isFirst:Boolean;
       
      public var selePlayElf:SelePlayElfUI;
      
      private var allElfContainVec:Vector.<ElfBgUnitUI>;
      
      private var allElfVec:Vector.<ElfVO>;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var cartoonImage:Image;
      
      private var rootClass:Game;
      
      private var myRivalVo:RivalVO;
      
      private var kingVo:KingVO;
      
      private var target:ElfBgUnitUI;
      
      private var targetX:int;
      
      private var time:int;
      
      private var keepTime:Timer;
      
      private var ifClick:Boolean;
      
      private var ifExchange:Boolean;
      
      private var ifChangePos:Boolean;
      
      private var lastPage:String;
      
      private var trialDifficultyVO:TrialDifficultyVO;
      
      public function SelePlayElfMedia(param1:Object = null)
      {
         allElfContainVec = new Vector.<ElfBgUnitUI>([]);
         allElfVec = new Vector.<ElfVO>([]);
         displayVec = new Vector.<DisplayObject>([]);
         keepTime = new Timer(10);
         super("SelePlayElfMedia",param1);
         selePlayElf = param1 as SelePlayElfUI;
         selePlayElf.addEventListener("triggered",clickHandler);
         rootClass = Config.starling.root as Game;
         isFirst = true;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(selePlayElf.btn_close !== _loc3_)
         {
            if(selePlayElf.btn_bag !== _loc3_)
            {
               if(selePlayElf.btn_ok === _loc3_)
               {
                  PlayerVO.isAcceptPvp = true;
                  if(GetElfFactor.seriesElfNum(PlayerVO.bagElfVec) == 0)
                  {
                     Tips.show("没有精灵在场上");
                     return;
                  }
                  selePlayElf.allElfList.removeFromParent();
                  removeClean();
                  isFirst = false;
                  sendNotification("switch_win",null);
                  sendNotification("ADD_ELFSERIES_MAIN");
                  sendNotification("ADD_KING");
                  sendNotification("add_pvp");
                  selePlayElf.removeFromParent();
                  if(!IsAllElfDie.playElfIsDie(lastPage))
                  {
                     _loc3_ = lastPage;
                     if("王者之路" !== _loc3_)
                     {
                        if("联盟大赛" !== _loc3_)
                        {
                           if("PVP" !== _loc3_)
                           {
                              if("试炼" !== _loc3_)
                              {
                                 if("挖矿" === _loc3_)
                                 {
                                    _loc2_ = MiningConfig.collectSpiritIdArr(PlayerVO.bagElfVec);
                                    (facade.retrieveProxy("Miningpro") as MiningPro).write3911(_loc2_);
                                 }
                              }
                              else
                              {
                                 if(trialDifficultyVO.bossId == 8)
                                 {
                                    FightingConfig.sceneName = "miaomiaoshilian";
                                 }
                                 else
                                 {
                                    FightingConfig.sceneName = "shilian";
                                 }
                                 (facade.retrieveProxy("TrialPro") as TrialPro).write2203(trialDifficultyVO.bossId,trialCallBack);
                              }
                           }
                           else
                           {
                              sendNotification("update_pvp_elfCamp");
                           }
                        }
                        else
                        {
                           (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5001(myRivalVo);
                        }
                     }
                     else
                     {
                        (facade.retrieveProxy("KingKwanPro") as KingKwanPro).write2301(kingVo);
                     }
                  }
                  else
                  {
                     FightingConfig.reGetBagElf();
                  }
               }
            }
            else
            {
               BackPackMedia.isElfSeries = true;
               selePlayElf.spr_allelf.removeFromParent();
               sendNotification("switch_win",null,"LOAD_BACKPACK_WIN");
               BeginnerGuide.removeFromParent();
            }
         }
         else
         {
            PlayerVO.isAcceptPvp = true;
            ElfBgUnitUI.isScrolling = false;
            selePlayElf.allElfList.dataViewPort.touchable = true;
            selePlayElf.allElfList.removeFromParent();
            removeClean();
            isFirst = false;
            WinTweens.closeWin(selePlayElf.spr_allelf,remove);
         }
      }
      
      public function trialCallBack() : void
      {
         FightingConfig.fightingAI = 1;
         GotoChallenge.gotoChallenge(trialDifficultyVO.bossName,trialDifficultyVO.bossImg,trialDifficultyVO.elfVOVec,false,null,0,true);
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         FightingConfig.reGetBagElf();
         sendNotification("ADD_ELFSERIES_MAIN");
         sendNotification("ADD_KING");
         sendNotification("add_pvp");
         selePlayElf.removeFromParent();
         if(lastPage == "试炼")
         {
            return;
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc3_:* = 0;
         var _loc11_:* = param1.getName();
         if("SEND_RIVAL_DATA" !== _loc11_)
         {
            if("SHOW_PLAY_ELF" !== _loc11_)
            {
               if("SHOW_COMPLAY_ELF" !== _loc11_)
               {
                  if("ADD_PLAYELF" !== _loc11_)
                  {
                     if("SUB_PLAYRLF" !== _loc11_)
                     {
                        if("SEND_PLAYELF_DATA" !== _loc11_)
                        {
                           if("CANCLE_PLAYELF_FLATTEN" !== _loc11_)
                           {
                              if("REMOVE_SELEPLAYELF_MEDIA" !== _loc11_)
                              {
                                 if("ADD_SELEPLAYELF" !== _loc11_)
                                 {
                                    if("CLEAN_PLAYELF" === _loc11_)
                                    {
                                       cleanList();
                                       showAllElf();
                                    }
                                 }
                                 else
                                 {
                                    selePlayElf.addChild(selePlayElf.spr_allelf);
                                 }
                              }
                              else
                              {
                                 dispose();
                              }
                           }
                           else
                           {
                              _loc3_ = (param1.getBody() as int) / 6;
                              ((selePlayElf.allElfList.dataProvider.data as Array)[_loc3_].icon as Sprite).unflatten();
                           }
                        }
                        else
                        {
                           _loc7_ = param1.getType() as String;
                           _loc8_ = param1.getBody() as ElfVO;
                           allElfVec[_loc7_] = _loc8_;
                           allElfContainVec[_loc7_]._elfVO = _loc8_;
                        }
                     }
                     else
                     {
                        _loc2_ = param1.getBody() as ElfVO;
                        _loc9_ = 0;
                        while(_loc9_ < PlayerVO.bagElfVec.length)
                        {
                           if(PlayerVO.bagElfVec[_loc9_] != null)
                           {
                              if(PlayerVO.bagElfVec[_loc9_].id == _loc2_.id)
                              {
                                 PlayerVO.bagElfVec[_loc9_] = null;
                                 break;
                              }
                           }
                           _loc9_++;
                        }
                        if(_loc9_ == 6)
                        {
                           return;
                        }
                        _loc10_ = 0;
                        while(_loc10_ < allElfContainVec.length)
                        {
                           if(allElfContainVec[_loc10_]._elfVO.id == _loc2_.id)
                           {
                              sendNotification("CANCLE_PLAYELF_FLATTEN",_loc10_);
                              allElfContainVec[_loc10_].tick.visible = false;
                              allElfContainVec[_loc10_].removeMask();
                              break;
                           }
                           _loc10_++;
                        }
                        GetElfFactor.otherSeiri(PlayerVO.bagElfVec);
                        playCartoon(_loc2_,_loc9_,_loc10_,false);
                        showPlayElf();
                     }
                  }
                  else
                  {
                     BeginnerGuide.playBeginnerGuide();
                     _loc4_ = param1.getBody() as ElfVO;
                     _loc5_ = 0;
                     while(_loc5_ < PlayerVO.bagElfVec.length)
                     {
                        if(PlayerVO.bagElfVec[_loc5_] == null)
                        {
                           PlayerVO.bagElfVec[_loc5_] = _loc4_;
                           break;
                        }
                        _loc5_++;
                     }
                     _loc6_ = 0;
                     while(_loc6_ < allElfContainVec.length)
                     {
                        if(allElfContainVec[_loc6_]._elfVO.id != _loc4_.id)
                        {
                           _loc6_++;
                           continue;
                        }
                        break;
                     }
                     playCartoon(_loc4_,_loc5_,_loc6_,true);
                  }
               }
               else
               {
                  showAllElf();
               }
            }
            else
            {
               showPlayElf();
            }
         }
         else
         {
            lastPage = param1.getType() as String;
            _loc11_ = lastPage;
            if("王者之路" !== _loc11_)
            {
               if("联盟大赛" !== _loc11_)
               {
                  if("试炼" !== _loc11_)
                  {
                     if("PVP" !== _loc11_)
                     {
                        if("挖矿" === _loc11_)
                        {
                           selePlayElf.btn_bag.visible = false;
                        }
                     }
                     else
                     {
                        selePlayElf.btn_bag.visible = false;
                     }
                  }
                  else
                  {
                     trialDifficultyVO = param1.getBody() as TrialDifficultyVO;
                     selePlayElf.btn_bag.visible = false;
                  }
               }
               else
               {
                  myRivalVo = param1.getBody() as RivalVO;
                  selePlayElf.btn_bag.visible = false;
               }
            }
            else
            {
               kingVo = param1.getBody() as KingVO;
               selePlayElf.btn_bag.visible = false;
            }
         }
      }
      
      private function playCartoon(param1:ElfVO, param2:int, param3:int, param4:Boolean) : void
      {
         elfVo = param1;
         i = param2;
         k = param3;
         isAdd = param4;
         SelectFormationMedia.isPlay = true;
         if(cartoonImage)
         {
            GetpropImage.clean(cartoonImage);
         }
         cartoonImage = ELFMinImageManager.getElfM(elfVo.imgName);
         var point:Point = allElfContainVec[k].getLoadPoint();
         point.x = point.x / Config.scaleX;
         point.y = point.y / Config.scaleY;
         var targetPoint:Point = selePlayElf.elfSprite.localToGlobal(new Point(selePlayElf.formationContainVec[i].x,selePlayElf.formationContainVec[i].y));
         targetPoint.x = targetPoint.x / Config.scaleX;
         targetPoint.y = targetPoint.y / Config.scaleY;
         if(isAdd)
         {
            cartoonImage.x = point.x;
            cartoonImage.y = point.y;
         }
         else
         {
            cartoonImage.x = targetPoint.x;
            cartoonImage.y = targetPoint.y;
         }
         cartoonImage.alpha = 0.8;
         rootClass.addChild(cartoonImage);
         var t1:Tween = new Tween(cartoonImage,0.2);
         Starling.juggler.add(t1);
         if(isAdd)
         {
            t1.animate("x",targetPoint.x);
            t1.animate("y",targetPoint.y);
            t1.animate("alpha",0.5);
         }
         else
         {
            t1.animate("x",point.x);
            t1.animate("y",point.y);
            t1.animate("alpha",0);
         }
         t1.onComplete = function():*
         {
            var /*UnknownSlot*/:* = §§dup(function():void
            {
               if(isAdd)
               {
                  showPlayElf();
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfVo.sound);
               }
               if(cartoonImage)
               {
                  GetpropImage.clean(cartoonImage);
               }
               SelectFormationMedia.isPlay = false;
            });
            return function():void
            {
               if(isAdd)
               {
                  showPlayElf();
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfVo.sound);
               }
               if(cartoonImage)
               {
                  GetpropImage.clean(cartoonImage);
               }
               SelectFormationMedia.isPlay = false;
            };
         }();
      }
      
      public function getAllElf() : void
      {
         var _loc4_:* = 0;
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         allElfVec = Vector.<ElfVO>([]);
         if(lastPage == "挖矿")
         {
            if(MiningConfig.miningFightElfVec.length != 0)
            {
               GetElfFactor.elfSort(MiningConfig.miningFightElfVec,"lv");
               allElfVec = MiningConfig.miningFightElfVec;
               _loc4_ = 0;
               while(_loc4_ < allElfVec.length)
               {
                  allElfVec[_loc4_].isDetail = true;
                  _loc4_++;
               }
               return;
            }
         }
         if(lastPage == "王者之路")
         {
            if(KingKwanMedia.kingPlayElf.length != 0)
            {
               GetElfFactor.elfSort(KingKwanMedia.kingPlayElf,"lv");
               allElfVec = KingKwanMedia.kingPlayElf;
               _loc1_ = 0;
               while(_loc1_ < allElfVec.length)
               {
                  allElfVec[_loc1_].isDetail = true;
                  _loc1_++;
               }
               return;
            }
         }
         if(lastPage == "联盟大赛" || lastPage == "PVP" || lastPage == "试炼")
         {
            GetElfFactor.elfSort(PlayerVO.comElfVec,"lv");
            _loc3_ = 0;
            while(_loc3_ < PlayerVO.comElfVec.length)
            {
               allElfVec.push(PlayerVO.comElfVec[_loc3_]);
               _loc3_++;
            }
            _loc2_ = 0;
            while(_loc2_ < FightingConfig.temBagElfVec.length)
            {
               if(FightingConfig.temBagElfVec[_loc2_] != null)
               {
                  allElfVec.unshift(FightingConfig.temBagElfVec[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      private function showAllElf() : void
      {
         var _loc9_:* = 0;
         var _loc6_:* = null;
         var _loc10_:* = 0;
         var _loc4_:* = null;
         selePlayElf.spr_allelf.addChild(selePlayElf.allElfList);
         if(selePlayElf.allElfList.dataProvider != null && lastPage != "挖矿")
         {
            return;
            §§push(LogUtil("已经不是第一次了"));
         }
         else
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            getAllElf();
            allElfContainVec = Vector.<ElfBgUnitUI>([]);
            var _loc8_:int = allElfVec.length;
            var _loc3_:* = 6;
            var _loc1_:Array = [];
            var _loc5_:int = Math.floor(_loc8_ / _loc3_);
            var _loc2_:* = _loc3_;
            if(_loc8_ % _loc3_ != 0)
            {
               _loc5_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc5_)
            {
               _loc6_ = new Sprite();
               if(_loc9_ == _loc5_ - 1 && _loc8_ % _loc3_ != 0)
               {
                  _loc2_ = _loc8_ % _loc3_;
               }
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  _loc4_ = new ElfBgUnitUI();
                  _loc4_.identify = "出战";
                  _loc4_.identify2 = lastPage;
                  _loc4_.name = "elfBgUI" + (_loc3_ * _loc9_ + _loc10_);
                  _loc4_.x = 140 * _loc10_;
                  _loc4_.comIndex = _loc3_ * _loc9_ + _loc10_;
                  _loc4_.myElfVo = allElfVec[_loc3_ * _loc9_ + _loc10_];
                  _loc4_.switchContain(true);
                  allElfContainVec.push(_loc4_);
                  _loc6_.addChild(_loc4_);
                  _loc10_++;
               }
               _loc6_.flatten();
               _loc1_.push({
                  "icon":_loc6_,
                  "label":""
               });
               displayVec.push(_loc6_);
               _loc9_++;
            }
            cleanList();
            var _loc7_:ListCollection = new ListCollection(_loc1_);
            selePlayElf.allElfList.dataProvider = _loc7_;
            if(!selePlayElf.allElfList.hasEventListener("initialize"))
            {
               selePlayElf.allElfList.addEventListener("initialize",creatComplete);
            }
            return;
         }
      }
      
      private function creatComplete() : void
      {
         (selePlayElf.allElfList.layout as VerticalLayout).gap = 30;
      }
      
      private function showPlayElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               selePlayElf.formationContainVec[_loc1_].myElfVo = PlayerVO.bagElfVec[_loc1_];
               selePlayElf.formationContainVec[_loc1_].switchContain(true);
               selePlayElf.formationContainVec[_loc1_].addEventListener("touch",ontouch);
               _loc2_ = 0;
               while(_loc2_ < allElfContainVec.length)
               {
                  if(allElfContainVec[_loc2_]._elfVO.id == PlayerVO.bagElfVec[_loc1_].id)
                  {
                     allElfContainVec[_loc2_].tick.visible = true;
                     allElfContainVec[_loc2_].addMask();
                     break;
                  }
                  _loc2_++;
               }
            }
            else
            {
               selePlayElf.formationContainVec[_loc1_].removeEventListener("touch",ontouch);
               selePlayElf.formationContainVec[_loc1_].hideImg();
               selePlayElf.formationContainVec[_loc1_].switchContain(false);
            }
            _loc1_++;
         }
         if(lastPage == "王者之路")
         {
            selePlayElf.power.text = GetElfFactor.kingPower(PlayerVO.bagElfVec);
         }
         else
         {
            selePlayElf.power.text = GetElfFactor.powerCalculate(PlayerVO.bagElfVec);
         }
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc2_:* = null;
         target = param1.currentTarget as ElfBgUnitUI;
         var _loc3_:Touch = param1.getTouch(target);
         if(_loc3_)
         {
            if(_loc3_.phase == "began")
            {
               targetX = target.name * 113;
               time = 0;
               keepTime.addEventListener("timer",starTime);
               keepTime.start();
               LogUtil("出战精灵的计时器开启");
            }
            if(_loc3_.phase == "moved")
            {
               removeHandle(_loc3_);
            }
            if(_loc3_.phase == "ended")
            {
               if(ifExchange)
               {
                  ifChangePos = true;
                  ifExchange = false;
                  _loc4_ = getIndex(target);
                  LogUtil("index== " + _loc4_);
                  if(offsideHandle(_loc4_,target))
                  {
                     return;
                  }
                  if(selePlayElf.formationContainVec[_loc4_] != target)
                  {
                     target.cancelSelected();
                     _loc5_ = new Tween(target,0.3,"easeOutBack");
                     Starling.juggler.add(_loc5_);
                     _loc5_.animate("x",_loc4_ * 113);
                     _loc5_.animate("y",0);
                     _loc6_ = new Tween(selePlayElf.formationContainVec[_loc4_],0.3,"easeOutBack");
                     Starling.juggler.add(_loc6_);
                     _loc6_.animate("x",targetX);
                     _loc6_.animate("y",0);
                     seiriPlayElf(target,_loc4_);
                     arrExchange(_loc4_,target);
                  }
                  else
                  {
                     target.cancelSelected();
                     _loc2_ = new Tween(target,0.3,"easeOutBack");
                     Starling.juggler.add(_loc2_);
                     _loc2_.animate("x",targetX);
                     _loc2_.animate("y",0);
                  }
               }
               if(ifClick)
               {
                  ifClick = false;
                  target.subPlayTem();
                  keepTime.stop();
                  keepTime.removeEventListener("timer",starTime);
                  LogUtil("出战精灵的计时器关闭");
               }
            }
         }
      }
      
      private function seiriPlayElf(param1:ElfBgUnitUI, param2:int) : void
      {
         var _loc3_:ElfVO = PlayerVO.bagElfVec[param1.name];
         PlayerVO.bagElfVec[param1.name] = PlayerVO.bagElfVec[param2];
         PlayerVO.bagElfVec[param2] = _loc3_;
      }
      
      private function arrExchange(param1:int, param2:ElfBgUnitUI) : void
      {
         var _loc5_:String = selePlayElf.formationContainVec[param1].name;
         var _loc4_:String = param2.name;
         var _loc6_:int = selePlayElf.formationContainVec.indexOf(param2);
         var _loc3_:ElfBgUnitUI = selePlayElf.formationContainVec[param1];
         selePlayElf.formationContainVec[_loc6_] = _loc3_;
         selePlayElf.formationContainVec[param1] = param2;
         selePlayElf.formationContainVec[param1].name = _loc5_;
         selePlayElf.formationContainVec[_loc6_].name = _loc4_;
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
         LogUtil("出战精灵的计时器关闭starMoveHandler");
         keepTime.stop();
         keepTime.removeEventListener("timer",starTime);
         ifExchange = true;
         selePlayElf.elfSprite.setChildIndex(target,selePlayElf.elfSprite.numChildren - 1);
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
      
      private function getIndex(param1:ElfBgUnitUI) : int
      {
         var _loc2_:int = (param1.x + param1.width / 2) / 113;
         return _loc2_;
      }
      
      private function offsideHandle(param1:int, param2:ElfBgUnitUI) : Boolean
      {
         var _loc3_:* = null;
         if(param1 >= GetElfFactor.seriesElfNum(PlayerVO.bagElfVec) || param1 < 0)
         {
            param2.cancelSelected();
            _loc3_ = new Tween(param2,0.3,"easeOutBack");
            Starling.juggler.add(_loc3_);
            _loc3_.animate("x",targetX);
            _loc3_.animate("y",0);
            return true;
         }
         return false;
      }
      
      public function removeClean() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               selePlayElf.formationContainVec[_loc2_].removeEventListener("touch",ontouch);
               selePlayElf.formationContainVec[_loc2_].hideImg();
               selePlayElf.formationContainVec[_loc2_].switchContain(false);
            }
            _loc2_++;
         }
         _loc1_ = 0;
         while(_loc1_ < allElfContainVec.length)
         {
            if(allElfContainVec[_loc1_].tick.visible)
            {
               allElfContainVec[_loc1_].tick.visible = false;
               allElfContainVec[_loc1_].removeMask();
            }
            _loc1_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_PLAY_ELF","SHOW_COMPLAY_ELF","SEND_RIVAL_DATA","ADD_PLAYELF","SUB_PLAYRLF","SEND_PLAYELF_DATA","CANCLE_PLAYELF_FLATTEN","REMOVE_SELEPLAYELF_MEDIA","ADD_SELEPLAYELF","CLEAN_PLAYELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      private function clean() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < selePlayElf.formationContainVec.length)
         {
            selePlayElf.formationContainVec[_loc1_].removeFromParent(true);
            selePlayElf.formationContainVec.splice(_loc1_,1);
         }
      }
      
      private function cleanList() : void
      {
         if(selePlayElf.allElfList.dataProvider)
         {
            selePlayElf.allElfList.dataProvider.removeAll();
            selePlayElf.allElfList.dataProvider = null;
         }
      }
      
      public function dispose() : void
      {
         clean();
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         cleanList();
         facade.removeMediator("SelePlayElfMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
