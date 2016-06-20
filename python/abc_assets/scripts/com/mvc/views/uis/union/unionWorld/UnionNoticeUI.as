package com.mvc.views.uis.union.unionWorld
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import lzm.starling.swf.display.SwfSprite;
   import lzm.starling.swf.display.SwfButton;
   import lzm.starling.swf.components.feathers.FeathersTextInput;
   import com.common.managers.LoadSwfAssetsManager;
   import feathers.core.ITextEditor;
   import feathers.controls.text.StageTextTextEditor;
   import starling.events.Event;
   import com.common.util.WinTweens;
   import com.common.util.strHandler.StrHandle;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.models.proxy.union.UnionPro;
   import com.common.consts.ConfigConst;
   import starling.display.Quad;
   
   public class UnionNoticeUI extends Sprite
   {
      
      public static var instance:com.mvc.views.uis.union.unionWorld.UnionNoticeUI;
       
      private var swf:Swf;
      
      private var spr_notice:SwfSprite;
      
      private var btn_ok:SwfButton;
      
      private var input_notice:FeathersTextInput;
      
      private var btn_cancel:SwfButton;
      
      public function UnionNoticeUI()
      {
         super();
         var _loc1_:Quad = new Quad(1136,640,0);
         _loc1_.alpha = 0.7;
         addChild(_loc1_);
         init();
      }
      
      public static function getInstance() : com.mvc.views.uis.union.unionWorld.UnionNoticeUI
      {
         return instance || new com.mvc.views.uis.union.unionWorld.UnionNoticeUI();
      }
      
      private function init() : void
      {
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionWorld");
         spr_notice = swf.createSprite("spr_notice");
         btn_ok = spr_notice.getButton("btn_ok");
         btn_cancel = spr_notice.getButton("btn_cancel");
         input_notice = spr_notice.getChildByName("input_notice") as FeathersTextInput;
         input_notice.width = 471;
         input_notice.height = 190;
         input_notice.paddingLeft = 10;
         input_notice.paddingTop = 5;
         input_notice.paddingRight = 10;
         input_notice.maxChars = 40;
         input_notice.textEditorFactory = textFactory;
         spr_notice.x = 1136 - spr_notice.width >> 1;
         spr_notice.y = 640 - spr_notice.height >> 1;
         addChild(spr_notice);
         this.addEventListener("triggered",clickHandler);
      }
      
      private function textFactory() : ITextEditor
      {
         var _loc1_:StageTextTextEditor = new StageTextTextEditor();
         _loc1_.multiline = true;
         _loc1_.color = 5715237;
         _loc1_.fontSize = 25;
         _loc1_.fontFamily = "FZCuYuan-M03S";
         return _loc1_;
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(btn_cancel !== _loc2_)
         {
            if(btn_ok === _loc2_)
            {
               if(StrHandle.isAllSpace(input_notice.text))
               {
                  Tips.show("请输入内容");
                  return;
               }
               if(CheckSensitiveWord.checkSensitiveWord(input_notice.text))
               {
                  Tips.show("不能有敏感词哦。");
                  return;
               }
               if(input_notice.text != "")
               {
                  EventCenter.addEventListener("EDIT_NOTICE_SUCCESS",editSuccess);
                  (Facade.getInstance().retrieveProxy("UnionPro") as UnionPro).write3405(input_notice.text);
               }
               else
               {
                  Tips.show("请输入内容");
               }
            }
         }
         else
         {
            WinTweens.closeWin(spr_notice,remove);
            input_notice.text = "";
         }
      }
      
      private function editSuccess() : void
      {
         EventCenter.removeEventListener("EDIT_NOTICE_SUCCESS",editSuccess);
         UnionPro.myUnionVO.notice = input_notice.text;
         input_notice.text = "";
         Facade.getInstance().sendNotification(ConfigConst.SHOW_UNION_NOTICE);
         WinTweens.closeWin(spr_notice,remove);
      }
      
      public function show(param1:Sprite) : void
      {
         param1.addChild(getInstance());
         WinTweens.openWin(spr_notice);
      }
      
      public function remove() : void
      {
         getInstance().removeFromParent(true);
         instance = null;
      }
   }
}
