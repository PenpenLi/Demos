package com.mvc.views.mediator.mainCity.mining
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.common.interfaces.IMediatorAdd;
   import com.mvc.views.uis.mainCity.mining.MiningInviteUI;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.mvc.views.uis.mainCity.mining.MiningInfoPage;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.proxy.mainCity.chat.ChatPro;
   import com.mvc.models.vos.union.UnionMemberVO;
   import org.puremvc.as3.interfaces.INotification;
   import starling.display.DisplayObject;
   
   public class MiningInviteMediator extends Mediator implements IMediatorAdd
   {
      
      public static const NAME:String = "MiningInviteMediator";
       
      public var miningInviteUI:MiningInviteUI;
      
      private var memberArr:Array;
      
      public function MiningInviteMediator(param1:Object = null)
      {
         super("MiningInviteMediator",param1);
         miningInviteUI = param1 as MiningInviteUI;
         miningInviteUI.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = param1.target;
         if(miningInviteUI.btn_cancle !== _loc4_)
         {
            if(miningInviteUI.btn_sure !== _loc4_)
            {
               if(miningInviteUI.btn_change === _loc4_)
               {
                  remove();
                  sendNotification("switch_win",miningInviteUI,"mining_load_select_member_win");
               }
            }
            else
            {
               _loc2_ = (MiningFrameMediator.nowPage as MiningInfoPage).miningObj.id;
               if(memberArr && memberArr.length == 0)
               {
                  return Tips.show("至少邀请一位玩家哦");
               }
               if(memberArr && memberArr.length != UnionPro.unionMemberVec.length)
               {
                  _loc3_ = collectInvitedUserId();
                  LogUtil("invitedArr.length: " + _loc3_.length);
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9011(_loc2_,_loc3_);
               }
               else
               {
                  (facade.retrieveProxy("ChatPro") as ChatPro).write9011(_loc2_,null);
               }
               WinTweens.closeWin(miningInviteUI.spr_invite,remove);
            }
         }
         else
         {
            WinTweens.closeWin(miningInviteUI.spr_invite,remove);
         }
      }
      
      private function collectInvitedUserId() : Array
      {
         var _loc2_:* = 0;
         var _loc1_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < memberArr.length)
         {
            _loc1_.push((memberArr[_loc2_] as UnionMemberVO).userId);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function remove() : void
      {
         miningInviteUI.removeFromParent();
         sendNotification("switch_win",null);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.getName();
         if("mining_select_member_complete" !== _loc3_)
         {
            if("mining_update_invite_minename" === _loc3_)
            {
               _loc2_ = (MiningFrameMediator.nowPage as MiningInfoPage).miningObj.name;
               miningInviteUI.tf_miningTittle.text = _loc2_;
            }
         }
         else
         {
            memberArr = param1.getBody() as Array;
            if(memberArr.length > 0 && memberArr.length == UnionPro.unionMemberVec.length - 1)
            {
               miningInviteUI.tf_invite.text = "邀请：全体公会成员";
            }
            else if(memberArr.length == 0)
            {
               miningInviteUI.tf_invite.text = "邀请：未选择成员";
            }
            else if(memberArr.length == 1)
            {
               miningInviteUI.tf_invite.text = "邀请：" + (memberArr[0] as UnionMemberVO).userName;
            }
            else if(memberArr.length > 1)
            {
               miningInviteUI.tf_invite.text = "邀请：" + (memberArr[0] as UnionMemberVO).userName + "、" + (memberArr[1] as UnionMemberVO).userName + "等" + memberArr.length + "人";
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["mining_select_member_complete","mining_update_invite_minename"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("MiningInviteMediator");
         UI.dispose();
         viewComponent = null;
      }
   }
}
