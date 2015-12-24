// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RateAndWeather.h instead.

@import CoreData;

extern const struct RateAndWeatherAttributes {
	__unsafe_unretained NSString *rateEUR;
	__unsafe_unretained NSString *rateUSD;
	__unsafe_unretained NSString *weather;
	__unsafe_unretained NSString *weatherType;
} RateAndWeatherAttributes;

@interface RateAndWeatherID : NSManagedObjectID {}
@end

@interface _RateAndWeather : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RateAndWeatherID* objectID;

@property (nonatomic, strong) NSString* rateEUR;

//- (BOOL)validateRateEUR:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rateUSD;

//- (BOOL)validateRateUSD:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* weather;

//- (BOOL)validateWeather:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* weatherType;

//- (BOOL)validateWeatherType:(id*)value_ error:(NSError**)error_;

@end

@interface _RateAndWeather (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveRateEUR;
- (void)setPrimitiveRateEUR:(NSString*)value;

- (NSString*)primitiveRateUSD;
- (void)setPrimitiveRateUSD:(NSString*)value;

- (NSString*)primitiveWeather;
- (void)setPrimitiveWeather:(NSString*)value;

- (NSString*)primitiveWeatherType;
- (void)setPrimitiveWeatherType:(NSString*)value;

@end
