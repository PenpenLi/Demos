#ifndef MOF_PETELITEINFOR_H
#define MOF_PETELITEINFOR_H

class PetEliteInfor{
public:
	void PetEliteInfor(void);
	void getPetId(void);
	void setPetIsDead(bool);
	void setPetId(int);
	void operator=(PetEliteInfor const&);
	void getPetIsDead(void);
	void getPetId(void)const;
}
#endif