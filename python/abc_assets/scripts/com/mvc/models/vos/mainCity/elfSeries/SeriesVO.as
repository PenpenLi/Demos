package com.mvc.models.vos.mainCity.elfSeries
{
   public class SeriesVO
   {
      
      public static var rank:int;
      
      public static var fightTime:int;
      
      public static var surplusTime:int;
      
      public static var costDiamond:int;
      
      public static var rivalVec:Vector.<com.mvc.models.vos.mainCity.elfSeries.RivalVO> = new Vector.<com.mvc.models.vos.mainCity.elfSeries.RivalVO>([]);
      
      public static var remainCount:int;
       
      public function SeriesVO()
      {
         super();
      }
      
      public static function initFeedElfVec() : void
      {
         var _loc1_:* = 0;
         rivalVec.length = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            rivalVec.push(null);
            _loc1_++;
         }
      }
   }
}
