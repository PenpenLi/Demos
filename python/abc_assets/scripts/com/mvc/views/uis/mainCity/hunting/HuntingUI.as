package com.mvc.views.uis.mainCity.hunting
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Quad;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadOtherAssetsManager;
   import extend.SoundEvent;
   import com.common.managers.ElfFrontImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class HuntingUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_huntingBg:SwfSprite;
      
      public var spr_playTipBg_s:SwfSprite;
      
      private var tipTf:TextField;
      
      private var helpBg:Quad;
      
      public var btn_playTipBtn:SwfButton;
      
      public var btn_close:SwfButton;
      
      public var btn_goHuntingBtn1:SwfButton;
      
      public var btn_goHuntingBtn2:SwfButton;
      
      public var btn_goHuntingBtn3:SwfButton;
      
      public var tf_lowElfName:TextField;
      
      public var tf_middleElfName:TextField;
      
      public var tf_heightElfName:TextField;
      
      public var tf_lowTicketNum:TextField;
      
      public var tf_middleTicketNum:TextField;
      
      public var tf_heightTicketNum:TextField;
      
      public var tf_lowEnterTime:TextField;
      
      public var tf_middleEnterTime:TextField;
      
      public var tf_heightEnterTime:TextField;
      
      public var normalElfWin:SwfSprite;
      
      public var specialElfWin:SwfSprite;
      
      public var hurntingResultBg:Quad;
      
      private var elfImage:Image;
      
      public function HuntingUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("hunting");
         spr_huntingBg = swf.createSprite("spr_huntingBg");
         spr_huntingBg.x = 1136 - spr_huntingBg.width >> 1;
         spr_huntingBg.y = 640 - spr_huntingBg.height >> 1;
         addChild(spr_huntingBg);
         var _loc1_:SwfSprite = spr_huntingBg.getSprite("spr_littleTip");
         spr_playTipBg_s = swf.createSprite("spr_playTipBg_s");
         tipTf = spr_playTipBg_s.getChildByName("tipTf") as TextField;
         tipTf.vAlign = "top";
         tipTf.text = "1.狩猎场每天凌晨自动刷新次数。\n\n2.狩猎场入场券可以通过每日任务和商店获取。\n\n3.玩家可以花费钻石购买狩猎场的进入次数。\n\n4.狩猎场的热点精灵每星期日刷新。\n\n5.使用神兽号角能在高级狩猎场百分百遇见神兽！";
         tf_lowElfName = spr_huntingBg.getTextField("tf_lowElfName");
         tf_middleElfName = spr_huntingBg.getTextField("tf_middleElfName");
         tf_heightElfName = spr_huntingBg.getTextField("tf_heightElfName");
         tf_lowTicketNum = spr_huntingBg.getTextField("tf_lowTicketNum");
         tf_lowTicketNum.text = "0";
         tf_lowTicketNum.touchable = false;
         tf_middleTicketNum = spr_huntingBg.getTextField("tf_middleTicketNum");
         tf_middleTicketNum.text = "0";
         tf_middleTicketNum.touchable = false;
         tf_heightTicketNum = spr_huntingBg.getTextField("tf_heightTicketNum");
         tf_heightTicketNum.text = "0";
         tf_heightTicketNum.touchable = false;
         tf_lowEnterTime = spr_huntingBg.getTextField("tf_lowEnterTime");
         tf_middleEnterTime = spr_huntingBg.getTextField("tf_middleEnterTime");
         tf_heightEnterTime = spr_huntingBg.getTextField("tf_heightEnterTime");
         var _loc2_:TextField = _loc1_.getTextField("tf_littleTips");
         _loc2_.autoScale = true;
         _loc2_.text = "热点精灵的遇见机率会随着狩猎券的使用数量累计叠加，当遇见热点精灵后累计机率会被重置。";
         btn_close = spr_huntingBg.getButton("btn_close");
         btn_playTipBtn = spr_huntingBg.getButton("btn_playTipBtn");
         btn_goHuntingBtn1 = spr_huntingBg.getButton("btn_goHuntingBtn1");
         btn_goHuntingBtn2 = spr_huntingBg.getButton("btn_goHuntingBtn2");
         btn_goHuntingBtn3 = spr_huntingBg.getButton("btn_goHuntingBtn3");
         initSpecialElfWin();
         initnNormalElfWin();
         hurntingResultBg = new Quad(1136,640,0);
         hurntingResultBg.alpha = 0.5;
      }
      
      private function initSpecialElfWin() : void
      {
         specialElfWin = swf.createSprite("spr_findBeast");
         specialElfWin.x = 1136 - specialElfWin.width >> 1;
         specialElfWin.y = 70;
         specialElfWin.getTextField("tf_elfName").color = 16777215;
         specialElfWin.getTextField("tf_elfName").fontName = "img_special";
      }
      
      private function initnNormalElfWin() : void
      {
         normalElfWin = swf.createSprite("spr_adventureResult");
         normalElfWin.x = 1136 - normalElfWin.width >> 1;
         normalElfWin.y = 640 - normalElfWin.height >> 1;
         normalElfWin.getTextField("tf_elfName").bold = true;
      }
      
      public function showNormalElf(param1:ElfVO) : void
      {
         elfvo = param1;
         addChild(hurntingResultBg);
         disposeResultTexture();
         var showNormalElfImage:Function = function():void
         {
            elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(elfvo.imgName));
            elfImage.name = "elfImage";
            elfImage.x = 245;
            elfImage.y = 200;
            elfImage.pivotX = elfImage.width / 2;
            elfImage.pivotY = elfImage.height / 2;
            normalElfWin.addChild(elfImage);
            if(elfImage.width == 300)
            {
               var _loc1_:* = 0.8;
               elfImage.scaleY = _loc1_;
               elfImage.scaleX = _loc1_;
            }
            addChild(normalElfWin);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfvo.sound);
         };
         ElfFrontImageManager.getInstance().getImg([elfvo.imgName],showNormalElfImage);
         normalElfWin.getTextField("tf_elfName").text = "遇到了" + elfvo.name;
      }
      
      public function showSpecialElfWin(param1:ElfVO) : void
      {
         elfvo = param1;
         addChild(hurntingResultBg);
         disposeResultTexture();
         var showSpecialElfImage:Function = function():void
         {
            elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(elfvo.imgName));
            elfImage.name = "elfImage";
            elfImage.pivotX = elfImage.width >> 1;
            elfImage.pivotY = elfImage.height >> 1;
            elfImage.y = 210;
            elfImage.x = 190;
            specialElfWin.addChild(elfImage);
            addChild(specialElfWin);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","elf" + elfvo.sound);
         };
         ElfFrontImageManager.getInstance().getImg([elfvo.imgName],showSpecialElfImage);
         specialElfWin.getTextField("tf_elfName").text = elfvo.name;
      }
      
      public function disposeResultTexture() : void
      {
         if(normalElfWin.getChildByName("elfImage"))
         {
            ElfFrontImageManager.getInstance().disposeImg(normalElfWin.getChildByName("elfImage") as Image);
         }
         if(specialElfWin.getChildByName("elfImage"))
         {
            ElfFrontImageManager.getInstance().disposeImg(specialElfWin.getChildByName("elfImage") as Image);
         }
         elfImage = null;
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
      
      public function cleanHelpBg() : void
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
