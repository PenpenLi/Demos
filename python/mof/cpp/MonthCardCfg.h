#ifndef MOF_MONTHCARDCFG_H
#define MOF_MONTHCARDCFG_H

class MonthCardCfg{
public:
	void setNeedRmb(int);
	void MonthCardCfg(void);
	void getMonthCardDefByIdx(int);
	void setTotalCount(int);
	void setAwardNum(int);
	void load(std::string);
	void ~MonthCardCfg();
}
#endif