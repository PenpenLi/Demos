package com.common.util
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.DisplayObject;
   import flash.geom.Point;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   
   public class Finger extends Sprite
   {
      
      private static var finger:SwfMovieClip;
      
      public static var instance:com.common.util.Finger;
       
      public function Finger()
      {
         super();
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         finger = _loc1_.createMovieClip("mc_finger");
         addChild(finger);
      }
      
      public static function getInstance(param1:Number = 0) : com.common.util.Finger
      {
         if(instance == null)
         {
            instance = new com.common.util.Finger();
         }
         finger.rotation = param1;
         return instance;
      }
      
      public function setFinger(param1:DisplayObject) : void
      {
         finger.x = param1.localToGlobal(new Point(0,0)).x / Config.scaleX + 82;
         finger.y = param1.localToGlobal(new Point(0,0)).y / Config.scaleY - 65;
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
         }
      }
   }
}
