package lzm.starling.gestures
{
   import starling.events.Touch;
   import starling.display.DisplayObject;
   
   public class MovedGestures extends Gestures
   {
       
      public function MovedGestures(param1:DisplayObject, param2:Function = null)
      {
         super(param1,param2);
      }
      
      override public function checkGestures(param1:Touch) : void
      {
         if(param1.phase != "began")
         {
            if(param1.phase == "moved")
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
            else if(param1.phase == "ended")
            {
            }
         }
      }
   }
}
