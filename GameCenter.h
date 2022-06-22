#import <GameKit/GameKit.h>

@interface GameCenter:NSObject <GKGameCenterControllerDelegate,GKLocalPlayerListener>
{
}

@property (nonatomic, strong) NSMutableArray *ArrayOfConflicts;

-(double) GameCenter_MacOS_SetWindowHandle:(void*) ptrgamewindowhandle;

-(double) GameCenter_PresentView_Default;
-(double) GameCenter_PresentView_Achievements;
-(double) GameCenter_PresentView_Achievement:(NSString*) ach_id;
-(double) GameCenter_PresentView_Leaderboards;
-(double) GameCenter_PresentView_Leaderboard:(NSString*) leaderboardId leaderboardTimeScope: (double) leaderboardTimeScope playerScope:(double) playerScope;
-(double) GameCenter_LocalPlayer_Authenticate;
-(double) GameCenter_LocalPlayer_IsAuthenticated;
-(double) GameCenter_LocalPlayer_IsUnderage;
-(double) GameCenter_LocalPlayer_IsMultiplayerGamingRestricted;
-(double) GameCenter_LocalPlayer_IsPersonalizedCommunicationRestricted;
-(NSString*) GameCenter_LocalPlayer_GetInfo;

-(double) GameCenter_SavedGames_Fetch;
-(double) GameCenter_SavedGames_Save: (NSString*) name data: (NSString*) mNSData;
-(double) GameCenter_SavedGames_Delete: (NSString*) name;
-(double) GameCenter_SavedGames_GetData: (NSString*) name;
-(double) GameCenter_SavedGames_ResolveConflict:(double) conflict_ind data:(NSString*) data;

-(double) GameCenter_Leaderboard_Submit: (NSString*) leaderboardID score: (double) score;
-(double) GameCenter_Achievement_Report: (NSString*) identifier percentComplete: (double) percent;
-(double) GameCenter_Achievement_ResetAll;

@end
