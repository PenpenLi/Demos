#ifndef MOF_MYSTICALCOPYMGR_H
#define MOF_MYSTICALCOPYMGR_H

class MysticalCopyMgr{
public:
	void ~MysticalCopyMgr();
	void showLoseAwareUI(ack_leave_mysticalcopy);
	void dialogEnd(void);
	void ackPassMysticalcopy(ack_pass_mysticalcopy);
	void reqGetCopyIndex(void);
	void beginReciprocal(void);
	void reqEnterMysticalCopy(int,int);
	void getKillBossTypeID(void);
	void challengeBoss(void);
	void ackGetCopyIndex(int,	std::vector<obj_mysticalcopy, std::allocator<obj_mysticalcopy>>, int, int);
	void showKillNum(void);
	void setEnterTimes(int);
	void getEnterTimes(void)const;
	void endReciprocal(void);
	void setCurTimer(int);
	void showBossChoose(void);
	void MysticalCopyMgr(void);
	void mysticalCopyGiveUp(void);
	void reqEnterMysticalCopy(int, int);
	void allMonsterClear(void);
	void isRandomMonsterInArea(void);
	void showWinUI(ack_leave_mysticalcopy);
	void getCurTimer(void)const;
	void setKillBossTypeID(int);
	void getEnterTimes(void);
	void mysticalCopyDead(void);
	void reqPassMysticalcopy(bool);
	void stopReciprocal(void);
	void ackEnterMysticalCopy(int, std::vector<obj_mysticalmonster, std::allocator<obj_mysticalmonster>>, int);
	void getCurTimer(void);
	void ackEnterMysticalCopy(int,std::vector<obj_mysticalmonster,std::allocator<obj_mysticalmonster>>,int);
	void createMonster(obj_mysticalmonster);
	void reqLeaveMysticalCopy(void);
	void getKillBossTypeID(void)const;
	void ackGetCopyIndex(int,std::vector<obj_mysticalcopy,std::allocator<obj_mysticalcopy>>,int,int);
	void ackLeaveMysticalCopy(ack_leave_mysticalcopy);
}
#endif