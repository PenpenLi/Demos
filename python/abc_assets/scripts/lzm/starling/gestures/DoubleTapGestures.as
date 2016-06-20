package lzm.starling.gestures
{
   import starling.events.Touch;
   import flash.geom.Rectangle;
   import starling.display.DisplayObject;
   
   public class DoubleTapGestures extends Gestures
   {
       
      public function DoubleTapGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         var _loc2_:* = null;
         if(param1.phase == "ended" && param1.tapCount == 2)
         {
            _loc2_ = _target.getBounds(_target.stage);
            if(param1.globalX < _loc2_.x || param1.globalY < _loc2_.y || param1.globalX > _loc2_.x + _loc2_.width || param1.globalY > _loc2_.y + _loc2_.height)
            {
               return;
            }
            if(_callBack)
            {
               if(_callBack.length == 0)
               {
                  _callBack();
               }
               else
               {
                  _callBack(param1);
               }
            }
         }
      }
   }
}
