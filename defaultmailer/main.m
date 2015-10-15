//
//  main.m
//  defaultmailer
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        // we're interested in things which can handle http/https
        NSArray *urlschemerefs = [[NSArray alloc] initWithObjects:@"mailto", nil];
        
        // lets figure out which handlers are available
        NSArray *HTTPHandlers = (__bridge NSArray *) LSCopyAllHandlersForURLScheme(
                                                                                   (__bridge CFStringRef)([urlschemerefs objectAtIndex:0]));
        NSMutableDictionary *handlers = [NSMutableDictionary dictionary];
        for (int i = 0; i < [HTTPHandlers count]; i++) {
            NSString *split = [HTTPHandlers objectAtIndex:i];
            NSArray *parts = [split componentsSeparatedByString:@"."];
            [handlers setObject:split  forKey:[[parts lastObject] lowercaseString]];
        }
        
        // what is our current handler?
        NSString *currentHandler = (__bridge NSString *) LSCopyDefaultHandlerForURLScheme(
                                                                                          (__bridge CFStringRef)([urlschemerefs objectAtIndex:0]));
        
        currentHandler = [[currentHandler componentsSeparatedByString:@"."] lastObject];
        
        // handler command line -set argument
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        NSString *set = [args stringForKey:@"set"];
        NSString *status = [args stringForKey:@"status"];
        
        if ([[status lowercaseString]  isEqual: @"available"] ) {
            //list current available handlers
            for (NSString *key in handlers) {
                printf("%s\n", [key cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            return 0;
        } else if ([[status lowercaseString]  isEqual: @"current"] ) {
            //output current default mailer name
            printf("%s\n", [currentHandler cStringUsingEncoding:NSUTF8StringEncoding]);
            return 0;
        } else if (set == nil) {
            //assume default output
            printf("Current: %s\n\n", [currentHandler cStringUsingEncoding:NSUTF8StringEncoding]);
            printf("Use -set <mailer> to set a new default mailto: handler\n");
        } else {
            // set a new default
            if ([handlers valueForKey:[set lowercaseString]] != nil) {
                CFStringRef newHandler = (__bridge CFStringRef)([handlers valueForKey:[set lowercaseString]]);
                for (NSString *urlschemeref in urlschemerefs) {
                    LSSetDefaultHandlerForURLScheme((__bridge CFStringRef)(urlschemeref), newHandler);
                }
            } else {
                printf("%s is not available as a mailer (mailto:)\n", [set cStringUsingEncoding:NSUTF8StringEncoding]);
                printf("Available mailers:\n");
                for (NSString *key in handlers) {
                    printf("- %s\n", [key cStringUsingEncoding:NSUTF8StringEncoding]);
                }
                return 1;
            }
        }
    }
    return 0;
}

