package lzm.starling.display.ainmation
{
   import starling.display.Sprite;
   import starling.animation.IAnimatable;
   import starling.textures.TextureAtlas;
   import starling.display.Image;
   import starling.core.Starling;
   import starling.utils.deg2rad;
   
   public class GroupMovieClip extends Sprite implements IAnimatable
   {
       
      protected var _data:Object;
      
      protected var _images:Object;
      
      protected var _textureAtlas:TextureAtlas;
      
      protected var _currentLabel:String;
      
      protected var _currentFrame:int;
      
      protected var _currentData:Array;
      
      protected var _numFrames:int;
      
      protected var _fps:Number;
      
      protected var _loop:Boolean = true;
      
      protected var _totalTime:Number;
      
      protected var _currentTime:Number;
      
      protected var _playing:Boolean = false;
      
      protected var _completeFunction:Function = null;
      
      public function GroupMovieClip(param1:Object, param2:TextureAtlas, param3:int = 12)
      {
         super();
         _data = param1;
         _images = {};
         _textureAtlas = param2;
         _fps = 1 / param3;
         init();
      }
      
      private function init() : void
      {
         var _loc1_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         try
         {
            name = _data["name"];
            _loc5_ = _data["combinantion"];
            var _loc8_:* = 0;
            var _loc7_:* = _loc5_;
            for(_loc4_ in _loc5_)
            {
               _loc3_ = _loc5_[_loc4_];
               _loc1_ = _loc3_["pivot"];
               _loc2_ = new Image(_textureAtlas.getTexture(name + "_" + _loc4_));
               _loc2_.pivotX = _loc1_[0];
               _loc2_.pivotY = _loc1_[1];
               _images[_loc4_] = _loc2_;
            }
            return;
         }
         catch(error:Error)
         {
            LogUtil(123123);
            return;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:int = _numFrames - 1;
         var _loc3_:int = _currentFrame;
         if(!_playing || param1 == 0 || _currentTime >= _totalTime)
         {
            return;
         }
         _currentTime = §§dup()._currentTime + param1;
         _currentFrame = _currentTime / _fps;
         if(_currentFrame > _loc2_ && _completeFunction != null)
         {
            _completeFunction(this);
         }
         if(_loop && _currentFrame > _loc2_)
         {
            _currentFrame = 0;
            _currentTime = 0;
         }
         if(_currentFrame != _loc3_)
         {
            currentFrame = _currentFrame;
         }
      }
      
      public function goToMovie(param1:String) : void
      {
         if(_currentLabel == param1)
         {
            return;
         }
         var _loc2_:Array = _data["framesInfo"][param1];
         if(_loc2_ == null)
         {
            return;
         }
         _currentData = _loc2_;
         _numFrames = _currentData.length;
         _currentFrame = -1;
         _currentTime = 0;
         _totalTime = _fps * _numFrames;
         currentFrame = 0;
      }
      
      public function play() : void
      {
         if(_playing)
         {
            return;
         }
         _playing = true;
         Starling.juggler.add(this);
      }
      
      public function stop() : void
      {
         _playing = false;
         Starling.juggler.remove(this);
      }
      
      public function set completeFunction(param1:Function) : void
      {
         _completeFunction = param1;
      }
      
      public function set currentFrame(param1:int) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = 0;
         _currentFrame = param1;
         clearChild();
         var _loc6_:Array = _currentData[_currentFrame];
         var _loc5_:int = _loc6_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc2_ = _loc6_[_loc7_];
            _loc3_ = _images[_loc2_[0]];
            _loc3_.mX = _loc2_[1];
            _loc3_.mY = _loc2_[2];
            _loc3_.mRotation = deg2rad(_loc2_[3]);
            _loc3_.mOrientationChanged = true;
            addQuickChild(_loc3_);
            _loc7_++;
         }
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function get numFrames() : int
      {
         return _numFrames;
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         stop();
         _data = null;
         var _loc4_:* = 0;
         var _loc3_:* = _images;
         for(_loc2_ in _images)
         {
            _loc1_ = _images[_loc2_];
            _loc1_.removeFromParent();
            _loc1_.dispose();
         }
         _images = null;
         _textureAtlas = null;
         _completeFunction = null;
         super.dispose();
      }
   }
}
