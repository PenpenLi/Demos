#ifndef MOF_SKILLCOLDINGCELLMGR_H
#define MOF_SKILLCOLDINGCELLMGR_H

class SkillColdingCellMgr{
public:
	void ~SkillColdingCellMgr();
	void objAutoPlaySkills(int);
	void deleteAllSkillColdingCell(void);
	void setOtherSkillComCd(int,float);
	void setOtherSkillComCd(int, float);
	void skillIsCoolding(int);
	void create(cocos2d::CCNode *);
	void addSkillColdingCells(int);
}
#endif