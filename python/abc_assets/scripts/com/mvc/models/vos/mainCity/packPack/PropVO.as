package com.mvc.models.vos.mainCity.packPack
{
   public class PropVO
   {
       
      public var id:String = "0";
      
      public var name:String;
      
      public var imgName:String;
      
      public var type:int;
      
      public var describe:String;
      
      public var validElf:Array;
      
      public var validNature:String;
      
      public var effectValue:Number;
      
      public var relieveState:String;
      
      public var replyType:String;
      
      public var skillId:int;
      
      public var elfNature:String;
      
      public var actRole:String;
      
      public var isCarry:int;
      
      public var position:int;
      
      public var count:String = "0";
      
      public var rewardCount:int = 1;
      
      public var isUsed:Boolean;
      
      public var price:int;
      
      public var isSale:int;
      
      public var evolveNum:int;
      
      public var useNum:int = 0;
      
      public var diamond:int;
      
      public var composeId:int;
      
      public var composeNum:int;
      
      public var composeMoney:int;
      
      public var compNeedPropId:Array;
      
      public var quality:int;
      
      public var auctionType:int;
      
      public var auctionNum:int;
      
      public var auctionIndex:int;
      
      public var vipLimitBuyInfoArr:Array;
      
      public var dayBuyCount:int = -1;
      
      public var exclusiveElf:Array;
      
      public var effectForAblility:Array;
      
      public var previewLimit:int;
      
      public var isDiamondSale:Boolean = true;
      
      public function PropVO()
      {
         validElf = [];
         compNeedPropId = [];
         vipLimitBuyInfoArr = [];
         exclusiveElf = [];
         effectForAblility = [];
         super();
      }
   }
}
