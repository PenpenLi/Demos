package com.mvc.models.vos.elf
{
   public class FeatureVO
   {
       
      public var id:String;
      
      public var name:String;
      
      public var abilityAddOnSpecialSta:Array;
      
      public var statusOfCannotInto:String;
      
      public var addSkillPower:Array;
      
      public function FeatureVO()
      {
         abilityAddOnSpecialSta = [];
         addSkillPower = [];
         super();
      }
   }
}
