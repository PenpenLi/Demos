#ifndef MOF_OBJ_SKILL_EFFECT_INFO_H
#define MOF_OBJ_SKILL_EFFECT_INFO_H

class obj_skill_effect_info{
public:
	void decode(ByteArray &);
	void encode(ByteArray &);
	void obj_skill_effect_info(void);
}
#endif