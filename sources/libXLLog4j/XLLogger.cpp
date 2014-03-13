#include "XLLogger.h"
#include <string.h>
#include <sys/stat.h>
#include <log4cplus/consoleappender.h>
#include <log4cplus/layout.h>
#include <log4cplus/fileappender.h>

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

void Logger::InitLogger(const TSTRING& cfgFileName, int secRefresh)
{
	log4cplus::Logger::getInstance(LOGGER_NAME).setLogLevel(log4cplus::ALL_LOG_LEVEL);
	if (!_watchdog)
	{
		if (secRefresh > 0) {
			_watchdog = new log4cplus::ConfigureAndWatchThread(cfgFileName, secRefresh*1000);
		}
		else
		{
			log4cplus::PropertyConfigurator::doConfigure(cfgFileName);
		}
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
	std::auto_ptr<log4cplus::Layout> consoleLayout(new log4cplus::PatternLayout(strFormat));
	log4cplus::Logger logger = log4cplus::Logger::getInstance(LOGGER_NAME);
	logger.setLogLevel(log4cplus::ALL_LOG_LEVEL);
	log4cplus::SharedAppenderPtr consoleAppender(new log4cplus::ConsoleAppender);
	consoleAppender->setLayout(consoleLayout);
	logger.addAppender(consoleAppender);
	log4cplus::SharedAppenderPtr fileAppender(new log4cplus::RollingFileAppender(logFile));
	std::auto_ptr<log4cplus::Layout> fileLayout(new log4cplus::PatternLayout(strFormat));
	fileAppender->setLayout(fileLayout);
	logger.addAppender(fileAppender);
}

void Logger::SetLogLevel(LogLevel level) {
	log4cplus::Logger logger = log4cplus::Logger::getInstance(LOGGER_NAME);
	switch (level) {
	case LogLevelAll:
	case LogLevelTrace:
		logger.setLogLevel(log4cplus::ALL_LOG_LEVEL);
		break;
	case LogLevelDebug:
		logger.setLogLevel(log4cplus::DEBUG_LOG_LEVEL);
		break;
	case LogLevelInfo:
		logger.setLogLevel(log4cplus::INFO_LOG_LEVEL);
		break;
	case LogLevelWarn:
		logger.setLogLevel(log4cplus::WARN_LOG_LEVEL);
		break;
	case LogLevelError:
		logger.setLogLevel(log4cplus::ERROR_LOG_LEVEL);
		break;
	case LogLevelFatal:
		logger.setLogLevel(log4cplus::FATAL_LOG_LEVEL);
		break;
	case LogLevelOff:
		logger.setLogLevel(log4cplus::OFF_LOG_LEVEL);
		break;
	}
}

}  // namespace XL
