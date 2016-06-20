package com.mvc.views.uis.union.unionList
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import starling.text.TextField;
   import lzm.starling.swf.display.SwfButton;
   import com.mvc.models.vos.union.UnionVO;
   import starling.events.Event;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.union.UnionPro;
   import com.mvc.models.vos.login.PlayerVO;
   import feathers.controls.Alert;
   import feathers.data.ListCollection;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class UnionUnitUI extends Sprite
   {
       
      private var swf:Swf;
      
      private var spr_unionUint:SwfSprite;
      
      private var unionName:TextField;
      
      private var unionRank:TextField;
      
      private var unionLv:TextField;
      
      private var unionCDR:TextField;
      
      private var unionNum:TextField;
      
      private var unionNews:TextField;
      
      private var btn_apply:SwfButton;
      
      private var btn_cancelApply:SwfButton;
      
      private var _unionVo:UnionVO;
      
      public function UnionUnitUI()
      {
         super();
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("union");
         spr_unionUint = swf.createSprite("spr_unionUint");
         unionRank = spr_unionUint.getTextField("unionRank");
         unionName = spr_unionUint.getTextField("unionName");
         unionLv = spr_unionUint.getTextField("unionLv");
         unionCDR = spr_unionUint.getTextField("unionCDR");
         unionNum = spr_unionUint.getTextField("unionNum");
         unionNews = spr_unionUint.getTextField("unionNews");
         unionRank.autoScale = true;
         unionName.autoScale = true;
         addChild(spr_unionUint);
         btn_cancelApply = addBtn("btn_cancelApply");
         btn_apply = addBtn("btn_applyFor");
         btn_cancelApply.visible = false;
         btn_apply.visible = false;
         this.addEventListener("triggered",clickEvent);
      }
      
      private function clickEvent(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(btn_cancelApply !== _loc3_)
         {
            if(btn_apply === _loc3_)
            {
               if(!PlayerVO.isOpenUnion)
               {
                  _loc2_ = Alert.show("退出公会后当天申请公会需要消耗100钻石，你确定要申请么？","温馨提示",new ListCollection([{"label":"确定"},{"label":"取消"}]));
                  _loc2_.addEventListener("close",applyAlertHander);
                  return;
               }
               EventCenter.addEventListener("APPLY_UNION_SUCCESS",applyOK);
               LogUtil("申请加入公会=========",_unionVo.unionName,_unionVo.unionId);
               (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3401(_unionVo.unionId);
            }
         }
         else
         {
            EventCenter.addEventListener("CANCELAPPLY_UNION_SUCCESS",cancelApplyOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3406(_unionVo.unionId);
         }
      }
      
      public function set myUnionVo(param1:UnionVO) : void
      {
         _unionVo = param1;
         unionRank.text = param1.unionRank;
         unionName.text = param1.unionName;
         unionLv.text = param1.unionLv;
         unionCDR.text = param1.unionRCD;
         unionNum.text = param1.nowMemberNum + "/" + param1.maxMemberNum;
         switch(param1.applyStatus)
         {
            case 0:
               addTxt(param1.needLv + "级以上可申请");
               break;
            case 1:
               addTxt("公会已满");
               break;
            case 2:
               switchBtn(true);
               break;
            case 3:
               switchBtn(false);
               break;
         }
         if(param1.notice != "")
         {
            unionNews.text = param1.notice.substring(0,16);
         }
         else
         {
            unionNews.text = "这个会长很懒的，什么都没写呢";
         }
      }
      
      private function cancelApplyOK() : void
      {
         EventCenter.removeEventListener("CANCELAPPLY_UNION_SUCCESS",cancelApplyOK);
         switchBtn(true);
      }
      
      private function apply(param1:Event) : void
      {
      }
      
      private function applyAlertHander(param1:Event) : void
      {
         if(param1.data.label == "确定")
         {
            EventCenter.addEventListener("CANCEL_NOTICE_APPLYLVLIMT",cancelApplyLimtOK);
            (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3415();
         }
      }
      
      private function cancelApplyLimtOK() : void
      {
         EventCenter.removeEventListener("CANCEL_NOTICE_APPLYLVLIMT",cancelApplyLimtOK);
         EventCenter.addEventListener("APPLY_UNION_SUCCESS",applyOK);
         (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3401(_unionVo.unionId);
      }
      
      private function applyOK() : void
      {
         EventCenter.removeEventListener("APPLY_UNION_SUCCESS",applyOK);
         switchBtn(false);
      }
      
      private function switchBtn(param1:Boolean) : void
      {
         btn_apply.visible = param1;
         btn_cancelApply.visible = !param1;
      }
      
      private function addBtn(param1:String) : SwfButton
      {
         var _loc2_:SwfButton = swf.createButton(param1);
         _loc2_.x = 68;
         _loc2_.y = 211;
         addChild(_loc2_);
         return _loc2_;
      }
      
      private function addTxt(param1:String) : void
      {
         var _loc2_:TextField = new TextField(170,40,param1,"FZCuYuan-M03S",20,16711680,true);
         _loc2_.x = 23;
         _loc2_.y = 215;
         _loc2_.autoScale = true;
         addChild(_loc2_);
      }
   }
}
