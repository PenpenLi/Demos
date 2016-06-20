package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.mining.MiningDefendRecordUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import starling.display.Image;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import lzm.starling.swf.display.SwfButton;
   import lzm.util.TimeUtil;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class MiningDefendRecordMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningDefendRecordMediator";
       
      public var miningDefendRecordUI:MiningDefendRecordUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var arr:Array;
      
      public function MiningDefendRecordMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         arr = [];
         super("MiningDefendRecordMediator",param1);
         miningDefendRecordUI = param1 as MiningDefendRecordUI;
         miningDefendRecordUI.addEventListener("triggered",clickHandler);
         updateDefendRecordList([{"attackerHeadPtId":10}]);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(miningDefendRecordUI.btn_close === _loc2_)
         {
            miningDefendRecordUI.list.removeFromParent();
            WinTweens.closeWin(miningDefendRecordUI.spr_fightRecord,remove);
         }
      }
      
      private function remove() : void
      {
         judgeShowNews();
         miningDefendRecordUI.removeFromParent();
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("mining_update_defendrecord_list" === _loc2_)
         {
            miningDefendRecordUI.spr_fightRecord.addChild(miningDefendRecordUI.list);
            arr = param1.getBody() as Array;
            updateDefendRecordList(arr);
         }
      }
      
      private function updateDefendRecordList(param1:Array) : void
      {
         var _loc7_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc4_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = null;
         var _loc9_:* = null;
         var _loc2_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         miningDefendRecordUI.listData.removeAll();
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc3_ = new Sprite();
            _loc4_ = "";
            if(param1[_loc7_].isWin)
            {
               _loc6_ = miningDefendRecordUI.getImg("img_defeat");
               _loc4_ = "\n获得：<font color = \'#000000\'  size = \'24\'>" + showReward(param1[_loc7_].reward) + "</font>";
            }
            else
            {
               _loc6_ = miningDefendRecordUI.getImg("img_victory");
            }
            _loc3_.addChild(_loc6_);
            _loc5_ = GetPlayerRelatedPicFactor.getHeadPic(param1[_loc7_].attackerHeadPtId);
            _loc5_.x = 70;
            _loc3_.addChild(_loc5_);
            if(param1[_loc7_].attackerVip > 0)
            {
               _loc10_ = GetCommon.getVipIcon(param1[_loc7_].attackerVip);
               _loc10_.x = _loc5_.x - 5;
               _loc10_.y = _loc5_.y - 5;
               _loc3_.addChild(_loc10_);
            }
            displayVec.push(_loc3_);
            _loc8_ = miningDefendRecordUI.getBtn("btn_powerBtn_b");
            _loc8_.name = _loc7_;
            _loc8_.addEventListener("triggered",powerBtn_triggeredHandler);
            displayVec.push(_loc8_);
            if(!param1[_loc7_].haveBreadReward)
            {
               _loc8_.visible = false;
            }
            _loc9_ = TimeUtil.getTime(WorldTime.getInstance().serverTime - param1[_loc7_].time) + "前";
            _loc2_ = "<font color = \'#006000\'  size = \'24\'>" + param1[_loc7_].attackerName + "（" + param1[_loc7_].controlId + "区:" + param1[_loc7_].controlName + "）" + "</font>" + "\n" + "<font color = \'#000000\'  size = \'24\'>" + _loc9_ + "</font>" + "偷袭你的" + "<font color = \'#02559f\'  size = \'24\'>" + param1[_loc7_].mineName + "</font>" + _loc4_;
            miningDefendRecordUI.listData.push({
               "label":_loc2_,
               "icon":_loc3_,
               "accessory":_loc8_,
               "haveBreadReward":param1[_loc7_].haveBreadReward
            });
            _loc7_++;
         }
      }
      
      private function powerBtn_triggeredHandler(param1:Event) : void
      {
         event = param1;
         getPowerComplete = function():void
         {
            arr[index].haveBreadReward = false;
            updateDefendRecordList(arr);
         };
         var index:int = (event.target as SwfButton).name;
         (facade.retrieveProxy("Miningpro") as MiningPro).write3913(index,getPowerComplete);
      }
      
      private function showReward(param1:Object) : String
      {
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         if(!param1)
         {
            return "";
         }
         var _loc2_:String = "";
         if(param1.silver)
         {
            _loc2_ = _loc2_ + ("金币×" + param1.silver + "，");
         }
         if(param1.diamond)
         {
            _loc2_ = _loc2_ + ("钻石×" + param1.diamond + "，");
         }
         if(param1.prop)
         {
            _loc5_ = param1.prop;
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               _loc3_ = GetPropFactor.getPropVO(_loc5_[_loc4_].pId);
               _loc2_ = _loc2_ + (_loc3_.name + "×" + _loc5_[_loc4_].num + "，");
               _loc4_++;
            }
         }
         if(_loc2_)
         {
            _loc2_ = _loc2_.slice(0,_loc2_.length - 1);
         }
         return _loc2_;
      }
      
      private function judgeShowNews() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < arr.length)
         {
            if(arr[_loc2_].haveBreadReward)
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            MiningPro.isShowDefendNews = true;
            sendNotification("mining_show_defend_news");
         }
         else
         {
            MiningPro.isShowDefendNews = false;
            sendNotification("mining_hide_defend_news");
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["mining_update_defendrecord_list"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         facade.removeMediator("MiningDefendRecordMediator");
         UI.dispose();
         viewComponent = null;
      }
   }
}
