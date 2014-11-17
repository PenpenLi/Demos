#ifndef MOF_CDBUTTON_H
#define MOF_CDBUTTON_H

class CDButton{
public:
	void setCDTime(float);
	void init(float,	char const*, char const*);
	void getComCDTime(void)const;
	void init(float,char const*,char	const*);
	void getColding(void);
	void setComSkillCoolingEffect(float);
	void CDButton(void);
	void getComCDTime(void);
	void getComCding(void);
	void createCDButton(float,char const*,char const*);
	void setColding(bool);
	void isCoolding(void);
	void reset(void);
	void skillCoolDownCallBack(cocos2d::CCNode *);
	void ~CDButton();
	void setSkillCoolingEffect(void);
	void ComCoolDownCallBack(cocos2d::CCNode	*);
	void setComCDTime(float);
	void getSkillid(void);
	void getCDTime(void)const;
	void ComCoolDownCallBack(cocos2d::CCNode *);
	void setSkillid(int);
	void createCDButton(float, char const*, char const*);
	void skillClickCallBack(cocos2d::CCObject *,int);
	void getSkillid(void)const;
	void setComCding(bool);
	void skillClickCallBack(cocos2d::CCObject *, int);
	void getCDTime(void);
}
#endif