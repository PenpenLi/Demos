package lzm.starling.gestures
{
   import starling.events.Touch;
   import starling.display.DisplayObject;
   
   public class MoveOverGestures extends Gestures
   {
       
      private var _isMove:Boolean = false;
      
      public function MoveOverGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         if(param1.phase == "began")
         {
            _isMove = false;
         }
         else if(param1.phase == "moved")
         {
            _isMove = true;
         }
         else if(param1.phase == "ended")
         {
            _isMove = false;
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
