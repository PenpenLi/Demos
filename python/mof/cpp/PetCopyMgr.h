#ifndef MOF_PETCOPYMGR_H
#define MOF_PETCOPYMGR_H

class PetCopyMgr{
public:
	void getPrintCopyResetTimes(int);
	void reqResetCompleteCopy(int);
	void ackIntoPetCopy(int,int);
	void ackResetCompleteCopy(int,int);
	void ackCompleteCopy(int, std::vector<int, std::allocator<int>>, std::vector<obj_copy_resettimes, std::allocator<obj_copy_resettimes>>);
	void ackResetCompleteCopy(int,	int);
	void isHasCompleteCopy(int);
	void ackIntoPetCopy(int, int);
	void deleteHasCompleteCopy(int);
	void reqCompleteCopy(void);
	void readyIntoPetCopy(int);
	void ackCompleteCopy(int,std::vector<int,std::allocator<int>>,std::vector<obj_copy_resettimes,std::allocator<obj_copy_resettimes>>);
}
#endif