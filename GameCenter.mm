#import "GameCenter.h"

#if TARGET_OS_OSX
#define GMGC_MACOS 1
// enable GameMaker-GameCenter macOS specific code.
#endif

////////////////sigh:
extern
#ifndef GMGC_MACOS
    UIViewController
#else
    NSViewController
#endif
*g_controller;

////////////////macOS specific:
// also see GameCenterMacOS.cpp

#ifndef GMGC_MACOS
// g_controller is exported by the runner, no need to provide an impl.
// on macOS it is a little different though
// we have to get window_handle() from the game and resolve the viewcontroller that way.
// yeah I know, awful, Apple Moment!
#else
NSViewController* g_controller = nil;
NSWindow* g_window = nil;
#endif

////////////////GameMaker interface: macOS implementation is in GameCenterMacOS.cpp
const int EVENT_OTHER_SOCIAL = 70;
// those are not extern C
extern int CreateDsMap( int _num, ... );
extern void CreateAsynEventWithDSMap(int dsmapindex, int event_index);
// but these are... wtf yoyo???
extern "C" void dsMapAddDouble(int _dsMap, char* _key, double _value);
extern "C" void dsMapAddString(int _dsMap, char* _key, char* _value);

@implementation GameCenter

-(id) init {
    if ( self = [super init] ) {
        return self;
    }
    // ?????????????????
    return self;
}

-(double) GameCenter_MacOS_SetWindowHandle:(void*) ptrgamewindowhandle
{
#ifndef GMGC_MACOS
    // always return success on iOS, no need to init anything...
    return 1;
#else
    // the argument type is void* because we are calling this code from C++
    g_window = (NSWindow*)ptrgamewindowhandle;
    g_controller = nil;
    if (g_window != nil)
    {
        g_controller = g_window.contentViewController;
        return 1;
    }
    
    return 0;
#endif
}

////////////////GKGameCenterViewController
// https://developer.apple.com/documentation/gamekit/gkgamecenterviewcontroller?language=objc

-(double) GameCenter_PresentView_Default
{
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithState: GKGameCenterViewControllerStateDefault];
        if(gameCenterController == nil)
            return 0;
        
        gameCenterController.gameCenterDelegate = self;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    } else {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateDefault;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    }
    return 1;
}

-(double) GameCenter_PresentView_Achievements
{
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithState: GKGameCenterViewControllerStateAchievements];
        if(gameCenterController == nil)
            return 0;
        
        gameCenterController.gameCenterDelegate = self;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    } else {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    }
    return 1;
}

-(double) GameCenter_PresentView_Achievement:(NSString*) ach_id
{
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithAchievementID: ach_id];
        if(gameCenterController == nil)
            return 0;
        
        gameCenterController.gameCenterDelegate = self;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    } else {
        NSLog(@"GameCenter_PresentView_Achievement No Available Until iOS 14.0 or macOS 11.0");
        return 0;
    }
    return 1;
}

-(double) GameCenter_PresentView_Leaderboards
{
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithState: GKGameCenterViewControllerStateLeaderboards];
        if(gameCenterController == nil)
            return 0;
        
        gameCenterController.gameCenterDelegate = self;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    } else {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    }
    return 1;
}

-(double) GameCenter_PresentView_Leaderboard:(NSString*) leaderboardId leaderboardTimeScope: (double) leaderboardTimeScope playerScope:(double) playerScope
{
    GKLeaderboardPlayerScope mGKLeaderboardPlayerScope;
    
    switch((int) leaderboardTimeScope)
    {
        case 0: mGKLeaderboardPlayerScope = GKLeaderboardPlayerScopeGlobal; break;
        case 1: mGKLeaderboardPlayerScope = GKLeaderboardPlayerScopeFriendsOnly; break;
    }
    
    GKLeaderboardTimeScope mGKLeaderboardTimeScope;
    switch((int) playerScope)
    {
        case 0: mGKLeaderboardTimeScope = GKLeaderboardTimeScopeToday; break;
        case 1: mGKLeaderboardTimeScope = GKLeaderboardTimeScopeWeek; break;
        case 2: mGKLeaderboardTimeScope = GKLeaderboardTimeScopeAllTime; break;
    }
    
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithLeaderboardID:leaderboardId playerScope:mGKLeaderboardPlayerScope timeScope:mGKLeaderboardTimeScope];
        if(gameCenterController == nil)
            return 0;
        
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    } else {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        
        gameCenterController.leaderboardIdentifier = leaderboardId;
        gameCenterController.leaderboardTimeScope = mGKLeaderboardTimeScope;
        
#ifndef GMGC_MACOS
        [g_controller presentViewController: gameCenterController animated: YES completion:nil];
#else
        [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
    }
    return 1;
}

