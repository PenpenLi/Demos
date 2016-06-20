package com.mvc.models.vos.mainCity.train
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class TrainVO
   {
       
      public var traGrdId:int;
      
      public var status:int;
      
      public var elfVo:ElfVO;
      
      public var upExp:int;
      
      public var isFull:Boolean;
      
      public var vipNeed:int;
      
      public var isFree:int;
      
      public var levelNeed:int;
      
      public var unlockLevel:int;
      
      public var trainType:int;
      
      public var openCost:int;
      
      public var green:int;
      
      public var blue:int;
      
      public var purple:int;
      
      public var orange:int;
      
      public var maxLv:int;
      
      public function TrainVO()
      {
         super();
      }
   }
}
