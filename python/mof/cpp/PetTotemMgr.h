#ifndef MOF_PETTOTEMMGR_H
#define MOF_PETTOTEMMGR_H

class PetTotemMgr{
public:
	void getStep(int);
	void reqTotemOfferUp(int, std::vector<int, std::allocator<int>>);
	void ackTotemOfferUp(ack_totem_immolation const&);
	void getTxtOfDesc(int,int,int,float,float,float);
	void reqTotemOfferUp(int,std::vector<int,std::allocator<int>>);
	void getRGB(int);
	void ackTotemArrayData(ack_totem_group const&);
	void getTotemLvlDatas(std::map<int, int, std::less<int>, std::allocator<std::pair<int	const, int>>> &);
	void getRealLv(int);
	void getTxtOfDesc(int, float, float, float);
	void reqTotemArrayData(void);
	void getStepPercent(int);
	void getTotemLvlDatas(std::map<int,int,std::less<int>,std::allocator<std::pair<int const,int>>> &);
	void getTxtOfColor(int);
	void setTotemData(int, TotemData const&);
	void setTotemData(int,TotemData const&);
	void getTotemDataByIdx(int);
}
#endif