package starling.utils
{
   public function execute(param1:Function, ... rest) : void
   {
      var _loc4_:* = 0;
      var _loc3_:* = 0;
      if(param1 != null)
      {
         _loc3_ = param1.length;
         _loc4_ = rest.length;
         while(_loc4_ < _loc3_)
         {
            rest[_loc4_] = null;
            _loc4_++;
         }
         param1.apply(null,rest.slice(0,_loc3_));
      }
   }
}
