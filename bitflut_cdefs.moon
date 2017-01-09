cdef_BF_FRAME=[[
  #pragma pack(1)
  struct BF_FRAME {
    char magic[4]; // unterminated "BFPX"
    uint32_t x,y;
    uint8_t r,g,b,a;
  };
]]

cdef_FF_IMAGE=[[ // all numbers in big endian
  #pragma pack(1)
  struct FF_IMAGE_header {
    char magic[8]; // unterminated 'farbfeld'
    uint32_t w;
    uint32_t h;
  };
  struct FF_IMAGE_pixel {
    uint16_t r,g,b,a;
  };
  struct FF_IMAGE {
    struct FF_IMAGE_header header;
    struct FF_IMAGE_pixel pixels[?];
  };
]]

{:cdef_BF_FRAME, :cdef_FF_IMAGE}
