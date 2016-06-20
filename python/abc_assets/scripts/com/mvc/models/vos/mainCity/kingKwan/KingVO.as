package com.mvc.models.vos.mainCity.kingKwan
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class KingVO
   {
       
      public var useId:String;
      
      public var name:String;
      
      public var lv:int;
      
      public var headId:int;
      
      public var trainPtId:int;
      
      public var imgName:String;
      
      public var elfVec:Vector.<ElfVO>;
      
      public var state:int;
      
      public var chapter:int;
      
      public var vipRank:int;
      
      public function KingVO()
      {
         elfVec = new Vector.<ElfVO>([]);
         super();
      }
   }
}
