#include <string>
#include <boost/format.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include <boost/lexical_cast.hpp>

#include "CDemo.h"

#define LOG_TAG TEXT("main")
#include "XLLogger.h"

typedef boost::shared_ptr<CDemo> DemoSharedPtr;
typedef boost::scoped_ptr<CDemo> DemoScopedPtr;
typedef boost::weak_ptr<CDemo> DemoWeakPtr;

int main(int argc, char *argv[]) {
	XL::Logger::Instance()->InitLogger(argv[0]);
	LOGT("Program Name: " << argv[0]);
	LOGT("boost.format demo: ");
	std::string feild1 = "Hello";
	std::string format1 = str(boost::format("%1% World!") % feild1);
	LOGD(format1);
	int feild2 = 2;
	const char* feild3 = "format";
	LOGD(str(boost::format("%1% %2% %3%, number=%1%") % feild2 % feild1 % feild3));
	LOGT("======================================================");

	DemoWeakPtr weakDemo;
	LOGT("boost.smart_ptr demo: ");
	{
		DemoScopedPtr scopedDemo(new CDemo);
		//DemoSharedPtr sharedDemo = scopedDemo; //error
		DemoSharedPtr sharedDemo(new CDemo);
		LOGD("sharedDemo CDemo ref=" << sharedDemo.use_count());
		DemoSharedPtr sharedDemo1 = sharedDemo;
		LOGD("sharedDemo1 CDemo ref=" << sharedDemo1.use_count());
		//DemoScopedPtr scopedDemo1 = scopedDemo;//error
		weakDemo = sharedDemo1;
		sharedDemo->Hello();
//		weakDemo->Hello();	//error?
		if (!weakDemo.expired()) {
			LOGD("weakDemo CDemo ref=" << weakDemo.use_count());
		}
	}
	if (weakDemo.expired()) {
		LOGD("weakDemo CDemo ref=" << weakDemo.use_count());
	}

	LOGT("lexical_cast demo:");
	std::string s1 = "1234565";
	std::string s2 = "123null";
	std::string s3 = "null";
	try {
		LOGD(s1 << ":" << boost::lexical_cast<int>(s1));

	} catch (const std::bad_cast& e) {
		LOGE(s1 << ": " << e.what());
	}
	try {
		LOGD(s2 << ":" << boost::lexical_cast<int>(s2));

	} catch (const std::bad_cast& e) {
		LOGE(s2 << ": " << e.what());
	}
	try {
		LOGD(s3 << ":" << boost::lexical_cast<int>(s3));
	} catch (const std::bad_cast& e) {
		LOGE(s3 << ": " << e.what());
	}

	LOGT("OK.");
	return 0;
}
