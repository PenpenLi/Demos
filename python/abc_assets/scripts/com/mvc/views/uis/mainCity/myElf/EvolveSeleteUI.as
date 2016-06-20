package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.ScrollContainer;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.managers.ElfFrontImageManager;
   import starling.display.Quad;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   
   public class EvolveSeleteUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.EvolveSeleteUI;
       
      private var swf:Swf;
      
      public var spr_selete:SwfSprite;
      
      public var btn_seleClose:SwfButton;
      
      private var elfContain:ScrollContainer;
      
      private var rootPage:com.mvc.views.uis.mainCity.myElf.MyElfUI;
      
      public var isScrolling:Boolean;
      
      private var imgVec:Vector.<com.mvc.views.uis.mainCity.myElf.EvolveElfUnit>;
      
      public function EvolveSeleteUI()
      {
         imgVec = new Vector.<com.mvc.views.uis.mainCity.myElf.EvolveElfUnit>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addContain();
         if(Facade.getInstance().hasMediator("MyElfMedia"))
         {
            rootPage = (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).myElf;
         }
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.EvolveSeleteUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.EvolveSeleteUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("elfPanel");
         spr_selete = swf.createSprite("spr_selete");
         btn_seleClose = spr_selete.getButton("btn_seleClose");
         spr_selete.x = 1136 - spr_selete.width >> 1;
         spr_selete.y = 640 - spr_selete.height >> 1;
         addChild(spr_selete);
         btn_seleClose.addEventListener("triggered",close);
      }
      
      private function close() : void
      {
         remove();
      }
      
      private function addContain() : void
      {
         elfContain = new ScrollContainer();
         spr_selete.addChild(elfContain);
         elfContain.width = 700;
         elfContain.height = 300;
         elfContain.y = 200;
         elfContain.x = 35;
         elfContain.scrollBarDisplayMode = "none";
         elfContain.verticalScrollPolicy = "none";
         elfContain.addEventListener("scrollStart",startScroll);
         elfContain.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
      }
      
      public function set myElfVO(param1:ElfVO) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         imgVec = Vector.<com.mvc.views.uis.mainCity.myElf.EvolveElfUnit>([]);
         _loc3_ = 0;
         while(_loc3_ < param1.evolveIdArr.length)
         {
            _loc4_ = GetElfFactor.getElfVO(param1.evolveIdArr[_loc3_]);
            _loc2_ = new com.mvc.views.uis.mainCity.myElf.EvolveElfUnit();
            _loc2_.myElfVo = _loc4_;
            _loc2_.beforeElfVo = param1;
            _loc2_.name = _loc4_.elfId;
            _loc2_.x = 200 * _loc3_ + Math.max(3 - param1.evolveIdArr.length,0) * 160;
            elfContain.addChild(_loc2_);
            imgVec.push(_loc2_);
            _loc3_++;
         }
         rootPage.addChild(this);
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            disposeTexture();
            elfContain.removeChildren(0,-1,true);
            getInstance().removeFromParent();
            ElfFrontImageManager.tempNoRemoveTexture = [];
         }
      }
      
      public function disposeTexture() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < imgVec.length)
         {
            imgVec[_loc1_].clean();
            _loc1_++;
         }
      }
   }
}
