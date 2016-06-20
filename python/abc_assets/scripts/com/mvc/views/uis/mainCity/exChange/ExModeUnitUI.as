package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.exChange.ExChangeVO;
   import lzm.starling.swf.display.SwfImage;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.exChange.ExChangeMedia;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.util.AniEffects;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class ExModeUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_mode:SwfSprite;
      
      private var btn_mode:SwfButton;
      
      private var lvTxt:TextField;
      
      private var lessTxt:TextField;
      
      private var modeArr:Array;
      
      private var _exChangeVo:ExChangeVO;
      
      private var light:SwfImage;
      
      private var lightBase1:SwfImage;
      
      private var image:Image;
      
      public function ExModeUnitUI()
      {
         modeArr = ["初级交换","中级交换","高级交换"];
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("exChange");
         spr_mode = swf.createSprite("spr_ball");
         btn_mode = spr_mode.getButton("btn_mode");
         light = spr_mode.getImage("light");
         lightBase1 = spr_mode.getImage("lightBase1");
         lvTxt = (btn_mode.skin as Sprite).getChildByName("exchangeLv") as TextField;
         lessTxt = (btn_mode.skin as Sprite).getChildByName("lessNum") as TextField;
         lvTxt.fontName = "img_mode";
         lessTxt.fontName = "img_lessNum";
         light.touchable = false;
         lvTxt.touchable = false;
         lessTxt.touchable = false;
         addChild(spr_mode);
      }
      
      public function set mode(param1:ExChangeVO) : void
      {
         _exChangeVo = param1;
         lvTxt.text = modeArr[param1.index];
         lessTxt.text = "剩余次数：" + param1.lessNum;
         light.color = ExChangeMedia.lightArr[param1.index];
         lightBase1.color = ExChangeMedia.lightSourceArr[param1.index];
         ElfFrontImageManager.getInstance().getImg([param1.getElfVo.imgName],showElf);
         btn_mode.addEventListener("triggered",click);
      }
      
      private function showElf() : void
      {
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_exChangeVo.getElfVo.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,170);
         image.x = 140;
         image.y = 260;
         LogUtil(this.numChildren);
         spr_mode.addChildAt(image,spr_mode.numChildren - 4);
         openAni();
      }
      
      public function openAni() : void
      {
         var _loc1_:* = 0;
         image.y = 260;
         AniEffects.elfMoveAni(image,40,2);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            AniEffects.particleAni(spr_mode.getImage("point" + _loc1_),light.x + 20,light.y,light.width - 40,light.height - 50,1);
            _loc1_++;
         }
      }
      
      public function closeAni() : void
      {
         var _loc1_:* = 0;
         AniEffects.closeAni(image);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            AniEffects.closeAni(spr_mode.getImage("point" + _loc1_));
            _loc1_++;
         }
      }
      
      private function click(param1:Event) : void
      {
         EventCenter.addEventListener("EXCHANGE_RESULTS",returnResult);
         Facade.getInstance().sendNotification("SHOW_EXCHANGE_ELF",_exChangeVo);
      }
      
      private function returnResult() : void
      {
         EventCenter.removeEventListener("EXCHANGE_RESULTS",returnResult);
         lessTxt.text = "剩余次数：" + _exChangeVo.lessNum;
      }
   }
}
