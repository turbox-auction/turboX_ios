//#define BaseURL @"http://auction.wheelslot.com/index.php/webserviceV2/"
//#define BaseURL @"http://demo.wheelslot.com/auction/index.php/webserviceV2/"

#import "AppDelegate.h"

//#ifdef myGlobal
//#define MAIN_URL @"http://www.turbox.ca/" //Live
//#else
//#define MAIN_URL @"http://dev.turbox.ca/" //Test
//#endif


//#define BaseURL @"http://www.turbox.ca/index.php/webserviceV2/" //turbox URL
#define BaseURL [NSString stringWithFormat:@"%@index.php/webserviceV2/", [AppDelegate getBaseURL]]
#define SIGNUP_URL [NSString stringWithFormat:@"%@signup/signupService.php", [AppDelegate getBaseURL]]


#define REALSELLAUCTION [NSString stringWithFormat:@"%@index.php/AuctionOverNotify/directWinner", [AppDelegate getBaseURL]]
#define SIGINUP_WEB   [NSString stringWithFormat:@"%@signup", [AppDelegate getBaseURL]] //@"http://www.turbox.ca/signup/"

#define LOGIN           @"login"
#define FORGOTPASSWORD  @"forgotPassword"
#define VINDETAIL       @"vinDetail"
#define SAVE_FEATURES   @"createAuctionFeatures"
#define SAVE_SUMMARY    @"createAuctionSummary"
#define SAVE_HIGHLIGHTS @"createHighlights"
#define SAVE_DISCLOSURE @"createAuctionDisclosure"
#define ACTIVITY        @"activity"
#define MY_BID          @"myBid"
#define MY_LISTING      @"myListing"
#define INVOICES        @"invoices"
#define DOCUMENTS       @"documents"
#define UPLOAD_MEDIA    @"uploadMedia"
#define VEHICLE_DETAILS @"vehicleDetailSummary"
#define ADDFAVORITE     @"addFavourites" 
#define REMOVEFAVORITE  @"removeFavourites"
#define BID_HISTORY     @"vehicleBidHistory"
#define SAVE_PROFILE    @"saveProfile"
#define CREATE_BID      @"createBid"
#define BUY_FAVOURITE   @"buyFavourites"
#define FEEDBACK        @"feedback"
#define APNS_REG        @"apnsRegId"
#define CREATEAUTOBID   @"createAutoBid"
#define PARKAUCTION     @"declinedVehicle"
#define SELLAUCTION     @"extendAuction"
#define DELETEAUCTION   @"deleteAuction"
#define MARKINSTOCK     @"markVehicleInstock"
#define MARKDELIVERED   @"deliveredVehicle"
#define REMOVEDVEHICLES @"buyRemoved"
#define DELETEIMAGE     @"deleteInventoryImage"
#define SCHEDULE_NOW    @"schedule_now"
#define PARK_NOW        @"park_now"


#define setObjectInUserDefaults(key, obj)\
[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];\
[[NSUserDefaults standardUserDefaults]synchronize];

#define getObjectFromUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];
#define CheckNilString(str) str==nil?@"":str

#define PUSHER_API_KEY @"48a7b883e935f7ea9e4c"
#define PUSHER_API_SECRET @"1cc8c0695151935ad768"
#define PUSHER_APP_ID @"42541"

#ifdef __OBJC__

#import "AppDelegate.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#endif
