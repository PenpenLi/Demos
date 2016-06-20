package com.mvc.models.vos.mainCity.train
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class TrialDifficultyVO
   {
       
      public var id:uint;
      
      public var difficultyLv:String;
      
      public var pokePicture:String;
      
      public var openLv:uint;
      
      public var dropPropIdArr:Array;
      
      public var elfVOVec:Vector.<ElfVO>;
      
      public var bossImg:String;
      
      public var bossName:String;
      
      public var bossDesc:String;
      
      public var bossId:uint;
      
      public function TrialDifficultyVO()
      {
         dropPropIdArr = [];
         elfVOVec = Vector.<ElfVO>([]);
         super();
      }
   }
}
