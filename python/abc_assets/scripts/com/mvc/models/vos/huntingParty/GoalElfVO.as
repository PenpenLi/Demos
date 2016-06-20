package com.mvc.models.vos.huntingParty
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class GoalElfVO
   {
       
      public var lessTime:int;
      
      public var goalElfVo:ElfVO;
      
      public var nodeId:Array;
      
      public var state:int;
      
      public var rewardObj:Object;
      
      public function GoalElfVO()
      {
         nodeId = [];
         super();
      }
   }
}
