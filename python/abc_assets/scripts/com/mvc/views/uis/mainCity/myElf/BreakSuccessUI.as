package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.filters.BlurFilter;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import extend.SoundEvent;
   import starling.display.Quad;
   
   public class BreakSuccessUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.BreakSuccessUI;
       
      private var swf:Swf;
      
      private var spr_breakAni:SwfSprite;
      
      private var beforePower:TextField;
      
      private var nowPower:TextField;
      
      private var btn_ok:SwfButton;
      
      private var mc_break:SwfMovieClip;
      
      private var rootClass:Game;
      
      private var image:Image;
      
      private var posX:Number;
      
      private var posY:Number;
      
      private var beforeElf:ElfBgUnitUI;
      
      private var afterElf:ElfBgUnitUI;
      
      private var beforeName:TextField;
      
      private var nowName:TextField;
      
      public function BreakSuccessUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         rootClass = Config.starling.root as Game;
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.BreakSuccessUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.BreakSuccessUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_breakAni = swf.createSprite("spr_breakAni");
         beforePower = spr_breakAni.getTextField("beforePower");
         nowPower = spr_breakAni.getTextField("nowPower");
         btn_ok = spr_breakAni.getButton("btn_ok");
         mc_break = spr_breakAni.getMovie("mc_break");
         beforeName = spr_breakAni.getTextField("beforeName");
         nowName = spr_breakAni.getTextField("nowName");
         beforeName.filter = BlurFilter.createGlow(16777215,5,1,3);
         nowName.filter = BlurFilter.createGlow(16777215,5,1,3);
         posX = mc_break.x + mc_break.width / 2;
         posY = mc_break.y + mc_break.height / 2;
         spr_breakAni.x = (1136 - spr_breakAni.width >> 1) + 50;
         spr_breakAni.y = 640 - spr_breakAni.height >> 1;
         addChild(spr_breakAni);
         btn_ok.addEventListener("triggered",onclose);
      }
      
      public function onclose() : void
      {
         if(getInstance().parent)
         {
            if(beforeElf.parent)
            {
               beforeElf.removeFromParent(true);
            }
            if(afterElf.parent)
            {
               afterElf.removeFromParent(true);
            }
            mc_break.stop();
            this.removeFromParent();
            ElfFrontImageManager.tempNoRemoveTexture = [];
         }
      }
      
      public function show(param1:ElfVO) : void
      {
         mc_break.play();
         beforeElf = new ElfBgUnitUI(true);
         beforeElf.identify = "突破成功";
         beforeElf.myElfVo = param1;
         beforeElf.pivotX = beforeElf.width / 2;
         beforeElf.pivotY = beforeElf.height / 2;
         beforeElf.x = posX - 300;
         beforeElf.y = posY;
         spr_breakAni.addChild(beforeElf);
         beforePower.text = GetElfFactor.calculatePower(param1);
         beforeName.text = param1.name + ElfBreakUI.getInstance().brokenStr[param1.brokenLv];
         beforeName.color = ElfBreakUI.getInstance().brokenColor[param1.brokenLv];
         param1.brokenLv = param1.brokenLv + 1;
         afterElf = new ElfBgUnitUI(true);
         afterElf.identify = "突破成功";
         afterElf.myElfVo = param1;
         afterElf.pivotX = afterElf.width / 2;
         afterElf.pivotY = afterElf.height / 2;
         afterElf.x = posX;
         afterElf.y = posY;
         spr_breakAni.addChild(afterElf);
         CalculatorFactor.calculatorElf(param1);
         nowPower.text = GetElfFactor.calculatePower(param1);
         nowName.text = param1.name + ElfBreakUI.getInstance().brokenStr[param1.brokenLv];
         nowName.color = ElfBreakUI.getInstance().brokenColor[param1.brokenLv];
         rootClass.addChild(this);
         SoundEvent.dispatchEvent("play_music_and_stop_bg",{
            "musicName":"breakSuccess",
            "isContinuePlayBGM":true
         });
      }
   }
}
