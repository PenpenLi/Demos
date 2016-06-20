package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class GetElfFromSever
   {
       
      public function GetElfFromSever()
      {
         super();
      }
      
      public static function getElfInfo(param1:Object) : ElfVO
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = 0;
         var _loc5_:ElfVO = GetElfFactor.getElfVO(param1.spId);
         _loc5_.isDetail = true;
         _loc5_.id = param1.id;
         _loc5_.elfId = param1.spId;
         if(param1.nickName != null)
         {
            _loc5_.nickName = param1.nickName;
         }
         _loc5_.isLock = param1.isLock;
         _loc5_.sex = param1.sex;
         _loc5_.currentExp = param1.exp;
         _loc5_.lv = param1.lv;
         _loc5_.currentHp = param1.hp;
         _loc5_.characters = param1.charct;
         _loc5_.character = GetElfFactor.getRandomCharcter(_loc5_,false);
         _loc5_.individual = param1.indv;
         _loc5_.isCarry = param1.isCry;
         _loc5_.brokenLv = param1.bkLv;
         _loc5_.starts = param1.star;
         if(param1.cryPidAry)
         {
            if(param1.cryPidAry.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.cryPidAry.length)
               {
                  _loc4_ = GetPropFactor.getPropVO(param1.cryPidAry[_loc6_]);
                  if(_loc4_.type == 1 || _loc4_.type == 23)
                  {
                     _loc5_.carryProp = _loc4_;
                  }
                  else if(_loc4_.type == 16 || _loc4_.type == 17)
                  {
                     _loc5_.hagberryProp = _loc4_;
                  }
                  _loc6_++;
               }
            }
         }
         if(param1.stateAry)
         {
            _loc2_ = "";
            _loc5_.status = param1.stateAry;
            _loc7_ = 0;
            while(_loc7_ < _loc5_.status.length)
            {
               _loc2_ = _loc2_ + (StatusFactor.status[_loc5_.status[_loc7_] - 1] + "  ");
               _loc7_++;
            }
            _loc5_.state = _loc2_;
         }
         _loc5_.effAry = param1.effAry;
         var _loc3_:Array = param1.skLst;
         _loc5_.elfBallId = param1.ball;
         GetElfFactor.getElfCurrentSkill(_loc5_,_loc3_);
         CalculatorFactor.calculatorElf(_loc5_);
         return _loc5_;
      }
      
      public static function copyElf(param1:ElfVO) : ElfVO
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc4_:* = 0;
         var _loc3_:ElfVO = GetElfFactor.getElfVO(param1.elfId);
         _loc3_.isDetail = true;
         _loc3_.id = param1.id;
         _loc3_.elfId = param1.elfId;
         if(param1.nickName != null)
         {
            _loc3_.nickName = param1.nickName;
         }
         _loc3_.sex = param1.sex;
         _loc3_.currentExp = param1.currentExp;
         _loc3_.lv = param1.lv;
         _loc3_.currentHp = param1.currentHp;
         _loc3_.characters = param1.characters;
         _loc3_.character = GetElfFactor.getRandomCharcter(_loc3_,false);
         _loc3_.featureVO = param1.featureVO;
         _loc5_ = 0;
         while(_loc5_ < param1.individual.length)
         {
            _loc3_.individual[_loc5_] = param1.individual[_loc5_];
            _loc5_++;
         }
         _loc6_ = 0;
         while(_loc6_ < param1.characterCorrect.length)
         {
            _loc3_.characterCorrect[_loc6_] = param1.characterCorrect[_loc6_];
            _loc6_++;
         }
         _loc3_.isCarry = param1.isCarry;
         _loc3_.carryProp = param1.carryProp;
         _loc3_.hagberryProp = param1.hagberryProp;
         _loc3_.effAry = param1.effAry;
         _loc3_.elfBallId = param1.elfBallId;
         _loc3_.brokenLv = param1.brokenLv;
         _loc3_.starts = param1.starts;
         var _loc2_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < param1.currentSkillVec.length)
         {
            _loc2_.push({
               "id":param1.currentSkillVec[_loc4_].id,
               "pp":param1.currentSkillVec[_loc4_].currentPP,
               "lv":param1.currentSkillVec[_loc4_].lv
            });
            _loc4_++;
         }
         GetElfFactor.getElfCurrentSkill(_loc3_,_loc2_);
         CalculatorFactor.calculatorElf(_loc3_);
         return _loc3_;
      }
   }
}
