#ifndef MOF_NPCDIALOGMGR_H
#define MOF_NPCDIALOGMGR_H

class NpcDialogMgr{
public:
	void FindDialog(int);
	void GetDialogData(NpcDialog	*,std::string &,std::map<int,std::string,std::less<int>,std::allocator<std::pair<int const,std::string>>> *);
	void LoadFile(char const*);
	void GetDialogData(NpcDialog	*, std::string &, std::map<int,	std::string, std::less<int>, std::allocator<std::pair<int const, std::string>>>	*);
}
#endif