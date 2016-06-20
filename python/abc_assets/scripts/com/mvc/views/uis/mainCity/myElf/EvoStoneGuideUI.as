package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.display.Button;
   import feathers.controls.List;
   import feathers.display.Scale9Image;
   import starling.display.DisplayObject;
   import flash.text.TextFormat;
   import starling.events.Event;
   import com.mvc.views.uis.mainCity.backPack.ComposeUI;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.mvc.views.mediator.mainCity.backPack.BackPackMedia;
   import starling.display.Quad;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.managers.LoadOtherAssetsManager;
   import starling.utils.AssetManager;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import com.common.util.xmlVOHandler.GetMapFactor;
   import com.mvc.models.vos.mapSelect.MainMapVO;
   import starling.display.Image;
   import feathers.data.ListCollection;
   import com.mvc.views.mediator.mainCity.task.TaskMedia;
   import starling.core.Starling;
   import com.mvc.views.mediator.mapSelect.WorldMapMedia;
   import com.mvc.models.proxy.mapSelect.MapPro;
   import com.common.util.WinTweens;
   
   public class EvoStoneGuideUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI;
      
      public static var isEvoStoneGuide:Boolean;
      
      public static var cityID:int = -1;
      
      public static var nodeID:int;
      
      public static var nodeRcdID:int;
      
      public static var nodeRcdIndex:int;
      
      public static var isHard:Boolean;
      
      public static var parentPage:String = "";
       
      private var _propVO:PropVO;
      
      private var swf:Swf;
      
      public var evoStoneGuideSpr:SwfSprite;
      
      public var closeBtn:Button;
      
      public var backBtn:Button;
      
      public var headBtnList:List;
      
      public var stoneGuideBg:Scale9Image;
      
      public var stoneGuideList:List;
      
      public var notTouchArr:Array;
      
      public var displayVec:Vector.<DisplayObject>;
      
      private var disabledTextFormat:TextFormat;
      
      private var stateArr:Array;
      
      public function EvoStoneGuideUI()
      {
         notTouchArr = [];
         super();
         init();
         addList();
         this.addEventListener("triggered",triggeredHandler);
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI
      {
         return instance || new com.mvc.views.uis.mainCity.myElf.EvoStoneGuideUI();
      }
      
      private function addList() : void
      {
         stoneGuideList = new List();
         stoneGuideList.x = 20;
         stoneGuideList.y = 90;
         stoneGuideList.width = 480;
         stoneGuideList.height = 288;
         evoStoneGuideSpr.addChild(stoneGuideList);
         stoneGuideList.addEventListener("creationComplete",stoneGuideLis_createHandler);
      }
      
      private function triggeredHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(closeBtn !== _loc2_)
         {
            if(backBtn !== _loc2_)
            {
            }
            addr25:
            return;
         }
         remove();
         ComposeUI.getInstance().show(_propVO,parentPage);
         §§goto(addr25);
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent();
         }
      }
      
      public function show(param1:PropVO, param2:Array) : void
      {
         var _loc3_:* = null;
         _propVO = param1;
         stateArr = param2;
         setGuideListData();
         if(parentPage == "MyElfMedia")
         {
            _loc3_ = (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).myElf;
         }
         if(parentPage == "BackPackMedia")
         {
            _loc3_ = (Facade.getInstance().retrieveMediator("BackPackMedia") as BackPackMedia).backPack;
         }
         _loc3_.addChild(this);
      }
      
      private function init() : void
      {
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.5;
         addChild(_loc1_);
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("common");
         evoStoneGuideSpr = swf.createSprite("spr_evoStoneGuide");
         evoStoneGuideSpr.x = 1136 - evoStoneGuideSpr.width >> 1;
         evoStoneGuideSpr.y = 640 - evoStoneGuideSpr.height >> 1;
         addChild(evoStoneGuideSpr);
         closeBtn = evoStoneGuideSpr.getButton("closeBtn");
         backBtn = evoStoneGuideSpr.getButton("backBtn");
         stoneGuideBg = evoStoneGuideSpr.getChildByName("panelBg") as Scale9Image;
         disabledTextFormat = new TextFormat("FZCuYuan-M03S",22,10194846);
      }
      
      private function stoneGuideLis_createHandler(param1:Event) : void
      {
         var _loc2_:AssetManager = LoadOtherAssetsManager.getInstance().assets;
         var _loc3_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc3_.defaultValue = new Scale9Textures(_loc2_.getTexture("listBg"),new Rectangle(15,15,15,15));
         _loc3_.defaultSelectedValue = new Scale9Textures(_loc2_.getTexture("listBg"),new Rectangle(15,15,15,15));
         stoneGuideList.itemRendererProperties.stateToSkinFunction = _loc3_.updateValue;
      }
      
      private function setGuideListData() : void
      {
         var _loc6_:* = 0;
         var _loc8_:* = 0;
         var _loc4_:* = 0;
         var _loc16_:* = 0;
         var _loc13_:* = false;
         var _loc11_:* = false;
         var _loc12_:* = 0;
         var _loc17_:* = undefined;
         var _loc9_:* = 0;
         var _loc14_:* = null;
         var _loc10_:* = null;
         var _loc15_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         if(stoneGuideList.dataProvider)
         {
            stoneGuideList.dataProvider.removeAll();
            stoneGuideList.dataProvider = null;
         }
         notTouchArr.length = 0;
         var _loc7_:Array = GetMapFactor.allPropBirthPllace[_propVO.id];
         var _loc1_:Array = [];
         _loc6_ = 0;
         while(_loc6_ < _loc7_.length)
         {
            _loc8_ = GetMapFactor.countCityId(_loc7_[_loc6_].nodeId);
            _loc4_ = _loc7_[_loc6_].rcdId;
            _loc16_ = _loc7_[_loc6_].nodeId;
            _loc13_ = _loc7_[_loc6_].isHard;
            _loc11_ = stateArr[_loc6_];
            _loc17_ = GetMapFactor.getRecIdArr(_loc16_);
            _loc9_ = 0;
            while(_loc9_ < _loc17_.length)
            {
               if(_loc17_[_loc9_].id == _loc4_)
               {
                  _loc12_ = _loc9_;
                  break;
               }
               _loc9_++;
            }
            if(_loc13_)
            {
               _loc10_ = "<font color=\'#33cc00\' size=\'22\'>[精英]</font>";
            }
            else
            {
               _loc10_ = "<font color=\'#ff9900\' size=\'22\'>[普通]</font>";
            }
            if(_loc11_)
            {
               _loc15_ = "<font color=\'#48271b\' size=\'22\'>已开启</font>";
               _loc3_ = "\'#48271b\'";
            }
            else
            {
               _loc15_ = "<font color=\'#9b8f9e\' size=\'22\'>未开启</font>";
               _loc3_ = "\'#9b8f9e\'";
            }
            _loc14_ = "<font color=" + _loc3_ + " size=\'22\'>" + GetMapFactor.getCityNameById(_loc8_) + " - " + _loc17_[_loc12_].name + "  " + _loc10_ + "  " + _loc15_ + "\n" + _loc17_[_loc12_].descs + "</font>";
            _loc2_ = LoadSwfAssetsManager.getInstance().assets.getSwf("npcMin").createImage("img_" + _loc17_[_loc12_].picName);
            var _loc18_:* = 0.7;
            _loc2_.scaleY = _loc18_;
            _loc2_.scaleX = _loc18_;
            displayVec = new Vector.<DisplayObject>([]);
            displayVec.push(_loc2_);
            _loc1_.push({
               "label":_loc14_,
               "icon":_loc2_,
               "cityID":_loc8_,
               "nodeRcdID":_loc4_,
               "nodeID":_loc16_,
               "nodeRcdIndex":_loc12_,
               "isOpen":_loc11_,
               "isHard":_loc13_
            });
            _loc17_.length = 0;
            _loc17_ = null;
            _loc6_++;
         }
         var _loc5_:ListCollection = new ListCollection(_loc1_);
         stoneGuideList.dataProvider = _loc5_;
         stoneGuideList.addEventListener("change",stoneGuideList_changeHandler);
      }
      
      private function stoneGuideList_changeHandler(param1:Event) : void
      {
         var _loc5_:List = List(param1.currentTarget);
         var _loc4_:int = _loc5_.selectedIndex;
         if(_loc4_ < 0)
         {
            return;
         }
         var _loc3_:Object = stoneGuideList.dataProvider.getItemAt(stoneGuideList.selectedIndex);
         var _loc2_:Boolean = _loc3_.isOpen;
         isHard = _loc3_.isHard;
         nodeID = _loc3_.nodeID;
         if(!_loc2_)
         {
            TaskMedia.nodeId = _loc3_.nodeID;
            if(cityID == _loc3_.cityID && (Starling.current.root as Game).page.name == "MapMeida")
            {
               Facade.getInstance().sendNotification("update_city_point_open");
            }
            else
            {
               cityID = _loc3_.cityID;
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(cityID);
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            }
         }
         else
         {
            isEvoStoneGuide = true;
            LogUtil(_loc3_ + "sss" + stoneGuideList.selectedIndex);
            nodeRcdID = _loc3_.nodeRcdID;
            nodeRcdIndex = _loc3_.nodeRcdIndex;
            if(cityID == _loc3_.cityID && (Starling.current.root as Game).page.name == "MapMeida")
            {
               Facade.getInstance().sendNotification("open_main_advance_list_by_evoStone",isHard);
            }
            else
            {
               cityID = _loc3_.cityID;
               WorldMapMedia.mapVO = GetMapFactor.getMapVoById(cityID);
               Config.cityScene = WorldMapMedia.mapVO.bgImg;
               (Facade.getInstance().retrieveProxy("MapPro") as MapPro).write1703(WorldMapMedia.mapVO);
            }
         }
         stoneGuideList.selectedIndex = -1;
         removeOtherSource();
         WinTweens.showCity();
      }
      
      private function removeOtherSource() : void
      {
         if(parentPage == "MyElfMedia")
         {
            (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).myElf.removeFromParent();
         }
         if(parentPage == "BackPackMedia")
         {
            (Facade.getInstance().retrieveMediator("BackPackMedia") as BackPackMedia).backPack.removeFromParent();
         }
      }
   }
}
