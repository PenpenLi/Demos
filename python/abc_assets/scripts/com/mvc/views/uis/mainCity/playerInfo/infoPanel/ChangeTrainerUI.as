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
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Quad;
   import feathers.layout.TiledRowsLayout;
   
   public class ChangeTrainerUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var changeTrainerSpr:SwfSprite;
      
      public var headCloseBtn:Button;
      
      public var trainerBtnList:List;
      
      public var trainerBtnData:ListCollection;
      
      public var headPanelBg:Scale9Image;
      
      public var headBtnVec:Vector.<SwfButton>;
      
      public function ChangeTrainerUI()
      {
         headBtnVec = new Vector.<SwfButton>();
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("personalInfo");
         changeTrainerSpr = swf.createSprite("spr_replace_trainerPanel");
         changeTrainerSpr.x = 1136 - changeTrainerSpr.width >> 1;
         changeTrainerSpr.y = 640 - changeTrainerSpr.height >> 1;
         addChild(changeTrainerSpr);
         headCloseBtn = changeTrainerSpr.getButton("headCloseBtn");
         createBtnContainer();
         addTrainerBtn(PlayerVO.sex);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChildAt(_loc1_,0);
      }
      
      private function createBtnContainer() : void
      {
         trainerBtnData = new ListCollection();
         trainerBtnList = new List();
         trainerBtnList.x = 10;
         trainerBtnList.y = 68;
         trainerBtnList.height = 120;
         trainerBtnList.width = 440;
         trainerBtnList.isSelectable = false;
         trainerBtnList.itemRendererProperties.stateToSkinFunction = null;
         trainerBtnList.itemRendererProperties.padding = 0;
         trainerBtnList.dataProvider = trainerBtnData;
         trainerBtnList.scrollBarDisplayMode = "none";
         changeTrainerSpr.addChild(trainerBtnList);
         trainerBtnList.addEventListener("initialize",changeLay);
      }
      
      private function changeLay() : void
      {
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalGap = 8;
         _loc1_.verticalGap = 5;
         trainerBtnList.layout = _loc1_;
      }
      
      public function addTrainerBtn(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc3_:* = 0;
         if(param1)
         {
            _loc5_ = 1;
            while(_loc5_ <= 3)
            {
               _loc2_ = "btn_formHeadPic" + _loc5_;
               _loc4_ = swf.createButton(_loc2_);
               _loc4_.name = _loc5_ + 100000;
               LogUtil("headpicbtn.name: " + _loc4_.name);
               trainerBtnData.push({
                  "label":"",
                  "accessory":_loc4_
               });
               _loc5_++;
            }
         }
         else
         {
            _loc6_ = 4;
            while(_loc6_ <= 6)
            {
               _loc2_ = "btn_formHeadPic" + _loc6_;
               _loc4_ = swf.createButton(_loc2_);
               _loc4_.name = _loc6_ + 100000;
               LogUtil("headpicbtn.name: " + _loc4_.name);
               trainerBtnData.push({
                  "label":"",
                  "accessory":_loc4_
               });
               _loc6_++;
            }
         }
      }
   }
}
