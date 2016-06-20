package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class EvolveElfUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_evolveUnit:SwfSprite;
      
      private var elfCotain:SwfSprite;
      
      private var elfName:TextField;
      
      private var img:Image;
      
      private var _elfVo:ElfVO;
      
      private var _beforeElfVo:ElfVO;
      
      public function EvolveElfUnit()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_evolveUnit = swf.createSprite("spr_evolveUnit");
         elfCotain = spr_evolveUnit.getSprite("elfCotain");
         elfName = spr_evolveUnit.getTextField("elfName");
         addChild(spr_evolveUnit);
         this.addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(img);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(EvolveSeleteUI.getInstance().isScrolling)
            {
               return;
            }
            _beforeElfVo.evolveId = _elfVo.elfId;
            LogUtil("_beforeElfVo.muchEvoStoneArr",_beforeElfVo.muchEvoStoneArr);
            if(_beforeElfVo.muchEvoStoneArr.hasOwnProperty(_beforeElfVo.evolveIdArr.indexOf(_elfVo.elfId)))
            {
               _beforeElfVo.evoStoneArr = _beforeElfVo.muchEvoStoneArr[_beforeElfVo.evolveIdArr.indexOf(_elfVo.elfId)];
            }
            EvolveSeleteUI.getInstance().remove();
            ElfEvolveUI.getInstance().myElfVo = _beforeElfVo;
         }
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVo = param1;
         if(img != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(img);
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         elfName.text = param1.name;
      }
      
      private function showElf() : void
      {
         img = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVo.imgName));
         ElfFrontImageManager.getInstance().autoZoom(img,190,true,10);
         elfCotain.addChild(img);
      }
      
      public function set beforeElfVo(param1:ElfVO) : void
      {
         _beforeElfVo = param1;
      }
      
      public function clean() : void
      {
         if(img != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(img);
            img = null;
         }
      }
   }
}
