/// @description Leaderboard data handler

var s = "Game Center Leaderboard Data:\n";

	// string:
if (async_load[? "type"] == "GameCenter_Leaderboard_Load"
	// number:
&&  async_load[? "id"] == asyncOpId) {
	// bool:
	if (!async_load[? "success"]) {
		s += "Error:\n";
		// string: Display this to the user
		s += "Message: " + async_load[? "error_message"] + "\n";
		// number: See Apple GameKit documentation for more information on these
		s += "Code: " + string(async_load[? "error_code"]) + "\n";
		// do NOT touch any other DS Map fields if success!=true
		// otherwise you risk crashing the game.
	}
	else {
		// string: Use this string to display the name of your leaderboard:
		s += "Leaderboard: " + async_load[? "leaderboard_name"] + "\n";
		// string: The Game Center group as defined in App Store Connect
		s += "Group: " + async_load[? "leaderboard_group"] + "\n";
		// number:
		var entries = async_load[? "entries"];
		// "entry_THING_INDEX" where INDEX from 0 to entries, where THING is a string.
		// if entries is 0 or less, then no entries match your request.
		s += "Entries: " + string(entries) + ", rank displayName formattedScore date context rawScore:\n";
		for (var i = 0; i < entries; ++i) {
			// number: Can be stored in some data structure
			var e_score = async_load[? "entry_score_" + string(i)];
			// string: Use this to display the number
			var e_fmt_score = async_load[? "entry_formatted_score_" + string(i)];
			// number: User-defined value you pass to _Submit(), can be any number.
			var e_context = async_load[? "entry_context_" + string(i)];
			// number: 'Place' in the leaderboard, cannot be -1
			var e_rank = async_load[? "entry_rank_" + string(i)];
			// number: Date of the entry creation, use with date_*()
			var e_date = async_load[? "entry_date_" + string(i)];
			// string: JSON similar to one returned by GameCenter_LocalPlayer_GetInfo()
			// can be "{}" if no data is available, usually this doesn't happen...
			var e_info = json_parse(async_load[? "entry_info_" + string(i)]);
			// please use info.displayName whenever possible when displaying other player's scores.
			// and use info.alias when storing the information somewhere on save
			s += 
				// you can display this:
				string(e_rank) + " " +
				string(e_info[$ "displayName"]) + " " +
				string(e_fmt_score) + " " +
				date_datetime_string(e_date) + " " +
				// you usually should NEVER display this: but it's a demo so who cares
				string(e_context) + " " + 
				string(e_score) + "\n";
		}
		
		// same as e_score
		var l_score = async_load[? "local_score"];
		// same as e_fmt_score
		var l_fmt_score = async_load[? "local_formatted_score"];
		// same as e_context
		var l_context = async_load[? "local_context"];
		// same as e_rank
		var l_rank = async_load[? "local_rank"];
		// same as e_date
		var l_date = async_load[? "local_date"];
		// same as e_info, except this one is for your local player.
		var l_info = json_parse(async_load[? "local_info"]);
		// a quick way to check if you actually are present, rank is not -1.
		var l_has_this_player = l_rank != -1;
		if (l_has_this_player) {
			s += "--- This player is present: same format\n";
			s += 
				// you can display this:
				string(l_rank) + " " +
				string(l_info[$ "displayName"]) + " " +
				string(l_fmt_score) + " " +
				date_datetime_string(l_date) + " " +
				// you usually should NEVER display this: but it's a demo so who cares
				string(l_context) + " " + 
				string(l_score) + "\n";	
		}
		
		// there are some other fields in the DS Map
		// but they are purely for informative purposes
		// and are not available when using old APIs (older than iOS 14.0 or macOS 11.0)
		// as such they are not shown in this demo:
		// number: GameCenter_Leaderboard_Type_* constant
		// var type = async_load[? "leaderboard_type"];
		// -- ONLY VALID FOR GameCenter_Leaderboard_Type_Recurring LEADERBOARDS STUFF -- //
		//     number: use in date_*() functions
		//     var start_date = async_load[? "leaderboard_start_date"];
		//     number: use in date_*() functions
		//     var next_start_date = async_load[? "leaderboard_next_start_date"];
		//     number: in seconds, use date_inc_second(date, duration) with either start date or next date.
		//     var duration = async_load[? "leaderboard_duration"];
		//     // var next_next_date = date_inc_second(next_start_date, duration);
		// -- STUFF END -- //
		
		// Fields "leaderboard_id", "time_scope", "range_start", "range_end"
		// just mirror the arguments you originally passed to the function
		// the types are the same as the argument types...
		
		// number: constant GameCenter_Leaderboard_PlayerScope_*
		// depends on which function you called, _Global() or _FriendsOnly()
		// var scope = async_load[? "player_scope"];
	}
}

// display the data in a small async window:
s += "\nData End.\n";
show_message_async(s);

// this object is now free to process an another request!
asyncBusy = false;
