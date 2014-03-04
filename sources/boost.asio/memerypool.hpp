/*
 * memerypool.hpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#ifndef MEMERYPOOL_HPP_
#define MEMERYPOOL_HPP_

#include <boost/pool/singleton_pool.hpp>

#define MEMORY_BUFFER_MAX_SIZE 32768

struct memorypool {
};
typedef boost::singleton_pool<memorypool, MEMORY_BUFFER_MAX_SIZE> memory_pool_32k;

#endif /* MEMERYPOOL_HPP_ */
