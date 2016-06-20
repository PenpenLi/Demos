package com.common.util
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   
   public class ShowElfAbility extends Sprite
   {
      
      private static var instance:com.common.util.ShowElfAbility;
       
      public var abilityUpDesc:SwfSprite;
      
      private var root:Game;
      
      private var currentElf:ElfVO;
      
      private var isRemove:Boolean;
      
      public function ShowElfAbility()
      {
         super();
         root = Config.starling.root as Game;
         var _loc2_:Quad = new Quad(1136,640,0);
         _loc2_.alpha = 0;
         addChild(_loc2_);
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         abilityUpDesc = _loc1_.createSprite("spr_abilityUpDesc_s");
         abilityUpDesc.x = 860;
         abilityUpDesc.y = 300;
         addChild(abilityUpDesc);
         this.addEventListener("touch",touchHandler);
         this.name = "showElfAbility";
      }
      
      public static function getInstance() : com.common.util.ShowElfAbility
      {
         return instance || new com.common.util.ShowElfAbility();
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.getTouch(this);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            if(isRemove)
            {
               removeFromParent();
            }
            else
            {
               showAbility(currentElf);
            }
         }
      }
      
      public function show(param1:ElfVO, param2:int) : void
      {
         LogUtil(" 升级前后的等级差=====",param1.nickName,param1.lv,param1.currentExp);
         if(Config.isAutoFighting)
         {
            return;
         }
         currentElf = param1;
         param1.lv = param1.lv - param2;
         CalculatorFactor.calculatorElf(param1);
         var _loc3_:Object = {};
         _loc3_.hp = param1.totalHp;
         _loc3_.attack = param1.attack;
         _loc3_.defense = param1.defense;
         _loc3_.supAttack = param1.super_attack;
         _loc3_.supDefense = param1.super_defense;
         _loc3_.speed = param1.speed;
         param1.lv = param1.lv + param2;
         CalculatorFactor.calculatorElf(param1);
         abilityUpDesc.getTextField("hpAdd").text = "+" + (param1.totalHp - _loc3_.hp);
         abilityUpDesc.getTextField("attackAdd").text = "+" + (param1.attack - _loc3_.attack);
         abilityUpDesc.getTextField("defenceAdd").text = "+" + (param1.defense - _loc3_.defense);
         abilityUpDesc.getTextField("supAttackAdd").text = "+" + (param1.super_attack - _loc3_.supAttack);
         abilityUpDesc.getTextField("supDefenceAdd").text = "+" + (param1.super_defense - _loc3_.supDefense);
         abilityUpDesc.getTextField("speedAdd").text = "+" + (param1.speed - _loc3_.speed);
         root.addChild(this);
         isRemove = false;
         _loc3_ = null;
      }
      
      private function showAbility(param1:ElfVO) : void
      {
         abilityUpDesc.getTextField("hpAdd").text = "" + Math.round(param1.totalHp);
         abilityUpDesc.getTextField("attackAdd").text = "" + param1.attack;
         abilityUpDesc.getTextField("defenceAdd").text = "" + param1.defense;
         abilityUpDesc.getTextField("supAttackAdd").text = "" + param1.super_attack;
         abilityUpDesc.getTextField("supDefenceAdd").text = "" + param1.super_defense;
         abilityUpDesc.getTextField("speedAdd").text = "" + param1.speed;
         isRemove = true;
      }
   }
}
