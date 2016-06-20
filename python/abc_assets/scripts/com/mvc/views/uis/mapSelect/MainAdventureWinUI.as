package com.mvc.views.uis.mapSelect
{
   import starling.display.Sprite;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.List;
   import lzm.starling.display.Button;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import lzm.starling.swf.components.feathers.FeathersButton;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import feathers.layout.HorizontalLayout;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.common.util.xmlVOHandler.GetPropFactor;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.mvc.views.uis.mainCity.myElf.SimplePropUI;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.mvc.models.vos.fighting.NPCVO;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import lzm.starling.swf.display.SwfImage;
   import com.mvc.views.mediator.mapSelect.CityMapMeida;
   
   public class MainAdventureWinUI extends Sprite
   {
       
      public var mySpr:SwfSprite;
      
      public var swf:Swf;
      
      public var closeBtn:SwfButton;
      
      public var mapNameTf:TextField;
      
      public var advanceList:List;
      
      public var lessRaidsNumTF:TextField;
      
      public var raidsAddBtn:Button;
      
      public var raidsBtn:Button;
      
      public var levelDec:TextField;
      
      public var enemyElf:TextField;
      
      public var propReward:TextField;
      
      public var expReward:TextField;
      
      public var silverReward:TextField;
      
      public var lessNum:TextField;
      
      public var btn_adventure:SwfButton;
      
      private var costPower:TextField;
      
      private var enemyElfSpr:Sprite;
      
      private var propRewardSpr:Sprite;
      
      public var _mainMapVo:MainMapVO;
      
      private var spr_raids:SwfSprite;
      
      public var normalModeBtn:FeathersButton;
      
      public var hardModeBtn:FeathersButton;
      
      private var lessNumPrompt:TextField;
      
      private var radiaPropmt:TextField;
      
      public function MainAdventureWinUI()
      {
         super();
         init();
         addSpr();
      }
      
      private function addSpr() : void
      {
         enemyElfSpr = new Sprite();
         enemyElfSpr.x = enemyElf.x + enemyElf.width;
         enemyElfSpr.y = enemyElf.y - 25;
         mySpr.addChild(enemyElfSpr);
         propRewardSpr = new Sprite();
         propReward.y = propReward.y + 15;
         propRewardSpr.x = propReward.x + propReward.width;
         propRewardSpr.y = propReward.y - 25;
         mySpr.addChild(propRewardSpr);
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("cityMap");
         mySpr = swf.createSprite("spr_advanceBg_s");
         mapNameTf = mySpr.getTextField("mapNameTf");
         closeBtn = mySpr.getButton("closeBtn");
         spr_raids = mySpr.getSprite("spr_raids");
         lessRaidsNumTF = spr_raids.getTextField("raidsNum");
         raidsAddBtn = spr_raids.getButton("raidsAddBtn");
         raidsBtn = spr_raids.getButton("raidsBtn");
         costPower = mySpr.getTextField("costPower");
         levelDec = mySpr.getTextField("levelDec");
         enemyElf = mySpr.getTextField("enemyElf");
         propReward = mySpr.getTextField("propReward");
         expReward = mySpr.getTextField("expReward");
         silverReward = mySpr.getTextField("silverReward");
         lessNum = mySpr.getTextField("lessNum");
         lessNumPrompt = mySpr.getTextField("lessNumPrompt");
         radiaPropmt = mySpr.getTextField("radiaPropmt");
         normalModeBtn = mySpr.getChildByName("normalModeBtn") as FeathersButton;
         hardModeBtn = mySpr.getChildByName("hardModeBtn") as FeathersButton;
         addChild(mySpr);
         lessRaidsNumTF.bold = true;
         mySpr.x = 1136 - mySpr.width >> 1;
         mySpr.y = 640 - mySpr.height >> 1;
         initAdvanceList();
         if(PlayerVO.raidsProp)
         {
            lessRaidsNumTF.text = PlayerVO.raidsProp.count;
         }
         else
         {
            lessRaidsNumTF.text = "0";
         }
      }
      
      private function initAdvanceList() : void
      {
         advanceList = new List();
         advanceList.width = 813;
         advanceList.height = 170;
         advanceList.x = 45;
         advanceList.y = 405;
         advanceList.horizontalScrollPolicy = "on";
         advanceList.verticalScrollPolicy = "off";
         mySpr.addChild(advanceList);
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_listUp").texture,new Rectangle(15,15,15,15));
         _loc1_.defaultSelectedValue = new Scale9Textures(swf.createImage("img_listDown").texture,new Rectangle(15,15,15,15));
         advanceList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         advanceList.addEventListener("creationComplete",changeHorizontalLayout);
      }
      
      private function changeHorizontalLayout() : void
      {
         LogUtil("准备了多少次");
         advanceList.removeEventListener("creationComplete",changeHorizontalLayout);
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.horizontalAlign = "justify";
         advanceList.layout = _loc1_;
         advanceList.itemRendererProperties.width = 134;
      }
      
      public function set levelVo(param1:MainMapVO) : void
      {
         LogUtil("是不是精英模式——",param1.isHard,param1.lessTime,param1.isPass);
         _mainMapVo = param1;
         levelDec.text = param1.descs;
         expReward.text = param1.getExp;
         silverReward.text = param1.rewardMoney;
         switchMode(param1.isHard);
         if(raidsAddBtn && raidsAddBtn.parent)
         {
            raidsAddBtn.removeFromParent(true);
         }
         if(param1.isHard)
         {
            raidsAddBtn = swf.createButton("btn_raids_b" + param1.lessTime);
            lessNum.text = param1.lessTime + "/" + param1.maxTime;
            lessNumPrompt.visible = true;
         }
         else
         {
            raidsAddBtn = swf.createButton("btn_maoxian2_b");
            lessNum.text = "";
            lessNumPrompt.visible = false;
         }
         raidsAddBtn.x = 67;
         raidsAddBtn.y = 75;
         spr_raids.addChild(raidsAddBtn);
         costPower.text = param1.needPower;
         if(btn_adventure && btn_adventure.parent)
         {
            btn_adventure.removeFromParent(true);
         }
         if(param1.isClub == 0)
         {
            btn_adventure = swf.createButton("btn_maoxianBtn_bb");
         }
         else
         {
            btn_adventure = swf.createButton("btn_lastBtn");
         }
         if(param1.lessTime == 0 && param1.isHard)
         {
            btn_adventure = swf.createButton("btn_restart_b");
         }
         btn_adventure.name = "changeBtn";
         btn_adventure.x = 725;
         btn_adventure.y = 294;
         mySpr.addChild(btn_adventure);
         spr_raids.visible = false;
         radiaPropmt.visible = false;
         if(param1.isHard && param1.hardStars == 3)
         {
            spr_raids.visible = true;
         }
         if(!param1.isHard && param1.normalStars == 3)
         {
            spr_raids.visible = true;
         }
         radiaPropmt.visible = !spr_raids.visible;
         if(!param1.isPass)
         {
            radiaPropmt.visible = false;
         }
         addElf(param1.pokeList,param1.isPass);
         addProp(param1.propList);
      }
      
      private function addProp(param1:Array) : void
      {
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = null;
         var _loc2_:* = null;
         propRewardSpr.removeChildren(0,-1,true);
         if(!param1)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].pId != -2)
            {
               if(MapPro.hidePropArr.indexOf(param1[_loc4_].pId) != -1)
               {
                  param1.splice(_loc4_,1);
                  _loc4_--;
               }
               else
               {
                  _loc5_ = param1[_loc4_].pId;
                  if(param1[_loc4_].pId == -1)
                  {
                     switch(PlayerVO.firstElfId - 1)
                     {
                        case 0:
                           _loc5_ = 134;
                           break;
                        case 3:
                           _loc5_ = 131;
                        case 6:
                           _loc5_ = 132;
                           break;
                        default:
                           _loc5_ = 131;
                     }
                  }
                  _loc5_ = param1[_loc4_].pId;
                  _loc3_ = GetPropFactor.getPropVO(_loc5_);
                  _loc2_ = new SimplePropUI(0.75,0,true,true);
                  _loc2_.myPropVo = _loc3_;
                  _loc2_.x = 90 * _loc4_;
                  propRewardSpr.addChild(_loc2_);
               }
            }
            _loc4_++;
         }
      }
      
      private function addElf(param1:Array, param2:Boolean) : void
      {
         var _loc9_:* = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = null;
         var _loc3_:* = null;
         var _loc11_:* = null;
         var _loc10_:* = null;
         var _loc4_:* = null;
         enemyElfSpr.removeChildren(0,-1,true);
         if(!param1)
         {
            return;
         }
         var _loc5_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            if(param2)
            {
               _loc5_ = param1[_loc7_].split(",");
               _loc9_ = _loc5_[0];
               _loc6_ = _loc5_[1];
               if(_loc9_ == "-1")
               {
                  _loc8_ = GetElfFactor.getElfVO(NPCVO.elfOfXiaoMao);
                  if(_loc6_ >= _loc8_.evoLv && _loc8_.evoLv != -1 && _loc8_.evolveId != "0")
                  {
                     NPCVO.elfOfXiaoMao = _loc8_.evolveId;
                     _loc3_ = GetElfFactor.getElfVO(NPCVO.elfOfXiaoMao);
                     if(_loc6_ >= _loc3_.evoLv && _loc8_.evoLv != -1 && _loc3_.evolveId != "0")
                     {
                        NPCVO.elfOfXiaoMao = _loc3_.evolveId;
                     }
                  }
                  _loc9_ = NPCVO.elfOfXiaoMao;
               }
               _loc11_ = GetElfFactor.getElfVO(_loc9_);
               _loc11_.lv = _loc6_;
               _loc10_ = new ElfBgUnitUI(true);
               _loc10_.myElfVo = _loc11_;
               var _loc12_:* = 0.75;
               _loc10_.scaleY = _loc12_;
               _loc10_.scaleX = _loc12_;
               _loc10_.x = 90 * _loc7_;
               enemyElfSpr.addChild(_loc10_);
            }
            else
            {
               _loc4_ = swf.createImage("img_unFineImg");
               _loc12_ = 1.05;
               _loc4_.scaleY = _loc12_;
               _loc4_.scaleX = _loc12_;
               _loc4_.x = 90 * _loc7_;
               enemyElfSpr.addChild(_loc4_);
            }
            _loc7_++;
         }
      }
      
      public function switchMode(param1:Boolean) : void
      {
         normalModeBtn.isEnabled = param1;
         hardModeBtn.isEnabled = !param1;
         CityMapMeida.isHard = param1;
      }
      
      public function setMapInfo(param1:Vector.<MainMapVO>) : void
      {
         mapNameTf.text = param1[0].name;
      }
   }
}
