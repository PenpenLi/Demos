#ifndef MOF_GUILDNEWS_H
#define MOF_GUILDNEWS_H

class GuildNews{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setNewsShow(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void deleteData(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void GuildNews(void);
	void onEnter(void);
	void registerWithTouchDispatcher(void);
	void ~GuildNews();
	void init(void);
	void onExit(void);
}
#endif