package com.mvc.views.uis.union.unionMedal
{
   import starling.display.Sprite;
   import lzm.starling.swf.Swf;
   import com.common.util.xmlVOHandler.GetUnionMedal;
   import com.mvc.models.vos.login.PlayerVO;
   import flash.geom.Rectangle;
   import com.common.util.GetCommon;
   import com.common.managers.LoadSwfAssetsManager;
   
   public class MedalUnitUI extends Sprite
   {
       
      private var isMyself:Boolean;
      
      private var swf:Swf;
      
      private var isAddTxt:Boolean;
      
      private var txtSize:int;
      
      public function MedalUnitUI(param1:Boolean, param2:Boolean, param3:int)
      {
         super();
         txtSize = param3;
         isAddTxt = param2;
         isMyself = param1;
         this.y = this.y - 20;
         swf = LoadSwfAssetsManager.getInstance().assets.getSwf("unionMedal");
      }
      
      public function set setLv(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc4_:int = GetUnionMedal.getBigLv(param1);
         addChild(swf.createImage("img_medal" + (_loc4_ + 1)));
         if(PlayerVO.medalLv >= param1 && isMyself || !isMyself)
         {
            _loc2_ = swf.createSprite("spr_star1_s");
         }
         else
         {
            _loc2_ = swf.createSprite("spr_star2_s");
         }
         var _loc3_:Number = (GetUnionMedal.medalLvArr[_loc4_].indexOf(param1) + 1) / 4;
         _loc2_.clipRect = new Rectangle(0,0,_loc2_.width * _loc3_,_loc2_.height);
         _loc2_.x = (3 - GetUnionMedal.medalLvArr[_loc4_].indexOf(param1)) * 11 + 6;
         _loc2_.y = 90;
         addChild(_loc2_);
         if(isAddTxt)
         {
            GetCommon.getText(-25,this.height,150,25,GetUnionMedal.medalNameArr[GetUnionMedal.getBigLv(param1)],"FZCuYuan-M03S",txtSize,8674058,this,false,true,true);
            this.pivotY = this.height;
         }
      }
   }
}
