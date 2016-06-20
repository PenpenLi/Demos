package com.mvc.models.vos.mainCity.elfSeries
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class RivalVO
   {
       
      public var headPtId:int;
      
      public var lv:int;
      
      public var vipRank:int;
      
      public var sex:int;
      
      public var badge:int;
      
      public var rank:int;
      
      public var userName:String;
      
      public var userId:String;
      
      public var imgName:String = "di4liu4dao4guan3guan3zhu3";
      
      public var rivalTime:String;
      
      public var ranking:Number;
      
      public var elfVec:Vector.<ElfVO>;
      
      public var isWin:Boolean;
      
      public var unionDefenseAdd:Number = 1;
      
      public var unionAttackAdd:Number = 1;
      
      public function RivalVO()
      {
         elfVec = new Vector.<ElfVO>([]);
         super();
      }
   }
}
