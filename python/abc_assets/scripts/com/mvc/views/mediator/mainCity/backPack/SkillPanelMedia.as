package com.mvc.views.mediator.mainCity.backPack
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.backPack.SkillPanelUI;
   import com.mvc.models.vos.elf.SkillVO;
   import starling.events.Event;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import starling.display.DisplayObject;
   
   public class SkillPanelMedia extends Mediator
   {
      
      public static const NAME:String = "SkillPanelMedia";
      
      public static var startIndex:int;
       
      private var skillPanel:SkillPanelUI;
      
      private var isLearnNewSkill:Boolean;
      
      private var newSkill:SkillVO;
      
      private var selectSkillVo:SkillVO;
      
      public function SkillPanelMedia(param1:Object = null)
      {
         super("SkillPanelMedia",param1);
         skillPanel = param1 as SkillPanelUI;
         skillPanel.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(skillPanel.btn_close === _loc2_)
         {
            remove();
         }
      }
      
      private function remove() : void
      {
         if(isLearnNewSkill == true)
         {
            CalculatorFactor.learnSkillHandler(skillPanel.myElfVo);
         }
         isLearnNewSkill = false;
         newSkill = null;
         sendNotification("switch_win",null);
         skillPanel.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("show_elf_skill" !== _loc2_)
         {
            if("learn_new_skill" !== _loc2_)
            {
               if("skill_pp_up" !== _loc2_)
               {
                  if("give_up_skill_success" === _loc2_)
                  {
                     giveUpSkillHandler(selectSkillVo);
                  }
               }
               else if(isLearnNewSkill)
               {
                  isLearnNewSkill = false;
                  selectSkillVo = param1.getBody() as SkillVO;
                  (facade.retrieveProxy("BackPackPro") as BackPackPro).write3006(skillPanel.myElfVo.id,selectSkillVo.id);
               }
            }
            else
            {
               skillPanel.myElfVo = param1.getBody().targetElf;
               newSkill = param1.getBody().newSkill;
               isLearnNewSkill = true;
               setPrompt();
            }
         }
         else
         {
            skillPanel.myElfVo = param1.getBody() as ElfVO;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["show_elf_skill","learn_new_skill","skill_pp_up","give_up_skill_success"];
      }
      
      private function setPrompt() : void
      {
         skillPanel.prompt.y = 60;
         skillPanel.prompt.text = "<font color=\'#F3077C\' size=\'25\'>      " + skillPanel.myElfVo.nickName + " </font>" + "<font color=\'#B94600\' size=\'25\'>要遗忘哪项技能? </font>" + "\n" + "<font color=\'#B94600\' size=\'25\'>           新技能: </font>" + "<font color=\'#F3077C\' size=\'25\'>" + newSkill.name + "</font>" + "\n" + "<font color=\'#0C4784\' size=\'20\'>替换技能会返回该技能升级所消耗的金币 </font>" + "\n";
      }
      
      private function giveUpSkillHandler(param1:SkillVO) : void
      {
         startIndex = skillPanel.myElfVo.currentSkillVec.indexOf(param1);
         Dialogue.touch = false;
         Dialogue.collectDialogue(skillPanel.myElfVo.nickName + "已经遗忘" + param1.name);
         LogUtil("已经遗忘+++++++++++++++++++++++");
         Dialogue.playCollectDialogue(learnNewSkill);
      }
      
      private function learnNewSkill() : void
      {
         if(CalculatorFactor.learnByLvUp)
         {
            CalculatorFactor.learnByLvUp = false;
            if(skillPanel.myElfVo.currentSkillVec.length >= 4)
            {
               skillPanel.myElfVo.currentSkillVec[startIndex] = null;
               skillPanel.myElfVo.currentSkillVec[startIndex] = newSkill;
            }
            else
            {
               skillPanel.myElfVo.currentSkillVec.push(newSkill);
            }
            sendNotification("next_dialogue","prop_be_used");
            Dialogue.updateDialogue(skillPanel.myElfVo.name + "学会了" + newSkill.name);
            (facade.retrieveProxy("BackPackPro") as BackPackPro).write3007(skillPanel.myElfVo.id,newSkill.id,startIndex,updateDialue);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         }
         else
         {
            sendNotification("learn_new_skill_request",startIndex);
         }
      }
      
      private function updateDialue() : void
      {
         CalculatorFactor.learnSkillHandler(skillPanel.myElfVo);
         Dialogue.updateDialogue(skillPanel.myElfVo.name + "学会了" + newSkill.name,true,"share_exp",true);
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("SkillPanelMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
