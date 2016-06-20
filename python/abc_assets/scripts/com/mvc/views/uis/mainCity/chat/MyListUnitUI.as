package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.display.Image;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.common.util.GetCommon;
   import com.common.util.strHandler.StrHandle;
   
   public class MyListUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_myList:SwfSprite;
      
      private var playName:TextField;
      
      private var time:TextField;
      
      private var myText:TextField;
      
      private var myBg:SwfScale9Image;
      
      private var _chatVo:ChatVO;
      
      private var image:Image;
      
      private var elfText:TextField;
      
      private const space:int = 80;
      
      private var faceIndexArr:Array;
      
      private var imgArr:Array;
      
      private var lenghtText:TextField;
      
      private const PosX:int = 950;
      
      public function MyListUnitUI()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_myList = swf.createSprite("spr_myList");
         playName = spr_myList.getTextField("playName");
         time = spr_myList.getTextField("time");
         myText = spr_myList.getTextField("myText");
         myBg = spr_myList.getScale9Image("myBg");
         playName.fontName = "1";
         playName.hAlign = "right";
         playName.autoSize = "horizontal";
         myText.autoSize = "horizontal";
         myText.touchable = false;
         time.pivotX = time.width;
         spr_myList.x = spr_myList.x + 43;
         addChild(spr_myList);
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
         var _loc3_:Touch = param1.getTouch(elfText);
         if(_loc3_)
         {
            if(_loc3_.phase == "began")
            {
               onCheck();
            }
         }
      }
      
      private function onCheck() : void
      {
         ElfDetailInfoMedia.showFreeBtn = false;
         ElfDetailInfoMedia.showSetNameBtn = false;
         Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
         Facade.getInstance().sendNotification("SEND_ELF_DETAIL",myChatVo.elfVO);
      }
      
      public function set myChatVo(param1:ChatVO) : void
      {
         var _loc7_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = null;
         var _loc5_:* = 0;
         var _loc6_:* = null;
         LogUtil("显示发送时间====",param1.postTime);
         _chatVo = param1;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId,0.9);
         image.x = 950 + 50;
         addChild(image);
         if(param1.userName != "系统消息")
         {
            this.addEventListener("touch",ontouch);
         }
         playName.text = param1.userName + "  Lv." + param1.lv;
         playName.pivotX = playName.width;
         playName.x = 950;
         time.text = param1.postTime;
         time.x = playName.x - playName.width - 50;
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
         myText.text = StrHandle.simLineFeed(_loc2_,45);
         if(param1.ifShow)
         {
            myText.text = "展示了";
            elfText = new TextField(30,myText.height,"[" + param1.elfVO.name + "]","FZCuYuan-M03S",20,7599115);
            elfText.autoSize = "horizontal";
            elfText.underline = true;
            elfText.y = myText.y;
            spr_myList.addChild(elfText);
            myBg.width = myText.width + elfText.width + 80;
         }
         else
         {
            myBg.width = myText.width + 80;
         }
         myBg.pivotX = myBg.width;
         myBg.x = 950;
         myText.x = myBg.x - myBg.width + 80 / 2 - 8;
         if(param1.ifShow)
         {
            elfText.x = myText.x + myText.width;
         }
         _loc5_ = 0;
         while(_loc5_ < imgArr.length)
         {
            _loc6_ = swf.createImage(imgArr[_loc5_]);
            _loc6_.x = myText.x + faceIndexArr[_loc5_];
            _loc6_.y = myText.y + 5;
            spr_myList.addChild(_loc6_);
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
