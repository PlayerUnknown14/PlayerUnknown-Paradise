// Frame (de/con)struction states
/// Frame is empty, no wires no board
#define FRAME_STATE_EMPTY 0
/// Frame has been wired
#define FRAME_STATE_WIRED 1
/// Frame has a board installed, it is safe to assume if in this state then circuit is non-null (but you never know)
#define FRAME_STATE_BOARD_INSTALLED 2
/// Frame is empty, no circuit board yet
#define FRAME_COMPUTER_STATE_EMPTY FRAME_STATE_EMPTY
/// Frame now has a board installed, it is safe to assume beyond this state, circuit is non-null (but you never know)
#define FRAME_COMPUTER_STATE_BOARD_INSTALLED 1
/// Board has been secured
#define FRAME_COMPUTER_STATE_BOARD_SECURED 2
/// Frame has been wired
#define FRAME_COMPUTER_STATE_WIRED 3
/// Frame has had glass applied to it
#define FRAME_COMPUTER_STATE_GLASSED 4
