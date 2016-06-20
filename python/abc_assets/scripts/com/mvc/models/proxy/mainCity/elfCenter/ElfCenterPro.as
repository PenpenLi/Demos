package com.mvc.models.proxy.mainCity.elfCenter
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.themes.Tips;
   import extend.SoundEvent;
   import com.common.util.beginnerGuide.BeginnerGuide;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class ElfCenterPro extends Proxy
   {
      
      public static const NAME:String = "ElfCenterPro";
       
      private var client:Client;
      
      private var showPlace:String;
      
      private var recoverPlace:String;
      
      private var upSpeedType:String;
      
      public function ElfCenterPro(param1:Object = null)
      {
         super("ElfCenterPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2007",this);
         client.addCallObj("note2008",this);
         client.addCallObj("note2009",this);
         client.addCallObj("note2021",this);
      }
      
      public function write2007(param1:String) : void
      {
         showPlace = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2007;
         client.sendBytes(_loc2_);
      }
      
      public function note2007(param1:Object) : void
      {
         LogUtil("2007=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            MyElfMedia.recoverTimes = param1.data.freeTime;
            if(showPlace == "elfCenter")
            {
               sendNotification("SHOW_ELFCENTER",param1.data.freeTime);
               sendNotification("SEND_COUNT_DOWN",param1.data.cd);
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
      
      public function write2008(param1:String) : void
      {
         var _loc2_:* = null;
         LogUtil("2008=" + JSON.stringify(_loc2_));
         recoverPlace = param1;
         _loc2_ = {};
         _loc2_.msgId = 2008;
         client.sendBytes(_loc2_);
      }
      
      public function note2008(param1:Object) : void
      {
         LogUtil("2008=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            MyElfMedia.recoverTimes = param1.data.freeTime;
            if(recoverPlace == "myElf")
            {
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","recover");
               SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","putElfBall");
               sendNotification("UPDATE_ELFPANEL_ELF");
            }
            else if(recoverPlace == "elfCenter")
            {
               sendNotification("ELF_RECOVER",param1.data.freeTime);
               sendNotification("SEND_COUNT_DOWN",param1.data.cd);
               BeginnerGuide.playBeginnerGuide();
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
      
      public function write2009(param1:String) : void
      {
         upSpeedType = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2009;
         client.sendBytes(_loc2_);
      }
      
      public function note2009(param1:Object) : void
      {
         LogUtil("2009=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(upSpeedType == "elfCenter")
            {
               Tips.show("购买成功！");
               sendNotification("elfcenter_buy_recover");
            }
            else if(upSpeedType == "myElf")
            {
               (facade.retrieveProxy("ElfCenterPro") as ElfCenterPro).write2008("myElf");
            }
            sendNotification("update_play_money_info",param1.data.silver);
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
      
      public function write2021() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2021;
         client.sendBytes(_loc1_);
      }
      
      public function note2021(param1:Object) : void
      {
         LogUtil("2021=" + JSON.stringify(param1));
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
               Tips.show("协议处理失败");
            }
         }
         else
         {
            UmengExtension.getInstance().UMAnalysic("buy|07|1|10");
            sendNotification("update_play_diamond_info",PlayerVO.diamond - 10);
         }
      }
   }
}
