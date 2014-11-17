#ifndef MOF_SKILLHURT_H
#define MOF_SKILLHURT_H

class SkillHurt{
public:
	void battlepropAssignment(obj_current_battleprop_info &,LivingObject *);
	void SkillHurt(void);
	void toSkillHurtMsg(void);
	void create(LivingObject *,LivingObject	*,int,int,HitType,int);
	void create(LivingObject *, LivingObject *, int, int, HitType, int);
	void battlepropAssignment(obj_current_battleprop_info &, LivingObject *);
	void operator=(SkillHurt&);
	void toVerifySkillHurtMsg(void);
}
#endif