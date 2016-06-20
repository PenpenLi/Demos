package com.mvc.models.vos.mainCity.trial
{
   import com.mvc.models.vos.mainCity.train.TrialDifficultyVO;
   
   public class TrialBossVO
   {
       
      public var bossId:uint;
      
      public var bossImg:String;
      
      public var bossName:String;
      
      public var bossDesc:String;
      
      public var openData:uint;
      
      public var challengeTimes:uint;
      
      public var difficultyVec:Vector.<TrialDifficultyVO>;
      
      public function TrialBossVO()
      {
         difficultyVec = Vector.<TrialDifficultyVO>([]);
         super();
      }
   }
}
