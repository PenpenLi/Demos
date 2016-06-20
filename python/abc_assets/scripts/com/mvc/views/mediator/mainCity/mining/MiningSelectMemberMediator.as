package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.mining.MiningSelectMemberUI;
   import starling.display.DisplayObject;
   import lzm.starling.swf.display.SwfSprite;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.vos.union.UnionMemberVO;
   import org.puremvc.as3.interfaces.INotification;
   import com.common.consts.ConfigConst;
   import com.common.util.DisposeDisplay;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Sprite;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import lzm.starling.swf.display.SwfImage;
   
   public class MiningSelectMemberMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningSelectMemberMediator";
       
      public var miningSelectMemberUI:MiningSelectMemberUI;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var selectedMemberArr:Array;
      
      private var checkSprVec:Vector.<SwfSprite>;
      
      public function MiningSelectMemberMediator(param1:Object = null)
      {
         displayVec = new Vector.<DisplayObject>([]);
         selectedMemberArr = [];
         checkSprVec = new Vector.<SwfSprite>([]);
         super("MiningSelectMemberMediator",param1);
         miningSelectMemberUI = param1 as MiningSelectMemberUI;
         miningSelectMemberUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:* = param1.target;
         if(miningSelectMemberUI.btn_close !== _loc6_)
         {
            if(miningSelectMemberUI.btn_sure !== _loc6_)
            {
               if(miningSelectMemberUI.btn_clearAll !== _loc6_)
               {
                  if(miningSelectMemberUI.btn_selectAll === _loc6_)
                  {
                     _loc3_ = 0;
                     while(_loc3_ < checkSprVec.length)
                     {
                        checkSprVec[_loc3_].getChildAt(1).visible = true;
                        _loc3_++;
                     }
                  }
               }
               else
               {
                  _loc4_ = 0;
                  while(_loc4_ < checkSprVec.length)
                  {
                     checkSprVec[_loc4_].getChildAt(1).visible = false;
                     _loc4_++;
                  }
               }
            }
            else
            {
               selectedMemberArr = [];
               _loc5_ = 0;
               while(_loc5_ < checkSprVec.length)
               {
                  _loc2_ = UnionPro.unionMemberVec[checkSprVec[_loc5_].name];
                  if(checkSprVec[_loc5_].getChildAt(1).visible == true)
                  {
                     selectedMemberArr.push(_loc2_);
                  }
                  _loc5_++;
               }
               LogUtil("dddddddddd " + selectedMemberArr.length);
               miningSelectMemberUI.list.removeFromParent();
               WinTweens.closeWin(miningSelectMemberUI.spr_selectMember,remove);
            }
         }
         else
         {
            miningSelectMemberUI.list.removeFromParent();
            WinTweens.closeWin(miningSelectMemberUI.spr_selectMember,remove);
         }
      }
      
      private function remove() : void
      {
         miningSelectMemberUI.removeFromParent();
         sendNotification("switch_win",null);
         sendNotification("switch_win",null,"mining_load_invite_win");
         sendNotification("mining_select_member_complete",selectedMemberArr);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if(ConfigConst.MINING_UPDATE_MEMBER_LIST === _loc2_)
         {
            miningSelectMemberUI.spr_selectMember.addChild(miningSelectMemberUI.list);
            updateMemberList();
         }
      }
      
      private function updateMemberList() : void
      {
         var _loc3_:* = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         checkSprVec = Vector.<SwfSprite>([]);
         selectedMemberArr = [];
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         miningSelectMemberUI.listData.removeAll();
         var _loc4_:Vector.<UnionMemberVO> = UnionPro.unionMemberVec;
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            if(_loc4_[_loc3_].userId != PlayerVO.userId)
            {
               _loc1_ = new Sprite();
               _loc1_.addChild(GetPlayerRelatedPicFactor.getHeadPic(_loc4_[_loc3_].headId));
               _loc2_ = miningSelectMemberUI.getSpr("spr_check");
               _loc2_.name = _loc3_;
               _loc2_.addEventListener("touch",checkSpr_touchHandler);
               displayVec.push(_loc1_,_loc2_);
               checkSprVec.push(_loc2_);
               selectedMemberArr.push(_loc4_[_loc3_]);
               miningSelectMemberUI.listData.push({
                  "icon":_loc1_,
                  "label":"Lv:" + _loc4_[_loc3_].userLv + "          " + _loc4_[_loc3_].userName,
                  "accessory":_loc2_
               });
            }
            _loc3_++;
         }
      }
      
      private function checkSpr_touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Touch = param1.getTouch(param1.target as DisplayObject);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            _loc3_ = (param1.target as DisplayObject).parent.getChildAt(1) as SwfImage;
            _loc3_.visible = !_loc3_.visible;
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ConfigConst.MINING_UPDATE_MEMBER_LIST];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         DisposeDisplay.dispose(displayVec);
         displayVec = Vector.<DisplayObject>([]);
         facade.removeMediator("MiningSelectMemberMediator");
         UI.dispose();
         viewComponent = null;
      }
   }
}
