#include <stdio.h>
#include <syslog.h>
#include <string.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <objc/objc-class.h>
#include <Foundation/Foundation.h>

bool logging = true; // hooks verbose logging

// silence gcc
@interface ZoomSDKHax: NSObject
@end

@implementation ZoomSDKHax : NSObject

+(bool)isSupportSmartVirtualBackground {
    return YES;
}

+(void)infoLog:(NSString*)log {
    NSLog(@"%@",log);
}

@end

// ---------------------------------------------------------------------

void iHookMethod(Class class, SEL selector) {
    Method originalMeth = class_getInstanceMethod(class,selector);
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"ZoomSDKHax"),selector);
    method_exchangeImplementations(originalMeth, replacementMeth);
}

void iHookMethodTarget(Class class, SEL selector, SEL target) {
    Method originalMeth = class_getInstanceMethod(class,selector);
    Method replacementMeth = class_getInstanceMethod(NSClassFromString(@"ZoomSDKHax"),target);
    method_exchangeImplementations(originalMeth, replacementMeth);
}

void cHookMethod(Class class, SEL selector) {
    Method originalMeth = class_getClassMethod(class,selector);
    Method replacementMeth = class_getClassMethod(NSClassFromString(@"ZoomSDKHax"),selector);
    method_exchangeImplementations(originalMeth, replacementMeth);
}

void patch() {
    printf("[+] Patching methods...\n");

    if (logging == true) {
        cHookMethod(NSClassFromString(@"ZPPTLogHelperImp"), @selector(infoLog:));
    }
    cHookMethod(NSClassFromString(@"ZMVirtualBackgroundMgr"), @selector(isSupportSmartVirtualBackground));

    printf("[-] Done!");
}

__attribute__((constructor))
static void ctor(int argc, const char **argv)
 {
    if (strcmp(getprogname(), "RingCentral") == 0) {
        printf("[-] Detected RC process.\n");
        void* framework = dlopen("../Frameworks/ZoomSDKChatUI.framework/Versions/A/ZoomSDKChatUI", RTLD_LAZY);

        if(framework == NULL) {
            printf("[!] Error: failed to open ZoomSDKChatUI.\n");
            exit(1);
        } else {
            printf("[-] Opened ZoomSDKChatUI @ %p\n",framework);
        }

        patch();
    }
}