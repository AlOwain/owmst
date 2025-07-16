# OWMst

A 2D game, inspired by Omega Strikers.

How could you expand the game into more fields, how could you make a MMORPG out out it?

## Usage of Odin

This is my very first time using Odin, I have not written or read anything about it, but I'll try to catch up as fast as possible!

...I don't think I'm confident enough to build the server using Odin yet, I might finally have a project with two prevalent programming languages! If the Linux kernel can do it, why can't I?

Although I won't ever duplicate work and I might need to, for instance, in the Physics of it all. I could just have a Rust wrapper on the Odin physics, given that it is highly scrutinized. I'm not sure all this seems right though.

## Game Design Theory

### General

1. The game should be playable from the web-browser?

### Gameplay

1. If the Core is going fast, you should be faster, have shorter cooldowns, and the clock ticks should go by faster to keep up the tempo.
2. The Core Flip "mana" segments should not only be used to make you untargetable, it should also stop the core, fixing its orientation to be able to deal with the new physics system.

### Physics

1. The game is on an air-hockey table, friction should be low, but if the friction is too low the Core could get too fast.

2. If the Core is traveling, a hit aimed in the *same* direction, no matter how weak should not slow the Core down, it should only accelerate it.

3. If the Core is traveling, a hit aimed in the *opposite* direction, should not redirect it if the force applied is not sufficient, it should only reduce the current force on the Core. 

4. The Core should move 3-dimensionally, and I mean really 3 dimensionally, as in hits raise the ball, and hits on the wall could tilt it making tilted hits have reduced power, it's tilt should then continue with your hit, possibly flipping it in the air.

### Graphics & A/V effects

1. If the Core is going fast, or the game-time is running out, or the Core is in the Goal Arc or the game is closely contested, visual and audio effects similar to the ones in Marvel Rivals should be applied. The visual and audio effects should apply on a per-player basis, being made in the client side, if the player is in the final game of ranking up or ranking down, the visual effects should be applied only to the player and his premade team. The audio effects include playing music, additional echo to the Core hit, particularly on the walls, and a screech when the Core is traveling towards the Goal Arc. The video effects should include an increased FOV, screen shaking when the Core hits the wall at high speeds or is approaching the Goal Arc, and even the magazine black lines that "tear" the screen.

2. The game should be far more creative with its animations and movement, players should be able to buy walking and running animations, as well as hitting animations, and they should be mixed as well as different angles (for hits) or speeds (for movement) having different animations. Some idle animations should also auto-play.
