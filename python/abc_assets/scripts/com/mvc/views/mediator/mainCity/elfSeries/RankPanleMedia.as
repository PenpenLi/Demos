package com.mvc.views.mediator.mainCity.elfSeries
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.elfSeries.RankPanleUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.mainCity.elfSeries.RivalVO;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.proxy.mainCity.elfSeries.ElfSeriesPro;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class RankPanleMedia extends Mediator
   {
      
      public static const NAME:String = "RankPanleMedia";
      
      public static var openF5:Boolean;
       
      public var rankPanle:RankPanleUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function RankPanleMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("RankPanleMedia",param1);
         rankPanle = param1 as RankPanleUI;
         rankPanle.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(rankPanle.btn_rankClose === _loc2_)
         {
            RankPanleMedia.openF5 = false;
            if(rankPanle.rankList.dataProvider)
            {
               rankPanle.rankList.dataProvider.removeAll();
            }
            WinTweens.closeWin(rankPanle.spr_rankPanleBg,remove);
         }
      }
      
      private function remove() : void
      {
         rankPanle.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("SEND_RANK_DATA" !== _loc3_)
         {
            if("SHOW_RANKPLAYER_DATA" === _loc3_)
            {
               _loc2_ = param1.getBody() as RivalVO;
               sendNotification("switch_win",null,"LOAD_RIVAL_INFO");
               sendNotification("SEND_RIVAL_INFO",_loc2_);
            }
         }
         else
         {
            showRank();
         }
      }
      
      public function showRank() : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         if(rankPanle.rankList.dataProvider)
         {
            rankPanle.rankList.dataProvider.removeAll();
         }
         _loc6_ = 0;
         while(_loc6_ < ElfSeriesPro.rankVec.length)
         {
            _loc4_ = new Sprite();
            if(_loc6_ < 3)
            {
               _loc2_ = rankPanle.getImage("img_pp" + (_loc6_ + 1));
               _loc2_.x = 10;
               _loc2_.y = 5 + _loc6_ * 10;
               _loc4_.addChild(_loc2_);
            }
            else
            {
               _loc7_ = new TextField(106,69,(_loc6_ + 1).toString(),"img_rank",50,16777215);
               _loc7_.y = 28;
               _loc7_.x = -3;
               _loc4_.addChild(_loc7_);
            }
            _loc3_ = GetPlayerRelatedPicFactor.getHeadPic(ElfSeriesPro.rankVec[_loc6_].headPtId,1);
            _loc3_.x = 120;
            _loc3_.name = _loc6_.toString();
            _loc4_.addChild(_loc3_);
            if(ElfSeriesPro.rankVec[_loc6_].vipRank > 0)
            {
               _loc8_ = GetCommon.getVipIcon(ElfSeriesPro.rankVec[_loc6_].vipRank);
               _loc8_.x = _loc3_.x - 5;
               _loc8_.y = _loc3_.y - 5;
               _loc4_.addChild(_loc8_);
            }
            _loc1_.push({
               "icon":_loc4_,
               "label":"Lv." + ElfSeriesPro.rankVec[_loc6_].lv + "   " + ElfSeriesPro.rankVec[_loc6_].userName
            });
            _loc3_.addEventListener("touch",ontouch);
            displayVec.push(_loc4_);
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         rankPanle.rankList.dataProvider = _loc5_;
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Image = param1.target as Image;
         var _loc3_:Touch = param1.getTouch(_loc2_);
         var _loc4_:int = _loc2_.name;
         if(_loc3_ && _loc3_.phase == "began")
         {
            (facade.retrieveProxy("ElfSeriesPro") as ElfSeriesPro).write5011(ElfSeriesPro.rankVec[_loc4_]);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_RANK_DATA","SHOW_RANKPLAYER_DATA"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("RankPanleMedia");
         UI.dispose();
         viewComponent = null;
      }
   }
}
