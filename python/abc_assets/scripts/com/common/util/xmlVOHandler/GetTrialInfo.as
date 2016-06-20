package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.trial.TrialBossVO;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.models.vos.mainCity.train.TrialDifficultyVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class GetTrialInfo
   {
       
      public function GetTrialInfo()
      {
         super();
      }
      
      public static function getTrialInfo() : Vector.<TrialBossVO>
      {
         var _loc6_:* = 0;
         var _loc5_:* = null;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_trial");
         var _loc3_:uint = (_loc4_.sta_trial as XMLList).length();
         var _loc1_:Vector.<TrialBossVO> = new Vector.<TrialBossVO>([]);
         var _loc2_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            if(_loc2_.indexOf((_loc4_.sta_trial as XMLList)[_loc6_].@bossId) == -1)
            {
               _loc5_ = new TrialBossVO();
               _loc5_.bossId = (_loc4_.sta_trial as XMLList)[_loc6_].@bossId;
               _loc5_.bossName = (_loc4_.sta_trial as XMLList)[_loc6_].@bossName;
               _loc5_.bossDesc = (_loc4_.sta_trial as XMLList)[_loc6_].@bossDesc;
               _loc5_.bossImg = (_loc4_.sta_trial as XMLList)[_loc6_].@bossImg;
               if((_loc4_.sta_trial as XMLList)[_loc6_].@openData == 7)
               {
                  _loc5_.openData = 0;
               }
               else
               {
                  _loc5_.openData = (_loc4_.sta_trial as XMLList)[_loc6_].@openData;
               }
               _loc5_.challengeTimes = (_loc4_.sta_trial as XMLList)[_loc6_].@challengeTimes;
               _loc5_.difficultyVec = getDifficultyVO(_loc5_.bossId);
               _loc1_.push(_loc5_);
               _loc2_.push((_loc4_.sta_trial as XMLList)[_loc6_].@bossId);
            }
            _loc6_++;
         }
         LogUtil("bossArr: " + _loc2_);
         _loc2_ = null;
         _loc4_ = null;
         return _loc1_;
      }
      
      private static function getDifficultyVO(param1:uint) : Vector.<TrialDifficultyVO>
      {
         var _loc7_:* = 0;
         var _loc9_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = 0;
         var _loc4_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_trial");
         var _loc3_:uint = (_loc4_.sta_trial as XMLList).length();
         var _loc2_:Vector.<TrialDifficultyVO> = new Vector.<TrialDifficultyVO>([]);
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            if(param1 == (_loc4_.sta_trial as XMLList)[_loc7_].@bossId)
            {
               _loc9_ = new TrialDifficultyVO();
               _loc9_.id = (_loc4_.sta_trial as XMLList)[_loc7_].@id;
               _loc9_.openLv = (_loc4_.sta_trial as XMLList)[_loc7_].@openLv;
               _loc9_.difficultyLv = (_loc4_.sta_trial as XMLList)[_loc7_].@difficultyLv;
               _loc9_.pokePicture = (_loc4_.sta_trial as XMLList)[_loc7_].@pokePicture;
               _loc9_.bossImg = (_loc4_.sta_trial as XMLList)[_loc7_].@bossImg;
               _loc9_.bossName = (_loc4_.sta_trial as XMLList)[_loc7_].@bossName;
               _loc9_.bossDesc = (_loc4_.sta_trial as XMLList)[_loc7_].@bossDesc;
               _loc9_.bossId = (_loc4_.sta_trial as XMLList)[_loc7_].@bossId;
               _loc6_ = (_loc4_.sta_trial as XMLList)[_loc7_].@propJNS.replace(new RegExp("\\\'|&apos;","g"),"\"");
               _loc5_ = JSON.parse(_loc6_).drop;
               _loc8_ = 0;
               while(_loc8_ < _loc5_.length)
               {
                  _loc9_.dropPropIdArr.push(_loc5_[_loc8_].pId);
                  _loc8_++;
               }
               _loc2_.push(_loc9_);
            }
            _loc7_++;
         }
         _loc4_ = null;
         return _loc2_;
      }
      
      public static function getDifficultyElfVoVec(param1:uint) : Vector.<ElfVO>
      {
         var _loc5_:* = null;
         var _loc2_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_trial");
         var _loc4_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         var _loc7_:* = 0;
         var _loc6_:* = _loc2_.sta_trial as XMLList;
         for each(var _loc3_ in _loc2_.sta_trial as XMLList)
         {
            if(_loc3_.@id == param1)
            {
               _loc5_ = _loc3_.@spirit.split("|");
               _loc4_ = collectElfVO(_loc5_);
               break;
            }
         }
         _loc2_ = null;
         return _loc4_;
      }
      
      private static function collectElfVO(param1:Array) : Vector.<ElfVO>
      {
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = null;
         var _loc5_:Vector.<ElfVO> = new Vector.<ElfVO>([]);
         NPCVO.bagElfVec = Vector.<ElfVO>([]);
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc3_ = param1[_loc6_].split(",");
            _loc7_ = _loc3_[0];
            _loc4_ = _loc3_[1];
            _loc2_ = GetElfFactor.getElfVO(_loc7_);
            _loc2_.camp = "camp_of_computer";
            _loc2_.lv = _loc4_;
            CalculatorFactor.calculatorElf(_loc2_);
            selectCurrentSkillVec(_loc2_);
            _loc5_.push(_loc2_);
            _loc6_++;
         }
         return _loc5_;
      }
      
      private static function selectCurrentSkillVec(param1:ElfVO, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(!param2)
         {
            while(param1.currentSkillVec.length > 4)
            {
               _loc3_ = Math.random() * param1.currentSkillVec.length;
               param1.currentSkillVec.splice(_loc3_,1);
            }
         }
         else
         {
            while(param1.currentSkillVec.length > 4)
            {
               param1.currentSkillVec.splice(0,1);
            }
         }
         GetElfQuality.alterElfProperty(param1);
      }
   }
}
