package com.mvc.models.vos.mainCity.specialAct
{
   public class PreferVO
   {
       
      public var id:int;
      
      public var costArr:Array;
      
      public var rewardArr:Array;
      
      public var state:int = 1;
      
      public var remainCount:int;
      
      public function PreferVO()
      {
         costArr = [];
         rewardArr = [];
         super();
      }
   }
}
