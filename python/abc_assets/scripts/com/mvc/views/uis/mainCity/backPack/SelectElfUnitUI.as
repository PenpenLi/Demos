package com.mvc.views.uis.mainCity.backPack
{
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class SelectElfUnitUI extends ElfBgUnitUI
   {
       
      public function SelectElfUnitUI()
      {
         super();
      }
      
      override public function initEvent() : void
      {
         addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:Touch = param1.getTouch(img);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(Facade.getInstance().hasMediator("SetNameMedia"))
               {
                  Facade.getInstance().sendNotification("SEND_SETENAME_ELF",myElfVO);
                  return;
               }
               if(Facade.getInstance().hasMediator("TrainRoomMedia"))
               {
                  Facade.getInstance().sendNotification("SEND_TRAIN_ELF",myElfVO);
                  return;
               }
               if(Facade.getInstance().hasMediator("ReCallSkillMedia"))
               {
                  if(myElfVO.currentSkillVec.length < 4)
                  {
                     return Tips.show("精灵技能不满4个，无法回忆");
                  }
                  Facade.getInstance().sendNotification("SEND_RECALLSKILL_ELF",myElfVO);
                  return;
               }
               if(Facade.getInstance().hasMediator("ResetCharacterMediator"))
               {
                  Facade.getInstance().sendNotification("close_resetcharacter_elf",myElfVO);
                  return;
               }
               if(_elfVO.currentHp <= 0)
               {
                  Tips.show("不能放入濒死的精灵");
                  return;
               }
               _loc3_ = 0;
               while(_loc3_ < PlayerVO.FormationElfVec.length)
               {
                  if(PlayerVO.FormationElfVec[_loc3_] != null)
                  {
                     if(PlayerVO.FormationElfVec[_loc3_].id == _elfVO.id)
                     {
                        Tips.show("【" + _elfVO.nickName + "】是联盟大赛的防守精灵，不能放入");
                        return;
                     }
                  }
                  _loc3_++;
               }
               _loc4_ = 0;
               while(_loc4_ < PlayerVO.playElfVec.length)
               {
                  if(PlayerVO.playElfVec[_loc4_] != null)
                  {
                     if(PlayerVO.playElfVec[_loc4_].id == _elfVO.id)
                     {
                        Tips.show("【" + _elfVO.nickName + "】是联盟大赛的出战精灵，不能放入");
                        return;
                     }
                  }
                  _loc4_++;
               }
               Facade.getInstance().sendNotification("SELECT_ELF_INFO",myElfVO);
            }
         }
      }
   }
}
