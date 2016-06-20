package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.pvp.PVPPracticePreUI;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.themes.Tips;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.common.util.NullContentTip;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.display.Image;
   import com.mvc.views.uis.mainCity.pvp.PVPPracticeUI;
   import com.mvc.models.vos.login.PlayerVO;
   
   public class PVPPracticePreMediaor extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPPracticePreMediaor";
       
      public var pvpPracticePreUI:PVPPracticePreUI;
      
      private var listData:ListCollection;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var pageCount:int;
      
      public function PVPPracticePreMediaor(param1:Object = null)
      {
         super("PVPPracticePreMediaor",param1);
         pvpPracticePreUI = param1 as PVPPracticePreUI;
         pvpPracticePreUI.addEventListener("triggered",triggeredHandler);
         displayVec = new Vector.<DisplayObject>([]);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpPracticePreUI.quickStartBtn !== _loc2_)
         {
            if(pvpPracticePreUI.createRoomBtn !== _loc2_)
            {
               if(pvpPracticePreUI.leftBtn !== _loc2_)
               {
                  if(pvpPracticePreUI.rightBtn !== _loc2_)
                  {
                     if(pvpPracticePreUI.searchBtn !== _loc2_)
                     {
                        if(pvpPracticePreUI.refreshBtn === _loc2_)
                        {
                           (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6201(PVPPro.pageIndexNow);
                        }
                     }
                     else
                     {
                        if(pvpPracticePreUI.inputSearch.text == "")
                        {
                           Tips.show("亲，房号不能为空哦。");
                        }
                        else
                        {
                           (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6011(pvpPracticePreUI.inputSearch.text);
                        }
                        pvpPracticePreUI.inputSearch.text = "";
                     }
                  }
                  else
                  {
                     (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6201(PVPPro.pageIndexNow + 1);
                  }
               }
               else
               {
                  (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6201(PVPPro.pageIndexNow - 1);
               }
            }
            else
            {
               sendNotification("switch_win",pvpPracticePreUI,"load_pvp_croom");
            }
         }
         else
         {
            (facade.retrieveProxy("PVPPro") as PVPPro).write6203();
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc13_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc10_:* = null;
         var _loc11_:* = false;
         var _loc9_:* = null;
         var _loc12_:* = false;
         var _loc8_:* = null;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc14_:* = param1.getName();
         if("update_pvpprapre_roomlist" !== _loc14_)
         {
            if("add_pvp_practice" === _loc14_)
            {
               showPractice();
            }
         }
         else
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            if(listData)
            {
               listData.removeAll();
            }
            else
            {
               listData = new ListCollection();
            }
            _loc13_ = param1.getBody();
            pageCount = _loc13_.pageCount;
            if(!_loc13_.hasOwnProperty("roomInfo"))
            {
               updateChangePageInfo();
               NullContentTip.getInstance().showNullMailTip("房间空空如也。",pvpPracticePreUI.spr_practicePrepare,150,50);
               return;
            }
            if(NullContentTip.instance)
            {
               NullContentTip.getInstance().disposeNullMailTip();
            }
            _loc3_ = 0;
            while(_loc3_ < _loc13_.roomInfo.length)
            {
               _loc4_ = _loc13_.roomInfo[_loc3_].roomId;
               _loc5_ = _loc13_.roomInfo[_loc3_].roomName;
               _loc10_ = _loc13_.roomInfo[_loc3_].roomMasterName;
               _loc11_ = _loc13_.roomInfo[_loc3_].isPsw;
               _loc9_ = _loc13_.roomInfo[_loc3_].psw;
               _loc12_ = _loc13_.roomInfo[_loc3_].isFull;
               _loc8_ = _loc12_?"（2/2）":"（1/2）";
               _loc2_ = new Sprite();
               _loc6_ = pvpPracticePreUI.createAddBtn();
               _loc6_.name = _loc3_;
               _loc6_.addEventListener("triggered",addBtn_triggeredHandler);
               displayVec.push(_loc6_);
               if(_loc11_)
               {
                  _loc7_ = pvpPracticePreUI.createClockImg();
                  _loc7_.y = 10;
                  displayVec.push(_loc7_);
                  _loc2_.addChild(_loc7_);
                  _loc6_.x = 35;
               }
               _loc2_.addChild(_loc6_);
               listData.push({
                  "label":"房间名：\t" + _loc5_ + "\t" + _loc10_ + _loc8_,
                  "accessory":_loc2_,
                  "roomInfo":_loc13_.roomInfo[_loc3_]
               });
               _loc3_++;
            }
            pvpPracticePreUI.roomList.dataProvider = listData;
            updateChangePageInfo();
         }
      }
      
      private function updateChangePageInfo() : void
      {
         pvpPracticePreUI.pageNumTf.text = "第" + PVPPro.pageIndexNow + "页";
         if(pageCount <= 1)
         {
            pvpPracticePreUI.leftBtn.visible = false;
            pvpPracticePreUI.rightBtn.visible = false;
         }
         else if(PVPPro.pageIndexNow == 1 && pageCount > 1)
         {
            pvpPracticePreUI.leftBtn.visible = false;
            pvpPracticePreUI.rightBtn.visible = true;
         }
         else if(PVPPro.pageIndexNow > 1 && PVPPro.pageIndexNow < pageCount && pageCount > 2)
         {
            pvpPracticePreUI.leftBtn.visible = true;
            pvpPracticePreUI.rightBtn.visible = true;
         }
         else if(PVPPro.pageIndexNow == pageCount && pageCount > 1)
         {
            pvpPracticePreUI.leftBtn.visible = true;
            pvpPracticePreUI.rightBtn.visible = false;
         }
      }
      
      private function addBtn_triggeredHandler(param1:Event) : void
      {
         var _loc2_:int = (param1.target as DisplayObject).name;
         var _loc3_:Object = listData.getItemAt(_loc2_);
         if(_loc3_.roomInfo.isPsw)
         {
            sendNotification("switch_win",pvpPracticePreUI,"load_pvp_check_psw");
            sendNotification("pvp_send_room_data",_loc3_.roomInfo);
         }
         else
         {
            (Facade.getInstance().retrieveProxy("PVPPro") as PVPPro).write6204(_loc3_.roomInfo.roomId);
         }
      }
      
      private function showPractice() : void
      {
         LogUtil("移除准备界面, 加入练习赛房间界面");
         pvpPracticePreUI.spr_practicePrepare.removeFromParent();
         if(!Facade.getInstance().hasMediator("PVPPracticeMediator"))
         {
            Facade.getInstance().registerMediator(new PVPPracticeMediator(new PVPPracticeUI()));
         }
         var _loc1_:PVPPracticeUI = (Facade.getInstance().retrieveMediator("PVPPracticeMediator") as PVPPracticeMediator).UI as PVPPracticeUI;
         _loc1_.showMyElfCamp(PlayerVO.bagElfVec);
         pvpPracticePreUI.addChild(_loc1_);
         PVPBgMediator.isEnterRoom = true;
         PVPBgMediator.pvpFrom = 2;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["update_pvpprapre_roomlist","add_pvp_practice"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(Facade.getInstance().hasMediator("PVPPracticeMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPPracticeMediator") as PVPPracticeMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPCRoomMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPCRoomMediator") as PVPCRoomMediator).dispose();
         }
         if(Facade.getInstance().hasMediator("PVPCheckPswMediator"))
         {
            (Facade.getInstance().retrieveMediator("PVPCheckPswMediator") as PVPCheckPswMediator).dispose();
         }
         if(NullContentTip.instance)
         {
            NullContentTip.getInstance().disposeNullMailTip();
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("PVPPracticePreMediaor");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
