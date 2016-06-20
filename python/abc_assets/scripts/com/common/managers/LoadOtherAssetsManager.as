package com.common.managers
{
   import flash.media.SoundChannel;
   import flash.events.Event;
   import extend.SoundEvent;
   import starling.utils.AssetManager;
   import flash.filesystem.File;
   import starling.utils.formatString;
   import lzm.starling.STLConstant;
   import com.common.net.Client;
   import com.common.events.EventCenter;
   import com.mvc.views.uis.mainCity.mining.MiningFrameUI;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.common.util.loading.GameLoading;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.media.SoundTransform;
   import starling.core.Starling;
   import flash.desktop.NativeApplication;
   
   public class LoadOtherAssetsManager
   {
      
      private static var soundC:SoundChannel;
      
      private static var instance:com.common.managers.LoadOtherAssetsManager = null;
       
      private var _assets:AssetManager;
      
      private var file:File;
      
      private var assetsArray:Array;
      
      private var version:String;
      
      private var addElfList:Array;
      
      public function LoadOtherAssetsManager()
      {
         addElfList = ["chao1li4wang2_light","feng4wang2_mega","he4la1ke4luo2si1_mega","jing1jiao3lu4_light","ju4qian2tang2lang2_mega","luo4qi2ya4_light_mega","luo4qi2ya4_light","luo4qi2ya4_mega","luo4qi2ya4"];
         super();
         _assets = new AssetManager(STLConstant.scale);
         _assets.verbose = true;
         assetsArray = Config.configInfo.otherAssets;
         var _loc1_:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var _loc2_:Namespace = _loc1_.namespace();
         version = _loc1_._loc2_::versionNumber;
      }
      
      protected static function playOnceComplete(param1:Event) : void
      {
         if(soundC)
         {
            soundC.removeEventListener("soundComplete",playOnceComplete);
         }
         SoundEvent.dispatchEvent("PLAY_ONCE_COMPLETE");
      }
      
      public static function getInstance() : com.common.managers.LoadOtherAssetsManager
      {
         return instance || new com.common.managers.LoadOtherAssetsManager();
      }
      
      private function setFile(param1:String) : void
      {
         var _loc2_:Object = getAssetsInfo(param1);
         if(_loc2_ == null)
         {
            file = File.applicationDirectory;
            return;
         }
         if(_loc2_.assetsType == 0 || (_loc2_.bigVersion as Array).indexOf(version) == -1)
         {
            file = File.applicationDirectory;
         }
         else
         {
            file = File.applicationStorageDirectory;
         }
      }
      
      private function getAssetsInfo(param1:String) : Object
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         if(param1 == "startBg.jpg")
         {
            _loc3_ = 0;
            while(_loc3_ < Config.configInfo.ui.length)
            {
               if(Config.configInfo.ui[_loc3_].assetsName == param1)
               {
                  return Config.configInfo.ui[_loc3_];
               }
               _loc3_++;
            }
            return null;
         }
         _loc2_ = 0;
         while(_loc2_ < assetsArray.length)
         {
            if(assetsArray[_loc2_].assetsName == param1)
            {
               return assetsArray[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addAssets(param1:Array) : void
      {
         assets = param1;
         var i:int = 0;
         while(i < assets.length)
         {
            setFile(assets[i]);
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/" + assets[i],STLConstant.scale)));
            file = null;
            i = i + 1;
         }
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               LogUtil("加载完成");
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               EventCenter.dispatchEvent("load_other_asset_complete");
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addGotoGameAssets() : void
      {
         LogUtil("加载音效和公共资源");
         setFile("pageMusic");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/pageMusic",STLConstant.scale)));
         file = null;
         setFile("music");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/effectMusic",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               LogUtil("加载完成");
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               LoadSwfAssetsManager.getInstance().addCommentAssets();
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addEvolveAssets(param1:Array) : void
      {
         assetName = param1;
         (Config.starling.root as Game).touchable = false;
         setFile("music");
         var i:int = 0;
         while(i < assetName.length)
         {
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/evolve/" + assetName[i] + ".mp3",STLConstant.scale)));
            i = i + 1;
         }
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               SoundEvent.dispatchEvent("PLAY_BACKGROUND_MUSIC","evolveBg");
               LoadSwfAssetsManager.getInstance().addAssets(Config.elfEvolveMcAssets);
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addLoginAssets() : void
      {
         setFile("login");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/loginOther",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               EventCenter.addEventListener("load_swf_asset_complete",loadLoginComplete);
               LoadSwfAssetsManager.getInstance().addAssets(["login","elf_m","elf_m2","personalInfo"]);
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      private function loadLoginComplete() : void
      {
         LogUtil("加载登录完成");
         EventCenter.removeEventListener("load_swf_asset_complete",loadLoginComplete);
         EventCenter.dispatchEvent("LOAD_LOGIN_ASSET_COMPLETE");
      }
      
      public function addElfBackAssets(param1:Array) : void
      {
         var _loc4_:* = false;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = false;
            _loc3_ = 0;
            while(_loc3_ < addElfList.length)
            {
               if(addElfList[_loc3_] + "_b" == param1[_loc2_])
               {
                  setFile("elfBackAdd");
                  _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/elfBackAdd/" + param1[_loc2_] + ".png",STLConstant.scale)));
                  file = null;
                  _loc4_ = true;
                  break;
               }
               _loc3_++;
            }
            if(_loc4_ == false)
            {
               LogUtil("嵌入原来的精灵呢" + param1[_loc2_]);
               setFile("elfBack");
               _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/elfBack/" + param1[_loc2_] + ".png",STLConstant.scale)));
               file = null;
            }
            _loc2_++;
         }
      }
      
      public function addElfFrontAssets(param1:Array, param2:Boolean) : void
      {
         assets = param1;
         isloadQueue = param2;
         var i:int = 0;
         while(i < assets.length)
         {
            var isAdd:Boolean = false;
            var j:int = 0;
            while(j < addElfList.length)
            {
               if("img_" + addElfList[j] == assets[i])
               {
                  setFile("elfFrontAdd");
                  _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/elfFrontAdd/" + assets[i] + ".png",STLConstant.scale)));
                  file = null;
                  isAdd = true;
                  break;
               }
               j = j + 1;
            }
            if(isAdd == false)
            {
               setFile("elfFront");
               _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/elfFront/" + assets[i] + ".png",STLConstant.scale)));
               file = null;
            }
            i = i + 1;
         }
         if(isloadQueue)
         {
            Config.starling.root.touchable = false;
            if(Client._mutex)
            {
               Client._mutex.lock();
            }
            _assets.loadQueue(function(param1:Number):void
            {
               if(param1 == 1)
               {
                  Config.starling.root.touchable = true;
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  EventCenter.dispatchEvent("load_other_asset_complete");
               }
            },function():void
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
            });
         }
         file = null;
      }
      
      public function addNpcAssets(param1:Array, param2:Boolean) : void
      {
         assets = param1;
         isloadQueue = param2;
         setFile("NPCImage");
         var i:int = 0;
         while(i < assets.length)
         {
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/NPCImage/" + assets[i] + ".png",STLConstant.scale)));
            i = i + 1;
         }
         if(isloadQueue)
         {
            Config.starling.root.touchable = false;
            if(Client._mutex)
            {
               Client._mutex.lock();
            }
            _assets.loadQueue(function(param1:Number):void
            {
               if(param1 == 1)
               {
                  Config.starling.root.touchable = true;
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  EventCenter.dispatchEvent("load_other_asset_complete");
               }
            },function():void
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
            });
         }
         file = null;
      }
      
      public function addFSceneAssets(param1:Array) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         if((Config.starling.root as Game).page is MiningFrameUI)
         {
            _loc3_ = "miningBg";
         }
         else
         {
            _loc3_ = "fightScene";
         }
         setFile(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/" + _loc3_ + "/" + param1[_loc2_] + ".jpg",STLConstant.scale)));
            _loc2_++;
         }
         file = null;
      }
      
      public function addSkillAssets(param1:Array, param2:Boolean) : void
      {
         var _loc3_:* = 0;
         setFile("music");
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/skill/" + param1[_loc3_] + ".mp3",STLConstant.scale)));
            _loc3_++;
         }
         file = null;
      }
      
      public function addFightBGMAssets(param1:Array) : void
      {
         var _loc2_:* = 0;
         setFile("music");
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/fightMusic/" + param1[_loc2_] + ".mp3",STLConstant.scale)));
            _loc2_++;
         }
         file = null;
      }
      
      public function addFightingAssets() : void
      {
         getFightMusicAssets();
         addElfBackAssets(FightingConfig.elfBackAssets);
         addFSceneAssets(FightingConfig.FSceneAssets);
         addSkillAssets(FightingConfig.skillMusicAssets,false);
         addFightBGMAssets(FightingConfig.fightMusicAssets);
         addElfFrontAssets(FightingConfig.elfFrontAssets,false);
         if(NPCVO.name != null)
         {
            addNpcAssets([NPCVO.imageName],false);
         }
         GameLoading.getIntance().showLoading(loadQ);
      }
      
      private function loadQ() : void
      {
         if(Config.isOpenFightingAni)
         {
            FightingConfig.skillAssetsOfUse.push("status");
            LoadSwfAssetsManager.getInstance().addSkillAssets([FightingConfig.skillAssetsOfUse]);
         }
         Config.fightingAssets.push("player" + (PlayerVO.trainPtId - 100000) + "Act");
         LoadSwfAssetsManager.getInstance().addAssets(Config.fightingAssets,true);
      }
      
      private function getFightMusicAssets() : void
      {
         FightingConfig.fightMusicAssets = [];
         if(FightingConfig.selectMap != null)
         {
            if(FightingConfig.selectMap.type == 1 || FightingConfig.selectMap.type == 3)
            {
               if(FightingConfig.selectMap.isClub == 0)
               {
                  FightingConfig.fightMusicAssets = ["trainerFight","trainerWin"];
               }
               else
               {
                  FightingConfig.fightMusicAssets = ["clubFight","clubWin"];
               }
            }
            if(FightingConfig.selectMap.type == 0 || FightingConfig.selectMap.type == 2)
            {
               FightingConfig.fightMusicAssets = ["fieldFight","fieldWin"];
            }
         }
         else
         {
            FightingConfig.fightMusicAssets = ["kingFight","trainerWin"];
         }
      }
      
      public function removeAsset(param1:Array, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:* = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            LogUtil("移除了other资源" + param1[_loc4_]);
            if(param2)
            {
               _assets.removeSound(param1[_loc4_]);
            }
            else if(!param3)
            {
               _assets.removeTexture(param1[_loc4_]);
            }
            else
            {
               _assets.removeXml(param1[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      public function addCityAssets(param1:Boolean = true) : void
      {
         isLoadSwf = param1;
         (Config.starling.root as Game).touchable = false;
         setFile("cityScene");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/cityScene/" + Config.cityScene + ".jpg",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               if(isLoadSwf)
               {
                  LoadSwfAssetsManager.getInstance().addAssets(Config.cityMapAssets);
               }
               else
               {
                  (Config.starling.root as Game).touchable = true;
                  EventCenter.dispatchEvent("load_other_asset_complete");
               }
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addPageLoadingAssets(param1:String) : void
      {
         assets = param1;
         (Config.starling.root as Game).touchable = false;
         setFile("pageLoadingBgs");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/pageLoadingBgs/" + assets + ".jpg",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               (Config.starling.root as Game).touchable = true;
               EventCenter.dispatchEvent("load_other_asset_complete");
               LogUtil(" 页面背景图加载成功!");
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addActivityBgAssets(param1:String) : void
      {
         assets = param1;
         (Config.starling.root as Game).touchable = false;
         setFile("activities");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/activities/" + assets + ".jpg",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               (Config.starling.root as Game).touchable = true;
               EventCenter.dispatchEvent("load_other_asset_complete");
               LogUtil(" 活动背景图加载成功!");
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function addMiningBgAssets(param1:String) : void
      {
         assets = param1;
         (Config.starling.root as Game).touchable = false;
         setFile("miningBg");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/miningBg/" + assets + ".jpg",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               (Config.starling.root as Game).touchable = true;
               EventCenter.dispatchEvent("load_other_asset_complete");
               LogUtil(" 挖矿背景图加载成功!");
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function playElfVoice(param1:String) : void
      {
         voiceName = param1;
         LogUtil("播放精灵叫声：" + voiceName);
         if(assets.playSound(voiceName) == null)
         {
            (Config.starling.root as Game).touchable = false;
            setFile("music");
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/elfVoices/" + voiceName + ".mp3",STLConstant.scale)));
            file = null;
            if(Client._mutex)
            {
               Client._mutex.lock();
            }
            _assets.loadQueue(function(param1:Number):void
            {
               if(param1 == 1)
               {
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  (Config.starling.root as Game).touchable = true;
                  assets.playSound(voiceName);
                  EventCenter.dispatchEvent("PLAY_ELFSOUND_OVER");
               }
            },function():void
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
            });
         }
         else
         {
            LogUtil("已经这个精灵的叫声");
            EventCenter.dispatchEvent("PLAY_ELFSOUND_OVER");
         }
      }
      
      public function playSkillVoice(param1:String) : void
      {
         voiceName = param1;
         LogUtil("播放技能声音：" + voiceName);
         if(!Config.isOpenFightingAni)
         {
            SoundEvent.dispatchEvent("PLAY_ONCE_COMPLETE");
            return;
         }
         soundC = assets.playSound(voiceName);
         if(soundC == null)
         {
            if(Pocketmon.isDeActive)
            {
               Starling.juggler.delayCall(function():void
               {
                  SoundEvent.dispatchEvent("PLAY_ONCE_COMPLETE");
               },0.3);
               return;
            }
            FightingConfig.skillMusicAssets.push(voiceName);
            (Config.starling.root as Game).touchable = false;
            setFile("music");
            _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/skill/" + voiceName + ".mp3",STLConstant.scale)));
            file = null;
            if(Client._mutex)
            {
               Client._mutex.lock();
            }
            _assets.loadQueue(function(param1:Number):void
            {
               var _loc2_:* = null;
               if(param1 == 1)
               {
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  (Config.starling.root as Game).touchable = true;
                  soundC = assets.playSound(voiceName);
                  soundC.addEventListener("soundComplete",playOnceComplete);
                  if(!SoundManager.SESwitch)
                  {
                     _loc2_ = soundC.soundTransform;
                     _loc2_.volume = 0;
                     soundC.soundTransform = _loc2_;
                  }
               }
            },function():void
            {
               Starling.juggler.delayCall(function():void
               {
                  if(Client._mutex)
                  {
                     Client._mutex.unlock();
                  }
                  SoundEvent.dispatchEvent("PLAY_ONCE_COMPLETE");
               },0.3);
            });
         }
         else
         {
            soundC.addEventListener("soundComplete",playOnceComplete);
            if(!SoundManager.SESwitch || Pocketmon.isDeActive)
            {
               var soundTransform:SoundTransform = soundC.soundTransform;
               soundTransform.volume = 0;
               soundC.soundTransform = soundTransform;
            }
         }
      }
      
      public function loadGuideVoice(param1:String, param2:Function) : void
      {
         voiceName = param1;
         callBack = param2;
         LogUtil("加载引导声音:" + voiceName);
         (Config.starling.root as Game).touchable = false;
         setFile("music");
         _assets.enqueue(file.resolvePath(formatString("assets/otherAssets/music/beginGuideVoice/" + voiceName + ".mp3",STLConstant.scale)));
         file = null;
         if(Client._mutex)
         {
            Client._mutex.lock();
         }
         _assets.loadQueue(function(param1:Number):void
         {
            if(param1 == 1)
            {
               if(Client._mutex)
               {
                  Client._mutex.unlock();
               }
               (Config.starling.root as Game).touchable = true;
               callBack();
            }
         },function():void
         {
            if(Client._mutex)
            {
               Client._mutex.unlock();
            }
         });
      }
      
      public function get assets() : AssetManager
      {
         return _assets;
      }
   }
}
