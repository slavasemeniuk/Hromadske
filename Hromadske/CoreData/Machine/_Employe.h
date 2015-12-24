// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Employe.h instead.

@import CoreData;

extern const struct EmployeAttributes {
	__unsafe_unretained NSString *bio;
	__unsafe_unretained NSString *identifire;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
} EmployeAttributes;

@interface EmployeID : NSManagedObjectID {}
@end

@interface _Employe : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EmployeID* objectID;

@property (nonatomic, strong) NSString* bio;

//- (BOOL)validateBio:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifire;

@property (atomic) int16_t identifireValue;
- (int16_t)identifireValue;
- (void)setIdentifireValue:(int16_t)value_;

//- (BOOL)validateIdentifire:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* position;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;

@end

@interface _Employe (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBio;
- (void)setPrimitiveBio:(NSString*)value;

- (NSNumber*)primitiveIdentifire;
- (void)setPrimitiveIdentifire:(NSNumber*)value;

- (int16_t)primitiveIdentifireValue;
- (void)setPrimitiveIdentifireValue:(int16_t)value_;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePosition;
- (void)setPrimitivePosition:(NSString*)value;

@end
