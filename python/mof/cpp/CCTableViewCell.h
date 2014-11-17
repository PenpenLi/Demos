#ifndef MOF_CCTABLEVIEWCELL_H
#define MOF_CCTABLEVIEWCELL_H

class CCTableViewCell{
public:
	void setObjectID(uint);
	void getIdx(void);
	void setObjectID(unsigned int);
	void reset(void);
	void getObjectID(void);
	void setIdx(unsigned int);
	void ~CCTableViewCell();
	void setIdx(uint);
}
#endif