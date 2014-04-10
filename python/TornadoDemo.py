#!/usr/bin/python
# _*_ coding: utf-8 _*_

import tornado.ioloop
import tornado.web


class DemoHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello World!")

application = tornado.web.Application([(r"/", DemoHandler)])

if __name__ == '__main__':
    application.listen(5555)
    tornado.ioloop.IOLoop.instance().start()
