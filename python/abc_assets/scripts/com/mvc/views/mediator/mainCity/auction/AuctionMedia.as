package com.mvc.views.mediator.mainCity.auction
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.auction.AuctionUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.auction.AuctionPro;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import org.puremvc.as3.interfaces.INotification;
   import lzm.util.TimeUtil;
   import com.common.consts.ConfigConst;
   import com.mvc.views.uis.mainCity.auction.SimplePropUnitUI;
   import feathers.data.ListCollection;
   import com.common.util.DisposeDisplay;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class AuctionMedia extends Mediator
   {
      
      public static const NAME:String = "AuctionMedia";
      
      public static var isCall:Boolean = true;
       
      public var auction:AuctionUI;
      
      private var propUintVec:Vector.<DisplayObject>;
      
      public function AuctionMedia(param1:Object = null)
      {
         propUintVec = new Vector.<DisplayObject>([]);
         super("AuctionMedia",param1);
         auction = param1 as AuctionUI;
         auction.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(auction.btn_close !== _loc2_)
         {
            if(auction.btn_pid === _loc2_)
            {
               if(!auction._propVo)
               {
                  return Tips.show("拍卖时间未到");
               }
               if(auction.priceInput.text == "")
               {
                  return Tips.show("你还没有输入价格");
               }
               if(auction.priceInput.text > PlayerVO.diamond && auction._propVo.auctionType == 1)
               {
                  return Tips.show("钻石不足");
               }
               if(auction.priceInput.text > PlayerVO.silver && auction._propVo.auctionType == 2)
               {
                  return Tips.show("金币不足");
               }
               if(isCall)
               {
                  (facade.retrieveProxy("AuctionPro") as AuctionPro).write3202(auction.priceInput.text);
                  auction.priceInput.text = "";
               }
               else
               {
                  Tips.show("请等待下一轮竞价");
               }
            }
         }
         else
         {
            (facade.retrieveProxy("AuctionPro") as AuctionPro).write3203();
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_AUNTION_PROP !== _loc2_)
         {
            if(ConfigConst.SHOW_AUNTIONING_PROP !== _loc2_)
            {
               if(ConfigConst.SHOW_BID_UPDOWN !== _loc2_)
               {
                  if(ConfigConst.SHOW_AUCTION_UPDOWN === _loc2_)
                  {
                     auction.auctionLessTime.text = TimeUtil.convertStringToDate(AuctionPro.auctionLessTime,true);
                  }
               }
               else
               {
                  auction.bidLessTime.text = TimeUtil.convertStringToDate(AuctionPro.bidLessTime);
               }
            }
            else
            {
               auction.showInfo(param1.getBody() as Boolean);
            }
         }
         else
         {
            showAuctionProp(param1.getBody() as Boolean);
         }
      }
      
      private function showAuctionProp(param1:Boolean) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc3_:* = null;
         clean();
         var _loc2_:Array = [];
         if(param1)
         {
            _loc4_ = 1;
         }
         _loc8_ = _loc4_;
         while(_loc8_ < AuctionPro.auctionPropVec.length)
         {
            if(AuctionPro.auctionPropVec[_loc8_].auctionIndex < 25)
            {
               _loc5_ = 12;
               _loc7_ = AuctionPro.auctionPropVec[_loc8_].auctionIndex;
            }
            else
            {
               _loc5_ = 18;
               _loc7_ = AuctionPro.auctionPropVec[_loc8_].auctionIndex - 100;
            }
            _loc3_ = new SimplePropUnitUI(TimeUtil.convertStringToDate(300 * _loc7_,false,_loc5_));
            _loc3_.myPropVo = AuctionPro.auctionPropVec[_loc8_];
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            propUintVec.push(_loc3_);
            _loc8_++;
         }
         var _loc6_:ListCollection = new ListCollection(_loc2_);
         auction.propList.dataProvider = _loc6_;
      }
      
      private function clean() : void
      {
         if(auction.propList.dataProvider)
         {
            auction.propList.dataProvider.removeAll();
            auction.propList.dataProvider = null;
            DisposeDisplay.dispose(propUintVec);
            propUintVec = Vector.<DisplayObject>([]);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_AUNTION_PROP,ConfigConst.SHOW_BID_UPDOWN,ConfigConst.SHOW_AUNTIONING_PROP,ConfigConst.SHOW_AUCTION_UPDOWN];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         clean();
         facade.removeMediator("AuctionMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.auctionAssets);
      }
   }
}
