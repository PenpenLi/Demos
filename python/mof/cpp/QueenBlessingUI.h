#ifndef MOF_QUEENBLESSINGUI_H
#define MOF_QUEENBLESSINGUI_H

class QueenBlessingUI{
public:
	void autoreComplement(int, int);
	void onMenuItemReciveClicked(cocos2d::CCObject *);
	void recv(int, int, char const*);
	void showQueenBlessingList(int);
	void recv(int, int, cocos2d::CCPoint, int);
	void recv(int, int,	cocos2d::CCPoint, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ~QueenBlessingUI();
	void recv(int, void *);
	void recv(int,int,char const*);
	void recv(int,int,cocos2d::CCPoint,int);
	void recv(int, void	*);
	void removeQueenBlessingEffect(float);
	void recv(int,void *);
	void QueenBlessingUI(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void showRecvQueenBlessingEffect(void);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void Init(void);
	void recv(int, int,	char const*);
	void create(void);
	void autoreComplement(int,int);
	void init(void);
	void onExit(void);
}
#endif