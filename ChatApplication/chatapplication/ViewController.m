//
//  ViewController.m
//  ChatApplication
//
//  Created by Vishwan Aranha on 8/17/13.
//  Copyright © 2013 Vishwan Aranha. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MCSessionDelegate, MCBrowserViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>  {
    NSMutableArray *messageArray;
}
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *messagetxtField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMultipeer];
    
    messageArray = [[NSMutableArray alloc] init];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView
                        *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [messageArray objectAtIndex:indexPath.row];
    return cell;
    
}

- (void) setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chatApp" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chatApp" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}

- (IBAction)sendMessage:(id)sender {
    
    NSString *strMessage = self.messagetxtField.text;
    
    NSData *data = [strMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
    

    
}


- (IBAction)connectDevies:(id)sender {
     [self presentViewController:self.browserVC animated:YES completion:nil];
}

#pragma mark - BrowserViewController Delegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCSessionDelegate Delegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    

     dispatch_async(dispatch_get_main_queue(), ^{
         
        if(state == MCSessionStateConnected) {
            NSLog(@"Connected");
            self.connectBtn.hidden = YES;
            self.chatView.hidden = NO;
        }
         
         if(state == MCSessionStateNotConnected) {
             NSLog(@"Connected");
             if([session connectedPeers].count <2){
                              self.connectBtn.hidden = NO;
                              self.chatView.hidden = YES;

             }
//             self.connectBtn.hidden = YES;
//             self.chatView.hidden = NO;
         }
         
         
         });
    
}



// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *messageString = [NSString stringWithFormat:@"%@: %@",peerID.displayName,str];
        
        [messageArray addObject:messageString];
        [self.myTableView reloadData];
    });
    
    
    //    [self receiveMessage:message fromPeer:peerID];
}


























@end
