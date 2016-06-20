package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class ElfContainUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_preview:SwfSprite;
      
      public var elfName:TextField;
      
      public var elfLv:TextField;
      
      public var hpText:TextField;
      
      public var elfHP:SwfSprite;
      
      public var hp:SwfScale9Image;
      
      public var woman:SwfImage;
      
      public var man:SwfImage;
      
      private var _elfVO:ElfVO;
      
      private var defaultBg:Image;
      
      private var seleteBg:Image;
      
      private var image:Image;
      
      private var yellow:SwfScale9Image;
      
      private var red:SwfScale9Image;
      
      private var loadingSwf:Swf;
      
      public var promopImg:SwfImage;
      
      public var skillPrompt:SwfImage;
      
      public var isSelete:Boolean;
      
      public function ElfContainUnitUI()
      {
         super();
         init();
         initEvent();
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
            }
         }
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         loadingSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_preview = swf.createSprite("spr_preview");
         elfHP = spr_preview.getSprite("elfHP");
         hp = elfHP.getScale9Image("hp");
         yellow = elfHP.getScale9Image("yellow");
         red = elfHP.getScale9Image("red");
         woman = loadingSwf.createImage("img_woman");
         man = loadingSwf.createImage("img_man");
         elfName = spr_preview.getTextField("elfName");
         elfLv = spr_preview.getTextField("elfLv");
         hpText = spr_preview.getTextField("hpText");
         defaultBg = spr_preview.getImage("defaultBg");
         seleteBg = spr_preview.getImage("seleteBg");
         promopImg = spr_preview.getImage("promopImg");
         skillPrompt = spr_preview.getImage("skillPromop");
         seleteBg.visible = false;
         spr_preview.x = 2;
         addChild(spr_preview);
         woman.x = 120;
         man.x = 120;
         woman.y = 15;
         man.y = 17;
         addChild(woman);
         addChild(man);
         var _loc1_:* = false;
         woman.visible = _loc1_;
         man.visible = _loc1_;
         _loc1_ = 0.8;
         man.scaleY = _loc1_;
         man.scaleX = _loc1_;
         _loc1_ = 0.8;
         woman.scaleY = _loc1_;
         woman.scaleX = _loc1_;
         hpText.autoScale = true;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         elfName.text = param1.nickName;
         elfLv.text = "Lv." + param1.lv;
         if(param1.sex == 1)
         {
            man.visible = true;
         }
         else if(param1.sex == 0)
         {
            woman.visible = true;
         }
         hpText.text = param1.currentHp + "/" + param1.totalHp;
         var _loc2_:Number = param1.currentHp / param1.totalHp;
         showHpState(_loc2_);
         var _loc3_:String = GetElfFactor.getElfVO(param1.elfId).imgName;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = ELFMinImageManager.getElfM(param1.imgName,0.55);
         image.x = 7;
         image.y = 5;
         addChild(image);
      }
      
      public function get myElfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function switchBg(param1:Boolean) : void
      {
         defaultBg.visible = !param1;
         seleteBg.visible = param1;
         isSelete = param1;
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
            return hp;
         }
         if(param1 < 0.5 && param1 > 0.15)
         {
            return yellow;
         }
         return red;
      }
      
      public function selected() : void
      {
         var _loc1_:Tween = new Tween(this,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1.1);
         _loc1_.animate("scaleY",1.1);
         _loc1_.animate("alpha",0.5);
      }
      
      public function cancelSelected() : void
      {
         var _loc1_:Tween = new Tween(this,0.3,"easeOut");
         Starling.juggler.add(_loc1_);
         _loc1_.animate("scaleX",1);
         _loc1_.animate("scaleY",1);
         _loc1_.animate("alpha",1);
      }
   }
}
