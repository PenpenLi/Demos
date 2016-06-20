package lzm.starling.display.ainmation
{
   import starling.display.Image;
   import starling.animation.IAnimatable;
   import starling.textures.Texture;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   
   public class MutiStateMovieClip extends Image implements IAnimatable
   {
       
      private var _textures:Vector.<Texture>;
      
      private var _numFrames:int;
      
      private var _currentFrame:int;
      
      private var _fps:Number;
      
      private var _loop:Boolean = true;
      
      private var _totalTime:Number;
      
      private var _currentTime:Number;
      
      private var _playing:Boolean = false;
      
      private var _completeFunction:Function = null;
      
      private var _currentKey:String;
      
      private var _moviesDictionary:Dictionary;
      
      public function MutiStateMovieClip(param1:Vector.<Texture>, param2:String, param3:Number = 12)
      {
         _moviesDictionary = new Dictionary();
         super(param1[0]);
         _textures = param1;
         _currentKey = param2;
         _moviesDictionary[param2] = _textures;
         _fps = 1 / param3;
         _numFrames = param1.length;
         _currentFrame = 0;
         _currentTime = 0;
         _totalTime = _fps * _numFrames;
         this.pivotX = pivotX;
         this.pivotY = pivotY;
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
         if(_loop && _currentTime >= _totalTime)
         {
            _currentFrame = 0;
            _currentTime = 0;
         }
         if(_currentFrame != _loc3_)
         {
            texture = _textures[_currentFrame];
         }
      }
      
      public function get numFrames() : int
      {
         return _numFrames;
      }
      
      public function get currentFrame() : int
      {
         return _currentFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         if(_currentFrame >= _numFrames - 1)
         {
            throw new Error("你妹，帧超出范围了");
         }
         _currentFrame = param1;
         _currentTime = _currentFrame * _fps;
      }
      
      public function get fps() : Number
      {
         return 1 / _fps;
      }
      
      public function set fps(param1:Number) : void
      {
         _fps = 1 / param1;
      }
      
      public function get loop() : Boolean
      {
         return _loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         _loop = loop;
      }
      
      public function set completeFunction(param1:Function) : void
      {
         _completeFunction = param1;
      }
      
      public function get currentKey() : String
      {
         return _currentKey;
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
      
      public function addMovie(param1:String, param2:Vector.<Texture>) : void
      {
         _moviesDictionary[param1] = param2;
      }
      
      public function goToMovie(param1:String) : void
      {
         if(_currentKey == param1)
         {
            return;
         }
         if(_moviesDictionary[param1] == null)
         {
            return;
         }
         _textures = _moviesDictionary[param1];
         _currentKey = param1;
         _numFrames = _textures.length;
         _currentFrame = 0;
         _currentTime = 0;
         _totalTime = _fps * _numFrames;
         texture = _textures[0];
         readjustSize();
      }
      
      public function removeMovie(param1:String) : void
      {
         if(_currentKey == param1)
         {
            throw new Error("你妹，动画正在播放不能删除！！");
         }
         return;
         §§push(delete _moviesDictionary[param1]);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Starling.juggler.remove(this);
      }
   }
}
