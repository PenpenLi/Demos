package com.mvc.models.proxy.mainCity.home
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.mediator.fighting.CalculatorFactor;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.events.EventCenter;
   import com.common.themes.Tips;
   import flash.utils.getTimer;
   import com.mvc.views.mediator.fighting.StatusFactor;
   import com.common.util.RewardHandle;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.uis.mainCity.home.ComLockUI;
   import com.massage.ane.UmengExtension;
   import com.mvc.views.mediator.mainCity.home.BagElfMedia;
   import com.mvc.views.mediator.mainCity.home.ComElfMedia;
   import com.mvc.models.proxy.Illustrations.IllustrationsPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   
   public class HomePro extends Proxy
   {
      
      public static const NAME:String = "HomePro";
       
      private var client:Client;
      
      public var select:int;
      
      private var _index:String;
      
      private var _type:String;
      
      private var singleFreeElfVO:ElfVO;
      
      private var str:String = "{\"goods\":[{\"goodsId\":1,\"props\":{\"num\":1,\"propStaId\":77,\"price\":3000},\"isSell\":false},{\"goodsId\":2,\"props\":{\"num\":3,\"propStaId\":215,\"price\":150},\"isSell\":false},{\"goodsId\":3,\"props\":{\"num\":1,\"propStaId\":163,\"price\":100},\"isSell\":false},{\"goodsId\":4,\"props\":{\"num\":1,\"propStaId\":78,\"price\":3000},\"isSell\":false},{\"goodsId\":5,\"props\":{\"num\":1,\"propStaId\":166,\"price\":100},\"isSell\":false},{\"goodsId\":6,\"props\":{\"num\":1,\"propStaId\":81,\"price\":3000},\"isSell\":false},{\"goodsId\":7,\"props\":{\"num\":1,\"propStaId\":81,\"price\":3000},\"isSell\":false},{\"goodsId\":8,\"props\":{\"num\":3,\"propStaId\":223,\"price\":250},\"isSell\":false},{\"goodsId\":9,\"props\":{\"num\":1,\"propStaId\":157,\"price\":100},\"isSell\":false},{\"goodsId\":10,\"props\":{\"num\":1,\"propStaId\":166,\"price\":100},\"isSell\":false},{\"goodsId\":11,\"props\":{\"num\":3,\"propStaId\":220,\"price\":150},\"isSell\":false},{\"goodsId\":12,\"props\":{\"num\":1,\"propStaId\":162,\"price\":100},\"isSell\":false}],\"pvDot\":0}";
      
      private var _chatVo:ChatVO;
      
      public function HomePro(param1:Object = null)
      {
         super("HomePro",param1);
         client = Client.getInstance();
         client.addCallObj("note1105",this);
         client.addCallObj("note2000",this);
         client.addCallObj("note2001",this);
         client.addCallObj("note2002",this);
         client.addCallObj("note2004",this);
         client.addCallObj("note2015",this);
         client.addCallObj("note2018",this);
         client.addCallObj("note2022",this);
         client.addCallObj("note2029",this);
         client.addCallObj("note2030",this);
         client.addCallObj("note2801",this);
         client.addCallObj("note2802",this);
         client.addCallObj("note2803",this);
         client.addCallObj("note2804",this);
         PlayerVO.initBagElfVec();
      }
      
      public function write2000() : void
      {
         LogUtil("发送2000");
         var _loc1_:Object = {};
         _loc1_.msgId = 2000;
         client.sendBytes(_loc1_);
      }
      
      public function note2000(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc2_:* = 0;
         var _loc3_:* = null;
         LogUtil("note2000==",JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc4_ = param1.data.packetList;
            PlayerVO.BagElfSetNull();
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = GetElfFromSever.getElfInfo(_loc4_[_loc2_]);
               _loc3_.position = _loc4_[_loc2_].position;
               CalculatorFactor.calculatorElf(_loc3_);
               PlayerVO.bagElfVec[_loc4_[_loc2_].position - 1] = _loc3_;
               _loc2_++;
            }
            GetElfFactor.seiri();
            LogUtil("背包精灵的数量=" + _loc4_.length + "\tPlayerVO.bagElfVec=" + PlayerVO.bagElfVec);
            EventCenter.dispatchEvent("UPDATE_BAG_SUCCESS");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2001() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2001;
         client.sendBytes(_loc1_,false);
      }
      
      public function note2001(param1:Object) : void
      {
         var _loc8_:* = null;
         var _loc7_:* = NaN;
         var _loc4_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         var _loc6_:* = 0;
         var _loc3_:* = null;
         LogUtil("note2001=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc8_ = param1.data.computerList;
            LogUtil("电脑精灵的数量=" + _loc8_.length);
            PlayerVO.comElfVec = Vector.<ElfVO>([]);
            _loc7_ = getTimer();
            _loc5_ = 0;
            while(_loc5_ < _loc8_.length)
            {
               _loc4_ = new ElfVO();
               _loc4_ = GetElfFactor.getElfVO(_loc8_[_loc5_].spId);
               _loc4_.id = _loc8_[_loc5_].id;
               _loc4_.isLock = _loc8_[_loc5_].isLock;
               _loc4_.sex = _loc8_[_loc5_].sex;
               _loc4_.lv = _loc8_[_loc5_].lv;
               _loc4_.currentHp = _loc8_[_loc5_].hp;
               _loc4_.effAry = _loc8_[_loc5_].effAry;
               _loc4_.individual = _loc8_[_loc5_].indv;
               _loc4_.currentExp = _loc8_[_loc5_].exp;
               if(_loc8_[_loc5_].charct)
               {
                  _loc4_.characters = _loc8_[_loc5_].charct;
                  _loc4_.character = GetElfFactor.getRandomCharcter(_loc4_,false);
               }
               if(_loc8_[_loc5_].nickName)
               {
                  _loc4_.nickName = _loc8_[_loc5_].nickName;
               }
               _loc2_ = "";
               _loc4_.status = _loc8_[_loc5_].stateAry;
               _loc6_ = 0;
               while(_loc6_ < _loc4_.status.length)
               {
                  _loc2_ = _loc2_ + (StatusFactor.status[_loc4_.status[_loc6_] - 1] + "  ");
                  _loc6_++;
               }
               _loc4_.state = _loc2_;
               if(_loc8_[_loc5_].skLst)
               {
                  _loc3_ = _loc8_[_loc5_].skLst;
                  GetElfFactor.getElfCurrentSkill(_loc4_,_loc3_);
               }
               CalculatorFactor.calculatorElf(_loc4_);
               PlayerVO.comElfVec.push(_loc4_);
               _loc5_++;
            }
            LogUtil("加载时间" + (getTimer() - _loc7_));
            GetElfFactor.elfSort(PlayerVO.comElfVec,"lv");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2002() : void
      {
         var _loc1_:* = 0;
         var _loc4_:* = null;
         var _loc2_:Object = {};
         _loc2_.msgId = 2002;
         var _loc3_:Array = [];
         LogUtil("背包的精灵——————" + PlayerVO.bagElfVec);
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc1_] != null)
            {
               _loc4_ = {};
               _loc4_[PlayerVO.bagElfVec[_loc1_].id] = _loc1_ + 1;
               _loc3_.push(_loc4_);
            }
            _loc1_++;
         }
         _loc2_.packetList = _loc3_;
         client.sendBytes(_loc2_);
      }
      
      public function note2002(param1:Object) : void
      {
         LogUtil("note2002=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("交换成功");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2004(param1:ElfVO) : void
      {
         singleFreeElfVO = param1;
         var _loc2_:Object = {};
         _loc2_.msgId = 2004;
         _loc2_.id = param1.id;
         client.sendBytes(_loc2_);
      }
      
      public function note2004(param1:Object) : void
      {
         LogUtil("note2004=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("精灵跑到野外去了");
            sendNotification("MAKE_FREE_ELF");
            if(facade.hasMediator("HomeMedia"))
            {
               sendNotification("CLEAN_BAG_TICK");
               sendNotification("CLEAN_COM_TICK");
            }
            else if(facade.hasMediator("addAmuseMcMedia"))
            {
               singleFreeElfVO.isAlreadyFree = true;
            }
            RewardHandle.Reward(param1.data);
            sendNotification("update_drop_tittleImg");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2018(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2018;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2018(param1:Object) : void
      {
         LogUtil("note2018=" + JSON.stringify(param1));
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
            Tips.show("精灵跑到野外去了");
            sendNotification("BATCH_FREE_ELF");
            RewardHandle.Reward(param1.data);
            sendNotification("update_drop_tittleImg");
         }
      }
      
      public function write2015(param1:ElfVO, param2:String, param3:int) : void
      {
         LogUtil("elfVo.id==",param1.id);
         _index = param3.toString();
         _type = param2;
         var _loc4_:Object = {};
         _loc4_.msgId = 2015;
         _loc4_.spId = param1.id;
         client.sendBytes(_loc4_);
      }
      
      public function note2015(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil(_type + "2015=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc3_ = param1.data.spirit;
            _loc2_ = GetElfFromSever.getElfInfo(_loc3_);
            if(_type == "电脑")
            {
               sendNotification("SEND_COMELF_DATA",_loc2_,_index);
               sendNotification("SEND_COM_ELF",_loc2_);
            }
            else if(_type == "防守")
            {
               sendNotification("SEND_SERIESELF_DATA",_loc2_,_index);
               sendNotification("ADD_FORMATION",_loc2_);
            }
            else if(_type == "出战")
            {
               sendNotification("SEND_PLAYELF_DATA",_loc2_,_index);
               sendNotification("ADD_PLAYELF",_loc2_);
            }
            else if(_type == "邮件")
            {
               sendNotification("SEND_ELF_DETAIL",_loc2_);
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
            }
            else if(_type == "训练")
            {
               EventCenter.dispatchEvent("TRAINELF_DATA_SUCCESS",_loc2_);
            }
            _loc2_ = null;
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write1105(param1:Boolean) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 1105;
         _loc2_.isDiamond = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note1105(param1:Object) : void
      {
         LogUtil("1105=" + JSON.stringify(param1));
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
            Tips.show("解锁成功");
            LogUtil("ComLockUI.getInstance().nowComSpace==",ComLockUI.getInstance().nowComSpace);
            PlayerVO.cpSpace = ComLockUI.getInstance().nowComSpace;
            sendNotification("SHOW_COM_ELF");
            EventCenter.dispatchEvent("UNLOCK_COM_SUCCESS");
            if((param1.data as Object).hasOwnProperty("silver"))
            {
               sendNotification("update_play_money_info",param1.data.silver);
            }
            if((param1.data as Object).hasOwnProperty("diamond"))
            {
               UmengExtension.getInstance().UMAnalysic("buy|03|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
         }
      }
      
      public function write2022(param1:int, param2:ChatVO) : void
      {
         _chatVo = param2;
         var _loc3_:Object = {};
         _loc3_.msgId = 2022;
         _loc3_.userId = param2.userId;
         _loc3_.spId = param1;
         client.sendBytes(_loc3_);
      }
      
      public function note2022(param1:Object) : void
      {
         var _loc2_:* = null;
         LogUtil("2022=" + JSON.stringify(param1));
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
            _loc2_ = GetElfFromSever.getElfInfo(param1.data.spirit);
            _loc2_.master = _chatVo.userName;
            sendNotification("SEND_ELF_DETAIL",_loc2_);
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
         }
      }
      
      public function write2029(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2029;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2029(param1:Object) : void
      {
         LogUtil("note2029=" + JSON.stringify(param1));
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
            Tips.show("锁定成功");
            updateElfLockState();
         }
      }
      
      public function write2030(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2030;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2030(param1:Object) : void
      {
         LogUtil("note2030=" + JSON.stringify(param1));
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
            Tips.show("解锁成功");
            updateElfLockState();
         }
      }
      
      private function updateElfLockState() : void
      {
         if(BagElfMedia.seleNum)
         {
            sendNotification("home_update_bagelf_lock");
         }
         if(ComElfMedia.seleNum)
         {
            sendNotification("home_update_comelf_lock");
         }
         sendNotification("home_update_big_elf_lock");
      }
      
      public function write2801() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2801;
         client.sendBytes(_loc1_);
      }
      
      public function note2801(param1:Object) : void
      {
         LogUtil("note2801: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
               sendNotification("update_score_shop_scoreTf",param1.data.fsDot);
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2802(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2802;
         _loc2_.goodsId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2802(param1:Object) : void
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         LogUtil("note2802=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("兑换成功。");
            sendNotification("remove_score_goods");
            sendNotification("update_score_shop_scoreTf",param1.data.fsDot);
            sendNotification("update_score_shop");
            if(param1.data.goods)
            {
               if(param1.data.goods.spirites)
               {
                  _loc4_ = param1.data.goods.spirites;
                  _loc3_ = GetElfFromSever.getElfInfo(_loc4_);
                  GetElfFactor.bagOrCom(_loc3_);
                  IllustrationsPro.saveElfInfo(_loc3_);
               }
               if(param1.data.goods.props)
               {
                  _loc2_ = GetPropFactor.getPropVO(param1.data.goods.props.pId);
                  _loc2_.rewardCount = param1.data.goods.props.num;
                  GetPropFactor.addOrLessProp(_loc2_,true,_loc2_.rewardCount);
               }
            }
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2803() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2803;
         client.sendBytes(_loc1_);
      }
      
      public function note2803(param1:Object) : void
      {
         LogUtil("note2803=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if(param1.data.goods)
            {
               sendNotification("show_score_shop_goods",param1.data);
            }
            sendNotification("update_score_shop_scoreTf",param1.data.fsDot);
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2804(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2804;
         _loc2_.spiritIdArr = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2804(param1:Object) : void
      {
         LogUtil("note2804=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("精灵跑到野外去了");
            RewardHandle.Reward(param1.data);
            sendNotification("freeshop_free_elf_success");
            sendNotification("update_drop_tittleImg");
         }
         else if(param1.status == "fail")
         {
            Tips.show(param1.data.msg);
            sendNotification("freeshop_free_elf_fail");
         }
         else if(param1.status == "error")
         {
            Tips.show(param1.data.msg);
         }
      }
   }
}
