package com.common.util.dialogue
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.GameFacade;
   import starling.core.Starling;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import starling.animation.Tween;
   import extend.SoundEvent;
   
   public class Dialogue extends Sprite
   {
      
      private static var TF:TextField;
      
      private static var container:Sprite;
      
      private static var root:Sprite;
      
      private static var _object:Object;
      
      private static var _collectDialogueVec:Vector.<String> = new Vector.<String>([]);
      
      private static var isPlayingDia:Boolean;
      
      private static var callBackVec:Vector.<Function> = new Vector.<Function>([]);
      
      private static var touchable:Boolean;
      
      private static var nextMark:SwfMovieClip;
       
      public function Dialogue()
      {
         super();
      }
      
      public static function init() : void
      {
         root = Config.starling.root as Game;
         container = new Sprite();
         container.name = "dialogue";
         var _loc3_:Quad = new Quad(1136,640,3806992);
         _loc3_.alpha = 0;
         container.addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,160,3806992);
         _loc1_.y = 480;
         container.addChild(_loc1_);
         TF = new TextField(1077,113,"","FZCuYuan-M03S",40,16777215,true);
         TF.x = 40;
         TF.y = 508;
         TF.autoSize = "vertical";
         TF.hAlign = "left";
         container.addChild(TF);
         container.addEventListener("touch",touchHandler);
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         nextMark = _loc2_.createMovieClip("mc_nextTips_ss");
         nextMark.stop();
         nextMark.x = 1050;
         nextMark.y = 560;
         _loc2_ = null;
      }
      
      private static function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         if(!touchable)
         {
            return;
         }
         _loc2_ = param1.getTouch(container);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            touchable = false;
            removeFormParent();
            GameFacade.getInstance().sendNotification("next_dialogue",_object);
         }
      }
      
      public static function updateDialogue(param1:String, param2:Boolean = false, param3:Object = null, param4:Boolean = false) : void
      {
         var _loc6_:* = NaN;
         if(!container.parent)
         {
            root.addChild(container);
            if(root.getChildByName("showElfAbility") != null)
            {
               root.setChildIndex(root.getChildByName("showElfAbility"),root.numChildren - 1);
            }
         }
         container.visible = true;
         LogUtil("是否可点击:" + touchable);
         if(param4 == false && touchable == true)
         {
            return;
         }
         LogUtil("对话内容:" + param1);
         touchable = param2;
         Starling.juggler.removeTweens(TF);
         if(FightingMedia.isFighting)
         {
            _loc6_ = Config.dialogueDelay / 3;
         }
         else
         {
            _loc6_ = 0.5;
         }
         var _loc5_:Tween = new Tween(TF,_loc6_);
         Starling.juggler.add(_loc5_);
         _loc5_.onUpdate = playTextAni;
         _loc5_.onUpdateArgs = [param1,_loc5_];
         _object = param3;
         GameFacade.getInstance().sendNotification("bomb_dialogue");
         if(touchable)
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","dialogue");
            container.addChild(nextMark);
            nextMark.gotoAndPlay(0);
         }
         else
         {
            removeNextMark();
         }
      }
      
      private static function playTextAni(param1:String, param2:Tween) : void
      {
         if(LoadSwfAssetsManager.getInstance().assets.isLoading)
         {
            TF.text = param1;
            Starling.juggler.removeTweens(TF);
            return;
         }
         var _loc3_:int = param1.length * param2.progress;
         TF.text = param1.substr(0,_loc3_);
      }
      
      public static function removeFormParent(param1:Boolean = false) : void
      {
         LogUtil("移除对话" + touchable);
         if(param1 == false)
         {
            if(container.parent && !touchable)
            {
               container.removeFromParent();
               removeNextMark();
               GameFacade.getInstance().sendNotification("remove_dialogue");
            }
         }
         else
         {
            touchable = false;
            container.removeFromParent();
            removeNextMark();
            GameFacade.getInstance().sendNotification("remove_dialogue");
         }
         isPlayingDia = false;
         _collectDialogueVec = Vector.<String>([]);
      }
      
      private static function removeNextMark() : void
      {
         if(nextMark.isPlay)
         {
            nextMark.removeFromParent();
            nextMark.stop();
         }
      }
      
      private static function playDialogueOver() : void
      {
         if(collectDialogueVec.length > 0)
         {
            LogUtil("要结束时，又加了新对话");
            startPlay();
            return;
         }
         LogUtil("播放对话结束");
         removeFormParent();
         playCallBack();
      }
      
      public static function collectDialogue(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         if(_collectDialogueVec.indexOf(param1) == -1)
         {
            _collectDialogueVec.push(param1);
         }
         return;
         §§push(LogUtil(_collectDialogueVec + ":对话内容"));
      }
      
      public static function get collectDialogueVec() : Vector.<String>
      {
         return _collectDialogueVec;
      }
      
      public static function playCollectDialogue(param1:Function) : void
      {
         if(touchable == true)
         {
            if(param1 != null && callBackVec.indexOf(param1) == -1)
            {
               callBackVec.push(param1);
            }
            LogUtil("当对话处于要点击时,执行回调");
            playCallBack();
            return;
         }
         if(param1 != null && callBackVec.indexOf(param1) == -1)
         {
            callBackVec.push(param1);
         }
         LogUtil("不是播放中吗" + isPlayingDia);
         if(isPlayingDia)
         {
            return;
         }
         LogUtil("对话长度" + _collectDialogueVec.length + ":对话内容:" + _collectDialogueVec);
         if(_collectDialogueVec.length == 0)
         {
            LogUtil("当对话为空时,执行回调");
            playCallBack();
            return;
         }
         startPlay();
      }
      
      public static function playCallBack() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         LogUtil("执行了回调:" + callBackVec);
         isPlayingDia = false;
         _loc2_ = 0;
         while(_loc2_ < callBackVec.length)
         {
            _loc1_ = callBackVec[_loc2_];
            callBackVec.splice(_loc2_,1);
            _loc1_();
            if(!isPlayingDia)
            {
               _loc2_--;
               LogUtil("还有回调吗:" + callBackVec.length);
               _loc2_++;
               continue;
            }
            break;
         }
      }
      
      private static function startPlay() : void
      {
         LogUtil("播放对话:" + _collectDialogueVec);
         if(_collectDialogueVec.length == 0)
         {
            return;
         }
         if(touchable)
         {
            playCallBack();
            return;
         }
         updateDialogue(_collectDialogueVec[0]);
         _collectDialogueVec.splice(0,1);
         isPlayingDia = true;
         if(_collectDialogueVec.length > 0)
         {
            Starling.juggler.delayCall(startPlay,Config.dialogueDelay);
         }
         else
         {
            Starling.juggler.delayCall(playDialogueOver,Config.dialogueDelay);
         }
      }
      
      public static function initAll() : void
      {
         touchable = false;
         removeFormParent();
         callBackVec = Vector.<Function>([]);
      }
      
      public static function set touch(param1:Boolean) : void
      {
         touchable = param1;
      }
   }
}
