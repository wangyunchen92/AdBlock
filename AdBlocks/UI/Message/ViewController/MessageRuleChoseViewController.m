//
//  MessageRuleChoseViewController.m
//  MessageJudge
//
//  Created by GeXiao on 12/06/2017.
//  Copyright © 2017 GeXiao. All rights reserved.
//

#import "MessageRuleChoseViewController.h"
#import "MessageGroup.h"
#import "MessageManage.h"

NSString *const MJTargetSenderCheckTag = @"MJTargetSenderCheckTag";
NSString *const MJTargetContentCheckTag = @"MJTargetContentCheckTag";

NSString *const MJTypeHasPrefixCheckTag = @"MJTypeHasPrefixCheckTag";
NSString *const MJTypeHasSuffixCheckTag = @"MJTypeHasSuffixCheckTag";
NSString *const MJTypeContainsCheckTag = @"MJTypeContainsCheckTag";
NSString *const MJTypeNotContainsCheckTag = @"MJTypeNotContainsCheckTag";
NSString *const MJTypeContainsRegexCheckTag = @"MJTypeContainsRegexCheckTag";

NSString *const MJKeywordTextInputTag = @"MJKeywordTextInputTag";

@interface MessageRuleChoseViewController ()
@property (nonatomic, strong)MessageRule *condRule;

@end

@implementation MessageRuleChoseViewController

- (instancetype)initWithCondition:(MessageRule *)condition {
    self = [super init];
    if (self) {
        self.condRule = [[MessageRule alloc] init];
        self.condRule.ruleType = condition.ruleType;
        self.condRule.ruleTarget = condition.ruleTarget;
        self.condRule.keyword = condition.keyword;
        _condition = condition;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.title = @"条件配置";
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
     self.navigationController.navigationBarHidden = YES;
}

- (void)initUI {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptorWithTitle:@"条件配置"];
    
    XLFormSectionDescriptor *targetSection = [XLFormSectionDescriptor formSectionWithTitle:@"目标"];
    targetSection.footerTitle = @"选择信息发送者或信息内容作为将要匹配的对象。";
    
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTargetSenderCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"目标"];
    row.value = @(self.condRule.ruleTarget == MERuleTargetSender);
    [targetSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTargetContentCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"内容"];
    row.value = @(self.condRule.ruleTarget == MERuleTargetConternt);
    [targetSection addFormRow:row];
    [form addFormSection:targetSection];
    
    XLFormSectionDescriptor *typeSection = [XLFormSectionDescriptor formSectionWithTitle:@"模式"];
    typeSection.footerTitle = @"选择一个匹配模式。";
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTypeHasPrefixCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"含有前缀"];
    row.value = @(self.condRule.ruleType == MERuleTypeHasPrefix);
    [typeSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTypeHasSuffixCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"含有后缀"];
    row.value = @(self.condRule.ruleType == MERuleTypeHasSuffix);
    [typeSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTypeContainsCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"包含"];
    row.value = @(self.condRule.ruleType == MERuleTypeContains);
    [typeSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTypeNotContainsCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"不包含"];
    row.value = @(self.condRule.ruleType == MERuleTypeNoContains);
    [typeSection addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:MJTypeContainsRegexCheckTag rowType:XLFormRowDescriptorTypeBooleanCheck title:@"正则表达"];
    row.value = @(self.condRule.ruleType == MERuleTypeContainsRegex);
    [typeSection addFormRow:row];
    [form addFormSection:typeSection];
    
    XLFormSectionDescriptor *keywordSection = [XLFormSectionDescriptor formSectionWithTitle:@"关键字"];
    XLFormRowDescriptor *keywordRow = [XLFormRowDescriptor formRowDescriptorWithTag:MJKeywordTextInputTag rowType:XLFormRowDescriptorTypeText title:nil];
    keywordRow.value = self.condRule.keyword;
    [keywordRow.cellConfigAtConfigure setObject:@"必填" forKey:@"textField.placeholder"];
    keywordRow.required = YES;
    [keywordSection addFormRow:keywordRow];
    [form addFormSection:keywordSection];
    
    // 按钮
    
    // Sixth Section
    XLFormSectionDescriptor *Section = [XLFormSectionDescriptor formSection];
    [form addFormSection:Section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"conform" rowType:XLFormRowDescriptorTypeButton];
    row.title = @"确定";
    [Section addFormRow:row];
    
    self.form = form;
}

