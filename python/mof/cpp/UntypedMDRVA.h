#ifndef MOF_UNTYPEDMDRVA_H
#define MOF_UNTYPEDMDRVA_H

class UntypedMDRVA{
public:
	void Allocate(ulong);
	void Copy(unsigned int, void const*, unsigned long);
	void Copy(uint,void	const*,ulong);
}
#endif