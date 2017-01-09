# bitflut
a defnull/pixelflut inspired binary framebuffer thingie

## Usage:
run the server, it'll listen on `ipv6/::/udp/54321`.
to draw a pixel, send a binary datagram formatted as:

    byte:    01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16
    meaning:        magic      |         x         |         y         |  R |  G |  B |  A
    values:        "BFPX"      |                uint32_t               |       uint8_t

of course as this runs over UDP, the datagram, and thus pixel, is never guaranteed to arrive.
