package com.common.util.strHandler
{
   import com.common.managers.LoadOtherAssetsManager;
   import com.common.themes.Tips;
   
   public class CheckSensitiveWord
   {
      
      private static var sensitiveWordArr:Array;
       
      public function CheckSensitiveWord()
      {
         super();
      }
      
      public static function checkSensitiveWord(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc11_:* = null;
         var _loc12_:* = null;
         var _loc8_:* = false;
         var _loc9_:* = null;
         var _loc5_:* = null;
         var _loc13_:* = null;
         var _loc3_:* = 0;
         if(!param1)
         {
            return false;
         }
         if(param2)
         {
            _loc11_ = new RegExp("[⅐-↏①-⓿⟀-⟯⦀-⧿㈀-㋿＀-￯ቀ0-ቇfᵰ0-ᵿf0-9]|零|壹|贰|叁|肆|伍|陆|柒|捌|玖|一|二|三|四|五|六|七|八|九|㊀|㊁|㊂|㊃|㊄|㊅|㊆|㊇|㊈","g");
            _loc12_ = param1.match(_loc11_);
            LogUtil("specnumarr: " + _loc12_);
            if(_loc12_ && _loc12_.length >= 6)
            {
               return true;
            }
         }
         var _loc6_:RegExp = new RegExp("[^一-龥]","g");
         var _loc4_:RegExp = new RegExp("[^A-Za-z]","g");
         var _loc7_:String = param1.replace(_loc6_,"");
         var _loc10_:String = param1.replace(_loc4_,"");
         var param1:String = _loc7_ + _loc10_;
         LogUtil("checkSensitiveWord: " + param1);
         if(_loc13_ == null)
         {
            _loc9_ = LoadOtherAssetsManager.getInstance().assets.getXml("sta_sensitiveWord");
            _loc5_ = _loc9_.sta_sensitiveWord.@word;
            _loc13_ = _loc5_.split("|");
            _loc13_.push("充值","冲值","代充","代冲","公告","全网","交易","www","http","com");
            _loc9_ = null;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc13_.length)
         {
            if(param1.indexOf(_loc13_[_loc3_]) != -1)
            {
               _loc8_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc8_;
      }
      
      public static function checkAndReplaceSensWord(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:* = null;
         var _loc10_:* = false;
         var _loc15_:* = null;
         var _loc16_:* = null;
         var _loc5_:* = null;
         var _loc9_:* = null;
         var _loc13_:* = null;
         var _loc8_:* = null;
         var _loc17_:* = null;
         var _loc4_:* = 0;
         if(!param1)
         {
            return param1;
         }
         if(param2)
         {
            _loc3_ = new RegExp(".*[加入群裙峮qQ免最低交易教意淘套逃桃掏陶待代冲充]+.+[加入群裙峮qQ免最低交易教意淘套逃桃掏陶待代冲充]+.*");
            if(_loc3_.test(param1))
            {
               return null;
            }
            _loc15_ = new RegExp("[⅐-↏①-⓿⟀-⟯⦀-⧿㈀-㋿㌀-㏿❶-❾]|〇|零|壹|贰|叁|肆|伍|陆|柒|捌|玖|㊀|㊁|㊂|㊃|㊄|㊅|㊆|㊇|㊈|○","g");
            _loc16_ = param1.match(_loc15_);
            LogUtil("specnumarr: " + _loc16_);
            if(_loc16_ && _loc16_[0] != null)
            {
               var param1:String = param1.replace(_loc15_,"*");
               LogUtil("wordwordword: " + param1);
               _loc10_ = true;
            }
            _loc5_ = new RegExp("[^0-9一二三四五六七八九]","g");
            _loc9_ = param1.replace(_loc5_,"");
            if(_loc10_ || _loc9_ && _loc9_.length > 5)
            {
               param1 = param1.replace(new RegExp("[0-9]|一|二|三|四|五|六|七|八|九","g"),"*");
               Tips.show("超过5个表示数字符号会被认为企图刷广告哦。");
            }
         }
         var _loc11_:RegExp = new RegExp("[^一-龥]","g");
         var _loc6_:RegExp = new RegExp("[^A-Za-z]","g");
         var _loc12_:String = param1.replace(_loc11_,"");
         var _loc14_:String = param1.replace(_loc6_,"");
         var _loc7_:String = _loc12_ + _loc14_;
         LogUtil("checkSensitiveWord: " + _loc7_);
         if(_loc17_ == null)
         {
            _loc13_ = LoadOtherAssetsManager.getInstance().assets.getXml("sta_sensitiveWord");
            _loc8_ = _loc13_.sta_sensitiveWord.@word;
            _loc17_ = _loc8_.split("|");
            _loc17_.push("充值","冲值","代充","代冲","公告","全网","交易","www","http","com","淘宝","掏宝","陶宝");
            _loc13_ = null;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc17_.length)
         {
            if(_loc7_.indexOf(_loc17_[_loc4_]) != -1)
            {
               return null;
            }
            _loc4_++;
         }
         return param1;
      }
      
      public static function replaceSensitiveWord(param1:String) : String
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = 0;
         var _loc2_:* = null;
         if(_loc6_ == null)
         {
            _loc4_ = LoadOtherAssetsManager.getInstance().assets.getXml("sta_sensitiveWord");
            _loc3_ = _loc4_.sta_sensitiveWord.@word;
            _loc6_ = _loc3_.split("|");
            _loc4_ = null;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc6_.length)
         {
            if(param1.indexOf(_loc6_[_loc5_]) != -1)
            {
               _loc2_ = param1.replace(_loc6_[_loc5_],"**");
               break;
            }
            _loc5_++;
         }
         return _loc2_;
      }
   }
}
