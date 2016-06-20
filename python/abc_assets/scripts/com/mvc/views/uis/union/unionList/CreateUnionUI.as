package com.mvc.views.uis.union.unionList
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import lzm.starling.swf.display.SwfButton;
   import starling.text.TextField;
   import com.common.managers.LoadSwfAssetsManager;
   import com.mvc.models.vos.login.PlayerVO;
   import com.common.util.WinTweens;
   import starling.events.Event;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.common.themes.Tips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.union.UnionPro;
   import starling.display.Quad;
   
   public class CreateUnionUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.union.unionList.CreateUnionUI;
       
      private var swf:Swf;
      
      private var spr_createUnion:SwfSprite;
      
      private var unionNameInput:FeathersTextInput;
      
      private var btn_cancel:SwfButton;
      
      private var btn_create:SwfButton;
      
      private var price:TextField;
      
      public function CreateUnionUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionList.CreateUnionUI
      {
         return instance || new com.mvc.views.uis.union.unionList.CreateUnionUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("union");
         spr_createUnion = swf.createSprite("spr_createUnion");
         unionNameInput = spr_createUnion.getChildByName("unionNameInput") as FeathersTextInput;
         btn_cancel = spr_createUnion.getButton("btn_cancel");
         btn_create = spr_createUnion.getButton("btn_create");
         price = spr_createUnion.getTextField("price");
         spr_createUnion.getTextField("diamondNum").text = PlayerVO.diamond;
         unionNameInput.width = 250;
         unionNameInput.paddingLeft = 10;
         unionNameInput.paddingTop = 5;
         unionNameInput.maxChars = 6;
         unionNameInput.prompt = "不能超过6个字";
         spr_createUnion.x = 1136 - spr_createUnion.width >> 1;
         spr_createUnion.y = 640 - spr_createUnion.height >> 1;
         addChild(spr_createUnion);
         WinTweens.openWin(spr_createUnion);
         this.addEventListener("triggered",click);
      }
      
      private function click(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_create !== _loc2_)
         {
            if(btn_cancel === _loc2_)
            {
               WinTweens.closeWin(spr_createUnion,remove);
               EventCenter.removeEventListener("CREATE_UNION_SUCCESS",removeAni);
            }
         }
         else if(PlayerVO.diamond >= price.text)
         {
            if(unionNameInput.text != "")
            {
               if(CheckSensitiveWord.checkSensitiveWord(unionNameInput.text))
               {
                  return Tips.show("不能有敏感词哦");
               }
               EventCenter.addEventListener("CREATE_UNION_SUCCESS",removeAni);
               (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3403(unionNameInput.text);
            }
            else
            {
               Tips.show("亲，您还没有输入公会名字哦");
            }
         }
         else
         {
            Tips.show("亲， 您的钻石不足哦");
         }
      }
      
      private function removeAni() : void
      {
         EventCenter.removeEventListener("CREATE_UNION_SUCCESS",removeAni);
         remove();
         Facade.getInstance().sendNotification("switch_page","LOAD_UNIONWORLD_PAGE");
      }
      
      public function remove() : void
      {
         if(getInstance().parent)
         {
            getInstance().removeFromParent(true);
         }
         instance = null;
      }
   }
}
