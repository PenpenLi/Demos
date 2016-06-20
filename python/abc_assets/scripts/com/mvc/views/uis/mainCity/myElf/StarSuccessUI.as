package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import flash.geom.Rectangle;
   import extend.SoundEvent;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.display.Quad;
   
   public class StarSuccessUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.StarSuccessUI;
       
      private var swf:Swf;
      
      private var spr_starAni:SwfSprite;
      
      private var beforePower:TextField;
      
      private var nowPower:TextField;
      
      private var btn_ok:SwfButton;
      
      private var mc_light:SwfMovieClip;
      
      private var starImg:SwfSprite;
      
      private var image:Image;
      
      private var rootClass:Game;
      
      private var posX:Number;
      
      private var posY:Number;
      
      private var shadows:Image;
      
      private var imgName:String;
      
      public function StarSuccessUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         rootClass = Config.starling.root as Game;
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.StarSuccessUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.StarSuccessUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_starAni = swf.createSprite("spr_starAni");
         beforePower = spr_starAni.getTextField("beforePower");
         nowPower = spr_starAni.getTextField("nowPower");
         starImg = spr_starAni.getSprite("starImg");
         btn_ok = spr_starAni.getButton("btn_ok");
         mc_light = spr_starAni.getMovie("mc_light");
         shadows = spr_starAni.getImage("shadows");
         shadows.alpha = 0.7;
         shadows.pivotX = shadows.width / 2;
         shadows.pivotY = shadows.height / 2;
         spr_starAni.x = (1136 - spr_starAni.width >> 1) - 10;
         spr_starAni.y = 25;
         addChild(spr_starAni);
         posX = mc_light.x + mc_light.width / 2;
         posY = mc_light.y + mc_light.height / 2;
         btn_ok.addEventListener("triggered",onclose);
      }
      
      public function onclose() : void
      {
         if(getInstance().parent)
         {
            if(image)
            {
               image.removeFromParent(true);
            }
            mc_light.stop();
            this.removeFromParent();
            ElfFrontImageManager.tempNoRemoveTexture = [];
         }
      }
      
      public function show(param1:ElfVO) : void
      {
         mc_light.play();
         shadows.visible = false;
         imgName = param1.imgName;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         beforePower.text = GetElfFactor.calculatePower(param1);
         param1.starts = param1.starts + 1;
         CalculatorFactor.calculatorElf(param1);
         nowPower.text = GetElfFactor.calculatePower(param1);
         starImg.clipRect = new Rectangle(0,0,param1.starts * MyElfUI.starWidth,starImg.height);
         rootClass.addChild(this);
         SoundEvent.dispatchEvent("play_music_and_stop_bg",{
            "musicName":"starSuccess",
            "isContinuePlayBGM":true
         });
      }
      
      private function showElf() : void
      {
         LogUtil("显示精灵===========");
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,250,true);
         image.x = posX;
         image.y = posY;
         spr_starAni.addChild(image);
         shadows.x = posX;
         shadows.y = image.y + image.height / 2;
         shadows.visible = true;
      }
   }
}
