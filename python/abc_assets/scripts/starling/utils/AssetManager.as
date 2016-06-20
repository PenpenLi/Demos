package starling.utils
{
   import starling.events.EventDispatcher;
   import starling.core.Starling;
   import starling.textures.TextureOptions;
   import flash.utils.Dictionary;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.clearTimeout;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import starling.text.TextField;
   import starling.text.BitmapFont;
   import flash.display.Bitmap;
   import starling.textures.AtfData;
   import flash.net.URLLoader;
   import flash.events.IOErrorEvent;
   import flash.events.HTTPStatusEvent;
   import flash.events.ProgressEvent;
   import flash.system.LoaderContext;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.net.FileReference;
   
   public class AssetManager extends EventDispatcher
   {
      
      private static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private static const NAME_REGEX:RegExp = new RegExp("([^\\?\\/\\\\]+?)(?:\\.([\\w\\-]+))?(?:\\?.*)?$");
       
      private var mStarling:Starling;
      
      private var mNumLostTextures:int;
      
      private var mNumRestoredTextures:int;
      
      private var mDefaultTextureOptions:TextureOptions;
      
      private var mCheckPolicyFile:Boolean;
      
      private var mKeepAtlasXmls:Boolean;
      
      private var mKeepFontXmls:Boolean;
      
      private var mVerbose:Boolean;
      
      private var mQueue:Array;
      
      private var mIsLoading:Boolean;
      
      private var mTimeoutID:uint;
      
      private var mTextures:Dictionary;
      
      private var mAtlases:Dictionary;
      
      private var mSounds:Dictionary;
      
      private var mXmls:Dictionary;
      
      private var mObjects:Dictionary;
      
      private var mByteArrays:Dictionary;
      
      private var runtimeLoadTexture:Dictionary;
      
      private var encryAssets:Array;
      
      private var _loadTextureList:Vector.<Array>;
      
      private var _isLoading:Boolean = false;
      
      public function AssetManager(param1:Number = 1, param2:Boolean = false)
      {
         encryAssets = ["beginnersGuide","character","sta_bigNode","sta_features","sta_guildLv","sta_guildTitle","sta_home","sta_insectBuff","sta_insectIntegral","sta_insectNode","sta_kingRoad","sta_lvExp","sta_mega","sta_megaConsumption","sta_needSkillTips","sta_nodeRcd","sta_playNotice","sta_poke","sta_pokeQuality","sta_prop","sta_qualityInfo","sta_rawPokeNode","sta_rechargeInfo","sta_sensitiveWord","sta_skill","sta_smallNode","sta_specialMails","sta_startChat","sta_task","sta_trainInfo","sta_trial","sta_vip","sta_vipLvInfo"];
         _loadTextureList = new Vector.<Array>();
         super();
         mDefaultTextureOptions = new TextureOptions(param1,param2);
         mTextures = new Dictionary();
         mAtlases = new Dictionary();
         mSounds = new Dictionary();
         mXmls = new Dictionary();
         mObjects = new Dictionary();
         mByteArrays = new Dictionary();
         mQueue = [];
         runtimeLoadTexture = new Dictionary();
      }
      
      public function dispose() : void
      {
         var _loc6_:* = 0;
         var _loc5_:* = mTextures;
         for each(var _loc1_ in mTextures)
         {
            _loc1_.dispose();
         }
         var _loc8_:* = 0;
         var _loc7_:* = mAtlases;
         for each(var _loc4_ in mAtlases)
         {
            _loc4_.dispose();
         }
         var _loc10_:* = 0;
         var _loc9_:* = mXmls;
         for each(var _loc3_ in mXmls)
         {
            System.disposeXML(_loc3_);
         }
         var _loc12_:* = 0;
         var _loc11_:* = mByteArrays;
         for each(var _loc2_ in mByteArrays)
         {
            _loc2_.clear();
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         var _loc2_:* = null;
         if(param1 in mTextures)
         {
            return mTextures[param1];
         }
         var _loc5_:* = 0;
         var _loc4_:* = mAtlases;
         for each(var _loc3_ in mAtlases)
         {
            _loc2_ = _loc3_.getTexture(param1);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         if(param2 == null)
         {
            var param2:Vector.<Texture> = new Vector.<Texture>(0);
         }
         var _loc5_:* = 0;
         var _loc4_:* = getTextureNames(param1,sNames);
         for each(var _loc3_ in getTextureNames(param1,sNames))
         {
            param2.push(getTexture(_loc3_));
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getTextureNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         var param2:Vector.<String> = getDictionaryKeys(mTextures,param1,param2);
         var _loc5_:* = 0;
         var _loc4_:* = mAtlases;
         for each(var _loc3_ in mAtlases)
         {
            _loc3_.getNames(param1,param2);
         }
         param2.sort(1);
         return param2;
      }
      
      public function getTextureAtlas(param1:String) : TextureAtlas
      {
         return mAtlases[param1] as TextureAtlas;
      }
      
      public function getSound(param1:String) : Sound
      {
         return mSounds[param1];
      }
      
      public function getSoundNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mSounds,param1,param2);
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
      {
         if(param1 in mSounds)
         {
            return getSound(param1).play(param2,param3,param4);
         }
         return null;
      }
      
      public function getXml(param1:String) : XML
      {
         return mXmls[param1];
      }
      
      public function getXmlNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mXmls,param1,param2);
      }
      
      public function getObject(param1:String) : Object
      {
         return mObjects[param1];
      }
      
      public function getObjectNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mObjects,param1,param2);
      }
      
      public function getByteArray(param1:String) : ByteArray
      {
         return mByteArrays[param1];
      }
      
      public function getByteArrayNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mByteArrays,param1,param2);
      }
      
      public function addTexture(param1:String, param2:Texture) : void
      {
         log("Adding texture \'" + param1 + "\'");
         if(param1 in mTextures)
         {
            log("Warning: name was already in use; the previous texture will be replaced.");
            mTextures[param1].dispose();
         }
         mTextures[param1] = param2;
      }
      
      public function addTextureAtlas(param1:String, param2:TextureAtlas) : void
      {
         log("Adding texture atlas \'" + param1 + "\'");
         if(param1 in mAtlases)
         {
            log("Warning: name was already in use; the previous atlas will be replaced.");
            mAtlases[param1].dispose();
         }
         mAtlases[param1] = param2;
      }
      
      public function addSound(param1:String, param2:Sound) : void
      {
         log("Adding sound \'" + param1 + "\'");
         if(param1 in mSounds)
         {
            log("Warning: name was already in use; the previous sound will be replaced.");
         }
         mSounds[param1] = param2;
      }
      
      public function addXml(param1:String, param2:XML) : void
      {
         log("Adding XML \'" + param1 + "\'");
         if(param1 in mXmls)
         {
            log("Warning: name was already in use; the previous XML will be replaced.");
            System.disposeXML(mXmls[param1]);
         }
         mXmls[param1] = param2;
      }
      
      public function addObject(param1:String, param2:Object) : void
      {
         log("Adding object \'" + param1 + "\'");
         if(param1 in mObjects)
         {
            log("Warning: name was already in use; the previous object will be replaced.");
         }
         mObjects[param1] = param2;
      }
      
      public function addByteArray(param1:String, param2:ByteArray) : void
      {
         log("Adding byte array \'" + param1 + "\'");
         if(param1 in mByteArrays)
         {
            log("Warning: name was already in use; the previous byte array will be replaced.");
            mByteArrays[param1].clear();
         }
         mByteArrays[param1] = param2;
      }
      
      public function removeTexture(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture \'" + param1 + "\'");
         if(param2 && param1 in mTextures)
         {
            mTextures[param1].dispose();
         }
      }
      
      public function removeTextureAtlas(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture atlas \'" + param1 + "\'");
         if(param2 && param1 in mAtlases)
         {
            mAtlases[param1].dispose();
         }
      }
      
      public function removeSound(param1:String) : void
      {
         log("Removing sound \'" + param1 + "\'");
      }
      
      public function removeXml(param1:String, param2:Boolean = true) : void
      {
         log("Removing xml \'" + param1 + "\'");
         if(param2 && param1 in mXmls)
         {
            System.disposeXML(mXmls[param1]);
         }
      }
      
      public function removeObject(param1:String) : void
      {
         log("Removing object \'" + param1 + "\'");
      }
      
      public function removeByteArray(param1:String, param2:Boolean = true) : void
      {
         log("Removing byte array \'" + param1 + "\'");
         if(param2 && param1 in mByteArrays)
         {
            mByteArrays[param1].clear();
         }
      }
      
      public function purgeQueue() : void
      {
         mIsLoading = false;
         mQueue.length = 0;
         clearTimeout(mTimeoutID);
         dispatchEventWith("cancel");
      }
      
      public function purge() : void
      {
         log("Purging all assets, emptying queue");
         purgeQueue();
         dispose();
         mTextures = new Dictionary();
         mAtlases = new Dictionary();
         mSounds = new Dictionary();
         mXmls = new Dictionary();
         mObjects = new Dictionary();
         mByteArrays = new Dictionary();
      }
      
      public function enqueue(... rest) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc16_:* = 0;
         var _loc15_:* = rest;
         for each(var _loc3_ in rest)
         {
            if(_loc3_ is Array)
            {
               enqueue.apply(this,_loc3_);
            }
            else if(_loc3_ is Class)
            {
               _loc4_ = describeType(_loc3_);
               if(mVerbose)
               {
                  log("Looking for static embedded assets in \'" + _loc4_.@name.split("::").pop() + "\'");
               }
               var _loc10_:* = 0;
               var _loc5_:* = _loc4_.constant;
               var _loc6_:* = 0;
               var _loc8_:* = new XMLList("");
               var _loc9_:* = _loc4_.constant.(@type == "Class");
               for each(_loc2_ in _loc4_.constant.(@type == "Class"))
               {
                  enqueueWithName(_loc3_[_loc2_.@name],_loc2_.@name);
               }
               var _loc14_:* = 0;
               var _loc11_:* = _loc4_.variable;
               var _loc12_:* = 0;
               _loc5_ = new XMLList("");
               var _loc13_:* = _loc4_.variable.(@type == "Class");
               for each(_loc2_ in _loc4_.variable.(@type == "Class"))
               {
                  enqueueWithName(_loc3_[_loc2_.@name],_loc2_.@name);
               }
            }
            else if(getQualifiedClassName(_loc3_) == "flash.filesystem::File")
            {
               if(!_loc3_["exists"])
               {
                  log("File or directory not found: \'" + _loc3_["url"] + "\'");
               }
               else if(!_loc3_["isHidden"])
               {
                  if(_loc3_["isDirectory"])
                  {
                     enqueue.apply(this,§§dup(_loc3_)["getDirectoryListing"]());
                  }
                  else
                  {
                     enqueueWithName(_loc3_);
                  }
               }
            }
            else if(_loc3_ is String)
            {
               enqueueWithName(_loc3_);
            }
            else
            {
               log("Ignoring unsupported asset type: " + getQualifiedClassName(_loc3_));
            }
         }
      }
      
      public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         if(getQualifiedClassName(param1) == "flash.filesystem::File")
         {
            var param1:Object = decodeURI(param1["url"]);
         }
         if(param2 == null)
         {
            var param2:String = getName(param1);
         }
         if(param3 == null)
         {
            var param3:TextureOptions = mDefaultTextureOptions;
         }
         else
         {
            param3 = param3.clone();
         }
         log("Enqueuing \'" + param2 + "\'");
         mQueue.push({
            "name":param2,
            "asset":param1,
            "options":param3
         });
         return param2;
      }
      
      public function loadQueue(param1:Function, param2:Function = null) : void
      {
         onProgress = param1;
         onError = param2;
         resume = function():void
         {
            currentRatio = mQueue.length?1 - mQueue.length / numElements:1.0;
            if(mQueue.length)
            {
               mTimeoutID = setTimeout(processNext,1);
            }
            else
            {
               processXmls();
               mIsLoading = false;
            }
            if(onProgress != null)
            {
               onProgress(currentRatio);
            }
         };
         processNext = function():void
         {
            var _loc1_:Object = mQueue.shift();
            clearTimeout(mTimeoutID);
            processRawAsset(_loc1_.name,_loc1_.asset,_loc1_.options,xmls,progress,resume);
         };
         processXmls = function():void
         {
            xmls.sort(function(param1:XML, param2:XML):int
            {
               return param1.localName() == "TextureAtlas"?-1:1.0;
            });
            var _loc3_:* = 0;
            var _loc2_:* = xmls;
            for each(xml in xmls)
            {
               var rootNode:String = xml.localName();
               if(rootNode == "TextureAtlas")
               {
                  var name:String = getName(xml.@imagePath.toString());
                  var texture:Texture = getTexture(name);
                  if(texture)
                  {
                     addTextureAtlas(name,new TextureAtlas(texture,xml));
                     if(mKeepAtlasXmls)
                     {
                        addXml(name,xml);
                     }
                     else
                     {
                        System.disposeXML(xml);
                     }
                  }
                  else
                  {
                     log("Cannot create atlas: texture \'" + name + "\' is missing.");
                  }
                  continue;
               }
               if(rootNode == "font")
               {
                  name = getName(xml.pages.page.@file.toString());
                  texture = getTexture(name);
                  if(texture)
                  {
                     log("Adding bitmap font \'" + name + "\'");
                     TextField.registerBitmapFont(new BitmapFont(texture,xml),name);
                     if(mKeepFontXmls)
                     {
                        addXml(name,xml);
                     }
                     else
                     {
                        System.disposeXML(xml);
                     }
                  }
                  else
                  {
                     log("Cannot create bitmap font: texture \'" + name + "\' is missing.");
                  }
                  continue;
               }
               throw new Error("XML contents not recognized: " + rootNode);
            }
         };
         progress = function(param1:Number):void
         {
         };
         mStarling = Starling.current;
         if(mStarling == null || mStarling.context == null)
         {
            throw new Error("The Starling instance needs to be ready before textures can be loaded.");
         }
         if(mIsLoading)
         {
            log("正在加载中。请稍后再试");
            if(onError != null)
            {
               onError();
            }
            return;
         }
         var xmls:Vector.<XML> = new Vector.<XML>(0);
         var numElements:int = mQueue.length;
         var currentRatio:Number = 0.0;
         mIsLoading = true;
         return;
         §§push(resume());
      }
      
      private function processRawAsset(param1:String, param2:Object, param3:TextureOptions, param4:Vector.<XML>, param5:Function, param6:Function) : void
      {
         name = param1;
         rawAsset = param2;
         options = param3;
         xmls = param4;
         onProgress = param5;
         onComplete = param6;
         process = function(param1:Object):void
         {
            asset = param1;
            mStarling.makeCurrent();
            if(!canceled)
            {
               if(asset == null)
               {
                  onComplete();
               }
               else if(asset is Sound)
               {
                  addSound(name,asset as Sound);
                  onComplete();
               }
               else if(asset is XML)
               {
                  var xml:XML = asset as XML;
                  var rootNode:String = xml.localName();
                  if(rootNode == "TextureAtlas" || rootNode == "font")
                  {
                     xmls.push(xml);
                  }
                  else
                  {
                     addXml(name,xml);
                  }
                  onComplete();
               }
               else if(Starling.handleLostContext && mStarling.context.driverInfo == "Disposed")
               {
                  log("Context lost while processing assets, retrying ...");
                  return;
                  §§push(setTimeout(process,1,asset));
               }
               else if(asset is Bitmap)
               {
                  var texture:Texture = Texture.fromData(asset,options);
                  texture.root.onRestore = function():void
                  {
                     mNumLostTextures = mNumLostTextures + 1;
                     loadRawAsset(rawAsset,null,function(param1:Object):void
                     {
                        try
                        {
                           texture.root.uploadBitmap(param1 as Bitmap);
                        }
                        catch(e:Error)
                        {
                           log("Texture restoration failed: " + e.message);
                        }
                        param1.bitmapData.dispose();
                        mNumRestoredTextures = mNumRestoredTextures + 1;
                        if(mNumLostTextures == mNumRestoredTextures)
                        {
                           dispatchEventWith("texturesRestored");
                        }
                     });
                  };
                  asset.bitmapData.dispose();
                  addTexture(name,texture);
                  onComplete();
               }
               else if(asset is ByteArray)
               {
                  var bytes:ByteArray = asset as ByteArray;
                  if(AtfData.isAtfData(bytes))
                  {
                     options.onReady = onComplete;
                     texture = Texture.fromData(bytes,options);
                     texture.root.onRestore = function():void
                     {
                        mNumLostTextures = mNumLostTextures + 1;
                        loadRawAsset(rawAsset,null,function(param1:Object):void
                        {
                           try
                           {
                              texture.root.uploadAtfData(param1 as ByteArray,0,true);
                           }
                           catch(e:Error)
                           {
                              log("Texture restoration failed: " + e.message);
                           }
                           param1.clear();
                           mNumRestoredTextures = mNumRestoredTextures + 1;
                           if(mNumLostTextures == mNumRestoredTextures)
                           {
                              dispatchEventWith("texturesRestored");
                           }
                        });
                     };
                     bytes.clear();
                     addTexture(name,texture);
                  }
                  else if(byteArrayStartsWith(bytes,"{") || byteArrayStartsWith(bytes,"["))
                  {
                     addObject(name,JSON.parse(bytes.readUTFBytes(bytes.length)));
                     bytes.clear();
                     onComplete();
                  }
                  else if(byteArrayStartsWith(bytes,"<"))
                  {
                     process(new XML(bytes));
                     bytes.clear();
                  }
                  else
                  {
                     addByteArray(name,bytes);
                     onComplete();
                  }
               }
               else
               {
                  log("Ignoring unsupported asset type: " + getQualifiedClassName(asset));
                  onComplete();
               }
            }
            var asset:Object = null;
            bytes = null;
            removeEventListener("cancel",cancel);
         };
         progress = function(param1:Number):void
         {
            if(!canceled)
            {
               onProgress(param1);
            }
         };
         cancel = function():void
         {
            canceled = true;
         };
         var canceled:Boolean = false;
         addEventListener("cancel",cancel);
         loadRawAsset(rawAsset,progress,process,name);
      }
      
      private function loadRawAsset(param1:Object, param2:Function, param3:Function, param4:* = "") : void
      {
         rawAsset = param1;
         onProgress = param2;
         onComplete = param3;
         name = param4;
         onIoError = function(param1:IOErrorEvent):void
         {
            log("IO error: " + param1.text);
         };
         onHttpResponseStatus = function(param1:HTTPStatusEvent):void
         {
            var _loc2_:* = null;
            var _loc3_:* = null;
            if(extension == null)
            {
               _loc2_ = param1["responseHeaders"];
               _loc3_ = getHttpHeader(_loc2_,"Content-Type");
               if(_loc3_ && new RegExp("(audio|image)\\/").exec(_loc3_))
               {
                  extension = _loc3_.split("/").pop();
               }
            }
         };
         onLoadProgress = function(param1:ProgressEvent):void
         {
            if(onProgress != null)
            {
               onProgress(param1.bytesLoaded / param1.bytesTotal);
            }
         };
         onUrlLoaderComplete = function(param1:Object):void
         {
            var _loc2_:* = false;
            var _loc7_:* = 0;
            var _loc6_:* = null;
            var _loc5_:* = null;
            var _loc4_:* = null;
            var _loc3_:ByteArray = transformData(urlLoader.data as ByteArray,url);
            _loc7_ = 0;
            while(_loc7_ < encryAssets.length)
            {
               if(name == encryAssets[_loc7_])
               {
                  _loc3_ = decryptByteArray(_loc3_);
                  _loc2_ = true;
                  break;
               }
               _loc7_++;
            }
            if(!_loc2_)
            {
               _loc3_.uncompress();
            }
            urlLoader.removeEventListener("ioError",onIoError);
            urlLoader.removeEventListener("httpResponseStatus",onHttpResponseStatus);
            urlLoader.removeEventListener("progress",onLoadProgress);
            urlLoader.removeEventListener("complete",onUrlLoaderComplete);
            if(extension)
            {
               extension = extension.toLowerCase();
            }
            var _loc8_:* = extension;
            if("mpeg" !== _loc8_)
            {
               if("mp3" !== _loc8_)
               {
                  if("jpg" !== _loc8_)
                  {
                     if("jpeg" !== _loc8_)
                     {
                        if("png" !== _loc8_)
                        {
                           if("gif" !== _loc8_)
                           {
                              complete(_loc3_);
                           }
                        }
                        addr93:
                        _loc5_ = new LoaderContext(mCheckPolicyFile);
                        _loc4_ = new Loader();
                        _loc5_.imageDecodingPolicy = "onLoad";
                        _loc4_.contentLoaderInfo.addEventListener("complete",onLoaderComplete);
                        _loc4_.loadBytes(_loc3_,_loc5_);
                     }
                     addr92:
                     §§goto(addr93);
                  }
                  §§goto(addr92);
               }
               addr142:
               return;
            }
            _loc6_ = new Sound();
            _loc6_.loadCompressedDataFromByteArray(_loc3_,_loc3_.length);
            _loc3_.clear();
            complete(_loc6_);
            §§goto(addr142);
         };
         onLoaderComplete = function(param1:Object):void
         {
            urlLoader.data.clear();
            param1.target.removeEventListener("complete",onLoaderComplete);
         };
         complete = function(param1:Object):void
         {
            if(SystemUtil.isDesktop)
            {
               onComplete(param1);
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(onComplete,param1);
            }
         };
         var extension:String = null;
         var urlLoader:URLLoader = null;
         var url:String = null;
         if(rawAsset is Class)
         {
            setTimeout(complete,1,new rawAsset());
         }
         else if(rawAsset is String)
         {
            url = rawAsset as String;
            extension = getExtensionFromUrl(url);
            urlLoader = new URLLoader();
            urlLoader.dataFormat = "binary";
            urlLoader.addEventListener("ioError",onIoError);
            urlLoader.addEventListener("httpResponseStatus",onHttpResponseStatus);
            urlLoader.addEventListener("progress",onLoadProgress);
            urlLoader.addEventListener("complete",onUrlLoaderComplete);
            urlLoader.load(new URLRequest(url));
         }
      }
      
      public function decryptByteArray(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         param1.position = 9;
         param1.readBytes(_loc2_,0,param1.bytesAvailable);
         _loc2_.uncompress();
         param1.clear();
         return _loc2_;
      }
      
      public function loadTexture(param1:String, param2:Function, param3:Boolean = true) : void
      {
         path = param1;
         callBack = param2;
         isCache = param3;
         urlLoadError = function(param1:Object):void
         {
            urlLoader.removeEventListener("complete",urlLoaderComplete);
            urlLoader.removeEventListener("ioError",urlLoadError);
            if(callBack != null)
            {
               callBack(null);
            }
         };
         urlLoaderComplete = function(param1:Object):void
         {
            var _loc3_:* = null;
            var _loc2_:* = null;
            urlLoader.removeEventListener("complete",urlLoaderComplete);
            urlLoader.removeEventListener("ioError",urlLoadError);
            bytes = urlLoader.data;
            var _loc4_:* = extesion;
            if("atf" !== _loc4_)
            {
               if("png" !== _loc4_)
               {
                  if("jpg" !== _loc4_)
                  {
                  }
               }
               _loc3_ = new LoaderContext(mCheckPolicyFile);
               _loc2_ = new Loader();
               _loc3_.imageDecodingPolicy = "onLoad";
               _loc2_.contentLoaderInfo.addEventListener("complete",onLoaderComplete);
               _loc2_.loadBytes(bytes,_loc3_);
            }
            else
            {
               completeAssets(bytes);
            }
         };
         onLoaderComplete = function(param1:Object):void
         {
            param1.target.removeEventListener("complete",onLoaderComplete);
            var _loc2_:Bitmap = param1.target.content as Bitmap;
         };
         completeAssets = function(param1:Object):void
         {
            asset = param1;
            if(asset is Bitmap)
            {
               texture = Texture.fromData(asset,mDefaultTextureOptions.clone());
               texture.root.onRestore = function():void
               {
                  mNumLostTextures = mNumLostTextures + 1;
                  loadRawAsset(path,null,function(param1:Object):void
                  {
                     try
                     {
                        texture.root.uploadBitmap(param1 as Bitmap);
                     }
                     catch(e:Error)
                     {
                        log("Texture restoration failed: " + e.message);
                     }
                     param1.bitmapData.dispose();
                     mNumRestoredTextures = mNumRestoredTextures + 1;
                     if(mNumLostTextures == mNumRestoredTextures)
                     {
                        dispatchEventWith("texturesRestored");
                     }
                  });
               };
               asset.bitmapData.dispose();
               if(callBack != null)
               {
                  callBack(texture);
               }
            }
            else if(asset is ByteArray)
            {
               bytes = asset as ByteArray;
               if(AtfData.isAtfData(bytes))
               {
                  var options:TextureOptions = mDefaultTextureOptions.clone();
                  options.onReady = atfOnReady;
                  texture = Texture.fromData(bytes,options);
                  texture.root.onRestore = function():void
                  {
                     mNumLostTextures = mNumLostTextures + 1;
                     loadRawAsset(path,null,function(param1:Object):void
                     {
                        try
                        {
                           texture.root.uploadAtfData(param1 as ByteArray,0,true);
                        }
                        catch(e:Error)
                        {
                           log("Texture restoration failed: " + e.message);
                        }
                        param1.clear();
                        mNumRestoredTextures = mNumRestoredTextures + 1;
                        if(mNumLostTextures == mNumRestoredTextures)
                        {
                           dispatchEventWith("texturesRestored");
                        }
                     });
                  };
               }
            }
            bytes.clear();
            if(isCache)
            {
               runtimeLoadTexture[name] = texture;
            }
         };
         atfOnReady = function():void
         {
            if(callBack != null)
            {
               callBack(texture);
            }
         };
         completeLoadIist = function():void
         {
            var _loc1_:* = null;
            _isLoading = false;
            if(_loadTextureList.length > 0)
            {
               _loc1_ = _loadTextureList.shift();
               loadTexture(_loc1_[0],_loc1_[1],_loc1_[2]);
            }
         };
         if(_isLoading)
         {
            _loadTextureList.push([path,callBack,isCache]);
            return;
         }
         var name:String = getName(path);
         var texture:Texture = runtimeLoadTexture[name];
         if(texture)
         {
            if(callBack != null)
            {
               callBack(texture);
            }
            return;
            §§push(completeLoadIist());
         }
         else
         {
            _isLoading = true;
            log("run time load:" + path);
            var extesion:String = path.split(".").pop().toLowerCase();
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.dataFormat = "binary";
            urlLoader.addEventListener("complete",urlLoaderComplete);
            urlLoader.addEventListener("ioError",urlLoadError);
            urlLoader.load(new URLRequest(path));
            return;
         }
      }
      
      public function clearRuntimeLoadTexture() : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = runtimeLoadTexture;
         for each(var _loc1_ in runtimeLoadTexture)
         {
            _loc1_.dispose();
         }
         runtimeLoadTexture = new Dictionary();
      }
      
      protected function getName(param1:Object) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1 is String || param1 is FileReference)
         {
            _loc3_ = param1 is String?param1 as String:(param1 as FileReference).name;
            _loc3_ = _loc3_.replace(new RegExp("%20","g")," ");
            _loc3_ = getBasenameFromUrl(_loc3_);
            if(_loc3_)
            {
               return _loc3_;
            }
            throw new ArgumentError("Could not extract name from String \'" + param1 + "\'");
         }
         _loc3_ = getQualifiedClassName(param1);
         throw new ArgumentError("Cannot extract names for objects of type \'" + _loc3_ + "\'");
      }
      
      protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         return param1;
      }
      
      protected function log(param1:String) : void
      {
         if(mVerbose)
         {
            LogUtil("[AssetManager]",param1);
         }
      }
      
      private function byteArrayStartsWith(param1:ByteArray, param2:String) : Boolean
      {
         var _loc7_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:int = param1.length;
         var _loc6_:int = param2.charCodeAt(0);
         if(_loc5_ >= 4 && param1[0] == 0 && param1[1] == 0 && param1[2] == 254 && param1[3] == 255 || param1[0] == 255 && param1[1] == 254 && param1[2] == 0 && param1[3] == 0)
         {
            _loc4_ = 4;
         }
         else if(_loc5_ >= 3 && param1[0] == 239 && param1[1] == 187 && param1[2] == 191)
         {
            _loc4_ = 3;
         }
         else if(_loc5_ >= 2 && param1[0] == 254 && param1[1] == 255 || param1[0] == 255 && param1[1] == 254)
         {
            _loc4_ = 2;
         }
         _loc7_ = _loc4_;
         while(_loc7_ < _loc5_)
         {
            _loc3_ = param1[_loc7_];
            if(!(_loc3_ == 0 || _loc3_ == 10 || _loc3_ == 13 || _loc3_ == 32))
            {
               return _loc3_ == _loc6_;
            }
            _loc7_++;
         }
         return false;
      }
      
      private function getDictionaryKeys(param1:Dictionary, param2:String = "", param3:Vector.<String> = null) : Vector.<String>
      {
         if(param3 == null)
         {
            var param3:Vector.<String> = new Vector.<String>(0);
         }
         var _loc6_:* = 0;
         var _loc5_:* = param1;
         for(var _loc4_ in param1)
         {
            if(_loc4_.indexOf(param2) == 0)
            {
               param3.push(_loc4_);
            }
         }
         param3.sort(1);
         return param3;
      }
      
      private function getHttpHeader(param1:Array, param2:String) : String
      {
         if(param1)
         {
            var _loc5_:* = 0;
            var _loc4_:* = param1;
            for each(var _loc3_ in param1)
            {
               if(_loc3_.name == param2)
               {
                  return _loc3_.value;
               }
            }
         }
         return null;
      }
      
      private function getBasenameFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 0)
         {
            return _loc2_[1];
         }
         return null;
      }
      
      private function getExtensionFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 1)
         {
            return _loc2_[2];
         }
         return null;
      }
      
      protected function get queue() : Array
      {
         return mQueue;
      }
      
      public function get numQueuedAssets() : int
      {
         return mQueue.length;
      }
      
      public function get verbose() : Boolean
      {
         return mVerbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         mVerbose = param1;
      }
      
      public function get useMipMaps() : Boolean
      {
         return mDefaultTextureOptions.mipMapping;
      }
      
      public function set useMipMaps(param1:Boolean) : void
      {
         mDefaultTextureOptions.mipMapping = param1;
      }
      
      public function get scaleFactor() : Number
      {
         return mDefaultTextureOptions.scale;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         mDefaultTextureOptions.scale = param1;
      }
      
      public function get checkPolicyFile() : Boolean
      {
         return mCheckPolicyFile;
      }
      
      public function set checkPolicyFile(param1:Boolean) : void
      {
         mCheckPolicyFile = param1;
      }
      
      public function get keepAtlasXmls() : Boolean
      {
         return mKeepAtlasXmls;
      }
      
      public function set keepAtlasXmls(param1:Boolean) : void
      {
         mKeepAtlasXmls = param1;
      }
      
      public function get keepFontXmls() : Boolean
      {
         return mKeepFontXmls;
      }
      
      public function set keepFontXmls(param1:Boolean) : void
      {
         mKeepFontXmls = param1;
      }
   }
}
