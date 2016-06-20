package com.mvc.views.uis.mainCity.hunting
{
   import starling.display.Sprite;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.common.managers.ELFMinImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   
   public class HuntingSmallElfUnit extends Sprite
   {
       
      private var _elfvo:ElfVO;
      
      private var elfImg:Image;
      
      public function HuntingSmallElfUnit()
      {
         super();
      }
      
      public function set elfvo(param1:ElfVO) : void
      {
         _elfvo = param1;
         elfImg = ELFMinImageManager.getElfM(_elfvo.imgName);
         addChild(elfImg);
         elfImg.addEventListener("touch",elfImg_touchHandler);
      }
      
      private function elfImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(elfImg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               ExtendElfUnitTips.getInstance().showElfTips(_elfvo,this);
            }
            if(_loc2_.phase == "ended")
            {
               ExtendElfUnitTips.getInstance().removeElfTips();
            }
         }
      }
   }
}
