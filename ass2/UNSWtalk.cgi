#!/usr/bin/python3

import os
from wsgiref.handlers import CGIHandler
from UNSWtalk import app
if 'PATH_INFO' not in os.environ:
    os.environ['PATH_INFO'] = ''
app.secret_key = 'correct horse battery staple'
CGIHandler().run(app)
