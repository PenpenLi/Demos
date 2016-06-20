package com.mvc.views.mediator.mainCity.playerInfo
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.playerInfo.PlayInfoBarUI;
   import flash.geom.Rectangle;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.worldHorn.WorldTimeUI;
   import com.mvc.views.uis.mainCity.MainCityUI;
   import com.mvc.views.uis.mainCity.shop.ShopUI;
   import starling.events.Event;
   import com.mvc.views.uis.mapSelect.WorldMapUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.GetCommon;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.mediator.mainCity.growthPlan.GrowthPlanMediator;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import starling.display.DisplayObject;
   
   public class PlayInfoBarMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PlayInfoBarMediator";
      
      public static var isFirstLoadMainCity:Boolean = true;
      
      public static var isFirstShowVipBar:Boolean = true;
      
      public static var dialogueArr:Array = [];
      
      public static var savePower:int;
       
      private var playInfoBarUI:PlayInfoBarUI;
      
      private var expBarWidth:Number;
      
      private var expBarHeight:Number;
      
      private var rect:Rectangle;
      
      public function PlayInfoBarMediator(param1:Object = null)
      {
         rect = new Rectangle();
         super("PlayInfoBarMediator",param1);
         playInfoBarUI = param1 as PlayInfoBarUI;
         expBarWidth = playInfoBarUI.expProgressBar.width;
         expBarHeight = playInfoBarUI.expProgressBar.height;
         playInfoBarUI.addEventListener("triggered",playInfoBarUI_triggeredHandler);
         playInfoBarUI.worldTime.addEventListener("touch",ontouch);
         playInfoBarUI.vipSpr.addEventListener("touch",ontouch);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(playInfoBarUI);
         if(_loc2_)
         {
            if(_loc2_.target.name == "worldTime")
            {
               if(_loc2_.phase == "began")
               {
                  WorldTimeUI.getInstance().show();
               }
               if(_loc2_.phase == "ended")
               {
                  WorldTimeUI.getInstance().remove();
               }
            }
            if(_loc2_.target.name == "vipTf")
            {
               if(_loc2_.phase == "ended")
               {
                  sendNotification("switch_win",(playInfoBarUI.parent as Game).page is MainCityUI || ShopUI?null:(playInfoBarUI.parent as Game).page,"load_diamond_panel");
               }
            }
         }
      }
      
      private function playInfoBarUI_triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(playInfoBarUI.headBtn !== _loc2_)
         {
            if(playInfoBarUI.buyDiamondBtn !== _loc2_)
            {
               if(playInfoBarUI.buyMoneyBtn !== _loc2_)
               {
                  if(playInfoBarUI.buyPowerBtn === _loc2_)
                  {
                     sendNotification("switch_win",(playInfoBarUI.parent as Game).page is MainCityUI || ShopUI?null:(playInfoBarUI.parent as Game).page,"load_power_panel");
                  }
               }
               else
               {
                  sendNotification("switch_win",(playInfoBarUI.parent as Game).page is MainCityUI || ShopUI?null:(playInfoBarUI.parent as Game).page,"load_money_panel");
               }
            }
            else
            {
               sendNotification("switch_win",(playInfoBarUI.parent as Game).page is MainCityUI || ShopUI?null:(playInfoBarUI.parent as Game).page,"load_diamond_panel");
            }
         }
         else
         {
            sendNotification("switch_win",(playInfoBarUI.parent as Game).page is MainCityUI || WorldMapUI?null:(playInfoBarUI.parent as Game).page,"load_play_info_panel");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_play_info_bar","update_trainerPic","update_nickname","update_play_lv_info","update_play_expbar_info","update_play_money_info","update_play_diamond_info","update_play_power_info","update_play_max_power_info"];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("update_play_info_bar" !== _loc2_)
         {
            if("update_trainerPic" !== _loc2_)
            {
               if("update_play_lv_info" !== _loc2_)
               {
                  if("update_play_power_info" !== _loc2_)
                  {
                     if("update_play_max_power_info" !== _loc2_)
                     {
                        if("update_play_money_info" !== _loc2_)
                        {
                           if("update_play_diamond_info" !== _loc2_)
                           {
                              if("update_play_expbar_info" === _loc2_)
                              {
                                 PlayerVO.exper = param1.getBody();
                                 updateExpProgressBar(PlayerVO.exper);
                              }
                           }
                           else
                           {
                              PlayerVO.diamond = param1.getBody();
                              if(GetCommon.isIOSDied())
                              {
                                 return;
                              }
                              playInfoBarUI.diamondTf.text = PlayerVO.diamond;
                              AniFactor.ScaleMaxAni(playInfoBarUI.diamondTf);
                           }
                        }
                        else
                        {
                           PlayerVO.silver = param1.getBody();
                           if(GetCommon.isIOSDied())
                           {
                              return;
                           }
                           playInfoBarUI.moneyTf.text = PlayerVO.silver;
                           AniFactor.ScaleMaxAni(playInfoBarUI.moneyTf);
                        }
                     }
                     else
                     {
                        PlayerVO.maxActionForce = param1.getBody();
                        playInfoBarUI.maxPowerTf.text = "/" + PlayerVO.maxActionForce;
                     }
                  }
                  else
                  {
                     if(GetCommon.isIOSDied())
                     {
                        savePower = param1.getBody();
                        return;
                     }
                     PlayerVO.actionForce = param1.getBody();
                     playInfoBarUI.nowPowerTf.text = PlayerVO.actionForce;
                     AniFactor.ScaleMaxAni(playInfoBarUI.nowPowerTf);
                     if(PlayerVO.actionForce >= PlayerVO.maxActionForce)
                     {
                        PlayerVO.actionCDTime = 0;
                     }
                  }
               }
               else
               {
                  playInfoBarUI.levelTf.text = "Lv:" + PlayerVO.lv;
               }
            }
            else
            {
               changeTrainerPic(param1.getBody() as int);
            }
         }
         else
         {
            playInfoBarUI.levelTf.text = "Lv:" + PlayerVO.lv;
            playInfoBarUI.nowPowerTf.text = PlayerVO.actionForce;
            playInfoBarUI.maxPowerTf.text = "/" + PlayerVO.maxActionForce;
            playInfoBarUI.moneyTf.text = PlayerVO.silver;
            playInfoBarUI.vipTf.text = "VIP  " + PlayerVO.vipRank;
            playInfoBarUI.diamondTf.text = PlayerVO.diamond;
            updateExpProgressBar(PlayerVO.exper,true);
            changeTrainerPic(PlayerVO.trainPtId);
         }
      }
      
      private function updateExpProgressBar(param1:int, param2:Boolean = false) : void
      {
         if(PlayerVO.lv >= PlayerVO.playerLvVoVec.length)
         {
            showExpAni(1);
            return;
         }
         var _loc3_:int = PlayerVO.lv;
         calculateExp(param1);
         handleUpLv(_loc3_,param2);
      }
      
      private function handleUpLv(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:* = 0;
         if(PlayerVO.lv > param1)
         {
            if(!param2)
            {
               LogUtil("登陆以后计算经验，并且玩家升级了！");
               FightingConfig.isLvUp = true;
            }
            sendNotification("update_play_lv_info");
            FightingConfig.lvBefore = param1;
            FightingConfig.powerBefore = PlayerVO.actionForce;
            FightingConfig.maxPowerBefore = PlayerVO.maxActionForce;
            LogUtil("升级前最大体力" + FightingConfig.maxPowerBefore + "   升级前当前体力" + FightingConfig.powerBefore);
            _loc3_ = 1;
            while(_loc3_ <= PlayerVO.lv - param1)
            {
               PlayerVO.actionForce = PlayerVO.actionForce + PlayerVO.playerLvVoVec[PlayerVO.lv - _loc3_].actionRestore;
               _loc3_++;
            }
            PlayerVO.maxActionForce = PlayerVO.playerLvVoVec[PlayerVO.lv - 1].maxActionForce;
            sendNotification("update_play_power_info",PlayerVO.actionForce);
            sendNotification("update_play_max_power_info",PlayerVO.maxActionForce);
            if(PlayerVO.pokeSpace <= 3 && PlayerVO.lv >= 20)
            {
               PlayerVO.pokeSpace = PlayerVO.pokeSpace + 1;
               PlayerVO.isOpenPokeSpace = true;
            }
            if(PlayerVO.pokeSpace <= 4 && PlayerVO.lv >= 25)
            {
               PlayerVO.pokeSpace = PlayerVO.pokeSpace + 1;
               PlayerVO.isOpenPokeSpace = true;
            }
            if(PlayerVO.pokeSpace <= 5 && PlayerVO.lv >= 30)
            {
               PlayerVO.pokeSpace = PlayerVO.pokeSpace + 1;
               PlayerVO.isOpenPokeSpace = true;
            }
            if(GrowthPlanMediator.isBuy && !GrowthPlanMediator.isGet && PlayerVO.lv >= GrowthPlanMediator.nextGrade)
            {
               GrowthPlanMediator.isGet = true;
               sendNotification("SHOW_GROWTHPLAN");
            }
         }
      }
      
      private function calculateExp(param1:int) : void
      {
         var _loc5_:* = 0;
         var _loc6_:* = NaN;
         var _loc2_:* = NaN;
         var _loc3_:* = 0.0;
         var _loc4_:int = PlayerVO.playerLvVoVec.length;
         _loc5_ = 0;
         while(_loc5_ < PlayerVO.lv)
         {
            _loc3_ = _loc3_ + PlayerVO.playerLvVoVec[_loc5_].exp;
            _loc5_++;
         }
         if(param1 >= _loc3_)
         {
            PlayerVO.lv = PlayerVO.lv + 1;
            if(PlayerVO.lv == _loc4_)
            {
               LogUtil("满级啦，尼玛。。");
               showExpAni(1);
               return;
            }
            calculateExp(param1);
         }
         else
         {
            _loc6_ = 0.0;
            _loc2_ = param1 - (_loc3_ - PlayerVO.playerLvVoVec[PlayerVO.lv - 1].exp);
            _loc6_ = _loc2_ / PlayerVO.playerLvVoVec[PlayerVO.lv - 1].exp;
            showExpAni(_loc6_);
         }
      }
      
      private function showExpAni(param1:Number) : void
      {
         playInfoBarUI.expProgressBar.visible = true;
         if(param1 == 0)
         {
            playInfoBarUI.expProgressBar.visible = false;
         }
         else
         {
            rect.width = expBarWidth * param1;
            rect.height = expBarHeight;
            playInfoBarUI.expProgressBar.clipRect = rect;
         }
      }
      
      private function changeTrainerPic(param1:int) : void
      {
         var _loc2_:* = null;
         _loc2_ = GetPlayerRelatedPicFactor.getHeadPic(param1,1,false);
         playInfoBarUI.trainerPicImg.texture = _loc2_.texture;
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PlayInfoBarMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
