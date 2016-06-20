package com.mvc.views.uis.mainCity.backPack
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import extend.SoundEvent;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class PlayElfUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_unlock:SwfSprite;
      
      private var spr_preview:SwfSprite;
      
      public var elfName:TextField;
      
      public var elfLv:TextField;
      
      public var currentHp:TextField;
      
      public var totalHp:TextField;
      
      public var elfHP:SwfSprite;
      
      public var hp:SwfScale9Image;
      
      public var woman:SwfImage;
      
      public var man:SwfImage;
      
      private var _elfVO:ElfVO;
      
      private var defaultBg:SwfSprite;
      
      private var seleteBg:SwfSprite;
      
      private var image:Image;
      
      private var elfSta:TextField;
      
      private var yellow:SwfScale9Image;
      
      private var red:SwfScale9Image;
      
      private var lastScale:Number;
      
      private var isLearnText:TextField;
      
      public var propVo:PropVO;
      
      private var loadingSwf:Swf;
      
      private var fighting:SwfImage;
      
      public function PlayElfUnitUI()
      {
         super();
         init();
         initEvent();
         addText();
      }
      
      private function addText() : void
      {
         isLearnText = new TextField(180,40,"不可以学习","FZCuYuan-M03S",20,5715237);
         isLearnText.y = 117;
      }
      
      public function initEvent() : void
      {
         addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               Facade.getInstance().sendNotification("SEND_SELECT_ELF",this);
            }
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         loadingSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_unlock = swf.createSprite("spr_Notunlock");
         spr_preview = swf.createSprite("spr_preview");
         elfHP = spr_preview.getSprite("elfHP");
         hp = elfHP.getScale9Image("hp");
         yellow = elfHP.getScale9Image("yellow");
         red = elfHP.getScale9Image("red");
         woman = loadingSwf.createImage("img_woman");
         man = loadingSwf.createImage("img_man");
         elfName = spr_preview.getTextField("elfName");
         elfLv = spr_preview.getTextField("elfLv");
         elfSta = spr_preview.getTextField("elfSta");
         currentHp = spr_preview.getTextField("currentHp");
         totalHp = spr_preview.getTextField("totalHp");
         defaultBg = spr_preview.getSprite("defaultBg");
         seleteBg = spr_preview.getSprite("seleteBg");
         fighting = swf.createImage("img_fighting");
         fighting.x = 110;
         fighting.y = -1;
         seleteBg.visible = false;
         addChild(spr_unlock);
         spr_preview.x = 1;
         spr_unlock.addChild(spr_preview);
         var _loc1_:* = 153;
         man.x = _loc1_;
         woman.x = _loc1_;
         _loc1_ = 37;
         man.y = _loc1_;
         woman.y = _loc1_;
         addChild(woman);
         addChild(man);
         addChild(fighting);
         woman.visible = false;
         man.visible = false;
         fighting.visible = false;
         currentHp.width = 105;
         currentHp.autoScale = true;
         totalHp.visible = false;
         spr_preview.getChildAt(spr_preview.numChildren - 1).visible = false;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         var _loc4_:* = 0;
         _elfVO = param1;
         LogUtil("ChangeBackgroundWidget",propVo);
         fighting.visible = param1.isPlay;
         if(propVo)
         {
            if(propVo.skillId != 0)
            {
               _loc4_ = 0;
               while(_loc4_ < propVo.validElf.length)
               {
                  if(param1.elfId == propVo.validElf[_loc4_])
                  {
                     isLearnText.text = "可以学习";
                     break;
                  }
                  _loc4_++;
               }
               addChild(isLearnText);
            }
         }
         elfName.text = param1.nickName;
         elfLv.text = param1.lv;
         if(param1.sex == 1)
         {
            man.visible = true;
         }
         else if(param1.sex == 0)
         {
            woman.visible = true;
         }
         currentHp.text = param1.currentHp + "/" + param1.totalHp;
         var _loc2_:Number = param1.currentHp / param1.totalHp;
         showHpState(_loc2_);
         var _loc3_:String = GetElfFactor.getElfVO(param1.elfId).imgName;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = ELFMinImageManager.getElfM(param1.imgName,0.55);
         image.x = 5;
         image.y = 15;
         addChild(image);
         upDateStatusShow();
      }
      
      public function upDateStatusShow() : void
      {
         if(_elfVO.currentHp == 0)
         {
            elfSta.text = "濒死";
            return;
         }
         if(_elfVO.status.length == 0)
         {
            elfSta.text = "";
            return;
         }
         LogUtil("我方状态" + _elfVO.status);
         var _loc1_:String = StatusFactor.status[_elfVO.status[_elfVO.status.length - 1] - 1];
         if(elfSta.text == _loc1_)
         {
            return;
         }
         elfSta.text = _loc1_;
         return;
         §§push(LogUtil("更新了状态" + _loc1_));
      }
      
      public function get myElfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function showHp() : void
      {
         currentHp.text = _elfVO.currentHp + "/" + _elfVO.totalHp;
         var _loc1_:Number = _elfVO.currentHp / _elfVO.totalHp;
         LogUtil("scaleXscaleXscaleX ===",lastScale,_loc1_);
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","blood");
         var _loc2_:Tween = new Tween(gethpColor(lastScale),1,"easeOut");
         Starling.juggler.add(_loc2_);
         _loc2_.onUpdate = playHpAni;
         _loc2_.onUpdateArgs = [_loc1_,_loc2_];
      }
      
      private function playHpAni(param1:Number, param2:Tween) : void
      {
         var _loc3_:Number = (param1 - lastScale) * param2.progress;
         LogUtil(_loc3_ + lastScale,"==========scale+lastScale");
         gethpColor(_loc3_ + lastScale).scaleX = _loc3_ + lastScale;
      }
      
      private function showHpState(param1:Number) : void
      {
         if(param1 >= 0.5)
         {
            hp.visible = true;
            var _loc2_:* = false;
            red.visible = _loc2_;
            yellow.visible = _loc2_;
            hp.scaleX = param1;
         }
         else if(param1 < 0.5 && param1 > 0.15)
         {
            yellow.visible = true;
            _loc2_ = false;
            red.visible = _loc2_;
            hp.visible = _loc2_;
            yellow.scaleX = param1;
         }
         else
         {
            red.visible = true;
            _loc2_ = false;
            yellow.visible = _loc2_;
            hp.visible = _loc2_;
            red.scaleX = param1;
         }
      }
      
      private function gethpColor(param1:Number) : SwfScale9Image
      {
         if(param1 >= 0.5)
         {
            hp.visible = true;
            var _loc2_:* = false;
            red.visible = _loc2_;
            yellow.visible = _loc2_;
            return hp;
         }
         if(param1 < 0.5 && param1 > 0.15)
         {
            yellow.visible = true;
            _loc2_ = false;
            red.visible = _loc2_;
            hp.visible = _loc2_;
            return yellow;
         }
         red.visible = true;
         _loc2_ = false;
         yellow.visible = _loc2_;
         hp.visible = _loc2_;
         return red;
      }
      
      public function getLastScale() : void
      {
         lastScale = _elfVO.currentHp / _elfVO.totalHp;
      }
      
      public function switchBg(param1:Boolean) : void
      {
         defaultBg.visible = !param1;
         seleteBg.visible = param1;
      }
   }
}
