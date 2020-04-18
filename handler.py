#!/usr/local/bin/python

import sys
import urllib
import os

url = sys.argv[1]
handler, fullPath = url.split(":", 1)
path, fullArgs = fullPath.split("?", 1)
args = fullArgs.split("&")
params = {
    "path": path
}

for url in args:
    key, value = map(urllib.unquote, url.split("=", 1))
    params[key] = value

try:
    import neovim
except ImportError:
    os.system("osascript -e 'display alert \"Error\" message \"Please install neovim with 'pip install neovim'\"'")

try:
    nvim =neovim.attach('socket', path=params['server'])

    # Open file
    nvim.command(':e ' + str(params['path']))

    # Go to line
    if params['line']:
        nvim.command(':' + params['line'])
except:
    os.system("osascript -e 'display alert \"Error\" message \"Vim does not appear to be running\"'")

