package com.mvc.views.uis.union.unionHall
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.union.UnionMemberVO;
   import starling.display.Image;
   import starling.events.Event;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.common.consts.ConfigConst;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.mediator.union.unionHall.UnionHallMedia;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class HallListUnit extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_list1:SwfSprite;
      
      private var spr_list2:SwfSprite;
      
      private var myBg:SwfScale9Image;
      
      private var other:SwfScale9Image;
      
      private var playerName:TextField;
      
      private var post:TextField;
      
      private var state:TextField;
      
      private var active:TextField;
      
      private var btn_makeOver:SwfButton;
      
      private var btn_demotion:SwfButton;
      
      private var btn_promotion:SwfButton;
      
      private var btn_kick:SwfButton;
      
      private var _memberVo:UnionMemberVO;
      
      private var headImg:Image;
      
      public var index:int;
      
      private var applypName:TextField;
      
      private var rank:TextField;
      
      private var btn_agree:SwfButton;
      
      private var btn_reject:SwfButton;
      
      private var spr_list3:SwfSprite;
      
      public function HallListUnit(param1:int = 1)
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionHall");
         if(param1 == 1)
         {
            spr_list1 = swf.createSprite("spr_list1_s");
            myBg = spr_list1.getScale9Image("myBg");
            other = spr_list1.getScale9Image("other");
            playerName = spr_list1.getTextField("playerName");
            post = spr_list1.getTextField("post");
            state = spr_list1.getTextField("state");
            active = spr_list1.getTextField("active");
            playerName.fontName = "1";
            playerName.autoScale = true;
            addChild(spr_list1);
            this.addEventListener("touch",onTouch);
         }
         if(param1 == 2)
         {
            spr_list2 = swf.createSprite("spr_list2");
            btn_makeOver = spr_list2.getButton("btn_makeOver");
            btn_demotion = spr_list2.getButton("btn_demotion");
            btn_promotion = spr_list2.getButton("btn_promotion");
            btn_kick = spr_list2.getButton("btn_kick");
            addChild(spr_list2);
            this.addEventListener("triggered",onclick);
         }
         if(param1 == 3)
         {
            spr_list3 = swf.createSprite("spr_list3");
            applypName = spr_list3.getTextField("applypName");
            rank = spr_list3.getTextField("rank");
            btn_agree = spr_list3.getButton("btn_agree");
            btn_reject = spr_list3.getButton("btn_reject");
            applypName.fontName = "1";
            applypName.autoScale = true;
            addChild(spr_list3);
            this.addEventListener("triggered",onclick);
         }
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc6_:* = param1.target;
         if(btn_promotion !== _loc6_)
         {
            if(btn_demotion !== _loc6_)
            {
               if(btn_kick !== _loc6_)
               {
                  if(btn_makeOver !== _loc6_)
                  {
                     if(btn_agree !== _loc6_)
                     {
                        if(btn_reject === _loc6_)
                        {
                           EventCenter.addEventListener("REJECT_SUCCESS",rejectOK);
                           (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3408(_memberVo.userId,false);
                        }
                     }
                     else
                     {
                        EventCenter.addEventListener("AGREE_SUCCESS",agreeOK);
                        (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3407(_memberVo.userId);
                     }
                  }
                  else
                  {
                     _loc4_ = Alert.show("确定将职位转让给【" + _memberVo.userName + "】么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                     _loc4_.addEventListener("close",makeOverHander);
                  }
               }
               else
               {
                  _loc3_ = Alert.show("确定将【" + _memberVo.userName + "】踢出公会么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc3_.addEventListener("close",kickAlertHander);
               }
            }
            else
            {
               _loc5_ = Alert.show("确定将【" + _memberVo.userName + "】降职为成员么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc5_.addEventListener("close",demotionAlertHander);
            }
         }
         else if(UnionPro.myUnionVO.unionRCDId == PlayerVO.userId)
         {
            if(UnionPro.myUnionVO.unionViceRCDIdArr.length >= 2)
            {
               return Tips.show("副会长位置已满");
            }
            _loc2_ = Alert.show("确定将【" + _memberVo.userName + "】升职为副会长么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc2_.addEventListener("close",promotionAlertHander);
         }
         else
         {
            return Tips.show("权限不足");
         }
      }
      
      private function makeOverHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("MAKEOVER_SUCCESS",makeOverOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3416(1,_memberVo.userId);
         }
      }
      
      private function kickAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("KICK_SUCCESS",kickOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3416(4,_memberVo.userId);
         }
      }
      
      private function demotionAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("DEMOTION_SUCCESS",demotionOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3416(3,_memberVo.userId);
         }
      }
      
      private function promotionAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("PROMOTION_SUCCESS",promotionOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3416(2,_memberVo.userId);
         }
      }
      
      private function rejectOK(param1:Event) : void
      {
         EventCenter.removeEventListener("REJECT_SUCCESS",rejectOK);
         if(param1.data)
         {
            UnionPro.applyUnionVec = Vector.<UnionMemberVO>([]);
         }
         else
         {
            UnionPro.applyUnionVec.splice(index,1);
         }
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_APPLY);
      }
      
      private function agreeOK(param1:Event) : void
      {
         EventCenter.removeEventListener("AGREE_SUCCESS",agreeOK);
         UnionPro.unionMemberVec.push(param1.data.memberVO);
         UnionPro.applyUnionVec.splice(index,1);
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_APPLY);
      }
      
      private function makeOverOK() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         EventCenter.removeEventListener("MAKEOVER_SUCCESS",makeOverOK);
         if(UnionPro.myUnionVO.unionRCDId == PlayerVO.userId)
         {
            _loc1_ = 0;
            while(_loc1_ < UnionPro.unionMemberVec.length)
            {
               if(PlayerVO.userId == UnionPro.unionMemberVec[_loc1_].userId)
               {
                  UnionPro.unionMemberVec[_loc1_].post = 3;
                  break;
               }
               _loc1_++;
            }
            UnionPro.unionMemberVec.splice(index,1);
            UnionPro.myUnionVO.unionRCDId = _memberVo.userId;
            UnionPro.myUnionVO.unionRCD = _memberVo.userName;
            _memberVo.post = 1;
            Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
            if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId) != -1)
            {
               LogUtil("这个被转让的是副会长");
               UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId),1);
            }
         }
         if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < UnionPro.unionMemberVec.length)
            {
               if(PlayerVO.userId == UnionPro.unionMemberVec[_loc2_].userId)
               {
                  UnionPro.unionMemberVec[_loc2_].post = 3;
                  break;
               }
               _loc2_++;
            }
            UnionPro.unionMemberVec.splice(index,1);
            UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId),1);
            UnionPro.myUnionVO.unionViceRCDIdArr.push(_memberVo.userId);
            _memberVo.post = 2;
            Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
         }
      }
      
      private function kickOK() : void
      {
         EventCenter.removeEventListener("KICK_SUCCESS",kickOK);
         LogUtil("踢出成功");
         UnionPro.unionMemberVec.splice(index,1);
         UnionPro.unionMemberVec.splice(index - 1,1);
         §§dup(UnionPro.myUnionVO).nowMemberNum--;
         if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId) != -1)
         {
            UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId),1);
         }
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
      }
      
      private function demotionOK() : void
      {
         EventCenter.removeEventListener("DEMOTION_SUCCESS",demotionOK);
         UnionPro.unionMemberVec.splice(index,1);
         _memberVo.post = 3;
         UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId),1);
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
      }
      
      private function promotionOK() : void
      {
         EventCenter.removeEventListener("PROMOTION_SUCCESS",promotionOK);
         UnionPro.unionMemberVec.splice(index,1);
         _memberVo.post = 2;
         UnionPro.myUnionVO.unionViceRCDIdArr.push(_memberVo.userId);
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         if(UnionHallUI.isScrolling)
         {
            return;
         }
         if(_memberVo.userId == UnionPro.myUnionVO.unionRCDId)
         {
            return;
         }
         if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) == -1 && PlayerVO.userId != UnionPro.myUnionVO.unionRCDId)
         {
            return;
         }
         if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
         {
            if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId) != -1)
            {
               return;
            }
         }
         var _loc2_:Touch = param1.getTouch(spr_list1);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(UnionPro.unionMemberVec.indexOf(null) != -1)
            {
               if(index != UnionHallMedia.index - 1)
               {
                  LogUtil("另开！！！！！");
                  UnionPro.unionMemberVec.splice(UnionPro.unionMemberVec.indexOf(null),1);
                  UnionPro.unionMemberVec.splice(UnionPro.unionMemberVec.indexOf(_memberVo) + 1,0,null);
                  UnionHallMedia.index = UnionPro.unionMemberVec.indexOf(_memberVo) + 1;
                  Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
                  return;
               }
               LogUtil("收！！！！！");
               UnionHallMedia.index = UnionPro.unionMemberVec.indexOf(null) - 1;
               UnionPro.unionMemberVec.splice(UnionPro.unionMemberVec.indexOf(null),1);
               Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
               return;
            }
            LogUtil("出来吧！！！！！");
            UnionHallMedia.index = UnionPro.unionMemberVec.indexOf(_memberVo) + 1;
            UnionPro.unionMemberVec.splice(UnionPro.unionMemberVec.indexOf(_memberVo) + 1,0,null);
            Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_HALLL);
         }
      }
      
      public function set settingBtnVo(param1:UnionMemberVO) : void
      {
         _memberVo = param1;
         if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_memberVo.userId) != -1)
         {
            btn_demotion.visible = true;
            btn_promotion.visible = false;
         }
         else
         {
            btn_demotion.visible = false;
            btn_promotion.visible = true;
         }
      }
      
      public function set applyVo(param1:UnionMemberVO) : void
      {
         var _loc2_:* = null;
         _memberVo = param1;
         applypName.text = _memberVo.userName + "\nLv." + _memberVo.userLv;
         rank.text = _memberVo.userRank;
         headImg = GetPlayerRelatedPicFactor.getHeadPic(_memberVo.headId,0.8);
         var _loc3_:* = 5;
         headImg.y = _loc3_;
         headImg.x = _loc3_;
         spr_list3.addChild(headImg);
         if(param1.vipRank > 0)
         {
            _loc2_ = GetCommon.getVipIcon(param1.vipRank);
            _loc2_.x = headImg.x - 5;
            _loc2_.y = headImg.x - 5;
            spr_list3.addChild(_loc2_);
         }
      }
      
      public function set memberVo(param1:UnionMemberVO) : void
      {
         var _loc2_:* = null;
         LogUtil("_memberVo,",param1.post,index);
         _memberVo = param1;
         playerName.text = _memberVo.userName + "\nLv." + _memberVo.userLv;
         active.text = _memberVo.vitality;
         headImg = GetPlayerRelatedPicFactor.getHeadPic(_memberVo.headId,0.8);
         var _loc3_:* = 5;
         headImg.y = _loc3_;
         headImg.x = _loc3_;
         spr_list1.addChild(headImg);
         if(param1.vipRank > 0)
         {
            _loc2_ = GetCommon.getVipIcon(param1.vipRank);
            _loc2_.x = headImg.x - 5;
            _loc2_.y = headImg.x - 5;
            spr_list1.addChild(_loc2_);
         }
         if(_memberVo.userId == PlayerVO.userId)
         {
            myBg.visible = true;
            other.visible = false;
         }
         else
         {
            myBg.visible = false;
            other.visible = true;
         }
         switch(_memberVo.post - 1)
         {
            case 0:
               post.text = "会长";
               break;
            case 1:
               post.text = "副会长";
               break;
            case 2:
               post.text = "成员";
               break;
         }
         if(param1.status == 1)
         {
            state.text = "在线";
         }
         else
         {
            state.text = "离线" + _memberVo.loginOutTime;
         }
      }
   }
}
