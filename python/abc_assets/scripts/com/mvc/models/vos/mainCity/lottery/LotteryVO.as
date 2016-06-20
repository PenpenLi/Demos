package com.mvc.models.vos.mainCity.lottery
{
   public class LotteryVO
   {
      
      public static var costDiamond:int;
      
      public static var currentTimes:int;
      
      public static var endTime:int;
      
      public static var startTime:int;
      
      public static var upTotalRes:int;
      
      public static var payList:Array = [];
      
      public static var rewardList:Vector.<com.mvc.models.vos.mainCity.lottery.LotteryRewardVO> = new Vector.<com.mvc.models.vos.mainCity.lottery.LotteryRewardVO>([]);
       
      public function LotteryVO()
      {
         super();
      }
   }
}
