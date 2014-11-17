#ifndef MOF_SKILLCOLDINGCELL_H
#define MOF_SKILLCOLDINGCELL_H

class SkillColdingCell{
public:
	void setSkillid(int);
	void getSkillid(void)const;
	void getColding(void);
	void SkillColdingCell(void);
	void create(void);
	void setColding(bool);
	void isCoolding(void);
	void starComCdingSchedule(float);
	void ~SkillColdingCell();
	void getSkillid(void);
	void starColdingSchedule(void);
	void getComCding(void);
	void init(void);
	void setComCding(bool);
	void coldingScheduleCallBack(float);
}
#endif