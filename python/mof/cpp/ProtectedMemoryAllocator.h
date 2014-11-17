#ifndef MOF_PROTECTEDMEMORYALLOCATOR_H
#define MOF_PROTECTEDMEMORYALLOCATOR_H

class ProtectedMemoryAllocator{
public:
	void Protect(void);
	void ProtectedMemoryAllocator(unsigned int);
	void ~ProtectedMemoryAllocator();
	void Allocate(uint);
	void Unprotect(void);
	void ProtectedMemoryAllocator(uint);
	void Allocate(unsigned int);
}
#endif