package com.mvc.views.mediator.union.unionHall
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionHall.UnionHallUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.WinTweens;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.mvc.views.uis.union.unionHall.UnionHelpUI;
   import com.mvc.views.uis.worldHorn.WorldTime;
   import com.common.themes.Tips;
   import com.mvc.views.uis.union.unionHall.Setting;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.vos.union.UnionMemberVO;
   import com.common.consts.ConfigConst;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.GetCommon;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.union.unionHall.HallListUnit;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionHallMedia extends Mediator
   {
      
      public static const NAME:String = "UnionHallMedia";
      
      public static var index:int;
       
      public var unionHall:UnionHallUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function UnionHallMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("UnionHallMedia",param1);
         unionHall = param1 as UnionHallUI;
         unionHall.addEventListener("triggered",triggeredHandler);
         unionHall.setting.addEventListener("change",oncheck);
      }
      
      private function oncheck(param1:Event) : void
      {
         trace("监听单选框的状态== ",unionHall.setting.isSelected);
         (facade.retrieveProxy("UnionPro") as UnionPro).write3414(unionHall.setting.isSelected);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = param1.target;
         if(unionHall.btn_close !== _loc4_)
         {
            if(unionHall.btn_allReject !== _loc4_)
            {
               if(unionHall.btn_check !== _loc4_)
               {
                  if(unionHall.btn_exitUnion !== _loc4_)
                  {
                     if(unionHall.btn_help !== _loc4_)
                     {
                        if(unionHall.btn_hiring !== _loc4_)
                        {
                           if(unionHall.btn_member !== _loc4_)
                           {
                              if(unionHall.btn_setting === _loc4_)
                              {
                                 unionHall.addChild(Setting.getInstance());
                              }
                           }
                           else
                           {
                              unionHall.switchBtn();
                              showMember();
                           }
                        }
                        else
                        {
                           if(WorldTime.unionHirTime > 0)
                           {
                              return Tips.show("距离下一次发言还有 " + WorldTime.unionHirTime + " 秒");
                           }
                           WorldTime.unionHirTime = 30;
                           (facade.retrieveProxy("UnionPro") as UnionPro).write3412();
                        }
                     }
                     else
                     {
                        unionHall.addChild(UnionHelpUI.getInstance());
                     }
                  }
                  else
                  {
                     _loc2_ = Alert.show("退出公会后当天申请其他公会需要100钻石，确定要退会么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                     _loc2_.addEventListener("close",exitUnion);
                  }
               }
               else
               {
                  LogUtil("审核==");
                  unionHall.switchBtn();
                  if(UnionPro.myUnionVO.isApply)
                  {
                     (facade.retrieveProxy("UnionPro") as UnionPro).write3411();
                  }
                  else
                  {
                     showApply();
                  }
               }
            }
            else
            {
               _loc3_ = Alert.show("您确定要全部拒绝么？","",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc3_.addEventListener("close",allReject);
            }
         }
         else
         {
            if(unionHall.hallList.dataProvider)
            {
               unionHall.hallList.dataProvider.removeAll();
            }
            WinTweens.closeWin(unionHall.spr_unionHall,remove);
         }
      }
      
      private function allReject(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("REJECT_SUCCESS",rejectOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3408(null,true);
         }
      }
      
      private function rejectOK(param1:Event) : void
      {
         EventCenter.removeEventListener("REJECT_SUCCESS",rejectOK);
         if(param1.data)
         {
            UnionPro.applyUnionVec = Vector.<UnionMemberVO>([]);
         }
         else
         {
            UnionPro.applyUnionVec.splice(index,1);
         }
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_APPLY);
      }
      
      private function exitUnion(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            (facade.retrieveProxy("UnionPro") as UnionPro).write3402();
         }
      }
      
      private function remove() : void
      {
         WinTweens.showCity();
         unionHall.clean();
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_UNION_HALLL !== _loc2_)
         {
            if(ConfigConst.EXIT_UNION_SUCCESS !== _loc2_)
            {
               if(ConfigConst.SHOW_UNION_APPLY !== _loc2_)
               {
                  if(ConfigConst.SEND_UNION_APPLY === _loc2_)
                  {
                     if(GetCommon.isIOSDied())
                     {
                        return;
                     }
                     ((unionHall.btn_check.skin as Sprite).getChildByName("promptImg") as SwfImage).visible = true;
                  }
               }
               else
               {
                  showApply();
               }
            }
            else
            {
               if(GetCommon.isIOSDied())
               {
                  return;
               }
               remove();
               sendNotification("switch_page","load_maincity_page");
            }
         }
         else
         {
            if(GetCommon.isIOSDied())
            {
               return;
            }
            showMember();
            unionHall.showInfo();
         }
      }
      
      private function showApply() : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(unionHall.hallList.dataProvider)
         {
            unionHall.hallList.dataProvider.removeAll();
         }
         LogUtil("UnionPro.applyUnionVec.length==",UnionPro.applyUnionVec.length);
         if(UnionPro.applyUnionVec.length == 0)
         {
            unionHall.spr_unionHall.addChild(unionHall.noApply);
            LogUtil("显示没有申请的文本");
            ((unionHall.btn_check.skin as Sprite).getChildByName("promptImg") as SwfImage).visible = false;
            UnionPro.myUnionVO.isApply = false;
            return;
         }
         if(unionHall.noApply.parent)
         {
            unionHall.noApply.removeFromParent();
         }
         LogUtil("不显示没有申请的文本");
         var _loc1_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < UnionPro.applyUnionVec.length)
         {
            _loc4_ = new HallListUnit(3);
            _loc4_.index = _loc3_;
            _loc4_.applyVo = UnionPro.applyUnionVec[_loc3_];
            _loc1_.push({
               "icon":_loc4_,
               "label":""
            });
            displayVec.push(_loc4_);
            _loc3_++;
         }
         var _loc2_:ListCollection = new ListCollection(_loc1_);
         unionHall.hallList.dataProvider = _loc2_;
      }
      
      private function showMember() : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(unionHall.hallList.dataProvider)
         {
            unionHall.hallList.dataProvider.removeAll();
         }
         if(unionHall.noApply.parent)
         {
            unionHall.noApply.removeFromParent();
         }
         var _loc1_:Array = [];
         LogUtil("UnionPro.unionMemberVec.length===",UnionPro.unionMemberVec.length);
         _loc3_ = 0;
         while(_loc3_ < UnionPro.unionMemberVec.length)
         {
            if(UnionPro.unionMemberVec[_loc3_])
            {
               _loc5_ = new HallListUnit();
               _loc5_.index = _loc3_;
               _loc5_.memberVo = UnionPro.unionMemberVec[_loc3_];
               _loc1_.push({
                  "icon":_loc5_,
                  "label":""
               });
               displayVec.push(_loc5_);
            }
            else
            {
               _loc4_ = new HallListUnit(2);
               _loc4_.index = _loc3_;
               _loc4_.settingBtnVo = UnionPro.unionMemberVec[_loc3_ - 1];
               _loc1_.push({
                  "icon":_loc4_,
                  "label":""
               });
               displayVec.push(_loc4_);
            }
            _loc3_++;
         }
         var _loc2_:ListCollection = new ListCollection(_loc1_);
         unionHall.hallList.dataProvider = _loc2_;
         if(unionHall.hallList.dataProvider)
         {
            unionHall.hallList.scrollToDisplayIndex(index);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_UNION_HALLL,ConfigConst.EXIT_UNION_SUCCESS,ConfigConst.SHOW_UNION_APPLY,ConfigConst.SEND_UNION_APPLY];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(Setting.instance)
            {
               Setting.getInstance().remove();
            }
            if(UnionHelpUI.instance)
            {
               UnionHelpUI.getInstance().remove();
            }
         }
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("UnionHallMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.unionHallAssets);
      }
   }
}
