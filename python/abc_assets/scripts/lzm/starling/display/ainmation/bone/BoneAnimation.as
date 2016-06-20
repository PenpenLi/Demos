package lzm.starling.display.ainmation.bone
{
   import starling.display.Sprite;
   import starling.display.Image;
   
   public class BoneAnimation extends Sprite
   {
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
       
      private var _images:Object;
      
      private var _frameInfos:Object;
      
      protected var _labels:Array;
      
      protected var _currentLabel:String;
      
      protected var _currentFrame:int;
      
      protected var _currentData:Array;
      
      protected var _numFrames:int;
      
      protected var _fps:Number;
      
      protected var _loop:Boolean = true;
      
      protected var _playing:Boolean = false;
      
      protected var _completeFunction:Function = null;
      
      public function BoneAnimation(param1:Object, param2:Object, param3:int = 12)
      {
         super();
         _images = param2;
         _labels = [];
         _frameInfos = param1["frameInfos"];
         var _loc6_:* = 0;
         var _loc5_:* = _frameInfos;
         for(var _loc4_ in _frameInfos)
         {
            _labels.push(_loc4_);
         }
         _fps = 1 / param3;
      }
      
      public function update() : void
      {
         var _loc1_:int = _numFrames - 1;
         if(!_playing)
         {
            return;
         }
         var _loc2_:int = _currentFrame;
         _currentFrame = §§dup()._currentFrame + 1;
         if(_currentFrame > _loc1_)
         {
            if(!_loop)
            {
               stop();
            }
            if(_completeFunction)
            {
               _completeFunction(this);
            }
            _currentFrame = 0;
            return;
         }
         if(_currentFrame != _loc2_)
         {
            currentFrame = _currentFrame;
         }
      }
      
      public function hasLabel(param1:String) : Boolean
      {
         return _frameInfos[param1] != null;
      }
      
      public function goToMovie(param1:String) : void
      {
         if(_currentLabel == param1)
         {
            return;
         }
         _currentLabel = param1;
         _currentData = _frameInfos[param1];
         _numFrames = _currentData.length;
         _currentFrame = -1;
         currentFrame = 0;
      }
      
      public function play(param1:Boolean = true) : void
      {
         if(_playing)
         {
            return;
         }
         _playing = true;
         _loop = param1;
         if(_currentLabel == null)
         {
            goToMovie(_labels[0]);
         }
      }
      
      public function stop() : void
      {
         _playing = false;
      }
      
      public function set completeFunction(param1:Function) : void
      {
         _completeFunction = param1;
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         _currentFrame = param1;
         clearChild();
         var _loc3_:Array = _currentData[_currentFrame];
         var _loc4_:int = _loc3_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc6_];
            _loc5_ = _images[_loc2_[0]];
            _loc5_.x = _loc2_[1];
            _loc5_.y = _loc2_[2];
            _loc5_.scaleX = _loc2_[3];
            _loc5_.scaleY = _loc2_[4];
            _loc5_.skewX = _loc2_[5] * 0.017453292519943295;
            _loc5_.skewY = _loc2_[6] * 0.017453292519943295;
            addQuickChild(_loc5_);
            _loc6_++;
         }
      }
      
      public function get labels() : Array
      {
         return _labels;
      }
      
      public function get currentLabel() : String
      {
         return _currentLabel;
      }
      
      public function get playing() : Boolean
      {
         return _playing;
      }
      
      override public function dispose() : void
      {
         stop();
         removeFromParent();
         var _loc3_:* = 0;
         var _loc2_:* = _images;
         for each(var _loc1_ in _images)
         {
            _loc1_.removeFromParent();
            _loc1_.dispose();
         }
         _images = null;
         _frameInfos = null;
         super.dispose();
      }
   }
}
