package com.mvc.views.uis.mainCity.specialAct.dayRecharge
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import lzm.starling.swf.Swf;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.Image;
   import starling.events.Event;
   import starling.display.DisplayObject;
   import com.mvc.views.mediator.mainCity.amuse.AmuseMedia;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.specialAct.SpecialActPro;
   
   public class DayRechargeUI extends Sprite
   {
       
      public var spr_dayRechargeBg:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var btn_recharge:SwfButton;
      
      public var tf_rechargeNum:TextField;
      
      public var tf_rechargeMoney:TextField;
      
      public var tf_rechargeDate:TextField;
      
      private var stateSprite:Sprite;
      
      private var propSprite:Sprite;
      
      private var swf:Swf;
      
      private var existElfIndexArr:Array;
      
      public function DayRechargeUI()
      {
         existElfIndexArr = [];
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("dayRecharge");
         spr_dayRechargeBg = swf.createSprite("spr_dayRechargeBg");
         addChild(spr_dayRechargeBg);
         btn_close = spr_dayRechargeBg.getButton("btn_close");
         btn_recharge = spr_dayRechargeBg.getButton("btn_recharge");
         tf_rechargeNum = spr_dayRechargeBg.getTextField("tf_rechargeNum");
         tf_rechargeNum.text = "";
         tf_rechargeDate = spr_dayRechargeBg.getTextField("tf_rechargeDate");
         tf_rechargeDate.text = "";
         tf_rechargeDate.width = tf_rechargeDate.width + 120;
         tf_rechargeMoney = spr_dayRechargeBg.getTextField("tf_rechargeMoney");
         tf_rechargeMoney.text = "";
         tf_rechargeMoney.autoScale = true;
         var _loc1_:TextField = new TextField(700,20,"活动刷新时间于每天凌晨3-7点，建议训练师们不要在此时间段进行参与活动的充值。","FZCuYuan-M03S",18,16777215);
         _loc1_.hAlign = "center";
         _loc1_.x = 1136 - _loc1_.width >> 1;
         _loc1_.y = tf_rechargeDate.y - 23;
         spr_dayRechargeBg.addChild(_loc1_);
         stateSprite = new Sprite();
         spr_dayRechargeBg.addChild(stateSprite);
         propSprite = new Sprite();
         spr_dayRechargeBg.addChild(propSprite);
      }
      
      public function setReward(param1:Array) : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = 0;
         var _loc7_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         propSprite.removeChildren(0,-1,true);
         existElfIndexArr = [];
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = 0;
            _loc7_ = 0;
            while(_loc7_ < param1[_loc5_].length)
            {
               _loc4_ = new DayRechargePropUnit();
               if(param1[_loc5_][_loc7_].hasOwnProperty("pId"))
               {
                  _loc3_ = GetPropFactor.getPropVO(param1[_loc5_][_loc7_].pId);
                  _loc3_.rewardCount = param1[_loc5_][_loc7_].num;
                  _loc4_.propVO = _loc3_;
               }
               if(param1[_loc5_][_loc7_].hasOwnProperty("pokeId"))
               {
                  if(existElfIndexArr.indexOf(_loc5_) == -1)
                  {
                     existElfIndexArr.push(_loc5_);
                  }
                  _loc6_ = GetElfFactor.getElfVO(param1[_loc5_][_loc7_].pokeId,false);
                  _loc4_.elfVO = _loc6_;
               }
               if(param1[_loc5_][_loc7_].hasOwnProperty("silver"))
               {
                  _loc4_.setOtherAward("金币",param1[_loc5_][_loc7_].silver);
               }
               if(param1[_loc5_][_loc7_].hasOwnProperty("diamond"))
               {
                  _loc4_.setOtherAward("钻石",param1[_loc5_][_loc7_].diamond);
               }
               propSprite.addChild(_loc4_);
               if(_loc7_ % 2 == 0 && _loc7_ != 0)
               {
                  _loc2_++;
               }
               _loc4_.x = 115 + 103 * (_loc7_ % 2) + 345 * _loc5_;
               _loc4_.y = 185 + 100 * _loc2_;
               _loc7_++;
            }
            _loc5_++;
         }
      }
      
      public function setBtnByState(param1:Array) : void
      {
         var _loc5_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         stateSprite.removeChildren(0,-1,true);
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            var _loc6_:* = param1[_loc5_];
            if(0 !== _loc6_)
            {
               if(1 !== _loc6_)
               {
                  if(2 === _loc6_)
                  {
                     _loc2_ = swf.createImage("img_alreadyGetImg");
                     _loc2_.x = 165 + 350 * _loc5_;
                     _loc2_.y = 415;
                     stateSprite.addChild(_loc2_);
                  }
               }
               else
               {
                  _loc3_ = swf.createButton("btn_getBtn_b");
                  _loc3_.x = 165 + 350 * _loc5_;
                  _loc3_.y = 415;
                  _loc3_.name = _loc5_;
                  _loc3_.addEventListener("triggered",btn_getBtn_b_triggeredHandler);
                  stateSprite.addChild(_loc3_);
               }
            }
            else
            {
               _loc4_ = swf.createImage("img_notGetImg");
               _loc4_.x = 165 + 350 * _loc5_;
               _loc4_.y = 415;
               stateSprite.addChild(_loc4_);
            }
            _loc5_++;
         }
      }
      
      private function btn_getBtn_b_triggeredHandler(param1:Event) : void
      {
         var _loc2_:int = (param1.target as DisplayObject).name;
         if(existElfIndexArr.indexOf(_loc2_) != -1 && !AmuseMedia.once())
         {
            return;
         }
         (Facade.getInstance().retrieveProxy("SpecialActivePro") as SpecialActPro).write1909(_loc2_);
      }
      
      public function updateState(param1:int) : void
      {
         var _loc3_:SwfButton = stateSprite.getChildByName(param1) as SwfButton;
         _loc3_.removeFromParent(true);
         var _loc2_:Image = swf.createImage("img_alreadyGetImg");
         _loc2_.x = 165 + 350 * param1;
         _loc2_.y = 415;
         stateSprite.addChild(_loc2_);
      }
   }
}
