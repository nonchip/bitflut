require 'luarocks.loader'
ffi = require 'ffi'
C = ffi.C
socket = require 'socket'
import cdef_BF_FRAME from require 'bitflut_cdefs'

ffi.cdef cdef_BF_FRAME

ip = arg[1] or '::1'

frame = ffi.new 'struct BF_FRAME'
frame.magic=ffi.new 'char [4]', 'BFPX'

inmatch = 'PX (%d+) (%d+) '..('([0-9a-fA-F][0-9a-fA-F])'\rep 3)

client = assert socket.udp6!

fsize=ffi.sizeof 'struct BF_FRAME'

while true
  line=io.read '*l'
  if line\len! > 4
    x,y,r,g,b = assert line\match inmatch
    frame.x=assert tonumber x, 10
    frame.y=assert tonumber y, 10
    frame.r=assert tonumber r, 16
    frame.g=assert tonumber g, 16
    frame.b=assert tonumber b, 16
    frame.a=255
    client\sendto ffi.string(ffi.cast('void*',frame),fsize), ip, 54321
