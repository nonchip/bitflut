cdef_BF_FRAME=[[
struct BF_FRAME {
  char magic[4]; // unterminated "BFPX"
  uint32_t x,y;
  uint8_t r,g,b,a;
};
]]

{:cdef_BF_FRAME}
