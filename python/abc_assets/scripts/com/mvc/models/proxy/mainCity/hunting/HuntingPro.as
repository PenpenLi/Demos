package com.mvc.models.proxy.mainCity.hunting
{
   import org.puremvc.as3.patterns.proxy.Proxy;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.net.Client;
   import com.mvc.views.mediator.mainCity.hunting.HuntingMediator;
   import com.common.themes.Tips;
   import com.massage.ane.UmengExtension;
   
   public class HuntingPro extends Proxy
   {
      
      public static const NAME:String = "HuntingPro";
      
      public static var huntingGrade:int;
      
      public static var lowTicketNum:int;
      
      public static var middleTicketNumn:int;
      
      public static var heightTicketNum:int;
      
      public static var heightAndHaoJiaoTicketNum:int;
       
      private var client:Client;
      
      private var str:String = " {  \"spiritInfo\": [ [1,2,3,4,5,6,7,8,9,10,10,10,10,10,10,10,1], [11,12,13,14,15,16,17,18,143], [21,22,23,24,25,26,27,28,150] ], \"enterTimes\": [3,4,5]  } ";
      
      private var spiritStr:String = " {\"isCry\":0,\"charct\":2,\"star\":1,\"oldStar\":1,\"nickName\":null,\"position\":0,\"cryPidAry\":[],\"oldExp\":53,\"effAry\":[0,0,0,0,0,0],\"stateAry\":[],\"skLst\":[{\"lv\":1,\"id\":33,\"pp\":35}],\"sex\":0,\"oldSpiritId\":43,\"spId\":150,\"actionForce\":57,\"oldSkillList\":[{\"lv\":1,\"id\":33,\"pp\":35}],\"code\":1,\"exp\":53,\"hp\":81,\"indv\":[0,0,0,0,0,0],\"bkLv\":0,\"oldLv\":3,\"spec\":0,\"flash\":false,\"lv\":3,\"ball\":28} ";
      
      private var specialPropId:int;
      
      public function HuntingPro(param1:Object = null)
      {
         super("HuntingPro",param1);
         client = Client.getInstance();
         client.addCallObj("note2900",this);
         client.addCallObj("note2901",this);
         client.addCallObj("note2902",this);
      }
      
      public static function calculatorTickNum(param1:Array) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         var _loc2_:int = PlayerVO.huntingPropVec.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            if(PlayerVO.lv >= 19 && PlayerVO.huntingPropVec[_loc4_].name == "初级狩猎券" && PlayerVO.huntingPropVec[_loc4_].count != 0 && param1[0] != 0)
            {
               return true;
            }
            if(PlayerVO.lv >= 25 && PlayerVO.huntingPropVec[_loc4_].name == "中级狩猎券" && PlayerVO.huntingPropVec[_loc4_].count != 0 && param1[1] != 0)
            {
               return true;
            }
            if(PlayerVO.lv >= 30 && PlayerVO.huntingPropVec[_loc4_].name != "初级狩猎券" && PlayerVO.huntingPropVec[_loc4_].name != "中级狩猎券")
            {
               _loc3_ = 0;
               _loc3_ = _loc3_ + PlayerVO.huntingPropVec[_loc4_].count;
               if(_loc3_ && param1[2] != 0)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function write2900() : void
      {
         var _loc1_:Object = {};
         _loc1_.msgId = 2900;
         client.sendBytes(_loc1_);
      }
      
      public function note2900(param1:Object) : void
      {
         LogUtil("note2900: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("hunting_update_elf_times",param1.data);
            if(calculatorTickNum(param1.data.enterTimes))
            {
               HuntingMediator.isSureHunting = true;
               sendNotification("SHOW_HUNTING_DRAW");
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
      
      public function write2901(param1:int, param2:int = 0) : void
      {
         specialPropId = param2;
         huntingGrade = param1;
         var _loc3_:Object = {};
         _loc3_.msgId = 2901;
         _loc3_.huntGrade = param1;
         if(param2 != 0)
         {
            _loc3_.pId = param2;
         }
         client.sendBytes(_loc3_);
      }
      
      public function note2901(param1:Object) : void
      {
         LogUtil("note2901: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            sendNotification("hunting_show_adventure_result",param1.data.spirit);
            if(specialPropId == 0)
            {
               sendNotification("hunting_update_entertime_and_tick",huntingGrade);
            }
            else
            {
               sendNotification("hunting_update_entertime_and_tick",huntingGrade,specialPropId);
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
      
      public function write2902(param1:int) : void
      {
         var _loc2_:Object = {};
         _loc2_.msgId = 2902;
         _loc2_.huntGrade = param1;
         client.sendBytes(_loc2_);
      }
      
      public function note2902(param1:Object) : void
      {
         LogUtil("note2902: " + JSON.stringify(param1));
         if(param1.status == "success")
         {
            Tips.show("进入次数购买成功!");
            sendNotification("hunting_update_enter_times",param1.data.enterTimes);
            UmengExtension.getInstance().UMAnalysic("buy|015|1|" + (PlayerVO.diamond - param1.data.diamond));
            sendNotification("update_play_diamond_info",param1.data.diamond);
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
   }
}
