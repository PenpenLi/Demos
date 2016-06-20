package com.mvc.models.proxy.union
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.union.UnionVO;
   import com.mvc.models.vos.union.UnionMemberVO;
   import com.mvc.models.vos.mainCity.train.TrainVO;
   import com.mvc.models.vos.union.MarkUpVO;
   import com.common.net.Client;
   import com.common.util.GetCommon;
   import com.common.themes.Tips;
   import com.mvc.views.mediator.union.unionList.UnionListMedia;
   import com.common.consts.ConfigConst;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.events.EventCenter;
   import com.massage.ane.UmengExtension;
   import lzm.util.TimeUtil;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.mediator.union.unionTrain.OtherTrainMedia;
   import com.common.util.xmlVOHandler.GetUnionInfo;
   import com.common.util.RewardHandle;
   
   public class UnionPro extends Proxy
   {
      
      public static const NAME:String = "UnionPro";
      
      public static var attackMark:String = "1";
      
      public static var defenseMark:String = "1";
      
      public static var unionVec:Vector.<UnionVO> = new Vector.<UnionVO>([]);
      
      public static var unionMemberVec:Vector.<UnionMemberVO> = new Vector.<UnionMemberVO>([]);
      
      public static var applyUnionVec:Vector.<UnionMemberVO> = new Vector.<UnionMemberVO>([]);
      
      public static var trainMemberVec:Vector.<UnionMemberVO> = new Vector.<UnionMemberVO>([]);
      
      public static var otherTrainVec:Vector.<TrainVO> = new Vector.<TrainVO>([]);
      
      public static var markUpVec:Vector.<MarkUpVO> = new Vector.<MarkUpVO>([]);
      
      public static var applyNum:int;
      
      public static var myUnionVO:UnionVO;
      
      public static var speedUpTimes:int;
      
      public static var beSpeedUpTimes:int;
      
      public static var beSpeedUpLog:String;
       
      private var client:Client;
      
      private var _isAddNextPage:Boolean;
      
      private var _isOpen:Boolean;
      
      private var _researchType:int;
      
      private var _markUpVo:MarkUpVO;
      
      private var _isAuto:Boolean;
      
      private var _changeType:int;
      
      private var _enterLv:int;
      
      private var _refuseAll:Boolean;
      
      public function UnionPro(param1:Object = null)
      {
         super("UnionPro",param1);
         client = Client.getInstance();
         client.addCallObj("note3400",this);
         client.addCallObj("note3401",this);
         client.addCallObj("note3402",this);
         client.addCallObj("note3403",this);
         client.addCallObj("note3404",this);
         client.addCallObj("note3405",this);
         client.addCallObj("note3406",this);
         client.addCallObj("note3407",this);
         client.addCallObj("note3408",this);
         client.addCallObj("note3409",this);
         client.addCallObj("note3410",this);
         client.addCallObj("note3411",this);
         client.addCallObj("note3412",this);
         client.addCallObj("note3413",this);
         client.addCallObj("note3414",this);
         client.addCallObj("note3415",this);
         client.addCallObj("note3416",this);
         client.addCallObj("note3417",this);
         client.addCallObj("note3418",this);
         client.addCallObj("note3419",this);
         client.addCallObj("note3420",this);
         client.addCallObj("note3421",this);
         client.addCallObj("note3422",this);
         client.addCallObj("note3423",this);
         client.addCallObj("note3424",this);
      }
      
      public function write3400(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         _isAddNextPage = param3;
         var _loc4_:Object = {};
         _loc4_.msgId = 3400;
         _loc4_.pageNow = param1;
         _loc4_.isNotShowFull = param2;
         client.sendBytes(_loc4_);
      }
      
      public function note3400(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         LogUtil("3400=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            if(!GetCommon.isNullObject(param1.data))
            {
               return Tips.show("公会数据异常");
            }
            if(param1.data.msg)
            {
               Tips.show(param1.data.msg);
            }
            if(!_isAddNextPage)
            {
               unionVec = Vector.<UnionVO>([]);
            }
            applyNum = param1.data.applyNum;
            UnionListMedia.currentPage = param1.data.pageNow;
            _loc4_ = param1.data.guildList;
            if(UnionListMedia.currentPage < param1.data.pageCount)
            {
               UnionListMedia.isShowNext = true;
            }
            else
            {
               UnionListMedia.isShowNext = false;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = new UnionVO();
               _loc2_.unionId = _loc4_[_loc3_].guildId;
               _loc2_.unionName = _loc4_[_loc3_].guildName;
               _loc2_.unionRCD = _loc4_[_loc3_].chairmanUserName;
               _loc2_.unionRCDLv = _loc4_[_loc3_].guildEnterLv;
               _loc2_.unionLv = _loc4_[_loc3_].guildLv;
               _loc2_.maxMemberNum = _loc4_[_loc3_].playerMax;
               _loc2_.applyStatus = _loc4_[_loc3_].applyStatus;
               _loc2_.nowMemberNum = _loc4_[_loc3_].playerNum;
               _loc2_.notice = _loc4_[_loc3_].guildNote;
               _loc2_.unionRank = _loc4_[_loc3_].guildRank;
               _loc2_.needLv = _loc4_[_loc3_].guildEnterLv;
               unionVec.push(_loc2_);
               _loc3_++;
            }
            sendNotification(ConfigConst.UPDATE_APPLY_STATE);
            sendNotification(ConfigConst.SHOW_UNION_LIST);
         }
      }
      
      public function write3401(param1:Number) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3401;
         _loc2_.guildId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3401(param1:Object) : void
      {
         LogUtil("3401=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            applyNum = param1.data.applyNum;
            sendNotification(ConfigConst.UPDATE_APPLY_STATE);
            if(param1.data.guildId)
            {
               Tips.show("申请成功");
               PlayerVO.unionId = param1.data.guildId;
               sendNotification("switch_page","LOAD_UNIONWORLD_PAGE");
            }
            else
            {
               EventCenter.dispatchEvent("APPLY_UNION_SUCCESS");
               Tips.show("申请成功，等待审核");
            }
         }
      }
      
      public function write3402() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3402;
         client.sendBytes(_loc1_);
      }
      
      public function note3402(param1:Object) : void
      {
         LogUtil("3402=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
            {
               LogUtil("这个退出的是副会长");
               UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId),1);
            }
            PlayerVO.unionId = -1;
            PlayerVO.isOpenUnion = false;
            write3413(false);
            sendNotification(ConfigConst.EXIT_UNION_SUCCESS);
         }
      }
      
      public function write3403(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3403;
         _loc2_.guildName = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3403(param1:Object) : void
      {
         LogUtil("3403=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("创建公会成功");
            PlayerVO.unionId = param1.data.guildId;
            UmengExtension.getInstance().UMAnalysic("buy|016|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
            EventCenter.dispatchEvent("CREATE_UNION_SUCCESS");
         }
      }
      
      public function write3404() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3404;
         client.sendBytes(_loc1_);
      }
      
      public function note3404(param1:Object) : void
      {
         LogUtil("3404=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write3405(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3405;
         _loc2_.msg = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3405(param1:Object) : void
      {
         LogUtil("3405=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("修改成功");
            EventCenter.dispatchEvent("EDIT_NOTICE_SUCCESS");
         }
      }
      
      public function write3406(param1:Number) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3406;
         _loc2_.guildId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3406(param1:Object) : void
      {
         LogUtil("3406=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("取消申请成功");
            applyNum = applyNum + 1;
            sendNotification(ConfigConst.UPDATE_APPLY_STATE);
            EventCenter.dispatchEvent("CANCELAPPLY_UNION_SUCCESS");
         }
      }
      
      public function write3407(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3407;
         _loc2_.userId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3407(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         LogUtil("3407=" + JSON.stringify(param1));
         var _loc4_:* = param1.status;
         if("success" !== _loc4_)
         {
            if("fail" !== _loc4_)
            {
               if("error" === _loc4_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            _loc2_ = param1.data.guildPlayerInfo;
            _loc3_ = new UnionMemberVO();
            §§dup(UnionPro.myUnionVO).nowMemberNum++;
            _loc3_.loginOutTime = TimeUtil.getTime(_loc2_.loginOutTime);
            _loc3_.post = _loc2_.position;
            _loc3_.status = _loc2_.status;
            _loc3_.unionId = _loc2_.guildId;
            _loc3_.userId = _loc2_.userId;
            _loc3_.userLv = _loc2_.userLv;
            _loc3_.userName = _loc2_.userName;
            _loc3_.vitality = _loc2_.vitality;
            _loc3_.headId = _loc2_.userHeadPtId;
            sendNotification(ConfigConst.SHOW_UNION_HALLL);
            EventCenter.dispatchEvent("AGREE_SUCCESS",{"memberVO":_loc3_});
         }
      }
      
      public function write3408(param1:String = null, param2:Boolean = false) : void
      {
         _refuseAll = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 3408;
         if(param1)
         {
            _loc3_.userId = param1;
         }
         _loc3_.refuseAll = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3408(param1:Object) : void
      {
         LogUtil("3408=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            EventCenter.dispatchEvent("REJECT_SUCCESS",_refuseAll);
         }
      }
      
      public function write3409(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3409;
         _loc2_.guildName = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3409(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         LogUtil("3409=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            if(param1.data.msg)
            {
               Tips.show(param1.data.msg);
            }
            _loc4_ = param1.data.guildList;
            if(_loc4_.length == 0)
            {
               return Tips.show("找不到相关的公会");
            }
            UnionListMedia.isShowNext = false;
            unionVec = Vector.<UnionVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = new UnionVO();
               _loc2_.unionId = _loc4_[_loc3_].guildId;
               _loc2_.unionName = _loc4_[_loc3_].guildName;
               _loc2_.unionRCD = _loc4_[_loc3_].chairmanUserName;
               _loc2_.unionRCDLv = _loc4_[_loc3_].guildEnterLv;
               _loc2_.unionLv = _loc4_[_loc3_].guildLv;
               _loc2_.maxMemberNum = _loc4_[_loc3_].playerMax;
               _loc2_.applyStatus = _loc4_[_loc3_].applyStatus;
               _loc2_.nowMemberNum = _loc4_[_loc3_].playerNum;
               _loc2_.notice = _loc4_[_loc3_].guildNote;
               _loc2_.unionRank = _loc4_[_loc3_].guildRank;
               _loc2_.needLv = _loc4_[_loc3_].guildEnterLv;
               unionVec.push(_loc2_);
               _loc3_++;
            }
            sendNotification(ConfigConst.SHOW_UNION_LIST,true);
         }
      }
      
      public function write3410() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3410;
         client.sendBytes(_loc1_);
      }
      
      public function note3410(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         LogUtil("3410=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            unionMemberVec = Vector.<UnionMemberVO>([]);
            _loc4_ = param1.data.allGuildPlayerInfo;
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = new UnionMemberVO();
               _loc3_.loginOutTime = TimeUtil.getTime(_loc4_[_loc2_].loginOutTime);
               _loc3_.post = _loc4_[_loc2_].position;
               _loc3_.status = _loc4_[_loc2_].status;
               _loc3_.unionId = _loc4_[_loc2_].guildId;
               _loc3_.userId = _loc4_[_loc2_].userId;
               _loc3_.userLv = _loc4_[_loc2_].userLv;
               _loc3_.userName = _loc4_[_loc2_].userName;
               _loc3_.vitality = _loc4_[_loc2_].vitality;
               _loc3_.headId = _loc4_[_loc2_].userHeadPtId;
               _loc3_.vipRank = _loc4_[_loc2_].vipRank;
               unionMemberVec.push(_loc3_);
               _loc2_++;
            }
            myUnionVO.nowMemberNum = unionMemberVec.length;
            sendNotification(ConfigConst.SHOW_UNION_HALLL);
            sendNotification(ConfigConst.MINING_UPDATE_MEMBER_LIST);
         }
      }
      
      public function write3411() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3411;
         client.sendBytes(_loc1_);
      }
      
      public function note3411(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         LogUtil("3411=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            applyUnionVec = Vector.<UnionMemberVO>([]);
            _loc2_ = param1.data.applyUserList;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = new UnionMemberVO();
               _loc4_.userId = _loc2_[_loc3_].userId;
               _loc4_.userLv = _loc2_[_loc3_].userLv;
               _loc4_.userName = _loc2_[_loc3_].userName;
               _loc4_.userRank = _loc2_[_loc3_].userRank;
               _loc4_.headId = _loc2_[_loc3_].headPtId;
               _loc4_.vipRank = _loc2_[_loc3_].vipRank;
               applyUnionVec.push(_loc4_);
               _loc3_++;
            }
            sendNotification(ConfigConst.SHOW_UNION_APPLY);
         }
      }
      
      public function write3412() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3412;
         client.sendBytes(_loc1_);
      }
      
      public function note3412(param1:Object) : void
      {
         LogUtil("3412=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("招人信息已发布到世界");
         }
      }
      
      public function write3413(param1:Boolean = true) : void
      {
         _isOpen = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3413;
         client.sendBytes(_loc2_);
      }
      
      public function note3413(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         LogUtil("3413=" + JSON.stringify(param1));
         var _loc4_:* = param1.status;
         if("success" !== _loc4_)
         {
            if("fail" !== _loc4_)
            {
               if("error" === _loc4_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            _loc2_ = param1.data.ownGuildInfo;
            PlayerVO.unionId = _loc2_.guildId;
            PlayerVO.isOpenUnion = _loc2_.isOpenGuild;
            PlayerVO.applyCount = _loc2_.guildApplyGuildId;
            PlayerVO.guildApplyGuildId = _loc2_.guildApplyGuildId;
            PlayerVO.medalLv = _loc2_.gtLv;
            PlayerVO.medalExp = _loc2_.gtExp;
            PlayerVO.isGetMedalReward = _loc2_.gtReward;
            myUnionVO = null;
            if(!param1.data.guildInfo)
            {
               defenseMark = "1";
               attackMark = "1";
               sendNotification("UPDATE_BAG_ELF");
               return;
            }
            _loc3_ = param1.data.guildInfo;
            myUnionVO = new UnionVO();
            myUnionVO.unionId = _loc3_.guildId;
            myUnionVO.unionName = _loc3_.guildName;
            myUnionVO.unionRCD = _loc3_.chairmanUserName;
            myUnionVO.unionRCDLv = _loc3_.guildEnterLv;
            myUnionVO.unionLv = _loc3_.guildLv;
            myUnionVO.maxMemberNum = _loc3_.playerMax;
            myUnionVO.applyStatus = _loc3_.applyStatus;
            myUnionVO.nowMemberNum = _loc3_.playerNum;
            myUnionVO.notice = _loc3_.guildNote;
            myUnionVO.unionRank = _loc3_.guildRank;
            myUnionVO.needLv = _loc3_.guildEnterLv;
            myUnionVO.serverId = _loc3_.contId;
            myUnionVO.isApply = _loc3_.isApply;
            myUnionVO.unionRCDId = _loc3_.chairmanUserId;
            myUnionVO.unionViceRCDIdArr = _loc3_.viceChairmanUserIdArr;
            myUnionVO.unionExp = _loc3_.guildExp;
            myUnionVO.isAutoEnter = _loc3_.isAutoEnter;
            defenseMark = _loc3_.defense;
            attackMark = _loc3_.attack;
            sendNotification("UPDATE_BAG_ELF");
            if(_isOpen)
            {
               sendNotification("switch_page","LOAD_UNIONWORLD_PAGE");
               sendNotification(ConfigConst.SHOW_UNION_NOTICE);
            }
         }
      }
      
      public function write3414(param1:Boolean) : void
      {
         _isAuto = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3414;
         _loc2_.isAuto = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3414(param1:Object) : void
      {
         LogUtil("3414=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            myUnionVO.isAutoEnter = _isAuto;
         }
      }
      
      public function write3415() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3415;
         client.sendBytes(_loc1_);
      }
      
      public function note3415(param1:Object) : void
      {
         LogUtil("3415=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            PlayerVO.isOpenUnion = true;
            UmengExtension.getInstance().UMAnalysic("buy|017|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
            EventCenter.dispatchEvent("CANCEL_NOTICE_APPLYLVLIMT");
         }
      }
      
      public function write3416(param1:int, param2:String) : void
      {
         _changeType = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 3416;
         _loc3_.changeType = param1;
         _loc3_.userId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3416(param1:Object) : void
      {
         LogUtil("3416=" + JSON.stringify(param1),_changeType);
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            switch(_changeType - 1)
            {
               case 0:
                  Tips.show("转让成功");
                  EventCenter.dispatchEvent("MAKEOVER_SUCCESS");
                  break;
               case 1:
                  Tips.show("升职成功");
                  EventCenter.dispatchEvent("PROMOTION_SUCCESS");
                  break;
               case 2:
                  Tips.show("降职成功");
                  EventCenter.dispatchEvent("DEMOTION_SUCCESS");
                  break;
               case 3:
                  Tips.show("踢出成功");
                  EventCenter.dispatchEvent("KICK_SUCCESS");
                  break;
            }
         }
      }
      
      public function write3417(param1:int) : void
      {
         _enterLv = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3417;
         _loc2_.enterLv = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3417(param1:Object) : void
      {
         LogUtil("3417=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            UnionPro.myUnionVO.needLv = _enterLv;
            EventCenter.dispatchEvent("EDIT_NOTICE_LVLIMT_SUCCESS");
         }
      }
      
      public function write3418() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3418;
         client.sendBytes(_loc1_);
      }
      
      public function note3418(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = null;
         LogUtil("3418=" + JSON.stringify(param1));
         var _loc8_:* = param1.status;
         if("success" !== _loc8_)
         {
            if("fail" !== _loc8_)
            {
               if("error" === _loc8_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            beSpeedUpTimes = param1.data.ownTrainInfo.beSpeedUpTimes;
            speedUpTimes = param1.data.ownTrainInfo.speedUpTimes;
            beSpeedUpLog = "";
            if(param1.data.ownTrainInfo.beSpeedUpLog)
            {
               _loc2_ = param1.data.ownTrainInfo.beSpeedUpLog;
               if(_loc2_.length > 0)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc2_.length)
                  {
                     if(_loc2_[_loc6_].nkName)
                     {
                        _loc7_ = _loc2_[_loc6_].nkName;
                     }
                     else
                     {
                        _loc7_ = GetElfFactor.getElfVO(_loc2_[_loc6_].spStaId,false).name;
                     }
                     beSpeedUpLog = §§dup().beSpeedUpLog + ("<font color=\'#dd632e\' size=\'20\'>" + TimeUtil.getTime(_loc2_[_loc6_].date) + "前</font>\n<font color=\'#26b41f\' size=\'20\'>" + _loc2_[_loc6_].addUserName + "</font><font color=\'#dd632e\' size=\'20\'>为你的</font>\n<font color=\'#26b41f\' size=\'20\'>" + _loc7_ + "</font><font color=\'#dd632e\' size=\'20\'>使用了1次\n加速训练</font>\n");
                     _loc6_++;
                  }
               }
               else
               {
                  beSpeedUpLog = " <font color=\'#dd632e\' size=\'20\'>还没有玩家帮你训练英\n 雄哦，快去提醒他们吧。</font>";
               }
            }
            _loc3_ = param1.data.trainUserList;
            trainMemberVec = Vector.<UnionMemberVO>([]);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = new UnionMemberVO();
               _loc5_.userId = _loc3_[_loc4_].userId;
               _loc5_.headId = _loc3_[_loc4_].headPtId;
               _loc5_.userName = _loc3_[_loc4_].userName;
               _loc5_.userLv = _loc3_[_loc4_].userLv;
               _loc5_.trainStatus = _loc3_[_loc4_].trainStatus;
               _loc5_.vipRank = _loc3_[_loc4_].vipRank;
               trainMemberVec.push(_loc5_);
               _loc4_++;
            }
            sendNotification(ConfigConst.SHOW_UNIONTRAIN_LIST);
         }
      }
      
      public function write3419(param1:String) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3419;
         _loc2_.trainUserId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3419(param1:Object) : void
      {
         var _loc5_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = null;
         LogUtil("3419=" + JSON.stringify(param1));
         var _loc6_:* = param1.status;
         if("success" !== _loc6_)
         {
            if("fail" !== _loc6_)
            {
               if("error" === _loc6_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            _loc5_ = param1.data.trainGrid;
            otherTrainVec = new Vector.<TrainVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               _loc2_ = new TrainVO();
               _loc2_.traGrdId = _loc5_[_loc3_].trainId;
               _loc2_.maxLv = _loc5_[_loc3_].maxLv;
               _loc2_.status = _loc5_[_loc3_].trainStatus;
               _loc2_.isFull = _loc5_[_loc3_].isLvFull;
               _loc4_ = GetElfFactor.getElfVO(_loc5_[_loc3_].spStaId,false);
               if(_loc5_[_loc3_].nkName)
               {
                  _loc4_.nickName = _loc5_[_loc3_].nkName;
               }
               _loc4_.currentExp = _loc5_[_loc3_].spiritExp;
               _loc4_.lv = _loc5_[_loc3_].spiritlv;
               _loc2_.elfVo = _loc4_;
               otherTrainVec.push(_loc2_);
               _loc3_++;
            }
            sendNotification(ConfigConst.HIDE_UNION_TRAIN);
            sendNotification("switch_win",null,"LOAD_OTHERTRAIN_WIN");
         }
      }
      
      public function write3420(param1:String, param2:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 3420;
         _loc3_.trainUserId = param1;
         _loc3_.trainId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note3420(param1:Object) : void
      {
         LogUtil("3420=" + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("乐于助人，奖励金币" + param1.data.sliver);
            sendNotification("update_play_money_info",PlayerVO.silver + param1.data.sliver);
            OtherTrainMedia.isAddExp = true;
            EventCenter.dispatchEvent("GIVE_OTHERELF_SUCCESS",{"exp":param1.data.addExp});
            write3418();
         }
      }
      
      public function write3421(param1:int) : void
      {
         _researchType = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 3421;
         _loc2_.researchType = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3421(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc2_:* = null;
         LogUtil("3421=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            _loc4_ = param1.data.info;
            markUpVec = Vector.<MarkUpVO>([]);
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               _loc2_ = new MarkUpVO();
               _loc2_.lv = _loc4_[_loc3_].lv;
               _loc2_.exp = _loc4_[_loc3_].exp;
               _loc2_.silverCount = _loc4_[_loc3_].silver;
               _loc2_.diamondCount = _loc4_[_loc3_].diamond;
               switch(_researchType - 1)
               {
                  case 0:
                     _loc2_.title = GetUnionInfo.hallTitleArr[_loc3_];
                     _loc2_.imgName = GetUnionInfo.hallIconArr[_loc3_];
                     _loc2_.dec = GetUnionInfo.hallDecArr[_loc3_];
                     _loc2_.type = GetUnionInfo.hallTypeArr[_loc3_];
                     break;
                  case 1:
                     _loc2_.title = GetUnionInfo.trainTitleArr[_loc3_];
                     _loc2_.imgName = GetUnionInfo.trainIconArr[_loc3_];
                     _loc2_.dec = GetUnionInfo.trainDecArr[_loc3_];
                     _loc2_.type = GetUnionInfo.trainTypeArr[_loc3_];
                     break;
                  case 2:
                     _loc2_.title = GetUnionInfo.seriesTitleArr[_loc3_];
                     _loc2_.imgName = GetUnionInfo.seriesIconArr[_loc3_];
                     _loc2_.dec = GetUnionInfo.seriesDecArr[_loc3_];
                     _loc2_.type = GetUnionInfo.seriesTypeArr[_loc3_];
                     break;
               }
               markUpVec.push(_loc2_);
               _loc3_++;
            }
            sendNotification(ConfigConst.SHOW_STUDY_MARKUP);
         }
      }
      
      public function write3422(param1:int, param2:int, param3:MarkUpVO) : void
      {
         _markUpVo = param3;
         var _loc4_:Object = {};
         _loc4_.msgId = 3422;
         _loc4_.researchType = param1;
         _loc4_.payType = param2;
         client.sendBytes(_loc4_);
      }
      
      public function note3422(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("3422=" + JSON.stringify(param1));
         var _loc3_:* = param1.status;
         if("success" !== _loc3_)
         {
            if("fail" !== _loc3_)
            {
               if("error" === _loc3_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("捐献成功");
            _loc2_ = param1.data.info;
            _markUpVo.lv = _loc2_.lv;
            _markUpVo.exp = _loc2_.exp;
            _markUpVo.silverCount = _loc2_.silver;
            _markUpVo.diamondCount = _loc2_.diamond;
            if(PlayerVO.medalLv < _loc2_.gtLv)
            {
               _markUpVo.isMedalUp = true;
            }
            PlayerVO.medalLv = _loc2_.gtLv;
            PlayerVO.medalExp = _loc2_.gtExp;
            EventCenter.dispatchEvent("UNION_DONATE_SUCCESS",{"markVO":_markUpVo});
            if((param1.data as Object).hasOwnProperty("diamond"))
            {
               UmengExtension.getInstance().UMAnalysic("buy|018|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            if((param1.data as Object).hasOwnProperty("silver"))
            {
               sendNotification("update_play_money_info",param1.data.silver);
            }
         }
      }
      
      public function note3423(param1:Object) : void
      {
         var _loc3_:* = 0;
         var _loc4_:* = null;
         var _loc2_:* = null;
         LogUtil("3423=" + JSON.stringify(param1));
         var _loc5_:* = param1.status;
         if("success" !== _loc5_)
         {
            if("fail" !== _loc5_)
            {
               if("error" === _loc5_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            if(PlayerVO.unionId == -1 || !myUnionVO)
            {
               return;
            }
            _loc3_ = param1.data.changeType;
            Tips.show(param1.data.msg);
            _loc4_ = param1.data.operated;
            _loc2_ = param1.data.beOperated;
            switch(_loc3_ - 1)
            {
               case 0:
                  LogUtil("=============转让==============");
                  if(UnionPro.myUnionVO.unionRCDId == _loc4_)
                  {
                     UnionPro.myUnionVO.unionRCDId = _loc2_;
                     if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_) != -1)
                     {
                        LogUtil("这个被装让的是副会长");
                        UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_),1);
                     }
                  }
                  if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc4_) != -1)
                  {
                     UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc4_),1);
                     UnionPro.myUnionVO.unionViceRCDIdArr.push(_loc2_);
                  }
                  write3410();
                  break;
               case 1:
                  LogUtil("=============升职==============");
                  UnionPro.myUnionVO.unionViceRCDIdArr.push(_loc2_);
                  write3410();
                  break;
               case 2:
                  LogUtil("=============降职==============");
                  UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_),1);
                  write3410();
                  break;
               case 3:
                  LogUtil("=============踢出==============");
                  if(PlayerVO.userId == _loc2_)
                  {
                     PlayerVO.unionId = -1;
                     PlayerVO.isOpenUnion = false;
                     write3413(false);
                     sendNotification(ConfigConst.EXIT_UNION_SUCCESS);
                  }
                  if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_) != -1)
                  {
                     UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_),1);
                  }
                  write3410();
                  break;
               case 4:
                  LogUtil("=============有人加入公会==============");
                  write3410();
                  if(PlayerVO.userId == _loc2_)
                  {
                     write3413(false);
                  }
                  break;
               case 5:
                  LogUtil("=============有人退出公会==============");
                  if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_) != -1)
                  {
                     LogUtil("这个退出的是副会长");
                     UnionPro.myUnionVO.unionViceRCDIdArr.splice(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(_loc2_),1);
                  }
                  write3410();
                  break;
               case 6:
                  LogUtil("=============有人申请加入==============");
                  sendNotification(ConfigConst.SEND_UNION_APPLY);
                  myUnionVO.isApply = true;
                  break;
            }
         }
      }
      
      public function write3424() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 3424;
         client.sendBytes(_loc1_);
      }
      
      public function note3424(param1:Object) : void
      {
         LogUtil("note3424= " + JSON.stringify(param1));
         var _loc2_:* = param1.status;
         if("success" !== _loc2_)
         {
            if("fail" !== _loc2_)
            {
               if("error" === _loc2_)
               {
                  Tips.show("服务端异常");
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            RewardHandle.Reward(param1.data.reward);
            PlayerVO.isGetMedalReward = false;
            sendNotification("SHOW_MEDAL_LIST");
         }
      }
   }
}
