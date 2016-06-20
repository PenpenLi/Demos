package com.mvc.models.vos.fighting
{
   import com.mvc.models.vos.elf.ElfVO;
   
   public class NPCVO
   {
      
      public static var useId:String;
      
      public static var name:String;
      
      public static var imageName:String;
      
      public static var bagElfVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
      
      public static var dialougBeforeFighting:Array = [];
      
      public static var dialougAfterFighting:Array = [];
      
      public static var isSpecial:Boolean;
      
      public static var isUseProp:Boolean;
      
      public static var isChangeElf:Boolean;
      
      public static var elfOfXiaoMao:String;
      
      public static var unionDefenseAdd:Number = 1;
      
      public static var unionAttackAdd:Number = 1;
       
      public function NPCVO()
      {
         super();
      }
   }
}
