//
//  BIDViewController.m
//  Twitter Client
//
//  Created by user on 5/29/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "BIDViewController.h"
#import "BIDTweetCell.h"
#import "BIDUser.h"
#import "BIDTweet.h"
#import "BIDUtils.h"
#import "BIDImageCache.h"

#define kCellDefautHeight 120
#define kCellWithPictureHeight 280
#define kCellLoadMoreHeight 46

static NSString *CellIdentifier = @"TweetCell";
static NSString *LoadMoreCellIdentifier = @"LoadCell";

@interface BIDViewController () {
    ACAccount *twitterAccount;
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation BIDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.table.rowHeight = kCellDefautHeight;
    
    self.users = [NSMutableDictionary dictionary];
    
    UINib *nib = [UINib nibWithNibName:@"BIDTweetCell" bundle:nil];
    [self.table registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    UINib *loadMoreNib = [UINib nibWithNibName:@"BIDLoadMoreCell" bundle:nil];
    [self.table registerNib:loadMoreNib forCellReuseIdentifier:LoadMoreCellIdentifier];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:_refreshControl];
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 twitterAccount = [arrayOfAccounts lastObject];
                 [self getTimeLine];
                 
             }
         }
     }];
    
    UIEdgeInsets contentInset = self.table.contentInset;
    contentInset.top = 5;
    [self.table setContentInset:contentInset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void) refresh: (UIRefreshControl *)refreshControl {
    [self refreshTweets];
    
}
- (IBAction)compose:(UIBarButtonItem *)sender {
    [self showTweetSheet];
}

- (void)getTimeLine {

     [BIDUtils requestTimeline:twitterAccount withBlock:^(NSArray * data) {
         if (data.count != 0) {
             self.dataSource = [[NSArray alloc] initWithArray: [self createTweetsAndAddNewUsers:data]];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.table reloadData];
                 [UIView animateWithDuration:0.3 animations:^{
                     self.table.alpha = 1.0;
                 }];
                 [self.loadingIndicator stopAnimating];
             });
         }
     }];
}

- (void)loadMoreTweets {
    
    [BIDUtils requestTimeline:twitterAccount afterTweet:self.dataSource[self.dataSource.count-1] withBlock:^(NSArray * data) {
        if (data.count != 0) {
            NSMutableArray *tweets = [NSMutableArray arrayWithArray:self.dataSource];
            [tweets addObjectsFromArray:[self createTweetsAndAddNewUsers:data]];
            
            self.dataSource = [[NSArray alloc] initWithArray:tweets];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
            });
        }
    }];
}

- (void)refreshTweets {
    
    [BIDUtils requestTimeline:twitterAccount sinceTweet:self.dataSource[0] withBlock:^(NSArray * data) {
        if (data.count != 0) {
            NSMutableArray *tweets = [self createTweetsAndAddNewUsers:data];
            
            [tweets addObjectsFromArray:self.dataSource];
            
            self.dataSource = [[NSArray alloc] initWithArray:tweets];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.table reloadData];
                [_refreshControl endRefreshing];
            });
        } else {
            [_refreshControl endRefreshing];
        }
    }];
}

- (NSMutableArray *) createTweetsAndAddNewUsers: (NSArray *) data {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (int i = 0; i < data.count; i++) {
        BIDTweet  *tweet = [[BIDTweet alloc] initFromDictionary:data[i]];
        
        BIDUser *user = self.users[tweet.userId];
        if (user == nil) {
            user = [[BIDUser alloc] initFromDictionary:data[i]];
            [self.users setObject:user forKey:tweet.userId];
        }
        
        tweet.user = user;
        
        [tweets addObject: tweet];
    }
    return tweets;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showTweetSheet
{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];

    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    [tweetSheet setInitialText:@"just setting up my twttr"];
    
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataSource.count == 0) {
        return 0;
    }
    
    return _dataSource.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] < _dataSource.count) {
        BIDTweetCell *cell = [self.table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        BIDTweet *tweet = self.dataSource[[indexPath row]];
        BIDUser *user = tweet.user;
    
        cell.userName = user.userName;
        cell.tweetText = tweet.text;
        
        [cell setPhotoImage: nil withAnimation:NO];
        
        [[BIDImageCache sharedCache] loadImageFromURL:tweet.mediaUrl withBlock:^(UIImage * image, BOOL fromMemory) {
            UIImage *resizedImage = [BIDUtils imageWithImage:image scaledToSize:CGSizeMake(315, 160)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               [cell setPhotoImage: resizedImage withAnimation: !fromMemory];
            });
        }];
    
        [cell setUserImage: user.picture];
        
        return cell;
    } else {
        UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
        [self loadMoreTweets];
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] < _dataSource.count) {
        BIDTweet *tweet = self.dataSource[[indexPath row]];
        
        if (tweet.mediaUrl != nil) {
            return kCellWithPictureHeight;
        } else {
            return kCellDefautHeight;
        }
    }
    
    return kCellLoadMoreHeight;
}


@end
