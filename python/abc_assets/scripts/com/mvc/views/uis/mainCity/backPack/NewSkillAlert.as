package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.elf.SkillVO;
   import com.mvc.models.proxy.mainCity.train.TrainPro;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.myElf.SkillInfoTipsUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import com.common.util.dialogue.Dialogue;
   import extend.SoundEvent;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class NewSkillAlert extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.backPack.NewSkillAlert;
      
      public static var isReCallSkill:Boolean;
       
      private var rootClass:Game;
      
      private var spr_Alert:SwfSprite;
      
      private var status:TextField;
      
      private var type:TextField;
      
      private var power:TextField;
      
      private var rate:TextField;
      
      private var pp:TextField;
      
      private var skillDec:TextField;
      
      private var btn_yes:FeathersButton;
      
      private var btn_no:SwfButton;
      
      private var elfName:TextField;
      
      private var skillName:TextField;
      
      private var skillContain:Sprite;
      
      private var _elfVo:ElfVO;
      
      private var swf:Swf;
      
      private var skillIcon:SwfImage;
      
      public var index:int;
      
      private var _skillVo:SkillVO;
      
      private var tf_tips:TextField;
      
      private var temSkillVO:SkillVO;
      
      private var isShowskill:Boolean;
      
      public function NewSkillAlert()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         rootClass = Config.starling.root as Game;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("bag");
         spr_Alert = swf.createSprite("spr_Alert");
         elfName = spr_Alert.getTextField("elfName");
         skillName = spr_Alert.getTextField("skillName");
         status = spr_Alert.getTextField("status");
         type = spr_Alert.getTextField("type");
         power = spr_Alert.getTextField("power");
         rate = spr_Alert.getTextField("rate");
         pp = spr_Alert.getTextField("pp");
         skillDec = spr_Alert.getTextField("skillDec");
         tf_tips = spr_Alert.getTextField("tf_tips");
         tf_tips.x = tf_tips.x + 50;
         tf_tips.hAlign = "left";
         tf_tips.autoSize = "horizontal";
         tf_tips.text = "遗忘的技能可以在精灵研究中心-技能回忆找回";
         skillDec.autoScale = true;
         btn_yes = spr_Alert.getChildByName("btn_yes") as FeathersButton;
         btn_no = spr_Alert.getButton("btn_no");
         spr_Alert.x = (1136 - spr_Alert.width) / 2;
         spr_Alert.y = (640 - spr_Alert.height) / 2;
         addChild(spr_Alert);
         addSkillContain();
         addSeleIcon();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.backPack.NewSkillAlert
      {
         return instance || new com.mvc.views.uis.mainCity.backPack.NewSkillAlert();
      }
      
      private function addSkillContain() : void
      {
         skillContain = new Sprite();
         skillContain.x = 40;
         skillContain.y = 340;
         spr_Alert.addChild(skillContain);
      }
      
      private function addSeleIcon() : void
      {
         skillIcon = swf.createImage("img_seleIcon");
         skillIcon.x = 100;
         skillIcon.y = 372;
         spr_Alert.addChild(skillIcon);
         skillIcon.visible = false;
      }
      
      public function show(param1:ElfVO, param2:SkillVO) : void
      {
         TrainPro.isSeleSkill = true;
         CalculatorFactor.isLearnSkill = true;
         skillIcon.visible = false;
         btn_yes.isEnabled = false;
         _elfVo = param1;
         _skillVo = param2;
         elfName.text = param1.nickName;
         skillName.text = param2.name;
         status.text = param2.property;
         type.text = param2.sort;
         power.text = param2.power;
         if(param2.hitRate > 100)
         {
            rate.text = "--";
         }
         else
         {
            rate.text = param2.hitRate;
         }
         pp.text = param2.totalPP;
         skillDec.text = param2.descs;
         addSkill();
         this.scaleX = Config.scaleX;
         this.scaleY = Config.scaleY;
         rootClass.parent.addChild(this);
         btn_no.addEventListener("triggered",click);
         btn_yes.addEventListener("triggered",seleOk);
      }
      
      private function addSkill() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         skillContain.removeChildren(0,-1,true);
         _loc1_ = 0;
         while(_loc1_ < _elfVo.currentSkillVec.length)
         {
            _loc2_ = new SkillUnitUI();
            _loc2_.mySkillVo = _elfVo.currentSkillVec[_loc1_];
            _loc2_.name = _loc1_.toString();
            _loc2_.x = 167 * _loc1_;
            skillContain.addChild(_loc2_);
            _loc2_.addEventListener("touch",ontouch);
            _loc1_++;
         }
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(param1.currentTarget as SkillUnitUI);
         if(_loc2_ && _loc2_.phase == "began")
         {
            isShowskill = false;
         }
         if(_loc2_ && _loc2_.phase == "moved")
         {
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(isShowskill)
            {
               SkillInfoTipsUI.getInstance().removeSkillTips();
            }
            else
            {
               skillIcon.visible = true;
               btn_yes.isEnabled = true;
               index = (param1.currentTarget as SkillUnitUI).name;
               skillIcon.x = 167 * index + 162;
               LogUtil("index = ",index);
            }
         }
      }
      
      private function click() : void
      {
         remove();
         CalculatorFactor.learnSkillHandler(_elfVo);
      }
      
      private function seleOk() : void
      {
         remove();
         if(CalculatorFactor.learnByLvUp)
         {
            CalculatorFactor.learnByLvUp = false;
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3013(_elfVo.id,_skillVo.id,index,null,0,forgetDialue);
         }
         else
         {
            Facade.getInstance().sendNotification("learn_new_skill_request",index);
         }
      }
      
      private function giveUpSkillHandler(param1:Event) : void
      {
         EventCenter.removeEventListener("GIVE_UP_SKILL_SUCCESS",giveUpSkillHandler);
         Dialogue.touch = false;
         learnNewSkill();
      }
      
      private function learnNewSkill() : void
      {
         if(CalculatorFactor.learnByLvUp)
         {
            CalculatorFactor.learnByLvUp = false;
            if(_elfVo.currentSkillVec.length >= 4)
            {
               _elfVo.currentSkillVec[index] = null;
               _elfVo.currentSkillVec[index] = _skillVo;
            }
            else
            {
               _elfVo.currentSkillVec.push(_skillVo);
            }
            Facade.getInstance().sendNotification("next_dialogue","prop_be_used");
            var startDia:Function = function():void
            {
               Dialogue.collectDialogue(_elfVo.nickName + "已经遗忘" + _elfVo.currentSkillVec[index].name);
               Dialogue.playCollectDialogue(updateDialue);
            };
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3007(_elfVo.id,_skillVo.id,index,startDia);
         }
         else
         {
            Dialogue.updateDialogue(_elfVo.nickName + "已经遗忘" + _elfVo.currentSkillVec[index].name);
            Facade.getInstance().sendNotification("learn_new_skill_request",index);
         }
      }
      
      private function updateDialue() : void
      {
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         CalculatorFactor.learnSkillHandler(_elfVo);
         Dialogue.updateDialogue(_elfVo.name + "学会了" + _skillVo.name,true,"share_exp",true);
      }
      
      private function forgetDialue() : void
      {
         LogUtil("获得经验升级，遗忘技能对话播放开始。。。。。。。。。。。。。。。。。");
         Dialogue.touch = false;
         Dialogue.collectDialogue(_elfVo.nickName + "已经遗忘" + _elfVo.currentSkillVec[index].name);
         temSkillVO = _skillVo;
         Dialogue.playCollectDialogue(learnDialue);
         if(_elfVo.currentSkillVec.length >= 4)
         {
            _elfVo.currentSkillVec[index] = null;
            _elfVo.currentSkillVec[index] = _skillVo;
         }
         else
         {
            _elfVo.currentSkillVec.push(_skillVo);
         }
      }
      
      private function learnDialue() : void
      {
         CalculatorFactor.learnSkillHandler(_elfVo);
         Dialogue.updateDialogue(_elfVo.nickName + "学会了" + temSkillVO.name,true,"share_exp",true);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","upgrade");
         temSkillVO = null;
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
         }
      }
   }
}
