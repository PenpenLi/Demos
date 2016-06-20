package com.common.util
{
   public class DisposeDisplay
   {
       
      public function DisposeDisplay()
      {
         super();
      }
      
      public static function dispose(param1:*) : void
      {
         var _loc3_:* = 0;
         var _loc2_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            param1[_loc3_].removeFromParent(true);
            param1[_loc3_] = null;
            _loc3_++;
         }
         var param1:* = null;
      }
   }
}
