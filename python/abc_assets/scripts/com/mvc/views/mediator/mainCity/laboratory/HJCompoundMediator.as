package com.mvc.views.mediator.mainCity.laboratory
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.laboratory.HJCompoundUI;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.events.Event;
   import com.common.themes.Tips;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.backPack.BackPackPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.massage.ane.UmengExtension;
   import org.puremvc.as3.interfaces.INotification;
   import feathers.data.ListCollection;
   import starling.display.DisplayObject;
   
   public class HJCompoundMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "HJCompoundMediator";
      
      public static var isEnough:Boolean = true;
       
      public var hjCompoundUI:HJCompoundUI;
      
      private var targetPropVO:PropVO;
      
      public function HJCompoundMediator(param1:Object = null)
      {
         super("HJCompoundMediator",param1);
         hjCompoundUI = param1 as HJCompoundUI;
         hjCompoundUI.addEventListener("triggered",triggeredHandler);
         hjCompoundUI.list.addEventListener("change",list_changeHandler);
      }
      
      private function list_changeHandler(param1:Event) : void
      {
         var _loc2_:int = hjCompoundUI.list.selectedIndex;
         targetPropVO = hjCompoundUI.list.dataProvider.getItemAt(_loc2_).propVO;
         hjCompoundUI.showCompoundInfo(targetPropVO);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(hjCompoundUI.btn_compound === _loc2_)
         {
            if(!isEnough)
            {
               Tips.show("亲，号角碎片不足哦。");
               return;
            }
            if(PlayerVO.diamond < 100)
            {
               Tips.show("亲，钻石不足哦。");
               return;
            }
            EventCenter.addEventListener("BOKEN_COMPOSE_SUCCES",composeSucces);
            (Facade.getInstance().retrieveProxy("BackPackPro") as BackPackPro).write3008(targetPropVO.id,true);
         }
      }
      
      private function composeSucces(param1:Event) : void
      {
         var _loc2_:* = 0;
         EventCenter.removeEventListener("BOKEN_COMPOSE_SUCCES",composeSucces);
         GetPropFactor.addOrLessProp(targetPropVO);
         _loc2_ = 0;
         while(_loc2_ < hjCompoundUI.bugleChipUnitVec.length)
         {
            GetPropFactor.addOrLessProp(hjCompoundUI.bugleChipUnitVec[_loc2_].propVO,false,1);
            _loc2_++;
         }
         sendNotification("update_play_diamond_info",PlayerVO.diamond - 100);
         UmengExtension.getInstance().UMAnalysic("buy|" + targetPropVO.id + "|1|100");
         sendNotification("SHOW_BACKPACK");
         isEnough = true;
         hjCompoundUI.showCompoundInfo(targetPropVO);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("close_hjcompound" !== _loc2_)
         {
            if("update_hjcompound_list" === _loc2_)
            {
               updateList(param1.getBody() as Vector.<PropVO>);
            }
         }
         else
         {
            dispose();
            sendNotification("SHOW_MENU");
         }
      }
      
      private function updateList(param1:Vector.<PropVO>) : void
      {
         var _loc4_:* = 0;
         var _loc2_:* = null;
         if(hjCompoundUI.list.dataProvider)
         {
            hjCompoundUI.list.dataProvider.removeAll();
         }
         var _loc5_:ListCollection = new ListCollection();
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = "<font color=\'#43281D\' size=\'20\'> " + param1[_loc4_].name.substr(0,4) + "\n" + param1[_loc4_].name.substr(4) + "</font>";
            _loc5_.push({
               "label":_loc2_,
               "propVO":param1[_loc4_]
            });
            _loc4_++;
         }
         var param1:Vector.<PropVO> = null;
         hjCompoundUI.list.dataProvider = _loc5_;
         if(_loc5_.length)
         {
            hjCompoundUI.list.selectedIndex = 0;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["close_hjcompound","update_hjcompound_list"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("HJCompoundMediator");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
