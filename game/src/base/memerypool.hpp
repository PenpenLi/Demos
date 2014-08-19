/*
 * memerypool.hpp
 *
 *  Created on: 2014-3-4
 *      Author: xiaobin
 */

#ifndef MEMERYPOOL_HPP_
#define MEMERYPOOL_HPP_

#include <boost/pool/singleton_pool.hpp>

#define MEMORY_SIZE_8K 8192

struct memorypool {
};
typedef boost::singleton_pool<memorypool, MEMORY_SIZE_8K> memory_pool_8k;

#endif /* MEMERYPOOL_HPP_ */
