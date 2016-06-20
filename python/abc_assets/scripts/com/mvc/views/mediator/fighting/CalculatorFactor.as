package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.mainCity.backPack.PropFactor;
   import com.common.util.xmlVOHandler.GetElfQuality;
   import com.common.events.EventCenter;
   import com.common.themes.Tips;
   import extend.SoundEvent;
   import com.mvc.GameFacade;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.mvc.views.uis.mainCity.backPack.NewSkillAlert;
   import com.common.util.xmlVOHandler.GetLvExp;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.controllers.LoadPageCmd;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import lzm.util.HttpClient;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.kingKwan.KingKwanUI;
   import com.mvc.views.uis.mainCity.elfSeries.ElfSeriesUI;
   import com.mvc.views.uis.mainCity.trial.TrialUI;
   
   public class CalculatorFactor
   {
      
      private static var mageArr:Array = [0.15,0.26,0.38,0.51,0.65,0.8,1];
      
      private static var nomalArr:Array = [0,0.55,0.62,0.72,0.85,1];
      
      public static var isLearnSkill:Boolean;
      
      public static var natureArr:Array = ["一般","格斗","飞行","毒","地上","岩石","虫","幽灵","钢","火","水","草","电","超能力","冰","龙","恶","妖精"];
      
      private static var natureInteract:Array = [[1,1,1,1,1,0.5,1,0,0.5,1,1,1,1,1,1,1,1,1],[2,1,0.5,0.5,1,2,0.5,0,2,1,1,1,1,0.5,2,1,2,0.5],[1,2,1,1,1,0.5,2,1,0.5,1,1,2,0.5,1,1,1,1,1],[1,1,1,0.5,0.5,0.5,1,0.5,0,1,1,2,1,1,1,1,1,2],[1,1,0,2,1,2,0.5,1,2,2,1,0.5,2,1,1,1,1,1],[1,0.5,2,1,0.5,1,2,1,0.5,2,1,1,1,1,2,1,1,1],[1,0.5,0.5,0.5,1,1,1,0.5,0.5,0.5,1,2,1,2,1,1,2,0.5],[0,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,0.5,1],[1,1,1,1,1,2,1,1,0.5,0.5,0.5,1,0.5,1,2,1,1,2],[1,1,1,1,1,0.5,2,1,2,0.5,0.5,2,1,1,2,0.5,1,1],[1,1,1,1,2,2,1,1,1,2,0.5,0.5,1,1,1,0.5,1,1],[1,1,0.5,0.5,2,2,0.5,1,0.5,0.5,2,0.5,1,1,1,0.5,1,1],[1,1,2,1,0,1,1,1,1,1,2,0.5,0.5,1,1,0.5,1,1],[1,2,1,2,1,1,1,1,0.5,1,1,1,1,0.5,1,1,0,1],[1,1,2,1,2,1,1,1,0.5,0.5,0.5,2,1,1,0.5,2,1,1],[1,1,1,1,1,1,1,1,0.5,1,1,1,1,1,1,2,1,0],[1,0.5,1,1,1,1,1,2,1,1,1,1,1,2,1,1,0.5,0.5],[1,2,1,0.5,1,1,1,1,0.5,0.5,1,1,1,1,1,2,2,1]];
      
      public static var natureColor:Array = [11053176,12595240,11047152,10502304,14729320,12099640,11057184,7362712,12105936,15761456,6852848,7915600,16306224,16275592,10016984,7354616,7362632,15636908];
      
      private static var tempElf:ElfVO;
      
      private static var tempSkill:SkillVO;
      
      public static var learnByLvUp:Boolean;
      
      private static var newSkillVec:Vector.<SkillVO> = new Vector.<SkillVO>([]);
      
      private static var isHasNewSkill:Boolean;
       
      public function CalculatorFactor()
      {
         super();
      }
      
      public static function calculatorElf(param1:ElfVO) : void
      {
         var _loc6_:* = NaN;
         var _loc2_:* = NaN;
         var _loc3_:* = null;
         if(param1.status.indexOf(18) != -1)
         {
            return;
         }
         var _loc5_:* = 0;
         if(param1.totalHp > 0)
         {
            _loc5_ = param1.totalHp;
         }
         var _loc4_:* = false;
         if(param1.camp == "camp_of_player")
         {
            _loc4_ = false;
         }
         else
         {
            _loc4_ = true;
         }
         if(_loc4_)
         {
            if(NPCVO.name != null)
            {
               _loc6_ = NPCVO.unionAttackAdd;
               _loc2_ = NPCVO.unionDefenseAdd;
            }
            else
            {
               _loc6_ = 1.0;
               _loc2_ = 1.0;
            }
         }
         else
         {
            _loc6_ = UnionPro.attackMark;
            _loc2_ = UnionPro.defenseMark;
         }
         LogUtil("unionDefenseAdd =",_loc2_,UnionPro.defenseMark,"unionAttackAdd=",_loc6_,UnionPro.attackMark);
         LogUtil("elfVo.camp = ",param1.camp," ConfigConst.CAMP_OF_PLAYER=","camp_of_player","isOther=",_loc4_);
         LogUtil("unionAttackAdd=" + _loc6_,"unionDefenseAdd=" + _loc2_,"individual = " + param1.individual + ", speciesHp=" + param1.speciesHp + ", starts=" + param1.starts + ", brokenLv=" + param1.brokenLv + ", lv=" + param1.lv + ", characterCorrect=" + param1.characterCorrect);
         param1.totalHp = CalculatorFactor.calHpAbility(param1.individual[0],param1.speciesHp,param1.starts,param1.brokenLv,param1.lv,param1.elfId);
         param1.attack = _loc6_ * CalculatorFactor.calOtherAbility(param1.individual[1],param1.speciesAttack,param1.starts,param1.brokenLv,param1.lv,param1.characterCorrect[0],param1.elfId);
         param1.defense = _loc2_ * CalculatorFactor.calOtherAbility(param1.individual[2],param1.speciesDefense,param1.starts,param1.brokenLv,param1.lv,param1.characterCorrect[1],param1.elfId);
         param1.super_attack = _loc6_ * CalculatorFactor.calOtherAbility(param1.individual[3],param1.speciesSuper_attack,param1.starts,param1.brokenLv,param1.lv,param1.characterCorrect[2],param1.elfId);
         param1.super_defense = _loc2_ * CalculatorFactor.calOtherAbility(param1.individual[4],param1.speciesSpuer_defense,param1.starts,param1.brokenLv,param1.lv,param1.characterCorrect[3],param1.elfId);
         param1.speed = CalculatorFactor.calOtherAbility(param1.individual[5],param1.speciesSpeed,param1.starts,param1.brokenLv,param1.lv,param1.characterCorrect[4],param1.elfId);
         LogUtil("elfVo.currentHp====",param1.currentHp,"elfVo.totalHp====",param1.totalHp,"____tempTotalHp==",_loc5_ + "攻击加成" + _loc6_ + "防御加成" + _loc2_ + "能力等级" + param1.ablilityAddLv);
         if(param1.elfId > 20000)
         {
            LogUtil(param1.evoFrom," mega精灵增幅前",param1.totalHp,param1.attack,param1.defense,param1.super_attack,param1.super_defense,param1.speed);
            _loc3_ = GetElfFactor.getElfVO(param1.evoFrom,false);
            param1.totalHp = param1.totalHp + CalculatorFactor.calHpAbility(30,_loc3_.speciesHp,5,13,70,_loc3_.elfId);
            param1.attack = param1.attack + CalculatorFactor.calOtherAbility(30,_loc3_.speciesAttack,5,13,70,param1.characterCorrect[0],_loc3_.elfId);
            param1.defense = param1.defense + CalculatorFactor.calOtherAbility(30,_loc3_.speciesDefense,5,13,70,param1.characterCorrect[1],_loc3_.elfId);
            param1.super_attack = param1.super_attack + CalculatorFactor.calOtherAbility(30,_loc3_.speciesSuper_attack,5,13,70,param1.characterCorrect[2],_loc3_.elfId);
            param1.super_defense = param1.super_defense + CalculatorFactor.calOtherAbility(30,_loc3_.speciesSpuer_defense,5,13,70,param1.characterCorrect[3],_loc3_.elfId);
            param1.speed = param1.speed + CalculatorFactor.calOtherAbility(30,_loc3_.speciesSpeed,5,13,70,param1.characterCorrect[4],_loc3_.elfId);
            _loc3_ = null;
            LogUtil(param1.evoFrom," mega精灵增幅后",param1.totalHp,param1.attack,param1.defense,param1.super_attack,param1.super_defense,param1.speed);
         }
         if(param1.currentHp < param1.totalHp && _loc5_ > 0)
         {
            if(_loc5_ > param1.totalHp)
            {
               _loc5_ = param1.totalHp;
            }
            param1.currentHp = param1.currentHp + (param1.totalHp - _loc5_);
         }
         if(param1.currentHp >= param1.totalHp)
         {
            param1.currentHp = param1.totalHp;
         }
         if(param1.currentHp == "-1")
         {
            param1.currentHp = param1.totalHp;
         }
         correctAblilityLv(param1);
         CElfOfFighting(param1);
         param1.nextLvExp = calculatorLvNeedExp(param1,param1.lv + 1);
         getCurrentSkill(param1);
         LogUtil(param1.nickName + "的各项属性：攻击" + param1.attack + "特攻" + param1.super_attack + "防御" + param1.defense + "特防" + param1.super_defense + "速度" + param1.speed);
         return;
         §§push(LogUtil(param1.nickName + "的当前hp" + param1.currentHp));
      }
      
      private static function calHpAbility(param1:Number, param2:int, param3:int, param4:int, param5:int, param6:int) : int
      {
         var _loc10_:* = NaN;
         var _loc9_:* = NaN;
         var _loc7_:* = 0;
         var _loc8_:* = NaN;
         if(param6 > 20000)
         {
            _loc9_ = 2 * param2 * mageArr[param3];
            _loc8_ = 2 * param2 * 1 / 2;
            _loc10_ = (63.75 + _loc8_) / 13 * param4;
            _loc7_ = Math.round((param1 + _loc9_ * 0.5 + _loc10_) * param5 * 24 / 100 + 240 + param5 * 24);
         }
         else
         {
            _loc9_ = 2 * param2 * nomalArr[param3];
            _loc10_ = param4 * 255 / 13 / 4;
            _loc7_ = Math.round((param1 + _loc9_ + _loc10_) * param5 * 24 / 100 + 240 + param5 * 24);
         }
         LogUtil("精灵等级" + param5 + "突破" + _loc10_ + "种族值" + param2 + "个体" + param1 + "最终值" + _loc7_);
         return _loc7_;
      }
      
      private static function calOtherAbility(param1:Number, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:int) : int
      {
         var _loc11_:* = NaN;
         var _loc10_:* = NaN;
         var _loc8_:* = 0;
         var _loc9_:* = NaN;
         if(param7 > 20000)
         {
            _loc10_ = 2 * param2 * mageArr[param3];
            _loc9_ = 2 * param2 * 1 / 2;
            _loc11_ = (63.75 + _loc9_) / 13 * param4;
            _loc8_ = Math.round(((param1 + _loc10_ * 0.5 + _loc11_) * param5 * 24 / 100 + 120) * param6);
         }
         else
         {
            _loc10_ = 2 * param2 * nomalArr[param3];
            _loc11_ = param4 * 255 / 13 / 4;
            _loc8_ = Math.round(((param1 + _loc10_ + _loc11_) * param5 * 24 / 100 + 120) * param6);
         }
         LogUtil("精灵等级" + param5 + "突破" + _loc11_ + "种族值" + param2 + "个体" + param1 + "性格修正" + param6 + "最终值" + _loc8_);
         return _loc8_;
      }
      
      private static function correctAblilityLv(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.ablilityAddLv.length)
         {
            if(param1.ablilityAddLv[_loc2_] > 6)
            {
               param1.ablilityAddLv[_loc2_] = 6;
            }
            if(param1.ablilityAddLv[_loc2_] < -6)
            {
               param1.ablilityAddLv[_loc2_] = -6;
            }
            _loc2_++;
         }
      }
      
      private static function getCurrentSkill(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         if(param1.currentSkillVec.length == 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.totalSkillVec.length)
            {
               if(param1.totalSkillVec[_loc2_].lvNeed <= param1.lv)
               {
                  param1.currentSkillVec.push(param1.totalSkillVec[_loc2_]);
                  while(param1.currentSkillVec.length > 4)
                  {
                     param1.currentSkillVec.splice(0,1);
                  }
               }
               _loc2_++;
            }
         }
      }
      
      private static function CElfOfFighting(param1:ElfVO) : void
      {
         var _loc2_:* = false;
         var _loc3_:Array = calculatorCorrectDouble(param1.ablilityAddLv);
         param1.attack = Math.round(param1.attack * _loc3_[0]);
         param1.defense = Math.round(param1.defense * _loc3_[1]);
         param1.super_attack = Math.round(param1.super_attack * _loc3_[2]);
         param1.super_defense = Math.round(param1.super_defense * _loc3_[3]);
         param1.speed = Math.round(param1.speed * _loc3_[4]);
         if(param1.status.indexOf(39) == -1 && param1.carryProp != null)
         {
            LogUtil(param1.carryProp.exclusiveElf + "携带道具名" + param1.carryProp.name);
            if(param1.carryProp.exclusiveElf.length > 0)
            {
               _loc2_ = PropFactor.isExclusiveElf(param1);
               LogUtil("是否专属" + _loc2_);
               if(_loc2_)
               {
                  PropFactor.effectForAblility(param1);
               }
            }
            else
            {
               PropFactor.effectForAblility(param1);
            }
         }
         FeatureFactor.firmnessHandler(param1);
         param1.currentSpeed = param1.speed;
      }
      
      public static function calculatorElfLv(param1:ElfVO, param2:int = 0) : void
      {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = 0;
         if(param2 != 0)
         {
            _loc6_ = param2;
         }
         else
         {
            _loc6_ = GetElfQuality.GetelfMaxLv(param1);
         }
         var _loc4_:Number = CalculatorFactor.calculatorLvNeedExp(param1,_loc6_ + 1) - 1;
         if(param1.currentExp > _loc4_)
         {
            param1.currentExp = _loc4_;
         }
         newSkillVec = Vector.<SkillVO>([]);
         param1.nextLvExp = CalculatorFactor.calculatorLvNeedExp(param1,param1.lv + 1);
         while(param1.currentExp >= param1.nextLvExp)
         {
            param1.lv = param1.lv + 1;
            if(param1.lv > 100)
            {
               param1.lv = "100";
               param1.currentExp = calculatorLvNeedExp(param1,100);
               return;
            }
            _loc3_ = checkIsCanLearnNewSkill(param1);
            if(_loc3_ != null)
            {
               newSkillVec.push(_loc3_);
            }
            param1.nextLvExp = calculatorLvNeedExp(param1,param1.lv + 1);
         }
         if(newSkillVec.length > 0)
         {
            isHasNewSkill = true;
         }
         else
         {
            isHasNewSkill = false;
         }
         _loc5_ = 0;
         while(_loc5_ < newSkillVec.length)
         {
            LogUtil("新的技能======",newSkillVec[_loc5_].name);
            _loc5_++;
         }
      }
      
      public static function learnSkillHandler(param1:ElfVO) : Boolean
      {
         var _loc2_:* = false;
         if(newSkillVec.length > 0)
         {
            _loc2_ = true;
            CalculatorFactor.isLearnSkill = true;
            learnNewSkillHandler(param1,newSkillVec[0]);
         }
         else if(isHasNewSkill)
         {
            EventCenter.dispatchEvent("LEARN_NEWSKILL_OVER");
            CalculatorFactor.isLearnSkill = false;
         }
         return _loc2_;
      }
      
      public static function learnNewSkillHandler(param1:ElfVO, param2:SkillVO) : void
      {
         elfVo = param1;
         newSkill = param2;
         newSkillVec.splice(0,1);
         var i:int = 0;
         while(i < elfVo.currentSkillVec.length)
         {
            if(newSkill.id == elfVo.currentSkillVec[i].id)
            {
               Tips.show("【" + elfVo.name + "】已经学会了" + newSkill.name);
               learnSkillHandler(elfVo);
               return;
            }
            i = i + 1;
         }
         LogUtil("学习技能名字" + newSkill.name);
         if(elfVo.currentSkillVec.length < 4)
         {
            var continueLearnSkill:Function = function():void
            {
               Config.starling.root.touchable = true;
               elfVo.currentSkillVec.push(newSkill);
               Tips.show(elfVo.nickName + "学习了新技能" + newSkill.name);
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
               learnSkillHandler(elfVo);
            };
            Config.starling.root.touchable = false;
            (GameFacade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3013(elfVo.id,newSkill.id,elfVo.currentSkillVec.length,null,0,continueLearnSkill);
         }
         else
         {
            LogUtil("升级学习新技能需要弹出替换弹窗。。。。。：" + newSkill.name);
            tempElf = elfVo;
            tempSkill = newSkill;
            learnByLvUp = true;
            NewSkillAlert.getInstance().show(tempElf,newSkill);
         }
      }
      
      public static function checkIsCanLearnNewSkill(param1:ElfVO) : SkillVO
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.totalSkillVec.length)
         {
            if(param1.totalSkillVec[_loc2_].lvNeed == param1.lv)
            {
               return param1.totalSkillVec[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function calculatorLvNeedExp(param1:ElfVO, param2:int) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < param2 - 1)
         {
            _loc3_ = _loc3_ + GetLvExp.elfGradeExp[_loc4_];
            _loc4_++;
         }
         if(param1.elfId > 20000)
         {
            return Math.round(_loc3_ * 5);
         }
         switch(param1.expCurve)
         {
            case 0:
               return Math.round(_loc3_ * 0.85);
            case 1:
               return Math.round(_loc3_ * 0.9);
            case 2:
               return Math.round(_loc3_);
            case 3:
               return Math.round(_loc3_ * 1.05);
            case 4:
               return Math.round(_loc3_ * 1.1);
            case 5:
               return Math.round(_loc3_ * 1.2);
            default:
               return 0;
         }
      }
      
      public static function hurtCalculator(param1:ElfVO, param2:ElfVO, param3:SkillVO) : int
      {
         var _loc15_:* = false;
         var _loc10_:* = NaN;
         var _loc9_:* = 0;
         calculatorElf(param1);
         calculatorElf(param2);
         param2.lastHurtOfPhysics = 0;
         param2.lastHurtOfSpecial = 0;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               if(FightingConfig.selfOrder.isFocusHit == 1)
               {
                  _loc15_ = true;
               }
               else
               {
                  _loc15_ = false;
               }
               _loc10_ = FightingConfig.selfOrder.randomNum;
               LogUtil("我方战斗信息" + JSON.stringify(FightingConfig.selfOrder));
            }
            else
            {
               if(FightingConfig.otherOrder.hasOwnProperty("isFocusHit") && FightingConfig.otherOrder.isFocusHit == 1)
               {
                  _loc15_ = true;
               }
               else
               {
                  _loc15_ = false;
               }
               _loc10_ = FightingConfig.otherOrder.randomNum;
               LogUtil("对方战斗信息" + JSON.stringify(FightingConfig.otherOrder));
            }
         }
         else
         {
            _loc15_ = isFocusHitHandler(param1,param3);
            if(_loc15_)
            {
               Dialogue.collectDialogue("会心一击");
            }
            _loc10_ = Math.random() * 0.25 + 0.85;
            if(param1.camp == "camp_of_player")
            {
               if(FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].randomNum != 0)
               {
                  _loc10_ = FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].randomNum;
               }
            }
            else if(FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].randomNum != 0)
            {
               _loc10_ = FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].randomNum;
            }
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               if(_loc15_)
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isFocusHit = 1;
               }
               else
               {
                  FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isFocusHit = 0;
               }
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].randomNum = _loc10_;
            }
            else
            {
               if(_loc15_)
               {
                  FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isFocusHit = 1;
               }
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].randomNum = _loc10_;
            }
         }
         FightingConfig.attackEffect = 1;
         var _loc11_:Number = calculatorNatureAdd(param3,param2);
         if(_loc11_ == 0)
         {
            return 0;
         }
         if(FeatureFactor.isFloatImmunity(param2,param1))
         {
            return 0;
         }
         if(param3.name == "打鼾" && param2.status.indexOf(6) != -1)
         {
            return 0;
         }
         if(param3.id == 283)
         {
            return param2.currentHp - param1.currentHp;
         }
         if(param2.status.indexOf(26) != -1)
         {
            return 0;
         }
         if(param3.name == "表面涂层")
         {
            return coatHurt(param1);
         }
         if(param3.name == "下踢")
         {
            param3.power = kickSkillHurt(param2);
         }
         if(param3.name == "手足慌乱" || param3.name == "起死回生")
         {
            param3.power = skillPowerByHp(param1);
         }
         if(param3.id == 205 || param3.id == 301)
         {
            param3.power = skillPowerByCount(param1);
         }
         if(param1.status.indexOf(29) != -1)
         {
            LogUtil("连切前威力" + param3.power);
            param3.power = param3.power * 2 > 160?"160":param3.power * 2;
            LogUtil("连切后威力" + param3.power);
         }
         if(param3.name == "水溅跃")
         {
            return 0;
         }
         if(param3.name == "食梦" && param2.status.indexOf(6) == -1)
         {
            return 0;
         }
         if(_loc11_ >= 2 && param3.id != 353)
         {
            FightingConfig.attackEffect = 2;
            Dialogue.collectDialogue("效果很好");
         }
         else if(_loc11_ <= 0.5 && param3.id != 353)
         {
            FightingConfig.attackEffect = 3;
            Dialogue.collectDialogue("不是很有效");
         }
         if(param3.isKillArray[0] == 1)
         {
            return onceKillHurt(param1,param3,param2);
         }
         if(param3.hurtNumFix[0] == 1)
         {
            return fixHurt(param1,param3,param2,_loc11_);
         }
         if(param3.id == 255)
         {
            if(param1.storeNum == "0")
            {
               return 0;
            }
            param3.power = param1.storeNum * 100;
            param1.ablilityAddLv[1] = 0;
            param1.ablilityAddLv[3] = 0;
            param1.storeNum = "0";
            LogUtil(param1.ablilityAddLv + "喷出技能威力" + param3.power);
         }
         var _loc5_:Number = powerAdd(param1,param3);
         var _loc7_:Number = param1.attack;
         var _loc12_:Number = param2.defense;
         if(param3.sort == "特殊")
         {
            _loc7_ = param1.super_attack;
            _loc12_ = param2.super_defense;
         }
         var _loc13_:* = 1.0;
         if(_loc15_)
         {
            _loc13_ = 2.0;
         }
         else if(param2.status.indexOf(21) != -1 && param3.sort == "物理")
         {
            if(param3.id == 280)
            {
               Dialogue.collectDialogue("劈瓦击碎减半反射");
               param2.status.splice(param2.status.indexOf(21),1);
            }
            else
            {
               _loc7_ = _loc7_ * 0.25;
               _loc12_ = _loc12_ * 0.5;
            }
         }
         var _loc4_:* = 1.0;
         var _loc8_:Number = _loc5_ * _loc11_ * _loc13_ * _loc4_ * _loc10_;
         LogUtil("focusHit:" + _loc13_ + "otherAdd:" + _loc4_ + "randomNum:" + _loc10_);
         LogUtil("技术员特性前威力" + param1.currentSkill.power);
         var _loc6_:int = FeatureFactor.technician(param1);
         LogUtil("技术员特性后威力" + _loc6_);
         var _loc14_:int = _loc6_ * PropFactor.getSkillPower(param1.carryProp,param3,param1);
         if(param3.id == 284 || param3.id == 323)
         {
            _loc14_ = 150 * param1.currentHp / param1.totalHp;
            LogUtil("喷火或喷水的威力" + _loc14_);
         }
         if(isPowerDouble(param3,param1,param2))
         {
            Dialogue.collectDialogue("技能威力翻倍");
            _loc14_ = _loc14_ + param3.power;
         }
         LogUtil(_loc14_ + "：技能威力：" + param3.power);
         var _loc16_:Number = ((2 * param1.lv + 10) / 250 * _loc7_ / _loc12_ * _loc14_ + 2) * _loc8_ * 24;
         if(param1.status.indexOf(1) != -1 && param3.sort == "物理")
         {
            Dialogue.collectDialogue(param1.nickName + "处于烧伤状态\n攻击力下降");
            _loc16_ = _loc16_ / 2;
         }
         if(param3.name == "践踏" && param2.status.indexOf(15) != -1)
         {
            _loc16_ = _loc16_ * 2;
         }
         if(param3.name == "烈暴风" && param2.status.indexOf(19) != -1)
         {
            _loc16_ = _loc16_ * 2;
         }
         if(param3.name == "地震" && param2.status.indexOf(20) != -1)
         {
            _loc16_ = _loc16_ * 2;
         }
         if(param3.sort == "特殊" && param2.wallArr.length > 0)
         {
            _loc16_ = _loc16_ / (2 * param2.wallArr.length);
         }
         if(param3.id == 280 && param2.wallArr.length > 0)
         {
            Dialogue.collectDialogue("劈瓦击碎光墙");
            param2.wallArr = [];
         }
         if(_loc16_ > param2.currentHp)
         {
            _loc16_ = param2.currentHp;
         }
         LogUtil("属性加成" + _loc11_);
         LogUtil("hurtNum" + _loc16_ + "lv:" + param1.lv + "attackNum" + _loc7_ + "defenseNum" + _loc12_ + "totalAdd" + _loc8_ + "power" + _loc14_);
         if(param3.sort == "特殊")
         {
            param2.lastHurtOfSpecial = Math.round(_loc16_);
         }
         else
         {
            param2.lastHurtOfPhysics = Math.round(_loc16_);
         }
         if(param3.name == "高速回转")
         {
            if(param1.camp == "camp_of_player")
            {
               CampOfPlayerMedia._currentCamp.landStar = 0;
            }
            else
            {
               CampOfComputerMedia._currentCamp.landStar = 0;
            }
            if(param1.status.indexOf(8) != -1)
            {
               param1.status.splice(param1.status.indexOf(8),1);
            }
            if(param1.status.indexOf(10) != -1)
            {
               param1.status.splice(param1.status.indexOf(10),1);
            }
         }
         if(LoadPageCmd.lastPage is CityMapUI)
         {
            if(param1.camp == "camp_of_player" && param1.lv < 25)
            {
               _loc9_ = param1.lv;
               _loc16_ = _loc16_ * (-2.0E-4 * _loc9_ * _loc9_ - 0.0595 * _loc9_ + 2.71);
            }
            LogUtil("精灵加成");
         }
         if(param3.name == "刀背击打")
         {
            if(_loc16_ > param2.currentHp - 1)
            {
               _loc16_ = param2.currentHp - 1;
            }
         }
         if(FeatureFactor.hugePower(param1))
         {
            LogUtil("大力士特性前伤害" + _loc16_);
            _loc16_ = _loc16_ * 2;
            LogUtil("大力士特性后伤害" + _loc16_);
         }
         return Math.round(_loc16_);
      }
      
      private static function isPowerDouble(param1:SkillVO, param2:ElfVO, param3:ElfVO) : Boolean
      {
         if(param1.id == 263 && (param2.status.indexOf(4) != -1 || param2.status.indexOf(1) != -1 || param2.status.indexOf(3) != -1))
         {
            return true;
         }
         if(param1.id == 265 && param3.status.indexOf(3) != -1)
         {
            param3.status.splice(param3.status.indexOf(3),1);
            return true;
         }
         if(param1.id == 279)
         {
            if(param2.camp == "camp_of_player")
            {
               if(!FightingLogicFactor.isFirstOfOurs && (param2.lastHurtOfPhysics > 0 || param2.lastHurtOfSpecial > 0))
               {
                  return true;
               }
            }
            else if(FightingLogicFactor.isFirstOfOurs && (param2.lastHurtOfPhysics > 0 || param2.lastHurtOfSpecial > 0))
            {
               return true;
            }
         }
         if(param1.property == "电" && param2.status.indexOf(33) != -1)
         {
            param2.status.splice(param2.status.indexOf(33),1);
            return true;
         }
         return false;
      }
      
      private static function powerAdd(param1:ElfVO, param2:SkillVO) : Number
      {
         var _loc3_:* = 1.0;
         if(param1.nature.indexOf(param2.property) != -1)
         {
            _loc3_ = 1.5;
         }
         return _loc3_;
      }
      
      private static function coatHurt(param1:ElfVO) : int
      {
         if(param1.camp == "camp_of_player")
         {
            if(FightingLogicFactor.isFirstOfOurs)
            {
               return 0;
            }
         }
         else if(!FightingLogicFactor.isFirstOfOurs)
         {
            return 0;
         }
         LogUtil("表面涂层伤害" + param1.lastHurtOfSpecial);
         var _loc2_:int = param1.lastHurtOfSpecial * 2;
         param1.lastHurtOfSpecial = 0;
         LogUtil("表面涂层伤害" + _loc2_);
         return _loc2_;
      }
      
      private static function skillPowerByCount(param1:ElfVO) : int
      {
         var _loc2_:int = Math.pow(2,param1.currentSkill.continueSkillCount) * 30;
         if(param1.hasUseDefense)
         {
            _loc2_ = _loc2_ * 2;
         }
         return _loc2_;
      }
      
      private static function skillPowerByHp(param1:ElfVO) : int
      {
         LogUtil(64 * param1.currentHp / param1.totalHp + "血量改变威力");
         if(64 * param1.currentHp / param1.totalHp > 0 && 64 * param1.currentHp / param1.totalHp <= 1)
         {
            return 240;
         }
         if(64 * param1.currentHp / param1.totalHp > 1 && 64 * param1.currentHp / param1.totalHp <= 5)
         {
            return 190;
         }
         if(64 * param1.currentHp / param1.totalHp > 5 && 64 * param1.currentHp / param1.totalHp <= 12)
         {
            return 140;
         }
         if(64 * param1.currentHp / param1.totalHp > 12 && 64 * param1.currentHp / param1.totalHp <= 21)
         {
            return 120;
         }
         if(64 * param1.currentHp / param1.totalHp > 21 && 64 * param1.currentHp / param1.totalHp <= 42)
         {
            return 80;
         }
         if(64 * param1.currentHp / param1.totalHp > 42 && 64 * param1.currentHp / param1.totalHp <= 64)
         {
            return 60;
         }
         return 0;
      }
      
      public static function mullHurtCalculator(param1:ElfVO) : int
      {
         var _loc11_:* = NaN;
         calculatorElf(param1);
         var _loc3_:* = 1.0;
         var _loc5_:* = 1.0;
         var _loc6_:Number = param1.attack;
         var _loc4_:Number = param1.defense;
         var _loc7_:* = 1.0;
         var _loc2_:* = 1.0;
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               _loc11_ = FightingConfig.selfOrder.randomNum;
            }
            else
            {
               _loc11_ = FightingConfig.otherOrder.randomNum;
            }
         }
         else
         {
            _loc11_ = Math.random() * 0.25 + 0.85;
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param1.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].randomNum = _loc11_;
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].randomNum = _loc11_;
            }
         }
         var _loc8_:Number = _loc5_ * _loc3_ * _loc7_ * _loc2_ * _loc11_;
         var _loc9_:* = 40;
         var _loc10_:Number = ((2 * param1.lv + 10) / 250 * _loc6_ / _loc4_ * _loc9_ + 2) * _loc8_ * 24;
         param1.lastHurtOfPhysics = 0;
         LogUtil("hurtNum" + _loc10_ + "lv:" + param1.lv + "attackNum" + _loc6_ + "defenseNum" + _loc4_ + "totalAdd" + _loc8_ + "power" + _loc9_);
         return Math.round(_loc10_);
      }
      
      public static function calculatorNatureAdd(param1:SkillVO, param2:ElfVO) : Number
      {
         var _loc4_:* = 0;
         if(param2.status.indexOf(27) != -1)
         {
            return 1;
         }
         LogUtil("技能属性" + param1.property);
         var _loc3_:int = natureArr.indexOf(param1.property);
         var _loc5_:int = natureArr.indexOf(param2.nature[0]);
         LogUtil("被攻击者属性1" + param2.nature[0]);
         if(param2.nature.length > 1)
         {
            LogUtil("被攻击者属性2" + param2.nature[1]);
            _loc4_ = natureArr.indexOf(param2.nature[1]);
            LogUtil("技能索引index1:" + _loc3_ + "index2" + _loc5_ + "index3" + _loc4_);
            return natureInteract[_loc3_][_loc5_] * natureInteract[_loc3_][_loc4_];
         }
         return natureInteract[_loc3_][_loc5_];
      }
      
      private static function fixHurt(param1:ElfVO, param2:SkillVO, param3:ElfVO, param4:Number) : int
      {
         var _loc5_:* = 0;
         if(param2.hurtNumFix[1] == "lv")
         {
            if(param4 == 0)
            {
               FightingConfig.attackEffect = 3;
               return 0;
            }
            _loc5_ = param1.lv;
            _loc5_ = _loc5_ * 20;
            if(param2.sort == "特殊")
            {
               param3.lastHurtOfSpecial = _loc5_;
            }
            return _loc5_;
         }
         if(param2.hurtNumFix[1] == "hp")
         {
            _loc5_ = param3.currentHp / 2 > 1?param3.currentHp / 2:1.0;
            if(param2.sort == "物理")
            {
               param3.lastHurtOfPhysics = _loc5_;
            }
            return Math.round(_loc5_);
         }
         if(param2.hurtNumFix[1] == "lastHurt")
         {
            if(param4 == 0)
            {
               FightingConfig.attackEffect = 3;
               return 0;
            }
            _loc5_ = param1.lastHurtOfPhysics * 2;
            param1.lastHurtOfPhysics = 0;
            return _loc5_;
         }
         _loc5_ = param2.hurtNumFix[1];
         _loc5_ = _loc5_ * 20;
         if(param2.sort == "特殊")
         {
            param3.lastHurtOfSpecial = _loc5_;
         }
         return _loc5_;
      }
      
      private static function onceKillHurt(param1:ElfVO, param2:SkillVO, param3:ElfVO) : int
      {
         var _loc4_:* = 0;
         if(FeatureFactor.isFructifyImmunity(param3,param1))
         {
            return 0;
         }
         if(param2.isKillArray[1] == 0 || param1.lv >= param3.lv)
         {
            _loc4_ = param3.currentHp;
            return _loc4_;
         }
         _loc4_ = 0;
         return _loc4_;
      }
      
      private static function kickSkillHurt(param1:ElfVO) : int
      {
         var _loc2_:* = 0;
         if(param1.heavy <= 10)
         {
            _loc2_ = 20;
         }
         else if(param1.heavy > 10 && param1.heavy <= 25)
         {
            _loc2_ = 40;
         }
         else if(param1.heavy > 25 && param1.heavy <= 50)
         {
            _loc2_ = 60;
         }
         else if(param1.heavy > 50 && param1.heavy <= 100)
         {
            _loc2_ = 80;
         }
         else if(param1.heavy > 100 && param1.heavy <= 200)
         {
            _loc2_ = 100;
         }
         else if(param1.heavy > 200)
         {
            _loc2_ = 120;
         }
         return _loc2_;
      }
      
      public static function isFocusHitHandler(param1:ElfVO, param2:SkillVO) : Boolean
      {
         var _loc3_:* = 0;
         _loc3_ = _loc3_ + param2.focusHitLv;
         if(param1.carryProp && param1.carryProp.name == "对焦镜片" && param1.status.indexOf(39) == -1)
         {
            _loc3_ = _loc3_ + 1;
         }
         if(param1.carryProp && param1.carryProp.name == "大葱" && param1.name == "大葱鸭" && param1.status.indexOf(39) == -1)
         {
            _loc3_ = _loc3_ + 2;
         }
         if(param1.status.indexOf(12) != -1)
         {
            _loc3_ = _loc3_ + 2;
         }
         if(_loc3_ == 0)
         {
            if(Math.random() * 12 <= 1)
            {
               return true;
            }
         }
         if(_loc3_ == 1)
         {
            if(Math.random() * 6 <= 1)
            {
               return true;
            }
         }
         if(_loc3_ == 2)
         {
            if(Math.random() * 2 <= 1)
            {
               return true;
            }
         }
         if(_loc3_ >= 3)
         {
            return true;
         }
         return false;
      }
      
      public static function calculatorCorrectDouble(param1:Array) : Array
      {
         var _loc2_:* = 0;
         var _loc3_:Array = [1,1,1,1,1];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] >= 0)
            {
               _loc3_[_loc2_] = (3 + param1[_loc2_]) / 3 > 6?6:(3 + param1[_loc2_]) / 3;
            }
            else
            {
               _loc3_[_loc2_] = 3 / (3 + Math.abs(param1[_loc2_])) > 6?6:3 / (3 + Math.abs(param1[_loc2_]));
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public static function isHit(param1:SkillVO, param2:ElfVO, param3:ElfVO) : Boolean
      {
         var _loc11_:* = 0;
         var _loc5_:* = NaN;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc4_:* = NaN;
         var _loc9_:* = NaN;
         var _loc10_:* = NaN;
         var _loc8_:* = null;
         if(param3.status.indexOf(19) != -1)
         {
            if(param1.name != "音爆" && param1.name != "打雷" && param1.name != "烈暴风" && param1.name != "猛毒素" && param1.id != 327)
            {
               return false;
            }
         }
         if(param3.status.indexOf(43) != -1)
         {
            if(param1.id != 57 && param1.id != 250)
            {
               return false;
            }
         }
         if(param3.status.indexOf(20) != -1)
         {
            if(param1.name != "地震" && param1.name != "音爆" && param1.name != "猛毒素")
            {
               return false;
            }
         }
         if(param1.name == "践踏" && param3.status.indexOf(15) != -1)
         {
            return true;
         }
         if(param3.status.indexOf(23) != -1)
         {
            param3.status.splice(param3.status.indexOf(23),1);
            return true;
         }
         if(Dialogue.collectDialogueVec.indexOf(param2.nickName + "\n攻击力提升了") != -1)
         {
            return true;
         }
         if(Dialogue.collectDialogueVec.indexOf(param2.nickName + "\n的能力都提升了") != -1)
         {
            return true;
         }
         if(FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack)
         {
            if(param2.camp == "camp_of_player")
            {
               _loc11_ = FightingConfig.selfOrder.hitRandomNum[0];
               (FightingConfig.selfOrder.hitRandomNum as Array).splice(0,1);
            }
            else
            {
               LogUtil(JSON.stringify(FightingConfig.otherOrder) + "对方");
               if(FightingConfig.otherOrder == null)
               {
                  HttpClient.send(Game.upLoadUrl,{
                     "custom":Game.system,
                     "otherUserId":NPCVO.useId,
                     "message":FightingConfig.otherOrderNext + "isHit pvp对方信息为空" + FightingLogicFactor.isFirstOfOurs,
                     "token":Game.token,
                     "userId":PlayerVO.userId,
                     "swfVersion":Pocketmon.swfVersion,
                     "description":Pocketmon._description
                  },null,null,"post");
               }
               _loc11_ = FightingConfig.otherOrder.hitRandomNum[0];
               (FightingConfig.otherOrder.hitRandomNum as Array).splice(0,1);
            }
         }
         else
         {
            _loc11_ = Math.random() * 100;
         }
         if(!FightingLogicFactor.isPlayBack)
         {
            if(param2.camp == "camp_of_player")
            {
               FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].hitRandomNum.push(_loc11_);
            }
            else
            {
               FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].hitRandomNum.push(_loc11_);
            }
         }
         if(param1.isKillArray[0] == 0)
         {
            if(param1.hitRate > 100)
            {
               return true;
            }
            _loc6_ = calculatorCorrectDouble(param2.ablilityAddLv);
            _loc7_ = calculatorCorrectDouble(param3.ablilityAddLv);
            _loc4_ = _loc6_[5] / _loc7_[6];
            _loc9_ = 1.0;
            _loc10_ = 1.0;
            _loc5_ = param1.hitRate * _loc4_ * _loc9_ * _loc10_;
            if(param3.carryProp && param3.carryProp.name == "亮光之粉" && param2.status.indexOf(39) == -1)
            {
               _loc9_ = 0.9;
            }
            _loc5_ = param1.hitRate * _loc4_ * _loc9_ * _loc10_;
         }
         else
         {
            _loc5_ = 30 + param2.lv - param3.lv;
         }
         if(_loc11_ < _loc5_)
         {
            return true;
         }
         if(param2.status.indexOf(29) != -1)
         {
            param2.status.splice(param2.status.indexOf(29),1);
            if(param2.skillOfLast == null)
            {
               HttpClient.send(Game.upLoadUrl,{
                  "custom":Game.system,
                  "message":"isHit上一个技能为空",
                  "token":Game.token,
                  "userId":PlayerVO.userId,
                  "swfVersion":Pocketmon.swfVersion,
                  "description":Pocketmon._description
               },null,null,"post");
            }
            if(param2.skillOfLast.name == "连切")
            {
               _loc8_ = GetElfFactor.getSkillById(param2.skillOfLast.id);
               param2.skillOfLast.power = _loc8_.power;
               _loc8_ = null;
            }
         }
         return false;
      }
      
      public static function calculatorIsGoOutSuccess(param1:ElfVO, param2:ElfVO, param3:int) : Boolean
      {
         var _loc4_:Number = param2.currentSpeed / 4 % 256;
         var _loc5_:Number = param1.speed * 32 / _loc4_ + 30 * param3;
         if(_loc5_ > 255)
         {
            return true;
         }
         if(Math.random() * 255 < _loc5_)
         {
            return true;
         }
         return false;
      }
      
      public static function isFirstAttackOfOur(param1:ElfVO, param2:ElfVO, param3:SkillVO, param4:SkillVO) : Boolean
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(!(LoadPageCmd.lastPage is KingKwanUI) && !(LoadPageCmd.lastPage is ElfSeriesUI) && !(LoadPageCmd.lastPage is TrialUI))
         {
            if(Config.isAutoFighting && param1.currentHp <= param1.totalHp * 0.25 && Config.isAutoFightingUseProp)
            {
               PlayerVO.isUseProp = true;
               return true;
            }
         }
         if(FightingConfig.selectMap && FightingConfig.selectMap.isHard && !FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBack)
         {
            if(NPCVO.name != null && param2.currentHp <= param2.totalHp * 0.1 && !Config.isOpenBeginner)
            {
               if(Math.random() * 100 < 15)
               {
                  NPCVO.isUseProp = true;
                  return false;
               }
            }
         }
         if(param3 == null)
         {
            return true;
         }
         if(param4 == null)
         {
            return false;
         }
         LogUtil(param3.skillPriority + " 技能优先度" + param4.skillPriority);
         if(param3.skillPriority > param4.skillPriority)
         {
            return true;
         }
         if(param3.skillPriority == param4.skillPriority)
         {
            if(param1.carryProp && param1.carryProp.name == "先攻之爪" && param1.status.indexOf(39) == -1)
            {
               if(param2.carryProp == null || param2.carryProp.name != "先攻之爪")
               {
                  if(!FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBack)
                  {
                     if(Math.random() * 100 < 18.75)
                     {
                        FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isFristAttack = 1;
                        return true;
                     }
                  }
                  else if(FightingConfig.selfOrder.isFristAttack == 1)
                  {
                     FightingConfig.selfOrderVec[FightingConfig.selfOrderVec.length - 1].isFristAttack = 1;
                     return true;
                  }
               }
            }
            if(param2.carryProp && param2.carryProp.name == "先攻之爪" && param2.status.indexOf(39) == -1)
            {
               if(param1.carryProp == null || param1.carryProp.name != "先攻之爪")
               {
                  if(!FightingLogicFactor.isPVP && !FightingLogicFactor.isPlayBack)
                  {
                     if(Math.random() * 100 < 18.75)
                     {
                        FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isFristAttack = 1;
                        return false;
                     }
                  }
                  else if(FightingConfig.otherOrder.isFristAttack == 1)
                  {
                     FightingConfig.otherOrderVec[FightingConfig.otherOrderVec.length - 1].isFristAttack = 1;
                     return false;
                  }
               }
            }
            LogUtil(param1.currentSpeed + ":速度:" + param2.currentSpeed);
            if(param1.currentSpeed > param2.currentSpeed)
            {
               return true;
            }
            if(param1.currentSpeed == param2.currentSpeed && (FightingLogicFactor.isPVP || FightingLogicFactor.isPlayBack))
            {
               _loc5_ = PlayerVO.userId.substring(PlayerVO.userId.lastIndexOf("p") + 1);
               LogUtil("我方id" + _loc5_);
               _loc6_ = NPCVO.useId.substring(NPCVO.useId.lastIndexOf("p") + 1);
               LogUtil("敌方id" + _loc6_);
               if(_loc5_ < _loc6_)
               {
                  return true;
               }
               return false;
            }
         }
         return false;
      }
      
      public static function getExpCalculator(param1:ElfVO) : String
      {
         var _loc2_:String = Math.round(20 * Math.log(param1.lv) + 27);
         return _loc2_;
      }
   }
}
