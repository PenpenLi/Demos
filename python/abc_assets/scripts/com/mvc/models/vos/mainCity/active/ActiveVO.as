package com.mvc.models.vos.mainCity.active
{
   public class ActiveVO
   {
       
      public var atvEndTime:int;
      
      public var atvDescs:String;
      
      public var id:int;
      
      public var atvType:int;
      
      public var weight:int;
      
      public var atvStartTime:int;
      
      public var atvPicId:String;
      
      public var atvTitle:String;
      
      public var activeChildVec:Vector.<com.mvc.models.vos.mainCity.active.ActiveChildVO>;
      
      public function ActiveVO()
      {
         activeChildVec = new Vector.<com.mvc.models.vos.mainCity.active.ActiveChildVO>([]);
         super();
      }
   }
}
