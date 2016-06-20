package com.mvc.views.mediator.login
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.login.ServerListUI;
   import starling.display.DisplayObject;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import lzm.util.LSOManager;
   import feathers.data.ListCollection;
   import starling.events.Event;
   import feathers.controls.List;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import com.mvc.views.uis.login.Server2UnitUI;
   import lzm.starling.display.Button;
   import com.mvc.views.uis.login.ServerUintUI;
   import com.mvc.models.vos.login.ServerVO;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import org.puremvc.as3.interfaces.INotification;
   
   public class ServerListMedia extends Mediator
   {
      
      public static const NAME:String = "ServerListMedia";
       
      public var serverList:ServerListUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function ServerListMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("ServerListMedia",param1);
         serverList = param1 as ServerListUI;
         serverList.last_region.addEventListener("touch",clickHandler);
         showSeleSer();
         showMyServer();
      }
      
      private function clickHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(serverList.last_region);
         if(_loc2_ && _loc2_.phase == "began")
         {
            remove();
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         serverList.removeFromParent();
         LoginMedia.lastLoginAdress = LSOManager.get("LASTLOGIN");
         LoginMedia.serverId = LSOManager.get("SERVERID");
         LoginMedia.serverIp = LSOManager.get("SERVERIP");
         LoginMedia.serverName = LSOManager.get("SERVERNAME");
         LoginMedia.serverProt = LSOManager.get("PORT");
         sendNotification("UPDATE_NOW_SERVER");
      }
      
      public function showSeleSer() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc1_:Array = [];
         var _loc5_:int = Math.floor(LoginMedia.serverVec.length / 10);
         LogUtil("LoginMedia.serverVec.length = ",LoginMedia.serverVec.length,_loc5_,_loc5_ % 10);
         if(LoginMedia.serverVec.length % 10 != 0 || _loc5_ == 0)
         {
            _loc5_++;
         }
         LogUtil("seleNum == ",_loc5_);
         _loc4_ = _loc5_ + 1;
         while(_loc4_ > 0)
         {
            if(_loc4_ == _loc5_ + 1)
            {
               _loc2_ = "<font size=\'20\'>       推荐</font>";
            }
            else
            {
               _loc2_ = "<font size=\'20\'>" + amend(_loc4_ - 1,true) + "-" + amend(_loc4_) + "</font>";
            }
            _loc1_.push({"label":_loc2_});
            _loc4_--;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         serverList.seleList.dataProvider = _loc3_;
         serverList.seleList.selectedIndex = 0;
         serverList.seleList.addEventListener("change",list_changeHandler);
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == 0)
         {
            showMyServer();
         }
         if(_loc2_.selectedIndex >= 1)
         {
            showServer(_loc2_.selectedIndex - 1);
         }
      }
      
      public function amend(param1:int, param2:Boolean = false) : String
      {
         if(param2)
         {
            if(param1 < 10)
            {
               return "     " + param1 + "1";
            }
            if(param1 < 100 && param1 >= 10)
            {
               return "   " + param1 + "1";
            }
            return "1";
         }
         return param1 + "0区";
      }
      
      public function showMyServer() : void
      {
         var _loc7_:* = 0;
         var _loc4_:* = null;
         var _loc8_:* = 0;
         var _loc10_:* = null;
         var _loc11_:* = null;
         serverList.setype(true);
         if(serverList.areaList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            serverList.areaList.dataProvider.removeAll();
            serverList.areaList.dataProvider = null;
         }
         if(serverList.myList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            serverList.myList.dataProvider.removeAll();
            serverList.myList.dataProvider = null;
         }
         var _loc1_:Array = [];
         var _loc6_:int = LoginMedia.myServerVec.length;
         var _loc2_:* = 3;
         var _loc9_:* = 3;
         var _loc3_:int = Math.floor(_loc6_ / _loc9_);
         if(_loc6_ % _loc9_ != 0)
         {
            _loc3_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            _loc4_ = new Sprite();
            if(_loc7_ == _loc3_ - 1 && _loc6_ % _loc9_ != 0)
            {
               _loc2_ = _loc6_ % _loc9_;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc2_)
            {
               _loc10_ = new Server2UnitUI();
               _loc10_.index = _loc9_ * _loc7_ + _loc8_;
               _loc10_.myServerVo = LoginMedia.myServerVec[_loc9_ * _loc7_ + _loc8_];
               _loc11_ = new Button(_loc10_);
               _loc11_.name = "私服" + (_loc9_ * _loc7_ + _loc8_);
               _loc11_.x = 235 * _loc8_;
               _loc11_.addEventListener("triggered",onclick);
               _loc4_.addChild(_loc11_);
               displayVec.push(_loc10_);
               _loc8_++;
            }
            _loc1_.push({
               "icon":_loc4_,
               "label":""
            });
            _loc7_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         serverList.myList.dataProvider = _loc5_;
      }
      
      public function showServer(param1:int) : void
      {
         var _loc12_:* = 0;
         var _loc7_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc6_:* = 0;
         var _loc8_:* = null;
         var _loc13_:* = null;
         serverList.setype(false);
         if(serverList.areaList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            serverList.areaList.dataProvider.removeAll();
            serverList.areaList.dataProvider = null;
         }
         if(serverList.myList.dataProvider)
         {
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
            serverList.myList.dataProvider.removeAll();
            serverList.myList.dataProvider = null;
         }
         var _loc2_:Array = [];
         var _loc11_:int = showNum(param1);
         var _loc9_:* = 2;
         var _loc10_:int = Math.floor(_loc11_ / 2);
         _loc7_ = 0;
         while(_loc7_ < param1)
         {
            _loc12_ = _loc12_ + showNum(_loc7_);
            _loc7_++;
         }
         if(_loc11_ % 2 != 0)
         {
            _loc10_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc10_)
         {
            _loc3_ = new Sprite();
            if(_loc5_ == _loc10_ - 1 && _loc11_ % 2 != 0)
            {
               _loc9_ = _loc11_ % 2;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc9_)
            {
               _loc8_ = new ServerUintUI();
               _loc8_.index = 2 * _loc5_ + _loc6_ + _loc12_;
               _loc8_.myServer = LoginMedia.serverVec[2 * _loc5_ + _loc6_ + _loc12_];
               _loc13_ = new Button(_loc8_);
               _loc13_.name = "官方" + (2 * _loc5_ + _loc6_ + _loc12_);
               _loc13_.x = 338 * _loc6_;
               _loc13_.addEventListener("triggered",onclick);
               _loc3_.addChild(_loc13_);
               displayVec.push(_loc8_);
               _loc6_++;
            }
            _loc2_.push({
               "icon":_loc3_,
               "label":""
            });
            _loc5_++;
         }
         var _loc4_:ListCollection = new ListCollection(_loc2_);
         serverList.areaList.dataProvider = _loc4_;
      }
      
      private function showNum(param1:int) : int
      {
         if(LoginMedia.serverVec.length > 10)
         {
            if(param1 == 0 && LoginMedia.serverVec.length % 10 != 0)
            {
               return LoginMedia.serverVec.length % 10;
            }
            return 10;
         }
         return LoginMedia.serverVec.length;
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc3_:int = (param1.currentTarget as Button).name.substr(2);
         var _loc2_:String = (param1.currentTarget as Button).name.substr(0,2);
         LogUtil("i=" + _loc3_,"belong=" + _loc2_);
         if(_loc2_ == "官方")
         {
            seleSerVer(LoginMedia.serverVec,_loc3_);
         }
         else
         {
            seleSerVer(LoginMedia.myServerVec,_loc3_);
         }
      }
      
      public function seleSerVer(param1:Vector.<ServerVO>, param2:int) : void
      {
         if(param1[param2].isFix)
         {
            Tips.show("【" + param1[param2].serverId + "区  " + param1[param2].serverName + "】正在维护");
            return;
         }
         if(param1[param2].forbid)
         {
            Tips.show("你在【" + param1[param2].serverId + "区  " + param1[param2].serverName + "】的账户已被冻结");
            return;
         }
         if(param1[param2].isBusy)
         {
            Tips.show("【" + param1[param2].serverId + "区  " + param1[param2].serverName + "】暂时有很多人在拥挤呢，去别的区逛逛吧");
            return;
         }
         LoginMedia.lastLoginAdress = param1[param2].serverId + "区    " + param1[param2].serverName;
         LoginMedia.serverId = param1[param2].serverId;
         LoginMedia.serverIp = param1[param2].serverIp;
         LoginMedia.serverName = param1[param2].serverName;
         LoginMedia.serverProt = param1[param2].serverProt;
         Facade.getInstance().sendNotification("UPDATE_NOW_SERVER");
         serverList.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("ClOSE_SERVER" !== _loc2_)
         {
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["ClOSE_SERVER"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("ServerListMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
