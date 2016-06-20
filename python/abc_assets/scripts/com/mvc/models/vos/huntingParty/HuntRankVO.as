package com.mvc.models.vos.huntingParty
{
   public class HuntRankVO
   {
      
      public static var lessTime:int;
      
      public static var rewardVec:Vector.<com.mvc.models.vos.huntingParty.RankRewardVO> = new Vector.<com.mvc.models.vos.huntingParty.RankRewardVO>([]);
      
      public static var myRank:int;
      
      public static var myScore:int;
      
      public static var allRankVec:Vector.<com.mvc.models.vos.huntingParty.RankVO> = new Vector.<com.mvc.models.vos.huntingParty.RankVO>([]);
       
      public function HuntRankVO()
      {
         super();
      }
   }
}
