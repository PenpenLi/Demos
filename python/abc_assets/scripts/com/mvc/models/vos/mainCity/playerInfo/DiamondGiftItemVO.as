package com.mvc.models.vos.mainCity.playerInfo
{
   import starling.display.Image;
   
   public class DiamondGiftItemVO
   {
       
      public var id:int;
      
      public var picture:Image;
      
      public var title:String;
      
      public var rmb:int = 20;
      
      public var rechargeExplain:String;
      
      public var recommend:Boolean;
      
      public var getDiamond:int;
      
      public var present:int;
      
      public var isLimit:Boolean;
      
      public var limit:int;
      
      public var weight:int;
      
      public function DiamondGiftItemVO()
      {
         super();
      }
   }
}
