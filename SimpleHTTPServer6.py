import BaseHTTPServer
import SimpleHTTPServer
import socket


class HTTPServer6(BaseHTTPServer.HTTPServer):
    address_family = socket.AF_INET6


if __name__ == '__main__':
    SimpleHTTPServer.test(ServerClass=HTTPServer6)
