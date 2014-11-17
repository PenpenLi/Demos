#ifndef MOF_GUILDAPPLY_H
#define MOF_GUILDAPPLY_H

class GuildApply{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void deleteSingleData(int);
	void registerWithTouchDispatcher(void);
	void ~GuildApply();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void deleteAllData(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void addDatas(int, int);
	void addDatas(int,int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void initApply(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void GuildApply(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif