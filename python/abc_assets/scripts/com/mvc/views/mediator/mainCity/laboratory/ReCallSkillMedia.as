package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.laboratory.RecallSkillUI;
   import starling.display.DisplayObject;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.TouchEvent;
   import com.mvc.views.uis.mainCity.myElf.SkillInfoTipsUI;
   import starling.events.Touch;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class ReCallSkillMedia extends Mediator
   {
      
      public static const NAME:String = "ReCallSkillMedia";
       
      public var recallSkill:RecallSkillUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      private var selectedElfVO:ElfVO;
      
      public function ReCallSkillMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("ReCallSkillMedia",param1);
         recallSkill = param1 as RecallSkillUI;
         recallSkill.addEventListener("triggered",triggeredHandler);
         recallSkill.addEventListener("touch",recall_touchHandler);
      }
      
      private function recall_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = 0;
         if(recallSkill.replaceContainer.isScrolling)
         {
            SkillInfoTipsUI.getInstance().removeSkillTips();
            return;
         }
         var _loc3_:Touch = param1.getTouch(recallSkill.spr_recallSkill);
         if(_loc3_)
         {
            if(!(param1.target as DisplayObject).name)
            {
               return;
            }
            if(_loc3_.phase == "began")
            {
               if((param1.target as DisplayObject).name.substr(0,3) == "own")
               {
                  _loc2_ = (param1.target as DisplayObject).name.substr(3);
                  SkillInfoTipsUI.getInstance().showSkillTips(selectedElfVO.currentSkillVec[_loc2_],recallSkill.ownSkillUnitSprVec[_loc2_]);
               }
               else if((param1.target as DisplayObject).name.substr(0,3) == "rep")
               {
                  _loc2_ = (param1.target as DisplayObject).name.substr(3);
                  SkillInfoTipsUI.getInstance().showSkillTips(recallSkill.skillVec[_loc2_],recallSkill.repSkillUnitSprVec[_loc2_]);
               }
            }
            if(_loc3_.phase == "ended")
            {
               if((param1.target as DisplayObject).name.substr(0,3) == "own")
               {
                  recallSkill.ownSelectedIndex = (param1.target as DisplayObject).name.substr(3);
                  recallSkill.updateOwnSkillState();
                  SkillInfoTipsUI.getInstance().removeSkillTips();
                  PlayerVO.isAcceptPvp = false;
               }
               else if((param1.target as DisplayObject).name.substr(0,3) == "rep")
               {
                  recallSkill.repSelectedIndex = (param1.target as DisplayObject).name.substr(3);
                  recallSkill.updateRepSkillState();
                  SkillInfoTipsUI.getInstance().removeSkillTips();
                  PlayerVO.isAcceptPvp = false;
               }
            }
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(recallSkill.btn_return !== _loc3_)
         {
            if(recallSkill.btn_seleElf !== _loc3_)
            {
               if(recallSkill.btn_skillChangeBtn === _loc3_)
               {
                  LogUtil("当前选中的已有，可回忆技能索引。。。。" + recallSkill.ownSelectedIndex,recallSkill.repSelectedIndex);
                  if(recallSkill.ownSelectedIndex == -1 || recallSkill.repSelectedIndex == -1)
                  {
                     return Tips.show("还没选择好技能呢。");
                  }
                  if(!recallSkill.propVO || recallSkill.propVO.count < 1)
                  {
                     return Tips.show("亲，心之鳞片不足哦。");
                  }
                  _loc2_ = Alert.show("是否遗忘\"<font color = \'#004c8c\'>" + selectedElfVO.currentSkillVec[recallSkill.ownSelectedIndex].name + "</font>\"" + "回忆" + "\"<font color = \'#004c8c\'>" + recallSkill.skillVec[recallSkill.repSelectedIndex].name + "</font>\"" + "\n需要消耗一枚：" + "<font color = \'#004c8c\'>心之鳞片</font>","",new ListCollection([{"label":"好的"},{"label":"不用了"}]));
                  _loc2_.addEventListener("close",usePropAlert_closeHandler);
               }
            }
            else
            {
               recallSkill.seleElf();
            }
         }
         else
         {
            remove();
         }
      }
      
      private function usePropAlert_closeHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "好的")
         {
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3013(selectedElfVO.id,recallSkill.skillVec[recallSkill.repSelectedIndex].id,recallSkill.ownSelectedIndex,recallSkill.propVO,1,forgetDialue);
         }
      }
      
      private function forgetDialue() : void
      {
         Dialogue.collectDialogue(selectedElfVO.nickName + "已经遗忘" + selectedElfVO.currentSkillVec[recallSkill.ownSelectedIndex].name);
         Dialogue.playCollectDialogue(learnDialue);
      }
      
      private function learnDialue() : void
      {
         Dialogue.updateDialogue(selectedElfVO.nickName + "学会了" + recallSkill.skillVec[recallSkill.repSelectedIndex].name,true);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         sendNotification("update_recallskill_panel");
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_RECALLSKILL_ELF" !== _loc2_)
         {
            if("update_recallskill_panel" !== _loc2_)
            {
               if("recallskill_use_prop_success" !== _loc2_)
               {
                  if("CLOSE_RECALLSKILL" === _loc2_)
                  {
                     remove();
                  }
               }
            }
            else
            {
               selectedElfVO.currentSkillVec[recallSkill.ownSelectedIndex] = recallSkill.skillVec[recallSkill.repSelectedIndex];
               recallSkill.ownSelectedIndex = -1;
               recallSkill.repSelectedIndex = -1;
               recallSkill.myElfVo = selectedElfVO;
               recallSkill.updatePropNum();
               PlayerVO.isAcceptPvp = true;
            }
         }
         else
         {
            recallSkill.ownSelectedIndex = -1;
            recallSkill.repSelectedIndex = -1;
            SelectElfUI.getIntance().removeFromParent();
            selectedElfVO = param1.getBody() as ElfVO;
            recallSkill.myElfVo = selectedElfVO;
            PlayerVO.isAcceptPvp = true;
         }
      }
      
      private function remove() : void
      {
         if(recallSkill.image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(recallSkill.image);
         }
         dispose();
         sendNotification("SHOW_MENU");
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_RECALLSKILL_ELF","CLOSE_RECALLSKILL","update_recallskill_panel","recallskill_use_prop_success"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            SelectElfUI.getIntance().removeFromParent();
         }
         facade.removeMediator("ReCallSkillMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
