type t =
  | DependsOnKbLayout
  | Unknown
  | Backspace
  | Tab
  | Enter
  | Shift
  | Ctrl
  | Alt
  | PauseBreak
  | CapsLock
  | Escape
  | Space
  | PageUp
  | PageDown
  | End
  | Home
  | LeftArrow
  | UpArrow
  | RightArrow
  | DownArrow
  | Insert
  | Delete
  | KEY_0
  | KEY_1
  | KEY_2
  | KEY_3
  | KEY_4
  | KEY_5
  | KEY_6
  | KEY_7
  | KEY_8
  | KEY_9
  | KEY_A
  | KEY_B
  | KEY_C
  | KEY_D
  | KEY_E
  | KEY_F
  | KEY_G
  | KEY_H
  | KEY_I
  | KEY_J
  | KEY_K
  | KEY_L
  | KEY_M
  | KEY_N
  | KEY_O
  | KEY_P
  | KEY_Q
  | KEY_R
  | KEY_S
  | KEY_T
  | KEY_U
  | KEY_V
  | KEY_W
  | KEY_X
  | KEY_Y
  | KEY_Z
  | Meta
  | ContextMenu
  | F1
  | F2
  | F3
  | F4
  | F5
  | F6
  | F7
  | F8
  | F9
  | F10
  | F11
  | F12
  | F13
  | F14
  | F15
  | F16
  | F17
  | F18
  | F19
  | NumLock
  | ScrollLock
  | US_SEMICOLON
  | US_EQUAL
  | US_COMMA
  | US_MINUS
  | US_DOT
  | US_SLASH
  | US_BACKTICK
  | US_OPEN_SQUARE_BRACKET
  | US_BACKSLASH
  | US_CLOSE_SQUARE_BRACKET
  | US_QUOTE
  | OEM_8
  | OEM_102
  | NUMPAD_0
  | NUMPAD_1
  | NUMPAD_2
  | NUMPAD_3
  | NUMPAD_4
  | NUMPAD_5
  | NUMPAD_6
  | NUMPAD_7
  | NUMPAD_8
  | NUMPAD_9
  | NUMPAD_MULTIPLY
  | NUMPAD_ADD
  | NUMPAD_SEPARATOR
  | NUMPAD_SUBTRACT
  | NUMPAD_DECIMAL
  | NUMPAD_DIVIDE
  | KEY_IN_COMPOSITION
  | ABNT_C1
  | ABNT_C2
  | MAX_VALUE

let to_int = function
  | DependsOnKbLayout -> -1
  | Unknown -> 0
  | Backspace -> 1
  | Tab -> 2
  | Enter -> 3
  | Shift -> 4
  | Ctrl -> 5
  | Alt -> 6
  | PauseBreak -> 7
  | CapsLock -> 8
  | Escape -> 9
  | Space -> 10
  | PageUp -> 11
  | PageDown -> 12
  | End -> 13
  | Home -> 14
  | LeftArrow -> 15
  | UpArrow -> 16
  | RightArrow -> 17
  | DownArrow -> 18
  | Insert -> 19
  | Delete -> 20
  | KEY_0 -> 21
  | KEY_1 -> 22
  | KEY_2 -> 23
  | KEY_3 -> 24
  | KEY_4 -> 25
  | KEY_5 -> 26
  | KEY_6 -> 27
  | KEY_7 -> 28
  | KEY_8 -> 29
  | KEY_9 -> 30
  | KEY_A -> 31
  | KEY_B -> 32
  | KEY_C -> 33
  | KEY_D -> 34
  | KEY_E -> 35
  | KEY_F -> 36
  | KEY_G -> 37
  | KEY_H -> 38
  | KEY_I -> 39
  | KEY_J -> 40
  | KEY_K -> 41
  | KEY_L -> 42
  | KEY_M -> 43
  | KEY_N -> 44
  | KEY_O -> 45
  | KEY_P -> 46
  | KEY_Q -> 47
  | KEY_R -> 48
  | KEY_S -> 49
  | KEY_T -> 50
  | KEY_U -> 51
  | KEY_V -> 52
  | KEY_W -> 53
  | KEY_X -> 54
  | KEY_Y -> 55
  | KEY_Z -> 56
  | Meta -> 57
  | ContextMenu -> 58
  | F1 -> 59
  | F2 -> 60
  | F3 -> 61
  | F4 -> 62
  | F5 -> 63
  | F6 -> 64
  | F7 -> 65
  | F8 -> 66
  | F9 -> 67
  | F10 -> 68
  | F11 -> 69
  | F12 -> 70
  | F13 -> 71
  | F14 -> 72
  | F15 -> 73
  | F16 -> 74
  | F17 -> 75
  | F18 -> 76
  | F19 -> 77
  | NumLock -> 78
  | ScrollLock -> 79
  | US_SEMICOLON -> 80
  | US_EQUAL -> 81
  | US_COMMA -> 82
  | US_MINUS -> 83
  | US_DOT -> 84
  | US_SLASH -> 85
  | US_BACKTICK -> 86
  | US_OPEN_SQUARE_BRACKET -> 87
  | US_BACKSLASH -> 88
  | US_CLOSE_SQUARE_BRACKET -> 89
  | US_QUOTE -> 90
  | OEM_8 -> 91
  | OEM_102 -> 92
  | NUMPAD_0 -> 93
  | NUMPAD_1 -> 94
  | NUMPAD_2 -> 95
  | NUMPAD_3 -> 96
  | NUMPAD_4 -> 97
  | NUMPAD_5 -> 98
  | NUMPAD_6 -> 99
  | NUMPAD_7 -> 100
  | NUMPAD_8 -> 101
  | NUMPAD_9 -> 102
  | NUMPAD_MULTIPLY -> 103
  | NUMPAD_ADD -> 104
  | NUMPAD_SEPARATOR -> 105
  | NUMPAD_SUBTRACT -> 106
  | NUMPAD_DECIMAL -> 107
  | NUMPAD_DIVIDE -> 108
  | KEY_IN_COMPOSITION -> 109
  | ABNT_C1 -> 110
  | ABNT_C2 -> 111
  | MAX_VALUE -> 112
;;

let to_jv x = x |> to_int |> Jv.of_int
