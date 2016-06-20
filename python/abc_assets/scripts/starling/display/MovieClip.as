package starling.display
{
   import starling.animation.IAnimatable;
   import starling.textures.Texture;
   import flash.media.Sound;
   import flash.errors.IllegalOperationError;
   
   public class MovieClip extends Image implements IAnimatable
   {
       
      private var mTextures:Vector.<Texture>;
      
      private var mSounds:Vector.<Sound>;
      
      private var mDurations:Vector.<Number>;
      
      private var mStartTimes:Vector.<Number>;
      
      private var mDefaultFrameDuration:Number;
      
      private var mCurrentTime:Number;
      
      private var mCurrentFrame:int;
      
      private var mLoop:Boolean;
      
      private var mPlaying:Boolean;
      
      private var mMuted:Boolean;
      
      public function MovieClip(param1:Vector.<Texture>, param2:Number = 12)
      {
         if(param1.length > 0)
         {
            super(param1[0]);
            init(param1,param2);
            return;
         }
         throw new ArgumentError("Empty texture array");
      }
      
      private function init(param1:Vector.<Texture>, param2:Number) : void
      {
         var _loc4_:* = 0;
         if(param2 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param2);
         }
         var _loc3_:int = param1.length;
         mDefaultFrameDuration = 1 / param2;
         mLoop = true;
         mPlaying = true;
         mCurrentTime = 0;
         mCurrentFrame = 0;
         mTextures = param1.concat();
         mSounds = new Vector.<Sound>(_loc3_);
         mDurations = new Vector.<Number>(_loc3_);
         mStartTimes = new Vector.<Number>(_loc3_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            mDurations[_loc4_] = mDefaultFrameDuration;
            mStartTimes[_loc4_] = _loc4_ * mDefaultFrameDuration;
            _loc4_++;
         }
      }
      
      public function addFrame(param1:Texture, param2:Sound = null, param3:Number = -1) : void
      {
         addFrameAt(numFrames,param1,param2,param3);
      }
      
      public function addFrameAt(param1:int, param2:Texture, param3:Sound = null, param4:Number = -1) : void
      {
         if(param1 < 0 || param1 > numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(param4 < 0)
         {
            var param4:Number = mDefaultFrameDuration;
         }
         mTextures.splice(param1,0,param2);
         mSounds.splice(param1,0,param3);
         mDurations.splice(param1,0,param4);
         if(param1 > 0 && param1 == numFrames)
         {
            mStartTimes[param1] = mStartTimes[param1 - 1] + mDurations[param1 - 1];
         }
         else
         {
            updateStartTimes();
         }
      }
      
      public function removeFrameAt(param1:int) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         if(numFrames == 1)
         {
            throw new IllegalOperationError("Movie clip must not be empty");
         }
         mTextures.splice(param1,1);
         mSounds.splice(param1,1);
         mDurations.splice(param1,1);
         updateStartTimes();
      }
      
      public function getFrameTexture(param1:int) : Texture
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return mTextures[param1];
      }
      
      public function setFrameTexture(param1:int, param2:Texture) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         mTextures[param1] = param2;
      }
      
      public function getFrameSound(param1:int) : Sound
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return mSounds[param1];
      }
      
      public function setFrameSound(param1:int, param2:Sound) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         mSounds[param1] = param2;
      }
      
      public function getFrameDuration(param1:int) : Number
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         return mDurations[param1];
      }
      
      public function setFrameDuration(param1:int, param2:Number) : void
      {
         if(param1 < 0 || param1 >= numFrames)
         {
            throw new ArgumentError("Invalid frame id");
         }
         mDurations[param1] = param2;
         updateStartTimes();
      }
      
      public function play() : void
      {
         mPlaying = true;
      }
      
      public function pause() : void
      {
         mPlaying = false;
      }
      
      public function stop() : void
      {
         mPlaying = false;
         currentFrame = 0;
      }
      
      private function updateStartTimes() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = this.numFrames;
         mStartTimes.length = 0;
         mStartTimes[0] = 0;
         _loc2_ = 1;
         while(_loc2_ < _loc1_)
         {
            mStartTimes[_loc2_] = mStartTimes[_loc2_ - 1] + mDurations[_loc2_ - 1];
            _loc2_++;
         }
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = null;
         if(!mPlaying || param1 <= 0)
         {
            return;
         }
         var _loc7_:int = mCurrentFrame;
         var _loc6_:* = 0.0;
         var _loc2_:* = false;
         var _loc5_:Boolean = hasEventListener("complete");
         var _loc8_:* = false;
         var _loc9_:Number = this.totalTime;
         if(mLoop && mCurrentTime >= _loc9_)
         {
            mCurrentTime = 0;
            mCurrentFrame = 0;
         }
         if(mCurrentTime < _loc9_)
         {
            mCurrentTime = §§dup().mCurrentTime + param1;
            _loc4_ = mTextures.length - 1;
            while(mCurrentTime > mStartTimes[mCurrentFrame] + mDurations[mCurrentFrame])
            {
               if(mCurrentFrame == _loc4_)
               {
                  if(mLoop && !_loc5_)
                  {
                     mCurrentTime = §§dup().mCurrentTime - _loc9_;
                     mCurrentFrame = 0;
                  }
                  else
                  {
                     _loc2_ = true;
                     _loc6_ = mCurrentTime - _loc9_;
                     _loc8_ = _loc5_;
                     mCurrentFrame = _loc4_;
                     mCurrentTime = _loc9_;
                  }
               }
               else
               {
                  mCurrentFrame = mCurrentFrame + 1;
               }
               _loc3_ = mSounds[mCurrentFrame];
               if(_loc3_ && !mMuted)
               {
                  _loc3_.play();
               }
               if(!_loc2_)
               {
                  continue;
               }
               break;
            }
            if(mCurrentFrame == _loc4_ && mCurrentTime == _loc9_)
            {
               _loc8_ = _loc5_;
            }
         }
         if(mCurrentFrame != _loc7_)
         {
            texture = mTextures[mCurrentFrame];
         }
         if(_loc8_)
         {
            dispatchEventWith("complete");
         }
         if(mLoop && _loc6_ > 0)
         {
            advanceTime(_loc6_);
         }
      }
      
      public function get totalTime() : Number
      {
         var _loc1_:int = mTextures.length;
         return mStartTimes[_loc1_ - 1] + mDurations[_loc1_ - 1];
      }
      
      public function get currentTime() : Number
      {
         return mCurrentTime;
      }
      
      public function get numFrames() : int
      {
         return mTextures.length;
      }
      
      public function get loop() : Boolean
      {
         return mLoop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         mLoop = param1;
      }
      
      public function get muted() : Boolean
      {
         return mMuted;
      }
      
      public function set muted(param1:Boolean) : void
      {
         mMuted = param1;
      }
      
      public function get currentFrame() : int
      {
         return mCurrentFrame;
      }
      
      public function set currentFrame(param1:int) : void
      {
         var _loc2_:* = 0;
         mCurrentFrame = param1;
         mCurrentTime = 0;
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            mCurrentTime = §§dup().mCurrentTime + getFrameDuration(_loc2_);
            _loc2_++;
         }
         texture = mTextures[mCurrentFrame];
         if(!mMuted && mSounds[mCurrentFrame])
         {
            mSounds[mCurrentFrame].play();
         }
      }
      
      public function get fps() : Number
      {
         return 1 / mDefaultFrameDuration;
      }
      
      public function set fps(param1:Number) : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = NaN;
         if(param1 <= 0)
         {
            throw new ArgumentError("Invalid fps: " + param1);
         }
         var _loc3_:Number = 1 / param1;
         var _loc4_:Number = _loc3_ / mDefaultFrameDuration;
         mCurrentTime = §§dup().mCurrentTime * _loc4_;
         mDefaultFrameDuration = _loc3_;
         _loc5_ = 0;
         while(_loc5_ < numFrames)
         {
            _loc2_ = mDurations[_loc5_] * _loc4_;
            mDurations[_loc5_] = _loc2_;
            _loc5_++;
         }
         updateStartTimes();
      }
      
      public function get isPlaying() : Boolean
      {
         if(mPlaying)
         {
            return mLoop || mCurrentTime < totalTime;
         }
         return false;
      }
      
      public function get isComplete() : Boolean
      {
         return !mLoop && mCurrentTime >= totalTime;
      }
   }
}
