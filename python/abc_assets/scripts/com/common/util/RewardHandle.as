package com.common.util
{
   import starling.display.Sprite;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.massage.ane.UmengExtension;
   import com.mvc.models.vos.huntingParty.HuntPartyVO;
   import com.common.events.EventCenter;
   import extend.SoundEvent;
   import com.mvc.models.proxy.mainCity.task.TaskPro;
   
   public class RewardHandle
   {
      
      private static var arr:Array;
      
      public static var isHasSpace:Boolean = true;
      
      public static var elfRewardNum:int;
      
      private static var _type:int;
       
      public function RewardHandle()
      {
         super();
      }
      
      public static function showReward(param1:Object, param2:Sprite, param3:Number = 1, param4:uint = 5715237) : void
      {
         var _loc9_:* = null;
         var _loc8_:* = 0;
         var _loc6_:* = null;
         var _loc7_:* = 0;
         var _loc5_:* = null;
         elfRewardNum = 0;
         if(param1.poke)
         {
            _loc8_ = 0;
            while(_loc8_ < param1.poke.length)
            {
               _loc9_ = new DropPropUnitUI(param4);
               var _loc10_:* = param3;
               _loc9_.scaleY = _loc10_;
               _loc9_.scaleX = _loc10_;
               _loc9_.touchable = false;
               _loc6_ = GetElfFactor.getElfVO(param1.poke[_loc8_].pokeId);
               _loc6_.lv = param1.poke[_loc8_].lv;
               _loc9_.myElfVo = _loc6_;
               _loc9_.rewardNameTf.text = _loc6_.name + "×" + param1.poke[_loc8_].num;
               param2.addChild(_loc9_);
               elfRewardNum = §§dup().elfRewardNum + param1.poke[_loc8_].num;
               _loc8_++;
            }
            if(PlayerVO.cpSpace + PlayerVO.pokeSpace - PlayerVO.comElfVec.length - GetElfFactor.bagElfNum() < elfRewardNum)
            {
               isHasSpace = false;
            }
            else
            {
               isHasSpace = true;
            }
         }
         if(param1.diamond)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励钻石×" + param1.diamond.num);
            param2.addChild(_loc9_);
         }
         if(param1.silver)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励金币×" + param1.silver.num);
            param2.addChild(_loc9_);
         }
         if(param1.action)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励体力×" + param1.action.num);
            param2.addChild(_loc9_);
         }
         if(param1.kwDot)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励王者积分×" + param1.kwDot.num);
            param2.addChild(_loc9_);
         }
         if(param1.pvDot)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励对战积分×" + param1.pvDot.num);
            param2.addChild(_loc9_);
         }
         if(param1.rkDot)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励联盟积分×" + param1.rkDot.num);
            param2.addChild(_loc9_);
         }
         if(param1.fsDot)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励神秘积分×" + param1.fsDot.num);
            param2.addChild(_loc9_);
         }
         if(param1.catchScore)
         {
            _loc9_ = new DropPropUnitUI(param4);
            _loc10_ = param3;
            _loc9_.scaleY = _loc10_;
            _loc9_.scaleX = _loc10_;
            _loc9_.setOtherAward("奖励捕虫大会积分×" + param1.catchScore.num);
            param2.addChild(_loc9_);
         }
         if(param1.prop)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.prop.length)
            {
               _loc9_ = new DropPropUnitUI(param4);
               _loc10_ = param3;
               _loc9_.scaleY = _loc10_;
               _loc9_.scaleX = _loc10_;
               _loc5_ = GetPropFactor.getPropVO(param1.prop[_loc7_].pId);
               _loc5_.rewardCount = param1.prop[_loc7_].num;
               _loc9_.myPropVo = _loc5_;
               param2.addChild(_loc9_);
               _loc7_++;
            }
         }
      }
      
      public static function Reward(param1:Object, param2:int = 0, param3:int = -1) : void
      {
         var _loc7_:* = 0;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc4_:* = null;
         _type = param3;
         arr = [];
         if(param1.poke)
         {
            _loc7_ = 0;
            while(_loc7_ < param1.poke.length)
            {
               _loc5_ = GetElfFromSever.getElfInfo(param1.poke[_loc7_]);
               arr.push(_loc5_);
               GetElfFactor.bagOrCom(_loc5_,false);
               IllustrationsPro.saveElfInfo(_loc5_);
               _loc7_++;
            }
         }
         if(param1.prop)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.prop.length)
            {
               _loc4_ = GetPropFactor.getPropVO(param1.prop[_loc6_].pId);
               _loc4_.rewardCount = param1.prop[_loc6_].num;
               arr.push(_loc4_);
               GetPropFactor.addOrLessProp(_loc4_,true,_loc4_.rewardCount);
               _loc6_++;
            }
         }
         if(param1.silver)
         {
            Facade.getInstance().sendNotification("update_play_money_info",PlayerVO.silver + param1.silver);
            arr.push("奖励金币×" + param1.silver);
         }
         if(param1.diamond)
         {
            arr.push("奖励钻石×" + param1.diamond);
            if(param2 != 0)
            {
               UmengExtension.getInstance().UMAnalysic("bonusMoney|" + param1.diamond + "|" + param2);
            }
            Facade.getInstance().sendNotification("update_play_diamond_info",PlayerVO.diamond + param1.diamond);
         }
         if(param1.action)
         {
            arr.push("奖励体力×" + param1.action);
            Facade.getInstance().sendNotification("update_play_power_info",PlayerVO.actionForce + param1.action);
         }
         if(param1.exper)
         {
            arr.push("奖励经验×" + param1.exper);
            Facade.getInstance().sendNotification("update_play_expbar_info",PlayerVO.exper + param1.exper);
         }
         if(param1.kwDot)
         {
            arr.push("奖励王者积分×" + param1.kwDot);
            PlayerVO.kwDot = PlayerVO.kwDot + param1.kwDot;
         }
         if(param1.pvDot)
         {
            arr.push("奖励对战积分×" + param1.pvDot);
            PlayerVO.pvDot = PlayerVO.pvDot + param1.pvDot;
         }
         if(param1.rkDot)
         {
            arr.push("奖励联盟积分×" + param1.rkDot);
            PlayerVO.rkDot = PlayerVO.rkDot + param1.rkDot;
         }
         if(param1.fsDot)
         {
            arr.push("奖励神秘积分×" + param1.fsDot);
            PlayerVO.fsDot = PlayerVO.fsDot + param1.fsDot;
         }
         if(param1.catchScore)
         {
            arr.push("奖励捕虫大会积分×" + param1.catchScore);
            Facade.getInstance().sendNotification("UPDATE_HUNTSCORE",HuntPartyVO.score + param1.catchScore);
         }
         if(arr.length == 0)
         {
            return;
         }
         EventCenter.addEventListener("WIN_PLAY_COMPLETE",loadAfter);
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_DROP_PROP");
         SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","getReward");
         if(GetElfFactor.bagNewElf)
         {
            GetElfFactor.bagNewElf = false;
            Facade.getInstance().sendNotification("UPDATE_BAG_ELF");
         }
      }
      
      private static function loadAfter() : void
      {
         EventCenter.removeEventListener("WIN_PLAY_COMPLETE",loadAfter);
         Facade.getInstance().sendNotification("SEND_DROP_PROP",arr);
         if(_type != -1)
         {
            (Facade.getInstance().retrieveProxy("TaskPro") as TaskPro).write1801(_type);
         }
      }
   }
}
