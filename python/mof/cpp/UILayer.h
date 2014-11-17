#ifndef MOF_UILAYER_H
#define MOF_UILAYER_H

class UILayer{
public:
	void onResolveCCBCCControlSelector(cocos2d::CCObject *, char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void addCocosbuilderLayer(char const*, cocos2d::extension::CCNodeLoader *, char const*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,	char const*, cocos2d::CCNode *);
	void onResolveCCBCCControlSelector(cocos2d::CCObject *,char	const*);
	void ~UILayer();
	void onResolveCCBCCControlSelector(cocos2d::CCObject *,char const*);
	void addCocosbuilderLayer(char const*,cocos2d::extension::CCNodeLoader *,char const*);
}
#endif