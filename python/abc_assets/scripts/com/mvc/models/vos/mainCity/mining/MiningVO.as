package com.mvc.models.vos.mainCity.mining
{
   public class MiningVO
   {
       
      public var id:String;
      
      public var severId:String;
      
      public var name:String;
      
      public var type:String = "1";
      
      public var totalNum:int;
      
      public var speed:int;
      
      public var startTime:int;
      
      public var endTime:int;
      
      public var lootNum:int;
      
      public var nextCoin:int;
      
      public var defenderArr:Array;
      
      public var isComplete:Boolean;
      
      public function MiningVO()
      {
         defenderArr = [];
         super();
      }
   }
}
