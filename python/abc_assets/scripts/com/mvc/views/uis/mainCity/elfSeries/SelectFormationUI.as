package com.mvc.views.uis.mainCity.elfSeries
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import feathers.controls.List;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.views.uis.mainCity.home.ElfBgUnitUI;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import starling.display.Quad;
   
   public class SelectFormationUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_allelf:SwfSprite;
      
      public var power:TextField;
      
      public var btn_ok:SwfButton;
      
      public var allElfList:List;
      
      public var elfSprite:Sprite;
      
      public var temformaElfVec:Vector.<ElfVO>;
      
      public var formationContainVec:Vector.<ElfBgUnitUI>;
      
      public var btn_close:SwfButton;
      
      public function SelectFormationUI()
      {
         temformaElfVec = new Vector.<ElfVO>([]);
         formationContainVec = new Vector.<ElfBgUnitUI>([]);
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
         initFormation();
         allElfList.addEventListener("scrollStart",startScroll);
         allElfList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         ElfBgUnitUI.isScrolling = false;
         allElfList.dataViewPort.touchable = true;
      }
      
      private function startScroll() : void
      {
         ElfBgUnitUI.isScrolling = true;
         allElfList.dataViewPort.touchable = false;
      }
      
      private function addList() : void
      {
         allElfList = new List();
         allElfList.x = 82;
         allElfList.y = 232;
         allElfList.width = 960;
         allElfList.height = 260;
         allElfList.isSelectable = false;
         allElfList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:* = 0;
         allElfList.itemRendererProperties.paddingBottom = _loc1_;
         allElfList.itemRendererProperties.paddingTop = _loc1_;
         spr_allelf.addChild(allElfList);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         spr_allelf = swf.createSprite("spr_seleDefendElf");
         btn_ok = spr_allelf.getButton("btn_ok");
         btn_close = spr_allelf.getButton("btn_close2");
         power = spr_allelf.getTextField("power");
         spr_allelf.x = 74;
         spr_allelf.y = 76;
         addChild(spr_allelf);
         elfSprite = new Sprite();
         elfSprite.x = 161;
         elfSprite.y = 76;
         spr_allelf.addChild(elfSprite);
      }
      
      public function initFormation() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = null;
         formationContainVec = Vector.<ElfBgUnitUI>([]);
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc1_ = new ElfBgUnitUI();
            _loc1_.identify = "防守队伍";
            _loc1_.x = 113 * _loc2_;
            _loc1_.switchContain(false);
            elfSprite.addChild(_loc1_);
            formationContainVec.push(_loc1_);
            _loc2_++;
         }
      }
      
      public function initFormationElfVec(param1:Vector.<ElfVO>) : void
      {
         var _loc2_:* = 0;
         temformaElfVec = Vector.<ElfVO>([]);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            temformaElfVec.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function updateElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < PlayerVO.FormationElfVec.length)
         {
            if(PlayerVO.FormationElfVec[_loc1_] != null)
            {
               _loc2_ = 0;
               while(_loc2_ < PlayerVO.bagElfVec.length)
               {
                  if(PlayerVO.bagElfVec[_loc2_] != null)
                  {
                     if(PlayerVO.FormationElfVec[_loc1_].id == PlayerVO.bagElfVec[_loc2_].id)
                     {
                        PlayerVO.FormationElfVec[_loc1_] = PlayerVO.bagElfVec[_loc2_];
                        break;
                     }
                  }
                  _loc2_++;
               }
            }
            _loc1_++;
         }
      }
      
      public function regetData(param1:Vector.<ElfVO>) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            PlayerVO.FormationElfVec[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
      }
   }
}
