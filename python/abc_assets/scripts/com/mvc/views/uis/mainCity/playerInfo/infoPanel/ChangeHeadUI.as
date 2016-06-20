package com.mvc.views.uis.mainCity.playerInfo.infoPanel
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import lzm.starling.swf.display.SwfButton;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Quad;
   import feathers.layout.TiledRowsLayout;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.managers.ELFMinImageManager;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.display.Image;
   
   public class ChangeHeadUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var changeHeadSpr:SwfSprite;
      
      public var headCloseBtn:Button;
      
      public var headBtnList:List;
      
      public var headBtnData:ListCollection;
      
      public var headPanelBg:Scale9Image;
      
      public var headBtnVec:Vector.<SwfButton>;
      
      public var ptNum:int;
      
      public function ChangeHeadUI()
      {
         headBtnVec = new Vector.<SwfButton>();
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         changeHeadSpr = swf.createSprite("spr_replace_headPicPanel_s");
         changeHeadSpr.x = 1136 - changeHeadSpr.width >> 1;
         changeHeadSpr.y = 640 - changeHeadSpr.height >> 1;
         addChild(changeHeadSpr);
         headCloseBtn = changeHeadSpr.getButton("headCloseBtn");
         createBtnContainer();
         headPanelBg = changeHeadSpr.getChildByName("headPanelBg") as Scale9Image;
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChildAt(_loc1_,0);
      }
      
      private function createBtnContainer() : void
      {
         headBtnData = new ListCollection();
         headBtnList = new List();
         headBtnList.x = 10;
         headBtnList.y = 68;
         headBtnList.height = 242;
         headBtnList.width = 500;
         headBtnList.isSelectable = false;
         headBtnList.itemRendererProperties.stateToSkinFunction = null;
         headBtnList.itemRendererProperties.padding = 0;
         headBtnList.dataProvider = headBtnData;
         headBtnList.scrollBarDisplayMode = "none";
         changeHeadSpr.addChild(headBtnList);
         headBtnList.addEventListener("initialize",changeLay);
      }
      
      private function changeLay() : void
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalGap = 8;
         _loc1_.verticalGap = 5;
         headBtnList.layout = _loc1_;
      }
      
      public function addPtHeadBtn() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         var _loc3_:* = null;
         removeHeadBtn();
         headBtnData.removeAll();
         headBtnList.x = 10;
         headBtnList.y = 68;
         headPanelBg.height = 330;
         ptNum = PlayerVO.headArr.length;
         _loc2_ = 0;
         while(_loc2_ < ptNum)
         {
            _loc1_ = ELFMinImageManager.getElfM(GetElfFactor.getElfVO(PlayerVO.headArr[_loc2_]).imgName);
            _loc3_ = new SwfButton(_loc1_);
            _loc3_.name = PlayerVO.headArr[_loc2_];
            headBtnData.push({
               "label":"",
               "accessory":_loc3_
            });
            headBtnVec.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function removeHeadBtn() : void
      {
         var _loc2_:* = 0;
         var _loc1_:int = headBtnVec.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            headBtnVec[_loc2_].removeFromParent(true);
            _loc2_++;
         }
         headBtnVec = Vector.<SwfButton>([]);
      }
   }
}
