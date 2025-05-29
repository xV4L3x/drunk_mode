#import "PSSpecifier.h"
#import "PSUIPrefsListController.h"
#import "dlfcn.h"
#import <AudioToolBox/AudioToolBox.h>
#import <AudioToolBox/AudioServices.h>

#define PreferencesPlist @"/var/mobile/Library/Preferences/me.qusic.drunkmode.plist"
#define DrunkModeKey @"DrunkMode"
#define Debugger() { kill( getpid(), SIGINT ) ; }

NSString *const alertTitle = @"You are drunk";
NSString *const alertBody = @"Go home";
NSString *const alertSubTitle = @"Whaat?";
NSMutableDictionary *riddles = [[NSMutableDictionary alloc] init];

static BOOL getDrunkMode()
{
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PreferencesPlist];
    return [[preferences objectForKey:DrunkModeKey]boolValue];
}

static void setDrunkMode(BOOL value)
{
    NSMutableDictionary *preferences = [NSMutableDictionary dictionary];
    [preferences addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PreferencesPlist]];
    [preferences setObject:[NSNumber numberWithBool:value] forKey:DrunkModeKey];
    [preferences writeToFile:PreferencesPlist atomically:YES];
}

%group Hooks


//MESSAGES
%hook CKChatController
-(void)messageEntryViewSendButtonHit:(id)messageEntryView {
    if (getDrunkMode()) 
    {
        //DisplayAlert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertSubTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertSubTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    } 
    else 
    {
        %orig();
    }
}
%end

//WHATSAPP
%hook WAChatBar
-(void)sendButtonTapped:(id)arg1
{
    if (getDrunkMode()) 
    {
        //DisplayAlert
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(alertSubTitle,@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) 
        {
           topWindow.hidden = YES; 
        }]];
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    else
    {
        %orig;
    }
}
%end

//INSTAGRAM
%hook IGDirectComposer
-(void)_didTapSend:(id)arg1
{
     if (getDrunkMode()) 
     {
        //DisplayAlert
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertBody preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(alertSubTitle,@"confirm") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) 
        {
           topWindow.hidden = YES; 
        }]];
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        return;
     }
     else
     {
        %orig;
     }
}
%end



%hook PSUIPrefsListController

-(void)reloadSpecifiers
{
    return %orig;
};
-(NSMutableArray *) specifiers 
{
    NSMutableArray *specifiers = %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Drunk Mode" target:self set:@selector(setDrunkMode:specifier:) get:@selector(getDrunkMode:) detail:Nil cell:PSSwitchCell edit:Nil];
        [specifier setIdentifier:DrunkModeKey];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"alternateColors"];
        [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/Application Support/DrunkMode/DrunkMode.png"] forKey:@"iconImage"];
        [specifier setProperty:@"Settings-DrunkMode" forKey:@"iconCache"];
        [specifiers insertObject:specifier atIndex:3];
    });
    return specifiers;
}

%new -(id)getDrunkMode:(PSSpecifier*)specifier 
{
    //Get Drunk mode for Settings cell
    return [NSNumber numberWithBool:getDrunkMode()];
}

%new -(void)setDrunkMode:(id)value specifier:(PSSpecifier *) specifier 
{
   if (getDrunkMode())
   {
       //Set Riddles
       [riddles setObject: @"326+987"  forKey: @"1313"];
       [riddles setObject: @"412+325"  forKey: @"737"];
       [riddles setObject: @"199+566"  forKey: @"765"];
       [riddles setObject: @"458+541"  forKey: @"999"];

       //Get all solutions into an array
       NSArray *array = [riddles allKeys];
       //Select a number between 0 and the number of riddles
       int random = arc4random()%[array count];
       //Get the solution by the index of the random number
       NSString *solutionValue = [array objectAtIndex:random];
       //Get the riddle by the random key
       NSString *riddleValue = [riddles objectForKey:solutionValue];

       //Display the check alert
       UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Are you really sober?\nProve it solving this" message:riddleValue preferredStyle:UIAlertControllerStyleAlert];
       //Put an entry inside the alert
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) 
       {
           textField.placeholder = @"Solution";
           textField.clearButtonMode = UITextFieldViewModeWhileEditing;
           textField.borderStyle = UITextBorderStyleRoundedRect;
       }];
       //Add the button with its action to the alert
       [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) 
       {
           //Get all fields from the alert
           NSArray * textfields = alertController.textFields;
           //Get the text from the only field
           UITextField * solutionField = textfields[0];
           //Convert solution and input text to int value because the if condition wont work with NSStrings
           int solution = [solutionValue intValue];
           int response = [solutionField.text intValue];

           //Check user answered correctly
           if (response == solution)
           {  
               //Disable Drunk Mode
               setDrunkMode([value boolValue]);
           }
           else
           {
               //Vibrate Device
               AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
               //Display alert to tell him that the answer is wrong
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"WRONG" message:nil preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertSubTitle style:UIAlertActionStyleDefault handler:nil];
               [alertController addAction:actionOk];
               //Display alert
               [self presentViewController:alertController animated:YES completion:nil];
               //Switch On
               [self reloadSpecifierAtIndex:3];
           }
       }]];
       //Display alert
       [self presentViewController:alertController animated:YES completion:nil];
   }
   else
   {
       //Enable Drunk Mode
       setDrunkMode([value boolValue]);
   }
}
%end

//End Group Hooks
%end

//Init Frameworks
%ctor 
{
dlopen([[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Frameworks/InstagramAppCoreFramework.framework/InstagramAppCoreFramework"] UTF8String], RTLD_NOW);
    %init(Hooks);
}