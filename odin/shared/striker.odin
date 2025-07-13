package shared

/*
While such things are defined way too early in the program, I can't currently make progress, as I have not yet setup my graphical build environment. However, the program runs, and I want to learn the language, even by learning to use such features prematurely
*/
Striker :: struct {
	type: enum {
		Fighter, Dueler, Sniper
	},
	pos: fvec2
}

striker_move :: proc(self: ^Striker, dir: ^Direction) { }

striker_logic :: proc(self: ^Striker, dir: ^Direction) { }
