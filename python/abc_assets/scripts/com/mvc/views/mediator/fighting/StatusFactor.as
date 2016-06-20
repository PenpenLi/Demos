package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.GameFacade;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.mvc.views.uis.fighting.CampBaseUI;
   import starling.core.Starling;
   
   public class StatusFactor
   {
      
      public static var statusInfo:Array = ["灼伤","冰冻","麻痹","中毒","猛毒","睡眠","混乱","束缚","退缩","寄生","石化","集气","替身","白雾","缩小","愤怒","忍忍","变身","飞翔","挖地洞","减半反射","光墙","心眼","噩梦","咒语","守住","看破","同命","连切","神秘护身","忍耐","假指控","充电","被挑拨","祈求","扎根","魔术外衣","打哈欠","落拳","封印","怨恨","破灭愿望","潜水"];
      
      public static var statusIntroduce:Array = ["每回合结束时损失HP \n 物理攻击伤害减半","精灵无法使用技能","每回合一定概率无法使用技能 \n 速度降低","每回合结束时损失HP","每回合结束时损失HP","精灵无法使用技能","每回合有一定的几率无法发出技能，而变为使用一个目标为自身，威力为40的无属性物理技能","每回合结束时损失HP\n无法换下或逃跑\n不能使用瞬间移动（技能）","当回合不能使用技能\n在当回合结束后退缩状态就会解除","每回合结束时损失HP，同时该状态的施放者恢复等量的HP","进入石化状态前最后使用的技能不能使用","技能的击中要害率提升","多次攻击类技能打消替身后可以继续攻击\n不能防止的效果及技能：自己发动的睡觉、石化、吼叫、旋风、黑雾","能力等级不会被来自对方的效果降低","使用者的回避提升\n被践踏技能攻击时伤害加倍，同时必定命中","受到技能伤害时攻击力上升 \n 替身挡下伤害不算作受到技能伤害","等待两回合, 第三回合以承受伤害的两倍的力量来反击。不受属性相性影响。","处于变身状态的神奇宝贝的部分项目变为与变身对象相同","除特定技能外，任何来自对方的技能均无法影响处于飞翔状态的神奇宝贝\n受到来自对方的烈暴风（技能）攻击时技能威力加倍\n可以击中飞翔状态的技能：裂暴风、打雷、旋风、音爆","除特定技能外，任何来自对方的技能均无法影响处于挖地洞状态的神奇宝贝\n来自对方的地震（技能）攻击时技能威力加倍\n可以击中挖地洞状态的技能：地震、地裂、音爆、猛毒素","受到物理技能攻击时，减少伤害\n发生击中要害时无效\n不减轻混乱的伤害","增强防御","使目标陷入心眼状态，下回合对目标的攻击必定命中。","处于恶梦状态的神奇宝贝在每个回合结束时损失最大HP的1/4。","处于该状态的神奇宝贝每回合结束时损失最大HP的1/4，离场后状态消失。","保护自身不受到来自对方场地的大部分技能的影响","处于看破状态的神奇宝贝回避提升无效，可以受到一般系和格斗系技能的攻击","如果自身在下次行动前被技能直接造成的伤害击倒，击倒自己的神奇宝贝也会倒下。","每次连切成功命中对手，则下次攻击时技能威力翻倍。","5回合内保护己方神奇宝贝不会陷入异常状态、混乱状态、哈欠状态","在本回合结束使自身保留至少1点HP，即使受到一击必杀类技能的攻击也会保留1点HP。","挑拨对方，令其不能连续使用同样的技能。","下一回合使用的电系技能威力上升。自己的特防也会提升。","在3回合之内只能用攻击技能。","在下一回合，回复自身最大HP的一半。","在大地上扎根每回合恢复HP。在扎根期间不能交换神奇宝贝。","反弹对方使用的异常状态等干扰技能。","打哈欠引起睡意。下回合对手会睡眠。","处于落拳状态的神奇宝贝可以视作失去携带物品。","如果对方拥有与自己相同的技能，那么对方将无法使用这些技能。","注入强烈的怨念。被对方击倒时对方所用技能的PP将变为0。","使用技能2回合后，会有无数道光线射向对方进行攻击。","使用潜水的神奇宝贝在第一回合潜入水下进行蓄气，第二回合发动攻击"];
      
      public static var statusClearOnOut:Array = [7,9,10,11,12,13,15,17,18,19,20,21,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,42,43];
      
      public static var specialStatus:Array = [1,2,3,4,5,6];
       
      public function StatusFactor()
      {
         super();
      }
      
      public static function getStatus(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(param1.currentHp == 0)
         {
            return;
         }
         isRandomStatus(param1,param2,param3);
         isCarryPropEffect(param1,param2,param3);
         LogUtil(param2.status[0] + "呵呵呵呵呵呵状态" + param2.name + "dasdasd" + param2.status);
         if(param2.status[0] == 0)
         {
            return;
         }
         if(param2.status[0] == 9)
         {
            if(param3.camp == "camp_of_player" && !FightingLogicFactor.isFirstOfOurs)
            {
               return;
            }
            if(param3.camp == "camp_of_computer" && FightingLogicFactor.isFirstOfOurs)
            {
               return;
            }
         }
         if(param2.status[0] == 19)
         {
            return;
         }
         if(param2.status[0] == 20)
         {
            return;
         }
         if(param2.status[0] == 43)
         {
            return;
         }
         if(param2.status[0] == 39 && param1.carryProp == null && param1.hagberryProp == null)
         {
            Dialogue.collectDialogue(param1.nickName + "身上没有携带品\n落拳状态不生效");
            return;
         }
         if(param1.status.indexOf(30) != -1 && param2.skillAffectTarget == 1)
         {
            _loc4_ = 0;
            while(_loc4_ < specialStatus.length)
            {
               if(param2.status[0] == specialStatus[_loc4_])
               {
                  Dialogue.collectDialogue(param1.nickName + "神秘护身\n防止一切异常状态");
                  return;
               }
               _loc4_++;
            }
            if(param2.status[0] == 7)
            {
               Dialogue.collectDialogue(param1.nickName + "神秘护身\n防止混乱");
               return;
            }
         }
         if(hasHandlerStatus(param2))
         {
            replySkillStatus(param1,param2,param3);
            return;
         }
         if(isHasCannotCom(param1,param2))
         {
            replySkillStatus(param1,param2,param3);
            return;
         }
         if(param2.status[0] == 22)
         {
            param1.wallArr.push(0);
            Dialogue.collectDialogue(param1.nickName + "提高了防御");
            return;
         }
         if(param1.status.indexOf(13) != -1)
         {
            _loc5_ = param2.status[0];
            if(_loc5_ == 1 || _loc5_ == 2 || _loc5_ == 3 || _loc5_ == 4 || _loc5_ == 5 || _loc5_ == 7 || _loc5_ == 9 || _loc5_ == 10)
            {
               Dialogue.collectDialogue(param1.nickName + "替身状态防止" + statusInfo[param2.status[0] - 1] + "状态");
               replySkillStatus(param1,param2,param3);
               return;
            }
            if(param1.id != param3.id && _loc5_ == 6)
            {
               Dialogue.collectDialogue(param1.nickName + "替身状态防止" + statusInfo[param2.status[0] - 1] + "状态");
               replySkillStatus(param1,param2,param3);
               return;
            }
         }
         if(param2.status[0] != 0)
         {
            if(param2.status[0] == 29)
            {
               getStatusHandler(param3,param2,param3);
            }
            else
            {
               getStatusHandler(param1,param2,param3);
            }
         }
         replySkillStatus(param1,param2,param3);
      }
      
      private static function replySkillStatus(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         if(param3.carryProp && param3.carryProp.name == "王者之证" && param3.status.indexOf(39) == -1)
         {
            if(param2.sort == "格斗" && param2.status[0] == 9)
            {
               param2.status = [0];
            }
         }
      }
      
      private static function isCarryPropEffect(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         if(param3.carryProp && param3.carryProp.name == "王者之证" && param3.status.indexOf(39) == -1)
         {
            if(param2.sort == "格斗" && param2.status[0] == 0)
            {
               param2.status = [9,10];
            }
         }
      }
      
      private static function isNoEffectStatus(param1:ElfVO, param2:SkillVO) : Boolean
      {
         LogUtil(param1.name + "的属性" + param1.nature + "中招的状态" + param2.status[0]);
         if(param2.status[0] == 1 && param1.nature.indexOf("火") != -1)
         {
            return true;
         }
         if(param2.status[0] == 2 && param1.nature.indexOf("冰") != -1)
         {
            return true;
         }
         if(param2.status[0] == 3 && param1.nature.indexOf("电") != -1)
         {
            return true;
         }
         if((param2.status[0] == 4 || param2.status[0] == 5) && param1.nature.indexOf("钢") != -1)
         {
            return true;
         }
         if((param2.status[0] == 4 || param2.status[0] == 5) && param1.nature.indexOf("毒") != -1)
         {
            return true;
         }
         if(param2.status[0] == 10 && param1.nature.indexOf("草") != -1)
         {
            return true;
         }
         return false;
      }
      
      private static function getStatusHandler(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param3.status.indexOf(19) != -1 || param3.status.indexOf(20) != -1)
            {
               return;
            }
            if(param3.camp == "camp_of_player")
            {
               if(FightingConfig.selfOrder.isStatusHandler == 1)
               {
                  statusHandler(param1,param2,param3);
               }
            }
            else if(FightingConfig.otherOrder.hasOwnProperty("isStatusHandler") && FightingConfig.otherOrder.isStatusHandler == 1)
            {
               statusHandler(param1,param2,param3);
            }
            return;
         }
         if(Math.random() * 100 < param2.status[1])
         {
            statusHandler(param1,param2,param3);
         }
      }
      
      private static function statusHandler(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         var _loc4_:* = false;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param3.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isStatusHandler = 1;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isStatusHandler = 1;
            }
         }
         if(param1.status.indexOf(param2.status[0]) == -1)
         {
            _loc4_ = isNoEffectStatus(param1,param2);
            LogUtil(_loc4_ + "是否免疫");
            _loc6_ = statusInfo[param2.status[0] - 1];
            if(_loc4_)
            {
               _loc6_ = statusInfo[param2.status[0] - 1];
               Dialogue.collectDialogue(param1.nickName + "免疫" + _loc6_ + "状态");
               return;
            }
            if(param2.name == "电磁波" && param1.nature.indexOf("地上") != -1)
            {
               Dialogue.collectDialogue(param2.name + "对地上系精灵无效");
               return;
            }
            if(param2.status[0] == 11)
            {
               if(param1.skillOfLast == null)
               {
                  Dialogue.collectDialogue(param3.nickName + "使用石化功失败");
                  return;
               }
               param1.skillBeforeStrone = param1.skillOfLast;
               param1.stoneCount = 0;
            }
            if(param2.status[0] == 24)
            {
               if(param1.status.indexOf(6) == -1)
               {
                  Dialogue.collectDialogue(param3.nickName + "还没睡眠,噩梦无效");
                  return;
               }
            }
            if(param1.status.indexOf(26) != -1)
            {
               Dialogue.collectDialogue(param3.nickName + "守住，" + _loc6_ + "状态无效");
               return;
            }
            if(param2.status[0] == 25)
            {
               _loc5_ = param3.totalHp / 2;
               if(_loc5_ > param3.currentHp)
               {
                  _loc5_ = param3.currentHp;
               }
               GameFacade.getInstance().sendNotification("hp_change",_loc5_,param3.camp);
            }
            if(param2.status[0] == 6 && FeatureFactor.insomnia(param1))
            {
               Dialogue.collectDialogue(param1.nickName + "失眠");
               return;
            }
            if(PropFactor.carryClearPropHandler(param1,_loc6_,param3))
            {
               return;
            }
            if(param2.status[0] == 6 && FightingLogicFactor.isNoisy > 0)
            {
               Dialogue.collectDialogue("周围很吵闹\n" + param1.nickName + "无法陷入睡眠状态");
               return;
            }
            if(param2.status[0] == 38 && param1.status.indexOf(6) != -1)
            {
               Dialogue.collectDialogue(param1.nickName + "睡得很熟");
               return;
            }
            if(param2.name == "装腔作势")
            {
               if(param1.ablilityAddLv[0] == 6)
               {
                  Dialogue.collectDialogue(param1.nickName + "攻击力无法再提升");
                  return;
               }
               var _loc7_:* = 0;
               var _loc8_:* = param1.ablilityAddLv[_loc7_] + 2;
               param1.ablilityAddLv[_loc7_] = _loc8_;
               Dialogue.collectDialogue(param1.nickName + "攻击力提升");
            }
            param1.status.push(param2.status[0]);
            Dialogue.collectDialogue(param1.nickName + "\n进入" + _loc6_ + "状态");
            if(param2.status[0] == 17)
            {
               param1.tolerCount = 0;
            }
            if(param2.status[0] == 23)
            {
               param1.eyeCount = 0;
            }
         }
         else if(param2.status[0] != 29)
         {
            if(param2.status[0] == 33)
            {
               param1.powerCount = 0;
            }
            Dialogue.collectDialogue(param1.nickName + "\n正处于" + statusInfo[param2.status[0] - 1] + "状态");
         }
         if(param2.status[0] == 5)
         {
            param1.hurtNum = 1;
         }
      }
      
      private static function isHasCannotCom(param1:ElfVO, param2:SkillVO) : Boolean
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc3_:* = null;
         if(param2.status[0] <= 6)
         {
            _loc4_ = 1;
            while(_loc4_ <= 6)
            {
               if(param1.status.indexOf(_loc4_) != -1)
               {
                  _loc5_ = statusInfo[param2.status[0] - 1];
                  _loc3_ = statusInfo[_loc4_ - 1];
                  if(_loc5_ == _loc3_)
                  {
                     Dialogue.collectDialogue(param1.name + "已经陷入了" + _loc3_);
                  }
                  else
                  {
                     Dialogue.collectDialogue(param1.name + "已经陷入了" + _loc3_ + "\n" + _loc5_ + "状态没有生效");
                  }
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      private static function isRandomStatus(param1:ElfVO, param2:SkillVO, param3:ElfVO) : void
      {
         var _loc4_:* = 0;
         if(param2.name == "三角攻击")
         {
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               if(param1.camp == "camp_of_player")
               {
                  param2.status[0] = FightingConfig.otherOrder.randomStatus;
               }
               else
               {
                  param2.status[0] = FightingConfig.selfOrder.randomStatus;
               }
            }
            else
            {
               _loc4_ = Math.round(Math.random() * 2 + 1);
               param2.status[0] = _loc4_;
            }
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].randomStatus = param2.status[0];
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].randomStatus = param2.status[0];
            }
         }
      }
      
      private static function hasHandlerStatus(param1:SkillVO) : Boolean
      {
         if(param1.name == "花之舞" || param1.name == "横冲直撞" || param1.name == "愤怒")
         {
            return true;
         }
         return false;
      }
      
      public static function statusHandlerBeforeSkillStart(param1:CampBaseUI, param2:String) : Boolean
      {
         var _loc4_:* = null;
         var _loc3_:ElfVO = param1.myVO;
         if(_loc3_.camp == "camp_of_player")
         {
            _loc4_ = CampOfComputerMedia._currentCamp.myVO;
         }
         else
         {
            _loc4_ = CampOfPlayerMedia._currentCamp.myVO;
         }
         if(_loc3_.status.indexOf(2) != -1)
         {
            SkillFactor.playStatusEffect(2,param1);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.name + "陷入冰冻状态\n无法使用技能",_loc3_.camp);
            if(!storeHandler(param1))
            {
               _loc3_.currentSkill.currentPP = _loc3_.currentSkill.currentPP + 1;
            }
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         if(_loc3_.status.indexOf(3) != -1)
         {
            if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
            {
               if(_loc3_.camp == "camp_of_player")
               {
                  if(FightingConfig.selfOrder.isPalsy == 1)
                  {
                     palsyHandler(param1);
                     _loc3_.currentSkill.continueSkillCount = 0;
                     _loc3_.currentSkill = null;
                     return true;
                  }
               }
               else
               {
                  if(FightingConfig.otherOrder == null)
                  {
                     return false;
                  }
                  if(FightingConfig.otherOrder.hasOwnProperty("isPalsy") && FightingConfig.otherOrder.isPalsy == 1)
                  {
                     palsyHandler(param1);
                     _loc3_.currentSkill.continueSkillCount = 0;
                     _loc3_.currentSkill = null;
                     return true;
                  }
               }
            }
            else if(Math.random() * 4 < 1)
            {
               palsyHandler(param1);
               _loc3_.currentSkill.continueSkillCount = 0;
               _loc3_.currentSkill = null;
               return true;
            }
         }
         if(_loc3_.status.indexOf(6) != -1 && _loc3_.currentSkill.name != "梦话" && _loc3_.currentSkill.name != "打鼾")
         {
            SkillFactor.playStatusEffect(6,param1);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "睡得很熟",_loc3_.camp);
            if(!storeHandler(param1))
            {
               _loc3_.currentSkill.currentPP = _loc3_.currentSkill.currentPP + 1;
            }
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         if(_loc3_.status.indexOf(9) != -1)
         {
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "害怕",_loc3_.camp);
            if(!storeHandler(param1))
            {
               _loc3_.currentSkill.currentPP = _loc3_.currentSkill.currentPP + 1;
            }
            FeatureFactor.steadfast(_loc3_);
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         if(_loc3_.status.indexOf(6) == -1 && (_loc3_.currentSkill.name == "梦话" || _loc3_.currentSkill.name == "打鼾"))
         {
            FeatureFactor.pressureHandler(_loc4_,_loc3_);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "不在睡眠中\n技能使用失败",_loc3_.camp);
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         if(_loc3_.status.indexOf(32) != -1 && _loc3_.skillOfLast == _loc3_.currentSkill)
         {
            FeatureFactor.pressureHandler(_loc4_,_loc3_);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "被指控\n不能连续使用相同技能",_loc3_.camp);
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         LogUtil(_loc3_.currentSkill.power + "当前技能名字" + _loc3_.name);
         if(_loc3_.status.indexOf(34) != -1 && _loc3_.currentSkill.power == 0)
         {
            FeatureFactor.pressureHandler(_loc4_,_loc3_);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "被挑拨\n不能使用非攻击技能",_loc3_.camp);
            _loc3_.currentSkill.continueSkillCount = 0;
            _loc3_.currentSkill = null;
            return true;
         }
         if(FightingLogicFactor.isNoisy > 0 && _loc3_.currentSkill.id == 156)
         {
            FeatureFactor.pressureHandler(_loc4_,_loc3_);
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "被吵闹\n睡觉失败",_loc3_.camp);
            _loc3_.currentSkill = null;
            return true;
         }
         if(isFailBecauseSeal(_loc3_,_loc4_))
         {
            return true;
         }
         if(_loc3_.currentSkill.id == 264)
         {
            if(_loc3_.camp == "camp_of_player")
            {
               if(!FightingLogicFactor.isFirstOfOurs && (_loc3_.lastHurtOfPhysics > 0 || _loc3_.lastHurtOfSpecial > 0))
               {
                  FeatureFactor.pressureHandler(_loc4_,_loc3_);
                  GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "受到攻击\n击中猛击失败",_loc3_.camp);
                  _loc3_.currentSkill = null;
                  return true;
               }
            }
            else if(FightingLogicFactor.isFirstOfOurs && (_loc3_.lastHurtOfPhysics > 0 || _loc3_.lastHurtOfSpecial > 0))
            {
               FeatureFactor.pressureHandler(_loc4_,_loc3_);
               GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "受到攻击\n击中猛击失败",_loc3_.camp);
               _loc3_.currentSkill = null;
               return true;
            }
         }
         if(_loc3_.currentSkill.id == 283)
         {
            if(_loc3_.currentHp >= _loc4_.currentHp)
            {
               FeatureFactor.pressureHandler(_loc4_,_loc3_);
               GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "血量大于" + _loc4_.nickName + "\n强攻失败",_loc3_.camp);
               _loc3_.currentSkill = null;
               return true;
            }
         }
         if(_loc3_.carryProp && _loc3_.carryProp.id == 853 && _loc3_.skillOfFirstSelect != null)
         {
            LogUtil("当前技能:" + _loc3_.currentSkill.name + "上场后第一个选择的技能:" + _loc3_.skillOfFirstSelect.name);
            if(_loc3_.currentSkill != _loc3_.skillOfFirstSelect)
            {
               FeatureFactor.pressureHandler(_loc4_,_loc3_);
               GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "携带限定招式头巾\n只能使用上场的第一个技能",_loc3_.camp);
               return true;
            }
         }
         if(_loc3_.currentSkill.id == 156 && FeatureFactor.insomnia(_loc3_))
         {
            GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_.nickName + "失眠" + "\n睡觉失败",_loc3_.camp);
            return true;
         }
         return false;
      }
      
      private static function isFailBecauseSeal(param1:ElfVO, param2:ElfVO) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         if(param2.status.indexOf(40) != -1)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.currentSkillVec.length)
            {
               if(param1.currentSkill.id == param2.currentSkillVec[_loc4_].id)
               {
                  FeatureFactor.pressureHandler(param2,param1);
                  _loc3_ = param2.nickName + "封印了自身\n不能使用" + param2.nickName + "学习了的技能";
                  GameFacade.getInstance().sendNotification("tell_after_self_act",_loc3_,param1.camp);
                  param1.currentSkill.continueSkillCount = 0;
                  param1.currentSkill = null;
                  return true;
               }
               _loc4_++;
            }
         }
         return false;
      }
      
      private static function palsyHandler(param1:CampBaseUI) : void
      {
         var _loc2_:ElfVO = param1.myVO;
         SkillFactor.playStatusEffect(3,param1);
         GameFacade.getInstance().sendNotification("tell_after_self_act",_loc2_.nickName + "陷入麻痹状态\n无法使用技能",_loc2_.camp);
         _loc2_.currentSkill.currentPP = _loc2_.currentSkill.currentPP + 1;
         storeHandler(param1);
         if(!FightingLogicFactor.isPlayBack)
         {
            if(_loc2_.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isPalsy = 1;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isPalsy = 1;
            }
         }
      }
      
      private static function storeHandler(param1:CampBaseUI) : Boolean
      {
         var _loc2_:* = 0;
         var _loc3_:ElfVO = param1.myVO;
         if(_loc3_.isStoreGas)
         {
            param1.elf.visible = true;
            _loc2_ = param1.myVO.status.indexOf(19);
            if(_loc2_ != -1)
            {
               param1.myVO.status.splice(_loc2_,1);
            }
            _loc2_ = param1.myVO.status.indexOf(20);
            if(_loc2_ != -1)
            {
               param1.myVO.status.splice(_loc2_,1);
               if(param1.shadow != null)
               {
                  param1.shadow.visible = true;
               }
            }
            _loc3_.isStoreGas = false;
            if(_loc3_.camp == "camp_of_player")
            {
               GameFacade.getInstance().sendNotification("update_skill_btns",_loc3_.currentSkillVec);
            }
            return true;
         }
         return false;
      }
      
      public static function statusHandlerAfterRound(param1:CampBaseUI, param2:CampBaseUI) : void
      {
         var _loc4_:* = null;
         var _loc3_:ElfVO = param1.myVO;
         if(param2 != null)
         {
            _loc4_ = param2.myVO;
         }
         if(_loc3_.isWillDie)
         {
            return;
         }
         if(_loc3_.status.indexOf(1) != -1)
         {
            burtStatus(param1);
         }
         if(_loc3_.status.indexOf(2) != -1)
         {
            iceStatus(param1);
         }
         if(_loc3_.status.indexOf(3) != -1)
         {
            palsyStatus(param1);
         }
         if(_loc3_.status.indexOf(4) != -1)
         {
            poisoningStaus(param1);
         }
         if(_loc3_.status.indexOf(5) != -1)
         {
            strengPoisoningStaus(param1);
         }
         if(_loc3_.status.indexOf(6) != -1)
         {
            sleepStatus(param1);
         }
         if(_loc3_.status.indexOf(7) != -1)
         {
            mullStatus(param1);
         }
         if(_loc3_.status.indexOf(8) != -1)
         {
            if(_loc4_ != null && _loc4_.currentHp > 0)
            {
               LogUtil("束缚" + _loc4_.currentHp);
               boundStatus(param1);
            }
         }
         if(_loc3_.status.indexOf(9) != -1)
         {
            flinchStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(10) != -1 && _loc4_ != null)
         {
            parasitic(param1,param2);
         }
         if(_loc3_.status.indexOf(11) != -1)
         {
            stoneStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(14) != -1)
         {
            fogStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(17) != -1)
         {
            tolerate(_loc3_);
         }
         if(_loc3_.status.indexOf(21) != -1)
         {
            lessHurtStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(23) != -1)
         {
            if(_loc3_.eyeCount == 0)
            {
               _loc3_.eyeCount = 1;
            }
            else
            {
               _loc3_.status.splice(_loc3_.status.indexOf(23),1);
            }
         }
         if(_loc3_.status.indexOf(24) != -1)
         {
            badSleepStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(25) != -1)
         {
            incantationStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(31) != -1)
         {
            _loc3_.status.splice(_loc3_.status.indexOf(31),1);
         }
         if(_loc3_.status.indexOf(30) != -1)
         {
            protectStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(33) != -1)
         {
            powerStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(34) != -1)
         {
            inciteStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(35) != -1)
         {
            prayStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(36) != -1)
         {
            rootedStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(37) != -1)
         {
            coatStatus(_loc3_);
         }
         if(_loc3_.status.indexOf(38) != -1)
         {
            yawnStatus(_loc3_,_loc4_);
         }
         if(_loc3_.status.indexOf(42) != -1)
         {
            blightStatus(_loc3_,_loc4_);
         }
         if(_loc3_.wallArr.length > 0)
         {
            wallStatus(_loc3_);
         }
      }
      
      private static function blightStatus(param1:ElfVO, param2:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1.blightCount >= 2)
         {
            _loc3_ = param1.status.indexOf(42);
            param1.status.splice(_loc3_,1);
            param1.blightCount = 0;
            LogUtil("对方精灵的状态" + param2.status);
            if(param2.status.indexOf(26) != -1)
            {
               Dialogue.collectDialogue(param2.nickName + "守住了破灭愿望的攻击");
            }
            else
            {
               Dialogue.collectDialogue(param2.nickName + "被无数光线攻击");
               _loc4_ = param1.blightHurt;
               if(_loc4_ == 0)
               {
                  Dialogue.collectDialogue("但没有效果");
               }
               else
               {
                  GameFacade.getInstance().sendNotification("hp_change",_loc4_,param2.camp);
               }
            }
         }
         else
         {
            §§dup(param1).blightCount++;
         }
      }
      
      private static function yawnStatus(param1:ElfVO, param2:ElfVO) : void
      {
         var _loc3_:* = 0;
         if(param1.yawnCount >= 1)
         {
            _loc3_ = param1.status.indexOf(38);
            param1.status.splice(_loc3_,1);
            param1.yawnCount = 0;
            if(param1.status.indexOf(30) != -1)
            {
               Dialogue.collectDialogue(param1.nickName + "神秘护身\n防止了哈欠睡眠");
            }
            else if(param1.status.indexOf(6) != -1)
            {
               Dialogue.collectDialogue(param1.nickName + "已经陷入睡眠状态");
            }
            else if(!PropFactor.carryClearPropHandler(param1,"睡眠",param2))
            {
               param1.status.push(6);
               Dialogue.collectDialogue(param1.nickName + "陷入睡眠状态");
            }
         }
         else
         {
            §§dup(param1).yawnCount++;
         }
      }
      
      private static function coatStatus(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(37);
         param1.status.splice(_loc2_,1);
      }
      
      private static function rootedStatus(param1:ElfVO) : void
      {
         Dialogue.collectDialogue(param1.nickName + "扎根\n回复了HP");
         var _loc2_:int = Math.round(param1.totalHp * 0.0625);
         GameFacade.getInstance().sendNotification("hp_change",-_loc2_,param1.camp);
      }
      
      private static function prayStatus(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         if(param1.prayCount >= 1)
         {
            _loc3_ = param1.status.indexOf(35);
            param1.status.splice(_loc3_,1);
            param1.prayCount = 0;
            Dialogue.collectDialogue(param1.nickName + "祈求\n回复了HP");
            _loc2_ = Math.round(param1.totalHp * 0.5);
            GameFacade.getInstance().sendNotification("hp_change",-_loc2_,param1.camp);
         }
         else
         {
            §§dup(param1).prayCount++;
         }
      }
      
      private static function inciteStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.inciteCount >= 3)
         {
            _loc2_ = param1.status.indexOf(34);
            param1.status.splice(_loc2_,1);
            param1.inciteCount = 0;
         }
         else
         {
            §§dup(param1).inciteCount++;
         }
      }
      
      private static function powerStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.powerCount >= 1)
         {
            _loc2_ = param1.status.indexOf(33);
            param1.status.splice(_loc2_,1);
            param1.powerCount = 0;
         }
         else
         {
            §§dup(param1).powerCount++;
         }
      }
      
      private static function incantationStatus(param1:ElfVO) : void
      {
         Dialogue.collectDialogue(param1.nickName + "陷入了咒语状态\n损失了HP");
         var _loc2_:int = Math.ceil(param1.totalHp / 4);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":4
         },param1.camp);
      }
      
      private static function protectStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         §§dup(param1).protectCount++;
         if(param1.protectCount > 5)
         {
            _loc2_ = param1.status.indexOf(30);
            param1.status.splice(_loc2_,1);
            Dialogue.collectDialogue(param1.nickName + "从神秘护身状态中\n恢复了");
            param1.protectCount = 0;
         }
      }
      
      private static function badSleepStatus(param1:ElfVO) : void
      {
         Dialogue.collectDialogue(param1.nickName + "陷入了噩梦状态\n损失了HP");
         var _loc2_:int = Math.round(param1.totalHp / 4);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":4
         },param1.camp);
      }
      
      private static function wallStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.wallArr.length)
         {
            param1.wallArr[_loc2_] = param1.wallArr[_loc2_] + 1;
            if(param1.wallArr[_loc2_] > 3)
            {
               param1.wallArr.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      private static function lessHurtStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         §§dup(param1).lessHurtCount++;
         if(param1.lessHurtCount > 5)
         {
            _loc2_ = param1.status.indexOf(21);
            param1.status.splice(_loc2_,1);
            Dialogue.collectDialogue(param1.nickName + "从减半反射状态中\n恢复了");
            param1.lessHurtCount = 0;
         }
      }
      
      private static function changeStatus(param1:ElfVO) : void
      {
      }
      
      private static function tolerate(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         §§dup(param1).tolerCount++;
         if(param1.tolerCount >= 2)
         {
            _loc2_ = param1.status.indexOf(17);
            param1.status.splice(_loc2_,1);
            param1.tolerCount = 0;
            param1.isReleaseAnger = true;
         }
      }
      
      private static function fogStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.fogCount >= 5)
         {
            _loc2_ = param1.status.indexOf(14);
            param1.status.splice(_loc2_,1);
            Dialogue.collectDialogue(param1.nickName + "从白雾状态中\n恢复了");
            param1.fogCount = 0;
         }
         §§dup(param1).fogCount++;
      }
      
      private static function stoneStatus(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.stoneCount >= 4)
         {
            _loc2_ = param1.status.indexOf(11);
            param1.status.splice(_loc2_,1);
            Dialogue.collectDialogue(param1.nickName + "从石化状态中\n恢复了");
            param1.stoneCount = 0;
            param1.skillBeforeStrone = null;
         }
         §§dup(param1).stoneCount++;
      }
      
      private static function parasitic(param1:CampBaseUI, param2:CampBaseUI) : void
      {
         var _loc3_:int = Math.round(param1.myVO.totalHp / 8);
         if(_loc3_ > param1.myVO.currentHp)
         {
            _loc3_ = param1.myVO.currentHp;
         }
         if(_loc3_ == 0)
         {
            return;
         }
         Dialogue.collectDialogue(param1.myVO.nickName + "陷入了寄生状态\n损失了HP");
         GameFacade.getInstance().sendNotification("hp_change",_loc3_,param1.myVO.camp);
         Dialogue.collectDialogue(param2.myVO.nickName + "吸收了" + param1.myVO.nickName + "的HP");
         Starling.juggler.delayCall(getHp,Config.dialogueDelay,_loc3_,param2.myVO);
      }
      
      private static function getHp(param1:int, param2:ElfVO) : void
      {
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":-param1,
            "status":100
         },param2.camp);
      }
      
      private static function flinchStatus(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(9);
         param1.status.splice(_loc2_,1);
      }
      
      private static function boundStatus(param1:CampBaseUI) : void
      {
         var _loc3_:ElfVO = param1.myVO;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(_loc3_.camp == "camp_of_player")
            {
               if((FightingConfig.selfOrder.clearStatus as Array).indexOf(8) != -1)
               {
                  clearBound(_loc3_);
                  return;
               }
            }
            else if(FightingConfig.otherOrder != null && FightingConfig.otherOrder.hasOwnProperty("clearStatus"))
            {
               if((FightingConfig.otherOrder.clearStatus as Array).indexOf(8) != -1)
               {
                  clearBound(_loc3_);
                  return;
               }
            }
         }
         else if(_loc3_.boundCount > Math.round(Math.random() * 1) + 5)
         {
            clearBound(_loc3_);
            return;
         }
         Dialogue.collectDialogue(_loc3_.nickName + "陷入了束缚状态\n损失了HP");
         var _loc2_:int = Math.round(_loc3_.totalHp / 8);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":8
         },_loc3_.camp);
         _loc3_.boundCount = §§dup(_loc3_).boundCount + 1;
      }
      
      private static function clearBound(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(8);
         param1.status.splice(_loc2_,1);
         Dialogue.collectDialogue(param1.nickName + "从束缚状态中\n恢复了");
         param1.boundCount = 0;
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].clearStatus.push(8);
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].clearStatus.push(8);
            }
         }
      }
      
      private static function mullStatus(param1:CampBaseUI) : void
      {
         var _loc3_:* = 0;
         var _loc2_:ElfVO = param1.myVO;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            §§dup(param1.myVO).mullCount++;
            if(_loc2_.camp == "camp_of_player")
            {
               if((FightingConfig.selfOrder.clearStatus as Array).indexOf(7) != -1)
               {
                  clearMull(_loc2_);
               }
            }
            else
            {
               if(FightingConfig.otherOrder == null)
               {
                  return;
               }
               if(FightingConfig.otherOrder.hasOwnProperty("clearStatus"))
               {
                  if((FightingConfig.otherOrder.clearStatus as Array).indexOf(7) != -1)
                  {
                     clearMull(_loc2_);
                  }
               }
            }
         }
         else
         {
            _loc3_ = Math.round(Math.random() * 3) + 1;
            LogUtil("随机数" + _loc3_);
            §§dup(param1.myVO).mullCount++;
            LogUtil("混乱计数" + param1.myVO.mullCount);
            if(param1.myVO.mullCount > _loc3_)
            {
               LogUtil("解除混乱啦大哥");
               clearMull(_loc2_);
            }
         }
      }
      
      private static function clearMull(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(7);
         param1.status.splice(_loc2_,1);
         Dialogue.collectDialogue(param1.nickName + "从混乱状态中\n恢复了");
         param1.mullCount = 0;
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].clearStatus.push(7);
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].clearStatus.push(7);
            }
         }
      }
      
      private static function sleepStatus(param1:CampBaseUI) : void
      {
         var _loc2_:ElfVO = param1.myVO;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            param1.myVO.sleepCount = param1.myVO.sleepCount + 1;
            if(_loc2_.camp == "camp_of_player")
            {
               if((FightingConfig.selfOrder.clearStatus as Array).indexOf(6) != -1)
               {
                  clearSleep(_loc2_);
               }
            }
            else
            {
               if(FightingConfig.otherOrder == null)
               {
                  return;
               }
               if(FightingConfig.otherOrder.hasOwnProperty("clearStatus"))
               {
                  if((FightingConfig.otherOrder.clearStatus as Array).indexOf(6) != -1)
                  {
                     clearSleep(_loc2_);
                  }
               }
            }
         }
         else
         {
            param1.myVO.sleepCount = param1.myVO.sleepCount + 1;
            if(param1.myVO.sleepCount > Math.round(Math.random() * 2) + 2)
            {
               clearSleep(_loc2_);
            }
         }
      }
      
      private static function clearSleep(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(6);
         param1.status.splice(_loc2_,1);
         _loc2_ = param1.status.indexOf(24);
         if(_loc2_ != -1)
         {
            param1.status.splice(_loc2_,1);
         }
         Dialogue.collectDialogue(param1.nickName + "从睡眠状态中\n恢复了");
         param1.sleepCount = "0";
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].clearStatus.push(6);
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].clearStatus.push(6);
            }
         }
      }
      
      private static function strengPoisoningStaus(param1:CampBaseUI) : void
      {
         Dialogue.collectDialogue(param1.myVO.nickName + "陷入了猛毒状态\n损失了HP");
         var _loc2_:int = Math.round(param1.myVO.totalHp * (1 + param1.myVO.hurtNum) / 16);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":5
         },param1.myVO.camp);
         §§dup(param1.myVO).hurtNum++;
      }
      
      private static function poisoningStaus(param1:CampBaseUI) : void
      {
         Dialogue.collectDialogue(param1.myVO.nickName + "陷入了中毒状态\n损失了HP");
         var _loc2_:int = Math.round(param1.myVO.totalHp / 8);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":4
         },param1.myVO.camp);
      }
      
      private static function palsyStatus(param1:CampBaseUI) : void
      {
         param1.myVO.currentSpeed = param1.myVO.speed * 0.25;
         Dialogue.collectDialogue(param1.myVO.nickName + "陷入了麻痹状态\n速度下降了");
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":0,
            "status":3
         },param1.myVO.camp);
      }
      
      private static function iceStatus(param1:CampBaseUI) : void
      {
         var _loc2_:ElfVO = param1.myVO;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(_loc2_.camp == "camp_of_player")
            {
               if((FightingConfig.selfOrder.clearStatus as Array).indexOf(2) != -1)
               {
                  clearIce(_loc2_);
               }
            }
            else
            {
               if(FightingConfig.otherOrder == null)
               {
                  return;
               }
               if(FightingConfig.otherOrder.hasOwnProperty("clearStatus"))
               {
                  if((FightingConfig.otherOrder.clearStatus as Array).indexOf(2) != -1)
                  {
                     clearIce(_loc2_);
                  }
               }
            }
         }
         else if(Math.random() * 4 < 1)
         {
            clearIce(_loc2_);
         }
      }
      
      private static function clearIce(param1:ElfVO) : void
      {
         var _loc2_:int = param1.status.indexOf(2);
         param1.status.splice(_loc2_,1);
         Dialogue.collectDialogue(param1.nickName + "从冰冻状态中\n恢复了");
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].clearStatus.push(2);
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].clearStatus.push(2);
            }
         }
      }
      
      private static function burtStatus(param1:CampBaseUI) : void
      {
         Dialogue.collectDialogue(param1.myVO.nickName + "陷入了灼伤状态\n损失了HP");
         var _loc2_:int = Math.round(param1.myVO.totalHp / 8);
         GameFacade.getInstance().sendNotification("hp_change",{
            "lessNum":_loc2_,
            "status":1
         },param1.myVO.camp);
      }
      
      public static function get status() : Array
      {
         return statusInfo;
      }
      
      private function grubStatus(param1:ElfVO) : void
      {
      }
      
      private function flyStaus(param1:ElfVO) : void
      {
      }
      
      private function angerStatus(param1:ElfVO) : void
      {
      }
      
      private function narrowStatus(param1:ElfVO) : void
      {
      }
      
      private function avatarsStatus(param1:ElfVO) : void
      {
      }
      
      private function collectGasStatus(param1:ElfVO) : void
      {
      }
   }
}
