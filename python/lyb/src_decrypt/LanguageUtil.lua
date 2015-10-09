LanguageUtil={};

LanguageUtil.CN=1;
LanguageUtil.TW=2;

LanguageUtil.language={
	["抢购"]={"抢购","搶購"},
	["确定花费"]={"确定花费","確定花費"},
	["购买"]={"购买","購買"},
	["吗"]={"吗","嗎"},
	["领取"]={"领取","領取"},
	["进入"]={"进入","進入"},
	["充值"]={"充值","充值"},
	["抢完"]={"抢完","搶完"},
	["已领取"]={"已领取","已領取"}
}

function LanguageUtil:getString(string)
	local lang=LanguageUtil.CN;
	if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
		lang=LanguageUtil.TW;
	end
	local s;
	if self.language[string] then
		s=self.language[string][lang];
	end
	if nil==s then
		s="";
	end
	return s;
end