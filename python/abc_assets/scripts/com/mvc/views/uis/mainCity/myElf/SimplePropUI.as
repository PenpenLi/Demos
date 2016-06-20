package com.mvc.views.uis.mainCity.myElf
{
   import starling.display.Sprite;
   import starling.text.TextField;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import com.common.util.xmlVOHandler.GetpropImage;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.events.EventCenter;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.myElf.MyElfMedia;
   import com.common.util.beginnerGuide.BeginnerGuide;
   
   public class SimplePropUI extends Sprite
   {
       
      private var _scale:Number;
      
      public var _costNum:int;
      
      private var counText:TextField;
      
      private var image:Sprite;
      
      private var _isClick:Boolean;
      
      public var identity:String;
      
      public var lastPropVo:PropVO;
      
      public var lastBestPropVo:PropVO;
      
      public var lastBestBestPropVo:PropVO;
      
      public var _propVo:PropVO;
      
      private var rootClass:com.mvc.views.uis.mainCity.myElf.MyElfUI;
      
      public var isMeet:Boolean;
      
      private var _isPrompt:Boolean;
      
      private var _useSum:int;
      
      public function SimplePropUI(param1:Number = 1, param2:int = 0, param3:Boolean = true, param4:Boolean = false, param5:int = 0)
      {
         super();
         _scale = param1;
         _costNum = param2;
         _isClick = param3;
         _isPrompt = param4;
         _useSum = param5;
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         var _loc2_:* = 0;
         _propVo = param1;
         if(image)
         {
            GetpropImage.clean(image);
         }
         image = GetpropImage.getPropSpr(param1,true,_scale);
         addChild(image);
         if(_costNum > 0)
         {
            if(counText)
            {
               counText.removeFromParent(true);
            }
            counText = new TextField(image.width,25,"","FZCuYuan-M03S",25 * _scale,5584695,true);
            counText.autoScale = true;
            counText.y = image.height - 2;
            addChild(counText);
            _loc2_ = _propVo.count - _useSum >= 0?_propVo.count - _useSum:0.0;
            counText.text = _loc2_ + "/" + _costNum;
            if((_propVo.count - _useSum) / _costNum >= 1)
            {
               counText.color = 902695;
               isMeet = true;
            }
            else
            {
               counText.color = 16711680;
               isMeet = false;
            }
         }
         if(_isClick)
         {
            this.addEventListener("touch",onclick);
         }
         if(_isPrompt)
         {
            this.addEventListener("touch",isPromptFun);
         }
      }
      
      private function isPromptFun(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            if(_propVo)
            {
               FirstRchRewardTips.getInstance().showPropTips(_propVo,this);
            }
         }
         if(_loc2_ && _loc2_.phase == "ended")
         {
            if(_propVo)
            {
               FirstRchRewardTips.getInstance().removePropTips();
            }
         }
      }
      
      private function onclick(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "ended")
         {
            var _loc3_:* = identity;
            if("合成1" !== _loc3_)
            {
               if("合成2" !== _loc3_)
               {
                  if("合成3" !== _loc3_)
                  {
                     if("合成4" !== _loc3_)
                     {
                        if("合成23" !== _loc3_)
                        {
                           if("one" !== _loc3_)
                           {
                              if("two" !== _loc3_)
                              {
                                 if("three" === _loc3_)
                                 {
                                    CompChildUI.getInstance().addStyleThree(lastBestPropVo,lastPropVo,_propVo);
                                 }
                              }
                              else
                              {
                                 CompChildUI.getInstance().addStyleTwo(lastPropVo,_propVo);
                              }
                           }
                           else
                           {
                              CompChildUI.getInstance().addStyleOne(_propVo);
                           }
                        }
                        else
                        {
                           CompChildUI.getInstance().addStyleThree(lastPropVo,_propVo);
                           EventCenter.addEventListener("BREAK_RETURN",returnEvent2);
                        }
                     }
                     else
                     {
                        CompChildUI.getInstance().addStylefour(lastBestBestPropVo,lastBestPropVo,lastPropVo,_propVo);
                        EventCenter.addEventListener("BREAK_RETURN",returnEvent3);
                     }
                  }
                  else
                  {
                     CompChildUI.getInstance().addStyleThree(lastBestPropVo,lastPropVo,_propVo);
                     EventCenter.addEventListener("BREAK_RETURN",returnEvent);
                  }
               }
               else
               {
                  CompChildUI.getInstance().addStyleTwo(lastPropVo,_propVo);
                  EventCenter.addEventListener("BREAK_RETURN",returnEvent2);
               }
            }
            else
            {
               if(ElfBreakUI.getInstance().isScrolling)
               {
                  return;
               }
               CompChildUI.getInstance().myPropVo = _propVo;
               EventCenter.addEventListener("COMPROP_SUCCESS",comPropSuccess);
               rootClass = (Facade.getInstance().retrieveMediator("MyElfMedia") as MyElfMedia).UI as com.mvc.views.uis.mainCity.myElf.MyElfUI;
               rootClass.addChild(CompChildUI.getInstance());
               BeginnerGuide.playBeginnerGuide();
            }
         }
      }
      
      private function returnEvent3() : void
      {
         EventCenter.removeEventListener("BREAK_RETURN",returnEvent3);
         CompChildUI.getInstance().addStyleThree(lastBestBestPropVo,lastBestPropVo,lastPropVo);
      }
      
      private function comPropSuccess() : void
      {
         EventCenter.removeEventListener("COMPROP_SUCCESS",comPropSuccess);
         ElfBreakUI.getInstance().updateProp();
      }
      
      private function returnEvent2() : void
      {
         EventCenter.removeEventListener("BREAK_RETURN",returnEvent2);
         CompChildUI.getInstance().addStyleOne(lastPropVo);
      }
      
      private function returnEvent() : void
      {
         EventCenter.removeEventListener("BREAK_RETURN",returnEvent);
         CompChildUI.getInstance().addStyleTwo(lastBestPropVo,lastPropVo);
      }
      
      public function get count() : int
      {
         return _costNum;
      }
   }
}
