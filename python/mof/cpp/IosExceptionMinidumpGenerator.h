#ifndef MOF_IOSEXCEPTIONMINIDUMPGENERATOR_H
#define MOF_IOSEXCEPTIONMINIDUMPGENERATOR_H

class IosExceptionMinidumpGenerator{
public:
	void IosExceptionMinidumpGenerator(NSException *);
	void WriteThreadStream(unsigned int, MDRawThread *);
	void WriteCrashingContextARM(MDLocationDescriptor *);
	void WriteThreadStream(uint,MDRawThread *);
	void WriteExceptionStream(MDRawDirectory *);
	void ~IosExceptionMinidumpGenerator();
}
#endif