package com.mvc.views.uis.mainCity.scoreShop
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.data.ListCollection;
   import feathers.controls.List;
   import flash.utils.Timer;
   import feathers.layout.TiledColumnsLayout;
   import com.mvc.views.mediator.mainCity.scoreShop.ScoreShopMediator;
   import starling.display.Image;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import starling.display.DisplayObject;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.events.Event;
   import org.puremvc.as3.patterns.facade.Facade;
   import flash.events.TimerEvent;
   import lzm.util.TimeUtil;
   
   public class ScoreShopUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_pvpShop:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_shopRefresh:SwfButton;
      
      public var btn_shopLeftBtn:SwfButton;
      
      public var btn_shopRightBtn:SwfButton;
      
      public var tf_allFightDot:TextField;
      
      public var tf_refreshTip:TextField;
      
      public var tf_discount:TextField;
      
      public var tf_countDown:TextField;
      
      private var goodsBtnData:ListCollection;
      
      private var goodsBtnList:List;
      
      public var goodsBtnVec:Vector.<Sprite>;
      
      private var spr_scoreTittle:Sprite;
      
      public var spr_freeDesc:SwfSprite;
      
      public var btn_freeBtn:SwfButton;
      
      private var freeTimer:Timer;
      
      private var countDown:uint;
      
      private var tiledColumnsLayout:TiledColumnsLayout;
      
      public var spr_countDown:SwfSprite;
      
      private var tittleContainer:Sprite;
      
      public function ScoreShopUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = null;
         if(ScoreShopMediator.nowType == "MainCityMedia" || ScoreShopMediator.nowType == "ShopMedia")
         {
            _loc2_ = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture("common"));
            var _loc3_:* = 1.515;
            _loc2_.scaleY = _loc3_;
            _loc2_.scaleX = _loc3_;
            _loc2_.y = -328;
            addChild(_loc2_);
         }
         else
         {
            _loc1_ = new Quad(1136,640,0);
            _loc1_.alpha = 0;
            addChild(_loc1_);
         }
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("scoreShop");
         spr_pvpShop = swf.createSprite("spr_pvpShop");
         spr_pvpShop.x = (1136 - spr_pvpShop.width >> 1) - 10;
         spr_pvpShop.y = 640 - spr_pvpShop.height >> 1;
         addChild(spr_pvpShop);
         spr_countDown = spr_pvpShop.getSprite("countDownSpr");
         tf_allFightDot = spr_pvpShop.getChildByName("tf_allFightDot") as TextField;
         tf_allFightDot.fontName = "img_pvpShop";
         tf_refreshTip = spr_pvpShop.getChildByName("tf_refreshTip") as TextField;
         tf_refreshTip.text = "每天21:00自动刷新";
         tf_discount = spr_pvpShop.getChildByName("tf_discount") as TextField;
         tf_discount.text = "";
         tf_countDown = spr_countDown.getChildByName("tf_countDown") as TextField;
         btn_shopRefresh = spr_pvpShop.getChildByName("btn_shopRefresh") as SwfButton;
         btn_close = spr_pvpShop.getChildByName("btn_close") as SwfButton;
         btn_shopLeftBtn = spr_pvpShop.getChildByName("btn_shopLeftBtn") as SwfButton;
         btn_shopRightBtn = spr_pvpShop.getChildByName("btn_shopRightBtn") as SwfButton;
         createPropBtnList();
         this.addEventListener("touch",touchHandler);
         tittleContainer = new Sprite();
         spr_pvpShop.addChild(tittleContainer);
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(tittleContainer);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               LogUtil("目标" + (param1.target as DisplayObject).name);
               var _loc3_:* = (param1.target as DisplayObject).name;
               if("img_pvpNpc" !== _loc3_)
               {
                  if("img_kingNpc" !== _loc3_)
                  {
                     if("img_seriesNpc" !== _loc3_)
                     {
                        if("img_freeNpc" !== _loc3_)
                        {
                           if("img_playerNpc" === _loc3_)
                           {
                              ScoreShopNpcTips.getInstance().showNpcTips("一串光阴一串金，串金难买串光逼。",param1.target as DisplayObject);
                           }
                        }
                        else
                        {
                           ScoreShopNpcTips.getInstance().showNpcTips("看样子，我比较像个绅士。",param1.target as DisplayObject);
                        }
                     }
                     else
                     {
                        ScoreShopNpcTips.getInstance().showNpcTips("我讨厌别人摸我还不给钱。",param1.target as DisplayObject);
                     }
                  }
                  else
                  {
                     ScoreShopNpcTips.getInstance().showNpcTips("每次刷新要付俺一些积分，请叫我雷锋。",param1.target as DisplayObject);
                  }
               }
               else
               {
                  ScoreShopNpcTips.getInstance().showNpcTips("世界那么大，唯独这里风景最美",param1.target as DisplayObject);
               }
            }
         }
      }
      
      public function showGoods(param1:String, param2:Array) : void
      {
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = null;
         goodsBtnList.width = 895;
         goodsBtnList.height = 500;
         tiledColumnsLayout.verticalGap = -80;
         removeGoodsBtn();
         goodsBtnVec = Vector.<Sprite>([]);
         goodsBtnData.removeAll();
         _loc5_ = 0;
         while(_loc5_ < param2.length)
         {
            _loc3_ = new ScoreShopGoodsBtnUI(param1);
            _loc3_.btn_propUnit.name = _loc5_;
            if(param2[_loc5_].spirites)
            {
               _loc6_ = GetElfFactor.getElfVO(param2[_loc5_].spirites.spStaId,false);
               goodsBtnData.push({
                  "label":"",
                  "accessory":_loc3_,
                  "goodsVO":_loc6_,
                  "goodsId":param2[_loc5_].goodsId,
                  "num":param2[_loc5_].props.num,
                  "price":param2[_loc5_].props.price,
                  "discount":param2[_loc5_].props.discount,
                  "shopType":param1
               });
            }
            if(param2[_loc5_].props)
            {
               _loc3_.btn_propUnit.name = _loc5_;
               _loc4_ = GetPropFactor.getPropVO(param2[_loc5_].props.propStaId);
               _loc3_.propVO = _loc4_;
               _loc3_.setNumAndDot(param2[_loc5_].props.num,param2[_loc5_].props.price,param2[_loc5_].props.discount);
               goodsBtnData.push({
                  "label":"",
                  "accessory":_loc3_,
                  "goodsVO":_loc4_,
                  "goodsId":param2[_loc5_].goodsId,
                  "num":param2[_loc5_].props.num,
                  "price":param2[_loc5_].props.price,
                  "discount":param2[_loc5_].props.discount,
                  "shopType":param1
               });
            }
            if(param2[_loc5_].isSell)
            {
               _loc3_.addMask();
            }
            goodsBtnVec.push(_loc3_);
            _loc3_.addEventListener("triggered",propBtn_triggeredHandler);
            _loc5_++;
         }
      }
      
      public function showFreeGoods(param1:String, param2:Array) : void
      {
         var _loc4_:* = 0;
         var _loc6_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         goodsBtnList.width = 895;
         goodsBtnList.height = 500;
         tiledColumnsLayout.verticalGap = -130;
         removeGoodsBtn();
         goodsBtnVec = Vector.<Sprite>([]);
         goodsBtnData.removeAll();
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc6_ = new FreeShopGoodsBtn();
            _loc6_.btn_freePropUnit.name = _loc4_;
            if(param2[_loc4_].spirites)
            {
               _loc5_ = GetElfFactor.getElfVO(param2[_loc4_].spirites.spStaId,false);
               goodsBtnData.push({
                  "label":"",
                  "accessory":_loc6_,
                  "goodsVO":_loc5_,
                  "goodsId":param2[_loc4_].goodsId,
                  "num":param2[_loc4_].props.num,
                  "price":param2[_loc4_].props.price,
                  "discount":param2[_loc4_].props.discount,
                  "shopType":param1
               });
            }
            if(param2[_loc4_].props)
            {
               _loc6_.btn_freePropUnit.name = _loc4_;
               _loc3_ = GetPropFactor.getPropVO(param2[_loc4_].props.propStaId);
               _loc6_.propVO = _loc3_;
               _loc6_.setNumAndDot(param2[_loc4_].props.num,param2[_loc4_].props.price,param2[_loc4_].props.discount);
               goodsBtnData.push({
                  "label":"",
                  "accessory":_loc6_,
                  "goodsVO":_loc3_,
                  "goodsId":param2[_loc4_].goodsId,
                  "num":param2[_loc4_].props.num,
                  "price":param2[_loc4_].props.price,
                  "discount":param2[_loc4_].props.discount,
                  "shopType":param1
               });
            }
            if(param2[_loc4_].isSell)
            {
               _loc6_.addMask();
            }
            goodsBtnVec.push(_loc6_);
            _loc6_.addEventListener("triggered",propBtn_triggeredHandler);
            _loc4_++;
         }
      }
      
      private function propBtn_triggeredHandler(param1:Event) : void
      {
         if(goodsBtnList.isScrolling)
         {
            return;
         }
         var _loc2_:int = (param1.target as SwfButton).name;
         ScoreShopMediator.selectedGoodsIndex = _loc2_;
         if(goodsBtnData.getItemAt(_loc2_).goodsVO is PropVO)
         {
            Facade.getInstance().sendNotification("switch_win",null,"load_score_goods");
            Facade.getInstance().sendNotification("send_score_goods_info",goodsBtnData.getItemAt(_loc2_));
         }
      }
      
      private function createPropBtnList() : void
      {
         goodsBtnData = new ListCollection();
         goodsBtnList = new List();
         goodsBtnList.x = 95;
         goodsBtnList.y = 150;
         goodsBtnList.width = 895;
         goodsBtnList.height = 500;
         goodsBtnList.isSelectable = false;
         goodsBtnList.itemRendererProperties.stateToSkinFunction = null;
         goodsBtnList.itemRendererProperties.padding = 0;
         goodsBtnList.dataProvider = goodsBtnData;
         goodsBtnList.scrollBarDisplayMode = "none";
         spr_pvpShop.addChild(goodsBtnList);
         goodsBtnList.addEventListener("initialize",changeLay);
      }
      
      private function changeLay() : void
      {
         tiledColumnsLayout = new TiledColumnsLayout();
         tiledColumnsLayout.paging = "horizontal";
         tiledColumnsLayout.horizontalGap = 15;
         tiledColumnsLayout.verticalGap = -80;
         goodsBtnList.layout = tiledColumnsLayout;
      }
      
      public function removeGoodsBtn() : void
      {
         var _loc1_:* = 0;
         if(!goodsBtnVec)
         {
            return;
         }
         var _loc2_:int = goodsBtnVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            goodsBtnVec[_loc1_].removeFromParent(true);
            _loc1_++;
         }
         goodsBtnVec = Vector.<Sprite>([]);
         goodsBtnVec = null;
      }
      
      public function addShopTittle(param1:String) : void
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         tittleContainer.removeChildren(0,-1,true);
         var _loc7_:* = param1;
         if("PVPBgMediator" !== _loc7_)
         {
            if("KingKwanMedia" !== _loc7_)
            {
               if("ElfSeriesMedia" !== _loc7_)
               {
                  if("MainCityMedia" !== _loc7_)
                  {
                     if("ShopMedia" === _loc7_)
                     {
                        spr_scoreTittle = swf.createSprite("spr_playerTittle");
                        _loc3_ = spr_scoreTittle.getChildByName("img_playerNpc") as Image;
                     }
                  }
                  else
                  {
                     spr_scoreTittle = swf.createSprite("spr_freeTittle");
                     _loc2_ = spr_scoreTittle.getChildByName("img_freeNpc") as Image;
                  }
               }
               else
               {
                  spr_scoreTittle = swf.createSprite("spr_seriesTittle");
                  _loc4_ = spr_scoreTittle.getChildByName("img_seriesNpc") as Image;
               }
            }
            else
            {
               spr_scoreTittle = swf.createSprite("spr_kingTittle");
               _loc6_ = spr_scoreTittle.getChildByName("img_kingNpc") as Image;
            }
         }
         else
         {
            spr_scoreTittle = swf.createSprite("spr_pvpTittle");
            _loc5_ = spr_scoreTittle.getChildByName("img_pvpNpc") as Image;
         }
         tittleContainer.addChild(spr_scoreTittle);
      }
      
      public function createFreeDescSpr() : void
      {
         if(!spr_freeDesc)
         {
            spr_freeDesc = swf.createSprite("spr_freeDesc");
         }
         btn_freeBtn = spr_freeDesc.getButton("btn_freeBtn");
         spr_pvpShop.addChild(spr_freeDesc);
      }
      
      public function startFreeTimer(param1:uint) : void
      {
         countDown = param1;
         if(countDown > 0 && !freeTimer)
         {
            freeTimer = new Timer(1000);
            freeTimer.addEventListener("timer",freeTimer_timerHandler);
            freeTimer.start();
            LogUtil("积分商店的计时器开启");
         }
         else
         {
            tf_countDown.text = "下次刷新：00:00:00";
         }
      }
      
      protected function freeTimer_timerHandler(param1:TimerEvent) : void
      {
         countDown = countDown - 1;
         tf_countDown.text = "下次刷新：" + TimeUtil.convertStringToDate(countDown);
         if(countDown <= 0)
         {
            stopFreeTimer();
         }
      }
      
      public function stopFreeTimer() : void
      {
         if(!freeTimer)
         {
            return;
         }
         freeTimer.removeEventListener("timer",freeTimer_timerHandler);
         freeTimer.stop();
         freeTimer = null;
         return;
         §§push(LogUtil("积分商店的计时器关闭"));
      }
   }
}
