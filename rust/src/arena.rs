use raylib::prelude::{Color, RaylibDraw, RaylibDrawHandle, Rectangle};

pub struct Arena;
impl Arena {
    pub fn draw(dh: &mut RaylibDrawHandle, scr: (f32, f32)) {
        let area = Rectangle {
            x: 10.0,
            y: 10.0,
            height: scr.0 - 20.0,
            width: scr.1 - 20.0,
        };
        dh.draw_rectangle_lines_ex(area, 10.0, Color::BLACK);
    }
}
