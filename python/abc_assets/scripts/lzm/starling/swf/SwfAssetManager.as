package lzm.starling.swf
{
   import flash.utils.Dictionary;
   import starling.utils.AssetManager;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfShapeImage;
   import lzm.starling.swf.display.SwfParticleSyetem;
   
   public class SwfAssetManager
   {
      
      protected static const ______otherAssetsTag:String = "______otherAssetsTag";
       
      protected var _verbose:Boolean = false;
      
      protected var _loadQueue:Array;
      
      protected var _loadQueueNames:Array;
      
      protected var _isLoading:Boolean;
      
      protected var _swfs:Dictionary;
      
      protected var _swfNames:Array;
      
      protected var _scaleFactor:Number;
      
      protected var _useMipmaps:Boolean;
      
      protected var _otherAssets:AssetManager;
      
      protected var _otherQueue:Array;
      
      public function SwfAssetManager(param1:Number = 1, param2:Boolean = false)
      {
         super();
         _loadQueue = [];
         _loadQueueNames = [];
         _isLoading = false;
         _swfs = new Dictionary();
         _swfNames = [];
         _scaleFactor = param1;
         _useMipmaps = param2;
         _otherAssets = new AssetManager(param1,param2);
         _otherQueue = [];
      }
      
      public function enqueue(param1:String, param2:Array, param3:int = 24) : void
      {
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         if(getSwf(param1) != null)
         {
            log("Swf已经存在");
            return;
         }
         if(_loadQueueNames.indexOf(param1) == -1)
         {
            _loadQueueNames.push(param1);
            _loadQueue.push([param1,param2,param3]);
         }
         else
         {
            log("加载队列中已经有：" + param1 + ",跳过!");
         }
      }
      
      public function enqueueWithArray(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_];
            if(_loc2_.length == 3)
            {
               enqueue(_loc2_[0],_loc2_[1],_loc2_[2]);
            }
            else
            {
               enqueue(_loc2_[0],_loc2_[1]);
            }
            _loc4_++;
         }
      }
      
      public function enqueueOtherAssets(... rest) : void
      {
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
         }
         var _loc4_:* = 0;
         var _loc3_:* = rest;
         for each(var _loc2_ in rest)
         {
            _otherQueue.push(_loc2_);
         }
      }
      
      protected function parseOtherAssets() : void
      {
         if(_otherQueue.length > 0)
         {
            enqueue("______otherAssetsTag",_otherQueue.slice());
         }
         _otherQueue = [];
      }
      
      public function loadQueue(param1:Function, param2:Function) : void
      {
         onProgress = param1;
         error = param2;
         loadNext = function():void
         {
            swfAsset = _loadQueue.shift();
            if(getSwf(swfAsset[0]) != null)
            {
               loadNext();
            }
            else
            {
               load();
            }
         };
         load = function():void
         {
            var swfName:String = swfAsset[0];
            var swfResource:Array = swfAsset[1];
            var swfFps:int = swfAsset[2];
            var assetManager:AssetManager = swfName == "______otherAssetsTag"?_otherAssets:new AssetManager(_scaleFactor,_useMipmaps);
            assetManager.verbose = verbose;
            var _loc3_:* = 0;
            var _loc2_:* = swfResource;
            for each(assetObject in swfResource)
            {
               assetManager.enqueue(assetObject);
            }
            assetManager.loadQueue(function(param1:Number):void
            {
               if(param1 == 1)
               {
                  if(swfName != "______otherAssetsTag")
                  {
                     addSwf(swfName,new Swf(assetManager.getByteArray(swfName),assetManager,swfFps));
                  }
                  loadComplete();
               }
               else
               {
                  onProgress(currentRatio + avgRatio * param1);
               }
            });
         };
         loadComplete = function():void
         {
            currentRatio = _loadQueue.length?1 - _loadQueue.length / numSwfAsset:1.0;
            if(currentRatio == 1)
            {
               _isLoading = false;
            }
            else
            {
               loadNext();
            }
         };
         if(_isLoading)
         {
            log("正在加载中。请稍后再试");
            return;
            §§push(error());
         }
         else
         {
            parseOtherAssets();
            _loadQueueNames = [];
            var numSwfAsset:int = _loadQueue.length;
            var currentRatio:Number = 0.0;
            var avgRatio:Number = 1 / numSwfAsset;
            if(numSwfAsset == 0)
            {
               log("没有需要加载的Swf");
               return;
               §§push(onProgress(1));
            }
            else
            {
               _isLoading = true;
               return;
               §§push(loadNext());
            }
         }
      }
      
      public function getSwf(param1:String) : Swf
      {
         return _swfs[param1];
      }
      
      public function addSwf(param1:String, param2:Swf) : Boolean
      {
         if(getSwf(param1) != null)
         {
            log("Swf已经存在");
            return false;
         }
         log("添加Swf:" + param1);
         _swfs[param1] = param2;
         _swfNames.push(param1);
         return true;
      }
      
      public function removeSwf(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Swf = getSwf(param1);
         if(_loc3_)
         {
            log("移除Swf:" + param1 + "  dispose:" + param2);
            if(param2)
            {
               _loc3_.dispose(param2);
            }
            delete _swfs[param1];
            _swfNames.splice(_swfNames.indexOf(param1),1);
         }
      }
      
      public function clearSwf() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = _swfs;
         for each(var _loc1_ in _swfs)
         {
            _loc1_.dispose(true);
         }
         _swfs = new Dictionary();
         _swfNames = [];
      }
      
      public function clearAll() : void
      {
         clearSwf();
         _otherAssets.purge();
         _otherAssets.clearRuntimeLoadTexture();
      }
      
      public function get swfNames() : Array
      {
         return _swfNames.slice();
      }
      
      public function createSprite(param1:String) : SwfSprite
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasSprite(param1))
            {
               return _loc2_.createSprite(param1);
            }
         }
         return null;
      }
      
      public function createMovieClip(param1:String) : SwfMovieClip
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasMovieClip(param1))
            {
               return _loc2_.createMovieClip(param1);
            }
         }
         return null;
      }
      
      public function createImage(param1:String) : SwfImage
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasImage(param1))
            {
               return _loc2_.createImage(param1);
            }
         }
         return null;
      }
      
      public function createButton(param1:String) : SwfButton
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasButton(param1))
            {
               return _loc2_.createButton(param1);
            }
         }
         return null;
      }
      
      public function createS9Image(param1:String) : SwfScale9Image
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasS9Image(param1))
            {
               return _loc2_.createS9Image(param1);
            }
         }
         return null;
      }
      
      public function createShapeImage(param1:String) : SwfShapeImage
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasShapeImage(param1))
            {
               return _loc2_.createShapeImage(param1);
            }
         }
         return null;
      }
      
      public function createComponent(param1:String) : *
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasComponent(param1))
            {
               return _loc2_.createComponent(param1);
            }
         }
         return null;
      }
      
      public function createParticle(param1:String) : SwfParticleSyetem
      {
         var _loc4_:* = 0;
         var _loc3_:* = _swfs;
         for each(var _loc2_ in _swfs)
         {
            if(_loc2_.hasParticle(param1))
            {
               return _loc2_.createParticle(param1);
            }
         }
         return null;
      }
      
      public function get otherAssets() : AssetManager
      {
         return _otherAssets;
      }
      
      public function get isLoading() : Boolean
      {
         return _isLoading;
      }
      
      public function get verbose() : Boolean
      {
         return _verbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         _verbose = param1;
      }
      
      protected function log(param1:String) : void
      {
         if(_verbose)
         {
            LogUtil("SwfAssetManager:" + param1);
         }
      }
   }
}
