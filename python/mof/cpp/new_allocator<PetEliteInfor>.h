#ifndef MOF_NEW_ALLOCATOR<PETELITEINFOR>_H
#define MOF_NEW_ALLOCATOR<PETELITEINFOR>_H

class new_allocator<PetEliteInfor>{
public:
	void destroy(PetEliteInfor*);
	void construct(PetEliteInfor*, PetEliteInfor const&);
	void construct(PetEliteInfor*,PetEliteInfor const&);
}
#endif