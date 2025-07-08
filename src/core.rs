use raylib::prelude::{Color, RaylibDraw, RaylibDrawHandle};

pub struct Core {
    pub pos: (f32, f32),
    pub _direction: f32,
    pub _speed: f32,
}
impl Core {
    pub const _SPEED_MULTIPLIER: f32 = 0.0005;
    pub const _FRICTION: f32 = 0.90;
    pub const RADIUS: f32 = 0.03;

    pub fn step(self: &mut Self, direction: (f32, f32)) {
        // FIXME: Make step consider speed and direction
        // FIXME: Apply friction
        self._speed *= Self::_FRICTION;
        self.pos.0 += direction.0 * Self::_SPEED_MULTIPLIER;
        self.pos.1 += direction.1 * Self::_SPEED_MULTIPLIER;
    }

    pub fn draw(self: &Self, dh: &mut RaylibDrawHandle, scr: (f32, f32)) {
        assert!(self.pos.0 >= 0.0 && self.pos.0 <= 1.0 && self.pos.1 >= 0.0 && self.pos.1 <= 1.0);

        let min_dim = scr.0.min(scr.1);
        dh.draw_circle(
            (self.pos.1 * scr.1 - Self::RADIUS / 2.0) as i32,
            (scr.0 - self.pos.0 * scr.0 - Self::RADIUS / 2.0) as i32,
            Self::RADIUS * min_dim,
            Color::YELLOW,
        );
    }
}
