//
//  CreateRecipeVC.m
//  Recipe Ready
//
//  Created by mac on 12/9/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import "CreateRecipeVC.h"
#import "MBProgressHUD.h"
#import "IngredientHintCell.h"
#import "IngredientCell.h"
#import "UIImageView+WebCache.h"
#import "IngredientNameCell.h"
#import "HeaderCell.h"

@interface CreateRecipeVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
	NSMutableArray* arrIngredient;
	NSMutableArray* arrSelected;
	NSMutableArray* arrSelectedIngredient;
	NSMutableArray* searchResult;
	NSMutableArray* searchResultDetail;
	NSMutableArray* arrRate;
	NSMutableArray* arrUnitSingular;
	NSMutableArray* arrUnitPlural;

	NSString* strInstruction;
	NSString* strIngrdientNames;
	NSString* strRecipeImageName;
	
	BOOL bCancelled;
	BOOL bAddIngredients;
	int nCallIndex;
	int nSelectedRecipeId;
	int nSelectedRateMark;
	int nSelectedIndex;
	RecipeDetail* createdRecipe;
}
@end

@implementation CreateRecipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	arrIngredient = [[NSMutableArray alloc] init];
	arrSelectedIngredient = [[NSMutableArray alloc] init];
	searchResult = [[NSMutableArray alloc] init];
	searchResultDetail = [[NSMutableArray alloc] init];
	[self refreshMyIngredients];
	
	[self.btnDone setTitle:@"Create" forState:UIControlStateNormal];
	strRecipeImageName = @"no_recipe";
	
	appdata.nCreateMode = TAKE_MODE;
	bAddIngredients = NO;
	
	self.mainView.contentSize = self.containerView.bounds.size;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"Unit" ofType:@"plist"];
	NSString *paths = [[NSBundle mainBundle] pathForResource:
					   @"Units" ofType:@"plist"];
 
	// Build the array from the plist
	arrUnitSingular = [[NSMutableArray alloc] initWithContentsOfFile:path];
	arrUnitPlural = [[NSMutableArray alloc] initWithContentsOfFile:paths];
	
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
	[recognizer setNumberOfTapsRequired:1];
	[self.mainView addGestureRecognizer:recognizer];
	
	UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearUnitView)];
	[tap setNumberOfTapsRequired:1];
	[self.darkView addGestureRecognizer:tap];
}

- (void) viewWillAppear:(BOOL)animated {
	if (appdata.nCreateMode == GENERATE_MODE && appdata.nSelectRecipeIndex != -1) {
		
//		[MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
//		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//			[self getRecipeDetail:appData.nSelectRecipeIndex];
//		});
		
		NSString *imageUrlString = appdata.strSelectedImgName;
		strRecipeImageName = appdata.strSelectedImgName;
		
		NSArray* foo = [strRecipeImageName componentsSeparatedByString: @"/"];
		if (foo.count > 0) {
			strRecipeImageName = [foo lastObject];
		}
		
		[self.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
							  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		
		CGRect frame = self.ingredientTblView.frame;
		self.ingredientTblView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80 * arrSelectedIngredient.count);
		
		[self resizeContentSize];
	}
}

