#ifndef MOF_TITLEUI_H
#define MOF_TITLEUI_H

class TitleUI{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void TitleUI(void);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void createHeader(void);
	void setUseSpr(void);
	void ackCancleUseTitle(void);
	void endAnimDoMinus(cocos2d::CCNode *);
	void adjustScrollView(void);
	void setDefaultShow(int,int);
	void endAnimDoOpen(int,int);
	void ~TitleUI();
	void closeHeader(cocos2d::CCNode *);
	void ackUseTitle(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void setSelSpr(void);
	void wakeUp(float);
	void endAnimDoClose(int,int);
	void addTitleNotGet(std::vector<obj_honorCondInfo,std::allocator<obj_honorCondInfo>> &);
	void endAnimDoClose(int, int);
	void setDefaultShow(int, int);
	void canUsethisTitle(int);
	void endAnimDoAdd(cocos2d::CCNode	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject	*);
	void initTitle(int);
	void onEnter(void);
	void refreshHeader(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void Init(void);
	void gethonorCondInfoById(int);
	void openHeader(cocos2d::CCNode *);
	void create(void);
	void Adjust *>(false, false, std::random_access_iterator_tag);
	void addTitleNotGet(std::vector<obj_honorCondInfo, std::allocator<obj_honorCondInfo>> &);
	void init(void);
	void onExit(void);
	void endAnimDoOpen(int, int);
}
#endif