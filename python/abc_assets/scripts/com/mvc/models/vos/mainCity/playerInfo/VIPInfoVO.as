package com.mvc.models.vos.mainCity.playerInfo
{
   public class VIPInfoVO
   {
       
      public var vipLv:int;
      
      public var diamondVec:Vector.<int>;
      
      public var flash:int;
      
      public var friendLimit:int;
      
      public var locked:String;
      
      public var acFrVec:Vector.<int>;
      
      public var sweep:int;
      
      public var buyAcFr:int;
      
      public var goldFinger:int;
      
      public var alliance:int;
      
      public var kingRoad:int;
      
      public var pmCenter:int;
      
      public var remainSweep:int;
      
      public var remainBuyAcFr:int;
      
      public var remainGoldFinger:int;
      
      public var remainAlliance:int;
      
      public var remainKingRoad:int;
      
      public var remainPmCenter:int;
      
      public var remainFreeSay:int;
      
      public function VIPInfoVO()
      {
         diamondVec = new Vector.<int>([]);
         super();
      }
   }
}
