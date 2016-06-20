package com.mvc.views.uis.mainCity.miracle
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ELFMinImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class MiracleAddElfUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var swf2:Swf;
      
      private var _elfVO:ElfVO;
      
      public var elfImage:Image;
      
      public var spr_addElf:SwfSprite;
      
      public var btn_addElfBtn:SwfButton;
      
      private var lvBg:SwfImage;
      
      private var Lvtxt:TextField;
      
      public function MiracleAddElfUnit()
      {
         super();
         init();
      }
      
      public function get elfVO() : ElfVO
      {
         return _elfVO;
      }
      
      public function set elfVO(param1:ElfVO) : void
      {
         _elfVO = param1;
         setElfImg();
         lvBg = getTextBg(8,84);
         Lvtxt = getText(0,84,"Lv." + elfVO.lv,14);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("miracle");
         swf2 = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_addElf = swf.createSprite("spr_addElf");
         addChild(spr_addElf);
         btn_addElfBtn = spr_addElf.getButton("btn_addElfBtn");
      }
      
      public function setElfImg() : void
      {
         elfImage = ELFMinImageManager.getElfM(elfVO.imgName);
         elfImage.addEventListener("touch",elfImage_touchHandler);
         spr_addElf.addChild(elfImage);
         btn_addElfBtn.removeFromParent();
      }
      
      private function elfImage_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(elfImage);
         if(_loc2_)
         {
            if(_loc2_.phase == "ended")
            {
               removeImgAndAddBtn();
               Facade.getInstance().sendNotification("miracle_add_elf_unit_touch_complete",elfVO);
            }
         }
      }
      
      public function removeImgAndAddBtn() : void
      {
         if(elfImage)
         {
            elfImage.removeEventListener("touch",elfImage_touchHandler);
            elfImage.removeFromParent(true);
            elfImage = null;
            lvBg.removeFromParent(true);
            Lvtxt.removeFromParent(true);
            spr_addElf.addChild(btn_addElfBtn);
         }
      }
      
      private function getTextBg(param1:int, param2:int) : SwfImage
      {
         var _loc3_:SwfImage = swf2.createImage("img_lvBg");
         _loc3_.x = param1;
         _loc3_.y = param2;
         _loc3_.touchable = false;
         addQuickChild(_loc3_);
         return _loc3_;
      }
      
      private function getText(param1:int, param2:int, param3:String, param4:int) : TextField
      {
         var _loc5_:TextField = new TextField(60,20,param3,"FZCuYuan-M03S",param4,16777215);
         _loc5_.x = param1;
         _loc5_.y = param2;
         _loc5_.touchable = false;
         addQuickChild(_loc5_);
         return _loc5_;
      }
   }
}
