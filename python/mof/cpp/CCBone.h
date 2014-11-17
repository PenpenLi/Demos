#ifndef MOF_CCBONE_H
#define MOF_CCBONE_H

class CCBone{
public:
	void getParentName(void);
	void setNode(CCBaseNode *);
	void ~CCBone();
	void setTweenNode(CCTweenNode *);
	void getName(void)const;
	void getArmature(void);
	void setParent(CCBone*);
	void getDisplay(void);
	void setLockPosition(float);
	void getParent(void);
	void getTweenNode(void);
	void init(bool);
	void create(bool);
	void update(float);
	void remove(void);
	void setLockPosition(float,float,float,float);
	void getNode(void)const;
	void setArmature(CCArmature *);
	void getParentName(void)const;
	void setName(char const*);
	void getParent(void)const;
	void getDisplay(void)const;
	void setDisplay(cocos2d::CCNode *);
	void getNode(void);
	void getArmature(void)const;
	void setParentName(std::string const&);
	void getTweenNode(void)const;
	void updateDisplay(void);
	void getName(void);
}
#endif