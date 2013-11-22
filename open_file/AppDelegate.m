//
//  AppDelegate.m
//  open_file
//
//  Created by Eduard Litau on 22.11.13.
//  Copyright (c) 2013 Eduard Litau. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //create content - four lines of text
//    NSString *content = @"One\nTwo\nThree\nFoursssss";
//    [self writeToTextFile:content];
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em
     setEventHandler:self
     andSelector:@selector(getUrl:withReplyEvent:)
     forEventClass:kInternetEventClass
     andEventID:kAEGetURL];
    
//    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
//    NSString *combined = [arguments componentsJoinedByString:@","];
//    NSString *path = [self getPathFromUri:combined];
//    [self writeToTextFile:path];
    
//    Test with fixed url
//    NSString *filePath = @"open?url=file:///etc/profile";
//    [self openInSublime:filePath];
}
    
- (void)getUrl:(NSAppleEventDescriptor *)event
withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    // Get the URL
    NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject]
                        stringValue];

    [self openInSublime:urlStr];
    //TODO: Your custom URL handling code here
}
    
    
-(void) openInSublime:(NSString *)uriFromLink
{
//    NSString *filePath = @"/Volumes/simfy/code/spec/mailers/error_mailer_spec.rb";
    //get the documents directory:
//    NSArray *paths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    //make a file name to write the data to using the documents directory:
//    NSString *fileNameUrl = [NSString stringWithFormat:@"%@/urlFull.txt",
//                             documentsDirectory];
//    NSString *fileNamePath = [NSString stringWithFormat:@"%@/urlPath.txt",
//                              documentsDirectory];

    NSString *filePath = [self getPathFromUri:uriFromLink];

//    NSArray *argsUrl = [NSArray arrayWithObjects:uriFromLink, fileNameUrl, nil];
//    [self writeToTextFile:argsUrl];
    
//    NSArray *argsPath = [NSArray arrayWithObjects:filePath, fileNamePath, nil];
//    [self writeToTextFile:argsPath];
    
    [self executeInShell:filePath];
}
    
-(void) executeInShell:(NSString *)argument
{
    NSString *path = @"/usr/local/bin/subl";
    NSArray *args = [NSArray arrayWithObjects:argument, nil];
    [NSTask launchedTaskWithLaunchPath:path arguments:args];

}
    
-(NSString *) getPathFromUri:(NSString *)uri
{
    NSArray *lines = [uri componentsSeparatedByString: @"=file://"];
    NSInteger size = [lines count];
    NSString *filePath = nil;
    if (size > 0) {
         filePath = lines[1];
    } else {
         filePath = @"/Volumes/simfy/code/spec/mailers/error_mailer_spec.rb";
    }
   
    return filePath;
}

    //Method writes a string to a text file
-(void) writeToTextFile:(NSArray *)stringAndPath
    {
        
        NSString *content = stringAndPath[0];
        NSString *fileName = stringAndPath[1];
        //create content - four lines of text
        //    NSString *content = @"One\nTwo\nThree\nFour\nFive";
        //save content to the documents directory
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
        
    }
@end
