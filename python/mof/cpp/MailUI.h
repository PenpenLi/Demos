#ifndef MOF_MAILUI_H
#define MOF_MAILUI_H

class MailUI{
public:
	void showMailInfo(void);
	void MailUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void initControl(void);
	void onMenuItemDeleteClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void changeDeleteMenu(int,MailData	*);
	void onMenuItemCancel(void);
	void deleteAllData(void);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ~MailUI();
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void onMenuItemGetAttachClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void deleteMailAttach(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void changeDeleteMenu(int,	MailData *);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemOK(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void getAttachByMailId(void);
	void create(void);
	void deleteMailAttach(std::string);
	void onMenuItemGetAllAttachClicked(cocos2d::CCObject *);
	void addAttachChild(char const*,char const*);
	void addAttachChild(char const*, char const*);
	void init(void);
	void onExit(void);
}
#endif