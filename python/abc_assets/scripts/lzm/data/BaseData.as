package lzm.data
{
   public dynamic class BaseData
   {
       
      public function BaseData()
      {
         super();
      }
      
      public function parse(param1:Object) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = param1;
         for(var _loc2_ in param1)
         {
            if(this.hasOwnProperty(_loc2_))
            {
               this[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function parseFieldValues(param1:Array, param2:Array) : void
      {
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(this.hasOwnProperty(_loc5_))
            {
               this[_loc5_] = param2[_loc4_];
            }
            _loc4_++;
         }
      }
   }
}
