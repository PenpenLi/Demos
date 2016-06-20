package com.mvc.models.vos.elf
{
   public class SkillVO
   {
       
      public var id:String = "0";
      
      public var name:String;
      
      public var property:String;
      
      public var skillEffectName:String = "mc_1_m";
      
      public var totalPP:int;
      
      public var currentPP:String;
      
      public var power:String;
      
      public var hitRate:Number;
      
      public var descs:String;
      
      public var lvNeed:int;
      
      public var skillPriority:int;
      
      public var sort:String;
      
      public var lv:String = "0";
      
      public var skillAffectTarget:int = 1;
      
      public var isKillArray:Array;
      
      public var isStoreGas:int = 0;
      
      public var focusHitLv:int = 1;
      
      public var attackNum:Array;
      
      public var hurtNumFix:Array;
      
      public var badEffect:Array;
      
      public var effectForOther:Array;
      
      public var effectForSelf:Array;
      
      public var effectForAblilityLv:Array;
      
      public var status:Array;
      
      public var continueSkillCount:int = 0;
      
      public var soundName:String;
      
      public var isRestrain:Boolean;
      
      public var isNoEffect:Boolean;
      
      public var isNoSuggest:Boolean;
      
      public var isNoGoodEffect:Boolean;
      
      public var successRate:int = 100;
      
      public function SkillVO()
      {
         isKillArray = [0,0];
         attackNum = [1];
         hurtNumFix = [0,0];
         badEffect = [0,0];
         effectForOther = [0,0,0];
         effectForSelf = [0,0];
         effectForAblilityLv = [[],0,0];
         status = [0,100];
         super();
      }
   }
}
