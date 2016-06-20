package com.common.util.xmlVOHandler
{
   import com.mvc.models.vos.mainCity.playerInfo.PlayerLvVO;
   import com.common.managers.LoadOtherAssetsManager;
   
   public class GetLvExp
   {
      
      public static var elfGradeExp:Array = [];
      
      public static var elfGradepv:Array = [];
       
      public function GetLvExp()
      {
         super();
      }
      
      public static function getPlayerLvVoVec() : Vector.<PlayerLvVO>
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         var _loc4_:Vector.<PlayerLvVO> = new Vector.<PlayerLvVO>([]);
         elfGradeExp = [];
         elfGradepv = [];
         var _loc5_:XML = LoadOtherAssetsManager.getInstance().assets.getXml("sta_lvExp");
         var _loc1_:int = (_loc5_.sta_lvExp as XMLList).length();
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new PlayerLvVO();
            _loc3_.lv = _loc5_.sta_lvExp[_loc2_].@id;
            _loc3_.exp = _loc5_.sta_lvExp[_loc2_].@exp;
            _loc3_.maxPokeLv = _loc5_.sta_lvExp[_loc2_].@maxPokeLv;
            _loc3_.maxActionForce = _loc5_.sta_lvExp[_loc2_].@maxActionForce;
            _loc3_.actionRestore = _loc5_.sta_lvExp[_loc2_].@actionRestore;
            _loc3_.pokeExp = _loc5_.sta_lvExp[_loc2_].@pokeExp;
            _loc3_.openActivity = (_loc5_.sta_lvExp[_loc2_] as XML).attribute("function");
            _loc4_.push(_loc3_);
            elfGradeExp.push(_loc5_.sta_lvExp[_loc2_].@pokeExp);
            elfGradepv.push(_loc5_.sta_lvExp[_loc2_].@maxPokeLv);
            _loc2_++;
         }
         _loc5_ = null;
         return _loc4_;
      }
   }
}
