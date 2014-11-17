#ifndef MOF_CHANNELSELECT_H
#define MOF_CHANNELSELECT_H

class ChannelSelect{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ~ChannelSelect();
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onMenuItemClose(cocos2d::CCObject *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ChannelSelect(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void init(void);
	void onExit(void);
}
#endif