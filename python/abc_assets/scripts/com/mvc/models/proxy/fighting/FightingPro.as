package com.mvc.models.proxy.fighting
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import feathers.controls.Alert;
   import com.mvc.views.mediator.fighting.FightingLogicFactor;
   import com.mvc.GameFacade;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.dialogue.Dialogue;
   import com.common.consts.ConfigConst;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mainCity.hunting.HuntingUI;
   import com.mvc.models.proxy.mainCity.hunting.HuntingPro;
   import com.mvc.views.uis.huntingParty.HuntingPartyUI;
   import com.common.util.fighting.GotoChallenge;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.events.Event;
   import com.common.net.CheckNetStatus;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.loading.PVPLoading;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class FightingPro extends Proxy
   {
      
      public static const NAME:String = "FightingPro";
      
      private static var client:Client;
      
      public static var isPvpOver:Boolean;
      
      public static var isOutLineOfSelf:Boolean;
      
      private static var alert:Alert;
      
      public static var isRequest1501Com:Boolean = true;
       
      private var catchBallId:int;
      
      private var _callBack:Function;
      
      private var cthVfy:String = null;
      
      public function FightingPro(param1:String = null, param2:Object = null)
      {
         super("FightingPro",param2);
         client = Client.getInstance();
         client.addCallObj("note1501",this);
         client.addCallObj("note1502",this);
         client.addCallObj("note3100",this);
         client.addCallObj("note1601",this);
         client.addCallObj("note1602",this);
         client.addCallObj("note1603",this);
         client.addCallObj("note6001",this);
         client.addCallObj("note6002",this);
         client.addCallObj("note6003",this);
      }
      
      public static function dropLineOfSelfHandler() : void
      {
         isPvpOver = false;
         if(!FightingLogicFactor.isPVP)
         {
            return;
         }
         GameFacade.getInstance().sendNotification("pvp_timer_stop");
         if(alert != null)
         {
            return;
         }
         alert = Alert.show("您已掉线！","",new ListCollection([{"label":"我知道啦"}]));
         var failFightHandler:Function = function():void
         {
            alert = null;
            FightingConfig.isWin = false;
            Dialogue.initAll();
            GameFacade.getInstance().sendNotification(ConfigConst.INIT_ALL_ELF);
            GameFacade.getInstance().sendNotification("switch_page","RETURN_LAST");
         };
         alert.addEventListener("close",failFightHandler);
      }
      
      public static function dropLineHandler() : void
      {
         isPvpOver = false;
         if(!FightingLogicFactor.isPVP)
         {
            return;
         }
         if(alert != null)
         {
            return;
         }
         GameFacade.getInstance().sendNotification("pvp_timer_stop");
         alert = Alert.show("对方已经掉线！","",new ListCollection([{"label":"我知道啦"}]));
         alert.addEventListener("close",winFightHandler);
      }
      
      private static function winFightHandler() : void
      {
         alert = null;
         if((Starling.current.root as Game).page is PVPBgUI)
         {
            GameFacade.getInstance().sendNotification("update_pvpChallenge_state",false);
            return;
         }
         FightingConfig.isWin = true;
         Dialogue.initAll();
         GameFacade.getInstance().sendNotification(ConfigConst.INIT_ALL_ELF);
         GameFacade.getInstance().sendNotification("switch_page","RETURN_LAST");
      }
      
      public function write3100(param1:Function = null) : void
      {
         _callBack = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3100;
         client.sendBytes(_loc2_);
      }
      
      public function note3100(param1:Object) : void
      {
         LogUtil("接受3001" + JSON.stringify(param1));
         if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
            return;
         }
         FightingConfig.fightToken = param1.data.verify;
         if(_callBack != null)
         {
            _callBack();
            _callBack = null;
         }
         return;
         §§push(LogUtil(FightingConfig.fightToken + "战斗token"));
      }
      
      public function write1501(param1:ElfVO, param2:PropVO, param3:Boolean) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 1501;
         _loc4_.maxHp = param1.totalHp;
         _loc4_.curHp = param1.currentHp;
         _loc4_.libId = param1.elfId;
         _loc4_.stateAry = param1.status;
         _loc4_.pId = param2.id;
         catchBallId = param2.id;
         _loc4_.isNpc = param3;
         client.sendBytes(_loc4_);
         isRequest1501Com = false;
      }
      
      public function note1501(param1:Object) : void
      {
         LogUtil("1501=" + JSON.stringify(param1));
         if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
            return;
         }
         if(param1.data.hasOwnProperty("cthVfy"))
         {
            cthVfy = param1.data.cthVfy;
         }
         isRequest1501Com = true;
         GameFacade.getInstance().sendNotification("catch_elf_result",param1.data);
      }
      
      public function write1502(param1:ElfVO) : void
      {
         param1.elfBallId = catchBallId;
         var _loc3_:Object = {};
         _loc3_.msgId = 1502;
         if(cthVfy != null)
         {
            _loc3_.cthVfy = cthVfy;
            cthVfy = null;
         }
         var _loc2_:Object = {};
         _loc2_.spId = param1.elfId;
         if(param1.nickName != param1.name)
         {
            _loc2_.nickName = param1.nickName;
         }
         _loc2_.sex = param1.sex;
         _loc2_.lv = param1.lv;
         _loc2_.hp = param1.currentHp;
         _loc2_.ball = param1.elfBallId;
         _loc3_.poke = _loc2_;
         if(LoadPageCmd.lastPage is HuntingUI)
         {
            _loc3_.huntGrade = HuntingPro.huntingGrade;
         }
         else
         {
            _loc3_.nodeId = FightingConfig.selectMap.nodeId;
         }
         client.sendBytes(_loc3_);
      }
      
      public function note1502(param1:Object) : void
      {
         LogUtil("1502=" + JSON.stringify(param1));
         if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
            return;
         }
         GameFacade.getInstance().sendNotification("save_catch_elf_result",param1.data);
      }
      
      public function write1601() : void
      {
         var _loc1_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = 0;
         var _loc3_:* = null;
         if(LoadPageCmd.lastPage is HuntingUI || LoadPageCmd.lastPage is HuntingPartyUI)
         {
            GotoChallenge.updateBagElfVecAfterPVP();
         }
         var _loc8_:Object = {};
         _loc8_.msgId = 1601;
         var _loc4_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc5_] != null && PlayerVO.bagElfVec[_loc5_].isHasFiging)
            {
               _loc1_ = {};
               _loc1_.id = PlayerVO.bagElfVec[_loc5_].id;
               _loc1_.hp = PlayerVO.bagElfVec[_loc5_].currentHp;
               _loc1_.exp = Math.round(PlayerVO.bagElfVec[_loc5_].currentExp);
               _loc1_.lv = PlayerVO.bagElfVec[_loc5_].lv;
               _loc6_ = [];
               if(PlayerVO.bagElfVec[_loc5_].carryProp)
               {
                  _loc6_.push(PlayerVO.bagElfVec[_loc5_].carryProp.id);
               }
               if(PlayerVO.bagElfVec[_loc5_].hagberryProp)
               {
                  _loc6_.push(PlayerVO.bagElfVec[_loc5_].hagberryProp.id);
               }
               _loc1_.cryPidAry = _loc6_;
               _loc1_.effAry = PlayerVO.bagElfVec[_loc5_].effAry;
               _loc2_ = [];
               _loc7_ = 0;
               while(_loc7_ < PlayerVO.bagElfVec[_loc5_].currentSkillVec.length)
               {
                  _loc3_ = {};
                  _loc3_.id = PlayerVO.bagElfVec[_loc5_].currentSkillVec[_loc7_].id;
                  _loc3_.pp = PlayerVO.bagElfVec[_loc5_].currentSkillVec[_loc7_].currentPP;
                  _loc3_.lv = PlayerVO.bagElfVec[_loc5_].currentSkillVec[_loc7_].lv;
                  _loc2_.push(_loc3_);
                  _loc7_++;
               }
               _loc1_.skLst = _loc2_;
               _loc1_.stateAry = PlayerVO.bagElfVec[_loc5_].status;
               _loc4_.push(_loc1_);
            }
            _loc5_++;
         }
         _loc8_.updtPokeLst = _loc4_;
         client.sendBytes(_loc8_);
         LogUtil("1601发送数据=" + JSON.stringify(_loc8_));
         write1602();
      }
      
      public function note1601(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.status;
         if("fail" === _loc3_)
         {
            _loc2_ = Alert.show(param1.data.msg,"",new ListCollection([{"label":"确定"}]));
            _loc2_.addEventListener("close",alertEvent);
         }
      }
      
      private function alertEvent(param1:Event) : void
      {
         CheckNetStatus.reLogin();
      }
      
      public function write1602() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         if(PlayerVO.usePropVec.length == 0)
         {
            return;
         }
         var _loc4_:Object = {};
         _loc4_.msgId = 1602;
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.usePropVec.length)
         {
            _loc1_ = {};
            _loc1_.pId = PlayerVO.usePropVec[_loc2_].id;
            _loc1_.useCnt = PlayerVO.usePropVec[_loc2_].useNum;
            _loc3_.push(_loc1_);
            PlayerVO.usePropVec[_loc2_].useNum = 0;
            _loc2_++;
         }
         _loc4_.usePropLst = _loc3_;
         client.sendBytes(_loc4_);
         return;
         §§push(LogUtil("1602发送数据=" + JSON.stringify(_loc4_)));
      }
      
      public function note1602(param1:Object) : void
      {
         LogUtil("1602=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" === _loc2_)
         {
            LogUtil("清空使用道具");
            PlayerVO.usePropVec = Vector.<PropVO>([]);
         }
      }
      
      public function write1603() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1603;
         _loc1_.money = FightingConfig.moneyFromFighting;
         client.sendBytes(_loc1_);
      }
      
      public function note1603(param1:Object) : void
      {
      }
      
      public function write6001(param1:int, param2:Boolean = false) : void
      {
         var _loc4_:* = false;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         FightingConfig.pvpSwitch = 1;
         var _loc6_:Object = {};
         _loc6_.msgId = 6001;
         if(param2)
         {
            _loc6_.isGoOut = 1;
            _loc6_.userId = NPCVO.useId;
            client.sendBytes(_loc6_,false);
            LogUtil("pvp逃跑了");
            return;
            §§push(LogUtil("6001发送数据=" + JSON.stringify(_loc6_) + "加载咩" + _loc4_));
         }
         else
         {
            _loc6_.skillIndex = param1;
            _loc4_ = true;
            LogUtil("撒打算当阿斯顿" + FightingConfig.otherSelectSkill);
            if(FightingConfig.otherSelectSkill != -1 || FightingConfig.otherSelectElf != -1)
            {
               _loc4_ = false;
               if(FightingConfig.otherOrderNext != null)
               {
                  FightingConfig.otherOrder = null;
                  FightingConfig.otherOrder = FightingConfig.otherOrderNext;
                  FightingConfig.otherOrderNext = null;
                  LogUtil(FightingConfig.otherOrder + "对方的指令是否为空啊啊啊啊啊");
               }
            }
            else
            {
               FightingConfig.otherOrder = null;
               LogUtil("初始化了啊啊啊啊啊");
            }
            var _loc7_:Object = {};
            if(FightingConfig.selfOrder.isPalsy == 1)
            {
               _loc7_.isPalsy = 1;
            }
            if(FightingConfig.selfOrder.isMull == 1)
            {
               _loc7_.isMull = 1;
            }
            if(FightingConfig.selfOrder.leadSkillId != 0)
            {
               _loc7_.leadSkillId = FightingConfig.selfOrder.leadSkillId;
            }
            if(FightingConfig.selfOrder.talkSleepUseIndex != -1)
            {
               _loc7_.talkSleepUseIndex = FightingConfig.selfOrder.talkSleepUseIndex;
            }
            if(FightingConfig.selfOrder.isStatusHandler == 1)
            {
               _loc7_.isStatusHandler = 1;
            }
            if(FightingConfig.selfOrder.attackNum != 0)
            {
               _loc7_.attackNum = FightingConfig.selfOrder.attackNum;
            }
            if(FightingConfig.selfOrder.attackRoundNum != 0)
            {
               _loc7_.attackRoundNum = FightingConfig.selfOrder.attackRoundNum;
            }
            if(FightingConfig.selfOrder.isHasEffect != 0)
            {
               _loc7_.isHasEffect = FightingConfig.selfOrder.isHasEffect;
            }
            if(FightingConfig.selfOrder.isFocusHit == 1)
            {
               _loc7_.isFocusHit = 1;
            }
            if(FightingConfig.selfOrder.randomStatus != 0)
            {
               _loc7_.randomStatus = FightingConfig.selfOrder.randomStatus;
            }
            if((FightingConfig.selfOrder.clearStatus as Array).length > 0)
            {
               _loc7_.clearStatus = FightingConfig.selfOrder.clearStatus;
            }
            if(FightingConfig.selfOrder.isProtectNoDie != 0)
            {
               _loc7_.isProtectNoDie = FightingConfig.selfOrder.isProtectNoDie;
            }
            _loc7_.hitRandomNum = FightingConfig.selfOrder.hitRandomNum;
            _loc7_.randomNum = FightingConfig.selfOrder.randomNum;
            _loc7_.isFristAttack = FightingConfig.selfOrder.isFristAttack;
            _loc6_.otherOrder = _loc7_;
            _loc6_.userId = NPCVO.useId;
            PVPLoading.addLoading(_loc4_);
            client.sendBytes(_loc6_,false);
            _loc7_ = null;
            if(FightingConfig.otherSelectSkill != -1)
            {
               _loc3_ = FightingConfig.otherSelectSkill;
               FightingConfig.otherSelectSkill = -1;
               sendNotification("receive_skill_index",_loc3_);
            }
            if(FightingConfig.otherSelectElf != -1)
            {
               FightingConfig.pvpSwitch = 4;
               _loc5_ = FightingConfig.otherSelectElf;
               FightingConfig.otherSelectElf = -1;
               sendNotification("receive_elf_id",_loc5_);
            }
            return;
            §§push(LogUtil("6001发送数据=" + JSON.stringify(_loc6_) + "加载咩" + _loc4_));
         }
      }
      
      public function note6001(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("接受6001=" + JSON.stringify(param1));
         PVPLoading.removeLoading();
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" === _loc3_)
            {
               if(!FightingLogicFactor.isPVP)
               {
                  return;
               }
               if(FightingConfig.isGoOut)
               {
                  return;
               }
               isPvpOver = true;
               if(param1.data.msg == "你已掉线")
               {
                  isOutLineOfSelf = true;
               }
               else
               {
                  isOutLineOfSelf = false;
               }
               if(LoadSwfAssetsManager.isLoading)
               {
                  return;
               }
               if(param1.data.msg == "你已掉线")
               {
                  dropLineOfSelfHandler();
               }
               else
               {
                  dropLineHandler();
               }
            }
         }
         else
         {
            _loc2_ = param1.data;
            if(_loc2_.hasOwnProperty("isGoOut"))
            {
               if(FightingLogicFactor.isPVP)
               {
                  if(!FightingLogicFactor.isPVP)
                  {
                     return;
                  }
                  isOutLineOfSelf = false;
                  isPvpOver = true;
                  if(LoadSwfAssetsManager.isLoading)
                  {
                     return;
                  }
                  if(alert != null)
                  {
                     return;
                  }
                  sendNotification("pvp_timer_stop");
                  alert = Alert.show("对方已经逃跑！","",new ListCollection([{"label":"我知道啦"}]));
                  alert.addEventListener("close",winFightHandler);
                  isPvpOver = false;
               }
               return;
            }
            if(FightingConfig.otherOrder == null && FightingLogicFactor.isRounding == false)
            {
               FightingConfig.otherOrder = _loc2_.otherOrder;
               LogUtil("刷新指令?");
            }
            else
            {
               FightingConfig.otherOrderNext = _loc2_.otherOrder;
               LogUtil("下一回合的指令收到没?");
            }
            LogUtil("技能的几种情况" + FightingConfig.pvpSwitch);
            if(FightingConfig.pvpSwitch != 1 && FightingConfig.pvpSwitch != 2 || FightingLogicFactor.isRounding)
            {
               FightingConfig.otherSelectSkill = _loc2_.skillIndex;
               if(FightingConfig.otherSelectSkill == -1)
               {
                  FightingConfig.otherSelectSkill = 165;
               }
               FightingConfig.otherSelectElf = -1;
               LogUtil("先收到aaa" + FightingConfig.otherSelectSkill);
            }
            else
            {
               if(FightingConfig.pvpSwitch == 1)
               {
                  FightingConfig.pvpSwitch = 1;
               }
               if(FightingConfig.pvpSwitch == 2)
               {
                  FightingConfig.pvpSwitch = 3;
               }
               sendNotification("receive_skill_index",_loc2_.skillIndex);
            }
            LogUtil("先收到" + FightingConfig.otherSelectSkill);
         }
      }
      
      public function write6002(param1:int, param2:* = true) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var param2:* = param2;
         if(param2 == false)
         {
            FightingConfig.pvpSwitch = -1;
            write6003(param1,false);
            return;
         }
         FightingConfig.pvpSwitch = 2;
         var _loc5_:Object = {};
         _loc5_.msgId = 6002;
         _loc5_.elfId = param1;
         if(FightingConfig.otherSelectSkill != -1 || FightingConfig.otherSelectElf != -1)
         {
            param2 = false;
            if(FightingConfig.otherOrderNext != null)
            {
               FightingConfig.otherOrder = null;
               FightingConfig.otherOrder = FightingConfig.otherOrderNext;
               FightingConfig.otherOrderNext = null;
               LogUtil(FightingConfig.otherOrder + "对方的指令是否为空啊啊啊啊啊");
            }
         }
         else
         {
            FightingConfig.otherOrder = null;
            LogUtil("初始化了啊啊啊啊啊");
         }
         _loc5_.userId = NPCVO.useId;
         FightingConfig.initSelfOrder(false);
         PVPLoading.addLoading(param2);
         client.sendBytes(_loc5_,false);
         if(FightingConfig.otherSelectSkill != -1)
         {
            FightingConfig.pvpSwitch = 3;
            _loc3_ = FightingConfig.otherSelectSkill;
            FightingConfig.otherSelectSkill = -1;
            sendNotification("receive_skill_index",_loc3_);
         }
         if(FightingConfig.otherSelectElf != -1)
         {
            FightingConfig.pvpSwitch = 2;
            _loc4_ = FightingConfig.otherSelectElf;
            FightingConfig.otherSelectElf = -1;
            sendNotification("receive_elf_id",_loc4_);
         }
         return;
         §§push(LogUtil("6002发送数据=" + JSON.stringify(_loc5_)));
      }
      
      public function note6002(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("接受6002=" + JSON.stringify(param1));
         PVPLoading.removeLoading();
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" === _loc3_)
            {
               if(!FightingLogicFactor.isPVP)
               {
                  return;
               }
               if(FightingConfig.isGoOut)
               {
                  return;
               }
               isPvpOver = true;
               isOutLineOfSelf = false;
               if(LoadSwfAssetsManager.isLoading)
               {
                  return;
               }
               dropLineHandler();
            }
         }
         else
         {
            _loc2_ = param1.data;
            LogUtil(FightingConfig.pvpSwitch + "pvp的几种情况");
            if(FightingConfig.pvpSwitch != 1 && FightingConfig.pvpSwitch != 2)
            {
               FightingConfig.otherSelectElf = _loc2_.elfId;
               FightingConfig.otherSelectSkill = -1;
            }
            else
            {
               FightingConfig.otherOrder = null;
               if(FightingConfig.pvpSwitch == 2)
               {
                  FightingConfig.pvpSwitch = 2;
               }
               if(FightingConfig.pvpSwitch == 1)
               {
                  FightingConfig.pvpSwitch = 4;
               }
               sendNotification("receive_elf_id",_loc2_.elfId);
            }
         }
      }
      
      public function write6003(param1:int, param2:* = true) : void
      {
         var param2:* = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 6003;
         _loc3_.elfId = param1;
         _loc3_.userId = NPCVO.useId;
         PVPLoading.addLoading(param2);
         FightingConfig.initSelfOrder(false);
         client.sendBytes(_loc3_,false);
      }
      
      public function note6003(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("接受6003=" + JSON.stringify(param1));
         PVPLoading.removeLoading(true);
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" === _loc3_)
            {
               if(!FightingLogicFactor.isPVP)
               {
                  return;
               }
               if(FightingConfig.isGoOut)
               {
                  return;
               }
               isPvpOver = true;
               isOutLineOfSelf = false;
               if(LoadSwfAssetsManager.isLoading)
               {
                  return;
               }
               dropLineHandler();
            }
         }
         else
         {
            _loc2_ = param1.data;
            LogUtil(FightingConfig.pvpSwitch + "pvp的几种情况");
            if(FightingConfig.pvpSwitch != 5)
            {
               FightingConfig.otherSelectElfAfterDie = _loc2_.elfId;
            }
            else
            {
               FightingConfig.otherOrder = null;
               FightingConfig.pvpSwitch = -1;
               sendNotification("receive_elf_id",_loc2_.elfId);
            }
         }
      }
   }
}
