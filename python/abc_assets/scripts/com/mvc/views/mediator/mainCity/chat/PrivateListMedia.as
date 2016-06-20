package com.mvc.views.mediator.mainCity.chat
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.chat.PrivateListUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.display.Image;
   import com.common.util.SomeFontHandler;
   import lzm.starling.swf.display.SwfSprite;
   import com.common.util.strHandler.StrHandle;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.display.Quad;
   import starling.events.Touch;
   import feathers.controls.List;
   
   public class PrivateListMedia extends Mediator
   {
      
      public static const NAME:String = "PrivateListMedia";
       
      public var privateList:PrivateListUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function PrivateListMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PrivateListMedia",param1);
         privateList = param1 as PrivateListUI;
         privateList.addEventListener("triggered",clickHandler);
         privateList.chatList.addEventListener("change",list_changeHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if("" !== _loc2_)
         {
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_CHAT_LIST" === _loc2_)
         {
            showList();
         }
      }
      
      private function showList() : void
      {
         var _loc7_:* = 0;
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc9_:* = null;
         var _loc8_:* = null;
         var _loc10_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc7_ = 0;
         while(_loc7_ < GetPrivateDate.privateChatVec.length)
         {
            _loc4_ = GetPrivateDate.privateChatVec[_loc7_][0];
            _loc3_ = GetPlayerRelatedPicFactor.getHeadPic(_loc4_.headPtId,0.75);
            _loc9_ = SomeFontHandler.setColoeSize(_loc4_.userName,30);
            _loc8_ = GetPrivateDate.privateChatVec[_loc7_][GetPrivateDate.privateChatVec[_loc7_].length - 1];
            _loc10_ = privateList.getNotReadSpr(_loc4_,_loc8_);
            if(GetPrivateDate.privateChatVec[_loc7_].length > 1)
            {
               _loc2_ = _loc8_.msg;
            }
            else
            {
               _loc2_ = "暂无聊天记录";
            }
            _loc5_ = {};
            _loc5_["icon"] = _loc3_;
            _loc5_["label"] = _loc9_ + "\n" + StrHandle.getLen(_loc2_,17,true);
            _loc5_["accessory"] = _loc10_;
            _loc5_["time"] = _loc8_.newTime;
            _loc5_["useId"] = _loc4_.userId;
            _loc1_.push(_loc5_);
            displayVec.push(_loc3_,_loc10_);
            _loc7_++;
         }
         sortTime(_loc1_);
         var _loc6_:ListCollection = new ListCollection(_loc1_);
         privateList.chatList.dataProvider = _loc6_;
      }
      
      private function sortTime(param1:Array) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc2_:* = null;
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length - _loc3_)
            {
               if(param1[_loc4_].time < param1[_loc4_ + 1].time)
               {
                  _loc2_ = param1[_loc4_];
                  param1[_loc4_] = param1[_loc4_ + 1];
                  param1[_loc4_ + 1] = _loc2_;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc3_:* = 0;
         var _loc2_:Touch = param1.getTouch(param1.target as Quad);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               LogUtil("name=" + (param1.target as Quad).name);
               _loc3_ = (param1.target as Quad).name;
            }
         }
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc5_:List = List(param1.currentTarget);
         var _loc3_:int = _loc5_.selectedIndex;
         if(_loc3_ < 0)
         {
            return;
         }
         var _loc2_:Object = privateList.chatList.dataProvider.getItemAt(_loc3_);
         LogUtil("选中的联系人- ",_loc2_.label,_loc2_.useId);
         var _loc4_:int = GetPrivateDate.getChatVec(_loc2_.useId);
         privateList.removeFromParent();
         sendNotification("SHOW_CHAT_INDEX",1);
         GetPrivateDate.privateChatVec[_loc4_][0].notReadNum = 0;
         sendNotification("SEND_PRIVATE_DATA",GetPrivateDate.privateChatVec[_loc4_][0]);
         sendNotification("SHOW_PRIVATE_ALONE",GetPrivateDate.privateChatVec[_loc4_]);
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_CHAT_LIST"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("PrivateListMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
