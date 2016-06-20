package com.mvc.views.mediator.mainCity.pvp
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import starling.display.DisplayObject;
   import com.mvc.views.uis.mainCity.pvp.PVPRankUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.util.DisposeDisplay;
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import starling.display.Image;
   import feathers.data.ListCollection;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   
   public class PVPRankMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "PVPRankMediator";
       
      private var displayVec:Vector.<DisplayObject>;
      
      public var pvpRankUI:PVPRankUI;
      
      public function PVPRankMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("PVPRankMediator",param1);
         pvpRankUI = param1 as PVPRankUI;
         pvpRankUI.addEventListener("triggered",triggeredHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(pvpRankUI.closeBtn === _loc2_)
         {
            pvpRankUI.rankList.dataProvider.removeAll();
            WinTweens.closeWin(pvpRankUI.spr_rankPanleBg,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         pvpRankUI.removeFromParent();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("show_pvp_rank" === _loc2_)
         {
            showRank();
         }
      }
      
      private function showRank() : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc1_:Array = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         _loc6_ = 0;
         while(_loc6_ < PVPPro.rankVec.length)
         {
            _loc4_ = new Sprite();
            if(_loc6_ < 3)
            {
               _loc2_ = pvpRankUI.getImage("img_pp" + (_loc6_ + 1));
               _loc4_.addChild(_loc2_);
            }
            else
            {
               _loc7_ = new TextField(106,69,(_loc6_ + 1).toString(),"img_rank",50,16777215);
               _loc7_.y = 18;
               _loc7_.x = -3;
               _loc4_.addChild(_loc7_);
            }
            _loc3_ = GetPlayerRelatedPicFactor.getHeadPic(PVPPro.rankVec[_loc6_].headPtId,1);
            _loc3_.x = 110;
            _loc3_.name = _loc6_.toString();
            _loc4_.addChild(_loc3_);
            _loc1_.push({
               "icon":_loc4_,
               "label":"Lv." + PVPPro.rankVec[_loc6_].lv + "   " + PVPPro.rankVec[_loc6_].userName
            });
            _loc3_.addEventListener("touch",ontouch);
            displayVec.push(_loc4_);
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         pvpRankUI.rankList.dataProvider = _loc5_;
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Image = param1.target as Image;
         var _loc3_:Touch = param1.getTouch(_loc2_);
         var _loc4_:int = _loc2_.name;
         if(_loc3_ && _loc3_.phase == "began")
         {
            (facade.retrieveProxy("PVPPro") as PVPPro).write6013(PVPPro.rankVec[_loc4_]);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["show_pvp_rank"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("PVPRankMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
