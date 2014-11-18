<h1 align="center">RRMessageController</h1>

RRMessageController is a UIViewController, allows you to write a message with photos as attachment.
A messages UI for iPhone. Support text && image.

<p align="center">
  <img src ="https://raw.githubusercontent.com/remirobert/RRMessageController/master/ressources/record.gif"/>
</p>

<h3 align="center">Usage</h3>
<hr>
<p align="center">With block :</p>
```Objective-C
- (void) newMessage {
    RRSendMessageViewController *controller = [[RRSendMessageViewController alloc] init];
    
    [controller presentController:self :^(RRMessageModel *model, BOOL isCancel) {
        if (isCancel == true) {
            self.message.text = @"";
        }
        else {
            self.message.text = model.text;
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
}
```
<hr>
<p align="center">With delegate :</p>

```Objective-C
#pragma mark RRSendMessageController Delegate

- (void) messageCancel {
    [self.controllerMessage dismissViewControllerAnimated:YES completion:nil];
}

- (void) getMessage:(RRMessageModel *)message {
    self.message.text = message.text;
    [self.controllerMessage dismissViewControllerAnimated:YES completion:nil];
}

- (void) newMessage {
    [self presentViewController:self.controllerMessage animated:YES completion:nil];
}

- (void) initMessageController {
    self.controllerMessage = [[RRSendMessageViewController alloc] init];
    self.controllerMessage.delegate = self;
}
```