-(void)gestureAction:(UITapGestureRecognizer *) sender
{
	CGPoint p = [sender locationInView:self.mainView];
	CGPoint p1 = CGPointMake(p.x, p.y - self.ingredientTblView.frame.origin.y);
	NSIndexPath *indexPath = [self.ingredientTblView indexPathForRowAtPoint:p1];
	if (indexPath) {
		[self.ingredientTblView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		[self tableView:self.ingredientTblView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)disappearUnitView {
	self.darkView.hidden = YES;
	self.selectUnitView.hidden = YES;
}


//- (void)getRecipeDetail:(int) index {
//	[appData.me getRecipeDetail:index handler:^(NSDictionary *result, NSString *errorMsg) {
//		[MBProgressHUD hideHUDForView:self.parentViewController.view animated:YES];
//		if (result) {
//			NSLog(@"%@", result);
//			[arrSelectedIngredient removeAllObjects];
//			arrSelectedIngredient = [[NSMutableArray alloc] init];
//			
//			recipeDetail = [[RecipeDetail alloc] initWithDictionary:result];
//			arrSelectedIngredient = recipeDetail.arrIngredients;
//			strInstruction = recipeDetail.instructions;
//			
//			NSString *imageUrlString = recipeDetail.imageName;
//			strRecipeImageName = recipeDetail.imageName;
//			
//			NSArray* foo = [strRecipeImageName componentsSeparatedByString: @"/"];
//			if (foo.count > 0) {
//				strRecipeImageName = [foo lastObject];
//			}
//			
//			[self.recipeImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
//								  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
//			
//			self.ingredientTblView.hidden = NO;
//			[self.ingredientTblView reloadData];
//			
//			self.lblRecipeName.text = recipeDetail.title;
//
//			CGRect frame = self.ingredientTblView.frame;
//			self.ingredientTblView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80 * arrSelectedIngredient.count);
//			
//			[self resizeContentSize];
//			
//			if (![AppData isNullOrEmptyString:strInstruction]) {
//				CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
//				
//				CGSize expectedLabelSize = [strInstruction sizeWithFont:[UIFont fontWithName:@"Arial" size:15] constrainedToSize:maximumLabelSize lineBreakMode:self.lblInstructions.lineBreakMode];
//				
//				CGRect newFrame = self.lblInstructions.frame;
//				newFrame.size.height = expectedLabelSize.height + 10;
//				newFrame.origin.y = self.instructionView.frame.origin.y + self.instructionView.frame.size.height + 3;
//				self.lblInstructions.frame = newFrame;
//				self.lblInstructions.text = strInstruction;
//				
//				frame = self.containerView.frame;
//				self.containerView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.lblInstructions.frame.origin.y + self.lblInstructions.frame.size.height + 3);
//				
//				self.mainView.contentSize = self.containerView.bounds.size;
//			}
//			
//		}
//	}];
//}

- (void)refreshMyIngredients {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[FIRIngredient observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		[arrIngredient removeAllObjects];
		arrIngredient = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Ingredient* aIngredient = [[Ingredient alloc] initWithDictionary:dicSnap snapKey:snap.key];
			[arrIngredient addObject:aIngredient];
		}
		
		NSArray *sortedArray = [arrIngredient sortedArrayUsingComparator:^NSComparisonResult(Ingredient *p1, Ingredient *p2){
			
			return [p1.name compare:p2.name];
			
		}];
		arrIngredient = [sortedArray mutableCopy];
		appdata.arrBasket = [arrIngredient mutableCopy];
		
		arrSelected = [[NSMutableArray alloc] init];
		for (int i = 0; i < arrIngredient.count; i++) {
			[arrSelected addObject:@"NO"];
		}
		self.myingredientView.hidden = YES;
		[self.myIngredientTblView reloadData];
		[self refreshRate];
	}];
}

- (void)refreshRate {
	[FIRRate observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
		arrRate = [[NSMutableArray alloc] init];
		for (FIRDataSnapshot* snap in snapshot.children.allObjects) {
			NSDictionary* dicSnap = (NSDictionary*) snap.value;
			Rate* aRate = [[Rate alloc] initWithData:dicSnap snapkey:snap.key];
			[arrRate addObject:aRate];
		}
		
		appdata.arrRate = [arrRate mutableCopy];
	}];
}

