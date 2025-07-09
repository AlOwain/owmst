#include <raylib.h>

#include "datatypes.h"
#include "config.h"

void striker_draw(Vector2 pos) {
  DrawRectangle(pos.y, pos.x, 50, 150, BLACK);
}

void arena_draw(Arena arena) {
  // FIXME: This is not drawn.
  DrawRectangle((int) arena.bl.x, (int) arena.bl.y, 100, 200, RAYWHITE);
}

void ball_draw(float pos_x, float pos_y) {
  // FIXME: Subtract half of ball size from position
  DrawCircle((int) (pos_y * (float) SCREEN_WIDTH), (int) (pos_x * (float) SCREEN_HEIGHT), 20, YELLOW);
}

// TODO: define object size to be relative to screen size.
void draw(PlayerState *ps) {
  striker_draw(ps->pos);
  // arena_draw(pos_x, 200);
  ball_draw(0.5f, 0.5f);
}
