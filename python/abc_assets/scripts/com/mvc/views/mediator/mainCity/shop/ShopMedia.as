package com.mvc.views.mediator.mainCity.shop
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.shop.ShopUI;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.themes.Tips;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.SomeFontHandler;
   import com.common.util.strHandler.StrHandle;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.shop.ShopPro;
   import starling.text.TextField;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import feathers.controls.TabBar;
   import starling.core.Starling;
   
   public class ShopMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "ShopMedia";
       
      private var shop:ShopUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var sellIndex:int;
      
      private var buyIndex:int;
      
      public function ShopMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("ShopMedia",param1);
         shop = param1 as ShopUI;
         shop.addEventListener("triggered",clickHandler);
         shop.tabs.addEventListener("change",tabs_changeHandler);
         shop.btn_shopBuy.addEventListener("triggered",buyclickHandler);
         shop.btn_shopSell.addEventListener("triggered",sellclickHandler);
         switchBtn(false);
      }
      
      private function sellclickHandler() : void
      {
         if(BackPackPro.salePropVec.length == 0)
         {
            Tips.show("没有道具可以出售");
            return;
         }
         shop.swtich(false);
         initSellGoodsList();
         switchBtn(true);
      }
      
      private function buyclickHandler() : void
      {
         shop.swtich(true);
         switchBuyGoods(0);
         switchBtn(false);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(shop.btn_mainClose === _loc2_)
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SHOP_LIST" !== _loc2_)
         {
            if("SHOW_SALE_LIST" !== _loc2_)
            {
               if("UPDATA_SELL_LIST" !== _loc2_)
               {
                  if("update_list_after_buy_diamond_goods" === _loc2_)
                  {
                     switchBuyGoods(3);
                     shop.buyGoodsList.scrollToDisplayIndex(buyIndex);
                  }
               }
               else if(shop.sellGoodsList.dataProvider)
               {
                  shop.sellGoodsList.scrollToDisplayIndex(sellIndex);
               }
            }
            else
            {
               initSellGoodsList();
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SHOP_LIST","SHOW_SALE_LIST","UPDATA_SELL_LIST","update_list_after_buy_diamond_goods"];
      }
      
      private function initSellGoodsList() : void
      {
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc1_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < BackPackPro.salePropVec.length)
         {
            if(BackPackPro.salePropVec[_loc7_].count == 0)
            {
               BackPackPro.salePropVec.splice(_loc7_,1);
            }
            else
            {
               _loc2_ = shop.getBtn("btn_sell_b");
               _loc2_.name = _loc7_.toString();
               _loc3_ = new Sprite();
               _loc5_ = GetpropImage.getPropSpr(BackPackPro.salePropVec[_loc7_],false);
               _loc3_.addChild(_loc5_);
               _loc4_ = SomeFontHandler.setColoeSize(BackPackPro.salePropVec[_loc7_].name,30,6);
               _loc1_.push({
                  "icon":_loc3_,
                  "label":_loc4_ + "\n价格: " + BackPackPro.salePropVec[_loc7_].price / 2 + "        数量: " + BackPackPro.salePropVec[_loc7_].count + "  \n" + StrHandle.lineFeed(BackPackPro.salePropVec[_loc7_].describe,20,"\n",19),
                  "accessory":_loc2_
               });
               _loc2_.addEventListener("triggered",sellGoodsSure);
               displayVec.push(_loc3_);
               displayVec.push(_loc2_);
            }
            _loc7_++;
         }
         var _loc6_:ListCollection = new ListCollection(_loc1_);
         shop.sellGoodsList.dataProvider = _loc6_;
      }
      
      public function switchBuyGoods(param1:int) : void
      {
         var _loc9_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc11_:* = 0;
         var _loc12_:* = null;
         var _loc16_:* = null;
         var _loc20_:* = null;
         var _loc13_:* = 0;
         var _loc22_:* = null;
         var _loc18_:* = null;
         var _loc19_:* = null;
         var _loc17_:* = 0;
         var _loc3_:* = null;
         var _loc21_:* = null;
         var _loc6_:* = null;
         var _loc10_:* = null;
         var _loc14_:* = null;
         var _loc15_:* = null;
         var _loc2_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         loop4:
         switch(param1)
         {
            case 0:
               _loc9_ = 0;
               while(_loc9_ < ShopPro.medicineVec.length)
               {
                  _loc4_ = shop.getBtn("btn_buy_b");
                  _loc4_.name = "药品" + _loc9_;
                  _loc7_ = GetpropImage.getPropSpr(ShopPro.medicineVec[_loc9_],false);
                  _loc5_ = SomeFontHandler.setColoeSize(ShopPro.medicineVec[_loc9_].name,35,9);
                  _loc2_.push({
                     "icon":_loc7_,
                     "label":_loc5_ + "金币:" + ShopPro.medicineVec[_loc9_].price + "\n" + ShopPro.medicineVec[_loc9_].describe,
                     "accessory":_loc4_
                  });
                  _loc4_.addEventListener("triggered",buyGoodsSure);
                  displayVec.push(_loc7_);
                  displayVec.push(_loc4_);
                  _loc9_++;
               }
               break;
            case 1:
               _loc11_ = 0;
               while(_loc11_ < ShopPro.elfBallVec.length)
               {
                  _loc12_ = shop.getBtn("btn_buy_b");
                  _loc12_.name = "灵球" + _loc11_;
                  _loc16_ = GetpropImage.getPropSpr(ShopPro.elfBallVec[_loc11_],false);
                  _loc20_ = SomeFontHandler.setColoeSize(ShopPro.elfBallVec[_loc11_].name,35,9);
                  _loc2_.push({
                     "icon":_loc16_,
                     "label":_loc20_ + "金币:" + ShopPro.elfBallVec[_loc11_].price + "\n" + ShopPro.elfBallVec[_loc11_].describe,
                     "accessory":_loc12_
                  });
                  _loc12_.addEventListener("triggered",buyGoodsSure);
                  displayVec.push(_loc16_);
                  displayVec.push(_loc12_);
                  _loc11_++;
               }
               break;
            case 2:
               _loc13_ = 0;
               while(_loc13_ < ShopPro.otherPropVec.length)
               {
                  _loc22_ = shop.getBtn("btn_buy_b");
                  _loc22_.name = "其他" + _loc13_;
                  _loc18_ = GetpropImage.getPropSpr(ShopPro.otherPropVec[_loc13_],false);
                  _loc19_ = SomeFontHandler.setColoeSize(ShopPro.otherPropVec[_loc13_].name,35,9);
                  _loc2_.push({
                     "icon":_loc18_,
                     "label":_loc19_ + "金币:" + ShopPro.otherPropVec[_loc13_].price + "\n" + StrHandle.lineFeed(ShopPro.otherPropVec[_loc13_].describe,20,"\n",23),
                     "accessory":_loc22_
                  });
                  _loc22_.addEventListener("triggered",buyGoodsSure);
                  displayVec.push(_loc18_);
                  displayVec.push(_loc22_);
                  _loc13_++;
               }
               break;
            case 3:
               _loc17_ = 0;
               while(true)
               {
                  if(_loc17_ >= ShopPro.diamondPropVec.length)
                  {
                     break loop4;
                  }
                  if(ShopPro.diamondPropVec[_loc17_].isDiamondSale)
                  {
                     _loc3_ = new Sprite();
                     if(ShopPro.diamondPropVec[_loc17_].dayBuyCount > -1)
                     {
                        _loc21_ = new TextField(100,20,"","FZCuYuan-M03S",16,153760);
                        _loc21_.autoScale = true;
                        if(PlayerVO.vipRank < ShopPro.diamondPropVec[_loc17_].vipLimitBuyInfoArr[0])
                        {
                           _loc21_.fontSize = 18;
                           _loc21_.height = 50;
                           _loc21_.text = "购买需要\nVIP" + ShopPro.diamondPropVec[_loc17_].vipLimitBuyInfoArr[0];
                           _loc3_.addChild(_loc21_);
                        }
                        else
                        {
                           _loc6_ = shop.getBtn("btn_buy2_b");
                           _loc6_.name = "钻石" + _loc17_;
                           _loc6_.addEventListener("triggered",buyGoodsSure);
                           _loc21_.text = "今日可购买" + ShopPro.diamondPropVec[_loc17_].dayBuyCount;
                           _loc21_.x = _loc6_.x;
                           _loc21_.y = _loc6_.y + _loc6_.height + 2;
                           _loc3_.addChild(_loc6_);
                           _loc3_.addChild(_loc21_);
                        }
                     }
                     else
                     {
                        _loc10_ = shop.getBtn("btn_buy_b");
                        _loc10_.name = "钻石" + _loc17_;
                        _loc10_.addEventListener("triggered",buyGoodsSure);
                        _loc3_.addChild(_loc10_);
                     }
                     _loc14_ = GetpropImage.getPropSpr(ShopPro.diamondPropVec[_loc17_],false);
                     _loc15_ = SomeFontHandler.setColoeSize(ShopPro.diamondPropVec[_loc17_].name,35,9);
                     _loc2_.push({
                        "icon":_loc14_,
                        "label":_loc15_ + "钻石:" + ShopPro.diamondPropVec[_loc17_].diamond + "\n" + StrHandle.lineFeed(ShopPro.diamondPropVec[_loc17_].describe,24,"\n",19),
                        "accessory":_loc3_
                     });
                     displayVec.push(_loc14_);
                     displayVec.push(_loc3_);
                  }
                  _loc17_++;
               }
               break;
         }
         var _loc8_:ListCollection = new ListCollection(_loc2_);
         shop.buyGoodsList.dataProvider = _loc8_;
         shop.buyGoodsList.stopScrolling();
         if(shop.buyGoodsList.dataProvider)
         {
            shop.buyGoodsList.scrollToDisplayIndex(0);
         }
         shop.tabs.selectedIndex = param1;
      }
      
      private function buyGoodsSure(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:String = (param1.target as SwfButton).name.substr(0,2);
         buyIndex = (param1.target as SwfButton).name.substring(2);
         var _loc4_:* = _loc3_;
         if("药品" !== _loc4_)
         {
            if("灵球" !== _loc4_)
            {
               if("其他" !== _loc4_)
               {
                  if("钻石" === _loc4_)
                  {
                     _loc2_ = ShopPro.diamondPropVec[buyIndex];
                     BuySureMedia.type = 2;
                     if(_loc2_.dayBuyCount == 0)
                     {
                        Tips.show("亲，该商品今天购买次数已用完。");
                        return;
                     }
                  }
               }
               else
               {
                  _loc2_ = ShopPro.otherPropVec[buyIndex];
                  BuySureMedia.type = 1;
               }
            }
            else
            {
               _loc2_ = ShopPro.elfBallVec[buyIndex];
               BuySureMedia.type = 1;
            }
         }
         else
         {
            _loc2_ = ShopPro.medicineVec[buyIndex];
            BuySureMedia.type = 1;
         }
         LogUtil(_loc3_,buyIndex,_loc2_.name,_loc2_.id);
         sendNotification("switch_win",null,"LOAD_BUYSURE_WIN");
         (facade.retrieveMediator("BuySureMedia") as BuySureMedia).buySure.myPropVo = _loc2_;
      }
      
      private function sellGoodsSure(param1:Event) : void
      {
         sellIndex = (param1.target as SwfButton).name;
         BuySureMedia.type = 3;
         sendNotification("switch_win",null,"LOAD_BUYSURE_WIN");
         (facade.retrieveMediator("BuySureMedia") as BuySureMedia).buySure.myPropVo = BackPackPro.salePropVec[sellIndex];
      }
      
      private function switchBtn(param1:Boolean) : void
      {
         shop.btn_shopSell.isEnabled = !param1;
         shop.btn_shopBuy.isEnabled = param1;
      }
      
      private function tabs_changeHandler(param1:Event) : void
      {
         var _loc2_:TabBar = TabBar(param1.currentTarget);
         switchBuyGoods(_loc2_.selectedIndex);
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         shop.removeEventListener("triggered",clickHandler);
         shop.tabs.removeEventListener("change",tabs_changeHandler);
         shop.btn_shopBuy.removeEventListener("triggered",buyclickHandler);
         shop.btn_shopSell.removeEventListener("triggered",sellclickHandler);
         Starling.juggler.removeTweens(shop.prompt);
         shop.mc_clerk.stop();
         shop.mc_clerk.removeFromParent(true);
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("ShopMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
