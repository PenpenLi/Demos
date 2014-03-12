#include "XLLogger.h"
#include <string.h>
#include <sys/stat.h>
#include <log4cplus/consoleappender.h>
#include <log4cplus/layout.h>
#include <log4cplus/fileappender.h>

using namespace log4cplus;

XLLogger::XLLogger() :
		_watchdog(NULL) {

}

XLLogger::~XLLogger() {
	if (_watchdog) {
		delete _watchdog;
		_watchdog = NULL;
	}
}

void XLLogger::InitLogger(const TSTRING& cfgFileName, int secRefresh)
{
	Logger::getInstance(LOGGER_NAME).setLogLevel(ALL_LOG_LEVEL);
	if (!_watchdog)
	{
		if (secRefresh > 0) {
			_watchdog = new ConfigureAndWatchThread(cfgFileName, secRefresh*1000);
		}
		else
		{
			PropertyConfigurator::doConfigure(cfgFileName);
		}
	}
}

void XLLogger::InitLogger(const char* szProgramPath, int secRefresh) {
	//todo 取程序名，按程序名找配置文件，文件不存在，进行默认配置
	const char* szProgramName = strrchr(szProgramPath, '/');
	std::string strFormat("%D{%Y-%m-%d %H:%M:%S.%q}[");
	std::string logFile;
	std::string currentPath;
	if (szProgramName) {
		strFormat += (szProgramName+1);
		currentPath = std::string(szProgramPath).substr(0, szProgramName-szProgramPath);
		logFile = currentPath + "/logs/";
		logFile += (szProgramName+1);
		logFile += ".log";
	} else {
		strFormat += "%i";
		logFile = std::string(szProgramPath) + ".log";
	}
	strFormat += ".%t] %m%n";
	std::auto_ptr<Layout> consoleLayout(new PatternLayout(strFormat));
	Logger logger = Logger::getInstance(LOGGER_NAME);
	logger.setLogLevel(ALL_LOG_LEVEL);
	SharedAppenderPtr consoleAppender(new ConsoleAppender);
	consoleAppender->setLayout(consoleLayout);
	logger.addAppender(consoleAppender);
	SharedAppenderPtr fileAppender(new RollingFileAppender(logFile));
	std::auto_ptr<Layout> fileLayout(new PatternLayout(strFormat));
	fileAppender->setLayout(fileLayout);
	logger.addAppender(fileAppender);
}

void XLLogger::SetLogLevel(XLLogLevel level) {
	Logger logger = Logger::getInstance(LOGGER_NAME);
	switch (level) {
	case XLLogLevelAll:
	case XLLogLevelTrace:
		logger.setLogLevel(ALL_LOG_LEVEL);
		break;
	case XLLogLevelDebug:
		logger.setLogLevel(DEBUG_LOG_LEVEL);
		break;
	case XLLogLevelInfo:
		logger.setLogLevel(INFO_LOG_LEVEL);
		break;
	case XLLogLevelWarn:
		logger.setLogLevel(WARN_LOG_LEVEL);
		break;
	case XLLogLevelError:
		logger.setLogLevel(ERROR_LOG_LEVEL);
		break;
	case XLLogLevelFatal:
		logger.setLogLevel(FATAL_LOG_LEVEL);
		break;
	case XLLogLevelOff:
		logger.setLogLevel(OFF_LOG_LEVEL);
		break;
	}
}
