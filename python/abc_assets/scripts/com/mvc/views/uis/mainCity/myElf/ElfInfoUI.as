package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.mvc.models.vos.elf.ElfVO;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.events.Event;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   
   public class ElfInfoUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.mainCity.myElf.ElfInfoUI;
       
      private var swf:Swf;
      
      public var spr_info:SwfSprite;
      
      public var num:TextField;
      
      public var elfName:TextField;
      
      public var nature:TextField;
      
      public var currentHp:TextField;
      
      public var totalHp:TextField;
      
      public var Attack:TextField;
      
      public var Defense:TextField;
      
      public var super_attack:TextField;
      
      public var spuer_defense:TextField;
      
      public var speed:TextField;
      
      public var nowExp:TextField;
      
      public var nextLvExp:TextField;
      
      public var petName:TextField;
      
      public var lv:TextField;
      
      public var character:TextField;
      
      public var elfHP:SwfSprite;
      
      public var carryThing:TextField;
      
      public var hp:SwfScale9Image;
      
      private var _elfVO:ElfVO;
      
      public var btn_showElf:SwfButton;
      
      public var btn_species:SwfButton;
      
      private var man:SwfImage;
      
      private var woman:SwfImage;
      
      private var yellow:SwfScale9Image;
      
      private var red:SwfScale9Image;
      
      private var isLight:TextField;
      
      private var rare:TextField;
      
      private var exp:SwfScale9Image;
      
      private var newSkill1:TextField;
      
      private var newSkill0:TextField;
      
      private var newSkill2:TextField;
      
      private var newSkill4:TextField;
      
      private var loadingSwf:Swf;
      
      private var feature:TextField;
      
      public function ElfInfoUI()
      {
         super();
         init();
         addEventListener("triggered",clickHandler);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.ElfInfoUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.ElfInfoUI();
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_showElf !== _loc2_)
         {
            if(btn_species === _loc2_)
            {
               ElfSpeciesTipsUI.getInstance().showSpecies(_elfVO);
            }
         }
         else
         {
            if(WorldTime.showElfTime > 0)
            {
               return Tips.show("距离下一次展示精灵还有 " + WorldTime.showElfTime + " 秒！");
            }
            if(_elfVO.rareValue >= 4)
            {
               (Facade.getInstance().retrieveProxy("ChatPro") as ChatPro).write2009(1,_elfVO.id);
            }
            else
            {
               Tips.show("只有史诗和传说的精灵才可以展示哦");
            }
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         loadingSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_info = swf.createSprite("spr_info");
         num = spr_info.getTextField("num");
         elfName = spr_info.getTextField("elfName");
         nature = spr_info.getTextField("nature");
         currentHp = spr_info.getTextField("currentHp");
         totalHp = spr_info.getTextField("totalHp");
         Attack = spr_info.getTextField("Attack");
         Defense = spr_info.getTextField("Defense");
         super_attack = spr_info.getTextField("super_attack");
         spuer_defense = spr_info.getTextField("spuer_defense");
         speed = spr_info.getTextField("speed");
         isLight = spr_info.getTextField("isLight");
         carryThing = spr_info.getTextField("carryThing");
         nowExp = spr_info.getTextField("nowExp");
         nextLvExp = spr_info.getTextField("nextLvExp");
         petName = spr_info.getTextField("petName");
         lv = spr_info.getTextField("lv");
         character = spr_info.getTextField("character");
         rare = spr_info.getTextField("rare");
         feature = spr_info.getTextField("feature");
         elfHP = spr_info.getSprite("elfHP");
         hp = elfHP.getScale9Image("hp");
         yellow = elfHP.getScale9Image("yellow");
         red = elfHP.getScale9Image("red");
         woman = loadingSwf.createImage("img_woman");
         man = loadingSwf.createImage("img_man");
         exp = spr_info.getScale9Image("exp");
         newSkill0 = spr_info.getTextField("newSkill0");
         newSkill1 = spr_info.getTextField("newSkill1");
         newSkill2 = spr_info.getTextField("newSkill2");
         newSkill4 = spr_info.getTextField("newSkill4");
         btn_showElf = spr_info.getButton("btn_showElf");
         btn_species = spr_info.getButton("btn_species");
         addChild(spr_info);
         var _loc1_:* = 65;
         man.x = _loc1_;
         woman.x = _loc1_;
         _loc1_ = 365;
         man.y = _loc1_;
         woman.y = _loc1_;
         spr_info.addChild(woman);
         spr_info.addChild(man);
         petName.width = 150;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         num.text = param1.elfId;
         elfName.text = param1.name;
         if(param1.nature.length > 1)
         {
            nature.text = param1.nature[0] + " | " + param1.nature[1];
         }
         else
         {
            nature.text = param1.nature[0];
         }
         rare.text = param1.rare;
         currentHp.text = param1.currentHp;
         totalHp.text = param1.totalHp;
         Attack.text = param1.attack;
         Defense.text = param1.defense;
         super_attack.text = param1.super_attack;
         spuer_defense.text = param1.super_defense;
         speed.text = param1.speed;
         carryThing.text = "无";
         if(param1.carryProp)
         {
            carryThing.text = param1.carryProp.name;
         }
         if(param1.elfId > 10000 && param1.elfId < 20000)
         {
            isLight.text = "是";
         }
         else
         {
            isLight.text = "否";
         }
         var _loc3_:Number = CalculatorFactor.calculatorLvNeedExp(param1,param1.lv);
         var _loc2_:Number = (param1.currentExp - _loc3_) / (param1.nextLvExp - _loc3_);
         nowExp.text = Math.round(param1.currentExp - _loc3_);
         nextLvExp.text = Math.round(param1.nextLvExp - _loc3_);
         exp.scaleX = _loc2_;
         petName.text = param1.nickName;
         lv.text = param1.lv;
         character.text = param1.character;
         if(param1.featureVO)
         {
            feature.text = param1.featureVO.name;
         }
         else
         {
            feature.text = "未开放";
         }
         if(getNextLv(param1))
         {
            newSkill1.text = getNextLv(param1);
            newSkill4.text = "新技能:";
            newSkill0.text = "至";
            newSkill2.text = "级可学会";
         }
         else
         {
            newSkill0.text = "";
            newSkill1.text = "";
            newSkill2.text = "";
            newSkill4.text = "";
         }
         if(param1.sex == 0)
         {
            switchSex(false);
         }
         else if(param1.sex == 1)
         {
            switchSex(true);
         }
         else
         {
            var _loc4_:* = false;
            woman.visible = _loc4_;
            man.visible = _loc4_;
         }
         showHpState(param1.currentHp / param1.totalHp);
      }
      
      private function getNextLv(param1:ElfVO) : int
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.totalSkillVec.length)
         {
            if(param1.totalSkillVec[_loc2_].lvNeed > param1.lv)
            {
               return param1.totalSkillVec[_loc2_].lvNeed;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function showHpState(param1:Number) : void
      {
         if(param1 >= 0.5)
         {
            hp.visible = true;
            var _loc2_:* = false;
            red.visible = _loc2_;
            yellow.visible = _loc2_;
            hp.scaleX = param1;
         }
         else if(param1 < 0.5 && param1 > 0.15)
         {
            yellow.visible = true;
            _loc2_ = false;
            red.visible = _loc2_;
            hp.visible = _loc2_;
            yellow.scaleX = param1;
         }
         else
         {
            red.visible = true;
            _loc2_ = false;
            yellow.visible = _loc2_;
            hp.visible = _loc2_;
            red.scaleX = param1;
         }
      }
      
      private function switchSex(param1:Boolean) : void
      {
         man.visible = param1;
         woman.visible = !param1;
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
   }
}
