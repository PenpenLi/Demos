package com.mvc.views.uis.mainCity.shop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.display.Quad;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.data.ListCollection;
   import feathers.controls.List;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.layout.TiledColumnsLayout;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.core.Starling;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   
   public class SaleTrashyProp extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.shop.SaleTrashyProp;
       
      private var swf:Swf;
      
      private var spr_saleTrashyProp:SwfSprite;
      
      private var bg:Quad;
      
      private var btn_closeBtn:SwfButton;
      
      private var btn_sureBtn:SwfButton;
      
      private var tf_getMoney:TextField;
      
      private var goodsBtnData:ListCollection;
      
      private var goodsBtnList:List;
      
      private var goodsBtnVec:Vector.<Sprite>;
      
      private var getMoneyNum:int;
      
      public function SaleTrashyProp()
      {
         super();
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.shop.SaleTrashyProp
      {
         return instance || new com.mvc.views.uis.mainCity.shop.SaleTrashyProp();
      }
      
      private function init() : void
      {
         bg = new Quad(1136,640,0);
         bg.alpha = 0.7;
         addChild(bg);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_saleTrashyProp = swf.createSprite("spr_saleTrashyProp");
         spr_saleTrashyProp.x = 1136 - spr_saleTrashyProp.width >> 1;
         spr_saleTrashyProp.y = 640 - spr_saleTrashyProp.height >> 1;
         addChild(spr_saleTrashyProp);
         btn_closeBtn = spr_saleTrashyProp.getButton("btn_closeBtn");
         btn_sureBtn = spr_saleTrashyProp.getButton("btn_sureBtn");
         tf_getMoney = spr_saleTrashyProp.getTextField("tf_getMoney");
         createPropBtnList();
      }
      
      private function createPropBtnList() : void
      {
         goodsBtnData = new ListCollection();
         goodsBtnList = new List();
         goodsBtnList.x = 0;
         goodsBtnList.y = 148;
         goodsBtnList.width = 660;
         goodsBtnList.height = 285;
         goodsBtnList.isSelectable = false;
         goodsBtnList.itemRendererProperties.stateToSkinFunction = null;
         goodsBtnList.itemRendererProperties.padding = 0;
         goodsBtnList.dataProvider = goodsBtnData;
         goodsBtnList.scrollBarDisplayMode = "none";
         spr_saleTrashyProp.addChild(goodsBtnList);
         goodsBtnList.addEventListener("initialize",changeLay);
      }
      
      private function changeLay() : void
      {
         var _loc1_:TiledColumnsLayout = new TiledColumnsLayout();
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.horizontalGap = 0;
         _loc1_.verticalGap = 5;
         goodsBtnList.layout = _loc1_;
      }
      
      private function removeGoodsBtn() : void
      {
         var _loc1_:* = 0;
         if(!goodsBtnVec)
         {
            return;
         }
         var _loc2_:int = goodsBtnVec.length;
         _loc1_ = _loc2_ - 1;
         while(_loc1_ >= 0)
         {
            goodsBtnVec[_loc1_].removeFromParent(true);
            goodsBtnVec.splice(_loc1_,1);
            _loc1_--;
         }
         goodsBtnVec = null;
      }
      
      public function showWin() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc1_:* = null;
         removeGoodsBtn();
         goodsBtnVec = Vector.<Sprite>([]);
         getMoneyNum = 0;
         goodsBtnData.removeAll();
         var _loc2_:int = PlayerVO.trashyPropVec.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new DropPropUnitUI();
            _loc1_ = PlayerVO.trashyPropVec[_loc3_];
            _loc1_.rewardCount = _loc1_.count;
            _loc4_.myPropVo = _loc1_;
            var _loc5_:* = 0.9;
            _loc4_.scaleY = _loc5_;
            _loc4_.scaleX = _loc5_;
            goodsBtnData.push({
               "label":"",
               "accessory":_loc4_
            });
            goodsBtnVec.push(_loc4_);
            getMoneyNum = §§dup().getMoneyNum + _loc1_.price * _loc1_.count;
            _loc3_++;
         }
         tf_getMoney.text = getMoneyNum;
         (Starling.current.root as Game).addChild(this);
         this.addEventListener("triggered",triggeredHandler);
         bg.addEventListener("touch",touchHandler);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(bg);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            closeWin();
         }
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = 0;
         var _loc4_:* = param1.target;
         if(btn_closeBtn !== _loc4_)
         {
            if(btn_sureBtn === _loc4_)
            {
               _loc3_ = [];
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.trashyPropVec.length)
               {
                  _loc3_.push(PlayerVO.trashyPropVec[_loc2_].id);
                  _loc2_++;
               }
               (Facade.getInstance().retrieveProxy("ShopPro") as ShopPro).write3310(_loc3_);
            }
         }
         else
         {
            closeWin();
         }
      }
      
      public function closeWin() : void
      {
         if(getInstance().parent)
         {
            removeGoodsBtn();
            this.removeFromParent();
            this.removeEventListener("triggered",triggeredHandler);
            bg.removeEventListener("touch",touchHandler);
         }
      }
   }
}
