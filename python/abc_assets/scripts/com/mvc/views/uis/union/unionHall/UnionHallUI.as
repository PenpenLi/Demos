package com.mvc.views.uis.union.unionHall
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import feathers.controls.List;
   import lzm.starling.swf.components.feathers.FeathersCheck;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.util.xmlVOHandler.GetUnionInfo;
   import flash.geom.Rectangle;
   import com.mvc.models.vos.login.PlayerVO;
   import lzm.starling.swf.display.SwfImage;
   import starling.display.Image;
   import starling.display.Quad;
   
   public class UnionHallUI extends Sprite
   {
      
      public static var isScrolling:Boolean;
       
      private var swf:Swf;
      
      public var spr_unionHall:SwfSprite;
      
      public var btn_close:SwfButton;
      
      public var proText:TextField;
      
      public var spr_pro:SwfSprite;
      
      public var unionName:TextField;
      
      public var unionLv:TextField;
      
      public var unionRank:TextField;
      
      public var unionNum:TextField;
      
      public var btn_check:SwfButton;
      
      public var btn_hiring:SwfButton;
      
      public var btn_exitUnion:SwfButton;
      
      public var btn_help:SwfButton;
      
      public var hallList:List;
      
      private var spr_btn1:SwfSprite;
      
      private var spr_btn2:SwfSprite;
      
      public var setting:FeathersCheck;
      
      public var btn_member:SwfButton;
      
      public var btn_setting:SwfButton;
      
      public var btn_allReject:SwfButton;
      
      public var noApply:TextField;
      
      private var expWidth:Number;
      
      public function UnionHallUI()
      {
         super();
         var _loc2_:Swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         var _loc3_:Image = _loc2_.createImage("img_bg0");
         addChild(_loc3_);
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
         addList();
         initSettingBtn();
         initTxt();
         initMemberBtn();
         switchTxt(true);
         spr_unionHall.addChild(spr_btn1);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionHall");
         spr_unionHall = swf.createSprite("spr_unionHall");
         btn_close = spr_unionHall.getButton("btn_close");
         proText = spr_unionHall.getTextField("proText");
         spr_pro = spr_unionHall.getSprite("spr_pro");
         unionName = spr_unionHall.getTextField("unionName");
         unionLv = spr_unionHall.getTextField("unionLv");
         unionRank = spr_unionHall.getTextField("unionRank");
         unionNum = spr_unionHall.getTextField("unionNum");
         expWidth = spr_pro.width;
         unionLv.autoScale = true;
         unionName.autoScale = true;
         unionRank.autoScale = true;
         unionNum.autoScale = true;
         spr_unionHall.x = 1136 - spr_unionHall.width >> 1;
         spr_unionHall.y = 640 - spr_unionHall.height >> 1;
         addChild(spr_unionHall);
      }
      
      private function addList() : void
      {
         hallList = new List();
         hallList.width = 720;
         hallList.height = 350;
         hallList.x = 260;
         hallList.y = 217;
         hallList.isSelectable = false;
         hallList.itemRendererProperties.stateToSkinFunction = null;
         hallList.itemRendererProperties.paddingTop = 0;
         hallList.itemRendererProperties.paddingBottom = 0;
         spr_unionHall.addChild(hallList);
         hallList.addEventListener("scrollStart",startScroll);
         hallList.addEventListener("scrollComplete",scrollComplete);
      }
      
      private function scrollComplete() : void
      {
         isScrolling = false;
      }
      
      private function startScroll() : void
      {
         isScrolling = true;
      }
      
      public function showInfo() : void
      {
         unionLv.text = UnionPro.myUnionVO.unionLv;
         unionName.text = UnionPro.myUnionVO.unionName;
         unionNum.text = UnionPro.myUnionVO.nowMemberNum + "/" + UnionPro.myUnionVO.maxMemberNum;
         unionRank.text = UnionPro.myUnionVO.unionRank;
         var _loc1_:Number = GetUnionInfo.GetUnionLvExp(UnionPro.myUnionVO.unionLv - 1);
         var _loc3_:Number = UnionPro.myUnionVO.unionExp - _loc1_;
         var _loc2_:Number = GetUnionInfo.GetUnionLvExp(UnionPro.myUnionVO.unionLv) - _loc1_;
         proText.text = _loc3_ + "/" + _loc2_;
         spr_pro.clipRect = new Rectangle(0,0,expWidth * _loc3_ / _loc2_,spr_pro.height);
         if(PlayerVO.userId == UnionPro.myUnionVO.unionRCDId || UnionPro.myUnionVO.unionViceRCDIdArr.indexOf(PlayerVO.userId) != -1)
         {
            btn_check.visible = true;
            btn_hiring.visible = true;
         }
         else
         {
            btn_check.visible = false;
            btn_hiring.visible = false;
         }
      }
      
      private function initMemberBtn() : void
      {
         spr_btn1 = swf.createSprite("spr_btn1");
         btn_check = spr_btn1.getButton("btn_check");
         if(UnionPro.myUnionVO.isApply)
         {
            ((btn_check.skin as Sprite).getChildByName("promptImg") as SwfImage).visible = true;
         }
         else
         {
            ((btn_check.skin as Sprite).getChildByName("promptImg") as SwfImage).visible = false;
         }
         btn_hiring = spr_btn1.getButton("btn_hiring");
         btn_exitUnion = spr_btn1.getButton("btn_exitUnion");
         btn_help = spr_btn1.getButton("btn_help");
         spr_btn1.x = 92;
         spr_btn1.y = 312;
      }
      
      private function initSettingBtn() : void
      {
         spr_btn2 = swf.createSprite("spr_btn2");
         setting = spr_btn2.getChildByName("setting") as FeathersCheck;
         btn_member = spr_btn2.getButton("btn_member");
         btn_setting = spr_btn2.getButton("btn_setting");
         btn_allReject = spr_btn2.getButton("btn_allReject");
         spr_btn2.x = 92;
         spr_btn2.y = 312;
      }
      
      public function switchBtn() : void
      {
         LogUtil(spr_btn1.parent,spr_btn2.parent);
         if(spr_btn1.parent)
         {
            spr_btn1.removeFromParent();
            spr_unionHall.addChild(spr_btn2);
            switchTxt(false);
            setting.isSelected = UnionPro.myUnionVO.isAutoEnter;
            return;
         }
         if(spr_btn2.parent)
         {
            spr_btn2.removeFromParent();
            spr_unionHall.addChild(spr_btn1);
            switchTxt(true);
         }
      }
      
      public function clean() : void
      {
         if(spr_btn2.parent)
         {
            spr_btn2.removeFromParent(true);
         }
         if(spr_btn1.parent)
         {
            spr_btn1.removeFromParent(true);
         }
      }
      
      public function switchTxt(param1:Boolean) : void
      {
         spr_unionHall.getImage("txt3").visible = param1;
         spr_unionHall.getImage("txt4").visible = param1;
         spr_unionHall.getImage("txt5").visible = param1;
         spr_unionHall.getImage("txt9").visible = !param1;
      }
      
      public function initTxt() : void
      {
         noApply = new TextField(700,50,"当前没有收到玩家的申请哦","FZCuYuan-M03S",32,12275727,true);
         noApply.x = 260;
         noApply.y = 350;
      }
   }
}
