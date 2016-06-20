package com.mvc.views.uis.mainCity.pvp
{
   import starling.display.Sprite;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   
   public class PVPElfCampUI extends Sprite
   {
       
      private var elfVOVec:Vector.<ElfVO>;
      
      public function PVPElfCampUI(param1:Vector.<ElfVO>, param2:Boolean = false)
      {
         super();
         this.elfVOVec = param1;
         createElfCamp(param2);
      }
      
      private function createElfCamp(param1:Boolean = false) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < 6)
         {
            _loc3_ = new ElfBgUnitUI(true);
            _loc3_.touchable = false;
            var _loc5_:* = 0.65;
            _loc3_.scaleY = _loc5_;
            _loc3_.scaleX = _loc5_;
            _loc3_.identify = "pvp";
            if(elfVOVec[_loc4_] == null)
            {
               _loc3_.switchContain(false);
            }
            else
            {
               _loc3_.myElfVo = elfVOVec[_loc4_];
               _loc3_.switchContain(true);
            }
            if(param1)
            {
               _loc3_.addQuestionTf("？",80,22,10);
            }
            addChild(_loc3_);
            if(_loc4_ % 3 == 0 && _loc4_ != 0)
            {
               _loc2_++;
            }
            _loc3_.x = 75 * (_loc4_ % 3);
            _loc3_.y = 75 * _loc2_;
            _loc4_++;
         }
         elfVOVec = Vector.<ElfVO>([]);
         elfVOVec = null;
      }
   }
}
