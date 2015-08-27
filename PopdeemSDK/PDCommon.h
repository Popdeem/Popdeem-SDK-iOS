//
//  PDCommon.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#ifndef PopdeemSDK_PDCommon_h
#define PopdeemSDK_PDCommon_h

struct PDGeoLocation {
    float latitude;
    float longitude;
};
typedef struct PDGeoLocation PDGeoLocation;

static PDGeoLocation PDGeoLocationMake(float lati, float longi) {
    PDGeoLocation loc;
    loc.latitude = lati;
    loc.longitude = longi;
    return loc;
}

//For JSON parsing, check for Null Class
static BOOL isNilClass(id item) {
    return [item isKindOfClass:[NSNull class]];
}

#endif
