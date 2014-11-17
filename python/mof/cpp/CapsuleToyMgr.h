#ifndef MOF_CAPSULETOYMGR_H
#define MOF_CAPSULETOYMGR_H

class CapsuleToyMgr{
public:
	void reqBuyCapsuleToy(int);
	void getInfoVec(int);
	void setInfoVecRemainTime(int, int);
	void setInfoVecEnableGet(int, int);
	void setInfoVecEnableGet(int,int);
	void ackGetFreeCapsuleToy(ack_capsuletoy_get_egg);
	void ~CapsuleToyMgr();
	void CapsuleToyMgr(void);
	void getInfoVecPrice(int);
	void ackCapsuleToyStatus(ack_capsuletoy_status);
	void ackXyCapsuleToy(ack_capsuletoy_buy_n_egg);
	void ackBuyCapsuleToy(ack_capsuletoy_buy_egg);
	void reqXyCapsuleToy(int);
	void reqCapsuleToyStatus(void);
	void getInfoVecRemainFreeGetNum(int);
	void setInfoVecRemainTime(int,int);
	void getInfoVecRemainBuyNum(int);
	void getInfoVecEnableGet(int);
	void reqGetFreeCapsuleToy(int);
	void getInfoVecRemainTime(int);
}
#endif