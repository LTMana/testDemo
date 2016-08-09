//
//  WnsErrorCode.h
//  WnsSDK
//
//  Created by best1a on 3/31/15.
//
//

#ifndef WnsSDK_WnsErrorCode_h
#define WnsSDK_WnsErrorCode_h

typedef NS_ENUM(NSInteger, WnsSDKResult) {
    WnsSDKResultSuccess         = 0,
    WnsSDKResultParam           = 1,
    WnsSDKResultConnectFail     = 2,
    WnsSDKResultConnectTimeout  = 3,
    WnsSDKResultSendFail        = 4,
    WnsSDKResultSendTimeout     = 5,
    WnsSDKResultRecvFail        = 6,
    WnsSDKResultRecvTimeout     = 7,
    WnsSDKResultPackFail        = 8,
    WnsSDKResultUnpackFail      = 9,
    WnsSDKResultOther           = 10,
    WnsSDKResultServer          = 11,
    WnsSDKResultRequestCanceled = 12,
    WnsSDKResultInTestMode      = 13,
    WnsSDKResultNoAppRoute      = 10000,
    WnsSDKResultAppTimeout      = 10001,
    WnsSDKResultAppShutdown     = 10002,
    WnsSDKResultAppDecodeFail   = 10003,
    WnsSDKResultSdkVerifyFail   = 10100,
    WnsSDKResultCmdInvalid      = 10101,
    WnsSDKResultNoCmd           = 10102,
};
#endif
