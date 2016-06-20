package com.mvc.models.proxy.mainCity.auction
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.net.Client;
   import com.common.util.GetCommon;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mainCity.auction.AuctionMedia;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.common.consts.ConfigConst;
   
   public class AuctionPro extends Proxy
   {
      
      public static const NAME:String = "AuctionPro";
      
      public static var session:int;
      
      public static var auctionLessTime:int;
      
      public static var bidLessTime:int;
      
      public static var auctionPropVec:Vector.<PropVO> = new Vector.<PropVO>([]);
      
      public static var maxPrice:int;
      
      public static var playerName:String;
      
      public static var isOPen:Boolean = true;
       
      private var client:Client;
      
      private var _bidUpdate:Boolean = true;
      
      public function AuctionPro(param1:Object = null)
      {
         super("AuctionPro",param1);
         client = Client.getInstance();
         client.addCallObj("note3201",this);
         client.addCallObj("note3202",this);
         client.addCallObj("note3203",this);
      }
      
      public function write3201() : void
      {
         _bidUpdate = false;
         var _loc1_:Object = {};
         _loc1_.msgId = 3201;
         client.sendBytes(_loc1_);
      }
      
      public function note3201(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("3201=" + JSON.stringify(param1));
         var _loc6_:* = param1.status;
         if("success" !== _loc6_)
         {
            if("fail" !== _loc6_)
            {
               if("error" === _loc6_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            isOPen = param1.data.isOpen;
            if(!param1.data.isOpen && facade.hasMediator("AuctionMedia") && !GetCommon.isIOSDied())
            {
               Alert.show(param1.data.msg,"温馨提示",new ListCollection([{"label":"确定"}]));
            }
            if(_bidUpdate)
            {
               AuctionMedia.isCall = true;
            }
            session = param1.data.index;
            if(param1.data.time)
            {
               bidLessTime = param1.data.time.time1;
               auctionLessTime = param1.data.time.time2;
            }
            else
            {
               bidLessTime = 0;
               auctionLessTime = 0;
            }
            maxPrice = param1.data.maxPrice;
            playerName = param1.data.playerName;
            if(param1.data.result)
            {
               if(param1.data.result.playerName)
               {
                  playerName = param1.data.result.playerName;
               }
               if(param1.data.result.prop)
               {
                  _loc2_ = GetPropFactor.getPropVO(param1.data.result.prop.pId);
                  if(playerName != PlayerVO.nickName)
                  {
                     if(param1.data.result.diamond != 0)
                     {
                        Tips.show("恭喜玩家【" + playerName + "】花了" + param1.data.result.diamond + "钻石，获得" + param1.data.result.prop.num + "个" + _loc2_.name);
                     }
                     if(param1.data.result.silver != 0)
                     {
                        Tips.show("恭喜玩家【" + playerName + "】花了" + param1.data.result.silver + "金币，获得" + param1.data.result.prop.num + "个" + _loc2_.name);
                     }
                  }
                  playerName = "";
               }
               if(param1.data.result.userId == PlayerVO.userId)
               {
                  if(param1.data.result.diamond != 0)
                  {
                     sendNotification("update_play_diamond_info",PlayerVO.diamond - param1.data.result.diamond);
                  }
                  if(param1.data.result.silver != 0)
                  {
                     sendNotification("update_play_money_info",PlayerVO.silver - param1.data.result.silver);
                  }
               }
            }
            if(param1.data.back)
            {
               if(param1.data.back.userId == PlayerVO.userId)
               {
                  if(param1.data.back.diamond != 0)
                  {
                     sendNotification("update_play_diamond_info",PlayerVO.diamond + param1.data.back.diamond);
                  }
                  if(param1.data.back.silver != 0)
                  {
                     sendNotification("update_play_money_info",PlayerVO.silver + param1.data.back.silver);
                  }
               }
            }
            auctionPropVec = Vector.<PropVO>([]);
            _loc5_ = param1.data.props;
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_ = GetPropFactor.getPropVO(_loc5_[_loc4_].pId);
               _loc3_.auctionNum = _loc5_[_loc4_].num;
               _loc3_.auctionType = _loc5_[_loc4_].flag;
               _loc3_.auctionIndex = _loc5_[_loc4_].index;
               auctionPropVec.push(_loc3_);
               _loc4_++;
            }
            sendNotification(ConfigConst.SHOW_BID_UPDOWN);
            sendNotification(ConfigConst.SHOW_AUCTION_UPDOWN);
            sendNotification(ConfigConst.SHOW_AUNTIONING_PROP,param1.data.isOpen);
            sendNotification(ConfigConst.SHOW_AUNTION_PROP,param1.data.isOpen);
            _bidUpdate = true;
         }
      }
      
      public function write3202(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3202;
         _loc2_.price = param1;
         _loc2_.session = session;
         client.sendBytes(_loc2_);
      }
      
      public function note3202(param1:Object) : void
      {
         LogUtil("3202=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("您的价格已提交，请等待结果");
            AuctionMedia.isCall = false;
         }
      }
      
      public function write3203() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3203;
         client.sendBytes(_loc1_);
      }
      
      public function note3203(param1:Object) : void
      {
         LogUtil("3203=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
      }
   }
}
