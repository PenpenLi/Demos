package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.mining.MiningCheckFormatUI;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.mediator.mainCity.elfSeries.SelectFormationMedia;
   import com.mvc.views.uis.mainCity.elfSeries.SelectFormationUI;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import starling.display.DisplayObject;
   
   public class MiningCheckFormatMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningCheckFormatMediator";
      
      public static var defendElfVOVec:Vector.<ElfVO> = new Vector.<ElfVO>([]);
       
      public var miningCheckFormatUI:MiningCheckFormatUI;
      
      public var defendElfBgUnitVec:Vector.<ElfBgUnitUI>;
      
      private var isLoot:Boolean;
      
      private var object:Object;
      
      private var isAllDie:Boolean;
      
      public function MiningCheckFormatMediator(param1:Object = null)
      {
         defendElfBgUnitVec = new Vector.<ElfBgUnitUI>([]);
         super("MiningCheckFormatMediator",param1);
         miningCheckFormatUI = param1 as MiningCheckFormatUI;
         miningCheckFormatUI.addEventListener("triggered",clickHandler);
      }
      
      private static function initFormationElfVec() : void
      {
         var _loc1_:* = 0;
         MiningCheckFormatMediator.defendElfVOVec = Vector.<ElfVO>([]);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            MiningCheckFormatMediator.defendElfVOVec.push(null);
            _loc1_++;
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(miningCheckFormatUI.btn_close !== _loc2_)
         {
            if(miningCheckFormatUI.btn_selectCamp !== _loc2_)
            {
               if(miningCheckFormatUI.btn_loot === _loc2_)
               {
                  if(MiningFrameMediator.breadNum < 2)
                  {
                     return Tips.show("能量不足");
                  }
                  if(PlayerVO.silver < MiningFrameMediator.exportPay)
                  {
                     return Tips.show("金币不足");
                  }
                  if(isAllDie)
                  {
                     return Tips.show("对方已战败");
                  }
                  remove();
                  (facade.retrieveProxy("Miningpro") as MiningPro).write3910(object.userInfo.userId);
               }
            }
            else
            {
               remove();
               if(!facade.hasMediator("SelectFormationMedia"))
               {
                  facade.registerMediator(new SelectFormationMedia(new SelectFormationUI()));
               }
               sendNotification("selectformation_init_type",MiningCheckFormatMediator.defendElfVOVec,"调矿");
               sendNotification("switch_win",miningCheckFormatUI,"LOAD_SERIES_FORMATION");
            }
         }
         else
         {
            WinTweens.closeWin(miningCheckFormatUI.spr_campInfo,remove);
         }
      }
      
      private function remove() : void
      {
         miningCheckFormatUI.removeFromParent();
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("mining_update_format_info" !== _loc2_)
         {
            if("mining_adjust_format_complete" !== _loc2_)
            {
            }
         }
         else
         {
            object = param1.getBody();
            if(object.canGainRes)
            {
               isLoot = true;
            }
            miningCheckFormatUI.updateCheckFormat(object);
            collectElfCamp(object);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["mining_update_format_info","mining_adjust_format_complete"];
      }
      
      private function showElfCamp() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         removeElfBgUnit();
         _loc2_ = 0;
         while(_loc2_ < MiningCheckFormatMediator.defendElfVOVec.length)
         {
            if(MiningCheckFormatMediator.defendElfVOVec[_loc2_] != null)
            {
               _loc1_ = new ElfBgUnitUI();
               _loc1_.touchable = false;
               _loc1_.identify = "出战";
               if(isLoot)
               {
                  _loc1_.identify2 = "王者之路";
                  LogUtil("抢夺矿显示血量");
               }
               _loc1_.name = "i";
               _loc1_.x = 100 * _loc2_ + 31;
               _loc1_.y = 190;
               var _loc3_:* = 0.8;
               _loc1_.scaleY = _loc3_;
               _loc1_.scaleX = _loc3_;
               _loc1_.myElfVo = MiningCheckFormatMediator.defendElfVOVec[_loc2_];
               _loc1_.switchContain(true);
               miningCheckFormatUI.spr_campInfo.addChild(_loc1_);
               defendElfBgUnitVec.push(_loc1_);
            }
            _loc2_++;
         }
      }
      
      private function removeElfBgUnit() : void
      {
         var _loc1_:* = 0;
         _loc1_ = defendElfBgUnitVec.length - 1;
         while(_loc1_ >= 0)
         {
            (defendElfBgUnitVec[_loc1_] as ElfBgUnitUI).removeFromParent(true);
            defendElfBgUnitVec.splice(_loc1_,1);
            _loc1_--;
         }
      }
      
      private function collectElfCamp(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         isAllDie = true;
         initFormationElfVec();
         if(param1.spiritInfoArr)
         {
            _loc2_ = param1.spiritInfoArr;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = GetElfFactor.getElfVO(_loc2_[_loc4_].spId,false);
               _loc3_.lv = _loc2_[_loc4_].lv;
               _loc3_.currentHp = _loc2_[_loc4_].hp;
               _loc3_.totalHp = _loc2_[_loc4_].zHp;
               _loc3_.power = _loc2_[_loc4_].attack;
               CalculatorFactor.calculatorElf(_loc3_);
               MiningCheckFormatMediator.defendElfVOVec[_loc4_] = _loc3_;
               if(_loc3_.currentHp > 0)
               {
                  isAllDie = false;
               }
               _loc4_++;
            }
            LogUtil("挖矿精灵阵容简略信息");
         }
         else if(param1.spirits)
         {
            _loc2_ = param1.spirits;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc3_ = GetElfFromSever.getElfInfo(_loc2_[_loc5_]);
               MiningCheckFormatMediator.defendElfVOVec[_loc5_] = _loc3_;
               if(_loc3_.currentHp > 0)
               {
                  isAllDie = false;
               }
               _loc5_++;
            }
            LogUtil("挖矿精灵阵容详细信息");
         }
         showElfCamp();
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         MiningCheckFormatMediator.defendElfVOVec = null;
         facade.removeMediator("MiningCheckFormatMediator");
         UI.dispose();
         viewComponent = null;
      }
   }
}
