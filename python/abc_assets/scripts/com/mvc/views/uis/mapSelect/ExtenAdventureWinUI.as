package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.display.Button;
   import starling.text.TextField;
   import feathers.controls.ScrollContainer;
   import lzm.starling.swf.display.SwfMovieClip;
   import starling.display.Image;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import feathers.layout.VerticalLayout;
   import com.mvc.models.vos.mapSelect.ExtenMapVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   
   public class ExtenAdventureWinUI extends Sprite
   {
       
      public var mySpr:SwfSprite;
      
      private var swf:Swf;
      
      public var advanceBtn:Button;
      
      public var exitBtn:Button;
      
      public var needPowerTf:TextField;
      
      public var elfLvTf:TextField;
      
      public var extenContentContainer:ScrollContainer;
      
      public var result:SwfSprite;
      
      public var advanceAni1:SwfMovieClip;
      
      public var advanceAni2:SwfMovieClip;
      
      public var specialElfWin:SwfSprite;
      
      private var imgName:String;
      
      private var elfImage:Image;
      
      public function ExtenAdventureWinUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         mySpr = swf.createSprite("spr_extenWin_s");
         mySpr.x = 240;
         mySpr.y = 10;
         addChild(mySpr);
         advanceBtn = mySpr.getButton("advanceBtn");
         exitBtn = mySpr.getButton("exitBtn");
         needPowerTf = mySpr.getTextField("needPowerTf");
         elfLvTf = mySpr.getTextField("elfLvTf");
         needPowerTf.bold = true;
         initContainer();
         initResult();
         advanceAni1 = swf.createMovieClip("mc_meet1");
         advanceAni1.loop = false;
         advanceAni1.gotoAndStop(0);
         advanceAni1.x = 582;
         advanceAni1.y = 314;
         advanceAni2 = swf.createMovieClip("mc_meet2");
         advanceAni2.loop = false;
         advanceAni2.gotoAndStop(0);
         advanceAni2.x = 582;
         advanceAni2.y = 314;
         initSpecialElfWin();
      }
      
      private function initSpecialElfWin() : void
      {
         specialElfWin = swf.createSprite("spr_specialElfWin_s");
         specialElfWin.x = 170;
         specialElfWin.y = 30;
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         _loc1_.x = -170;
         _loc1_.y = -30;
         specialElfWin.addChild(_loc1_);
         specialElfWin.setChildIndex(_loc1_,0);
         specialElfWin.getTextField("elfNameTF").color = 16777215;
         specialElfWin.getTextField("elfNameTF").fontName = "img_special";
      }
      
      private function initResult() : void
      {
         result = swf.createSprite("spr_extenADResult_s");
         result.x = 340;
         result.y = 65;
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         _loc1_.x = -340;
         _loc1_.y = -65;
         result.addChild(_loc1_);
         result.setChildIndex(_loc1_,0);
         result.getTextField("elfNameTf").bold = true;
      }
      
      public function showResult(param1:ElfVO) : void
      {
         disposeResultTexture();
         imgName = param1.imgName;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showNormalElfImage);
         result.getTextField("elfNameTf").text = "遇到了" + param1.name;
      }
      
      private function showNormalElfImage() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         elfImage.name = "elfImage";
         elfImage.x = 245;
         elfImage.y = 200;
         elfImage.pivotX = elfImage.width / 2;
         elfImage.pivotY = elfImage.height / 2;
         result.addChild(elfImage);
         if(elfImage.width == 300)
         {
            var _loc1_:* = 0.8;
            elfImage.scaleY = _loc1_;
            elfImage.scaleX = _loc1_;
         }
         addChild(result);
         BeginnerGuide.playBeginnerGuide();
      }
      
      public function showSpecialElfWin(param1:ElfVO) : void
      {
         disposeResultTexture();
         imgName = param1.imgName;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showSpecialElfImage);
         specialElfWin.getTextField("elfNameTF").text = param1.name;
      }
      
      private function showSpecialElfImage() : void
      {
         elfImage = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(imgName));
         elfImage.name = "elfImage";
         elfImage.pivotX = elfImage.width >> 1;
         elfImage.pivotY = elfImage.height >> 1;
         elfImage.y = 249;
         elfImage.x = 190;
         specialElfWin.addChild(elfImage);
         addChild(specialElfWin);
      }
      
      public function disposeResultTexture() : void
      {
         if(result.getChildByName("elfImage"))
         {
            ElfFrontImageManager.getInstance().disposeImg(result.getChildByName("elfImage") as Image);
         }
         if(specialElfWin.getChildByName("elfImage"))
         {
            ElfFrontImageManager.getInstance().disposeImg(specialElfWin.getChildByName("elfImage") as Image);
         }
         imgName = null;
      }
      
      private function initContainer() : void
      {
         extenContentContainer = new ScrollContainer();
         extenContentContainer.width = 600;
         extenContentContainer.height = 295;
         extenContentContainer.x = 32;
         extenContentContainer.y = 198;
         mySpr.addChild(extenContentContainer);
         var _loc1_:VerticalLayout = new VerticalLayout();
         extenContentContainer.layout = _loc1_;
         extenContentContainer.horizontalScrollPolicy = "none";
      }
      
      public function upDateExtenContent(param1:ExtenMapVO) : void
      {
         var _loc2_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc4_:* = null;
         needPowerTf.text = param1.needPower.toString();
         extenContentContainer.removeChildren(0,-1,true);
         var _loc5_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < param1.elfArr.length)
         {
            _loc2_ = swf.createSprite("spr_extenUnit_s");
            _loc3_ = _loc2_.getTextField("timeTf");
            _loc3_.bold = true;
            if(param1.elfArr[_loc6_].hasOwnProperty("hide"))
            {
               param1.isSpecial = true;
               _loc3_.text = "??????";
            }
            else
            {
               _loc3_.text = param1.elfArr[_loc6_].begHour + ":00 ~ " + param1.elfArr[_loc6_].endHour + ":00";
            }
            _loc7_ = 0;
            while(_loc7_ < param1.elfArr[_loc6_].pokes.length)
            {
               _loc8_ = param1.elfArr[_loc6_].pokes[_loc7_];
               LogUtil(JSON.stringify(_loc8_) + "野外对象");
               _loc4_ = new ExtendElfUnit();
               _loc4_.myElfVO = GetElfFactor.getElfVO(_loc8_.staId);
               _loc4_.y = 6;
               _loc4_.x = 325 + _loc7_ * 93;
               _loc2_.addChild(_loc4_);
               _loc5_.push(_loc8_.lv);
               _loc7_++;
            }
            extenContentContainer.addChild(_loc2_);
            _loc6_++;
         }
         _loc5_.sort(16);
         elfLvTf.text = _loc5_[0] + "~" + _loc5_[_loc5_.length - 1];
         _loc5_ = null;
      }
   }
}
