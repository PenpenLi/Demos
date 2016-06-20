package com.mvc.views.mediator.mainCity.amuse
{
   import org.puremvc.as3.patterns.mediator.Mediator;
   import com.mvc.views.uis.mainCity.amuse.SetElfNameUI;
   import starling.events.Event;
   import com.common.util.strHandler.StrHandle;
   import com.common.themes.Tips;
   import com.common.util.strHandler.CheckSensitiveWord;
   import com.common.util.WinTweens;
   import com.common.util.xmlVOHandler.GetNickNameFactor;
   import com.mvc.views.mediator.fighting.FightingMedia;
   import com.common.events.EventCenter;
   import com.mvc.models.vos.login.PlayerVO;
   import com.mvc.models.proxy.login.LoginPro;
   import com.mvc.models.proxy.mainCity.amuse.AmusePro;
   import org.puremvc.as3.interfaces.INotification;
   import com.mvc.models.vos.elf.ElfVO;
   import com.common.util.dialogue.StartDialogue;
   import starling.display.DisplayObject;
   
   public class SetElfNameMedia extends Mediator
   {
      
      public static const NAME:String = "SetElfNameMedia";
       
      public var setElfName:SetElfNameUI;
      
      private var ifReturn:Boolean;
      
      private var mark:String;
      
      public function SetElfNameMedia(param1:Object = null)
      {
         super("SetElfNameMedia",param1);
         setElfName = param1 as SetElfNameUI;
         setElfName.addEventListener("triggered",clickHandler);
      }
      
      private function clickHandler(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(setElfName.btn_ok !== _loc2_)
         {
            if(setElfName.btn_rounds === _loc2_)
            {
               setElfName.setPetNameTxt.text = GetNickNameFactor.getNickName();
            }
         }
         else
         {
            if(mark == "玩家" && StrHandle.isAllSpace(setElfName.setPetNameTxt.text))
            {
               Tips.show("你还没有输入昵称哦");
               return;
            }
            if(CheckSensitiveWord.checkSensitiveWord(setElfName.setPetNameTxt.text))
            {
               Tips.show("不能有敏感词哦");
               return;
            }
            WinTweens.closeWin(setElfName.spr_setNameBg,remove);
         }
      }
      
      private function remove() : void
      {
         sendNotification("switch_win",null);
         if(StrHandle.isAllSpace(setElfName.setPetNameTxt.text))
         {
            Tips.show("昵称没有修改");
            if(FightingMedia.isFighting)
            {
               sendNotification("elf_set_name_complete");
            }
            setElfName.removeFromParent();
            EventCenter.dispatchEvent("CREATE_SET_NAME");
         }
         else
         {
            if(mark == "玩家")
            {
               PlayerVO.nickName = setElfName.setPetNameTxt.text;
               (facade.retrieveProxy("LoginPro") as LoginPro).write1011();
            }
            else
            {
               if(setElfName.setPetNameTxt.text != setElfName.myElfVO.name)
               {
                  setElfName.myElfVO.nickName = setElfName.setPetNameTxt.text;
               }
               if(FightingMedia.isFighting)
               {
                  sendNotification("elf_set_name_complete");
               }
               else
               {
                  (facade.retrieveProxy("AmusePro") as AmusePro).write2014(setElfName.myElfVO,setElfName.setPetNameTxt.text,ifReturn);
               }
               setElfName.removeFromParent();
               EventCenter.dispatchEvent("CREATE_SET_NAME");
            }
            setElfName.setPetNameTxt.text = "";
         }
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:* = param1.getName();
         if("SEND_SETNAME_ELF" !== _loc2_)
         {
            if("CLOSE_SETNAME_ELF" === _loc2_)
            {
               setElfName.removeFromParent();
               StartDialogue.getInstance().playDialogue();
            }
         }
         else
         {
            if(param1.getBody() == null)
            {
               mark = "玩家";
               setElfName.niceName.text = "你的昵称:";
            }
            else
            {
               mark = "精灵";
               setElfName.niceName.text = "幼崽的昵称:";
               setElfName.myElfVO = param1.getBody() as ElfVO;
            }
            if(param1.getType() == "true")
            {
               ifReturn = true;
            }
            else
            {
               ifReturn = false;
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return ["SEND_SETNAME_ELF","CLOSE_SETNAME_ELF"];
      }
      
      public function get UI() : DisplayObject
      {
         return viewComponent as DisplayObject;
      }
      
      public function dispose() : void
      {
         facade.removeMediator("SetElfNameMedia");
         UI.removeFromParent(true);
         viewComponent = null;
      }
   }
}
