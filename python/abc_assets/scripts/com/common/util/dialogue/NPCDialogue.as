package com.common.util.dialogue
{
   import starling.text.TextField;
   import starling.display.Image;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.fighting.FightingConfig;
   import starling.core.Starling;
   import com.mvc.views.uis.mapSelect.CityMapUI;
   import com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
   import com.common.managers.NpcImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.animation.Tween;
   import extend.SoundEvent;
   
   public class NPCDialogue
   {
      
      private static var TF:TextField;
      
      private static var NPCNameTF:TextField;
      
      private static var nameBg:Image;
      
      private static var container:Sprite;
      
      private static var root:Sprite;
      
      private static var nextMark:SwfMovieClip;
      
      private static var dialogueArr:Array = [];
      
      private static var NPCImage:Image;
      
      private static var nextDialogueArr:Array = [];
      
      private static var nextNpcName:String;
      
      private static var nextNpcImageName:String;
      
      private static var nextNpcNameArr:Array;
      
      private static var nextNpcImageNameArr:Array;
      
      private static var NPCImageStr:String = "";
       
      public function NPCDialogue()
      {
         super();
      }
      
      public static function init() : void
      {
         root = Config.starling.root as Game;
         container = new Sprite();
         var _loc3_:Quad = new Quad(1136,640,0);
         _loc3_.alpha = 0.75;
         container.addChild(_loc3_);
         var _loc4_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         var _loc2_:SwfSprite = _loc4_.createSprite("spr_NPCDialogue_s");
         container.addChild(_loc2_);
         TF = _loc2_.getTextField("npcDialogue");
         NPCNameTF = _loc2_.getTextField("npcName");
         nameBg = _loc2_.getImage("nameBg");
         _loc2_.y = 420;
         TF.hAlign = "left";
         TF.autoSize = "vertical";
         container.addEventListener("touch",touchHandler);
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         nextMark = _loc1_.createMovieClip("mc_nextTips_ss");
         var _loc5_:* = 0.5;
         nextMark.scaleY = _loc5_;
         nextMark.scaleX = _loc5_;
         nextMark.stop();
         nextMark.x = 1019;
         nextMark.y = 580;
         _loc1_ = null;
         _loc4_ = null;
      }
      
      private static function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:* = null;
         _loc2_ = param1.getTouch(container);
         if(!_loc2_ || NPCImage == null && NPCImageStr != "")
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            if(dialogueArr.length == 0)
            {
               removeFormParent();
               EventCenter.dispatchEvent("npc_dialogue_end");
               PlayerVO.isAcceptPvp = true;
               LogUtil("草泥马npc对话完毕，可以邀请： " + PlayerVO.isAcceptPvp);
               if(FightingConfig.isLvUp && (Starling.current.root as Game).page is CityMapUI)
               {
                  PlayerUpdateUI.getInstance().show();
               }
            }
            else
            {
               updateDialogue(dialogueArr[0]);
               dialogueArr.splice(0,1);
            }
         }
      }
      
      public static function playDialogue(param1:Array, param2:String, param3:String) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         if(container.parent)
         {
            nextDialogueArr = param1;
            nextNpcName = param2;
            nextNpcImageName = param3;
            return;
         }
         PlayerVO.isAcceptPvp = false;
         LogUtil("草泥马npc对话开始，不可邀请： " + PlayerVO.isAcceptPvp);
         nameBg.visible = true;
         NPCNameTF.text = param2;
         if(param2 == "您")
         {
            NPCNameTF.text = "";
            nameBg.visible = false;
         }
         if(NPCImage != null)
         {
            removeNpcImage();
         }
         dialogueArr = param1;
         if(param3)
         {
            NPCImageStr = param3;
            NpcImageManager.getInstance().getImg([param3],addNpcImage);
         }
         else
         {
            updateDialogue(dialogueArr[0]);
            dialogueArr.splice(0,1);
         }
      }
      
      private static function addNpcImage() : void
      {
         NPCImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(NPCImageStr));
         NPCImage.pivotX = NPCImage.width;
         NPCImage.x = 1100;
         NPCImage.y = 30;
         var _loc1_:* = 1.4;
         NPCImage.scaleY = _loc1_;
         NPCImage.scaleX = _loc1_;
         container.addChild(NPCImage);
         container.setChildIndex(NPCImage,1);
         updateDialogue(dialogueArr[0]);
         dialogueArr.splice(0,1);
      }
      
      private static function updateDialogue(param1:String) : void
      {
         if(!container.parent)
         {
            root.addChild(container);
         }
         LogUtil("NPC对话内容:" + param1);
         Starling.juggler.removeTweens(TF);
         var _loc2_:Tween = new Tween(TF,0.5);
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = playTextAni;
         _loc2_.onUpdateArgs = [param1,_loc2_];
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","dialogue");
         container.addChild(nextMark);
         nextMark.gotoAndPlay(0);
      }
      
      private static function playTextAni(param1:String, param2:Tween) : void
      {
         var _loc3_:int = param1.length * param2.progress;
         TF.text = param1.substr(0,_loc3_);
      }
      
      public static function removeFormParent() : void
      {
         if(!container)
         {
            return;
         }
         container.removeFromParent();
         removeNextMark();
         removeNpcImage();
         dialogueArr = null;
         dialogueArr = [];
         if(nextDialogueArr.length > 0)
         {
            playDialogue(nextDialogueArr,nextNpcName,nextNpcImageName);
         }
      }
      
      private static function removeNpcImage() : void
      {
         if(NPCImage)
         {
            NPCImage.texture.dispose();
            NPCImage.removeFromParent(true);
            NPCImage = null;
            NpcImageManager.getInstance().dispose();
            NPCImageStr = "";
         }
      }
      
      private static function removeNextMark() : void
      {
         if(nextMark.isPlay)
         {
            nextMark.removeFromParent();
            nextMark.stop();
         }
      }
      
      public static function initAll() : void
      {
         removeFormParent();
      }
   }
}
