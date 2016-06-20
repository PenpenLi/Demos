package com.mvc.models.vos.mainCity.chat
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class ChatVO
   {
       
      public var userId:String;
      
      public var userName:String;
      
      public var sex:int;
      
      public var vipRank:int;
      
      public var headPtId:int;
      
      public var msg:String;
      
      public var hornRollTimes:int;
      
      public var showPlace:int;
      
      public var lv:int;
      
      public var postTime:String;
      
      public var newTime:int;
      
      public var ifShow:Boolean;
      
      public var elfVO:ElfVO;
      
      public var elfVec:Vector.<ElfVO>;
      
      public var power:int;
      
      public var belong:int;
      
      public var beyondElf:int;
      
      public var PVPchangeNum:int;
      
      public var pvpBestRank:int;
      
      public var otherPlayerElf:Object;
      
      public var notReadNum:int;
      
      public var mineId:String;
      
      public function ChatVO()
      {
         elfVec = new Vector.<ElfVO>([]);
         super();
      }
   }
}
