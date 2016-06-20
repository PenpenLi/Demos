package com.mvc.views.uis.mainCity.chat
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.chat.ChatVO;
   import starling.display.Image;
   import feathers.controls.Button;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.util.xmlVOHandler.GetPlayerRelatedPicFactor;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetPrivateDate;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import starling.display.Quad;
   
   public class ChatPlayerUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_playerBg:SwfSprite;
      
      public var btn_chat:SwfButton;
      
      public var btn_pvp:SwfButton;
      
      public var btn_addfri:SwfButton;
      
      public var btn_close:SwfButton;
      
      public var playName:TextField;
      
      private var _chatVo:ChatVO;
      
      private var playLv:TextField;
      
      private var image:Image;
      
      private var playVIPLv:TextField;
      
      private var illNumber:TextField;
      
      private var seriesNumber:TextField;
      
      private var bestRank:TextField;
      
      public var bagElfCotain:Sprite;
      
      public var elfText:TextField;
      
      public var btn_shielding:Button;
      
      public var btn_cancelShielding:Button;
      
      public var playerID:TextField;
      
      private var union:TextField;
      
      public function ChatPlayerUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addShieldingBtn();
         addCancleShieldingBtn();
      }
      
      private function addShieldingBtn() : void
      {
         btn_shielding = new Button();
         btn_shielding.label = "屏蔽此人发言";
         btn_shielding.x = seriesNumber.x + seriesNumber.width + 80;
         btn_shielding.y = seriesNumber.y + 35;
         var _loc1_:* = 0.6;
         btn_shielding.scaleY = _loc1_;
         btn_shielding.scaleX = _loc1_;
         spr_playerBg.addChild(btn_shielding);
      }
      
      private function addCancleShieldingBtn() : void
      {
         btn_cancelShielding = new Button();
         btn_cancelShielding.label = "取消屏蔽";
         btn_cancelShielding.x = seriesNumber.x + seriesNumber.width + 110;
         btn_cancelShielding.y = seriesNumber.y + 20;
         var _loc1_:* = 0.6;
         btn_cancelShielding.scaleY = _loc1_;
         btn_cancelShielding.scaleX = _loc1_;
         spr_playerBg.addChild(btn_cancelShielding);
         btn_cancelShielding.visible = false;
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("chat");
         spr_playerBg = swf.createSprite("spr_playerBg");
         btn_chat = spr_playerBg.getButton("btn_chat");
         btn_pvp = spr_playerBg.getButton("btn_pvp");
         btn_addfri = spr_playerBg.getButton("btn_addfri");
         btn_close = spr_playerBg.getButton("btn_close");
         playName = spr_playerBg.getTextField("playName");
         playLv = spr_playerBg.getTextField("playLv");
         playVIPLv = spr_playerBg.getTextField("playVIPLv");
         illNumber = spr_playerBg.getTextField("illNumber");
         seriesNumber = spr_playerBg.getTextField("seriesNumber");
         bestRank = spr_playerBg.getTextField("bestRank");
         elfText = spr_playerBg.getTextField("elfText");
         union = spr_playerBg.getTextField("union");
         playerID = spr_playerBg.getTextField("playID");
         elfText.y = elfText.y + 15;
         playName.fontName = "1";
         spr_playerBg.x = 1136 - spr_playerBg.width >> 1;
         spr_playerBg.y = 640 - spr_playerBg.height >> 1;
         addChild(spr_playerBg);
         bagElfCotain = new Sprite();
         bagElfCotain.x = 175;
         bagElfCotain.y = 375;
         spr_playerBg.addChild(bagElfCotain);
      }
      
      public function set myChatVO(param1:ChatVO) : void
      {
         var _loc4_:* = false;
         var _loc2_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         _chatVo = param1;
         if(image != null)
         {
            GetpropImage.clean(image);
         }
         image = GetPlayerRelatedPicFactor.getHeadPic(param1.headPtId);
         image.x = 29;
         image.y = 83;
         spr_playerBg.addChild(image);
         playName.text = "昵称: " + param1.userName;
         playerID.text = "ID: " + param1.userId;
         playLv.text = "等级: Lv." + param1.lv;
         playVIPLv.text = "VIP等级: " + param1.vipRank;
         illNumber.text = "精灵图鉴数: " + param1.beyondElf;
         seriesNumber.text = "PVP挑战赛对战场数: " + param1.PVPchangeNum;
         bestRank.text = "PVP历史最高排名: " + param1.pvpBestRank;
         if(UnionPro.myUnionVO)
         {
            if(UnionPro.myUnionVO.unionRCDId == PlayerVO.userId)
            {
               union.text = "所属公会: " + UnionPro.myUnionVO.unionName + "(会长)";
            }
            else if(UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
            {
               union.text = "所属公会: " + UnionPro.myUnionVO.unionName + "(副会长)";
            }
            else
            {
               union.text = "所属公会: " + UnionPro.myUnionVO.unionName + "(成员)";
            }
         }
         else
         {
            union.text = "所属公会: 暂时没有加入公会";
         }
         btn_shielding.visible = false;
         btn_cancelShielding.visible = false;
         if(param1.userId != PlayerVO.userId)
         {
            if(GetPrivateDate.shieldingArr.indexOf(param1.userId) != -1)
            {
               btn_cancelShielding.visible = true;
            }
            else
            {
               if(param1.belong == 2)
               {
                  btn_shielding.visible = true;
               }
               if(param1.belong == 1)
               {
                  _loc2_ = 0;
                  while(_loc2_ < PlayerVO.friendVec.length)
                  {
                     if(param1.userId == PlayerVO.friendVec[_loc2_].userId)
                     {
                        _loc4_ = true;
                        break;
                     }
                     _loc2_++;
                  }
                  if(!_loc4_)
                  {
                     btn_shielding.visible = true;
                  }
               }
            }
            if(param1.otherPlayerElf)
            {
               if(param1.userId != PlayerVO.userId)
               {
                  param1.elfVec = Vector.<ElfVO>([]);
                  _loc5_ = 0;
                  while(_loc5_ < param1.otherPlayerElf.length)
                  {
                     _loc3_ = GetElfFactor.getElfVO(param1.otherPlayerElf[_loc5_].spId);
                     _loc3_.id = param1.otherPlayerElf[_loc5_].id;
                     _loc3_.lv = param1.otherPlayerElf[_loc5_].lv;
                     _loc3_.sex = param1.otherPlayerElf[_loc5_].sex;
                     param1.elfVec.push(_loc3_);
                     _loc5_++;
                  }
               }
            }
         }
         addElf();
      }
      
      private function addElf() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         bagElfCotain.removeChildren(0,-1,true);
         LogUtil("============",_chatVo.userName,_chatVo.elfVec);
         _loc2_ = 0;
         while(_loc2_ < _chatVo.elfVec.length)
         {
            if(_chatVo.elfVec[_loc2_] != null)
            {
               _loc1_ = new PlayerElfUnitUI();
               _loc1_.myElfVo = _chatVo.elfVec[_loc2_];
               _loc1_._chatVo = _chatVo;
               var _loc3_:* = 0.7;
               _loc1_.scaleY = _loc3_;
               _loc1_.scaleX = _loc3_;
               _loc1_.x = 90 * _loc2_;
               bagElfCotain.addChild(_loc1_);
            }
            _loc2_++;
         }
      }
      
      public function get myChatVO() : ChatVO
      {
         return _chatVo;
      }
   }
}
