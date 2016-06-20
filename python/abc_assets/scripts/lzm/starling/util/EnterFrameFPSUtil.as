package lzm.starling.util
{
   import starling.events.EnterFrameEvent;
   
   public class EnterFrameFPSUtil
   {
       
      private var fps:int;
      
      private var fpsTime:Number;
      
      private var currentTime:Number;
      
      public function EnterFrameFPSUtil(param1:int)
      {
         super();
         this.fps = param1;
         this.fpsTime = 1000 / this.fps * 0.001;
         this.currentTime = 0;
      }
      
      public function update(param1:EnterFrameEvent) : Boolean
      {
         this.currentTime = this.currentTime + param1.passedTime;
         if(this.currentTime >= this.fpsTime)
         {
            this.currentTime = this.currentTime - this.fpsTime;
            if(this.currentTime > this.fpsTime)
            {
               this.currentTime = 0;
            }
            return true;
         }
         return false;
      }
   }
}
