#include <raylib.h>
#include <stdio.h>

#include "datatypes.h"
#include "draw.h"
#include "config.h"
#include "math_helper.h"

void input(PlayerState *ps) {
  if (IsKeyDown(KEY_W))
    clip_inc(&ps->pos.x, MIN(SCREEN_WIDTH, SCREEN_HEIGHT), 1.0f, 0.0f);
  if (IsKeyDown(KEY_S))
    clip_dec(&ps->pos.x, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), 1.0f, 0.0f);
  if (IsKeyDown(KEY_W))
    clip_inc(&ps->pos.x, MIN(SCREEN_WIDTH, SCREEN_HEIGHT), 1.0f, 0.0f);
  if (IsKeyDown(KEY_W))
    clip_inc(&ps->pos.x, MIN(SCREEN_WIDTH, SCREEN_HEIGHT), 1.0f, 0.0f);
}

int main() {
  InitWindow(1280, 800, "C Omega Strikers");

  SetTargetFPS(60);

  PlayerState ps = (PlayerState) {
    // TODO: Should face the opposing teams' goal.
    .direction = 0.0f,
    .pos = (Vector2) { .x = 0.5f, .y = 0.3f }
  };

  while (!WindowShouldClose()) {
    BeginDrawing();
      ClearBackground(WHITE);
      input(&ps);
      draw(&ps);
    EndDrawing();
  }

  return 0;
}
