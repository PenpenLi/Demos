package com.mvc.models.proxy.mainCity.playerInfo
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import com.massage.ane.UmengExtension;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   
   public class PlayInfoPro extends Proxy
   {
      
      public static const NAME:String = "PlayInfoPro";
       
      private var client:Client;
      
      public function PlayInfoPro(param1:Object = null)
      {
         super("PlayInfoPro",param1);
         client = Client.getInstance();
         client.addCallObj("note1101",this);
         client.addCallObj("note1102",this);
         client.addCallObj("note1103",this);
         client.addCallObj("note1104",this);
         client.addCallObj("note1106",this);
         client.addCallObj("note1108",this);
         client.addCallObj("note1190",this);
      }
      
      public function write1101() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1101;
         client.sendBytes(_loc1_);
      }
      
      public function write1102(param1:int, param2:String, param3:int) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 1102;
         _loc4_.userName = param2;
         _loc4_.headPtId = param1;
         _loc4_.trainPtId = param3;
         LogUtil("obj=" + JSON.stringify(_loc4_));
         client.sendBytes(_loc4_);
      }
      
      public function write1103(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1103;
         _loc2_.diamond = param1;
         client.sendBytes(_loc2_);
      }
      
      public function write1104(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1104;
         _loc2_.diamond = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1101(param1:Object) : void
      {
         LogUtil("object1101=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            LogUtil("信息更新成功1101");
            if(param1.data.handBooknum)
            {
               PlayerVO.handbookNum = param1.data.handBooknum;
            }
            if(param1.data.headArr)
            {
               PlayerVO.headArr = param1.data.headArr;
            }
            if(param1.data.plyInfo)
            {
               if(param1.data.plyInfo.lv)
               {
                  PlayerVO.lv = param1.data.plyInfo.lv;
               }
               if(param1.data.plyInfo.badge)
               {
                  PlayerVO.badgeNum = param1.data.plyInfo.badge;
               }
               if(param1.data.firstLoginDay)
               {
                  PlayerVO.firstLoginDay = param1.data.firstLoginDay;
               }
               if(param1.data.plyInfo.fightDot)
               {
                  PlayerVO.pvDot = param1.data.plyInfo.fightDot;
               }
            }
            sendNotification("update_play_info_panel");
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
         else
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function note1102(param1:Object) : void
      {
         LogUtil("object1102=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.userName)
            {
               PlayerVO.isFirstChangeName = false;
               PlayerVO.nickName = param1.data.userName;
               sendNotification("update_nickname");
               Tips.show("昵称修改成功");
               if((param1.data as Object).hasOwnProperty("diamond"))
               {
                  sendNotification("update_play_diamond_info",param1.data.diamond);
               }
            }
            if(param1.data.headPtId)
            {
               PlayerVO.headPtId = param1.data.headPtId;
               Tips.show("头像修改成功");
            }
            if(param1.data.trainPtId)
            {
               PlayerVO.trainPtId = param1.data.trainPtId;
               Tips.show("训练师修改成功");
            }
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
         else
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function note1103(param1:Object) : void
      {
         LogUtil("object1103=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            UmengExtension.getInstance().UMAnalysic("buy|01|" + (param1.data.silver - PlayerVO.silver) + "|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_money_info",param1.data.silver);
            sendNotification("update_play_diamond_info",param1.data.diamond);
            PlayerVO.vipInfoVO.remainGoldFinger = param1.data.goldFinger;
            sendNotification("update_buy_money_panel");
            Tips.show("兑换成功！!");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function note1104(param1:Object) : void
      {
         LogUtil("object1104=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            UmengExtension.getInstance().UMAnalysic("buy|02|" + (param1.data.actionForce - PlayerVO.actionForce) + "|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_power_info",param1.data.actionForce);
            sendNotification("update_play_diamond_info",param1.data.diamond);
            PlayerVO.vipInfoVO.remainBuyAcFr = param1.data.buyAcFr;
            sendNotification("update_buy_power_panel");
            Tips.show("兑换成功！!");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function note1190(param1:Object) : void
      {
         LogUtil("object=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.actionForce < PlayerVO.maxActionForce)
            {
               PlayerVO.actionCDTime = 360;
            }
            sendNotification("update_play_power_info",param1.data.actionForce);
            LogUtil("更新体力成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
            LogUtil("失败信息 " + param1.data.msg);
         }
         else
         {
            Tips.show(param1.data.msg);
            LogUtil("服务端异常，请稍后重试");
         }
      }
      
      public function write1106() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1106;
         client.sendBytes(_loc1_,false);
      }
      
      public function note1106(param1:Object) : void
      {
         LogUtil("object=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.actionCDTime)
            {
               PlayerVO.actionCDTime = param1.data.actionCDTime;
               if(PlayerVO.actionCDTime < 0)
               {
                  PlayerVO.actionCDTime = 360;
               }
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else
         {
            Tips.show(param1.data.msg);
            LogUtil("服务端异常，请稍后重试");
         }
      }
      
      public function write1108() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 1108;
         LogUtil("write1108: " + JSON.stringify(_loc1_));
         client.sendBytes(_loc1_);
      }
      
      public function note1108(param1:Object) : void
      {
         LogUtil("note1108: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("SHOW_MYELF",param1.data);
         }
         else if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
   }
}
