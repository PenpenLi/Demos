#ifndef MOF_CCBSEQUENCE_H
#define MOF_CCBSEQUENCE_H

class CCBSequence{
public:
	void ~CCBSequence();
	void getSequenceId(void);
	void setChainedSequenceId(int);
	void getDuration(void);
	void setSequenceId(int);
	void getChainedSequenceId(void);
	void setName(char	const*);
	void CCBSequence(void);
	void setDuration(float);
	void getName(void);
}
#endif