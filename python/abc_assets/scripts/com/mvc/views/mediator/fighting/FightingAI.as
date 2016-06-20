package com.mvc.views.mediator.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.vos.elf.SkillVO;
   import extend.SoundEvent;
   import com.common.themes.Tips;
   import com.common.util.dialogue.Dialogue;
   import com.mvc.GameFacade;
   import com.mvc.models.vos.fighting.NPCVO;
   
   public class FightingAI
   {
       
      public function FightingAI()
      {
         super();
      }
      
      public static function selectSkillAI(param1:ElfVO, param2:ElfVO) : int
      {
         if(param1.camp == "camp_of_computer")
         {
            LogUtil(FightingConfig.otherOrder + "技能ai" + FightingConfig.fightingAI);
            if(FightingLogicFactor.isPlayBack)
            {
               return FightingConfig.otherOrder.selectSkill;
            }
            if(FightingConfig.fightingAI == 0)
            {
               return selectSkillByAI0(param1,param2);
            }
         }
         return selectSkillByAI1(param1,param2);
      }
      
      private static function selectSkillByAI1(param1:ElfVO, param2:ElfVO) : int
      {
         var _loc4_:* = null;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc7_:Vector.<SkillVO> = param1.currentSkillVec;
         var _loc3_:* = -1;
         if(Math.random() * 4 < 3)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc7_[_loc8_].isRestrain && _loc7_[_loc8_].currentPP > 0)
               {
                  _loc4_ = _loc7_[_loc8_];
                  if(!(param1.skillBeforeStrone != null && param1.skillBeforeStrone == _loc4_))
                  {
                     _loc3_ = _loc8_;
                     break;
                  }
                  break;
               }
               _loc8_++;
            }
         }
         if(_loc3_ == -1 && Math.random() * 4 < 3)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc7_[_loc8_].skillAffectTarget == 1 && _loc7_[_loc8_].sort != "变化" && _loc7_[_loc8_].currentPP > 0)
               {
                  if(CalculatorFactor.calculatorNatureAdd(_loc7_[_loc8_],param2) >= 1)
                  {
                     _loc4_ = _loc7_[_loc8_];
                     if(!(param1.skillBeforeStrone != null && param1.skillBeforeStrone == _loc4_))
                     {
                        _loc3_ = _loc8_;
                        break;
                     }
                     break;
                  }
               }
               _loc8_++;
            }
         }
         if(_loc3_ == -1)
         {
            _loc3_ = Math.random() * _loc7_.length;
            _loc4_ = _loc7_[_loc3_];
         }
         if(param1.currentHp == param1.totalHp)
         {
            if(_loc4_.effectForSelf[0] == 7)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  if(_loc7_[_loc8_].effectForSelf[0] != 7)
                  {
                     _loc3_ = _loc8_;
                     break;
                  }
                  _loc8_++;
               }
            }
         }
         if(_loc4_.skillAffectTarget == 1)
         {
            if(param2.status.indexOf(_loc7_[_loc3_].status[0]) != -1)
            {
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  if(param2.status.indexOf(_loc7_[_loc8_].status[0]) == -1)
                  {
                     _loc3_ = _loc8_;
                     break;
                  }
                  _loc8_++;
               }
            }
         }
         _loc4_ = _loc7_[_loc3_];
         var _loc5_:Number = CalculatorFactor.calculatorNatureAdd(_loc4_,param2);
         if(_loc5_ == 0)
         {
            _loc3_ = Math.random() * _loc7_.length;
         }
         if(_loc4_.name == "打鼾" && param1.status.indexOf(6) != -1)
         {
            _loc3_ = Math.random() * _loc7_.length;
         }
         if(_loc4_.name == "水溅跃")
         {
            _loc3_ = Math.random() * _loc7_.length;
         }
         if(_loc4_.name == "食梦" && param2.status.indexOf(6) == -1)
         {
            _loc3_ = Math.random() * _loc7_.length;
         }
         if(_loc4_.name == "表面涂层")
         {
            if(param1.camp == "camp_of_player")
            {
               if(FightingLogicFactor.isFirstOfOurs)
               {
                  _loc3_ = Math.random() * _loc7_.length;
               }
            }
            else if(!FightingLogicFactor.isFirstOfOurs)
            {
               _loc3_ = Math.random() * _loc7_.length;
            }
         }
         if(param2.camp == "camp_of_computer")
         {
            if(_loc4_.status[0] == 6)
            {
               _loc3_ = Math.random() * _loc7_.length;
            }
         }
         _loc4_ = _loc7_[_loc3_];
         var _loc6_:* = false;
         _loc9_ = 0;
         while(_loc9_ < _loc7_.length)
         {
            if(_loc7_[_loc9_].name != "自爆" && _loc7_[_loc9_].name != "大爆炸" && _loc7_[_loc9_].id != 262)
            {
               _loc6_ = true;
               break;
            }
            _loc9_++;
         }
         if(_loc6_)
         {
            while(_loc4_.name == "自爆" || _loc4_.name == "大爆炸" || _loc4_.id == 262)
            {
               _loc3_ = Math.random() * _loc7_.length;
               _loc4_ = _loc7_[_loc3_];
            }
         }
         if(param1.status.indexOf(32) != -1 && param1.skillOfLast == _loc4_)
         {
            _loc3_ = Math.random() * _loc7_.length;
         }
         if(param1.carryProp && param1.carryProp.id == 853 && param1.skillOfFirstSelect != null)
         {
            if(_loc7_.indexOf(param1.skillOfFirstSelect) != -1)
            {
               _loc3_ = _loc7_.indexOf(param1.skillOfFirstSelect);
            }
         }
         if(param1.status.indexOf(28) != -1)
         {
            _loc3_ = Math.random() * _loc7_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc7_[_loc8_].sort == "变化" && _loc7_[_loc8_].currentPP > 0)
               {
                  _loc3_ = _loc8_;
               }
               _loc8_++;
            }
            LogUtil("同命随机选");
         }
         LogUtil("ai选择的技能" + _loc3_);
         return _loc3_;
      }
      
      private static function selectSkillByAI0(param1:ElfVO, param2:ElfVO) : int
      {
         var _loc4_:* = null;
         var _loc7_:* = 0;
         var _loc6_:Vector.<SkillVO> = param1.currentSkillVec;
         var _loc3_:* = -1;
         _loc3_ = Math.random() * _loc6_.length;
         _loc4_ = _loc6_[_loc3_];
         if(_loc4_.status[0] == 6)
         {
            _loc3_ = Math.random() * _loc6_.length;
         }
         _loc4_ = _loc6_[_loc3_];
         var _loc5_:* = false;
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            if(_loc6_[_loc7_].name != "自爆" && _loc6_[_loc7_].name != "大爆炸" && _loc6_[_loc7_].id != 262)
            {
               _loc5_ = true;
               break;
            }
            _loc7_++;
         }
         if(_loc5_)
         {
            while(_loc4_.name == "自爆" || _loc4_.name == "大爆炸" || _loc4_.id == 262)
            {
               _loc3_ = Math.random() * _loc6_.length;
               _loc4_ = _loc6_[_loc3_];
            }
         }
         if(param1.status.indexOf(32) != -1 && param1.skillOfLast == _loc4_)
         {
            _loc3_ = Math.random() * _loc6_.length;
         }
         return _loc3_;
      }
      
      public static function isRestrain(param1:ElfVO, param2:ElfVO) : Boolean
      {
         var _loc5_:* = 0;
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            return false;
         }
         var _loc3_:int = param1.currentSkillVec.length;
         var _loc4_:Vector.<SkillVO> = param1.currentSkillVec;
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            if(_loc4_[_loc5_].skillAffectTarget == 1 && _loc4_[_loc5_].sort != "变化" && _loc4_[_loc5_].currentPP > 0)
            {
               if(CalculatorFactor.calculatorNatureAdd(_loc4_[_loc5_],param2) >= 2)
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function getElfOfSuitable(param1:Vector.<ElfVO>, param2:ElfVO) : ElfVO
      {
         var _loc4_:* = 0;
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(isSuitable(param1[_loc4_],param2))
            {
               return param1[_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      private static function isSuitable(param1:ElfVO, param2:ElfVO) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param2 == null)
         {
            return false;
         }
         if(param1.currentHp == "0")
         {
            return false;
         }
         return isRestrain(param1,param2);
      }
      
      public static function selectAction(param1:ElfVO, param2:ElfVO, param3:Vector.<ElfVO>) : Boolean
      {
         targetElf = param1;
         otherElf = param2;
         targetCamp = param3;
         if(targetElf.camp == "camp_of_player")
         {
            if(FightingLogicFactor.isPlayBack)
            {
               if(FightingConfig.selfOrder.isGoOut == 1)
               {
                  var dialogur:String = "成功地逃跑了!";
                  FightingConfig.isWin = false;
                  FightingConfig.isGoOut = true;
                  FightingLogicFactor.dialogueAndNext(dialogur,"END_FIGHTING");
                  SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","flee");
                  return false;
               }
               if(FightingConfig.selfOrder.isTimeOut == 1)
               {
                  Tips.show("很抱歉，您未能在限定时间内击败对手，请再接再厉！");
                  Dialogue.collectDialogue("战斗结束\n您没能在比赛时间内赢得战斗");
                  Dialogue.playCollectDialogue(function():void
                  {
                     GameFacade.getInstance().sendNotification("next_dialogue","END_FIGHTING");
                  });
                  return false;
               }
               if(FightingConfig.selfOrder.selectElf != -1 && FightingConfig.selfOrder.selectSkill == -1)
               {
                  GameFacade.getInstance().sendNotification("change_elf_on_play_back",0,"camp_of_player");
                  return true;
               }
               GameFacade.getInstance().sendNotification("auto_select_skill");
               return false;
            }
            GameFacade.getInstance().sendNotification("auto_select_skill");
            return false;
         }
         if(NPCVO.name == null)
         {
            return false;
         }
         if(FightingLogicFactor.isPlayBack)
         {
            if(FightingConfig.otherOrder.selectElf != -1 && FightingConfig.otherOrder.selectSkill == -1)
            {
               GameFacade.getInstance().sendNotification("change_elf_on_play_back",true,"camp_of_computer");
               return true;
            }
            return false;
         }
         if(FightingConfig.selectMap && !FightingConfig.selectMap.isHard)
         {
            return false;
         }
         if(targetElf.status.indexOf(8) != -1)
         {
            return false;
         }
         if(targetElf.status.indexOf(36) != -1)
         {
            return false;
         }
         var random:int = Math.random() * 100;
         if(random > 10)
         {
            return false;
         }
         if(!isSuitable(targetElf,otherElf))
         {
            LogUtil("合适吗");
            var changeElf:ElfVO = getElfOfSuitable(targetCamp,otherElf);
            if(changeElf != null)
            {
               LogUtil("自动换精灵" + targetElf.camp);
               FightingConfig.isPlayerActAfterChangeElf = true;
               NPCVO.isChangeElf = true;
               GameFacade.getInstance().sendNotification("update_fighting_ele",changeElf,targetElf.camp);
               return true;
            }
            return false;
         }
         return false;
      }
      
      public static function getNextElf(param1:Vector.<ElfVO>, param2:ElfVO) : ElfVO
      {
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = -1;
         if(param2)
         {
            _loc4_ = param1.indexOf(param2);
         }
         LogUtil(param2 + "当前精灵索引" + _loc4_);
         _loc3_ = _loc4_ + 1;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != null && param1[_loc3_].currentHp > 0)
            {
               _loc5_ = param1[_loc3_];
               break;
            }
            _loc3_++;
         }
         if(_loc5_ == null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(param1[_loc3_] != null && param1[_loc3_].currentHp > 0)
               {
                  _loc5_ = param1[_loc3_];
                  break;
               }
               _loc3_++;
            }
         }
         return _loc5_;
      }
   }
}
