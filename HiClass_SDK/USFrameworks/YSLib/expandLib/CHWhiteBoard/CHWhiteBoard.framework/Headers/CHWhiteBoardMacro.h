//
//  CHWhiteBoardMacro.h
//  CHWhiteBoard
//
//

#ifndef CHWhiteBoardMacro_h
#define CHWhiteBoardMacro_h

#define WBHaveSmallBalckBoard       1

#define CHTopBarHeight 30.0f

#define CHWBBUNDLE_SHORTNAME    @"CHWhiteBoardResources"
#define CHWBBUNDLE_NAME         @"CHWhiteBoardResources.bundle"
#define CHWBBUNDLE              [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:CHWBBUNDLE_NAME]]
#define CHWBLocalized(s)        [CHWBBUNDLE localizedStringForKey:s value:@"" table:nil]

#define CHLocalUser             [CHSessionManager sharedInstance].localUser


#endif /* CHWhiteBoardMacro_h */
