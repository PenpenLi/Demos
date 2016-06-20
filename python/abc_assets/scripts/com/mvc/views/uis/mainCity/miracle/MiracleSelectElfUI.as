package com.mvc.views.uis.mainCity.miracle
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.TiledRowsLayout;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   
   public class MiracleSelectElfUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_selectElf:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var elfBtnList:List;
      
      public var elfBtnData:ListCollection;
      
      public var elfNum:int;
      
      public var elfBtnVec:Vector.<SwfButton>;
      
      public function MiracleSelectElfUI()
      {
         elfBtnVec = new Vector.<SwfButton>();
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
         btn_close = spr_selectElf.getButton("btn_close");
         createBtnContainer();
      }
      
      private function createBtnContainer() : void
      {
         elfBtnData = new ListCollection();
         elfBtnList = new List();
         elfBtnList.x = 10;
         elfBtnList.y = 100;
         elfBtnList.height = 420;
         elfBtnList.width = 820;
         elfBtnList.isSelectable = false;
         elfBtnList.itemRendererProperties.stateToSkinFunction = null;
         elfBtnList.itemRendererProperties.padding = 0;
         elfBtnList.dataProvider = elfBtnData;
         elfBtnList.scrollBarDisplayMode = "none";
         elfBtnList.addEventListener("initialize",changeLay);
      }
      
      private function changeLay() : void
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalGap = 15;
         _loc1_.verticalGap = 15;
         elfBtnList.layout = _loc1_;
      }
      
      public function addElfBtn(param1:Vector.<ElfVO>) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         spr_selectElf.addChild(elfBtnList);
         removeHeadBtn();
         elfBtnData.removeAll();
         elfNum = param1.length;
         _loc4_ = 0;
         while(_loc4_ < elfNum)
         {
            _loc2_ = new ElfBgUnitUI(false,true,true);
            _loc2_.identify = "奇迹交换";
            _loc2_.myElfVo = param1[_loc4_];
            _loc3_ = new SwfButton(_loc2_);
            _loc3_.name = _loc4_;
            elfBtnData.push({
               "label":"",
               "accessory":_loc3_
            });
            elfBtnVec.push(_loc3_);
            _loc4_++;
         }
      }
      
      public function removeHeadBtn() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = elfBtnVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            elfBtnVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         elfBtnVec = Vector.<SwfButton>([]);
      }
   }
}
