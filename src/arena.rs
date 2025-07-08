use raylib::prelude::{Color, RaylibDraw, RaylibDrawHandle, Rectangle};

pub struct Arena;
impl Arena {
    pub fn draw(dh: &mut RaylibDrawHandle, scr: (f32, f32)) {
        dh.draw_rectangle_lines_ex(self.0, 10.0, Color::BLACK);
    }
}
