package com.mvc.views.uis.mainCity.Illustrations
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.List;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.views.mediator.mainCity.Illustrations.IllustrationsMedia;
   import lzm.starling.swf.display.SwfImage;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   
   public class IllustrationsUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_background:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_check:SwfButton;
      
      public var describe:TextField;
      
      public var list:List;
      
      private var image:Image;
      
      private var _elfVO:ElfVO;
      
      private var spr_elfinfo:SwfSprite;
      
      private var elfName:TextField;
      
      private var nature:TextField;
      
      private var tall:TextField;
      
      private var heavy:TextField;
      
      private var posElfArr:Array;
      
      private var unfaceImg:Image;
      
      public var btn_elfSound:SwfButton;
      
      public function IllustrationsUI()
      {
         posElfArr = [88];
         super();
         var _loc1_:Image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
         var _loc3_:* = 1.515;
         _loc1_.scaleY = _loc3_;
         _loc1_.scaleX = _loc3_;
         _loc1_.y = -328;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("Illustrations");
         spr_background = swf.createSprite("spr_background");
         spr_elfinfo = spr_background.getSprite("spr_elfinfo");
         btn_close = spr_background.getButton("btn_close");
         elfName = spr_elfinfo.getTextField("elfName");
         nature = spr_elfinfo.getTextField("nature");
         tall = spr_elfinfo.getTextField("tall");
         heavy = spr_elfinfo.getTextField("heavy");
         btn_check = spr_elfinfo.getButton("btn_check");
         btn_elfSound = spr_elfinfo.getButton("btn_elfSound");
         describe = spr_elfinfo.getTextField("describe");
         describe.autoSize = "vertical";
         spr_background.x = 1136 - spr_background.width >> 1;
         spr_background.y = 640 - spr_background.height >> 1;
         btn_elfSound.visible = false;
         addChild(spr_background);
         unfaceImg = swf.createImage("img_bigUnFineImg");
         unfaceImg.x = 164;
         unfaceImg.y = 108;
         list = new List();
         list.x = 515;
         list.y = 92;
         list.width = 380;
         list.height = 500;
         var _loc2_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc2_.defaultValue = new Scale9Textures(LoadOtherAssetsManager.getInstance().assets.getTexture("tab_btn_up"),new Rectangle(25,25,25,25));
         _loc2_.defaultSelectedValue = new Scale9Textures(LoadOtherAssetsManager.getInstance().assets.getTexture("tab_btn_down"),new Rectangle(25,25,25,25));
         list.itemRendererProperties.stateToSkinFunction = _loc2_.updateValue;
         spr_background.addChild(list);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         if(param1.relation == 2)
         {
            btn_check.visible = true;
            btn_elfSound.visible = true;
         }
      }
      
      private function showElf() : void
      {
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,250);
         image.x = 274;
         image.y = 348;
         var _loc1_:int = _elfVO.elfId;
         if(3 !== _loc1_)
         {
            if(6 !== _loc1_)
            {
               if(88 !== _loc1_)
               {
                  if(89 !== _loc1_)
                  {
                     if(34 === _loc1_)
                     {
                        image.y = 360;
                     }
                  }
                  else
                  {
                     image.y = 392;
                  }
               }
               else
               {
                  image.y = 368;
               }
            }
            else
            {
               image.y = 360;
            }
         }
         else
         {
            image.y = 370;
         }
         spr_background.addChild(image);
         AniFactor.ifOpen = true;
         AniFactor.elfAni(image);
         image.visible = true;
         switch(_elfVO.relation)
         {
            case 0:
               image.visible = false;
               spr_background.addChild(unfaceImg);
               btn_check.visible = false;
               btn_elfSound.visible = false;
               elfName.text = IllustrationsMedia.numberTxt(_elfVO.elfId) + "   " + "? ? ?";
               nature.text = "？？";
               tall.text = "？？";
               heavy.text = "？？";
               describe.text = "？？？";
               break;
            case 1:
               unfaceImg.removeFromParent();
               btn_elfSound.visible = false;
               elfName.text = IllustrationsMedia.numberTxt(_elfVO.elfId) + "   " + _elfVO.name;
               nature.text = "？？";
               tall.text = "？？";
               heavy.text = "？？";
               describe.text = "？？？";
               break;
            case 2:
               unfaceImg.removeFromParent();
               elfName.text = IllustrationsMedia.numberTxt(_elfVO.elfId) + "   " + _elfVO.name;
               nature.text = _elfVO.nature[0];
               tall.text = _elfVO.tall + "m";
               heavy.text = _elfVO.heavy + "kg";
               describe.text = _elfVO.descr;
               break;
         }
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
      
      public function getImg() : SwfImage
      {
         return swf.createImage("img_unFineImg");
      }
      
      public function getElfBall() : SwfButton
      {
         return swf.createButton("btn_elfball_b");
      }
      
      public function cleanImg() : void
      {
         ElfFrontImageManager.getInstance().disposeImg(image);
      }
   }
}
