package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.events.EventCenter;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.GetCommon;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ElfUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var img:Image;
      
      private var _elfVo:ElfVO;
      
      public function ElfUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(img);
         if(_loc2_ && _loc2_.phase == "began")
         {
            EventCenter.dispatchEvent("SELE_EXCHANGE_ELF",_elfVo);
            ExSeleElfUI.getInstance().remove();
            GotoExChange.getInstance().seleElfArr.push(_elfVo.id);
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
         img = ELFMinImageManager.getElfM(param1.imgName);
         addChild(img);
         getTextBg(0,90);
         GetCommon.getText(0,90,55,20,"Lv." + param1.lv,"FZCuYuan-M03S",15,16777215,this);
         getTextBg(52,0);
         GetCommon.getText(50,0,55,20,param1.character,"FZCuYuan-M03S",15,16777215,this);
         GetCommon.getText(0,img.height,img.width,25,param1.nickName,"FZCuYuan-M03S",25,9713664,this,false,true,true);
         this.addEventListener("touch",ontouch);
      }
      
      private function getTextBg(param1:int, param2:int) : SwfImage
      {
         var _loc3_:SwfImage = swf.createImage("img_lvBg");
         _loc3_.x = param1;
         _loc3_.y = param2;
         _loc3_.touchable = false;
         addQuickChild(_loc3_);
         return _loc3_;
      }
   }
}
