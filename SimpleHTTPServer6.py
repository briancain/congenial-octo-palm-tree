import BaseHTTPServer
import SimpleHTTPServer
import socket

###################################
# Usage:
#  python -m SimpleHTTPServer6 PORT
###################################

class HTTPServer6(BaseHTTPServer.HTTPServer):
    address_family = socket.AF_INET6


if __name__ == '__main__':
    SimpleHTTPServer.test(ServerClass=HTTPServer6)
