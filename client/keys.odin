package client

held_keys: bit_set[ckey] = {}
ckey :: enum {
	IGNORE = 0,

	SPACE,
	APOSTROPHE,
	COMMA,
	MINUS,
	PERIOD,
	SLASH,
	SEMICOLON,
	EQUAL,
	LEFT_BRACKET,
	BACKSLASH,
	RIGHT_BRACKET,
	GRAVE_ACCENT,
	WORLD_1,
	WORLD_2,

	ZERO,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,

	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
	I,
	J,
	K,
	L,
	M,
	N,
	O,
	P,
	Q,
	R,
	S,
	T,
	U,
	V,
	W,
	X,
	Y,
	Z,

	ESCAPE,
	ENTER,
	TAB,
	BACKSPACE,
	INSERT,
	DELETE,
	RIGHT,
	LEFT,
	DOWN,
	UP,
	PAGE_UP,
	PAGE_DOWN,
	HOME,
	END,
	CAPS_LOCK,
	SCROLL_LOCK,
	NUM_LOCK,
	PRINT_SCREEN,
	PAUSE,

	F1,
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	F10,
	F11,
	F12,
	F13,
	F14,
	F15,
	F16,
	F17,
	F18,
	F19,
	F20,
	F21,
	F22,
	F23,
	F24,
	F25,

	KP_ZERO,
	KP_ONE,
	KP_TWO,
	KP_THREE,
	KP_FOUR,
	KP_FIVE,
	KP_SIX,
	KP_SEVEN,
	KP_EIGHT,
	KP_NINE,

	KP_DECIMAL,
	KP_DIVIDE,
	KP_MULTIPLY,
	KP_SUBTRACT,
	KP_ADD,
	KP_ENTER,
	KP_EQUAL,

	LEFT_SHIFT,
	LEFT_CONTROL,
	LEFT_ALT,
	LEFT_SUPER,
	RIGHT_SHIFT,
	RIGHT_CONTROL,
	RIGHT_ALT,
	RIGHT_SUPER,
	MENU,
}

glfw_to_ckey :: proc(glfw_key: i32) -> ckey {
	switch glfw_key {
	case -1:  return .IGNORE

	case 32:  return .SPACE
	case 39:  return .APOSTROPHE
	case 44:  return .COMMA
	case 45:  return .MINUS
	case 46:  return .PERIOD
	case 47:  return .SLASH
	case 59:  return .SEMICOLON
	case 61:  return .EQUAL
	case 91:  return .LEFT_BRACKET
	case 92:  return .BACKSLASH
	case 93:  return .RIGHT_BRACKET
	case 96:  return .GRAVE_ACCENT
	case 161: return .WORLD_1
	case 162: return .WORLD_2

	case 48:  return .ZERO
	case 49:  return .ONE
	case 50:  return .TWO
	case 51:  return .THREE
	case 52:  return .FOUR
	case 53:  return .FIVE
	case 54:  return .SIX
	case 55:  return .SEVEN
	case 56:  return .EIGHT
	case 57:  return .NINE

	case 65:  return .A
	case 66:  return .B
	case 67:  return .C
	case 68:  return .D
	case 69:  return .E
	case 70:  return .F
	case 71:  return .G
	case 72:  return .H
	case 73:  return .I
	case 74:  return .J
	case 75:  return .K
	case 76:  return .L
	case 77:  return .M
	case 78:  return .N
	case 79:  return .O
	case 80:  return .P
	case 81:  return .Q
	case 82:  return .R
	case 83:  return .S
	case 84:  return .T
	case 85:  return .U
	case 86:  return .V
	case 87:  return .W
	case 88:  return .X
	case 89:  return .Y
	case 90:  return .Z

	case 256: return .ESCAPE
	case 257: return .ENTER
	case 258: return .TAB
	case 259: return .BACKSPACE
	case 260: return .INSERT
	case 261: return .DELETE
	case 262: return .RIGHT
	case 263: return .LEFT
	case 264: return .DOWN
	case 265: return .UP
	case 266: return .PAGE_UP
	case 267: return .PAGE_DOWN
	case 268: return .HOME
	case 269: return .END
	case 280: return .CAPS_LOCK
	case 281: return .SCROLL_LOCK
	case 282: return .NUM_LOCK
	case 283: return .PRINT_SCREEN
	case 284: return .PAUSE

	case 290: return .F1
	case 291: return .F2
	case 292: return .F3
	case 293: return .F4
	case 294: return .F5
	case 295: return .F6
	case 296: return .F7
	case 297: return .F8
	case 298: return .F9
	case 299: return .F10
	case 300: return .F11
	case 301: return .F12
	case 302: return .F13
	case 303: return .F14
	case 304: return .F15
	case 305: return .F16
	case 306: return .F17
	case 307: return .F18
	case 308: return .F19
	case 309: return .F20
	case 310: return .F21
	case 311: return .F22
	case 312: return .F23
	case 313: return .F24
	case 314: return .F25

	case 320: return .KP_ZERO
	case 321: return .KP_ONE
	case 322: return .KP_TWO
	case 323: return .KP_THREE
	case 324: return .KP_FOUR
	case 325: return .KP_FIVE
	case 326: return .KP_SIX
	case 327: return .KP_SEVEN
	case 328: return .KP_EIGHT
	case 329: return .KP_NINE

	case 330: return .KP_DECIMAL
	case 331: return .KP_DIVIDE
	case 332: return .KP_MULTIPLY
	case 333: return .KP_SUBTRACT
	case 334: return .KP_ADD
	case 335: return .KP_ENTER
	case 336: return .KP_EQUAL

	case 340: return .LEFT_SHIFT
	case 341: return .LEFT_CONTROL
	case 342: return .LEFT_ALT
	case 343: return .LEFT_SUPER
	case 344: return .RIGHT_SHIFT
	case 345: return .RIGHT_CONTROL
	case 346: return .RIGHT_ALT
	case 347: return .RIGHT_SUPER
	case 348: return .MENU
	}

	panic("Invalid GLFW key pressed.")
}

