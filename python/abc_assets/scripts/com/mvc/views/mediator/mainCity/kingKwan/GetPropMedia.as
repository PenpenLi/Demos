package com.mvc.views.mediator.mainCity.kingKwan
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.kingKwan.GetPropUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.vos.fighting.FightingConfig;
   import com.mvc.views.uis.mainCity.playerInfo.PlayerUpdateUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.views.uis.mainCity.kingKwan.DropPropUnitUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.models.vos.elf.ElfVO;
   import starling.display.DisplayObject;
   
   public class GetPropMedia extends Mediator
   {
      
      public static const NAME:String = "GetPropMedia";
      
      public static var type:int;
       
      public var getprop:GetPropUI;
      
      private var arr:Array;
      
      public function GetPropMedia(param1:Object = null)
      {
         super("GetPropMedia",param1);
         getprop = param1 as GetPropUI;
         getprop.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(getprop.btn_ok === _loc2_)
         {
            getprop.panel.removeChildren(0,-1,true);
            WinTweens.closeWin(getprop.spr_getRewardBg,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
         if(FightingConfig.isLvUp)
         {
            PlayerUpdateUI.getInstance().show();
         }
         if(FightingConfig.getArr.length)
         {
         }
         if(type == 1)
         {
            sendNotification("switch_page","LOAD_HUNTINGPARTY_PAGE");
         }
         type = 0;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_DROP_PROP" !== _loc2_)
         {
            if("update_drop_tittleImg" === _loc2_)
            {
               getprop.rewardTitleImg.removeFromParent();
               getprop.spr_getRewardBg.addChild(getprop.rewardTitleImg2);
            }
         }
         else
         {
            arr = param1.getBody() as Array;
            showDrop(arr);
            getprop.spr_getRewardBg.addChild(getprop.panel);
         }
      }
      
      private function showDrop(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         LogUtil("道具id数组");
         getprop.panel.removeChildren(0,-1,true);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ % 3 == 0 && _loc3_ != 0)
            {
               _loc4_ = _loc4_ + 1;
            }
            _loc2_ = new DropPropUnitUI();
            if(typeof param1[_loc3_] == "string")
            {
               _loc2_.setOtherAward(param1[_loc3_]);
            }
            else if(param1[_loc3_] is PropVO)
            {
               _loc2_.myPropVo = param1[_loc3_];
            }
            else if(param1[_loc3_] is ElfVO)
            {
               _loc2_.myElfVo = param1[_loc3_];
            }
            if(param1.length == 1)
            {
               _loc2_.x = getprop.panel.width - _loc2_.width >> 1;
               _loc2_.y = getprop.panel.height - _loc2_.height >> 1;
            }
            else if(param1.length == 2)
            {
               _loc2_.x = (getprop.panel.width - _loc2_.width * 2) / 3 + ((getprop.panel.width - _loc2_.width * 2) / 3 + _loc2_.width) * (_loc3_ % 3);
               _loc2_.y = getprop.panel.height - _loc2_.height >> 1;
            }
            else if(param1.length == 3)
            {
               _loc2_.x = (getprop.panel.width - _loc2_.width * 3) / 4 + ((getprop.panel.width - _loc2_.width * 3) / 4 + _loc2_.width) * (_loc3_ % 3);
               _loc2_.y = getprop.panel.height - _loc2_.height >> 1;
            }
            else
            {
               _loc2_.x = (getprop.panel.width - _loc2_.width * 3) / 4 + ((getprop.panel.width - _loc2_.width * 3) / 4 + _loc2_.width) * (_loc3_ % 3);
               _loc2_.y = 145 * _loc4_;
            }
            getprop.panel.addChild(_loc2_);
            _loc3_++;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_DROP_PROP","update_drop_tittleImg"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("GetPropMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
