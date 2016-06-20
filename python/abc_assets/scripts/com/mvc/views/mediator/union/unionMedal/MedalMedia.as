package com.mvc.views.mediator.union.unionMedal
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionMedal.MedalUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import feathers.data.ListCollection;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.views.uis.mainCity.perfer.PreferPropUnit;
   import lzm.starling.swf.display.SwfButton;
   import com.common.util.GetCommon;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.DisposeDisplay;
   
   public class MedalMedia extends Mediator
   {
      
      public static const NAME:String = "MedalMedia";
      
      public static const swfName:String = "unionMedal";
       
      public var medal:MedalUI;
      
      private var displayVec:Vector.<DisplayObject>;
      
      public function MedalMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("MedalMedia",param1);
         medal = param1 as MedalUI;
         medal.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(medal.btn_close !== _loc2_)
         {
            if(medal.btn_gift !== _loc2_)
            {
               if(medal.btn_myMedal === _loc2_)
               {
                  showMedal();
               }
            }
            else
            {
               showReward();
            }
         }
         else
         {
            if(medal.medalList.dataProvider)
            {
               medal.medalList.dataProvider.removeAll();
            }
            WinTweens.closeWin(medal.spr_medal,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         dispose();
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SHOW_MEDAL_LIST" !== _loc2_)
         {
            if("SHOW_MEDAL_LIST" === _loc2_)
            {
               showReward();
            }
         }
         else
         {
            showMedal();
            medal.showInfo();
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SHOW_MEDAL_LIST"];
      }
      
      public function showMedal() : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         var _loc5_:* = 0;
         clean();
         var _loc1_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < GetUnionMedal.medalLvArr.length)
         {
            _loc2_ = new Sprite();
            _loc2_.addChild(medal.getTitle(GetUnionMedal.medalNameArr[_loc4_],2));
            _loc5_ = 0;
            while(_loc5_ < GetUnionMedal.medalLvArr[_loc4_].length)
            {
               GetUnionMedal.getMedalIcon(222 + _loc5_ * 115,-12,GetUnionMedal.medalLvArr[_loc4_][_loc5_],_loc2_,20,true,false);
               _loc5_++;
            }
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec.push(_loc2_);
            _loc4_++;
         }
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         medal.medalList.dataProvider = _loc3_;
      }
      
      private function showReward() : void
      {
         var _loc6_:* = 0;
         var _loc4_:* = null;
         var _loc7_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc8_:* = null;
         clean();
         var _loc1_:Array = [];
         _loc6_ = GetUnionMedal.getBigLv(PlayerVO.medalLv);
         while(_loc6_ < GetUnionMedal.medalLvRewardArr.length)
         {
            _loc4_ = new Sprite();
            _loc4_.addChild(medal.getTitle(GetUnionMedal.medalNameArr[_loc6_],-4));
            _loc7_ = 0;
            while(_loc7_ < GetUnionMedal.medalLvRewardArr[_loc6_].length)
            {
               _loc2_ = new PreferPropUnit(true,0.78);
               _loc2_.handle(GetUnionMedal.medalLvRewardArr[_loc6_][_loc7_]);
               _loc2_.x = 222 + _loc7_ * 130;
               _loc2_.y = 5;
               _loc4_.addChild(_loc2_);
               _loc7_++;
            }
            _loc3_ = new Sprite();
            if(GetUnionMedal.getBigLv(PlayerVO.medalLv) >= _loc6_)
            {
               if(PlayerVO.isGetMedalReward)
               {
                  _loc8_ = medal.getBTn("btn_getReward");
                  _loc8_.addEventListener("triggered",getReward);
               }
               else
               {
                  _loc8_ = medal.getBTn("btn_yetReward");
                  _loc8_.enabled = false;
               }
               var _loc9_:* = 0.9;
               _loc8_.scaleY = _loc9_;
               _loc8_.scaleX = _loc9_;
               _loc3_.addChild(_loc8_);
            }
            else
            {
               GetCommon.getText(30,0,150,150,"还需经验\n" + (GetUnionMedal.GetMedalLvExp(GetUnionMedal.medalLvArr[_loc6_][0]) - PlayerVO.medalExp),"FZCuYuan-M03S",20,9713664,_loc3_);
            }
            _loc1_.push({
               "icon":_loc4_,
               "label":"",
               "accessory":_loc3_
            });
            displayVec.push(_loc4_,_loc3_);
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         medal.medalList.dataProvider = _loc5_;
      }
      
      private function getReward(param1:Event) : void
      {
         (facade.retrieveProxy("UnionPro") as UnionPro).write3424();
      }
      
      private function clean() : void
      {
         if(medal.medalList.dataProvider)
         {
            medal.medalList.dataProvider.removeAll();
            medal.medalList.dataProvider = null;
            DisposeDisplay.dispose(displayVec);
            displayVec = Vector.<DisplayObject>([]);
         }
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         clean();
         WinTweens.showCity();
         facade.removeMediator("MedalMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
