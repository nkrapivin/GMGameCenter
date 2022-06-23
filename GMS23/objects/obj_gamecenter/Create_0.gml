/// @description Initialize variables

// need to pass the current window to Objective-C code.
GameCenter_MacOS_SetWindowHandle(window_handle());

// Make sure we randomize the seed
randomize();