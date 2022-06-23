/// @description Handle callbacks

show_debug_message("GC ASYNC = " + json_encode(async_load));

// We create a switch on the 'type' of the event being triggered
// The type of events used by the GameCenter API starts with "GameCenter_"
switch(async_load[?"type"])
{
	// @triggered by GameCenter_LocalPlayer_Authenticate()
	case "GameCenter_Authenticate":
	// @triggered by GameCenter_Leaderboard_Submit()
	case "GameCenter_Leaderboard_Submit":
	// @triggered by GameCenter_Achievement_Report()
	case "GameCenter_Achievement_Report":
	// @triggered by GameCenter_Achievement_ResetAll()
	case "GameCenter_Achievement_ResetAll":
	
		// At this point on of the requests above just triggered it's callback.
		// However we still need to check if the task was successfull or not,
		// for that purposed we can read the flag 'success'.
		if (!async_load[?"success"])
		{
			// Here we just use an async message to inform the user that the
			// task failed.
			show_message_async(async_load[?"type"] + " FAILED");
		}
		break;
	
	// @triggered by GameCenter_PresentView_Default()
	// @triggered by GameCenter_PresentView_Achievement()
	// @triggered by GameCenter_PresentView_Achievements()
	// @triggered by GameCenter_PresentView_Leaderboard()
	// @triggered by GameCenter_PresentView_Leaderboards()
	case "GameCenter_PresentView_DidFinish":
		
		// At this point we just dismissed a GameCenter's overlay view.
		// Here we just use a debug message saying that the view was dismissed.
		show_debug_message("View DidFinish")
		break;
}