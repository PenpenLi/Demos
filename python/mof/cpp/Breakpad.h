#ifndef MOF_BREAKPAD_H
#define MOF_BREAKPAD_H

class Breakpad{
public:
	void HandleUncaughtException(NSException	*);
	void UncaughtExceptionHandler(NSException *);
	void SetKeyValue(NSString *,NSString *);
	void Create(NSDictionary *).	PRESS KEYPAD CTRL-"+" TO EXPAND];
	void RemoveKeyValue(NSString *);
	void ~Breakpad();
	void NextCrashReportToUpload(void);
	void Initialize(NSDictionary *);
	void Create(NSDictionary	*);
	void HandleMinidumpCallback(char	const*,char const*,void	*,bool);
	void UploadNextReport(void);
	void UncaughtExceptionHandler(NSException	*);
	void HandleMinidumpCallback(char const*,char const*,void *,bool);
	void KeyValue(NSString *);
	void ExtractParameters(NSDictionary *);
	void SetKeyValue(NSString *, NSString *);
	void CrashReportsToUpload(void);
}
#endif