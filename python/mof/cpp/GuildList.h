#ifndef MOF_GUILDLIST_H
#define MOF_GUILDLIST_H

class GuildList{
public:
	void setGobackAndCloseImageShowStata(void);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox	*);
	void editBoxReturn(cocos2d::extension::CCEditBox *);
	void ~GuildList();
	void deleteData(void);
	void onMenuItemGobackClick(cocos2d::CCObject *);
	void onMenuItemSearchClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setApplyListImageState(int, bool);
	void onMenuItemCreateClick(cocos2d::CCObject *);
	void setApplyListImageState(int,bool);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setSearchState(bool);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *, std::string const&);
	void setListViewShow(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void updateListDateByIndex(int);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox *);
	void isShowCreate(void);
	void showEditBox(void);
	void onEnter(void);
	void showRank(void);
	void GuildList(void);
	void editBoxEditingDidEnd(cocos2d::extension::CCEditBox *);
	void initEditBox(void);
	void create(void);
	void editBoxEditingDidBegin(cocos2d::extension::CCEditBox	*);
	void editBoxTextChanged(cocos2d::extension::CCEditBox *,std::string const&);
	void init(void);
	void onExit(void);
	void setRankNum(int);
}
#endif