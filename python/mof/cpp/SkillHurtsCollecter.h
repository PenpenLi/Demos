#ifndef MOF_SKILLHURTSCOLLECTER_H
#define MOF_SKILLHURTSCOLLECTER_H

class SkillHurtsCollecter{
public:
	void getInstance(void);
	void clearVerifySkillHurts(void);
	void sendPassLevelSkillHurts(void);
	void clearMaxOrMinSkillHurts(void);
	void getRandomVerifySkillHurtMsg(void);
	void addVerifySkillHurt(SkillHurt);
}
#endif