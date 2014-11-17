#include "log.h"

std::string w2c(const std::wstring& ws)
{
	return std::string().assign(ws.begin(), ws.end());
}

//std::string w2c(const wchar_t* pws)
//{
//	return w2c(std::wstring(pws));
//}

namespace XL {
    CLog::CLog() {
        
    }
    
    bool CLog::Init(const std::string& logPath) {
        
        return true;
    }
    
    void CLog::Log(const std::string &message, bool console) {
        time_t now;
        time(&now);
        struct tm *tm = localtime(&now);
        char header[64] = { 0 };
        snprintf(header, 63, "%02d:%02d:%02d[%u.%u] ", tm->tm_hour, tm->tm_min, tm->tm_sec, GetPid(), GetTid());
        std::cout << header << message << std::endl;
        if (console) std::cerr << header << message << std::endl;
    }
}