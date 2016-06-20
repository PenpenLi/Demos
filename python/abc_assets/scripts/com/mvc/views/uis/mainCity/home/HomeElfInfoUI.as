package com.mvc.views.uis.mainCity.home
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class HomeElfInfoUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var swf2:Swf;
      
      public var btn_pkhead:SwfButton;
      
      public var spr_info:SwfSprite;
      
      public var niceName:TextField;
      
      public var pkName:TextField;
      
      public var pkLv:TextField;
      
      public var pkNature:TextField;
      
      public var bigImage:Image;
      
      private var _elfVO:ElfVO;
      
      private var lockFreeImg:Image;
      
      public function HomeElfInfoUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("home");
         swf2 = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_info = swf.createSprite("spr_PKinfo_s");
         btn_pkhead = spr_info.getButton("btn_pkhead");
         niceName = spr_info.getTextField("niceName");
         pkName = spr_info.getTextField("pkName");
         pkLv = spr_info.getTextField("pkLv");
         pkNature = spr_info.getTextField("pkNature");
         addChild(spr_info);
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = null;
         _elfVO = param1;
         if(bigImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(bigImage);
         }
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         niceName.text = param1.nickName;
         pkName.text = param1.character;
         pkLv.text = param1.lv;
         if(param1.nature.length > 1)
         {
            pkNature.text = param1.nature[0] + " | " + param1.nature[1];
         }
         else
         {
            pkNature.text = param1.nature[0];
         }
      }
      
      private function showElf() : void
      {
         bigImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(bigImage,270,true,30);
         (btn_pkhead.getChildAt(0) as Sprite).addChild(bigImage);
         switchLock();
         AniFactor.ifOpen = true;
         AniFactor.elfAni(bigImage);
      }
      
      public function get myElfVo() : ElfVO
      {
         return _elfVO;
      }
      
      public function cleanBigImage() : void
      {
         if(bigImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(bigImage);
            bigImage = null;
            niceName.text = "";
            pkName.text = "";
            pkLv.text = "";
            pkNature.text = "";
         }
      }
      
      public function switchLock() : void
      {
         if(_elfVO.isLock)
         {
            if(!lockFreeImg)
            {
               lockFreeImg = swf2.createImage("img_lock2");
               lockFreeImg.x = this.width - lockFreeImg.width;
               (btn_pkhead.getChildAt(0) as Sprite).addChild(lockFreeImg);
            }
         }
         else if(lockFreeImg)
         {
            lockFreeImg.removeFromParent(true);
            lockFreeImg = null;
         }
      }
   }
}
