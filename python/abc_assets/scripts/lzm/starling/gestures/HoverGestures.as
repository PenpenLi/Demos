package lzm.starling.gestures
{
   import starling.events.Touch;
   import starling.display.DisplayObject;
   
   public class HoverGestures extends Gestures
   {
       
      public function HoverGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         if(param1.phase == "hover")
         {
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
