#ifndef MOF_MYSTICALCOPYTIPSUI_H
#define MOF_MYSTICALCOPYTIPSUI_H

class MysticalCopyTipsUI{
public:
	void showKillMonster(int, int);
	void MysticalCopyTipsUI(void);
	void setKillBoss(int);
	void setTimer(int);
	void ~MysticalCopyTipsUI();
	void callTipEnd(void);
	void showKillMonster(int,int);
	void getTimer(void)const;
	void refreshTimer(float);
	void showTimer(int);
	void onEnter(void);
	void timerStop(void);
	void getTimer(void);
	void timerEnd(void);
	void setKillMonster(int);
	void create(void);
	void init(void);
	void onExit(void);
}
#endif