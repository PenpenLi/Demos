package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import starling.display.Image;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.geom.Rectangle;
   import com.common.managers.ElfFrontImageManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.events.EventCenter;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   
   public class MyElfUI extends Sprite
   {
      
      public static var starWidth:Number;
       
      private var swf:Swf;
      
      public var mySpr:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var lockVec:Vector.<com.mvc.views.uis.mainCity.myElf.LockUnitUI>;
      
      public var containAll:Sprite;
      
      public var elfContain:Sprite;
      
      private var spr_elfBg:SwfSprite;
      
      public var btn_recover:SwfButton;
      
      private var elfName:TextField;
      
      private var starImg:SwfSprite;
      
      private var elfLv:TextField;
      
      private var elfExp:TextField;
      
      private var elfPower:TextField;
      
      public var btn_skill:SwfButton;
      
      public var btn_break:SwfButton;
      
      public var btn_evolve:SwfButton;
      
      public var btn_states:SwfButton;
      
      public var image:Image;
      
      public var hagberry:com.mvc.views.uis.mainCity.myElf.CarryPropUI;
      
      public var carryEquip:com.mvc.views.uis.mainCity.myElf.CarryPropUI;
      
      public var btn_star:SwfButton;
      
      public var btn_preview:SwfButton;
      
      public var breakPropmpt:SwfImage;
      
      public var starPropmpt:SwfImage;
      
      public var evolvePrompt:SwfImage;
      
      public var skillPrompt:SwfImage;
      
      private var _elfVO:ElfVO;
      
      public var btn_individual:SwfButton;
      
      private var size:int = 170;
      
      public function MyElfUI()
      {
         var _loc1_:* = null;
         lockVec = new Vector.<com.mvc.views.uis.mainCity.myElf.LockUnitUI>([]);
         super();
         if((Config.starling.root as Game).page.name == "HuntingPartyMedia")
         {
            _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("huntParty1"));
            var _loc2_:* = 1.3;
            _loc1_.scaleY = _loc2_;
            _loc1_.scaleX = _loc2_;
         }
         else
         {
            _loc1_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
            _loc2_ = 1.515;
            _loc1_.scaleY = _loc2_;
            _loc1_.scaleX = _loc2_;
            _loc1_.y = -328;
         }
         addChild(_loc1_);
         init();
         addpropContian();
      }
      
      private function addpropContian() : void
      {
         hagberry = new com.mvc.views.uis.mainCity.myElf.CarryPropUI(0);
         carryEquip = new com.mvc.views.uis.mainCity.myElf.CarryPropUI(1);
         hagberry.x = 25;
         carryEquip.x = 265;
         var _loc1_:* = 243;
         carryEquip.y = _loc1_;
         hagberry.y = _loc1_;
         spr_elfBg.addChild(hagberry);
         spr_elfBg.addChild(carryEquip);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         mySpr = swf.createSprite("spr_main");
         spr_elfBg = mySpr.getSprite("spr_elfBg");
         btn_close = mySpr.getButton("btn_close");
         btn_recover = mySpr.getButton("btn_recover");
         elfName = spr_elfBg.getTextField("elfName");
         starImg = spr_elfBg.getSprite("starImg");
         elfLv = spr_elfBg.getTextField("elfLv");
         elfExp = spr_elfBg.getTextField("elfExp");
         elfPower = spr_elfBg.getTextField("elfPower");
         btn_skill = spr_elfBg.getButton("btn_skill");
         btn_break = spr_elfBg.getButton("btn_break");
         btn_evolve = spr_elfBg.getButton("btn_evolve");
         btn_states = spr_elfBg.getButton("btn_states");
         btn_star = spr_elfBg.getButton("btn_star");
         btn_preview = spr_elfBg.getButton("btn_preview");
         btn_individual = spr_elfBg.getButton("btn_individual");
         breakPropmpt = spr_elfBg.getImage("breakPropmpt");
         starPropmpt = spr_elfBg.getImage("starPropmpt");
         evolvePrompt = spr_elfBg.getImage("evolvePrompt");
         skillPrompt = spr_elfBg.getImage("skillPropmpt");
         var _loc1_:* = false;
         skillPrompt.visible = _loc1_;
         _loc1_ = _loc1_;
         evolvePrompt.touchable = _loc1_;
         _loc1_ = _loc1_;
         starPropmpt.touchable = _loc1_;
         breakPropmpt.touchable = _loc1_;
         starWidth = starImg.width / 5;
         mySpr.x = 50;
         mySpr.y = 20;
         addChild(mySpr);
         containAll = new Sprite();
         containAll.x = mySpr.x + mySpr.width;
         containAll.y = mySpr.y;
         addChild(containAll);
         elfContain = new Sprite();
         mySpr.addChild(elfContain);
         containAll.addChild(ElfInfoUI.getInstance());
         ElfInfoUI.getInstance().myElfVo = PlayerVO.bagElfVec[0];
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         if(param1.elfId > 20000)
         {
            (spr_elfBg.getChildAt(12) as Image).visible = false;
            starImg.visible = false;
            size = 230;
         }
         else
         {
            (spr_elfBg.getChildAt(12) as Image).visible = true;
            starImg.visible = true;
            size = 170;
            starImg.clipRect = new Rectangle(0,0,param1.starts * starWidth,starImg.height);
         }
         if(image != null)
         {
            ElfFrontImageManager.getInstance().disposeImg(image);
         }
         AniFactor.ifOpen = true;
         _elfVO = param1;
         ElfFrontImageManager.getInstance().getImg([param1.imgName],showElf);
         elfName.text = param1.name + ElfBreakUI.getInstance().brokenStr[param1.brokenLv];
         elfName.color = ElfBreakUI.getInstance().brokenColor[param1.brokenLv];
         elfLv.text = "等级:" + param1.lv;
         elfExp.text = "经验:" + param1.currentExp;
         elfPower.text = "战斗力:" + Math.round(param1.attack + param1.super_attack + param1.super_defense + param1.defense + param1.speed + param1.totalHp);
         hagberry.myProp = param1.hagberryProp;
         LogUtil("携带物道具===========",param1.carryProp);
         carryEquip.myProp = param1.carryProp;
      }
      
      private function showElf() : void
      {
         LogUtil("--------------加载完精灵图片-----------",_elfVO.imgName);
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_elfVO.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,size);
         image.x = 188;
         image.y = 250;
         spr_elfBg.addChild(image);
         AniFactor.elfAni(image);
         EventCenter.dispatchEvent("LOAD_ELFIMG_SUCCESS");
      }
      
      public function addLock(param1:int) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         lockVec = Vector.<com.mvc.views.uis.mainCity.myElf.LockUnitUI>([]);
         _loc3_ = param1;
         while(_loc3_ < 6)
         {
            _loc2_ = new com.mvc.views.uis.mainCity.myElf.LockUnitUI();
            _loc2_.x = MyElfMedia.elflefting;
            _loc2_.y = MyElfMedia.elfGap * _loc3_ + MyElfMedia.elfToping;
            switch(_loc3_ - 3)
            {
               case 0:
                  _loc2_.lockTxt.text = "20级\n自动解锁";
                  _loc2_.btn_lock200.visible = true;
                  break;
               case 1:
                  _loc2_.lockTxt.text = "25级\n自动解锁";
                  _loc2_.btn_lock300.visible = true;
                  break;
               case 2:
                  _loc2_.lockTxt.text = "30级\n自动解锁";
                  _loc2_.btn_lock400.visible = true;
                  break;
            }
            elfContain.addChild(_loc2_);
            lockVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function addElfInfo(param1:int) : void
      {
         ElfPreviewUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         ElfStarUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         ElfInfoUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         ElfIndividualUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         ElfBreakUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         ElfEvolveUI.getInstance().myElfVo = PlayerVO.bagElfVec[param1];
         myElfVo = PlayerVO.bagElfVec[param1];
      }
      
      public function swithBtn(param1:SwfButton, param2:SwfButton, param3:SwfButton) : void
      {
         param1.visible = false;
         param2.visible = true;
         param3.visible = true;
         btn_states.visible = true;
         btn_states.x = param1.x;
         btn_states.y = param1.y;
      }
   }
}
