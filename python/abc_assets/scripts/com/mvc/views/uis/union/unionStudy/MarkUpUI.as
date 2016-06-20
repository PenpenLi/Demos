package com.mvc.views.uis.union.unionStudy
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.union.MarkUpVO;
   import com.common.managers.LoadSwfAssetsManager;
   import starling.display.Image;
   import com.common.util.GetCommon;
   import com.common.util.xmlVOHandler.GetUnionInfo;
   import flash.geom.Rectangle;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import starling.events.Event;
   import com.common.themes.Tips;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.views.mediator.fighting.AniFactor;
   import com.mvc.views.mediator.union.unionStudy.StudyChildMedia;
   import starling.display.Quad;
   
   public class MarkUpUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.union.unionStudy.MarkUpUI;
       
      private var swf:Swf;
      
      private var spr_addExp:SwfSprite;
      
      private var lvTxt:TextField;
      
      private var proTxt:TextField;
      
      private var spr_exp:SwfSprite;
      
      private var btn_silver:SwfButton;
      
      private var btn_diamond:SwfButton;
      
      private var silverDonateTxt:TextField;
      
      private var diamonDonateTxt:TextField;
      
      private var _markUpVo:MarkUpVO;
      
      private var btn_close:SwfButton;
      
      private var expWidth:Number;
      
      private var title:TextField;
      
      private var medalSwf:Swf;
      
      private var spr_MedalExp:SwfSprite;
      
      private var medalExpTxt:TextField;
      
      public function MarkUpUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.9;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionStudy.MarkUpUI
      {
         return instance || new com.mvc.views.uis.union.unionStudy.MarkUpUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionStudy");
         spr_addExp = swf.createSprite("spr_addExp");
         title = spr_addExp.getTextField("title");
         lvTxt = spr_addExp.getTextField("lvTxt");
         proTxt = spr_addExp.getTextField("proTxt");
         spr_exp = spr_addExp.getSprite("spr_exp");
         btn_close = spr_addExp.getButton("btn_close");
         btn_silver = spr_addExp.getButton("btn_silver");
         btn_diamond = spr_addExp.getButton("btn_diamond");
         expWidth = spr_exp.width;
         spr_addExp.x = 1136 - spr_addExp.width >> 1;
         spr_addExp.y = 140;
         addChild(spr_addExp);
         silverDonateTxt = (btn_silver.skin as Sprite).getChildByName("donateTxt") as TextField;
         diamonDonateTxt = (btn_diamond.skin as Sprite).getChildByName("donateTxt") as TextField;
         addMedalExp();
      }
      
      private function addMedalExp() : void
      {
         medalSwf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionMedal");
         medalExp(btn_silver.skin as Sprite,200);
         medalExp(btn_diamond.skin as Sprite,300);
         spr_MedalExp = medalSwf.createSprite("spr_exp");
         medalExpTxt = spr_MedalExp.getTextField("expTxt");
         medalExpTxt.pivotX = medalExpTxt.width / 2;
         medalExpTxt.x = medalExpTxt.x + medalExpTxt.width / 2;
         medalExpTxt.fontName = "img_medalFont";
         spr_MedalExp.x = 1136 - spr_MedalExp.width >> 1;
         spr_MedalExp.y = 20;
         addChild(spr_MedalExp);
      }
      
      private function medalExp(param1:Sprite, param2:int) : void
      {
         var _loc3_:Image = medalSwf.createImage("img_medalExp");
         _loc3_.x = 20;
         _loc3_.y = 145;
         GetCommon.getText(_loc3_.x + _loc3_.width,_loc3_.y,60,_loc3_.height,"+" + param2,"FZCuYuan-M03S",20,12284175,param1);
         param1.addChild(_loc3_);
      }
      
      public function set myMarkUpVo(param1:MarkUpVO) : void
      {
         _markUpVo = param1;
         lvTxt.text = "Lv." + param1.lv;
         title.text = param1.title;
         var _loc2_:int = GetUnionInfo.GetMarkUpExp(param1.lv - 1,param1.type);
         var _loc4_:int = param1.exp - _loc2_;
         var _loc3_:int = GetUnionInfo.GetMarkUpExp(param1.lv,param1.type) - _loc2_;
         proTxt.text = _loc4_ + "/" + _loc3_;
         spr_exp.clipRect = new Rectangle(0,0,expWidth * _loc4_ / _loc3_,spr_exp.height);
         silverDonateTxt.text = "每日捐献: " + param1.silverCount + "/5";
         diamonDonateTxt.text = "每日捐献: " + param1.diamondCount + "/3";
         medalExpTxt.text = PlayerVO.medalExp - GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv) + "/" + (GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv + 1) - GetUnionMedal.GetMedalLvExp(PlayerVO.medalLv));
         this.addEventListener("triggered",onclick);
      }
      
      private function onclick(param1:Event) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc4_:* = param1.target;
         if(btn_close !== _loc4_)
         {
            if(btn_diamond !== _loc4_)
            {
               if(btn_silver === _loc4_)
               {
                  if(PlayerVO.silver < 25000)
                  {
                     return Tips.show("金币不足");
                  }
                  if(_markUpVo.silverCount <= 0)
                  {
                     return Tips.show("亲，捐献次数用完了哦，明天再来吧");
                  }
                  _loc2_ = Alert.show("您是否确定使用25000金币捐献？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",silverAlertHander);
               }
            }
            else
            {
               if(PlayerVO.diamond < 50)
               {
                  return Tips.show("钻石不足");
               }
               if(_markUpVo.diamondCount <= 0)
               {
                  return Tips.show("亲，捐献次数用完了哦，明天再来吧");
               }
               _loc3_ = Alert.show("您是否确定使用50钻石捐献？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
               _loc3_.addEventListener("close",diamondAlertHander);
            }
         }
         else
         {
            remove();
         }
      }
      
      private function silverAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("UNION_DONATE_SUCCESS",donateOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3422(_markUpVo.type,1,_markUpVo);
         }
      }
      
      private function diamondAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("UNION_DONATE_SUCCESS",donateOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3422(_markUpVo.type,2,_markUpVo);
         }
      }
      
      private function donateOK(param1:Event) : void
      {
         EventCenter.removeEventListener("UNION_DONATE_SUCCESS",donateOK);
         var _loc2_:MarkUpVO = param1.data.markVO;
         _markUpVo = _loc2_;
         myMarkUpVo = _markUpVo;
         AniFactor.ScaleMaxAni(medalExpTxt);
         if(_markUpVo.isMedalUp)
         {
            _markUpVo.isMedalUp = false;
            MedalUpUI.getInstance().show(this.parent);
         }
      }
      
      public function show() : void
      {
         var _loc1_:Sprite = (Facade.getInstance().retrieveMediator("StudyChildMedia") as StudyChildMedia).studyChild;
         _loc1_.addChild(this);
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            this.removeFromParent(true);
            EventCenter.dispatchEvent("UNION_DONATE_OK",{"markVO":_markUpVo});
         }
         instance = null;
      }
   }
}
