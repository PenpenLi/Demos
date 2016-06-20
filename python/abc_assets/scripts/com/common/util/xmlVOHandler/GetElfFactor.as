package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.elf.SkillVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.elf.FeatureVO;
   import com.common.util.ElfSortHandler;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.myElf.MyElfPro;
   import com.common.events.EventCenter;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   
   public class GetElfFactor
   {
      
      public static var bagNewElf:Boolean;
      
      private static var _elfVo:ElfVO;
      
      private static var bfBagElfLvVec:Array = [];
      
      public static var evolveElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var allElfStaticObj:Object;
      
      public static var UpdateIndex:int;
      
      private static var allSkillStaticVec:Object;
      
      public static var amusePreviewElfVoVec:Vector.<ElfVO> = Vector.<ElfVO>([]);
      
      private static var allFeatureVO:Object;
       
      public function GetElfFactor()
      {
         super();
      }
      
      public static function getElfVO(param1:String, param2:Boolean = true) : ElfVO
      {
         var _loc4_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc5_:ElfVO = new ElfVO();
         _loc5_.elfId = allElfStaticObj[param1].elfId;
         _loc5_.master = PlayerVO.nickName;
         _loc5_.baseExp = allElfStaticObj[param1].baseExp;
         _loc5_.expCurve = allElfStaticObj[param1].expCurve;
         _loc5_.captureRate = allElfStaticObj[param1].captureRate;
         _loc5_.imgName = allElfStaticObj[param1].imgName;
         _loc5_.name = allElfStaticObj[param1].name;
         _loc5_.nature = allElfStaticObj[param1].nature;
         _loc5_.parentNature = allElfStaticObj[param1].parentNature;
         _loc5_.dropEffort = allElfStaticObj[param1].dropEffort;
         _loc5_.sexDistribution = allElfStaticObj[param1].sexDistribution;
         _loc5_.feature = allElfStaticObj[param1].feature;
         _loc5_.speciesAttack = allElfStaticObj[param1].speciesAttack;
         _loc5_.speciesDefense = allElfStaticObj[param1].speciesDefense;
         _loc5_.speciesSpuer_defense = allElfStaticObj[param1].speciesSpuer_defense;
         _loc5_.speciesSuper_attack = allElfStaticObj[param1].speciesSuper_attack;
         _loc5_.speciesHp = allElfStaticObj[param1].speciesHp;
         _loc5_.speciesSpeed = allElfStaticObj[param1].speciesSpeed;
         _loc5_.tall = allElfStaticObj[param1].tall;
         _loc5_.heavy = allElfStaticObj[param1].heavy;
         _loc5_.starts = allElfStaticObj[param1].starts;
         _loc5_.originStarts = allElfStaticObj[param1].starts;
         _loc5_.maxStar = allElfStaticObj[param1].maxStar;
         _loc5_.zzTotal = allElfStaticObj[param1].zzTotal;
         _loc5_.evoFrom = allElfStaticObj[param1].evoFrom;
         _loc5_.evoLv = allElfStaticObj[param1].evoLv;
         _loc5_.evolveId = allElfStaticObj[param1].evolveId;
         _loc5_.evolveIdArr = allElfStaticObj[param1].evolveIdArr;
         _loc5_.evoStoneArr = allElfStaticObj[param1].evoStoneArr;
         _loc5_.muchEvoStoneArr = allElfStaticObj[param1].muchEvoStoneArr;
         _loc5_.descr = allElfStaticObj[param1].descr;
         _loc5_.rare = allElfStaticObj[param1].rare;
         _loc5_.freePoints = allElfStaticObj[param1].freePoints;
         _loc5_.isSpecial = allElfStaticObj[param1].isSpecial;
         getIndividual(_loc5_);
         _loc5_.character = getRandomCharcter(_loc5_,true);
         _loc5_.sex = getSex(_loc5_);
         _loc5_.nickName = allElfStaticObj[param1].nickName;
         _loc5_.recruitLimit = allElfStaticObj[param1].recruitLimit;
         _loc5_.previewLimit = allElfStaticObj[param1].previewLimit;
         rareHandle(_loc5_);
         _loc5_.skillInfo = allElfStaticObj[param1].skillInfo;
         _loc5_.featureVO = allElfStaticObj[param1].featureVO;
         _loc5_.sound = allElfStaticObj[param1].sound;
         if(param2)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_.skillInfo.length)
            {
               _loc3_ = (_loc5_.skillInfo[_loc6_] as String).split(",");
               _loc4_ = getSkillById(_loc3_[1]);
               _loc5_.totalSkillID.push(_loc3_[1]);
               _loc5_.totalSkillVec.push(_loc4_);
               _loc4_.lvNeed = _loc3_[0];
               _loc6_++;
            }
            skillLvSort(_loc5_.totalSkillVec);
         }
         return _loc5_;
      }
      
      public static function getAllSpeciality() : void
      {
         var _loc1_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_features");
         allFeatureVO = {};
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_features;
         for each(var _loc3_ in _loc2_.sta_features)
         {
            _loc1_ = new FeatureVO();
            _loc1_.id = _loc3_.@id;
            _loc1_.name = _loc3_.@name;
            allFeatureVO[_loc1_.id] = _loc1_;
         }
         LoadOtherAssetsManager.getInstance().removeAsset(["sta_features"],false,true);
      }
      
      public static function getAllElfVO() : void
      {
         var _loc3_:* = null;
         var _loc1_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_poke");
         allElfStaticObj = {};
         var _loc5_:* = 0;
         var _loc4_:* = _loc1_.sta_poke;
         for each(var _loc2_ in _loc1_.sta_poke)
         {
            _loc3_ = new ElfVO();
            staticValue(_loc3_,_loc2_);
            allElfStaticObj[_loc3_.elfId] = _loc3_;
         }
         LoadOtherAssetsManager.getInstance().removeAsset(["sta_poke"],false,true);
      }
      
      public static function getAmusePreviewElfVoVec() : void
      {
         amusePreviewElfVoVec = Vector.<ElfVO>([]);
         var _loc3_:* = 0;
         var _loc2_:* = allElfStaticObj;
         for each(var _loc1_ in allElfStaticObj)
         {
            if(_loc1_.recruitLimit == 2 || _loc1_.recruitLimit == 3)
            {
               amusePreviewElfVoVec.push(_loc1_);
            }
         }
         amusePreviewElfVoVec = amusePreviewElfVoVec.sort(ElfSortHandler.sortRareDecrease);
      }
      
      public static function getAllSkillVO() : void
      {
         var _loc1_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_skill");
         allSkillStaticVec = {};
         var _loc5_:* = 0;
         var _loc4_:* = _loc2_.sta_skill;
         for each(var _loc3_ in _loc2_.sta_skill)
         {
            _loc1_ = {};
            _loc1_.id = _loc3_.@id;
            _loc1_.name = _loc3_.@chineseName;
            _loc1_.totalPP = _loc3_.@PP;
            _loc1_.property = _loc3_.@attr;
            _loc1_.power = _loc3_.@atk;
            _loc1_.skillPriority = _loc3_.@prio;
            _loc1_.hitRate = _loc3_.@hitRatio;
            _loc1_.sort = _loc3_.@type;
            _loc1_.descs = _loc3_.@descs;
            _loc1_.currentPP = _loc1_.totalPP;
            _loc1_.skillAffectTarget = _loc3_.@skillAffectTarget;
            _loc1_.isKillArray = _loc3_.@isKillArray;
            _loc1_.isStoreGas = _loc3_.@isStoreGas;
            _loc1_.focusHitLv = _loc3_.@focusHitLv;
            _loc1_.attackNum = _loc3_.@attackNum;
            _loc1_.hurtNumFix = _loc3_.@hurtNumFix;
            _loc1_.badEffect = _loc3_.@badEffect;
            _loc1_.effectForOther = _loc3_.@effectForOther;
            _loc1_.effectForSelf = _loc3_.@effectForSelf;
            _loc1_.effectForAblilityLv = _loc3_.@effectForAblilityLv;
            _loc1_.status = _loc3_.@status;
            _loc1_.soundName = _loc3_.@sound;
            allSkillStaticVec[_loc1_.id] = _loc1_;
         }
         LoadOtherAssetsManager.getInstance().removeAsset(["sta_skill"],false,true);
      }
      
      private static function staticValue(param1:ElfVO, param2:XML) : void
      {
         var _loc4_:* = 0;
         param1.elfId = param2.@id;
         param1.imgName = "img_" + param2.@pinyinName;
         param1.baseExp = param2.@expParam;
         param1.expCurve = param2.@expCurve;
         param1.captureRate = param2.@catchRatio;
         param1.name = param2.@chineseName;
         param1.nature = param2.@attr.split("|");
         _loc4_ = 0;
         while(_loc4_ < param1.nature.length)
         {
            param1.nature[_loc4_] = param1.nature[_loc4_].replace(new RegExp("^\\s*|\\s*$","g"),"");
            _loc4_++;
         }
         param1.parentNature = param2.@eggGroup;
         param1.dropEffort = param2.@hardVal.split(",");
         param1.sexDistribution = param2.@sex;
         param1.feature = param2.@feature;
         param1.speciesAttack = param2.@zzWG;
         param1.speciesDefense = param2.@zzWF;
         param1.speciesSpuer_defense = param2.@zzTF;
         param1.speciesSuper_attack = param2.@zzTG;
         param1.speciesHp = param2.@zzHP;
         param1.speciesSpeed = param2.@zzSD;
         param1.tall = param2.@tall;
         param1.heavy = param2.@heavy;
         param1.starts = param2.@star;
         param1.maxStar = param2.@starCeiling;
         param1.zzTotal = param2.@zzTotal;
         param1.evoFrom = param2.@evoFrom;
         var _loc3_:String = param2.@evoParamJNS;
         evolveHandle(param1,_loc3_);
         param1.descr = param2.@descr;
         param1.rare = param2.@rare;
         param1.freePoints = param2.@freePoints;
         param1.recruitLimit = param2.@recruitLimit;
         param1.previewLimit = param2.@previewLimit;
         param1.featureVO = getFeatureVO(param2.@feature);
         param1.sound = param2.@sound;
         if(param2.@godPoke == 0)
         {
            param1.isSpecial = false;
         }
         else
         {
            param1.isSpecial = true;
         }
         getIndividual(param1);
         param1.character = getRandomCharcter(param1,true);
         param1.sex = getSex(param1);
         param1.nickName = param1.name;
         rareHandle(param1);
         param1.skillInfo = param2.@skillSt.split("|");
      }
      
      private static function getFeatureVO(param1:String) : FeatureVO
      {
         if(param1 == "")
         {
            return null;
         }
         return allFeatureVO[param1];
      }
      
      public static function rareHandle(param1:ElfVO) : void
      {
         var _loc2_:* = param1.rare;
         if("传说" !== _loc2_)
         {
            if("史诗" !== _loc2_)
            {
               if("稀有" !== _loc2_)
               {
                  if("较稀有" !== _loc2_)
                  {
                     if("常见" === _loc2_)
                     {
                        param1.rareValue = 1;
                     }
                  }
                  else
                  {
                     param1.rareValue = 2;
                  }
               }
               else
               {
                  param1.rareValue = 3;
               }
            }
            else
            {
               param1.rareValue = 4;
            }
         }
         else
         {
            param1.rareValue = 5;
         }
      }
      
      public static function evolveHandle(param1:ElfVO, param2:String) : void
      {
         var _loc7_:* = 0;
         var _loc6_:* = 0;
         var _loc9_:* = null;
         var _loc8_:* = 0;
         if(param2 == "")
         {
            return;
         }
         var _loc4_:String = param2.replace(new RegExp("\\\'|&apos;","g"),"\"");
         var _loc5_:Object = JSON.parse(_loc4_);
         var _loc3_:Array = _loc5_.evo;
         if(_loc3_.length == 1)
         {
            param1.evolveId = _loc3_[0].evoPokeId;
            LogUtil("测试====",param1.name,_loc3_[0].evoL);
            param1.evoLv = _loc3_[0].evoLv;
            if(_loc3_[0].stones)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc3_[0].stones.length)
               {
                  param1.evoStoneArr.push([_loc3_[0].stones[_loc7_].id,_loc3_[0].stones[_loc7_].num]);
                  _loc7_++;
               }
            }
         }
         else if(_loc3_.length > 1)
         {
            param1.evoLv = _loc3_[0].evoLv;
            LogUtil("测试=======+++++++++++++==",param1.name,_loc3_[0].evoLv);
            param1.muchEvoStoneArr = {};
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               param1.evolveIdArr.push(_loc3_[_loc6_].evoPokeId);
               if(_loc3_[_loc6_].stones)
               {
                  _loc9_ = [];
                  _loc8_ = 0;
                  while(_loc8_ < _loc3_[_loc6_].stones.length)
                  {
                     _loc9_.push([_loc3_[_loc6_].stones[_loc8_].id,_loc3_[_loc6_].stones[_loc8_].num]);
                     _loc8_++;
                  }
                  param1.muchEvoStoneArr[_loc6_] = _loc9_;
               }
               _loc6_++;
            }
         }
      }
      
      public static function getRandomCharcter(param1:ElfVO, param2:Boolean) : String
      {
         var _loc5_:* = null;
         var _loc4_:* = null;
         if(param2)
         {
            param1.characters = Math.random() * 25 + 1;
         }
         param1.characterCorrect = [1,1,1,1,1];
         var _loc3_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("character");
         var _loc8_:* = 0;
         var _loc7_:* = _loc3_.node;
         for each(var _loc6_ in _loc3_.node)
         {
            if(_loc6_.@ID == param1.characters)
            {
               _loc5_ = _loc6_.@zjnlz;
               setAddAbilityCorrect(_loc5_,param1,1.1);
               _loc4_ = _loc6_.@jdnlz;
               setAddAbilityCorrect(_loc4_,param1,0.9);
            }
         }
         return _loc3_.node[param1.characters - 1].attribute("xg");
      }
      
      private static function getSex(param1:ElfVO) : int
      {
         if(param1.sexDistribution == -1)
         {
            if(param1.elfId == 132)
            {
               return 2;
            }
            return 3;
         }
         var _loc2_:int = Math.random() * 100;
         if(_loc2_ < param1.sexDistribution)
         {
            return 1;
         }
         return 0;
      }
      
      private static function setAddAbilityCorrect(param1:String, param2:ElfVO, param3:Number) : void
      {
         var _loc4_:* = param1;
         if("攻击" !== _loc4_)
         {
            if("防御" !== _loc4_)
            {
               if("特攻" !== _loc4_)
               {
                  if("特防" !== _loc4_)
                  {
                     if("速度" === _loc4_)
                     {
                        param2.characterCorrect[4] = param3;
                     }
                  }
                  else
                  {
                     param2.characterCorrect[3] = param3;
                  }
               }
               else
               {
                  param2.characterCorrect[2] = param3;
               }
            }
            else
            {
               param2.characterCorrect[1] = param3;
            }
         }
         else
         {
            param2.characterCorrect[0] = param3;
         }
      }
      
      private static function getIndividual(param1:ElfVO) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.individual.length)
         {
            param1.individual[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      public static function getElfCurrentSkill(param1:ElfVO, param2:Array) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         param1.currentSkillVec.length = 0;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ = getSkillById(param2[_loc4_].id);
            _loc3_.currentPP = param2[_loc4_].pp;
            _loc3_.lv = param2[_loc4_].lv;
            param1.currentSkillVec.push(_loc3_);
            _loc4_++;
         }
      }
      
      public static function getSkillById(param1:int) : SkillVO
      {
         var _loc2_:SkillVO = new SkillVO();
         _loc2_.id = allSkillStaticVec[param1].id;
         _loc2_.name = allSkillStaticVec[param1].name;
         _loc2_.totalPP = allSkillStaticVec[param1].totalPP;
         _loc2_.property = allSkillStaticVec[param1].property;
         _loc2_.power = allSkillStaticVec[param1].power;
         _loc2_.skillPriority = allSkillStaticVec[param1].skillPriority;
         _loc2_.hitRate = allSkillStaticVec[param1].hitRate;
         _loc2_.sort = allSkillStaticVec[param1].sort;
         _loc2_.descs = allSkillStaticVec[param1].descs;
         _loc2_.currentPP = _loc2_.totalPP;
         _loc2_.skillAffectTarget = allSkillStaticVec[param1].skillAffectTarget;
         _loc2_.isKillArray = allSkillStaticVec[param1].isKillArray.split(",");
         _loc2_.isStoreGas = allSkillStaticVec[param1].isStoreGas;
         _loc2_.focusHitLv = allSkillStaticVec[param1].focusHitLv;
         _loc2_.attackNum = allSkillStaticVec[param1].attackNum.split(",");
         _loc2_.hurtNumFix = allSkillStaticVec[param1].hurtNumFix.split(",");
         _loc2_.badEffect = allSkillStaticVec[param1].badEffect.split(",");
         _loc2_.effectForOther = allSkillStaticVec[param1].effectForOther.split(",");
         _loc2_.effectForSelf = allSkillStaticVec[param1].effectForSelf.split(",");
         if(allSkillStaticVec[param1].effectForAblilityLv != "")
         {
            _loc2_.effectForAblilityLv = allSkillStaticVec[param1].effectForAblilityLv.split(",");
            _loc2_.effectForAblilityLv[0] = _loc2_.effectForAblilityLv[0].split("|");
         }
         _loc2_.status = allSkillStaticVec[param1].status.split(",");
         _loc2_.soundName = allSkillStaticVec[param1].soundName;
         eleChangeNum(_loc2_.isKillArray,_loc2_.attackNum,_loc2_.hurtNumFix,_loc2_.badEffect,_loc2_.effectForOther,_loc2_.effectForSelf,_loc2_.status);
         return _loc2_;
      }
      
      public static function eleChangeNum(... rest) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < rest.length)
         {
            _loc2_ = rest[_loc3_];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_] != "lv" && _loc2_[_loc4_] != "hp" && _loc2_[_loc4_] != "lastHurt")
               {
                  _loc2_[_loc4_] = _loc2_[_loc4_];
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public static function bagElfNum(param1:Boolean = false, param2:Boolean = false, param3:Vector.<ElfVO> = null) : int
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(param3 == null)
         {
            var param3:Vector.<ElfVO> = PlayerVO.bagElfVec;
         }
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            if(param3[_loc4_] != null)
            {
               if(!param1)
               {
                  _loc5_++;
               }
               else if(!param3[_loc4_].currentHp <= 0)
               {
                  if(param2)
                  {
                     if(param3[_loc4_].lv != 80)
                     {
                        _loc5_++;
                     }
                  }
                  else
                  {
                     _loc5_++;
                  }
               }
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      public static function seriesElfNum(param1:Vector.<ElfVO>) : int
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public static function bagOrCom(param1:ElfVO, param2:Boolean = true) : void
      {
         var _loc3_:* = 0;
         if(seriesElfNum(PlayerVO.bagElfVec) < PlayerVO.pokeSpace)
         {
            _loc3_ = 0;
            while(_loc3_ < PlayerVO.bagElfVec.length)
            {
               if(PlayerVO.bagElfVec[_loc3_] == null)
               {
                  PlayerVO.bagElfVec[_loc3_] = param1;
                  param1.isCarry = 1;
                  PlayerVO.bagElfVec[_loc3_].position = _loc3_ + 1;
                  if(!param2)
                  {
                     bagNewElf = true;
                  }
                  break;
               }
               _loc3_++;
            }
         }
         else
         {
            PlayerVO.comElfVec.push(param1);
            param1.isCarry = 0;
            param1.position = 0;
         }
      }
      
      public static function kingPower(param1:Vector.<ElfVO>) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null)
            {
               _loc2_ = _loc2_ + param1[_loc3_].power;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function powerCalculate(param1:Vector.<ElfVO>) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null)
            {
               _loc2_ = _loc2_ + Math.round(param1[_loc3_].attack + param1[_loc3_].super_attack + param1[_loc3_].super_defense + param1[_loc3_].defense + param1[_loc3_].speed + param1[_loc3_].currentHp);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function powerFormation(param1:Vector.<ElfVO>) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null)
            {
               _loc2_ = _loc2_ + Math.round(param1[_loc3_].attack + param1[_loc3_].super_attack + param1[_loc3_].super_defense + param1[_loc3_].defense + param1[_loc3_].speed + param1[_loc3_].totalHp);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function calculatePower(param1:ElfVO) : int
      {
         return param1.attack + param1.super_attack + param1.super_defense + param1.defense + param1.speed + param1.totalHp;
      }
      
      public static function seiri() : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc1_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               _loc1_.push(PlayerVO.bagElfVec[_loc2_]);
               PlayerVO.bagElfVec[_loc2_] = null;
            }
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            PlayerVO.bagElfVec[_loc3_] = _loc1_[_loc3_];
            PlayerVO.bagElfVec[_loc3_].position = _loc3_ + 1;
            LogUtil("背包精灵位置整理=",PlayerVO.bagElfVec[_loc3_].nickName,PlayerVO.bagElfVec[_loc3_].position);
            _loc3_++;
         }
      }
      
      public static function otherSeiri(param1:Vector.<ElfVO>) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null)
            {
               _loc2_.push(param1[_loc3_]);
               param1[_loc3_] = null;
            }
            _loc3_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            param1[_loc4_] = _loc2_[_loc4_];
            _loc4_++;
         }
      }
      
      public static function bagElfEvolve() : void
      {
         var _loc1_:* = 0;
      }
      
      public static function gotoEvolve() : void
      {
         var _loc1_:* = 0;
         if(evolveElfVec.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < evolveElfVec.length)
            {
               LogUtil("有升级的精灵",evolveElfVec[0].name);
               if(!GetElfFactor.evolve(evolveElfVec[0]))
               {
                  _loc1_++;
                  continue;
               }
               break;
            }
         }
      }
      
      public static function evolve(param1:ElfVO) : Boolean
      {
         var _loc2_:* = null;
         _elfVo = param1;
         evolveElfVec.splice(0,1);
         if(param1.evoStoneArr.length == 0 && param1.lv >= param1.evoLv && param1.evoLv != -1 && param1.currentHp > 0)
         {
            _loc2_ = Alert.show("【" + param1.name + "】可以进化了！你确定要进化么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc2_.addEventListener("close",evolveSureHandler);
            return true;
         }
         return false;
      }
      
      private static function evolveSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (Facade.getInstance().retrieveProxy("MyElfPro") as MyElfPro).write2011(_elfVo.evolveId,_elfVo);
         }
      }
      
      public static function checkStatus() : Boolean
      {
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = true;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               if(PlayerVO.bagElfVec[_loc1_].currentHp < PlayerVO.bagElfVec[_loc1_].totalHp)
               {
                  _loc2_ = false;
                  break;
               }
               if(PlayerVO.bagElfVec[_loc1_].status.length != 0)
               {
                  _loc2_ = false;
                  break;
               }
               _loc3_ = 0;
               while(_loc3_ < PlayerVO.bagElfVec[_loc1_].currentSkillVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc1_].currentSkillVec[_loc3_].currentPP < PlayerVO.bagElfVec[_loc1_].currentSkillVec[_loc3_].totalPP)
                  {
                     _loc2_ = false;
                     break;
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public static function getBeforeFightElf() : void
      {
         var _loc1_:* = 0;
         bfBagElfLvVec = [];
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               bfBagElfLvVec.push(PlayerVO.bagElfVec[_loc1_].lv);
            }
            _loc1_++;
         }
      }
      
      private static function continueUpdate() : void
      {
         LogUtil("========================学习完新技能, 继续==========================");
         EventCenter.removeEventListener("LEARN_NEWSKILL_OVER",continueUpdate);
         GetElfFactor.updateElf(GetElfFactor.UpdateIndex + 1);
      }
      
      public static function updateElf(param1:int) : void
      {
         var _loc2_:* = 0;
         LogUtil("starIndex==",param1,TrainPro.trainVec.length,TrainPro.trainVec);
         _loc2_ = param1;
         while(_loc2_ < TrainPro.trainVec.length)
         {
            if(TrainPro.trainVec[_loc2_].elfVo)
            {
               LogUtil("更新精灵============",TrainPro.trainVec[_loc2_].elfVo.nickName);
               if(TrainPro.trainVec[_loc2_].elfVo.isCarry == 1)
               {
                  if(upDateElf(PlayerVO.bagElfVec,TrainPro.trainVec[_loc2_].elfVo))
                  {
                     LogUtil("------------------------中断更新背包精灵数据------------------------",_loc2_);
                     UpdateIndex = _loc2_;
                     return;
                  }
               }
               else if(upDateElf(PlayerVO.comElfVec,TrainPro.trainVec[_loc2_].elfVo))
               {
                  LogUtil("中断更新电脑精灵数据------------------------",_loc2_);
                  UpdateIndex = _loc2_;
                  return;
               }
            }
            _loc2_++;
         }
         EventCenter.dispatchEvent("UPDATE_TRAINELF_OVER");
      }
      
      private static function upDateElf(param1:Vector.<ElfVO>, param2:ElfVO) : Boolean
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null)
            {
               if(param1[_loc3_].id == param2.id)
               {
                  param1[_loc3_].currentExp = param2.currentExp;
                  param1[_loc3_].totalHp = param2.totalHp;
                  param1[_loc3_].currentHp = param2.currentHp;
                  LogUtil("训练后的hp======== ",param1[_loc3_].currentHp);
                  LogUtil("训练前的等级======== ",param1[_loc3_].lv);
                  CalculatorFactor.calculatorElfLv(param1[_loc3_]);
                  LogUtil("训练后的等级======== ",param1[_loc3_].lv);
                  CalculatorFactor.calculatorElf(param1[_loc3_]);
                  if(param2.currentHp > param1[_loc3_].totalHp)
                  {
                     LogUtil("当前hp超过了总hp==",param1[_loc3_].totalHp);
                     param2.currentHp = param1[_loc3_].totalHp;
                  }
                  if(CalculatorFactor.learnSkillHandler(param1[_loc3_]))
                  {
                     EventCenter.addEventListener("LEARN_NEWSKILL_OVER",continueUpdate);
                     LogUtil("-------------------------学习新技能--------------------------");
                     return true;
                  }
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function deleElf(param1:ElfVO, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(param1.isCarry == 1 && param2)
         {
            PlayerVO.bagElfVec[param1.position - 1] = null;
         }
         if(param1.isCarry == 0)
         {
            PlayerVO.comElfVec.splice(comIndex(param1),1);
         }
         _loc3_ = 0;
         while(_loc3_ < KingKwanMedia.kingPlayElf.length)
         {
            if(KingKwanMedia.kingPlayElf[_loc3_].id == param1.id)
            {
               KingKwanMedia.kingPlayElf.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public static function comIndex(param1:ElfVO) : int
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.comElfVec.length)
         {
            if(PlayerVO.comElfVec[_loc2_].id == param1.id)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function elfSort(param1:Vector.<ElfVO>, param2:String) : Vector.<ElfVO>
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         _loc4_ = 1;
         while(_loc4_ < param1.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length - _loc4_)
            {
               if(param1[_loc5_][param2] < param1[_loc5_ + 1][param2])
               {
                  _loc3_ = param1[_loc5_];
                  param1[_loc5_] = param1[_loc5_ + 1];
                  param1[_loc5_ + 1] = _loc3_;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return param1;
      }
      
      public static function skillLvSort(param1:Vector.<SkillVO>) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].lvNeed > param1[_loc4_ + 1].lvNeed)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
   }
}
