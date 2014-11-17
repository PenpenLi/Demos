#ifndef MOF_JOYAROUND_H
#define MOF_JOYAROUND_H

class Joyaround{
public:
	void visit(void);
	void ~Joyaround();
	void setNumber(int);
	void letsRoll(cocos2d::CCObject *);
	void onEnter(void);
	void putMaxPos(cocos2d::CCNode *);
	void Joyaround(void);
	void create(void);
	void init(void);
	void onExit(void);
}
#endif