- (NSDictionary<NSNumber *, NSString *> *)targetRowTagsRelation {
    return @{@(MERuleTargetSender): MJTargetSenderCheckTag,
             @(MERuleTargetConternt): MJTargetContentCheckTag
             };
}

- (NSDictionary<NSNumber *, NSString *> *)typeRowTagsRelation {
    return @{@(MERuleTypeHasPrefix): MJTypeHasPrefixCheckTag,
             @(MERuleTypeHasSuffix): MJTypeHasSuffixCheckTag,
             @(MERuleTypeContains): MJTypeContainsCheckTag,
             @(MERuleTypeNoContains): MJTypeNotContainsCheckTag,
             @(MERuleTypeContainsRegex): MJTypeContainsRegexCheckTag
             };
}

- (void)selectTarget:(MERuleTarget)target {
    self.condRule.ruleTarget = target;
    static NSDictionary<NSNumber *, NSString *> *relation;
    if (!relation) {
        relation = [self targetRowTagsRelation];
    }
    for (NSNumber *key in relation) {
        if (key.integerValue != target) {
            XLFormRowDescriptor *row =  [self.form formRowWithTag:relation[key]];
            if ([row.value boolValue]) {
                row.value = @(NO);
                [self reloadFormRow:row];
            }
        }
    }
}

- (void)selectTypeByRowTag:(NSString *)tag {
    static NSDictionary<NSNumber *, NSString *> *relation;
    if (!relation) {
        relation = [self typeRowTagsRelation];
    }
    for (NSNumber *key in relation) {
        if ([relation[key] isEqualToString:tag]) {
            self.condRule.ruleType = key.integerValue;
            break;
        }
    }
    for (NSNumber *key in relation) {
        if (![relation[key] isEqualToString:tag]) {
            XLFormRowDescriptor *row =  [self.form formRowWithTag:relation[key]];
            if ([row.value boolValue]) {
                row.value = @(NO);
                [self reloadFormRow:row];
            }
        }
    }
}

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if ([formRow.tag isEqualToString:MJTargetSenderCheckTag]) {
        if ([newValue boolValue]) {
            [self selectTarget:MERuleTargetSender];
        } else if ([oldValue boolValue] && self.condRule.ruleTarget == MERuleTargetSender) {
            [self selectTarget:MERuleTargetSender];
            formRow.value = @YES;
        }
    }
    if ([formRow.tag isEqualToString:MJTargetContentCheckTag]) {
        if ([newValue boolValue]) {
            [self selectTarget:MERuleTargetConternt];
        } else if ([oldValue boolValue] && self.condRule.ruleTarget == MERuleTargetConternt) {
            [self selectTarget:MERuleTargetConternt];
            formRow.value = @YES;
        }
    }
    if ([formRow.tag isEqualToString:MJTypeHasPrefixCheckTag] || [formRow.tag isEqualToString:MJTypeHasSuffixCheckTag] || [formRow.tag isEqualToString:MJTypeContainsCheckTag] || [formRow.tag isEqualToString:MJTypeNotContainsCheckTag] || [formRow.tag isEqualToString:MJTypeContainsRegexCheckTag]) {
        if ([newValue boolValue]) {
            [self selectTypeByRowTag:formRow.tag];
        } else if ([oldValue boolValue] && [[self typeRowTagsRelation][@(self.condRule.ruleType)] isEqualToString:formRow.tag]) {
            formRow.value = @YES;
        }
    }
    if ([formRow.tag isEqualToString:MJKeywordTextInputTag]) {
        NSString *newKeyword = formRow.value;
        if (newKeyword.length > 0) {
            self.condRule.keyword = newKeyword;
        }
    }

}

-(void)didSelectFormRow:(XLFormRowDescriptor *)formRow{
    
    // 判断是不是点击了确定按钮
    if([formRow.tag isEqualToString:@"conform"] && formRow.rowType == XLFormRowDescriptorTypeButton){
        
        //获取表单所有到的值
        NSDictionary *values =  [self formValues];
        _condition.keyword = self.condRule.keyword;
        
         _condition.ruleType = self.condRule.ruleType;
         _condition.ruleTarget = self.condRule.ruleTarget;
        [[MessageManage shareManage] save];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@", values);
        
    }
    
    [super didSelectFormRow:formRow];
    
}

@end