ckey_to_glfw :: proc(ckey: ckey) -> i32 {
	switch ckey {
	case .IGNORE:        return -1

	case .SPACE:         return 32
	case .APOSTROPHE:    return 39
	case .COMMA:         return 44
	case .MINUS:         return 45
	case .PERIOD:        return 46
	case .SLASH:         return 47
	case .SEMICOLON:     return 59
	case .EQUAL:         return 61
	case .LEFT_BRACKET:  return 91
	case .BACKSLASH:     return 92
	case .RIGHT_BRACKET: return 93
	case .GRAVE_ACCENT:  return 96
	case .WORLD_1:       return 161
	case .WORLD_2:       return 162

	case .ZERO:          return 48
	case .ONE:           return 49
	case .TWO:           return 50
	case .THREE:         return 51
	case .FOUR:          return 52
	case .FIVE:          return 53
	case .SIX:           return 54
	case .SEVEN:         return 55
	case .EIGHT:         return 56
	case .NINE:          return 57

	case .A:             return 65
	case .B:             return 66
	case .C:             return 67
	case .D:             return 68
	case .E:             return 69
	case .F:             return 70
	case .G:             return 71
	case .H:             return 72
	case .I:             return 73
	case .J:             return 74
	case .K:             return 75
	case .L:             return 76
	case .M:             return 77
	case .N:             return 78
	case .O:             return 79
	case .P:             return 80
	case .Q:             return 81
	case .R:             return 82
	case .S:             return 83
	case .T:             return 84
	case .U:             return 85
	case .V:             return 86
	case .W:             return 87
	case .X:             return 88
	case .Y:             return 89
	case .Z:             return 90

	case .ESCAPE:        return 256
	case .ENTER:         return 257
	case .TAB:           return 258
	case .BACKSPACE:     return 259
	case .INSERT:        return 260
	case .DELETE:        return 261
	case .RIGHT:         return 262
	case .LEFT:          return 263
	case .DOWN:          return 264
	case .UP:            return 265
	case .PAGE_UP:       return 266
	case .PAGE_DOWN:     return 267
	case .HOME:          return 268
	case .END:           return 269
	case .CAPS_LOCK:     return 280
	case .SCROLL_LOCK:   return 281
	case .NUM_LOCK:      return 282
	case .PRINT_SCREEN:  return 283
	case .PAUSE:         return 284

	case .F1:            return 290
	case .F2:            return 291
	case .F3:            return 292
	case .F4:            return 293
	case .F5:            return 294
	case .F6:            return 295
	case .F7:            return 296
	case .F8:            return 297
	case .F9:            return 298
	case .F10:           return 299
	case .F11:           return 300
	case .F12:           return 301
	case .F13:           return 302
	case .F14:           return 303
	case .F15:           return 304
	case .F16:           return 305
	case .F17:           return 306
	case .F18:           return 307
	case .F19:           return 308
	case .F20:           return 309
	case .F21:           return 310
	case .F22:           return 311
	case .F23:           return 312
	case .F24:           return 313
	case .F25:           return 314

	case .KP_ZERO:       return 320
	case .KP_ONE:        return 321
	case .KP_TWO:        return 322
	case .KP_THREE:      return 323
	case .KP_FOUR:       return 324
	case .KP_FIVE:       return 325
	case .KP_SIX:        return 326
	case .KP_SEVEN:      return 327
	case .KP_EIGHT:      return 328
	case .KP_NINE:       return 329

	case .KP_DECIMAL:    return 330
	case .KP_DIVIDE:     return 331
	case .KP_MULTIPLY:   return 332
	case .KP_SUBTRACT:   return 333
	case .KP_ADD:        return 334
	case .KP_ENTER:      return 335
	case .KP_EQUAL:      return 336

	case .LEFT_SHIFT:    return 340
	case .LEFT_CONTROL:  return 341
	case .LEFT_ALT:      return 342
	case .LEFT_SUPER:    return 343
	case .RIGHT_SHIFT:   return 344
	case .RIGHT_CONTROL: return 345
	case .RIGHT_ALT:     return 346
	case .RIGHT_SUPER:   return 347
	case .MENU:          return 348
	}

	panic("CKey does not have GLFW equivalent.")
}
