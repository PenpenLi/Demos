package com.mvc.views.uis.mainCity.elfCenter
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfMovieClip;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ElfCenterUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var mc_cartoon:SwfMovieClip;
      
      public var spr_elfCenterBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_buyBtn:SwfButton;
      
      public var btn_Recover:SwfButton;
      
      public var prompt:TextField;
      
      public var count:TextField;
      
      public var countDown:TextField;
      
      public var btn_playTip:Button;
      
      public var nextRecoveImg:Image;
      
      public var remainTimeImg:Image;
      
      private var tipTf:TextField;
      
      public var spr_playTipBg_s:SwfSprite;
      
      public var btn_recoverAll:SwfButton;
      
      public var mc_mouth:SwfMovieClip;
      
      public var spr_nurse:SwfSprite;
      
      public var mc_eye:SwfMovieClip;
      
      private var elfContain:SwfSprite;
      
      private var swfLoading:Swf;
      
      private var helpBg:Quad;
      
      public function ElfCenterUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfCenter");
         swfLoading = LoadSwfAssetsManager.getInstance().assets.getSwf("loading");
         spr_elfCenterBg = swf.createSprite("spr_elfCenterBg");
         spr_playTipBg_s = swf.createSprite("spr_playTipBg_s");
         elfContain = spr_elfCenterBg.getSprite("elfContain");
         mc_cartoon = elfContain.getMovie("mc_cartoon");
         btn_close = spr_elfCenterBg.getButton("btn_close");
         btn_close.name = "btn_close";
         btn_buyBtn = spr_elfCenterBg.getButton("btn_buyBtn");
         btn_buyBtn.visible = false;
         btn_Recover = spr_elfCenterBg.getButton("btn_Recover");
         btn_Recover.name = "btn_Recover";
         btn_recoverAll = spr_elfCenterBg.getButton("btn_recoverAll");
         btn_playTip = spr_elfCenterBg.getButton("btn_playTip");
         remainTimeImg = spr_elfCenterBg.getImage("remainTimeImg");
         nextRecoveImg = spr_elfCenterBg.getImage("nextRecoveImg");
         var _loc1_:* = 0.9;
         elfContain.scaleY = _loc1_;
         elfContain.scaleX = _loc1_;
         elfContain.y = elfContain.y + 60;
         elfContain.x = elfContain.x + 25;
         tipTf = spr_playTipBg_s.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         prompt = spr_elfCenterBg.getTextField("prompt");
         count = spr_elfCenterBg.getTextField("count");
         count.fontName = "img_VIP";
         count.color = 16777215;
         countDown = spr_elfCenterBg.getTextField("countDown");
         countDown.fontName = "img_font";
         mc_mouth = swfLoading.createMovieClip("mc_zhuiba");
         mc_mouth.x = 165;
         mc_mouth.y = 352;
         spr_elfCenterBg.addChild(mc_mouth);
         mc_mouth.stop();
         mc_eye = swfLoading.createMovieClip("mc_yanjing");
         mc_eye.x = 127;
         mc_eye.y = 305;
         spr_elfCenterBg.addChild(mc_eye);
         addChild(spr_elfCenterBg);
         mc_cartoon.stop();
         prompt.hAlign = "left";
         showDown(false);
      }
      
      public function showDown(param1:Boolean) : void
      {
         countDown.visible = param1;
         nextRecoveImg.visible = param1;
      }
      
      public function addHelp() : void
      {
         if(!helpBg)
         {
            helpBg = new Quad(1136,640,0);
            helpBg.alpha = 0.7;
            spr_playTipBg_s.addChildAt(helpBg,0);
         }
         addChild(spr_playTipBg_s);
         spr_playTipBg_s.addEventListener("touch",playTipImg_touchHandler);
      }
      
      public function clean() : void
      {
         spr_playTipBg_s.removeFromParent(true);
         spr_playTipBg_s = null;
      }
      
      private function playTipImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(spr_playTipBg_s);
         if(_loc2_ != null && _loc2_.phase == "ended")
         {
            spr_playTipBg_s.removeFromParent();
            spr_playTipBg_s.removeEventListener("touch",playTipImg_touchHandler);
         }
      }
   }
}
