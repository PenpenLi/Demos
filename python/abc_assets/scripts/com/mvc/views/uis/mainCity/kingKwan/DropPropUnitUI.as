package com.mvc.views.uis.mainCity.kingKwan
{
   import starling.display.Sprite;
   import com.mvc.models.vos.elf.ElfVO;
   import com.mvc.models.vos.mainCity.packPack.PropVO;
   import starling.display.Image;
   import starling.text.TextField;
   import com.common.util.xmlVOHandler.GetpropImage;
   import com.common.managers.ELFMinImageManager;
   import starling.events.TouchEvent;
   import starling.events.Touch;
   import com.mvc.views.uis.mapSelect.ExtendElfUnitTips;
   import com.mvc.views.uis.mainCity.firstRecharge.FirstRchRewardTips;
   import com.common.themes.Tips;
   import org.puremvc.as3.patterns.facade.Facade;
   import com.mvc.views.mediator.mainCity.home.ElfDetailInfoMedia;
   import com.mvc.views.uis.mainCity.home.ElfDetailInfoUI;
   import com.mvc.models.proxy.mainCity.home.HomePro;
   
   public class DropPropUnitUI extends Sprite
   {
       
      public var _elfVO:ElfVO;
      
      public var _propVO:PropVO;
      
      public var image:Sprite;
      
      public var elfImage:Image;
      
      public var rewardNameTf:TextField;
      
      public var isShowAttribute:Boolean = true;
      
      public function DropPropUnitUI(param1:uint = 5715237)
      {
         super();
         init(param1);
      }
      
      private function init(param1:uint) : void
      {
         rewardNameTf = new TextField(110,30,"","FZCuYuan-M03S",20,param1,true);
         rewardNameTf.autoScale = true;
         rewardNameTf.hAlign = "center";
         rewardNameTf.vAlign = "top";
         rewardNameTf.y = 113;
         addChild(rewardNameTf);
         addEventListener("touch",ontouch);
      }
      
      public function set myPropVo(param1:PropVO) : void
      {
         _propVO = param1;
         image = GetpropImage.getPropSpr(param1);
         this.addChild(image);
         if(param1.rewardCount > 1)
         {
            rewardNameTf.text = param1.name + "×" + param1.rewardCount;
         }
         else
         {
            rewardNameTf.text = param1.name;
         }
      }
      
      public function setTextColor(param1:Number, param2:int = 20, param3:int = 30) : void
      {
         rewardNameTf.color = param1;
         rewardNameTf.height = param3;
         rewardNameTf.fontSize = param2;
      }
      
      public function set myElfVo(param1:ElfVO) : void
      {
         _elfVO = param1;
         elfImage = ELFMinImageManager.getElfM(param1.imgName);
         this.addChild(elfImage);
         rewardNameTf.text = param1.name;
      }
      
      private function ontouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_)
         {
            if(_loc2_.phase == "began")
            {
               if(_elfVO)
               {
                  if(isShowAttribute)
                  {
                     handleElfDrop();
                  }
                  else
                  {
                     ExtendElfUnitTips.getInstance().showElfTips(_elfVO,this);
                  }
               }
               if(_propVO)
               {
                  FirstRchRewardTips.getInstance().showPropTips(_propVO,this);
               }
            }
            if(_loc2_.phase == "ended")
            {
               if(_elfVO && !isShowAttribute)
               {
                  ExtendElfUnitTips.getInstance().removeElfTips();
               }
               if(_propVO)
               {
                  FirstRchRewardTips.getInstance().removePropTips();
               }
            }
         }
      }
      
      private function handleElfDrop() : void
      {
         if(Config.isOpenBeginner)
         {
            return;
         }
         if(_elfVO.isAlreadyFree)
         {
            Tips.show("亲，精灵已经放生了！");
            return;
         }
         if(Facade.getInstance().hasMediator("addAmuseMcMedia"))
         {
            ElfDetailInfoMedia.showFreeBtn = true;
         }
         else
         {
            ElfDetailInfoMedia.showFreeBtn = false;
         }
         ElfDetailInfoMedia.showSetNameBtn = true;
         if(!Facade.getInstance().hasMediator("ElfDetailInfoMedia"))
         {
            Facade.getInstance().registerMediator(new ElfDetailInfoMedia(new ElfDetailInfoUI()));
         }
         if(!_elfVO.isDetail)
         {
            (Facade.getInstance().retrieveProxy("HomePro") as HomePro).write2015(_elfVO,"邮件",_elfVO.position);
         }
         else
         {
            Facade.getInstance().sendNotification("switch_win",null,"LOAD_ELFDETAILINFO_WIN");
            Facade.getInstance().sendNotification("SEND_ELF_DETAIL",_elfVO);
         }
      }
      
      public function setOtherAward(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = param1.indexOf("×");
         if(_loc3_ == -1)
         {
            return;
         }
         var _loc4_:* = param1.slice(0,_loc3_);
         if("奖励经验" !== _loc4_)
         {
            if("奖励金币" !== _loc4_)
            {
               if("奖励钻石" !== _loc4_)
               {
                  if("奖励体力" !== _loc4_)
                  {
                     if("奖励王者积分" !== _loc4_)
                     {
                        if("奖励对战积分" !== _loc4_)
                        {
                           if("奖励联盟积分" !== _loc4_)
                           {
                              if("奖励神秘积分" !== _loc4_)
                              {
                                 if("奖励捕虫大会积分" === _loc4_)
                                 {
                                    _loc2_ = "img_catchScore";
                                 }
                              }
                              else
                              {
                                 _loc2_ = "img_fsDot";
                              }
                           }
                           else
                           {
                              _loc2_ = "img_rkDot";
                           }
                        }
                        else
                        {
                           _loc2_ = "img_pvDot";
                        }
                     }
                     else
                     {
                        _loc2_ = "img_kwDot";
                     }
                  }
                  else
                  {
                     _loc2_ = "img_cake";
                  }
               }
               else
               {
                  _loc2_ = "img_dia980";
               }
            }
            else
            {
               _loc2_ = "img_coin";
            }
         }
         else
         {
            _loc2_ = "img_expicon";
         }
         image = GetpropImage.getOtherSpr(_loc2_);
         this.addChild(image);
         rewardNameTf.text = param1.slice(2);
      }
      
      public function removeNameTf() : void
      {
         rewardNameTf.removeFromParent(true);
      }
   }
}
