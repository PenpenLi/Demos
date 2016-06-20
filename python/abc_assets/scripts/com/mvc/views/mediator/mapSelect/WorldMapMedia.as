package com.mvc.views.mediator.mapSelect
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.models.vos.mapSelect.MapVO;
   import com.mvc.views.uis.mapSelect.WorldMapUI;
   import org.puremvc.as3.interfaces.INotification;
   import starling.events.Event;
   import com.mvc.views.uis.mapSelect.SeleLocalUI;
   import starling.display.DisplayObject;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.models.proxy.mapSelect.MapPro;
   
   public class WorldMapMedia extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "BigMapMedia";
      
      public static var mapVO:MapVO;
       
      private var bigMap:WorldMapUI;
      
      public function WorldMapMedia(param1:Object = null)
      {
         super("BigMapMedia",param1);
         bigMap = param1 as WorldMapUI;
         bigMap.addEventListener("triggered",clickHandler);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("load_city_map_page_complete" !== _loc2_)
         {
            if("tell_new_point_open" === _loc2_)
            {
               bigMap.updateOpen();
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["load_city_map_page_complete","tell_new_point_open"];
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1.target == bigMap.returnMainCityBtn)
         {
            sendNotification("switch_page","load_maincity_page");
         }
         else if(param1.target == bigMap.btn_local)
         {
            SeleLocalUI.getInstance().show(0);
         }
         else
         {
            _loc4_ = (param1.target as DisplayObject).name;
            if(_loc4_.indexOf("map") != -1)
            {
               mapVO = GetMapFactor.getMapVoById(_loc4_.substr(3));
               Config.cityScene = mapVO.bgImg;
               if(Config.isOpenAni)
               {
                  _loc5_ = 1;
                  while(_loc5_ <= 15)
                  {
                     if(_loc5_ != _loc4_.substr(3))
                     {
                        bigMap.mySpr.getButton("map" + _loc5_).touchable = false;
                        bigMap.mySpr.getButton("map" + _loc5_).visible = false;
                     }
                     _loc5_++;
                  }
                  bigMap.x = -bigMap.scrollContainer.horizontalScrollPosition;
                  bigMap.y = -bigMap.scrollContainer.verticalScrollPosition;
                  bigMap.flatten();
                  bigMap.mapMark.visible = false;
                  bigMap.returnMainCityBtn.visible = false;
                  _loc2_ = Config.starling.root as Game;
                  _loc3_ = new Tween(bigMap,0.8333333333333334,"easeIn");
                  Starling.juggler.add(_loc3_);
                  _loc3_.animate("scaleX",8);
                  _loc3_.animate("scaleY",8);
                  _loc3_.animate("x",bigMap.x - (param1.target as DisplayObject).x * 8);
                  _loc3_.animate("y",bigMap.y - (param1.target as DisplayObject).y * 8);
                  _loc2_.addPageChangeBg(initBigMap);
               }
               else
               {
                  (facade.retrieveProxy("MapPro") as MapPro).write1703(mapVO);
               }
            }
         }
      }
      
      private function initBigMap() : void
      {
         Starling.juggler.removeTweens(bigMap);
         bigMap.x = 0;
         bigMap.y = 0;
         bigMap.scaleX = 1;
         bigMap.scaleY = 1;
         (facade.retrieveProxy("MapPro") as MapPro).write1703(mapVO);
         bigMap.updateOpen();
         bigMap.mapMark.visible = true;
         bigMap.returnMainCityBtn.visible = true;
         bigMap.unflatten();
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("BigMapMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
