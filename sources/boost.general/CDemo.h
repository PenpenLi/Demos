/*
 * CDemo.h
 *
 *  Created on: 2014-2-19
 *      Author: xiaobin
 */

#ifndef CDEMO_H_
#define CDEMO_H_
#include <boost/noncopyable.hpp>
#include <boost/enable_shared_from_this.hpp>

/*!
 * @class CDemo
 */
class CDemo: private boost::noncopyable, public boost::enable_shared_from_this<CDemo> {
public:
	CDemo();
	virtual ~CDemo();

	void Hello();
};

#endif /* CDEMO_H_ */
