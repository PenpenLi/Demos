package com.common.util
{
   import starling.display.DisplayObject;
   import starling.animation.Tween;
   import starling.core.Starling;
   import starling.display.Quad;
   
   public class AniEffects
   {
      
      private static var _height:Number;
      
      private static var _time;
      
      private static var _colorTime:Number;
      
      public static var randomColor:uint;
      
      public static var isGetColor:Boolean;
      
      private static var _particleTime:Number;
      
      private static var randomX:Number;
      
      private static var randomY:Number;
       
      public function AniEffects()
      {
         super();
      }
      
      public static function openAni(param1:Boolean = false) : void
      {
         isGetColor = param1;
      }
      
      public static function elfMoveAni(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         target = param1;
         height = param2;
         time = param3;
         _height = height;
         _time = time;
         var t:Tween = new Tween(target,_time);
         Starling.juggler.add(t);
         t.animate("y",target.y + _height,target.y);
         t.onComplete = function():void
         {
            var t2:Tween = new Tween(target,_time);
            Starling.juggler.add(t2);
            t2.animate("y",target.y - _height,target.y);
            t2.onComplete = function():void
            {
               elfMoveAni(target,_height,_time);
            };
         };
      }
      
      public static function changeColor(param1:Quad, param2:Number) : void
      {
         target = param1;
         time = param2;
         _colorTime = time;
         target.color = randomColor;
         var t:Tween = new Tween(target,_colorTime);
         Starling.juggler.add(t);
         t.animate("alpha",0.5,1);
         t.onComplete = function():void
         {
            target.color = randomColor;
            var t2:Tween = new Tween(target,_colorTime);
            Starling.juggler.add(t2);
            t2.animate("alpha",1,0.5);
            t2.onComplete = function():void
            {
               changeColor(target,_colorTime);
            };
         };
      }
      
      public static function particleAni(param1:DisplayObject, param2:int, param3:int, param4:int, param5:int, param6:Number) : void
      {
         target = param1;
         x = param2;
         y = param3;
         w = param4;
         h = param5;
         time = param6;
         _particleTime = time;
         var t:Tween = new Tween(target,_particleTime);
         Starling.juggler.add(t);
         randomX = x + Math.random() * w;
         randomY = y + Math.random() * h;
         t.animate("x",randomX,target.x);
         t.animate("y",randomY,target.y);
         t.onComplete = function():void
         {
            randomX = x + Math.random() * w;
            randomY = y + Math.random() * h;
            var t2:Tween = new Tween(target,_particleTime);
            Starling.juggler.add(t2);
            t2.animate("x",randomX,target.x);
            t2.animate("y",randomY,target.y);
            t2.onComplete = function():void
            {
               particleAni(target,x,y,w,h,_particleTime);
            };
         };
      }
      
      public static function closeAni(... rest) : void
      {
         var _loc2_:* = 0;
         isGetColor = false;
         _loc2_ = 0;
         while(_loc2_ < rest.length)
         {
            LogUtil("关闭动画=",rest[_loc2_]);
            Starling.juggler.removeTweens(rest[_loc2_]);
            _loc2_++;
         }
      }
   }
}
