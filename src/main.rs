use raylib::{prelude::Color, prelude::RaylibDraw};

mod arena;
mod core;
mod striker;

use self::{arena::Arena, core::Core, striker::Striker};

fn main() {
    let (mut rh, thread) = raylib::init()
        .size(1200, 800)
        .title("OWmega Strikers")
        .resizable()
        .build();

    let arena = Arena {};
    let mut striker = Striker { pos: (0.5, 0.5) };
    let core = Core {
        pos: (0.5, 0.5),
        _direction: 0.0,
        _speed: 0.0,
    };

    while !rh.window_should_close() {
        // TODO: Instead of taking a step at each second in the thread we should add the input to a queue that is processed in a seperate thread.
        striker.step(striker.input(&rh));
        let scr_dim = (rh.get_screen_height() as f32, rh.get_screen_width() as f32);
        let mut dh = rh.begin_drawing(&thread);

        dh.clear_background(Color::WHITE);
        striker.draw(&mut dh, scr_dim);
        core.draw(&mut dh, scr_dim);
        arena.draw(&mut dh, scr_dim);
    }
}
