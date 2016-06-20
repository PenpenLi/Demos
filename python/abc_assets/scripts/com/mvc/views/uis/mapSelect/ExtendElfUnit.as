package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.common.managers.ELFMinImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class ExtendElfUnit extends Sprite
   {
       
      private var _elfVO:ElfVO;
      
      private var elfImg:Image;
      
      public function ExtendElfUnit()
      {
         super();
      }
      
      public function set myElfVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         elfImg = ELFMinImageManager.getElfM(param1.imgName,0.63);
         elfImg.addEventListener("touch",touchHndler);
         addChild(elfImg);
      }
      
      private function touchHndler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(elfImg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               ExtendElfUnitTips.getInstance().showElfTips(_elfVO,this);
            }
            if(_loc2_.phase == "ended")
            {
               ExtendElfUnitTips.getInstance().removeElfTips();
            }
         }
      }
   }
}
