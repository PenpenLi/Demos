package com.mvc.models.vos.mapSelect
{
   public class MainMapVO extends MapBaseVO
   {
       
      public var name:String;
      
      public var descs:String;
      
      public var picName:String;
      
      public var npcName:String;
      
      public var propList:Array;
      
      public var sayBefore:String;
      
      public var sayAfter:String;
      
      public var rewardMoney:int;
      
      public var getExp:int;
      
      public var isPass:Boolean;
      
      public var isEndPoint:int = 0;
      
      public var lessTime:int = 0;
      
      public var maxTime:int = 0;
      
      public var reStartTime:int;
      
      public function MainMapVO()
      {
         super();
      }
   }
}