- (IBAction)backAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addRecipeImage:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to add an image or have an image generated for you?"
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Add an image", @"Generate an image", nil];
	actionSheet.tag = 101;
	
	 [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.tag == 101) {
		if (buttonIndex == 0) {
			appdata.nCreateMode = TAKE_MODE;
			@try
			{
				UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
																		 delegate:self
																cancelButtonTitle:@"Cancel"
														   destructiveButtonTitle:nil
																otherButtonTitles:@"Take photo", @"Choose From Library", nil];
				actionSheet.tag = 102;
				
				[actionSheet showInView:self.view];
			}
			@catch (NSException *exception)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alert show];
			}
		} else if (buttonIndex == 1){
			appdata.nCreateMode = GENERATE_MODE;
			[self performSegueWithIdentifier:@"Generate" sender:nil];
		}
	} else if (actionSheet.tag == 102) {
		if (buttonIndex == 0) {
			@try
			{
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.allowsEditing = YES;
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				picker.delegate = self;
				
				[self presentViewController:picker animated:YES completion:^{
					
				}];
			}
			@catch (NSException *exception)
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alert show];
			}
		} else if (buttonIndex == 1){
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			picker.delegate = self;
			
			[self presentViewController:picker animated:YES completion:^{
				
			}];
		}
	} else if (actionSheet.tag == 103) {
		if (buttonIndex == 0) {
			[appdata addPostedRecipeToPersonalData:createdRecipe];
			[appdata addPostedRecipeToGlobal:createdRecipe];
		}
		
		[self.navigationController popViewControllerAnimated:YES];
	}
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	self.recipeImgView.image = chosenImage;
	
	strRecipeImageName = [NSString stringWithFormat:@"%@.png",[appdata randomStringWithLength:10]];
	
	[self inputRecipeName];
}

-(void)inputRecipeName {
	UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Recipe Title"
																			  message: @"Input recipe's title"
																	   preferredStyle:UIAlertControllerStyleAlert];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"title";
		textField.textColor = [UIColor blackColor];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.borderStyle = UITextBorderStyleNone;
	}];
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSArray * textfields = alertController.textFields;
		UITextField * titleField = textfields[0];
		self.lblRecipeName.text = titleField.text;
		
	}]];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)addIngredients:(id)sender {
	arrSelected = [[NSMutableArray alloc] init];
	for (int i = 0; i < arrIngredient.count; i++) {
		[arrSelected addObject:@"NO"];
	}
	self.myingredientView.hidden = NO;
	[self.myIngredientTblView reloadData];
	
	bAddIngredients = YES;
	[self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
}

- (IBAction)addInstructions:(id)sender {
	self.maskView.hidden = NO;
	self.inputView.hidden = NO;
	self.instructionTxtView.text = self.lblInstructions.text;
	[self.instructionTxtView becomeFirstResponder];
}

//Done Action for search with ingredients or Create a recipe
- (IBAction)doneAction:(id)sender {
	if (bAddIngredients) {
		bAddIngredients = NO;
		for (int i = 0; i < arrIngredient.count; i++) {
			Ingredient* myIngredient = arrIngredient[i];
			if ([arrSelected[i] isEqualToString:@"YES"]) {
				BOOL bExist = NO;
				for (Ingredient* aIngredient in arrSelectedIngredient) {
					if (aIngredient.index == myIngredient.index) {
						bExist = YES;
						break;
					}
				}
				
				if (!bExist)
					[arrSelectedIngredient addObject:arrIngredient[i]];
			}
		}
		[self.btnDone setTitle:@"Create" forState:UIControlStateNormal];
		self.myingredientView.hidden = YES;
		
		if (arrSelectedIngredient.count > 0) {
			CGRect frame = self.ingredientTblView.frame;
			self.ingredientTblView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80 * arrSelectedIngredient.count);
			
			self.ingredientTblView.hidden = NO;
			[self.ingredientTblView reloadData];
			
			[self resizeContentSize];
		}
	} else {
		if ([self.lblRecipeName.text isEqualToString:@""]) {
			[self inputRecipeName];
			return;
		}
		if (arrSelectedIngredient.count == 0) {
			UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																					  message: @"Please add ingredients"
																			   preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self addIngredients:nil];
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
			return;
		}
		
		if ([self.lblInstructions.text isEqualToString:@""]) {
			UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																					  message: @"Please input instructions"
																			   preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self addInstructions:nil];
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
			return;
		}
		
		if ([strRecipeImageName isEqualToString:@"no_recipe"]) {
			UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																					  message: @"Please add recipe image"
																			   preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self addRecipeImage:nil];
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
			return;
		}
		
		NSData* uploadData = UIImagePNGRepresentation(self.recipeImgView.image);
		[self storageRecipeImage:uploadData];	
	}
}

