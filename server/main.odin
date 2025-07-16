package server

import "core:fmt"

import "../shared"

main :: proc() {
	plr := shared.Striker {
		type = .Fighter,
		pos = shared.fvec2 {0.0, 0.0},
	}

	fmt.println(plr)
	
	// for { } // Game loop
}
