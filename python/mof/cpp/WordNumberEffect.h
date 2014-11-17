#ifndef MOF_WORDNUMBEREFFECT_H
#define MOF_WORDNUMBEREFFECT_H

class WordNumberEffect{
public:
	void updateState(float);
	void setWordAndNumber(HitType,int,EffectWordColor);
	void startEffect(void);
	void ~WordNumberEffect();
	void WordNumberEffect(ObjType,int,int);
	void WordNumberEffect(ObjType, int, int);
	void getPath(EffectWordColor);
	void setWordAndNumber(HitType, int, EffectWordColor);
	void effectCompleted(void);
}
#endif