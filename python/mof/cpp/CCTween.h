#ifndef MOF_CCTWEEN_H
#define MOF_CCTWEEN_H

class CCTween{
public:
	void ~CCTween();
	void setActive(bool);
	void create(void);
	void updateHandler(void);
	void remove(void);
	void updateCurrentPrecent(void);
	void setNode(CCTweenNode *);
	void playTo(void *,int,int,bool,int);
	void playTo(void *, int, int, bool, int);
	void init(void);
}
#endif