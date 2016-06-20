package com.mvc.views.uis.mainCity.amuse
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.mainCity.hunting.HuntingSmallElfUnit;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import feathers.layout.TiledRowsLayout;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.core.Starling;
   
   public class AmusePreviewUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.amuse.AmusePreviewUI;
       
      private var swf:Swf;
      
      private var spr_preview:SwfSprite;
      
      private var tf_previewTittle:TextField;
      
      private var tf_tips:TextField;
      
      private var elfList:List;
      
      public var elfData:ListCollection;
      
      private var huntingElfUnitVec:Vector.<HuntingSmallElfUnit>;
      
      private var bg:Quad;
      
      public function AmusePreviewUI()
      {
         huntingElfUnitVec = new Vector.<HuntingSmallElfUnit>();
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.amuse.AmusePreviewUI
      {
         return instance || new com.mvc.views.uis.mainCity.amuse.AmusePreviewUI();
      }
      
      private function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         bg.addEventListener("touch",bg_touchHandler);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("amuse");
         spr_preview = swf.createSprite("spr_preview");
         addChild(spr_preview);
         tf_previewTittle = spr_preview.getTextField("tf_previewTittle");
         tf_tips = spr_preview.getTextField("tf_tips");
         createElfList();
      }
      
      private function bg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(bg);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            removeSelf();
         }
      }
      
      private function createElfList() : void
      {
         elfData = new ListCollection();
         elfList = new List();
         elfList.x = 296;
         elfList.y = 215;
         elfList.width = 620;
         elfList.height = 300;
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
         _loc1_.verticalAlign = "middle";
         _loc1_.horizontalGap = 25;
         _loc1_.verticalGap = 20;
         elfList.layout = _loc1_;
      }
      
      public function showPreview(param1:Vector.<ElfVO>) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         addChild(elfList);
         removeHuntingElfUnitUI();
         elfData.removeAll();
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new HuntingSmallElfUnit();
            _loc2_.elfvo = param1[_loc4_];
            elfData.push({
               "label":"",
               "accessory":_loc2_
            });
            huntingElfUnitVec.push(_loc2_);
            _loc4_++;
         }
         (Starling.current.root as Game).addChild(this);
      }
      
      public function removeHuntingElfUnitUI() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = huntingElfUnitVec.length;
         _loc2_ = _loc1_ - 1;
         while(_loc2_ >= 0)
         {
            huntingElfUnitVec[_loc2_].removeFromParent(true);
            huntingElfUnitVec.splice(_loc2_,1);
            _loc2_--;
         }
      }
      
      public function removeSelf() : void
      {
         removeFromParent(true);
         instance = null;
      }
   }
}
