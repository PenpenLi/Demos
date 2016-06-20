package com.mvc.views.uis.login.startChat
{
   import starling.display.Sprite;
   import starling.display.Image;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.events.Event;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.login.LoginPro;
   import com.common.util.dialogue.StartDialogue;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import extend.SoundEvent;
   
   public class SeleElfUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.login.startChat.SeleElfUI;
       
      private var elfImage:Image;
      
      private var elfArray:Array;
      
      private var swf:Swf;
      
      private var btn_shui:SwfButton;
      
      private var btn_huo:SwfButton;
      
      private var btn_cao:SwfButton;
      
      private var btnVec:Vector.<SwfButton>;
      
      private var spr_seleElf:SwfSprite;
      
      private var isComplete:Boolean = true;
      
      private var centerPostion:Number;
      
      private var bg:SwfSprite;
      
      private var imgName:String;
      
      private var btn:SwfButton;
      
      public function SeleElfUI()
      {
         elfArray = [4,1,7];
         btnVec = new Vector.<SwfButton>([]);
         super();
      }
      
      public static function getInstance() : com.mvc.views.uis.login.startChat.SeleElfUI
      {
         return instance || new com.mvc.views.uis.login.startChat.SeleElfUI();
      }
      
      public function init() : void
      {
         var _loc2_:* = 0;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("startChat");
         bg = swf.createSprite("spr_boshi_s");
         addChild(bg);
         AniFactor.fadeOutOrIn(bg,1,0,0.5);
         spr_seleElf = swf.createSprite("spr_seleElf");
         btn_shui = spr_seleElf.getButton("btn_shui");
         btn_huo = spr_seleElf.getButton("btn_huo");
         btn_cao = spr_seleElf.getButton("btn_cao");
         btn_shui.name = "水";
         btn_huo.name = "火";
         btn_cao.name = "草";
         var _loc1_:int = Math.random() * 3 + 1;
         LogUtil("random ========",_loc1_);
         centerPostion = btn_cao.x;
         btnVec.length = 0;
         btnVec.push(btn_huo,btn_cao,btn_shui);
         _loc2_ = 0;
         while(_loc2_ < btnVec.length)
         {
            setBtnPivot(btnVec[_loc2_]);
            if(_loc2_ != 1)
            {
               var _loc3_:* = 0.6;
               btnVec[_loc2_].scaleY = _loc3_;
               btnVec[_loc2_].scaleX = _loc3_;
            }
            else if(_loc1_ == 1)
            {
               addElf(btnVec[_loc2_]);
            }
            _loc2_++;
         }
         spr_seleElf.x = 100;
         spr_seleElf.y = 0;
         addChild(spr_seleElf);
         btn_huo.addEventListener("triggered",seleElf);
         btn_shui.addEventListener("triggered",seleElf);
         btn_cao.addEventListener("triggered",seleElf);
         switch(_loc1_ - 2)
         {
            case 0:
               seleElfEvent(btn_huo,0);
               break;
            case 1:
               seleElfEvent(btn_shui,0);
               break;
         }
      }
      
      private function seleElf(param1:Event) : void
      {
         var _loc2_:SwfButton = param1.target as SwfButton;
         seleElfEvent(_loc2_,0.5);
      }
      
      private function seleElfEvent(param1:SwfButton, param2:Number) : void
      {
         if(!isComplete)
         {
            return;
         }
         if(param1.x > centerPostion)
         {
            playCartoon(param1,false,param2);
         }
         else if(param1.x < centerPostion)
         {
            playCartoon(param1,true,param2);
         }
         else
         {
            PlayerVO.enemyElfVec.length = 0;
            var _loc3_:* = param1.name;
            if("火" !== _loc3_)
            {
               if("水" !== _loc3_)
               {
                  if("草" === _loc3_)
                  {
                     PlayerVO.bagElfVec[0] = GetElfFactor.getElfVO("1");
                     PlayerVO.enemyElfVec.push(GetElfFactor.getElfVO("4"));
                  }
               }
               else
               {
                  PlayerVO.bagElfVec[0] = GetElfFactor.getElfVO("7");
                  PlayerVO.enemyElfVec.push(GetElfFactor.getElfVO("1"));
               }
            }
            else
            {
               PlayerVO.bagElfVec[0] = GetElfFactor.getElfVO("4");
               PlayerVO.enemyElfVec.push(GetElfFactor.getElfVO("7"));
            }
            trace("=============设置昵称===============");
            EventCenter.addEventListener("CREATE_SET_NAME",remove);
            SeleElfInfoUI.getInstance().show(PlayerVO.bagElfVec[0]);
         }
      }
      
      private function seleElfSureHandler(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFNAME_WIN");
            Facade.getInstance().sendNotification("SEND_SETNAME_ELF",PlayerVO.bagElfVec[0]);
         }
      }
      
      private function remove() : void
      {
         trace("PlayerVO.bagElfVec[0] === " + PlayerVO.bagElfVec[0].nickName);
         (Facade.getInstance().retrieveProxy("LoginPro") as LoginPro).write1010();
         EventCenter.removeEventListener("CREATE_SET_NAME",remove);
         StartDialogue.getInstance().playDialogue();
         removeAll();
      }
      
      private function playCartoon(param1:SwfButton, param2:Boolean, param3:Number) : void
      {
         btn = param1;
         clockwise = param2;
         time = param3;
         LogUtil("elfImage==============",elfImage);
         if(elfImage != null)
         {
            var t:Tween = new Tween(elfImage,0.2,"easeOut");
            Starling.juggler.add(t);
            t.animate("alpha",0,1);
            t.onComplete = function():void
            {
               ElfFrontImageManager.getInstance().disposeImg(elfImage);
            };
         }
         var index1:int = btnVec.indexOf(btn);
         isComplete = false;
         if(clockwise)
         {
            var index2:int = index1 + 1 > 2?0:index1 + 1;
            var index3:int = index2 + 1 > 2?0:index2 + 1;
            aniBall(btnVec[index1],btnVec[index2],1,time);
            aniBall(btnVec[index2],btnVec[index3],0.7,time);
            aniBall(btnVec[index3],btnVec[index1],0.7,time,true);
         }
         else
         {
            var index4:int = index1 - 1 < 0?2:index1 - 1;
            var index5:int = index4 - 1 < 0?2:index4 - 1;
            aniBall(btnVec[index1],btnVec[index4],1,time);
            aniBall(btnVec[index4],btnVec[index5],0.7,time);
            aniBall(btnVec[index5],btnVec[index1],0.7,time,true);
         }
      }
      
      private function aniBall(param1:SwfButton, param2:SwfButton, param3:Number, param4:Number, param5:Boolean = false) : void
      {
         btn = param1;
         nextBtn = param2;
         endScale = param3;
         time = param4;
         Complete = param5;
         var t:Tween = new Tween(btn,time,"easeOut");
         Starling.juggler.add(t);
         t.animate("x",nextBtn.x);
         t.animate("y",nextBtn.y);
         t.animate("scaleX",endScale);
         t.animate("scaleY",endScale);
         if(Complete)
         {
            t.onComplete = function():void
            {
               var _loc1_:* = 0;
               isComplete = true;
               _loc1_ = 0;
               while(_loc1_ < btnVec.length)
               {
                  if(btnVec[_loc1_].scaleX == 1)
                  {
                     addElf(btnVec[_loc1_]);
                     break;
                  }
                  _loc1_++;
               }
            };
         }
      }
      
      public function addElf(param1:SwfButton) : void
      {
         btn = param1;
         LogUtil("添加精灵:" + btn.name,elfArray[btnVec.indexOf(btn)]);
         if(elfImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(elfImage);
         }
         imgName = GetElfFactor.getElfVO(elfArray[btnVec.indexOf(btn)]).imgName;
         ElfFrontImageManager.getInstance().getImg([imgName],showElf);
      }
      
      private function showElf() : void
      {
         ElfFrontImageManager.getInstance().getImg([imgName],loadElfImgAfter);
      }
      
      private function loadElfImgAfter() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         elfImage.pivotX = elfImage.width / 2;
         elfImage.pivotY = elfImage.height / 2;
         elfImage.y = btn.y - btn.height / 2;
         elfImage.x = btn.x;
         elfImage.touchable = false;
         elfImage.alpha = 0;
         spr_seleElf.addChild(elfImage);
         var t:Tween = new Tween(elfImage,0.3,"linear");
         Starling.juggler.add(t);
         t.animate("alpha",1,0);
         t.onComplete = function():void
         {
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfArray[btnVec.indexOf(btn)]);
         };
      }
      
      public function setBtnPivot(param1:SwfButton) : void
      {
         param1.pivotX = param1.width / 2;
         param1.pivotY = param1.height / 2;
      }
      
      public function removeAll() : void
      {
         bg.removeFromParent();
         btn_cao.removeFromParent();
         btn_huo.removeFromParent();
         btn_shui.removeFromParent();
         if(elfImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(elfImage);
         }
         spr_seleElf.removeFromParent();
         spr_seleElf = null;
         btn = null;
         removeFromParent(true);
      }
   }
}
