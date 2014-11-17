#ifndef MOF_MAKEPRINTMGR_H
#define MOF_MAKEPRINTMGR_H

class MakeprintMgr{
public:
	void getPrintCopyResetTimes(int);
	void reqResetCompleteCopy(int);
	void ackIntoMakePrintCopy(int,int);
	void ackResetCompleteCopy(int,int);
	void ackCompleteCopy(int, std::vector<int, std::allocator<int>>, std::vector<obj_copy_resettimes, std::allocator<obj_copy_resettimes>>);
	void isHasCompleteCopy(int);
	void ackIntoMakePrintCopy(int, int);
	void readyIntoMakePrintCopy(int);
	void deleteHasCompleteCopy(int);
	void reqCompleteCopy(void);
	void ackResetCompleteCopy(int, int);
	void ackCompleteCopy(int,std::vector<int,std::allocator<int>>,std::vector<obj_copy_resettimes,std::allocator<obj_copy_resettimes>>);
}
#endif