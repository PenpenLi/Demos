package com.mvc.models.vos.mainCity.exChange
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class ExChangeVO
   {
       
      public var index:int;
      
      public var modeLv:int;
      
      public var lessNum:int;
      
      public var elfVec:Vector.<ElfVO>;
      
      public var getElfVo:ElfVO;
      
      public function ExChangeVO()
      {
         elfVec = new Vector.<ElfVO>([]);
         super();
      }
   }
}
