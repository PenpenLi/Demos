#ifndef MOF_LIMITACTIVITYCFG_H
#define MOF_LIMITACTIVITYCFG_H

class LimitActivityCfg{
public:
	void load(std::string);
	void getAllLimitActivityDatas(int);
	void getLimitByMapID(int);
	void getTicketTypeByActivityID(int);
	void getActivityIdByTicketId(int);
}
#endif