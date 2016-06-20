package com.mvc.models.vos.mainCity.sign
{
   public class AddUpVO
   {
       
      public var id:int;
      
      public var times:int;
      
      public var rewardArr:Array;
      
      public function AddUpVO()
      {
         rewardArr = [];
         super();
      }
   }
}