////GKGameCenterControllerDelegate
//https://developer.apple.com/documentation/gamekit/gkgamecentercontrollerdelegate?language=objc
-(void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController;
{
#ifndef GMGC_MACOS
    [g_controller dismissViewControllerAnimated:YES completion:nil];
#else
    // ???????????????????
    [g_controller dismiss: gameCenterViewController];
#endif
    int dsMapIndex = CreateDsMap(0);
    dsMapAddString(dsMapIndex, "type", "GameCenter_PresentView_DidFinish");
    CreateAsynEventWithDSMap(dsMapIndex, EVENT_OTHER_SOCIAL);
}

////////////// GKLocalPlayer
//https://developer.apple.com/documentation/gamekit/gklocalplayer?language=objc
-(double) GameCenter_LocalPlayer_Authenticate
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler  = ^(
#ifndef GMGC_MACOS
        UIViewController *
#else
        NSViewController *
#endif
        viewController,
        NSError *error)
    {
        double success;
        if(error == nil)
            success = 1.0;
        else
        {
            success = 0.0;
            NSLog([error localizedDescription]);
        }
            
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type", "GameCenter_Authenticate");
        dsMapAddDouble(dsMapIndex, "success", success);
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);

        if(viewController != nil)
        {
#ifndef GMGC_MACOS
            [g_controller presentViewController: viewController animated:YES completion: NULL];
#else
            [g_controller presentViewControllerAsModalWindow: gameCenterController];
#endif
            [localPlayer registerListener: self];
        }
    };
    
    return 1;
}

//GameCenter_GKLocalPlayer_generateIdentityVerificationSignatureWithCompletionHandler()////NO YET
-(double) GameCenter_LocalPlayer_IsAuthenticated
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if(localPlayer.isAuthenticated)
        return 1;
    else
        return 0;
}

-(double) GameCenter_LocalPlayer_IsUnderage
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    if(localPlayer.isUnderage)
        return 1;
    else
        return 0;
}

-(double) GameCenter_LocalPlayer_IsMultiplayerGamingRestricted
{
    if (@available(iOS 13.0, macOS 10.15, *)) {
        GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
        if(localPlayer.isMultiplayerGamingRestricted)
            return 1;
        else
            return 0;
    }
    else {
        NSLog(@"GameCenter_LocalPlayer_IsMultiplayerGamingRestricted No Available Until iOS 13.0 or macOS 10.15");
        return 0;
    }
}

-(double) GameCenter_LocalPlayer_IsPersonalizedCommunicationRestricted
{
    if (@available(iOS 14.0, macOS 11.0, *)) {
        GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
        if(localPlayer.isPersonalizedCommunicationRestricted)
            return 1;
        else
            return 0;
    }
    else {
        NSLog(@"GameCenter_LocalPlayer_IsPersonalizedCommunicationRestricted No Available Until iOS 14.0 or macOS 11.0");
        return 0;
    }
}

-(NSString*) GameCenter_LocalPlayer_GetInfo
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    return([GameCenter GKPlayerJSON:localPlayer]);
}

-(double) GameCenter_SavedGames_Fetch
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    [localPlayer fetchSavedGamesWithCompletionHandler:^(NSArray<GKSavedGame *> * _Nullable savedGames, NSError * _Nullable error)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if(savedGames != nil)
        for(GKSavedGame *savedGame in savedGames)
            [array addObject:[GameCenter GKSavedGameDic: savedGame]];
        
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex,"type","GameCenter_SavedGames_Fetch");
        dsMapAddString(dsMapIndex,"slots",(char*)[[GameCenter toJSON: array] UTF8String]);
        if(error == nil)
            dsMapAddDouble(dsMapIndex,"success",1);
        else
        {
            dsMapAddDouble(dsMapIndex,"success",0);
            NSLog([error localizedDescription]);
        }
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

