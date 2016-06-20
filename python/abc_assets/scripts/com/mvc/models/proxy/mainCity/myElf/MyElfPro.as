package com.mvc.models.proxy.mainCity.myElf
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.common.net.Client;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetElfFromSever;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.uis.mainCity.myElf.MyElfUI;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.views.mediator.mainCity.myElf.EvolveMcMediator;
   import com.massage.ane.UmengExtension;
   import extend.SoundEvent;
   import com.mvc.views.uis.mainCity.myElf.ElfIndividualUI;
   import com.common.util.RewardHandle;
   
   public class MyElfPro extends Proxy
   {
      
      public static const NAME:String = "MyElfPro";
       
      private var client:Client;
      
      private var _elfVO:ElfVO;
      
      private var _evolveId:int;
      
      private var _spId:int;
      
      public function MyElfPro(param1:Object = null)
      {
         super("MyElfPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2003",this);
         client.addCallObj("note2011",this);
         client.addCallObj("note2013",this);
         client.addCallObj("note2023",this);
         client.addCallObj("note2024",this);
         client.addCallObj("note3009",this);
         client.addCallObj("note3010",this);
         client.addCallObj("note2025",this);
         client.addCallObj("note2026",this);
         client.addCallObj("note2027",this);
         client.addCallObj("note2028",this);
      }
      
      public function write2025(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2025;
         _loc2_.spId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2025(param1:Object) : void
      {
         LogUtil("2025=" + JSON.stringify(param1));
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
            sendNotification("STAR_SUCCESS");
         }
      }
      
      public function write3010(param1:Array) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3010;
         _loc2_.nodeInfo = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3010(param1:Object) : void
      {
         LogUtil("3010=" + JSON.stringify(param1));
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
         else if(param1.data.nodeRes)
         {
            if(facade.hasMediator("MyElfMedia"))
            {
               sendNotification("JUMP_CITY_SUCCESS",param1.data.nodeRes);
            }
            else if(facade.hasMediator("BackPackMedia"))
            {
               sendNotification("JUMP_CITY_SUCCESS",param1.data.nodeRes);
            }
         }
      }
      
      public function write3009(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 3009;
         _loc2_.robotId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note3009(param1:Object) : void
      {
         LogUtil("3009=" + JSON.stringify(param1));
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
            Tips.show("机器人合成成功");
            EventCenter.dispatchEvent("BOKEN_COMPOSE_SUCCES");
         }
      }
      
      public function write2023(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2023;
         _loc2_.spId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2023(param1:Object) : void
      {
         LogUtil("2023=" + JSON.stringify(param1));
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
            sendNotification("BREAK_SUCCESS");
         }
      }
      
      public function write2003() : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = null;
         var _loc1_:Object = {};
         _loc1_.msgId = 2003;
         var _loc3_:Array = [];
         LogUtil("背包的精灵——————" + JSON.stringify(PlayerVO.bagElfVec));
         _loc2_ = 0;
         while(_loc2_ < PlayerVO.bagElfVec.length)
         {
            if(PlayerVO.bagElfVec[_loc2_] != null)
            {
               _loc4_ = {};
               _loc4_[PlayerVO.bagElfVec[_loc2_].id] = _loc2_ + 1;
               LogUtil("object==" + JSON.stringify(_loc4_));
               _loc3_.push(_loc4_);
            }
            _loc2_++;
         }
         _loc1_.packetList = _loc3_;
         client.sendBytes(_loc1_);
      }
      
      public function note2003(param1:Object) : void
      {
         LogUtil("note2003=" + JSON.stringify(param1));
         if(param1.status != "success")
         {
            if(param1.status == "fail")
            {
               Tips.show(param1.data.msg);
            }
            else if(param1.status == "error")
            {
               Tips.show(param1.data.msg);
            }
         }
      }
      
      public function write2011(param1:int, param2:ElfVO, param3:Boolean = true) : void
      {
         LogUtil("write2011==" + param1,param2);
         _elfVO = param2;
         var _loc4_:Object = {};
         _loc4_.msgId = 2011;
         _loc4_.spId = param2.id;
         _loc4_.evoPokeId = param1;
         _loc4_.isEvolve = param3;
         client.sendBytes(_loc4_);
         PlayerVO.isAcceptPvp = false;
      }
      
      public function note2011(param1:Object) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         LogUtil("2011=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            _loc2_ = param1.data.spirit.spId;
            _loc3_ = GetElfFromSever.getElfInfo(param1.data.spirit);
            _loc3_.position = _elfVO.position;
            if(!facade.hasMediator("MyElfMedia"))
            {
               facade.registerMediator(new MyElfMedia(new MyElfUI()));
            }
            _loc4_ = 0;
            while(_loc4_ < _elfVO.evoStoneArr.length)
            {
               GetPropFactor.addOrLessProp(GetPropFactor.getPropVO(_elfVO.evoStoneArr[_loc4_][0]),false,_elfVO.evoStoneArr[_loc4_][1]);
               _loc4_++;
            }
            sendNotification("update_elf",_loc3_);
            EvolveMcMediator.evolvoElfVo = _elfVO;
            sendNotification("switch_win",null,"load_elfEvolveMc");
         }
         else if(param1.status == "fail")
         {
            PlayerVO.isAcceptPvp = true;
            Tips.show(param1.data.msg);
         }
         else if(param1.status == "error")
         {
            PlayerVO.isAcceptPvp = true;
            Tips.show(param1.data.msg);
         }
      }
      
      public function write2013() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2013;
         client.sendBytes(_loc1_);
      }
      
      public function note2013(param1:Object) : void
      {
         LogUtil("2013=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("成功解锁背包");
            §§dup(PlayerVO).pokeSpace++;
            UmengExtension.getInstance().UMAnalysic("buy|06|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
            EventCenter.dispatchEvent("UNLOCK_SUCCESS");
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
      
      public function write2024(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:Object = {};
         _loc4_.msgId = 2024;
         _loc4_.spId = param1;
         _loc4_.indIndex = param2;
         _loc4_.isSilverMode = param3;
         client.sendBytes(_loc4_);
      }
      
      public function note2024(param1:Object) : void
      {
         LogUtil("note2024=" + JSON.stringify(param1));
         if(param1.status == "success")
         {
            if((param1.data as Object).hasOwnProperty("money"))
            {
               sendNotification("update_play_money_info",param1.data.money);
            }
            if((param1.data as Object).hasOwnProperty("diamond"))
            {
               UmengExtension.getInstance().UMAnalysic("buy|08|1|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            EventCenter.dispatchEvent("UPGRADE_INDIVIDUAL_SUCCESS",param1.data);
            SoundEvent.dispatchEvent("PLAY_MUSIC_ONCE","skillLvUp");
            sendNotification("UPDATA_SKILL_PROMPT",param1.data.skillDot);
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
      
      public function write2027() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2027;
         client.sendBytes(_loc1_);
      }
      
      public function note2027(param1:Object) : void
      {
         LogUtil("note2027: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("购买个体值点数成功。");
            if((param1.data as Object).hasOwnProperty("diamond"))
            {
               UmengExtension.getInstance().UMAnalysic("buy|011|10|" + (PlayerVO.diamond - param1.data.diamond));
               sendNotification("update_play_diamond_info",param1.data.diamond);
            }
            ElfIndividualUI.getInstance().updateSkillPointTf(10,0);
            sendNotification("UPDATA_SKILL_PROMPT",10);
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
      
      public function write2026(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2026;
         _loc2_.spId = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2026(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         LogUtil("note2026=" + JSON.stringify(param1));
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
         else if(param1.data.spirit)
         {
            _loc2_ = GetElfFromSever.getElfInfo(param1.data.spirit);
            _loc3_ = 0;
            while(_loc3_ < PlayerVO.comElfVec.length)
            {
               if(PlayerVO.comElfVec[_loc3_].id == _loc2_.id)
               {
                  PlayerVO.comElfVec[_loc3_] = _loc2_;
                  break;
               }
               _loc3_++;
            }
            RewardHandle.Reward(param1.data);
            sendNotification("resetelf_success");
            UmengExtension.getInstance().UMAnalysic("buy|09|1|200");
            sendNotification("update_play_diamond_info",PlayerVO.diamond - 200);
         }
      }
      
      public function write2028(param1:int, param2:int) : void
      {
         var _loc3_:Object = {};
         _loc3_.msgId = 2028;
         _loc3_.spId = param1;
         _loc3_.pId = param2;
         client.sendBytes(_loc3_);
      }
      
      public function note2028(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = 0;
         LogUtil("note2028=" + JSON.stringify(param1));
         var _loc4_:* = param1.status;
         if("success" !== _loc4_)
         {
            if("fail" !== _loc4_)
            {
               if("error" === _loc4_)
               {
                  Tips.show(param1.data.msg);
               }
            }
            else
            {
               Tips.show(param1.data.msg);
            }
         }
         else
         {
            Tips.show("洗炼成功。");
            if(param1.data.poke)
            {
               _loc2_ = GetElfFromSever.getElfInfo(param1.data.poke);
               _loc3_ = 0;
               while(_loc3_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc3_] != null && PlayerVO.bagElfVec[_loc3_].id == _loc2_.id)
                  {
                     PlayerVO.bagElfVec[_loc3_] = _loc2_;
                     break;
                  }
                  _loc3_++;
               }
               sendNotification("update_resetcharacter_info",_loc2_);
            }
         }
      }
   }
}
