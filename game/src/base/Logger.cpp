#include "Logger.h"
#include <string.h>
#include <sys/stat.h>
#include <log4cplus/consoleappender.h>
#include <log4cplus/layout.h>
#include <log4cplus/fileappender.h>
#include <memory>

namespace XL {

Logger::Logger() :
		_watchdog(NULL) {

}

Logger::~Logger() {
	if (_watchdog) {
		delete _watchdog;
		_watchdog = NULL;
	}
}

void Logger::InitLogger(const char* szProgramPath, int secRefresh) {
	//todo 取程序名，按程序名找配置文件，文件不存在，进行默认配置
	const char* szProgramName = strrchr(szProgramPath, '/');
	std::string strFormat("%D{%Y-%m-%d %H:%M:%S.%q}[");
	std::string logFile;
	std::string currentPath;
	if (szProgramName) {
		strFormat += (szProgramName + 1);
		currentPath = std::string(szProgramPath).substr(0, szProgramName - szProgramPath);
		logFile = currentPath + "/logs/";
		logFile += (szProgramName + 1);
		logFile += ".log";
	} else {
		strFormat += "%i";
		logFile = std::string(szProgramPath) + ".log";
	}
	strFormat += ".%t] %m%n";
	log4cplus::Logger logger = log4cplus::Logger::getInstance(LOGGER_NAME);
	logger.setLogLevel(log4cplus::ALL_LOG_LEVEL);
	log4cplus::SharedAppenderPtr consoleAppender(new log4cplus::ConsoleAppender);
	consoleAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(strFormat)));
	logger.addAppender(consoleAppender);
	log4cplus::SharedAppenderPtr fileAppender(new log4cplus::RollingFileAppender(logFile));
	fileAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(strFormat)));
	logger.addAppender(fileAppender);
}

}  // namespace XL
