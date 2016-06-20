package com.mvc.views.uis.mainCity.laboratory
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.backPack.SelectElfUI;
   
   public class SetNameUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_setName:SwfSprite;
      
      public var btn_seleElf:SwfButton;
      
      public var elfName:TextField;
      
      public var textput:FeathersTextInput;
      
      public var btn_round:SwfButton;
      
      public var btn_ok:SwfButton;
      
      public var btn_return:SwfButton;
      
      private var spr_putElf:SwfSprite;
      
      public var btn_help:SwfButton;
      
      public var image:Image;
      
      private var _elfVO:ElfVO;
      
      public function SetNameUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("laboratory");
         spr_setName = swf.createSprite("spr_setName");
         spr_putElf = spr_setName.getSprite("spr_putElf");
         btn_seleElf = spr_setName.getButton("btn_seleElf");
         elfName = spr_setName.getTextField("elfName");
         textput = spr_setName.getChildByName("textput") as FeathersTextInput;
         btn_round = spr_setName.getButton("btn_round");
         btn_ok = spr_setName.getButton("btn_ok");
         btn_return = spr_setName.getButton("btn_return");
         btn_help = spr_setName.getButton("btn_help");
         btn_help.visible = false;
         textput.width = 180;
         textput.paddingLeft = 10;
         textput.paddingTop = 4;
         textput.maxChars = 6;
         spr_setName.x = 370;
         spr_setName.y = 120;
         switchView(false);
         addChild(spr_setName);
         btn_return.visible = false;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         switchView(true);
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
            image = null;
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         elfName.text = param1.nickName;
      }
      
      private function showElf() : void
      {
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,190,true,20);
         spr_putElf.addChild(image);
         AniFactor.ifOpen = true;
         AniFactor.elfAni(image);
         image.addEventListener("touch",reSeleElf);
      }
      
      private function reSeleElf(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            seleElf();
         }
      }
      
      public function seleElf() : void
      {
         SelectElfUI.getIntance().createSeleElf();
         SelectElfUI.getIntance().title.text = "选择需要修改昵称的精灵";
         this;
         addChild(SelectElfUI.getIntance());
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
      
      public function switchView(param1:Boolean) : void
      {
         spr_putElf.visible = param1;
         btn_seleElf.visible = !param1;
         textput.isEditable = param1;
      }
   }
}
