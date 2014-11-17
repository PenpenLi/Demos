#ifndef MOF_QUESTMGR_H
#define MOF_QUESTMGR_H

class QuestMgr{
public:
	void GetDialog(Quest *, bool, int *, int	*);
	void FindQuest(int);
	void GetCurCondition(Quest *, std::vector<int, std::allocator<int>>, QuestCondition *, int *);
	void GetAcceptableQuests(int, std::vector<int, std::allocator<int>> &, std::vector<int, std::allocator<int>> &, std::vector<int,	std::allocator<int>>*, std::vector<int,	std::allocator<int>>*);
	void GetConditions(Quest	*,std::vector<QuestCondition *,std::allocator<QuestCondition *>> &);
	void GetRewords(Quest *,int *,int *,int *,int *,std::map<int,int,std::less<int>,std::allocator<std::pair<int const,int>>> *);
	void TypeQuests(char const*,int,std::list<int,std::allocator<int>> *);
	void GetCurCondition(Quest *,std::vector<int,std::allocator<int>>,QuestCondition	*,int *);
	void TypeQuests(char const*, int, std::list<int,	std::allocator<int>> *);
	void GetConditions(Quest	*, std::vector<QuestCondition *, std::allocator<QuestCondition *>> &);
	void GetDialog(Quest *,bool,int *,int *);
	void GetAcceptableQuests(int,std::vector<int,std::allocator<int>> &,std::vector<int,std::allocator<int>>	&,std::vector<int,std::allocator<int>>*,std::vector<int,std::allocator<int>>*);
	void GetRewords(Quest *,	int *, int *, int *, int *, std::map<int, int, std::less<int>, std::allocator<std::pair<int const, int>>> *);
	void LoadFile(char const*);
}
#endif