#define MIN(a, b) (a < b ? a : b)
#define MAX(a, b) (a > b ? a : b)

void clip_inc(float * val, float max, float inc, float rst) {
  if (*val >= max) {
    *val = rst;
  } else {
    *val += inc;
  }
}

void clip_dec(float * val, float min, float dec, float rst) {
  if (*val <= min) {
    *val = rst;
  } else {
    *val -= dec;
  }
}
