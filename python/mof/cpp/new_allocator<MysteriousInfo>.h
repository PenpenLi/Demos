#ifndef MOF_NEW_ALLOCATOR<MYSTERIOUSINFO>_H
#define MOF_NEW_ALLOCATOR<MYSTERIOUSINFO>_H

class new_allocator<MysteriousInfo>{
public:
	void destroy(MysteriousInfo*);
	void construct(MysteriousInfo*, MysteriousInfo const&);
	void construct(MysteriousInfo*,MysteriousInfo const&);
}
#endif