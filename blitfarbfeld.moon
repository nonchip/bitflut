require 'luarocks.loader'
ffi = require 'ffi'
bit = require 'bit'
C = ffi.C
socket = require 'socket'
import cdef_BF_FRAME, cdef_FF_IMAGE from require 'bitflut_cdefs'

ffi.cdef cdef_BF_FRAME
ffi.cdef cdef_FF_IMAGE

ffi.cdef[[
  int nanosleep(const struct timespec *req, struct timespec *rem);
  typedef long time_t;
  struct timespec {
    time_t tv_sec;
    long   tv_nsec;
  };
]]

ip = arg[1] or '::1'
xoff = tonumber arg[2] or 0
yoff = tonumber arg[3] or 0
wait = tonumber arg[4] or 5000

frame = ffi.new 'struct BF_FRAME'
frame.magic=ffi.new 'char [4]', 'BFPX'

client = assert socket.udp6!

fsize=ffi.sizeof 'struct BF_FRAME'

imagef=io.read '*all'

swapper32=ffi.abi'le' and ((x)->bit.bswap bit.tobit x) or ((x)->bit.tobit x)

swapper16=(x)->bit.rshift swapper32(x), 16

sleeperts=ffi.new 'struct timespec', {0, wait}

if imagef
  image = ffi.new 'struct FF_IMAGE', (imagef\len! - ffi.sizeof 'struct FF_IMAGE_header')/8
  ffi.copy image, imagef, ffi.sizeof image
  if ffi.string(image.header.magic,8)=='farbfeld'
    w=swapper32 image.header.w
    h=swapper32 image.header.h
    for yi=0,h-1
      for xi=0,w-1
        frame.x = xi + xoff
        frame.y = yi + yoff
        frame.r = swapper16 image.pixels[yi*w + xi].r
        frame.g = swapper16 image.pixels[yi*w + xi].g
        frame.b = swapper16 image.pixels[yi*w + xi].b
        frame.a = swapper16 image.pixels[yi*w + xi].a
        client\sendto ffi.string(ffi.cast('void*',frame),fsize), ip, 54321
        C.nanosleep sleeperts, ffi.NULL
