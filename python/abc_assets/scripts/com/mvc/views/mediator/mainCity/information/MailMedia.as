package com.mvc.views.mediator.mainCity.information
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.information.MailUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.RewardHandle;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.information.InformationPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.NullContentTip;
   import com.common.util.DisposeDisplay;
   import com.common.util.strHandler.StrHandle;
   import starling.display.Image;
   import feathers.data.ListCollection;
   import feathers.controls.List;
   
   public class MailMedia extends Mediator
   {
      
      public static const NAME:String = "MailMedia";
      
      public static var isNew:Boolean;
       
      public var mail:MailUI;
      
      private var index:int;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function MailMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("MailMedia",param1);
         mail = param1 as MailUI;
         mail.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(mail.getBtn !== _loc2_)
         {
            if(mail.delectBtn === _loc2_)
            {
               (facade.retrieveProxy("InformationPro") as InformationPro).write4202(mail.myMailVo.mainId,index);
            }
         }
         else
         {
            if(!RewardHandle.isHasSpace)
            {
               Tips.show("电脑空间不足，无法领取奖励");
            }
            (facade.retrieveProxy("InformationPro") as InformationPro).write4201(mail.myMailVo.mainId,index);
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_MAIL" !== _loc2_)
         {
            if("SEND_DEL_MAIL" === _loc2_)
            {
               delectMail();
            }
         }
         else if(InformationPro.mailVec.length != 0)
         {
            if(NullContentTip.instance)
            {
               NullContentTip.getInstance().disposeNullMailTip();
            }
            showMail();
            mail.spr_descise.visible = true;
         }
         else
         {
            mail.spr_descise.visible = false;
            NullContentTip.getInstance().showNullMailTip("邮件空空如也。",mail.spr_mail);
         }
      }
      
      private function showMail() : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc5_ = 0;
         while(_loc5_ < InformationPro.mailVec.length)
         {
            _loc2_ = StrHandle.getLen(InformationPro.mailVec[_loc5_].title,7,true,20,"#43281D");
            _loc6_ = "<font color=\'#43281D\' size=\'20\'> " + InformationPro.mailVec[_loc5_].getTime + "</font>";
            _loc3_ = mail.getIcon();
            _loc1_.push({
               "icon":_loc3_,
               "label":_loc2_ + "\n" + _loc6_
            });
            displayVec.push(_loc3_);
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         mail.mailList.dataProvider = _loc4_;
         mail.mailList.addEventListener("change",list_changeHandler);
         mail.mailList.selectedIndex = 0;
      }
      
      private function delectMail() : void
      {
         InformationPro.mailVec.splice(index,1);
         mail.mailList.dataProvider.removeItemAt(index);
         if(InformationPro.mailVec.length == 0)
         {
            mail.getBtn.visible = false;
            mail.delectBtn.visible = false;
            mail.mailStr.text = "";
            mail.sender.text = "";
            mail.mailTitle.text = "";
            mail.scrollContainer.removeChildren(0,-1,true);
         }
         else
         {
            mail.mailList.selectedIndex = 0;
         }
         if(InformationPro.mailVec.length == 0)
         {
            mail.spr_descise.visible = false;
            NullContentTip.getInstance().showNullMailTip("邮件空空如也。",mail.spr_mail);
         }
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex >= 0)
         {
            index = _loc2_.selectedIndex;
            mail.myMailVo = InformationPro.mailVec[index];
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_MAIL","SEND_DEL_MAIL"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         LogUtil("displayVec 123312==   ",displayVec);
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("MailMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
