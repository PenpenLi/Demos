package com.common.managers
{
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import extend.SoundEvent;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import starling.core.Starling;
   import starling.animation.Tween;
   import com.mvc.models.vos.fighting.FightingConfig;
   
   public class SoundManager
   {
      
      public static var BGSwitch:Boolean = true;
      
      public static var SESwitch:Boolean = true;
      
      private static var instance:com.common.managers.SoundManager;
       
      private var login:SoundChannel;
      
      private var elfCenter:SoundChannel;
      
      private var trainerFight:SoundChannel;
      
      private var fieldFight:SoundChannel;
      
      private var clubFight:SoundChannel;
      
      private var kingFight:SoundChannel;
      
      private var mainCity:SoundChannel;
      
      private var warmBg:SoundChannel;
      
      private var catchSuccessBg:SoundChannel;
      
      private var evolveBg:SoundChannel;
      
      private var soundTransform:SoundTransform;
      
      private var mainCityLast:Number = 0;
      
      private var trainerFightLast:Number = 0;
      
      private var fieldFightLast:Number = 0;
      
      private var clubFightLast:Number = 0;
      
      private var kingFightLast:Number = 0;
      
      private var loginLast:Number = 0;
      
      private var elfCenterLast:Number = 0;
      
      private var warmBgLast:Number = 0;
      
      private var catchSuccessBgLast:Number = 0;
      
      private var evolveBgLast:Number = 0;
      
      private var soundC:SoundChannel;
      
      private var soundC2:SoundChannel;
      
      private var nowPlayMusic:String;
      
      private var redayMusic:String;
      
      private var nextMusic:String;
      
      private var nowPlayDialogue:String;
      
      private var lastPlayDialogue:String;
      
      private var nowDialogue:SoundChannel;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function getInstance() : com.common.managers.SoundManager
      {
         return instance || new com.common.managers.SoundManager();
      }
      
      public function init() : void
      {
         SoundEvent.addEventListener("PLAY_MUSIC_ONCE",playMusic);
         SoundEvent.addEventListener("play_music_and_stop_bg",playMusicAndStopBg);
         SoundEvent.addEventListener("PLAY_BACKGROUND_MUSIC",playBackMusic);
         SoundEvent.addEventListener("close_music",closeBackMusic);
         SoundEvent.addEventListener("open_music",openBackMusic);
         SoundEvent.addEventListener("PLAY_DIALOGUE_AND_STOP_LAST",playDialogue);
      }
      
      private function playDialogue(param1:starling.events.Event) : void
      {
         LogUtil("播放对话 = " + param1.data,"上次播放的对话=" + nowPlayDialogue);
         nowPlayDialogue = param1.data as String;
         if(nowDialogue != null)
         {
            nowDialogue.stop();
            LoadOtherAssetsManager.getInstance().removeAsset([lastPlayDialogue],true);
            playDia();
         }
         else
         {
            playDia();
         }
      }
      
      private function playDia() : void
      {
         nowDialogue = LoadOtherAssetsManager.getInstance().assets.playSound(nowPlayDialogue);
         if(nowDialogue == null)
         {
            EventCenter.dispatchEvent("DIALOGUE_TALL_OVER");
            return;
         }
         lastPlayDialogue = nowPlayDialogue;
         if(nowPlayMusic != null && this[nowPlayMusic] != null)
         {
            soundTransform = (this[nowPlayMusic] as SoundChannel).soundTransform;
            soundTransform.volume = 0.3;
            (this[nowPlayMusic] as SoundChannel).soundTransform = soundTransform;
         }
         nowDialogue.addEventListener("soundComplete",dialogueComplete);
      }
      
      protected function dialogueComplete(param1:flash.events.Event) : void
      {
         nowDialogue.removeEventListener("soundComplete",dialogueComplete);
         if(nowPlayMusic != null && this[nowPlayMusic] != null)
         {
            soundTransform = (this[nowPlayMusic] as SoundChannel).soundTransform;
            soundTransform.volume = 1;
            (this[nowPlayMusic] as SoundChannel).soundTransform = soundTransform;
         }
         EventCenter.dispatchEvent("DIALOGUE_TALL_OVER");
         LoadOtherAssetsManager.getInstance().removeAsset([lastPlayDialogue],true);
      }
      
      private function openBackMusic() : void
      {
         LogUtil("nowPlayMusic",nowPlayMusic,"BGSwitch",BGSwitch);
         if(!BGSwitch)
         {
            return;
         }
         if(nowPlayMusic)
         {
            continuePlayBGM();
         }
         else
         {
            nowPlayMusic = "mainCity";
            continuePlayBGM();
         }
      }
      
      private function continuePlayBGM() : void
      {
         if(redayMusic != null)
         {
            nowPlayMusic = redayMusic;
            redayMusic = null;
         }
         if(this[nowPlayMusic] != null)
         {
            Starling.juggler.removeTweens(this[nowPlayMusic] as SoundChannel);
            (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
            (this[nowPlayMusic] as SoundChannel).stop();
         }
         this[nowPlayMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nowPlayMusic,this[nowPlayMusic + "Last"]);
         if(this[nowPlayMusic] == null)
         {
            nowPlayMusic = "mainCity";
            if(this[nowPlayMusic] as SoundChannel != null)
            {
               (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
            }
            this[nowPlayMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nowPlayMusic,0,2147483647);
         }
         else
         {
            (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
            (this[nowPlayMusic] as SoundChannel).addEventListener("soundComplete",loopsPlay);
         }
      }
      
      protected function loopsPlay(param1:flash.events.Event) : void
      {
         (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
         this[nowPlayMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nowPlayMusic,0,2147483647);
      }
      
      private function closeBackMusic() : void
      {
         if(nowPlayMusic)
         {
            if(this[nowPlayMusic] == null)
            {
               return;
            }
            this[nowPlayMusic + "Last"] = (this[nowPlayMusic] as SoundChannel).position;
            (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
            (this[nowPlayMusic] as SoundChannel).stop();
            Starling.juggler.removeTweens(this[nowPlayMusic] as SoundChannel);
            stopMusic();
         }
      }
      
      private function playBackMusic(param1:starling.events.Event) : void
      {
         var _loc2_:* = null;
         if(!BGSwitch)
         {
            return;
         }
         LogUtil("播放背景音乐 = " + param1.data,"上次播放的音乐=" + nowPlayMusic);
         nextMusic = param1.data as String;
         if(nowPlayMusic == nextMusic)
         {
            return;
         }
         if(nowPlayMusic != null)
         {
            redayMusic = nextMusic;
            if(this[nowPlayMusic] != null)
            {
               LogUtil("nowPlayMusic ========",nowPlayMusic);
               (this[nowPlayMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
               _loc2_ = new Tween(this[nowPlayMusic] as SoundChannel,1);
               Starling.juggler.add(_loc2_);
               _loc2_.onUpdate = nowUpdate;
               _loc2_.onUpdateArgs = [_loc2_];
               _loc2_.onComplete = complete;
               _loc2_.onCompleteArgs = [nowPlayMusic];
            }
            else
            {
               if(this[nextMusic] != null)
               {
                  (this[nextMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
               }
               this[nextMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nextMusic,0,2147483647);
               nowPlayMusic = nextMusic;
               redayMusic = null;
            }
         }
         else
         {
            this[nextMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nextMusic,0,2147483647);
            nowPlayMusic = nextMusic;
         }
      }
      
      private function nowUpdate(param1:Tween) : void
      {
         soundTransform = (this[nowPlayMusic] as SoundChannel).soundTransform;
         soundTransform.volume = 1 - param1.progress;
         (this[nowPlayMusic] as SoundChannel).soundTransform = soundTransform;
      }
      
      private function complete(param1:String) : void
      {
         if(param1 == "mainCity")
         {
            this[param1 + "Last"] = (this[param1] as SoundChannel).position;
         }
         (this[param1] as SoundChannel).stop();
         LogUtil("停止播放当前音乐" + nowPlayMusic,"开始播放下一个" + nextMusic);
         if(nextMusic == "mainCity")
         {
            continuePlayBGM();
         }
         else
         {
            if(this[nextMusic] != null)
            {
               (this[nextMusic] as SoundChannel).removeEventListener("soundComplete",loopsPlay);
            }
            this[nextMusic] = LoadOtherAssetsManager.getInstance().assets.playSound(nextMusic,0,2147483647);
            nowPlayMusic = nextMusic;
         }
         redayMusic = null;
         var _loc2_:Tween = new Tween(this[nowPlayMusic] as SoundChannel,1);
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = nextUpdate;
         _loc2_.onUpdateArgs = [_loc2_];
      }
      
      private function nextUpdate(param1:Tween) : void
      {
         var _loc2_:* = 1.0;
         if(nowPlayMusic == FightingConfig.fightMusicAssets[0])
         {
            _loc2_ = 0.5;
         }
         if(this[nowPlayMusic] != null)
         {
            soundTransform = (this[nowPlayMusic] as SoundChannel).soundTransform;
            soundTransform.volume = param1.progress * _loc2_;
            (this[nowPlayMusic] as SoundChannel).soundTransform = soundTransform;
         }
      }
      
      private function playMusic(param1:starling.events.Event) : void
      {
         LogUtil("播放一次音效 = " + param1.data);
         var _loc2_:String = param1.data as String;
         if(_loc2_.substr(0,3) == "elf")
         {
            if(SESwitch && !Pocketmon.isDeActive)
            {
               LoadOtherAssetsManager.getInstance().playElfVoice(_loc2_);
            }
            return;
         }
         if(_loc2_.substr(0,6) == "skillM")
         {
            _loc2_ = _loc2_.substr(6);
            LoadOtherAssetsManager.getInstance().playSkillVoice(_loc2_);
            return;
         }
         if(_loc2_ != "dialogue")
         {
            if(soundC != null)
            {
               soundC.removeEventListener("soundComplete",playOnceComplete);
            }
            soundC = null;
            soundC = LoadOtherAssetsManager.getInstance().assets.playSound(_loc2_);
            if(soundC == null)
            {
               return;
            }
            soundC.addEventListener("soundComplete",playOnceComplete);
            if(!SESwitch || Pocketmon.isDeActive)
            {
               soundTransform = soundC.soundTransform;
               soundTransform.volume = 0;
               soundC.soundTransform = soundTransform;
            }
         }
         else if(SESwitch)
         {
            LoadOtherAssetsManager.getInstance().assets.playSound(_loc2_);
         }
      }
      
      private function playOnceComplete(param1:flash.events.Event) : void
      {
         soundC.removeEventListener("soundComplete",playOnceComplete);
         SoundEvent.dispatchEvent("PLAY_ONCE_COMPLETE");
      }
      
      private function playMusicAndStopBg(param1:starling.events.Event) : void
      {
         LogUtil("播放音效并停止背景音乐" + param1.data);
         if(SESwitch)
         {
            if(BGSwitch)
            {
               if(this[nowPlayMusic] != null)
               {
                  this[nowPlayMusic + "Last"] = (this[nowPlayMusic] as SoundChannel).position;
                  (this[nowPlayMusic] as SoundChannel).stop();
                  Starling.juggler.removeTweens(this[nowPlayMusic] as SoundChannel);
               }
            }
         }
         var _loc2_:String = param1.data.musicName;
         if(soundC2 != null)
         {
            soundC2.removeEventListener("soundComplete",continueBGM);
         }
         soundC2 = null;
         soundC2 = LoadOtherAssetsManager.getInstance().assets.playSound(_loc2_);
         if(soundC2 == null)
         {
            return;
         }
         if(!SESwitch)
         {
            soundTransform = soundC2.soundTransform;
            soundTransform.volume = 0;
            soundC2.soundTransform = soundTransform;
         }
         if(param1.data.isContinuePlayBGM && SESwitch)
         {
            soundC2.addEventListener("soundComplete",continueBGM);
         }
      }
      
      private function continueBGM(param1:flash.events.Event) : void
      {
         soundC2.removeEventListener("soundComplete",continueBGM);
         if(BGSwitch)
         {
            continuePlayBGM();
         }
      }
      
      public function stopMusic() : void
      {
         if(soundC2 != null)
         {
            soundC2.removeEventListener("soundComplete",continueBGM);
            soundC2.stop();
            soundC2 = null;
            if(redayMusic != null)
            {
               nowPlayMusic = redayMusic;
               redayMusic = null;
            }
         }
      }
   }
}
