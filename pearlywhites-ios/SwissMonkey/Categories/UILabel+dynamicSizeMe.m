#import "UILabel+dynamicSizeMe.h"

@implementation UILabel (dynamicSizeMe)

-(float)resizeToFit{
    float height = [self expectedHeight];
    CGRect newFrame = [self frame];
    newFrame.size.height = height;
    [self setFrame:newFrame];
    return newFrame.origin.y + newFrame.size.height;
}

-(float)expectedHeight{
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];

    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width,MAXFLOAT);
    
//    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font] 
//                                            constrainedToSize:maximumLabelSize
//                                            lineBreakMode:[self lineBreakMode]];
//    CGRect textRect = [[self text] boundingRectWithSize:maximumLabelSize
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{NSFontAttributeName:FONT}
//                                         context:nil];
//    UILabel *gettingSizeLabel = [[UILabel alloc] init];
//    gettingSizeLabel.font = [UIFont fontWithName:[AppHandlers zHandler].fontName size:16]; // Your Font-style whatever you want to use.
//    gettingSizeLabel.text = @"YOUR TEXT HERE";
   // gettingSizeLabel.numberOfLines = 0;
    //CGSize maximumLabelSize = CGSizeMake(310, 9999); // this width will be as per your requirement
    
    CGSize expectedSize = [self sizeThatFits:maximumLabelSize];
    return expectedSize.height;
}

@end
