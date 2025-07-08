package owmst

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
 rl.InitWindow(1200, 800, "OWMst");
 rl.SetWindowState(rl.ConfigFlag.WINDOW_RESIZABLE)
 for (!rl.WindowShouldClose()) {
  rl.BeginDrawing()
   rl.ClearBackground(rl.Color {255, 255, 255, 255})
  rl.EndDrawing()
 }
}
