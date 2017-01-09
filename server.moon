require 'luarocks.loader'
ffi = require 'ffi'
C = ffi.C
sdl = require 'sdl2'
socket = require 'socket'
import cdef_BF_FRAME from require 'bitflut_cdefs'

ffi.cdef cdef_BF_FRAME

server = assert socket.udp6!
assert server\setsockname '::', 54321
server\settimeout 1

sdl.init sdl.INIT_VIDEO

window = sdl.createWindow "BitFlut", sdl.WINDOWPOS_CENTERED, sdl.WINDOWPOS_CENTERED, 512, 512, sdl.WINDOW_SHOWN
renderer = sdl.createRenderer window, -1, sdl.RENDERER_ACCELERATED

sdl.setRenderDrawColor renderer, 0, 0, 0, 0
sdl.renderClear renderer
sdl.renderPresent renderer

fsize=ffi.sizeof 'struct BF_FRAME'

running = true
event = ffi.new('SDL_Event')
while running
  frame=server\receive fsize
  if frame
    frame=ffi.cast 'struct BF_FRAME *', frame
    if ffi.string(frame.magic,4)=='BFPX'
      sdl.setRenderDrawColor renderer, frame.r, frame.g, frame.b, frame.a
      sdl.renderDrawPoint renderer, frame.x, frame.y
  while sdl.pollEvent(event) ~= 0
    if event.type == sdl.QUIT
      running = false
  sdl.renderPresent renderer

sdl.destroyWindow window
sdl.quit!
