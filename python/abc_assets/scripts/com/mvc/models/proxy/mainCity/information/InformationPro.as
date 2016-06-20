package com.mvc.models.proxy.mainCity.information
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.mainCity.information.MailVO;
   import com.common.util.GetCommon;
   import com.common.net.Client;
   import com.common.util.strHandler.StrHandle;
   import com.mvc.views.mediator.mainCity.information.MailMedia;
   import com.common.util.RewardHandle;
   import com.common.themes.Tips;
   import lzm.util.LSOManager;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class InformationPro extends Proxy
   {
      
      public static const NAME:String = "InformationPro";
      
      public static var mailVec:Vector.<MailVO> = new Vector.<MailVO>([]);
       
      private var client:Client;
      
      public var actArray:Array;
      
      public var noticeArray:Array;
      
      private var _index:int;
      
      public function InformationPro(param1:Object = null)
      {
         super("InformationPro",param1);
         client = Client.getInstance();
         client.addCallObj("note4200",this);
         client.addCallObj("note4201",this);
         client.addCallObj("note4202",this);
         client.addCallObj("note4203",this);
         client.addCallObj("note4204",this);
         client.addCallObj("note4205",this);
         client.addCallObj("note4207",this);
         client.addCallObj("note4300",this);
         client.addCallObj("note4301",this);
      }
      
      public static function isGetMail() : Boolean
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < mailVec.length)
         {
            if(GetCommon.isNullObject(mailVec[_loc1_].reward))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function write4200() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4200;
         client.sendBytes(_loc1_);
      }
      
      public function note4200(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         LogUtil("4200=" + JSON.stringify(param1));
         mailVec = Vector.<MailVO>([]);
         if(param1.result)
         {
            _loc2_ = param1.mailList;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = new MailVO();
               if(!(_loc2_[_loc4_].reward == null && _loc2_[_loc4_].staMId == 10002))
               {
                  _loc3_.actEndTime = _loc2_[_loc4_].actEndTime;
                  _loc3_.actStartTime = _loc2_[_loc4_].actStartTime;
                  _loc3_.getTime = StrHandle.getTime(_loc2_[_loc4_].getTime);
                  _loc3_.mainId = _loc2_[_loc4_].id;
                  _loc3_.isGet = _loc2_[_loc4_].isGet;
                  _loc3_.isRead = _loc2_[_loc4_].isRead;
                  _loc3_.staMId = _loc2_[_loc4_].staMId;
                  if(_loc2_[_loc4_].reward)
                  {
                     _loc3_.reward = _loc2_[_loc4_].reward;
                  }
                  else
                  {
                     _loc3_.reward = null;
                  }
                  if(_loc2_[_loc4_].isSpec)
                  {
                     addMail(_loc3_,_loc2_[_loc4_].desc);
                  }
                  else
                  {
                     _loc3_.desc = _loc2_[_loc4_].desc.replace(new RegExp("\\r","g"),"");
                     _loc3_.sender = _loc2_[_loc4_].sender;
                     _loc3_.title = _loc2_[_loc4_].title;
                  }
                  mailVec.push(_loc3_);
               }
               _loc4_++;
            }
            if(mailVec.length != 0 && !MailMedia.isNew)
            {
               sendNotification("TIP_GET_MAIL",true);
            }
            if(MailMedia.isNew && !GetCommon.isIOSDied())
            {
               MailMedia.isNew = false;
               sendNotification("SHOW_MAIL");
            }
         }
      }
      
      public function write4201(param1:int, param2:int) : void
      {
         LogUtil("write4201== ",param1);
         _index = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 4201;
         _loc3_.mainId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note4201(param1:Object) : void
      {
         LogUtil("4201=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            RewardHandle.Reward(param1.data.reward,1);
            sendNotification("SEND_DEL_MAIL");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write4202(param1:int, param2:int) : void
      {
         _index = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 4202;
         _loc3_.mainId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note4202(param1:Object) : void
      {
         LogUtil("4202=" + JSON.stringify(param1));
         if(param1.result)
         {
            var _loc2_:* = param1.result;
            if(1 !== _loc2_)
            {
               if(0 !== _loc2_)
               {
                  if(2 === _loc2_)
                  {
                     Tips.show("服务器故障");
                  }
               }
               else
               {
                  Tips.show("找不到邮件");
               }
            }
            else
            {
               Tips.show("删除成功");
               LogUtil(_index + "_index");
               sendNotification("SEND_DEL_MAIL",_index);
            }
         }
      }
      
      public function write4203() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4203;
         client.sendBytes(_loc1_,false);
      }
      
      public function note4203(param1:Object) : void
      {
         LogUtil("4203=" + JSON.stringify(param1));
         if(param1.result)
         {
            Game.activityHttp = param1.gameNotice;
         }
      }
      
      public function write4204() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4204;
         client.sendBytes(_loc1_,false);
      }
      
      public function note4204(param1:Object) : void
      {
         LogUtil("4204=" + JSON.stringify(param1));
         if(param1.result)
         {
            Game.noticeHttp = param1.gameNotice;
         }
      }
      
      public function write4205(param1:String, param2:String, param3:int, param4:String) : void
      {
         LogUtil(param1,param2,param3,param4);
         var _loc5_:Object = {};
         _loc5_.msgId = 4205;
         _loc5_.sex = param1;
         _loc5_.age = param2;
         _loc5_.type = param3 + 1;
         _loc5_.str = param4;
         client.sendBytes(_loc5_);
      }
      
      public function note4205(param1:Object) : void
      {
         LogUtil("4205=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("提交成功");
            if((param1.data as Object).hasOwnProperty("diamond"))
            {
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            if((param1.data as Object).hasOwnProperty("money"))
            {
               sendNotification("update_play_money_info",param1.data.money);
            }
            if((param1.data as Object).hasOwnProperty("actionForce"))
            {
               sendNotification("update_play_power_info",param1.data.actionForce);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write4207() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4207;
         client.sendBytes(_loc1_);
      }
      
      public function note4207(param1:Object) : void
      {
         LogUtil("4207=" + JSON.stringify(param1));
         if(param1.status != "success")
         {
            if(param1.status == "fail")
            {
               LogUtil(param1.data.msg);
            }
         }
      }
      
      public function write4300() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 4300;
         client.sendBytes(_loc1_);
      }
      
      public function note4300(param1:Object) : void
      {
         LogUtil("4300=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.giftName)
            {
               sendNotification("SEND_GIFT",param1.data.giftName);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write4301(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 4301;
         _loc2_.giftCode = param1;
         _loc2_.serverName = LSOManager.get("SERVERNAME");
         client.sendBytes(_loc2_);
      }
      
      public function note4301(param1:Object) : void
      {
         LogUtil("4301=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("领取成功");
            if(param1.data.rewareStr)
            {
               RewardHandle.Reward(param1.data.rewareStr,1);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      private function addMail(param1:MailVO, param2:String) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         LogUtil("补充邮件内容=== ",param2);
         if(param2)
         {
            _loc4_ = JSON.parse(param2);
         }
         var _loc5_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_specialMails");
         var _loc8_:* = 0;
         var _loc7_:* = _loc5_.sta_specialMails;
         for each(var _loc6_ in _loc5_.sta_specialMails)
         {
            LogUtil(_loc6_.@id,param1.staMId);
            if(_loc6_.@id == param1.staMId)
            {
               param1.title = _loc6_.@title;
               _loc3_ = _loc6_.@desc;
               if(param2)
               {
                  if(_loc4_.X)
                  {
                     _loc3_ = _loc3_.replace("X",_loc4_.X);
                  }
                  if(_loc4_.Y)
                  {
                     _loc3_ = _loc3_.replace("Y",_loc4_.Y);
                  }
               }
               LogUtil(_loc3_);
               param1.desc = _loc3_;
               param1.sender = _loc6_.@sender;
               break;
            }
         }
      }
   }
}
