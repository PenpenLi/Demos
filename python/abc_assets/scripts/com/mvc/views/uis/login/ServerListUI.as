package com.mvc.views.uis.login
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import feathers.controls.List;
   import lzm.starling.swf.display.SwfImage;
   import lzm.starling.swf.display.SwfScale9Image;
   import com.common.managers.LoadSwfAssetsManager;
   import com.common.util.GetCommon;
   import feathers.skins.SmartDisplayObjectStateValueSelector;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import feathers.layout.VerticalLayout;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import flash.text.TextFormat;
   import com.mvc.views.mediator.login.LoginMedia;
   import lzm.util.LSOManager;
   import com.mvc.models.vos.login.ServerVO;
   import starling.display.Quad;
   
   public class ServerListUI extends Sprite
   {
       
      private var swf:Swf;
      
      public var spr_server:SwfSprite;
      
      public var last_region:TextField;
      
      public var areaList:List;
      
      public var seleList:List;
      
      public var serverState:TextField;
      
      public var busy:SwfImage;
      
      public var full:SwfImage;
      
      public var normal:SwfImage;
      
      public var noPerson:SwfImage;
      
      public var backGround1:SwfScale9Image;
      
      public var backGround2:SwfScale9Image;
      
      private var title:TextField;
      
      public var myList:List;
      
      public function ServerListUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
         showState();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("login");
         spr_server = swf.createSprite("spr_serverbg");
         last_region = spr_server.getTextField("last_region");
         serverState = spr_server.getTextField("serverState");
         busy = spr_server.getImage("busy");
         full = spr_server.getImage("full");
         normal = spr_server.getImage("normal");
         noPerson = spr_server.getImage("noPerson");
         backGround1 = spr_server.getScale9Image("backGround1");
         backGround2 = spr_server.getScale9Image("backGround2");
         spr_server.x = 1136 - spr_server.width >> 1;
         spr_server.y = 640 - spr_server.height >> 1;
         addChild(spr_server);
         title = GetCommon.getText(backGround2.x,backGround2.y,backGround2.width,50,"本账号所有区服","FZCuYuan-M03S",25,6700061,spr_server,false,true);
      }
      
      private function addList() : void
      {
         areaList = new List();
         areaList.x = backGround2.x + 8;
         areaList.y = backGround2.y + 3;
         areaList.width = backGround2.width - 16;
         areaList.height = backGround2.height - 6;
         areaList.isSelectable = false;
         areaList.itemRendererProperties.stateToSkinFunction = null;
         spr_server.addChild(areaList);
         areaList.addEventListener("creationComplete",creatComplete);
         myList = new List();
         myList.x = backGround2.x + 8;
         myList.y = backGround2.y + 53;
         myList.width = backGround2.width - 16;
         myList.height = backGround2.height - 56;
         myList.isSelectable = false;
         myList.itemRendererProperties.stateToSkinFunction = null;
         spr_server.addChild(myList);
         seleList = new List();
         seleList.x = backGround1.x + 25;
         seleList.y = backGround1.y + 3;
         seleList.width = backGround1.width - 50;
         seleList.height = backGround1.height - 6;
         seleList.itemRendererProperties.stateToSkinFunction = null;
         var _loc1_:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
         _loc1_.defaultValue = new Scale9Textures(swf.createImage("img_line").texture,new Rectangle(1,1,151,47));
         _loc1_.defaultSelectedValue = new Scale9Textures(swf.createImage("img_title_touch").texture,new Rectangle(1,1,151,47));
         seleList.itemRendererProperties.stateToSkinFunction = _loc1_.updateValue;
         spr_server.addChild(seleList);
         seleList.addEventListener("creationComplete",creatComplete2);
         seleList.itemRendererProperties.minHeight = 47;
      }
      
      private function creatComplete() : void
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = -16;
         _loc1_.paddingTop = 5;
         areaList.layout = _loc1_;
      }
      
      private function creatComplete2() : void
      {
         var layout:VerticalLayout = new VerticalLayout();
         layout.horizontalAlign = "justify";
         layout.gap = -1;
         seleList.layout = layout;
         seleList.itemRendererFactory = function():IListItemRenderer
         {
            var _loc1_:DefaultListItemRenderer = new DefaultListItemRenderer();
            _loc1_.defaultSelectedLabelProperties.textFormat = new TextFormat("FZCuYuan-M03S",20,16763904,false,false,false,null,null,"left",0,0,0,0);
            return _loc1_;
         };
      }
      
      private function showState() : void
      {
         var _loc2_:* = null;
         var _loc1_:* = 0;
         busy.visible = false;
         full.visible = false;
         normal.visible = false;
         noPerson.visible = false;
         _loc1_ = 0;
         while(_loc1_ < LoginMedia.serverVec.length)
         {
            if(LoginMedia.serverVec[_loc1_].serverId == LSOManager.get("SERVERID"))
            {
               _loc2_ = LoginMedia.serverVec[_loc1_];
               break;
            }
            _loc1_++;
         }
         if(!_loc2_)
         {
            last_region.text = "未选择";
            noPerson.visible = true;
            return;
         }
         last_region.text = LSOManager.get("LASTLOGIN");
         if(_loc2_.clientnum >= 0 && _loc2_.clientnum < 20)
         {
            serverState.text = "流畅";
            serverState.color = 4759296;
            normal.visible = true;
         }
         else if(_loc2_.clientnum >= 20 && _loc2_.clientnum < 500)
         {
            serverState.text = "火爆";
            serverState.color = 16711680;
            full.visible = true;
         }
         else
         {
            serverState.text = "拥挤";
            serverState.color = 15820288;
            busy.visible = true;
         }
      }
      
      public function setype(param1:Boolean) : void
      {
         title.visible = param1;
         myList.touchable = param1;
         areaList.touchable = !param1;
      }
   }
}
