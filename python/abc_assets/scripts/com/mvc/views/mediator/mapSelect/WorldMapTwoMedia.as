package com.mvc.views.mediator.mapSelect
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mapSelect.WorldMapTwoUI;
   import starling.events.Event;
   import com.mvc.views.uis.mapSelect.SeleLocalUI;
   import starling.display.DisplayObject;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import starling.animation.Tween;
   import starling.core.Starling;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class WorldMapTwoMedia extends Mediator
   {
      
      public static const NAME:String = "WorldMapTwoMedia";
       
      public var mapTwo:WorldMapTwoUI;
      
      public function WorldMapTwoMedia(param1:Object = null)
      {
         super("WorldMapTwoMedia",param1);
         mapTwo = param1 as WorldMapTwoUI;
         mapTwo.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(param1.target == mapTwo.btn_close)
         {
            sendNotification("switch_page","load_maincity_page");
         }
         else if(param1.target == mapTwo.btn_local)
         {
            SeleLocalUI.getInstance().show(1);
         }
         else
         {
            _loc4_ = (param1.target as DisplayObject).name;
            if(_loc4_.indexOf("map") != -1)
            {
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(_loc4_.substr(3));
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               if(Config.isOpenAni)
               {
                  _loc5_ = 16;
                  while(_loc5_ < 16 + 15)
                  {
                     if(_loc5_ != _loc4_.substr(3))
                     {
                        if(mapTwo.spr_worldMap.getButton("map" + _loc5_))
                        {
                           mapTwo.spr_worldMap.getButton("map" + _loc5_).touchable = false;
                        }
                     }
                     _loc5_++;
                  }
                  mapTwo.x = -mapTwo.scrollContainer.horizontalScrollPosition;
                  mapTwo.y = -mapTwo.scrollContainer.verticalScrollPosition;
                  mapTwo.flatten();
                  mapTwo.mapMark.visible = false;
                  mapTwo.btn_close.visible = false;
                  _loc2_ = Config.starling.root as Game;
                  _loc3_ = new Tween(mapTwo,0.8333333333333334,"easeIn");
                  Starling.juggler.add(_loc3_);
                  _loc3_.animate("scaleX",8);
                  _loc3_.animate("scaleY",8);
                  _loc3_.animate("x",mapTwo.x - (param1.target as DisplayObject).x * 8);
                  _loc3_.animate("y",mapTwo.y - (param1.target as DisplayObject).y * 8);
                  _loc2_.addPageChangeBg(initmapTwo);
               }
               else
               {
                  (facade.retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
               }
            }
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("tell_new_point_open" === _loc2_)
         {
            mapTwo.updateOpen();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["tell_new_point_open"];
      }
      
      private function initmapTwo() : void
      {
         Starling.juggler.removeTweens(mapTwo);
         mapTwo.x = 0;
         mapTwo.y = 0;
         mapTwo.scaleX = 1;
         mapTwo.scaleY = 1;
         (facade.retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
         mapTwo.updateOpen();
         mapTwo.mapMark.visible = true;
         mapTwo.btn_close.visible = true;
         mapTwo.unflatten();
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("WorldMapTwoMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.worldMapTwoAssets);
      }
   }
}
