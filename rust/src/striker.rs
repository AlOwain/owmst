use raylib::{
    RaylibHandle,
    prelude::{Color, KeyboardKey, RaylibDraw, RaylibDrawHandle},
};

pub struct Striker {
    pub pos: (f32, f32),
}
impl Striker {
    pub const SPEED_MULTIPLIER: f32 = 0.0005;
    pub const HEIGHT: f32 = 0.1;
    pub const WIDTH: f32 = 0.1;

    pub fn input(self: &Self, rh: &RaylibHandle) -> (f32, f32) {
        if rh.is_key_down(KeyboardKey::KEY_W) {
            return (1.0, 0.0);
        }
        if rh.is_key_down(KeyboardKey::KEY_D) {
            return (0.0, 1.0);
        }
        if rh.is_key_down(KeyboardKey::KEY_S) {
            return (-1.0, 0.0);
        }
        if rh.is_key_down(KeyboardKey::KEY_A) {
            return (0.0, -1.0);
        }
        (0.0, 0.0)
    }

    pub fn step(self: &mut Self, direction: (f32, f32)) {
        self.pos.0 += direction.0 * Self::SPEED_MULTIPLIER;
        self.pos.1 += direction.1 * Self::SPEED_MULTIPLIER;
    }

    pub fn draw(self: &Self, dh: &mut RaylibDrawHandle, scr: (f32, f32)) {
        // FIXME: The ordering is wrong?
        assert!(
            self.pos.0 - Self::WIDTH >= 0.0
                && self.pos.0 <= 1.0
                && self.pos.1 >= 0.0
                && self.pos.1 + Self::HEIGHT <= 1.0
        );

        let min_dim = scr.0.min(scr.1);
        dh.draw_rectangle(
            (self.pos.1 * scr.1 - Self::WIDTH / 2.0) as i32,
            (scr.0 - self.pos.0 * scr.0 - Self::HEIGHT / 2.0) as i32,
            // FIXME: This makes the size of the player relative to the size of the window, a rectangular window will mean the player is rectangular
            (Self::WIDTH * min_dim) as i32,
            (Self::HEIGHT * min_dim) as i32,
            Color::BLACK,
        );
    }
}