- (void)storageRecipeImage:(NSData*) uploadData {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[[FIRStorageCreatedRecipe child:strRecipeImageName] putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if (error != nil) {
			UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																					  message: @"Upload Recipe's Image Failed"
																			   preferredStyle:UIAlertControllerStyleAlert];
			[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self addRecipeImage:nil];
			}]];
			[self presentViewController:alertController animated:YES completion:nil];
			return;
		}
		
		int rndValue = kLowerBound + arc4random() % kLowerBound;
		createdRecipe = [[RecipeDetail alloc] init];
		createdRecipe.index = rndValue;
		createdRecipe.arrIngredients = arrSelectedIngredient;
		createdRecipe.instructions = self.lblInstructions.text;
		createdRecipe.imageName = [metadata.downloadURL absoluteString];
		createdRecipe.title = self.lblRecipeName.text;
		createdRecipe.snapkey = @"";
		createdRecipe.userid = appdata.me.token;
		createdRecipe.createdDateTime = [appdata getCurrentEstTime];
		
		[self uploadCreatedRecipe:createdRecipe];
	}];
}

- (void) uploadCreatedRecipe:(RecipeDetail*) recipe {	
	NSString* strKey = [appdata addCreatedRecipeToFirebase:recipe];
	
	if (![AppData isNullOrEmptyString:strKey]) {
		UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
																				  message: @"Create a recipe successfully!"
																		   preferredStyle:UIAlertControllerStyleAlert];
		[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			// Post the created recipe to social feed
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to post the created recipe to social feed?"
																	 delegate:self
															cancelButtonTitle:@"Maybe later"
													   destructiveButtonTitle:nil
															otherButtonTitles:@"Yes", @"No", nil];
			actionSheet.tag = 103;
			[actionSheet showInView:self.view];
			
			//[self.navigationController popViewControllerAnimated:YES];
		}]];
		[self presentViewController:alertController animated:YES completion:nil];
		return;
	}
}

- (IBAction)submitAction:(id)sender {
	strInstruction = self.instructionTxtView.text;
	self.inputView.hidden = YES;
	self.maskView.hidden = YES;
	
	CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
	
	CGSize expectedLabelSize = [strInstruction sizeWithFont:[UIFont fontWithName:@"Arial" size:15] constrainedToSize:maximumLabelSize lineBreakMode:self.lblInstructions.lineBreakMode];
	
	//adjust the label the the new height.
	CGRect newFrame = self.lblInstructions.frame;
	newFrame.size.height = expectedLabelSize.height + 10;
	newFrame.origin.y = self.instructionView.frame.origin.y + self.instructionView.frame.size.height + 3;
	self.lblInstructions.frame = newFrame;
	self.lblInstructions.text = strInstruction;
	
	CGRect frame = self.containerView.frame;
	self.containerView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.lblInstructions.frame.origin.y + self.lblInstructions.frame.size.height + 3);
	
	self.mainView.contentSize = self.containerView.bounds.size;
	
	[self.instructionTxtView resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
	self.inputView.hidden = YES;
	self.maskView.hidden = YES;
	[self.instructionTxtView resignFirstResponder];
}

- (void)resizeContentSize {
	CGRect frame;
	frame = self.instructionView.frame;
	self.instructionView.frame = CGRectMake(frame.origin.x, self.ingredientTblView.frame.origin.y + self.ingredientTblView.frame.size.height + 3, frame.size.width, frame.size.height);
	
	frame = self.lblInstructions.frame;
	self.lblInstructions.frame = CGRectMake(frame.origin.x, self.instructionView.frame.origin.y + self.instructionView.frame.size.height + 3, frame.size.width, frame.size.height);
	
	frame = self.containerView.frame;
	self.containerView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.lblInstructions.frame.origin.y + self.lblInstructions.frame.size.height + 3);
	self.mainView.contentSize = self.containerView.bounds.size;
}

