package com.mvc.views.mediator.mainCity.scoreShop
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.scoreShop.FreeSelectElfUI;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.mediator.mainCity.kingKwan.KingKwanMedia;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   import com.common.util.NullContentTip;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import starling.display.DisplayObject;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   
   public class FreeSelectElfMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "FreeSelectElfMediator";
       
      public var freeSelectElfUI:FreeSelectElfUI;
      
      private var freeShopElfVec:Vector.<ElfVO>;
      
      private var nowFreeElfIdArr:Array;
      
      private var allFreeElfIdArr:Array;
      
      private var isKingElf:Boolean;
      
      private var isComElf:Boolean;
      
      public function FreeSelectElfMediator(param1:Object = null)
      {
         nowFreeElfIdArr = [];
         allFreeElfIdArr = [];
         super("FreeSelectElfMediator",param1);
         freeSelectElfUI = param1 as FreeSelectElfUI;
         freeSelectElfUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = param1.target;
         if(freeSelectElfUI.btn_close !== _loc4_)
         {
            if(freeSelectElfUI.btn_freeBtn === _loc4_)
            {
               nowFreeElfIdArr = [];
               _loc2_ = 0;
               while(_loc2_ < freeSelectElfUI.elfBgUnitUIVec.length)
               {
                  if(freeSelectElfUI.elfBgUnitUIVec[_loc2_].tick.visible)
                  {
                     nowFreeElfIdArr.push(freeSelectElfUI.elfBgUnitUIVec[_loc2_]._elfVO.id);
                  }
                  _loc2_++;
               }
               if(nowFreeElfIdArr.length)
               {
                  _loc3_ = Alert.show("确定放生精灵？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc3_.addEventListener("close",freeElf);
               }
               else
               {
                  Tips.show("亲，还没选择精灵呢。");
               }
            }
         }
         else
         {
            updateElf();
            sendNotification("freeshop_close_select_elf");
            freeSelectElfUI.elfList.removeFromParent();
            WinTweens.closeWin(freeSelectElfUI.spr_selectElf,removeWindow);
         }
      }
      
      private function updateElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         isKingElf = false;
         isComElf = false;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.comElfVec.length)
         {
            if(allFreeElfIdArr.indexOf(PlayerVO.comElfVec[_loc1_].id) != -1)
            {
               PlayerVO.comElfVec.splice(_loc1_,1);
               _loc1_--;
               isComElf = true;
            }
            _loc1_++;
         }
         if(isComElf)
         {
            if(facade.hasMediator("ElfSeriesMedia"))
            {
               sendNotification("CLEAN_PLAYELF");
               sendNotification("CLEAN_ELFSERIES_FORMATIONELF");
               LogUtil("更新联盟大赛的精灵");
            }
            if(facade.hasMediator("PVPBgMediator"))
            {
               LogUtil("更新PVP的精灵");
               sendNotification("CLEAN_PLAYELF");
            }
         }
         _loc2_ = 0;
         while(_loc2_ < KingKwanMedia.kingPlayElf.length)
         {
            if(allFreeElfIdArr.indexOf(KingKwanMedia.kingPlayElf[_loc2_].id) != -1)
            {
               KingKwanMedia.kingPlayElf.splice(_loc2_,1);
               _loc2_--;
               isKingElf = true;
            }
            _loc2_++;
         }
         if(isKingElf && facade.hasMediator("KingKwanMedia"))
         {
            sendNotification("CLEAN_PLAYELF");
         }
         allFreeElfIdArr = [];
      }
      
      private function freeElf(param1:Event, param2:Object) : void
      {
         if(param2.label == "确定")
         {
            (facade.retrieveProxy("HomePro") as HomePro).write2804(nowFreeElfIdArr);
         }
      }
      
      private function removeWindow() : void
      {
         sendNotification("switch_win",null);
         if(freeShopElfVec.length == 0)
         {
            if(NullContentTip.instance)
            {
               NullContentTip.getInstance().disposeNullMailTip();
            }
         }
         freeSelectElfUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc8_:* = param1.getName();
         if("freeshop_update_elf_list" !== _loc8_)
         {
            if("freeshop_free_elf_success" !== _loc8_)
            {
               if("freeshop_free_elf_fail" !== _loc8_)
               {
                  if("freeshop_touch_complete" === _loc8_)
                  {
                     _loc4_ = param1.getBody() as ElfBgUnitUI;
                     _loc5_ = _loc4_._elfVO;
                     if(_loc4_.tick.visible)
                     {
                        _loc7_ = freeSelectElfUI.tf_selectElfNum.text;
                        _loc2_ = freeSelectElfUI.tf_getFreeScore.text;
                        freeSelectElfUI.tf_selectElfNum.text = _loc7_ + 1;
                        freeSelectElfUI.tf_getFreeScore.text = _loc2_ + _loc5_.freePoints;
                     }
                     else
                     {
                        _loc7_ = freeSelectElfUI.tf_selectElfNum.text;
                        _loc2_ = freeSelectElfUI.tf_getFreeScore.text;
                        freeSelectElfUI.tf_selectElfNum.text = _loc7_ - 1;
                        freeSelectElfUI.tf_getFreeScore.text = _loc2_ - _loc5_.freePoints;
                     }
                  }
               }
               else
               {
                  LogUtil("、、、、、、、、、、、、、、、、、、、、、、、、、、、、、放生精灵失败，有清除精灵勾勾？");
                  _loc6_ = freeSelectElfUI.elfBgUnitUIVec.length - 1;
                  while(_loc6_ >= 0)
                  {
                     if(freeSelectElfUI.elfBgUnitUIVec[_loc6_].tick.visible)
                     {
                        freeSelectElfUI.elfBgUnitUIVec[_loc6_].tick.visible = false;
                     }
                     _loc6_--;
                  }
                  freeSelectElfUI.tf_selectElfNum.text = "0";
                  freeSelectElfUI.tf_getFreeScore.text = "0";
               }
            }
            else
            {
               _loc3_ = freeShopElfVec.length - 1;
               while(_loc3_ >= 0)
               {
                  if(freeSelectElfUI.elfBgUnitUIVec[_loc3_].tick.visible)
                  {
                     allFreeElfIdArr.push(freeSelectElfUI.elfBgUnitUIVec[_loc3_]._elfVO.id);
                     freeShopElfVec.splice(_loc3_,1);
                  }
                  _loc3_--;
               }
               freeSelectElfUI.addElfBgUI(freeShopElfVec);
               if(freeShopElfVec.length == 0)
               {
                  NullContentTip.getInstance().showNullMailTip("没有可放生精灵。",freeSelectElfUI.spr_selectElf,-100);
               }
               freeSelectElfUI.tf_haveFreeScore.text = PlayerVO.fsDot;
               freeSelectElfUI.tf_selectElfNum.text = "0";
               freeSelectElfUI.tf_getFreeScore.text = "0";
            }
         }
         else
         {
            freeShopElfVec = param1.getBody() as Vector.<ElfVO>;
            LogUtil("freeShopElfVec:长度 " + freeShopElfVec.length);
            if(freeShopElfVec.length == 0)
            {
               NullContentTip.getInstance().showNullMailTip("没有可放生精灵。",freeSelectElfUI.spr_selectElf,-100);
            }
            else
            {
               freeSelectElfUI.addElfBgUI(freeShopElfVec);
            }
            freeSelectElfUI.tf_selectElfNum.text = "0";
            freeSelectElfUI.tf_getFreeScore.text = "0";
            freeSelectElfUI.tf_haveFreeScore.text = PlayerVO.fsDot;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["freeshop_update_elf_list","freeshop_free_elf_success","freeshop_touch_complete","freeshop_free_elf_fail"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            updateElf();
            if(freeShopElfVec.length == 0)
            {
               if(NullContentTip.instance)
               {
                  NullContentTip.getInstance().disposeNullMailTip();
               }
            }
         }
         freeSelectElfUI.removeElfBgUnitUI();
         freeSelectElfUI.elfBgUnitUIVec = null;
         facade.removeMediator("FreeSelectElfMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
