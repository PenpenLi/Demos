#ifndef MOF_GUILDCREATE_H
#define MOF_GUILDCREATE_H

class GuildCreate{
public:
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox	*);
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void ~GuildCreate();
	void initLvlAndMoney(void);
	void GuildCreate(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemCreateClick(cocos2d::CCObject *);
	void editBoxTextChanged(cocos2d::extension::CCEditBox	*, std::string const&);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void editBoxTextChanged(cocos2d::extension::CCEditBox	*,std::string const&);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void checkGuildNameIsAvailable(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void onEnter(void);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void guildInputDetection(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void initEditBox(void);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void init(void);
	void onExit(void);
}
#endif