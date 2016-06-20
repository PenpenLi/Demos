package com.mvc.views.uis.login.startChat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.Event;
   import com.common.managers.ElfFrontImageManager;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.display.Quad;
   
   public class SeleElfInfoUI extends Sprite
   {
      
      private static var instance:com.mvc.views.uis.login.startChat.SeleElfInfoUI;
       
      private var rootClass:Game;
      
      private var swf:Swf;
      
      private var spr_seleElfInfo:SwfSprite;
      
      private var btn_seleteClose:SwfButton;
      
      private var elfName:TextField;
      
      private var rare:TextField;
      
      private var natrue:TextField;
      
      private var btn_ok:SwfButton;
      
      private var elfDec:TextField;
      
      private var elfImage:Image;
      
      private var elfCotain:SwfSprite;
      
      private var oneImage:Image;
      
      private var twoImage:Image;
      
      private var threeImage:Image;
      
      private var btn_cancle:SwfButton;
      
      private var twoImgName:String;
      
      private var OneImgName:String;
      
      private var threeImgName:String;
      
      public function SeleElfInfoUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         rootClass = Config.starling.root as Game;
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.login.startChat.SeleElfInfoUI
      {
         return instance || new com.mvc.views.uis.login.startChat.SeleElfInfoUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_seleElfInfo = swf.createSprite("spr_seleElfInfo");
         btn_seleteClose = spr_seleElfInfo.getButton("btn_seleteClose");
         btn_ok = spr_seleElfInfo.getButton("btn_seleteOk");
         btn_cancle = spr_seleElfInfo.getButton("btn_cancle");
         elfName = spr_seleElfInfo.getTextField("elfName");
         rare = spr_seleElfInfo.getTextField("rare");
         natrue = spr_seleElfInfo.getTextField("natrue");
         elfDec = spr_seleElfInfo.getTextField("elfDec");
         elfCotain = spr_seleElfInfo.getSprite("elfCotain");
         spr_seleElfInfo.x = 1136 - spr_seleElfInfo.width >> 1;
         spr_seleElfInfo.y = 640 - spr_seleElfInfo.height >> 1;
         addChild(spr_seleElfInfo);
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_seleteClose !== _loc2_)
         {
            if(btn_ok !== _loc2_)
            {
               if(btn_cancle === _loc2_)
               {
                  this.removeFromParent();
                  ElfFrontImageManager.tempNoRemoveTexture = [];
               }
            }
            else
            {
               clean();
               this.removeFromParent();
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFNAME_WIN");
               Facade.getInstance().sendNotification("SEND_SETNAME_ELF",PlayerVO.bagElfVec[0]);
               ElfFrontImageManager.tempNoRemoveTexture = [];
            }
         }
         else
         {
            this.removeFromParent();
            ElfFrontImageManager.tempNoRemoveTexture = [];
         }
      }
      
      public function show(param1:ElfVO) : void
      {
         if(elfImage != null)
         {
            LogUtil("------展示精灵信息------");
            ElfFrontImageManager.getInstance().disposeImg(elfImage);
         }
         var _loc3_:ElfVO = GetElfFactor.getElfVO(param1.evolveId);
         var _loc2_:ElfVO = GetElfFactor.getElfVO(_loc3_.evolveId);
         OneImgName = param1.imgName;
         twoImgName = _loc3_.imgName;
         threeImgName = _loc2_.imgName;
         ElfFrontImageManager.getInstance().getImg([param1.imgName,_loc3_.imgName,_loc2_.imgName],showElfImage);
         elfName.text = param1.nickName;
         rare.text = param1.rare;
         natrue.text = param1.nature[0];
         elfDec.text = param1.descr;
      }
      
      private function showElfImage() : void
      {
         ElfFrontImageManager.tempNoRemoveTexture.push(OneImgName,twoImgName,threeImgName);
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(OneImgName));
         ElfFrontImageManager.getInstance().autoZoom(elfImage,190,true,10);
         elfCotain.addChild(elfImage);
         AniFactor.ifOpen = true;
         AniFactor.elfAni(elfImage);
         if(oneImage != null)
         {
            oneImage.removeFromParent(true);
         }
         oneImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(OneImgName));
         var _loc1_:* = 0.6;
         oneImage.scaleY = _loc1_;
         oneImage.scaleX = _loc1_;
         oneImage.x = 50;
         oneImage.y = 310;
         spr_seleElfInfo.addChild(oneImage);
         if(twoImage != null)
         {
            twoImage.removeFromParent(true);
         }
         twoImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(twoImgName));
         _loc1_ = 0.6;
         twoImage.scaleY = _loc1_;
         twoImage.scaleX = _loc1_;
         twoImage.x = 235;
         twoImage.y = 290;
         spr_seleElfInfo.addChild(twoImage);
         if(threeImage != null)
         {
            threeImage.removeFromParent(true);
         }
         threeImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(threeImgName));
         _loc1_ = 0.6;
         threeImage.scaleY = _loc1_;
         threeImage.scaleX = _loc1_;
         threeImage.x = 460;
         threeImage.y = 270;
         spr_seleElfInfo.addChild(threeImage);
         rootClass.addChild(this);
      }
      
      public function clean() : void
      {
         if(elfImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(elfImage);
         }
         if(oneImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(oneImage);
         }
         if(twoImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(twoImage);
         }
         if(threeImage != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(threeImage);
         }
      }
   }
}
