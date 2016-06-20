package com.mvc.views.uis.mainCity.hunting
{
   import starling.display.Sprite;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import feathers.layout.TiledColumnsLayout;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.managers.ElfFrontImageManager;
   import com.common.managers.LoadOtherAssetsManager;
   import com.mvc.views.mediator.fighting.AniFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   
   public class HuntingElfCamp extends Sprite
   {
       
      private var elfList:List;
      
      public var elfData:ListCollection;
      
      private var huntingElfUnitVec:Vector.<com.mvc.views.uis.mainCity.hunting.HuntingSmallElfUnit>;
      
      private var elfVO:ElfVO;
      
      private var specialElfImg:Image;
      
      private var sprite:Sprite;
      
      public function HuntingElfCamp()
      {
         huntingElfUnitVec = new Vector.<com.mvc.views.uis.mainCity.hunting.HuntingSmallElfUnit>();
         super();
         createElfList();
      }
      
      private function createElfList() : void
      {
         elfData = new ListCollection();
         elfList = new List();
         elfList.width = 270;
         elfList.height = 130;
         elfList.isSelectable = false;
         elfList.horizontalScrollPolicy = "off";
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
         var _loc1_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc1_.verticalAlign = "top";
         _loc1_.horizontalGap = -20;
         _loc1_.verticalGap = -35;
         _loc1_.paddingTop = -18;
         _loc1_.paddingLeft = 10;
         elfList.layout = _loc1_;
      }
      
      public function addHuntingElfUnit(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = null;
         var _loc2_:* = null;
         addChild(elfList);
         removeHuntingElfUnitUI();
         elfData.removeAll();
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_ - 1)
         {
            _loc5_ = GetElfFactor.getElfVO(param1[_loc4_],false);
            _loc2_ = new com.mvc.views.uis.mainCity.hunting.HuntingSmallElfUnit();
            var _loc6_:* = 0.4;
            _loc2_.scaleY = _loc6_;
            _loc2_.scaleX = _loc6_;
            _loc2_.elfvo = _loc5_;
            elfData.push({
               "label":"",
               "accessory":_loc2_
            });
            huntingElfUnitVec.push(_loc2_);
            _loc4_++;
         }
      }
      
      public function addSpecialElf(param1:ElfVO) : void
      {
         elfVO = param1;
         ElfFrontImageManager.getInstance().getImg([elfVO.imgName],showElfImage);
         ElfFrontImageManager.tempNoRemoveTexture.push(elfVO.imgName);
      }
      
      private function showElfImage() : void
      {
         specialElfImg = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(elfVO.imgName));
         specialElfImg.alignPivot("center","bottom");
         var _loc1_:* = 0.8;
         specialElfImg.scaleY = _loc1_;
         specialElfImg.scaleX = _loc1_;
         specialElfImg.x = this.width >> 1;
         specialElfImg.y = -115;
         AniFactor.ifOpen = true;
         AniFactor.elfAni(specialElfImg);
         specialElfImg.addEventListener("touch",specialElfImg_touchHandler);
         addChild(specialElfImg);
      }
      
      private function specialElfImg_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(specialElfImg);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               ExtendElfUnitTips.getInstance().showElfTips(elfVO,this);
            }
            if(_loc2_.phase == "ended")
            {
               ExtendElfUnitTips.getInstance().removeElfTips();
            }
         }
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
      
      public function destorySpecialElfImg() : void
      {
         if(specialElfImg)
         {
            ElfFrontImageManager.getInstance().disposeImg(specialElfImg);
         }
      }
   }
}