- (void)minusAmount:(int) nId {
	Ingredient* aIngredient = arrSelectedIngredient[nId];
	float nAmount = aIngredient.amount;
	
	NSMutableArray* arrUnit;
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	int nCategoryIndex = 0, nUnitIndex = 0;
	NSString* strUnit = aIngredient.unit;
	BOOL bExist = NO;
	for (int i = 0; i < arrUnit.count; i++) {
		NSDictionary* unit = arrUnit[i];
		NSArray* arrSub = unit[@"units"];
		for (NSString* strName in arrSub) {
			if ([strName isEqualToString:strUnit]) {
				nCategoryIndex = i;
				nUnitIndex = [arrSub indexOfObject:strName];
				bExist = YES;
				break;
			}
		}
		if (bExist)
			break;
	}
	
	if (nAmount > 1.0f)
		nAmount -= 1.0f;
	
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	aIngredient.amount = nAmount;
	if (bExist) {
		NSString* strUpdatedUnit = arrUnit[nCategoryIndex][@"units"][nUnitIndex];
		aIngredient.unit = strUpdatedUnit;
	}
	
	[arrSelectedIngredient replaceObjectAtIndex:nId withObject:aIngredient];
	[self.ingredientTblView reloadData];
}

- (void)plusAmount:(int) nId {
	Ingredient* aIngredient = arrSelectedIngredient[nId];
	float nAmount = aIngredient.amount;
	
	NSMutableArray* arrUnit;
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	int nCategoryIndex = 0, nUnitIndex = 0;
	NSString* strUnit = aIngredient.unit;
	BOOL bExist = NO;
	for (int i = 0; i < arrUnit.count; i++) {
		NSDictionary* unit = arrUnit[i];
		NSArray* arrSub = unit[@"units"];
		for (NSString* strName in arrSub) {
			if ([strName isEqualToString:strUnit]) {
				nCategoryIndex = i;
				nUnitIndex = [arrSub indexOfObject:strName];
				bExist = YES;
				break;
			}
		}
		if (bExist)
			break;
	}
	
	nAmount += 1.0f;
	aIngredient.amount = nAmount;
	
	if (nAmount > 1)
		arrUnit = arrUnitPlural;
	else
		arrUnit = arrUnitSingular;
	
	if (bExist) {
		NSString* strUpdatedUnit = arrUnit[nCategoryIndex][@"units"][nUnitIndex];
		aIngredient.unit = strUpdatedUnit;
	}
	[arrSelectedIngredient replaceObjectAtIndex:nId withObject:aIngredient];
	[self.ingredientTblView reloadData];
}

