package com.mvc.views.uis.mainCity.exChange
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.display.SwfImage;
   import starling.text.TextField;
   import feathers.controls.Label;
   import com.mvc.models.vos.mainCity.exChange.ExChangeVO;
   import feathers.controls.ScrollContainer;
   import starling.display.Image;
   import feathers.layout.HorizontalLayout;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.views.mediator.mainCity.exChange.ExChangeMedia;
   import com.common.managers.ElfFrontImageManager;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.mainCity.exChange.ExChangePro;
   import com.common.util.xmlVOHandler.GetElfFactor;
   import com.common.util.AniEffects;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GotoExChange extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.mainCity.exChange.GotoExChange;
       
      private var swf:Swf;
      
      private var spr_gotoExChange:SwfSprite;
      
      private var btn_ok:SwfButton;
      
      private var btn_cancel:SwfButton;
      
      private var bottom:SwfImage;
      
      private var elfName:TextField;
      
      private var title:Label;
      
      private var _exChangeVo:ExChangeVO;
      
      public var colorArr:Array;
      
      private var panel:ScrollContainer;
      
      public var seleElfArr:Array;
      
      private var image:Image;
      
      private var light2:SwfImage;
      
      private var lightBase2:SwfImage;
      
      private var costElfVec:Vector.<com.mvc.views.uis.mainCity.exChange.CostElfUnitUI>;
      
      private var propmt:TextField;
      
      public function GotoExChange()
      {
         colorArr = ["#ffe356","#48db00","#39c9ff","#d490fb","#ffb64c"];
         seleElfArr = [];
         costElfVec = new Vector.<com.mvc.views.uis.mainCity.exChange.CostElfUnitUI>([]);
         super();
         init();
         addLabel();
         addContain();
      }
      
      public static function getInstance() : com.mvc.views.uis.mainCity.exChange.GotoExChange
      {
         return instance || new com.mvc.views.uis.mainCity.exChange.GotoExChange();
      }
      
      private function addContain() : void
      {
         panel = new ScrollContainer();
         spr_gotoExChange.addChild(panel);
         panel.width = 500;
         panel.height = 200;
         panel.y = 65;
         panel.x = 50;
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.verticalAlign = "middle";
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 10;
         _loc1_.useVirtualLayout = false;
         panel.scrollBarDisplayMode = "none";
         panel.horizontalScrollPolicy = "none";
         panel.layout = _loc1_;
      }
      
      private function addLabel() : void
      {
         title = GetCommon.getLabel(this,50,0,24);
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("exChange");
         spr_gotoExChange = swf.createSprite("spr_gotoExChange");
         btn_ok = spr_gotoExChange.getButton("btn_ok");
         btn_cancel = spr_gotoExChange.getButton("btn_cancel");
         light2 = spr_gotoExChange.getImage("light2");
         lightBase2 = spr_gotoExChange.getImage("lightBase2");
         elfName = spr_gotoExChange.getTextField("elfName");
         addChild(spr_gotoExChange);
         propmt = GetCommon.getText(50,-30,8,30,"注意: 背包、训练、联盟大赛防守阵容的精灵不能用于交换。","FZCuYuan-M03S",20,16777215,spr_gotoExChange,true);
      }
      
      public function show(param1:ExChangeVO, param2:Sprite) : void
      {
         _exChangeVo = param1;
         title.text = "<font color=\'#ffffff\'>可以使用以下精灵兑换</font><font color=\'" + colorArr[param1.getElfVo.rareValue - 1] + "\'> [ " + param1.getElfVo.rare + " ] </font><font color=\'#ffffff\'>精灵 </font><font color=\'#39c9ff\'>" + param1.getElfVo.name + "</font>";
         addExchangeElf();
         light2.color = ExChangeMedia.lightArr[param1.index];
         lightBase2.color = ExChangeMedia.lightSourceArr[param1.index];
         elfName.text = param1.getElfVo.name;
         ElfFrontImageManager.getInstance().getImg([param1.getElfVo.imgName],showElf);
         ElfFrontImageManager.tempNoRemoveTexture.push(param1.getElfVo.imgName);
         addEventListener("triggered",clickHandler);
         this.x = 1136 - this.width >> 1;
         this.y = 150;
         param2.addChild(this);
      }
      
      private function addExchangeElf() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = null;
         panel.removeChildren(0,-1,true);
         costElfVec = Vector.<com.mvc.views.uis.mainCity.exChange.CostElfUnitUI>([]);
         _loc1_ = 0;
         while(_loc1_ < _exChangeVo.elfVec.length)
         {
            _loc2_ = new com.mvc.views.uis.mainCity.exChange.CostElfUnitUI();
            _loc2_.myElfVo = _exChangeVo.elfVec[_loc1_];
            if(_loc1_ > 0)
            {
               panel.addChild(swf.createImage("img_add"));
            }
            panel.addChild(_loc2_);
            costElfVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = null;
         var _loc4_:* = param1.target;
         if(btn_ok !== _loc4_)
         {
            if(btn_cancel === _loc4_)
            {
               remove();
            }
         }
         else
         {
            LogUtil("_exChangeVo.lessNum == ",_exChangeVo.lessNum);
            if(_exChangeVo.lessNum <= 0)
            {
               return Tips.show("亲，交换剩余次数不足");
            }
            _loc3_ = 0;
            while(_loc3_ < costElfVec.length)
            {
               if(!costElfVec[_loc3_].isPass)
               {
                  return Tips.show("亲，请放入交换的精灵");
               }
               _loc3_++;
            }
            _loc2_ = Alert.show("亲，是否确定交换？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
            _loc2_.addEventListener("close",alertHander);
         }
      }
      
      private function alertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("EXCHANGE_ELF_SUCCESS",exChangeOk);
            (Facade.getInstance().retrieveProxy("ExChangePro") as ExChangePro).write3801(_exChangeVo.modeLv,seleElfArr);
         }
      }
      
      private function exChangeOk() : void
      {
         var _loc1_:* = 0;
         EventCenter.removeEventListener("EXCHANGE_ELF_SUCCESS",exChangeOk);
         seleElfArr = [];
         §§dup(_exChangeVo).lessNum--;
         LogUtil("_exChangeVo.lessNum ===== ",_exChangeVo.lessNum);
         _loc1_ = 0;
         while(_loc1_ < costElfVec.length)
         {
            GetElfFactor.deleElf(costElfVec[_loc1_]._elfVo);
            _loc1_++;
         }
         addExchangeElf();
      }
      
      public function remove() : void
      {
         var _loc1_:* = 0;
         AniEffects.closeAni(image,light2,lightBase2);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            AniEffects.closeAni(spr_gotoExChange.getImage("point" + _loc1_));
            _loc1_++;
         }
         Facade.getInstance().sendNotification("CLOSE_EXCHANGE_ELF");
         EventCenter.dispatchEvent("EXCHANGE_RESULTS");
         ElfFrontImageManager.tempNoRemoveTexture = [];
         panel.removeChildren(0,-1,true);
         removeFromParent(true);
         instance = null;
      }
      
      private function showElf() : void
      {
         var _loc1_:* = 0;
         image = new Image(LoadOtherAssetsManager.getInstance().assets.getTexture(_exChangeVo.getElfVo.imgName));
         ElfFrontImageManager.getInstance().autoZoom(image,240);
         image.x = 790;
         image.y = 200;
         spr_gotoExChange.addChildAt(image,spr_gotoExChange.numChildren - 4);
         AniEffects.openAni(true);
         AniEffects.elfMoveAni(image,40,2);
         AniEffects.changeColor(light2,1);
         AniEffects.changeColor(lightBase2,1);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            AniEffects.particleAni(spr_gotoExChange.getImage("point" + _loc1_),light2.x + 20,light2.y - 50,light2.width - 40,light2.height - 50,1);
            _loc1_++;
         }
      }
   }
}
