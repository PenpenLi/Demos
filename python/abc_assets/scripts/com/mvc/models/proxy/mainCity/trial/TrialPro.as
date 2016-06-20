package com.mvc.models.proxy.mainCity.trial
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.common.themes.Tips;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.mainCity.trial.TrialMediator;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.worldHorn.WorldTime;
   
   public class TrialPro extends Proxy
   {
      
      public static const NAME:String = "TrialPro";
       
      private var client:Client;
      
      private var bossIndex:int;
      
      private var isReturnToTrial:Boolean;
      
      private var callBack:Function;
      
      public function TrialPro(param1:Object = null)
      {
         super("TrialPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2201",this);
         client.addCallObj("note2202",this);
         client.addCallObj("note2203",this);
         client.addCallObj("note2204",this);
         client.addCallObj("note2205",this);
         client.addCallObj("note2206",this);
      }
      
      public function write2201(param1:int) : void
      {
         bossIndex = param1 - 1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2201;
         _loc2_.bossId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2201(param1:Object) : void
      {
         LogUtil("note2201" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("switch_win",null,"load_trial_select_difficulty");
            sendNotification("trial_update_select_difficulty",param1,bossIndex);
            sendNotification("trial_select_boss_success");
            if(bossIndex == 7)
            {
               sendNotification("trial_show_treasure_success");
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
      
      public function write2202(param1:Boolean, param2:int, param3:int, param4:Boolean = true) : void
      {
         var _loc5_:Object = {};
         _loc5_.msgId = 2202;
         _loc5_.difficultyId = param2;
         _loc5_.bossId = param3;
         _loc5_.flag = param1;
         LogUtil(FightingConfig.fightToken + "战斗token5555");
         _loc5_.verify = FightingConfig.fightToken;
         client.sendBytes(_loc5_);
         LogUtil("write2202: " + JSON.stringify(_loc5_));
         isReturnToTrial = param4;
         FightingConfig.reGetBagElf();
      }
      
      public function note2202(param1:Object) : void
      {
         LogUtil("note2202" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            TrialMediator.trialReward = param1.data.drop;
            if(param1.data.actionForce)
            {
               sendNotification("update_play_power_info",param1.data.actionForce);
            }
         }
         else if(param1.status == "fail")
         {
            Alert.show(param1.data.msg,"",new ListCollection([{"label":"我知道啦"}]));
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
         if(isReturnToTrial)
         {
            sendNotification("switch_page","load_trial_page");
         }
      }
      
      public function write2203(param1:int, param2:Function) : void
      {
         callBack = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 2203;
         _loc3_.bossId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note2203(param1:Object) : void
      {
         LogUtil("note2203" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.actionForce)
            {
               sendNotification("update_play_power_info",param1.data.actionForce);
            }
            if(callBack)
            {
               callBack();
               callBack = null;
            }
         }
         else if(param1.status == "fail")
         {
            FightingConfig.reGetBagElf();
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            FightingConfig.reGetBagElf();
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2204(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2204;
         _loc2_.difficultyId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2204(param1:Object) : void
      {
         LogUtil("note2204" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("trial_difficulty_open");
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
      
      public function write2205(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2205;
         _loc2_.bossId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2205(param1:Object) : void
      {
         LogUtil("note2205" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("trial_buy_challenge_times",param1);
            UmengExtension.getInstance().UMAnalysic("buy|012|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
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
      
      public function write2206() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2206;
         client.sendBytes(_loc1_);
      }
      
      public function note2206(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = false;
         var _loc3_:* = null;
         LogUtil("note2206" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc4_ = transDate(param1.data.startTime) + "—" + transDate(param1.data.endTime);
            if(WorldTime.getInstance().serverTime > param1.data.startTime && WorldTime.getInstance().serverTime < param1.data.endTime)
            {
               _loc2_ = true;
            }
            _loc3_ = {};
            _loc3_.actTime = _loc4_;
            _loc3_.isAct = _loc2_;
            sendNotification("trial_act_info",_loc3_);
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
      
      public function transDate(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 * 1000);
         return _loc2_.month + 1 + "月" + _loc2_.date + "日";
      }
   }
}
