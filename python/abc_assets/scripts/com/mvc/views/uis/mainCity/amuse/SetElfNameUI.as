package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   
   public class SetElfNameUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_setNameBg:SwfSprite;
      
      public var btn_ok:SwfButton;
      
      public var setPetNameTxt:FeathersTextInput;
      
      private var _elfVo:ElfVO;
      
      public var niceName:TextField;
      
      public var btn_rounds:SwfButton;
      
      public function SetElfNameUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_setNameBg = swf.createSprite("spr_setNameBg");
         niceName = spr_setNameBg.getTextField("niceName");
         setPetNameTxt = spr_setNameBg.getChildByName("comp_setName") as FeathersTextInput;
         btn_ok = spr_setNameBg.getButton("btn_ok");
         btn_rounds = spr_setNameBg.getButton("btn_rounds");
         spr_setNameBg.x = 1136 - spr_setNameBg.width >> 1;
         spr_setNameBg.y = 640 - spr_setNameBg.height >> 1;
         setPetNameTxt.width = 340;
         setPetNameTxt.maxChars = 6;
         setPetNameTxt.paddingLeft = 10;
         setPetNameTxt.paddingTop = 4;
         setPetNameTxt.textEditorProperties.fontFamily = "FZCuYuan-M03S";
         addChild(spr_setNameBg);
      }
      
      public function set myElfVO(param1:ElfVO) : void
      {
         setPetNameTxt.text = param1.nickName;
         _elfVo = param1;
      }
      
      public function get myElfVO() : ElfVO
      {
         return _elfVo;
      }
   }
}
