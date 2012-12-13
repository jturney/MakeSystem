#!/usr/bin/env python

import fnmatch
import os
import sys
from mako.template import Template

curdir = os.getcwd()
mkdir = os.path.dirname(os.path.abspath(sys.argv[0]))
destinationdir = ''

if curdir == mkdir:
    print "Do not run in MakeSystem directory."
    sys.exit(1)

# Check command line arguments
if len(sys.argv) == 1 or (len(sys.argv) == 2 and "-h" in sys.argv[1]):
    print "Make System"
    sys.exit(1)
elif len(sys.argv) == 2:
    destinationdir = sys.argv[1]
else:
    print "Make System"
    sys.exit(1)

binaryname = destinationdir
source = []

if destinationdir != '.':
    os.mkdir(destinationdir)
    os.chdir(destinationdir)
else:
    binaryname = os.getcwd().split('/')[-1]
    for root, dirnames, filenames in os.walk(curdir):
        for filename in fnmatch.filter(filenames, '*.cc'):
            source.append(os.path.join(root, filename).replace(curdir + '/' , ''))

# Load Mako template file
makefile_template = Template(filename=mkdir+'/Makefile')

makefile = None
try:
    makefile = open('Makefile', 'w')
    makefile.write(makefile_template.render(name=binaryname, sources=' '.join(source)))
except IOError as e:
    print "Unable to create your makefile file."
    sys.exit(1)

makefile.close()

# Copy settings.mk
import shutil, errno

def copyanything(src, dst):
    try:
        shutil.copytree(src, dst)
    except OSError as exc: # python >2.5
        if exc.errno == errno.ENOTDIR:
            shutil.copy(src, dst)
        else: raise

copyanything(mkdir+'/settings.mk', 'settings.mk')

