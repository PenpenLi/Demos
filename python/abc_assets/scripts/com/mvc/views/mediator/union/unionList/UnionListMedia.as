package com.mvc.views.mediator.union.unionList
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.union.unionList.UnionListUI;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.themes.Tips;
   import com.mvc.views.uis.union.unionList.CreateUnionUI;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import com.common.util.DisposeDisplay;
   import com.mvc.views.uis.union.unionList.UnionUnitUI;
   import lzm.starling.swf.display.SwfButton;
   import feathers.data.ListCollection;
   import com.mvc.models.proxy.mainCity.pvp.PVPPro;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionListMedia extends Mediator
   {
      
      public static const NAME:String = "UnionListMedia";
      
      public static var currentPage:int = 1;
      
      public static var isShowNext:Boolean;
      
      public static var isNotShowFull:Boolean;
       
      public var unionList:UnionListUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      public function UnionListMedia(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         super("UnionListMedia",param1);
         unionList = param1 as UnionListUI;
         unionList.addEventListener("triggered",triggeredHandler);
         unionList.check.addEventListener("change",oncheck);
      }
      
      private function oncheck(param1:Event) : void
      {
         trace("监听单选框的状态== ",unionList.check.isSelected);
         isNotShowFull = unionList.check.isSelected;
         currentPage = 1;
         (facade.retrieveProxy("UnionPro") as UnionPro).write3400(currentPage,isNotShowFull);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(unionList.btn_close !== _loc2_)
         {
            if(unionList.btn_search !== _loc2_)
            {
               if(unionList.btn_createUnion !== _loc2_)
               {
                  if(unionList.btn_return === _loc2_)
                  {
                     currentPage = 1;
                     (facade.retrieveProxy("UnionPro") as UnionPro).write3400(currentPage);
                  }
               }
               else
               {
                  unionList.addChild(CreateUnionUI.getInstance());
               }
            }
            else if(unionList.searchInput.text != "")
            {
               (facade.retrieveProxy("UnionPro") as UnionPro).write3409(unionList.searchInput.text);
            }
            else
            {
               Tips.show("亲，您还没有输入公会的关键字");
            }
         }
         else
         {
            sendNotification("switch_page","load_maincity_page");
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.SHOW_UNION_LIST !== _loc2_)
         {
            if(ConfigConst.UPDATE_APPLY_STATE === _loc2_)
            {
               unionList.applyState.text = "已申请: " + (3 - UnionPro.applyNum) + "/3";
            }
         }
         else
         {
            if(param1.getBody())
            {
               unionList.btn_return.visible = param1.getBody() as Boolean;
            }
            else
            {
               unionList.btn_return.visible = false;
            }
            showUnionList();
         }
      }
      
      private function showUnionList() : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         var _loc1_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < UnionPro.unionVec.length)
         {
            _loc2_ = new UnionUnitUI();
            _loc2_.myUnionVo = UnionPro.unionVec[_loc5_];
            _loc1_.push({
               "icon":_loc2_,
               "label":""
            });
            displayVec.push(_loc2_);
            _loc5_++;
         }
         if(isShowNext)
         {
            _loc3_ = unionList.addBtn("btn_next");
            _loc1_.push({
               "icon":_loc3_,
               "label":""
            });
            _loc3_.addEventListener("triggered",requestNext);
         }
         var _loc4_:ListCollection = new ListCollection(_loc1_);
         unionList.unionList.dataProvider = _loc4_;
         if(currentPage > 1)
         {
            if(unionList.unionList.dataProvider)
            {
               unionList.unionList.scrollToDisplayIndex((currentPage - 1) * 10);
            }
         }
      }
      
      private function requestNext(param1:Event) : void
      {
         (facade.retrieveProxy("UnionPro") as UnionPro).write3400(currentPage + 1,isNotShowFull,true);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.SHOW_UNION_LIST,ConfigConst.UPDATE_APPLY_STATE];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         if(PVPPro.isAcceptPvpInvite)
         {
            if(CreateUnionUI.instance)
            {
               CreateUnionUI.getInstance().remove();
            }
         }
         currentPage = 1;
         DisposeDisplay.dispose(displayVec);
         displayVec = null;
         facade.removeMediator("UnionListMedia");
         UI.removeFromParent(true);
         viewComponent = null;
         LoadSwfAssetsManager.getInstance().removeAsset(Config.unionAssets);
      }
   }
}
