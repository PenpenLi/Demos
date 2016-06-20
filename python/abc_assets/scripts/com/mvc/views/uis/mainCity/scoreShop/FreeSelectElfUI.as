package com.mvc.views.uis.mainCity.scoreShop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.text.TextField;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.TiledRowsLayout;
   
   public class FreeSelectElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_selectElf:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_freeBtn:SwfButton;
      
      public var elfList:List;
      
      public var elfData:ListCollection;
      
      public var elfNum:int;
      
      public var elfBgUnitUIVec:Vector.<ElfBgUnitUI>;
      
      private var spr_freeSelectElfInfo:SwfSprite;
      
      public var tf_selectElfNum:TextField;
      
      public var tf_getFreeScore:TextField;
      
      public var tf_haveFreeScore:TextField;
      
      private var freeShopElfVec:Vector.<ElfVO>;
      
      public function FreeSelectElfUI()
      {
         elfBgUnitUIVec = new Vector.<ElfBgUnitUI>();
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_selectElf = swf.createSprite("spr_selectComElfTittle");
         spr_selectElf.x = 1136 - spr_selectElf.width >> 1;
         spr_selectElf.y = 640 - spr_selectElf.height >> 1;
         addChild(spr_selectElf);
         var _loc1_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         spr_freeSelectElfInfo = _loc1_.createSprite("spr_freeSelectElfInfo");
         spr_selectElf.addChild(spr_freeSelectElfInfo);
         btn_close = spr_selectElf.getButton("btn_close");
         btn_freeBtn = spr_freeSelectElfInfo.getButton("btn_freeBtn");
         tf_selectElfNum = spr_freeSelectElfInfo.getTextField("tf_selectElfNum");
         tf_getFreeScore = spr_freeSelectElfInfo.getTextField("tf_getFreeScore");
         tf_haveFreeScore = spr_freeSelectElfInfo.getTextField("tf_haveFreeScore");
         tf_haveFreeScore.fontName = "img_pvpShop";
         createElfList();
      }
      
      private function createElfList() : void
      {
         elfData = new ListCollection();
         elfList = new List();
         elfList.x = 15;
         elfList.y = 95;
         elfList.width = 820;
         elfList.height = 360;
         elfList.isSelectable = false;
         elfList.itemRendererProperties.stateToSkinFunction = null;
         elfList.itemRendererProperties.padding = 0;
         elfList.dataProvider = elfData;
         elfList.scrollBarDisplayMode = "none";
         elfList.addEventListener("initialize",changeLay);
         elfList.addEventListener("scrollStart",startScroll);
         elfList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         ElfBgUnitUI.isScrolling = false;
         elfList.dataViewPort.touchable = true;
      }
      
      private function startScroll() : void
      {
         ElfBgUnitUI.isScrolling = true;
         elfList.dataViewPort.touchable = false;
      }
      
      private function changeLay() : void
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalGap = 15;
         _loc1_.verticalGap = 15;
         elfList.layout = _loc1_;
      }
      
      public function addElfBgUI(param1:Vector.<ElfVO>) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         spr_selectElf.addChild(elfList);
         removeElfBgUnitUI();
         elfData.removeAll();
         freeShopElfVec = param1;
         elfNum = param1.length;
         _loc3_ = 0;
         while(_loc3_ < elfNum)
         {
            _loc2_ = new ElfBgUnitUI(false,true,true);
            _loc2_.identify = "神秘商店";
            _loc2_.myElfVo = param1[_loc3_];
            _loc2_.name = _loc3_;
            elfData.push({
               "label":"",
               "accessory":_loc2_
            });
            elfBgUnitUIVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function removeElfBgUnitUI() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = elfBgUnitUIVec.length;
         _loc1_ = _loc2_ - 1;
         while(_loc1_ >= 0)
         {
            elfBgUnitUIVec[_loc1_].removeFromParent(true);
            elfBgUnitUIVec.splice(_loc1_,1);
            _loc1_--;
         }
      }
   }
}
