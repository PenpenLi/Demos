package com.common.sdk
{
   import com.AGame.ane.AGameExtension;
   import flash.events.StatusEvent;
   import com.common.events.EventCenter;
   import com.common.net.CheckNetStatus;
   import com.massage.ane.UmengExtension;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import flash.desktop.NativeApplication;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.util.LSOManager;
   
   public class SDKAG implements InterfaceANE
   {
       
      private const cpid:String = "100079";
      
      private const gameid:String = "100214";
      
      private const gamekey:String = "f54b1414cca01c90";
      
      private const gamename:String = "口袋妖怪复刻";
      
      private var sessionid:String;
      
      private var initState:int;
      
      private var isLogin:Boolean;
      
      private var data:Date;
      
      private var count:int;
      
      private var decArr:Array;
      
      private var accountid:String;
      
      public function SDKAG()
      {
         decArr = ["baidu","snail","yyh","paojiao","baidu2","baidu3","ttyy","caohua"];
         super();
      }
      
      private function resumeEvent() : void
      {
         AGameExtension.getInstance().AGameBackEnd("恢复");
      }
      
      private function stopEvent() : void
      {
         AGameExtension.getInstance().AGameBackEnd("停止");
      }
      
      private function pauseEvent() : void
      {
         AGameExtension.getInstance().AGameBackEnd("暂停");
      }
      
      protected function handler_status(param1:StatusEvent) : void
      {
         var _loc3_:* = null;
         var _loc12_:* = null;
         var _loc6_:* = null;
         var _loc13_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc9_:* = null;
         var _loc8_:* = null;
         var _loc11_:* = null;
         var _loc5_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         LogUtil("level:" + param1.level,",code:" + param1.code);
         var _loc14_:* = param1.level;
         if("initOK" !== _loc14_)
         {
            if("initIDEROR" !== _loc14_)
            {
               if("initNETEROR" !== _loc14_)
               {
                  if("initEROR" !== _loc14_)
                  {
                     if("loginOK" !== _loc14_)
                     {
                        if("loginNO" !== _loc14_)
                        {
                           if("loginCANCEL" !== _loc14_)
                           {
                              if("payOK" !== _loc14_)
                              {
                                 if("payNO" !== _loc14_)
                                 {
                                    if("payCHECK" !== _loc14_)
                                    {
                                       if("querOK" !== _loc14_)
                                       {
                                          if("querNO" !== _loc14_)
                                          {
                                             if("querCHECK" !== _loc14_)
                                             {
                                                if("querNOHAVE" !== _loc14_)
                                                {
                                                }
                                             }
                                          }
                                       }
                                       else
                                       {
                                          _loc11_ = param1.code.split("|");
                                          _loc5_ = _loc11_[0];
                                          _loc2_ = _loc11_[1];
                                          _loc7_ = _loc11_[2];
                                       }
                                    }
                                 }
                              }
                              else
                              {
                                 _loc6_ = param1.code.split("|");
                                 _loc13_ = _loc6_[0];
                                 _loc4_ = _loc6_[1];
                                 _loc10_ = _loc6_[2];
                                 _loc9_ = _loc6_[3];
                                 _loc8_ = _loc6_[4];
                                 UmengExtension.getInstance().UMAnalysic("payDiamond|" + _loc4_ + "|" + count + "|2");
                              }
                           }
                           else
                           {
                              LogUtil("注销了");
                              if(sessionid == null)
                              {
                                 login();
                                 return;
                              }
                              CheckNetStatus.reLogin();
                           }
                        }
                     }
                     else
                     {
                        if(Pocketmon._description == "wdj")
                        {
                           resumeEvent();
                        }
                        _loc3_ = param1.code.split("|");
                        sessionid = _loc3_[0];
                        accountid = _loc3_[1];
                        _loc12_ = _loc3_[2];
                        EventCenter.dispatchEvent("SERVER_LIST",{
                           "sessionid":sessionid,
                           "accountid":accountid,
                           "platform":platform
                        });
                     }
                  }
                  else
                  {
                     initState = 4;
                     if(isLogin)
                     {
                        otherErro();
                     }
                  }
               }
               else
               {
                  initState = 3;
                  if(isLogin)
                  {
                     netErro();
                  }
               }
            }
            else
            {
               initState = 2;
               if(isLogin)
               {
                  gameIdErro();
               }
            }
         }
         else
         {
            initState = 1;
            if(isLogin)
            {
               login();
            }
            SDKEvent.addEventListener("on_pause_event",pauseEvent);
            SDKEvent.addEventListener("on_stop_event",stopEvent);
            SDKEvent.addEventListener("on_resume_event",resumeEvent);
         }
      }
      
      private function result(param1:Object) : void
      {
      }
      
      public function initSDK() : void
      {
         AGameExtension.getInstance().addEventListener("status",handler_status);
         if(decArr.indexOf(Pocketmon._description) == -1)
         {
            AGameExtension.getInstance().AGameInit("false","100079","100214","f54b1414cca01c90","口袋妖怪复刻");
         }
         else
         {
            SDKEvent.addEventListener("on_pause_event",pauseEvent);
            SDKEvent.addEventListener("on_stop_event",stopEvent);
            SDKEvent.addEventListener("on_resume_event",resumeEvent);
         }
      }
      
      public function login() : void
      {
         isLogin = true;
         if(initState == 1 || decArr.indexOf(Pocketmon._description) != -1)
         {
            AGameExtension.getInstance().AGameLogin("","f54b1414cca01c90");
         }
         else if(initState == 2)
         {
            gameIdErro();
         }
         else if(initState == 3)
         {
            netErro();
         }
         else if(initState == 4)
         {
            otherErro();
         }
         else
         {
            Tips.show("初始化中，请耐心等待…");
         }
      }
      
      private function otherErro() : void
      {
         var _loc1_:Alert = Alert.show("初始化失败, 请检查是否网络异常","温馨提示",new ListCollection([{"label":"确定"}]));
         _loc1_.addEventListener("close",gameIDErroHander);
      }
      
      private function netErro() : void
      {
         var _loc1_:Alert = Alert.show("网络初始化异常，请检查网络后点击确定","温馨提示",new ListCollection([{"label":"确定"}]));
         _loc1_.addEventListener("close",netErroHander);
      }
      
      private function gameIdErro() : void
      {
         var _loc1_:String = "<font size=\'30\'>初始化失败</font>\n<font size=\'20\' color=\'#1c6b04\'>（请联系游戏官方客服登记问题，游戏官方1群159610038 2群374428661）</font>";
         var _loc2_:Alert = Alert.show(_loc1_,"温馨提示",new ListCollection([{"label":"确定"}]));
         _loc2_.addEventListener("close",gameIDErroHander);
      }
      
      private function netErroHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            initSDK();
         }
      }
      
      private function gameIDErroHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            NativeApplication.nativeApplication.exit();
            UmengExtension.getInstance().UMAnalysic("exit");
         }
      }
      
      public function logout() : void
      {
      }
      
      public function pay(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         var _loc7_:String = "钻石";
         if(Pocketmon._description == "leshi")
         {
            _loc7_ = param2 + "钻石";
         }
         if(param3 == 10)
         {
            _loc7_ = "月卡";
         }
         count = param2;
         var _loc8_:String = "serverId=" + param4 + "|userId=" + param5 + "|productId=" + param3;
         var _loc6_:String = Game._url + "/agame";
         data = new Date();
         AGameExtension.getInstance().AGamePay(data.time,_loc6_,param1,_loc7_,_loc8_,"f54b1414cca01c90");
         data = null;
      }
      
      public function exit() : void
      {
         AGameExtension.getInstance().AGameExit();
      }
      
      public function subInfo(param1:String) : void
      {
         var _loc3_:String = UnionPro.myUnionVO == null?"无帮派":UnionPro.myUnionVO.unionName;
         var _loc2_:Object = {};
         _loc2_.sceneValue = param1;
         _loc2_.ingot = PlayerVO.diamond;
         _loc2_.playerId = PlayerVO.userId;
         _loc2_.factionName = _loc3_;
         _loc2_.vipLevel = PlayerVO.vipRank;
         _loc2_.serverName = LSOManager.get("SERVERNAME");
         _loc2_.playerLevel = PlayerVO.lv;
         _loc2_.serverId = LSOManager.get("SERVERID");
         _loc2_.playerName = PlayerVO.nickName;
         _loc2_.campId = "无";
         if(PlayerVO.sex == 0)
         {
            _loc2_.roleSex = 1;
         }
         if(PlayerVO.sex == 1)
         {
            _loc2_.roleSex = 0;
         }
         _loc2_.careerId = PlayerVO.trainPtId;
         _loc2_.experience = PlayerVO.exper;
         _loc2_.coin = PlayerVO.silver;
         _loc2_.payment = PlayerVO.payCount;
         LogUtil("信息扩展==========",JSON.stringify(_loc2_));
         AGameExtension.getInstance().AGameSubmit(JSON.stringify(_loc2_));
      }
      
      public function get userId() : String
      {
         return accountid;
      }
      
      public function get token() : String
      {
         return sessionid;
      }
      
      public function get platform() : String
      {
         return "agame";
      }
      
      public function get channel() : String
      {
         return "android";
      }
   }
}
