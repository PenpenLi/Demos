package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.PvpRecordUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import starling.display.Image;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfImage;
   import com.common.util.GetCommon;
   import feathers.data.ListCollection;
   
   public class PvpRecordMedia extends Mediator
   {
      
      public static const NAME:String = "PvpRecordMedia";
       
      public var pvpRecord:PvpRecordUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function PvpRecordMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PvpRecordMedia",param1);
         pvpRecord = param1 as PvpRecordUI;
         pvpRecord.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpRecord.btn_pvpClose === _loc2_)
         {
            if(pvpRecord.pvpList.dataProvider)
            {
               pvpRecord.pvpList.dataProvider.removeAll();
            }
            WinTweens.closeWin(pvpRecord.spr_pvpRecordBg,remove);
            sendNotification("HIDE_SERIES_NEWS");
         }
      }
      
      private function remove() : void
      {
         pvpRecord.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_SERIES_PVP" === _loc2_)
         {
            showPvp();
         }
      }
      
      public function showPvp() : void
      {
         var _loc6_:* = 0;
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc2_:* = null;
         var _loc8_:* = null;
         var _loc4_:* = null;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc9_:* = null;
         var _loc1_:Array = [];
         LogUtil("ElfSeriesMedia.displayVec,",displayVec);
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc6_ = 0;
         while(_loc6_ < ElfSeriesPro.pvpVec.length)
         {
            _loc3_ = new Sprite();
            _loc7_ = GetPlayerRelatedPicFactor.getHeadPic(ElfSeriesPro.pvpVec[_loc6_].headPtId,1);
            _loc4_ = new TextField(100,50,"","img_rank",30,16777215);
            if(ElfSeriesPro.pvpVec[_loc6_].isWin)
            {
               _loc2_ = pvpRecord.getImage("img_succse");
               _loc8_ = pvpRecord.getImage("img_up");
            }
            else
            {
               _loc2_ = pvpRecord.getImage("img_fail");
               _loc8_ = pvpRecord.getImage("img_down");
            }
            _loc2_.y = 15;
            _loc8_.y = 10;
            _loc8_.x = 90;
            _loc4_.x = 50;
            _loc4_.y = 45;
            _loc7_.x = 140;
            _loc4_.text = Math.abs(ElfSeriesPro.pvpVec[_loc6_].ranking);
            _loc3_.addQuickChild(_loc2_);
            _loc3_.addQuickChild(_loc8_);
            _loc3_.addQuickChild(_loc4_);
            _loc3_.addQuickChild(_loc7_);
            if(ElfSeriesPro.pvpVec[_loc6_].vipRank > 0)
            {
               _loc10_ = GetCommon.getVipIcon(ElfSeriesPro.pvpVec[_loc6_].vipRank);
               _loc10_.x = _loc7_.x - 5;
               _loc10_.y = _loc7_.y - 5;
               _loc3_.addChild(_loc10_);
            }
            _loc11_ = new Sprite();
            _loc9_ = new TextField(50,40,ElfSeriesPro.pvpVec[_loc6_].rivalTime,"FZCuYuan-M03S",25,11617792);
            _loc9_.autoSize = "horizontal";
            _loc11_.addQuickChild(_loc9_);
            _loc1_.push({
               "icon":_loc3_,
               "label":"Lv." + ElfSeriesPro.pvpVec[_loc6_].lv + " " + ElfSeriesPro.pvpVec[_loc6_].userName,
               "accessory":_loc11_
            });
            displayVec.push(_loc3_);
            displayVec.push(_loc11_);
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         pvpRecord.pvpList.dataProvider = _loc5_;
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_SERIES_PVP"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("PvpRecordMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
