package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import starling.display.Image;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import lzm.starling.swf.display.SwfScale9Image;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import starling.core.Starling;
   import com.mvc.views.uis.mainCity.pvp.PVPBgUI;
   import com.common.themes.Tips;
   import com.mvc.models.proxy.mainCity.mining.MiningPro;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.common.util.strHandler.StrHandle;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class ChatlistUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_listUnit:SwfSprite;
      
      private var playName:TextField;
      
      private var time:TextField;
      
      private var image:Image;
      
      private var _chatVo:ChatVO;
      
      private var theriText:TextField;
      
      private var theriBg:SwfScale9Image;
      
      private var elfText:TextField;
      
      private const space:int = 80;
      
      private var faceIndexArr:Array;
      
      private var imgArr:Array;
      
      private var lenghtText:TextField;
      
      private var mineTf:TextField;
      
      public function ChatlistUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_listUnit = swf.createSprite("spr_listUnit");
         playName = spr_listUnit.getTextField("playName");
         time = spr_listUnit.getTextField("time");
         theriText = spr_listUnit.getTextField("theriText");
         theriText.x = theriText.x + 80 / 5;
         theriBg = spr_listUnit.getScale9Image("theriBg");
         playName.fontName = "1";
         playName.autoSize = "horizontal";
         theriText.autoSize = "horizontal";
         theriText.touchable = false;
         addChild(spr_listUnit);
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(image);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               Facade.getInstance().sendNotification("switch_win",null,"LOAD_OTHERPLAYER_WIN");
               Facade.getInstance().sendNotification("SEND_PLAYER_CHAT",myChatVo);
            }
         }
         var _loc4_:Touch = param1.getTouch(elfText);
         if(_loc4_)
         {
            if(_loc4_.phase == "began")
            {
               onCheck(param1);
            }
         }
         var _loc3_:Touch = param1.getTouch(mineTf);
         if(_loc3_)
         {
            if(_loc3_.phase == "began")
            {
               onCheck(param1);
            }
         }
      }
      
      private function onCheck(param1:TouchEvent) : void
      {
         if(param1.target == elfText)
         {
            ElfDetailInfoMedia.showFreeBtn = false;
            ElfDetailInfoMedia.showSetNameBtn = false;
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
            Facade.getInstance().sendNotification("SEND_ELF_DETAIL",myChatVo.elfVO);
         }
         else if(param1.target == mineTf)
         {
            if((Starling.current.root as Game).page is PVPBgUI)
            {
               return Tips.show("在pvp里不能直接进入挖矿哦");
            }
            (Facade.getInstance().retrieveProxy("Miningpro") as MiningPro).write3906(_chatVo.mineId);
         }
      }
      
      public function set myChatVo(param1:ChatVO) : void
      {
         var _loc7_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         _chatVo = param1;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId,0.9);
         addChild(image);
         if(param1.userName != "系统消息")
         {
            this.addEventListener("touch",ontouch);
         }
         playName.text = "Lv." + param1.lv + "  " + param1.userName;
         time.text = param1.postTime;
         time.x = playName.x + playName.width + 50;
         if(param1.vipRank > 0)
         {
            _loc7_ = GetCommon.getVipIcon(param1.vipRank);
            _loc7_.x = image.x - 5;
            _loc7_.y = image.y - 5;
            addChild(_loc7_);
         }
         faceIndexArr = [];
         imgArr = [];
         lenghtText = new TextField(1,25,"","FZCuYuan-M03S",20,7599115);
         lenghtText.autoSize = "horizontal";
         var _loc2_:String = param1.msg;
         _loc4_ = 0;
         while(_loc4_ < FaceUI.faceStrArr.length)
         {
            _loc3_ = FaceUI.faceStrArr[_loc4_];
            if(_loc2_.indexOf(_loc3_) != -1)
            {
               while(_loc2_.indexOf(_loc3_) != -1)
               {
                  if(_loc2_.indexOf(_loc3_) < 45)
                  {
                     lenghtText.text = _loc2_.slice(0,_loc2_.indexOf(_loc3_));
                     faceIndexArr.push(lenghtText.width);
                  }
                  imgArr.push("img_face" + _loc4_);
                  _loc2_ = _loc2_.replace(_loc3_,"　　 ");
               }
            }
            _loc4_++;
         }
         theriText.text = StrHandle.simLineFeed(_loc2_,45);
         if(param1.ifShow)
         {
            theriText.text = "展示了";
            elfText = new TextField(30,theriText.height,"[" + param1.elfVO.name + "]","FZCuYuan-M03S",20,7599115);
            elfText.autoSize = "horizontal";
            elfText.underline = true;
            elfText.x = theriText.x + theriText.width;
            elfText.y = theriText.y;
            spr_listUnit.addChild(elfText);
            theriBg.width = theriText.width + elfText.width + 80;
         }
         else if(param1.mineId)
         {
            theriText.text = "亲，求帮忙防守：";
            mineTf = new TextField(60,theriText.height,"[" + param1.msg + "]","FZCuYuan-M03S",20,16446616);
            mineTf.autoSize = "horizontal";
            mineTf.underline = true;
            mineTf.x = theriText.x + theriText.width;
            mineTf.y = theriText.y;
            spr_listUnit.addChild(mineTf);
            theriBg.width = theriText.width + mineTf.width + 80;
         }
         else
         {
            theriBg.width = theriText.width + 80;
         }
         _loc5_ = 0;
         while(_loc5_ < imgArr.length)
         {
            _loc6_ = swf.createImage(imgArr[_loc5_]);
            _loc6_.x = theriText.x + faceIndexArr[_loc5_];
            _loc6_.y = theriText.y + 5;
            spr_listUnit.addChild(_loc6_);
            _loc5_++;
         }
         lenghtText.dispose();
         lenghtText = null;
         imgArr = null;
         faceIndexArr = null;
      }
      
      public function clean() : void
      {
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         _chatVo = null;
         removeEventListener("touch",ontouch);
      }
      
      public function get myChatVo() : ChatVO
      {
         return _chatVo;
      }
   }
}