- (void)changeUnits:(int)nId {
	nSelectedIndex = nId;
	self.darkView.hidden = NO;
	self.selectUnitView.hidden = NO;
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int nCount = 0;
	if (tableView.tag == 101)
		nCount = (int)arrIngredient.count;
	else if (tableView.tag == 102)
		nCount = (int)arrSelectedIngredient.count;
	else if (tableView.tag == 103) {
		nCount = [arrUnitSingular[section][@"units"] count];
	}
	
	return nCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int nCount = 1;
	if (tableView.tag == 103) {
		nCount = arrUnitSingular.count;
	}
	return nCount;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	HeaderCell* headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
	
	if (tableView.tag == 103) {
		// 1. Dequeue the custom header cell
		
		NSLog(@"%@", arrUnitSingular[section][@"category"]);
		// 2. Set the various properties
		headerCell.lblSectionName.text = arrUnitSingular[section][@"category"];
		
		// 3. And return
		return headerCell;
	} else
		return nil;
	return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	int nHeight = 0;
	if (tableView.tag == 103)
		nHeight = 44;
	return nHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *simpleTableIdentifier = @"IngredientHintCell";
	IngredientHintCell *cell= (IngredientHintCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	if (tableView.tag == 101) {
		NSLog(@"cellForRowAtIndexPath row=%d section=%d", (int)indexPath.row, (int)indexPath.section);
		if (cell == nil)
		{
			cell = [[IngredientHintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		Ingredient* aIngredient = arrIngredient[indexPath.row];
		cell.lblIngredientName.text = aIngredient.name;
		
		BOOL bSelect = [arrSelected[indexPath.row] boolValue];
		if (bSelect) {
			[cell.checkImgVIew setImage:[UIImage imageNamed:@"check_mark"]];
		} else {
			[cell.checkImgVIew setImage:nil];
		}
		
		return cell;
	} else if (tableView.tag == 102){
		static NSString *simpleTableIdentifier = @"IngredientCell";
		IngredientCell *cell= (IngredientCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
		
		if (cell == nil)
		{
			cell = [[IngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.viewController1 = self;
		cell.btnMinus.tag = (int)indexPath.row;
		cell.btnPlus.tag = (int)indexPath.row;		
		
		Ingredient* aIngredient = arrSelectedIngredient[indexPath.row];
		cell.lblInggredientName.text = aIngredient.name;
		
		if (aIngredient.amount - floor(aIngredient.amount) > 0)
			cell.lblAmount.text = [NSString stringWithFormat:@"%0.2f", aIngredient.amount];
		else if (aIngredient.amount - floor(aIngredient.amount) == 0) {
			cell.lblAmount.text = [NSString stringWithFormat:@"%d", (int)aIngredient.amount];
		}
		
		if (![aIngredient.unit isEqualToString:@""])
			cell.lblUnit.text = [NSString stringWithFormat:@"(%@)", aIngredient.unit];
		else
			cell.lblUnit.text = @"";
		
		NSString *imageUrlString = aIngredient.imgName;
		[cell.ingredientImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
								  placeholderImage:[UIImage imageNamed:@"no_recipe"]];
		return cell;

	} else if (tableView.tag == 103) {
		static NSString *simpleTableIdentifier = @"IngredientNameCell";
		IngredientNameCell *cell= (IngredientNameCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
		
		if (cell == nil)
		{
			cell = [[IngredientNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		NSString* strUnit = arrUnitSingular[indexPath.section][@"units"][indexPath.row];
		cell.lblIngredientName.text = strUnit;
		
		return cell;
	}

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (tableView.tag == 101) {
		BOOL bSelect = [arrSelected[indexPath.row] boolValue];
		if (bSelect) {
			arrSelected[indexPath.row] = @"NO";
		} else {
			arrSelected[indexPath.row] = @"YES";
		}
		[self.myIngredientTblView reloadData];
	} else if (tableView.tag == 102) {
	}
	else if (tableView.tag == 103) {
		
		NSString* strUnitName;
		Ingredient* aIngredient = arrSelectedIngredient[nSelectedIndex];
		if (aIngredient.amount > 1)
			strUnitName = arrUnitPlural[indexPath.section][@"units"][indexPath.row];
		else
			strUnitName = arrUnitSingular[indexPath.section][@"units"][indexPath.row];
		
		aIngredient.unit = strUnitName;
		[arrSelectedIngredient replaceObjectAtIndex:nSelectedIndex withObject:aIngredient];
		self.darkView.hidden = YES;
		self.selectUnitView.hidden = YES;
		[self.ingredientTblView reloadData];
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[arrSelectedIngredient removeObjectAtIndex:indexPath.row];
		[self.ingredientTblView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		CGRect frame = self.ingredientTblView.frame;
		self.ingredientTblView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80 * arrSelectedIngredient.count);
		
		self.ingredientTblView.hidden = NO;
		[self.ingredientTblView reloadData];
		[self resizeContentSize];
	}
}

#pragma mark Table View Delegate Methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}


@end