-(double) GameCenter_SavedGames_Save: (NSString*) name data: (NSString*) mNSData
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    [localPlayer saveGameData:[mNSData dataUsingEncoding:NSUTF8StringEncoding] withName:name completionHandler:^(GKSavedGame * _Nullable savedGame, NSError * _Nullable error)
    {
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_Save");
        dsMapAddString(dsMapIndex, "name",(char*)[name UTF8String]);
        dsMapAddString(dsMapIndex, "slot",(char*)[[GameCenter GKSavedGameJSON: savedGame]UTF8String]);
        if(error == nil)
            dsMapAddDouble(dsMapIndex, "success",1);
        else
        {
            dsMapAddDouble(dsMapIndex, "success",0);
            NSLog([error localizedDescription]);
        }
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

-(double) GameCenter_SavedGames_Delete: (NSString*) name
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    [localPlayer deleteSavedGamesWithName:name completionHandler:^(NSError * _Nullable error)
    {
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_Delete");
        dsMapAddString(dsMapIndex, "name",(char*)[name UTF8String]);
        if(error == nil)
            dsMapAddDouble(dsMapIndex, "success",1);
        else
        {
            dsMapAddDouble(dsMapIndex, "success",0);
            NSLog([error localizedDescription]);
        }
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

-(double) GameCenter_SavedGames_GetData: (NSString*) name
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    [localPlayer fetchSavedGamesWithCompletionHandler:^(NSArray<GKSavedGame *> * _Nullable savedGames, NSError * _Nullable error)
    {
        if(error != nil)
        {
            NSLog([error localizedDescription]);
            int dsMapIndex = CreateDsMap(0);
            dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_GetData");
            dsMapAddString(dsMapIndex, "name",(char*)[name UTF8String]);
            dsMapAddDouble(dsMapIndex, "success",0);
            CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
            return;
        }
                
        for(GKSavedGame *mGKSavedGame in savedGames)
        if([[mGKSavedGame name] isEqualToString:name])
        {
            [mGKSavedGame loadDataWithCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error)
            {
                int dsMapIndex = CreateDsMap(0);
                dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_GetData");
                dsMapAddString(dsMapIndex, "name",(char*)[name UTF8String]);
                if(error == nil && data != nil)
                {
                    dsMapAddDouble(dsMapIndex, "success",1);
                    
                    const void *_Nullable rawData = [data bytes];
                    if(rawData != nil)
                        dsMapAddString(dsMapIndex, "data",(char *)rawData);
                }
                else
                {
                    dsMapAddDouble(dsMapIndex, "success",0);
                    NSLog([error localizedDescription]);
                }
                CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
            }];
            break;
        }
    }];
    
    return 1;
}


-(double) GameCenter_SavedGames_ResolveConflict:(double) conflict_ind data:(NSString*) data
{
    GKLocalPlayer *localPlayer = GKLocalPlayer.localPlayer;
    [localPlayer resolveConflictingSavedGames:self.ArrayOfConflicts[(int)conflict_ind] withData:[data dataUsingEncoding:NSUTF8StringEncoding] completionHandler:^(NSArray<GKSavedGame *> * _Nullable savedGames, NSError * _Nullable error)
    {
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_ResolveConflict");
        dsMapAddDouble(dsMapIndex, "conflict_ind",conflict_ind);
        if(error == nil)
            dsMapAddDouble(dsMapIndex, "success",1);
        else
        {
            dsMapAddDouble(dsMapIndex, "success",0);
            NSLog([error localizedDescription]);
        }
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

///////////GKSavedGameListener
//https://developer.apple.com/documentation/gamekit/gksavedgamelistener?language=objc

- (void)player:(GKPlayer *)player hasConflictingSavedGames:(NSArray<GKSavedGame *> *)savedGames
{
    double conflict_ind = self.ArrayOfConflicts.count;
    [self.ArrayOfConflicts addObject: savedGames];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(GKSavedGame *savedGame in savedGames)
        [array addObject:[GameCenter GKSavedGameJSON: savedGame]];
    
    int dsMapIndex = CreateDsMap(0);
    dsMapAddString(dsMapIndex, "type","GameCenter_SavedGames_HasConflict");
    dsMapAddDouble(dsMapIndex, "conflict_ind",conflict_ind);
    dsMapAddString(dsMapIndex, "slots",(char*)[[GameCenter toJSON: array] UTF8String]);
    CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
}

- (void)player:(GKPlayer *)player didModifySavedGame:(GKSavedGame *)savedGame;
{
    int dsMapIndex = CreateDsMap(0);
    dsMapAddString(dsMapIndex, "type", "GameCenter_SavedGames_DidModify");
    dsMapAddString(dsMapIndex, "player", (char*)[[GameCenter GKPlayerJSON:player] UTF8String]);
    dsMapAddString(dsMapIndex, "slot", (char*)[[GameCenter GKSavedGameJSON:savedGame] UTF8String]);
    CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
}

////////////////// GKBasePlayer
//https://developer.apple.com/documentation/gamekit/gkbaseplayer?language=objc
+(NSString*) GKSavedGameJSON: (GKSavedGame*) mGKSavedGame
{
    NSDictionary *dic = [GameCenter GKSavedGameDic: mGKSavedGame];
    return [GameCenter toJSON:dic];
}

+(NSDictionary*) GKSavedGameDic: (GKSavedGame*) mGKSavedGame
{
    NSDictionary *mNSDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      [mGKSavedGame deviceName], @"deviceName",
                      [NSNumber numberWithDouble:[[mGKSavedGame modificationDate] timeIntervalSince1970]], @"modificationDate",
                      [mGKSavedGame name], @"name",
                      nil];
    
    return mNSDictionary;
}

//GKScore
//https://developer.apple.com/documentation/gamekit/gkscore?language=objc
-(double) GameCenter_Leaderboard_Submit: (NSString*) leaderboardID score: (double) score
{
    GKScore *mGKScore = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    mGKScore.value = score;
    [GKScore reportScores: @[mGKScore] withCompletionHandler:^(NSError * _Nullable error)
    {
        double success;
        if(error == nil)
            success = 1.0;
        else
        {
            success = 0.0;
            NSLog([error localizedDescription]);
        }
        
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type", "GameCenter_Leaderboard_Submit");
        dsMapAddDouble(dsMapIndex, "success", success);
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

//GKAchievement
//https://developer.apple.com/documentation/gamekit/gkachievement?language=objc
-(double) GameCenter_Achievement_Report: (NSString*) identifier percentComplete: (double) percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    achievement.showsCompletionBanner = TRUE;
    
    achievement.percentComplete = (float) percent;
    [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error)
    {
         double success;
         if (error == nil)
             success = 1;
         else
         {
             success = 0;
             NSLog([error localizedDescription]);
         }
         
         int dsMapIndex = CreateDsMap(0);
         dsMapAddString(dsMapIndex, "type", "GameCenter_Achievement_Report");
         dsMapAddDouble(dsMapIndex, "success", success);
         CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
    }];
    
    return 1;
}

-(double) GameCenter_Achievement_ResetAll
{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError * _Nullable error)
    {
        double success;
        if (error == nil)
            success = 1;
        else
        {
            success = 0;
            NSLog([error localizedDescription]);
        }
        
        int dsMapIndex = CreateDsMap(0);
        dsMapAddString(dsMapIndex, "type", "GameCenter_Achievement_ResetAll");
        dsMapAddDouble(dsMapIndex, "success", success);
        CreateAsynEventWithDSMap(dsMapIndex,EVENT_OTHER_SOCIAL);
        
    }];
    
    return 1;
}

////////////////// GKPlayer
//https://developer.apple.com/documentation/gamekit/gkplayer?language=objc
+(NSString*) GKPlayerJSON: (GKPlayer*) mGKPlayer
{
    NSDictionary *mNSDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [mGKPlayer alias], @"alias",
                                   [mGKPlayer displayName], @"displayName",
                                   [mGKPlayer playerID], @"playerID",
//                                   [self GKBasePlayerJSON: mGKPlayer], @"GKBasePlayer",
                                   nil];
    return [GameCenter toJSON:mNSDictionary];
}

/////////TOOLS

+(NSString*) toJSON:(id) obj
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                           options:0//NSJSONWritingPrettyPrinted
                                                             error:&error];
    if(error == nil)
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    else
        return @"{}";
}

@end

