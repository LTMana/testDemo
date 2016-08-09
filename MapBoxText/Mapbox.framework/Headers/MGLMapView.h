#import "MGLGeometry.h"
#import "MGLMapCamera.h"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

@class MGLAnnotationView;
@class MGLAnnotationImage;
@class MGLUserLocation;
@class MGLPolyline;
@class MGLPolygon;
@class MGLShape;

@protocol MGLMapViewDelegate;
@protocol MGLAnnotation;
@protocol MGLOverlay;
@protocol MGLCalloutView;
@protocol MGLFeature;

/** The default deceleration rate for a map view. */
extern const CGFloat MGLMapViewDecelerationRateNormal;

/** A fast deceleration rate for a map view. */
extern const CGFloat MGLMapViewDecelerationRateFast;

/** Disables decleration in a map view. */
extern const CGFloat MGLMapViewDecelerationRateImmediate;

/**
 The vertical alignment of an annotation within a map view. Used with
 `MGLMapView.userLocationVerticalAlignment`.
 */
typedef NS_ENUM(NSUInteger, MGLAnnotationVerticalAlignment) {
    /** Aligns the annotation vertically in the center of the map view. */
    MGLAnnotationVerticalAlignmentCenter = 0,
    /** Aligns the annotation vertically at the top of the map view. */
    MGLAnnotationVerticalAlignmentTop,
    /** Aligns the annotation vertically at the bottom of the map view. */
    MGLAnnotationVerticalAlignmentBottom,
};

/** Options for enabling debugging features in an MGLMapView instance. */
typedef NS_OPTIONS(NSUInteger, MGLMapDebugMaskOptions) {
    /** Edges of tile boundaries are shown as thick, red lines to help diagnose
        tile clipping issues. */
    MGLMapDebugTileBoundariesMask = 1 << 1,
    /** Each tile shows its tile coordinate (x/y/z) in the upper-left corner. */
    MGLMapDebugTileInfoMask = 1 << 2,
    /** Each tile shows a timestamp indicating when it was loaded. */
    MGLMapDebugTimestampsMask = 1 << 3,
    /** Edges of glyphs and symbols are shown as faint, green lines to help
        diagnose collision and label placement issues. */
    MGLMapDebugCollisionBoxesMask = 1 << 4,
    /** Each drawing operation is replaced by a translucent fill. Overlapping
        drawing operations appear more prominent to help diagnose overdrawing.
     */
    MGLMapDebugOverdrawVisualizationMask = 1 << 5,
};

/**
 An interactive, customizable map view with an interface similar to the one
 provided by Apple's MapKit.
 
 Using `MGLMapView`, you can embed the map inside a view, allow users to
 manipulate it with standard gestures, animate the map between different
 viewpoints, and present information in the form of annotations and overlays.
 
 The map view loads scalable vector tiles that conform to the
 <a href="https://github.com/mapbox/vector-tile-spec">Mapbox Vector Tile Specification</a>.
 It styles them with a style that conforms to the
 <a href="https://www.mapbox.com/mapbox-gl-style-spec/">Mapbox GL style specification</a>.
 Such styles can be designed in
 <a href="https://www.mapbox.com/studio/">Mapbox Studio</a> and hosted on
 mapbox.com.
 
 A collection of Mapbox-hosted styles is available through the `MGLStyle`
 class. These basic styles use
 <a href="https://www.mapbox.com/developers/vector-tiles/mapbox-streets">Mapbox Streets</a>
 or <a href="https://www.mapbox.com/satellite/">Mapbox Satellite</a> data
 sources, but you can specify a custom style that makes use of your own data.
 
 Mapbox-hosted vector tiles and styles require an API access token, which you
 can obtain from the
 <a href="https://www.mapbox.com/studio/account/tokens/">Mapbox account page</a>.
 Access tokens associate requests to Mapbox's vector tile and style APIs with
 your Mapbox account. They also deter other developers from using your styles
 without your permission.
 
 @note You are responsible for getting permission to use the map data and for
 ensuring that your use adheres to the relevant terms of use.
 */
IB_DESIGNABLE
@interface MGLMapView : UIView

#pragma mark Creating Instances

/**
 Initializes and returns a newly allocated map view with the specified frame
 and the default style.
 
 @param frame The frame for the view, measured in points.
 @return An initialized map view.
 
 初始化并返回新地图视图。
 */

- (instancetype)initWithFrame:(CGRect)frame;

/**
 Initializes and returns a newly allocated map view with the specified frame
 and style URL.
 
 @param frame The frame for the view, measured in points.
 @param styleURL URL of the map style to display. The URL may be a full HTTP
    or HTTPS URL, a Mapbox URL indicating the style's map ID
    (`mapbox://styles/{user}/{style}`), or a path to a local file relative
    to the application's resource path. Specify `nil` for the default style.
 @return An initialized map view.
 
 初始化并返回指定URL风格的地图视图。
 @param styleURL 地图风格的URL来显示。URL可以是一个完整的HTTP或HTTPS URL，或一个Mapbox URL指明样式的地图标识（mapbox://styles/{user}/{style}），或本地应用程序的资源路径的文件的路径。指定nil默认样式。
   */
- (instancetype)initWithFrame:(CGRect)frame styleURL:(nullable NSURL *)styleURL;

#pragma mark Accessing the Delegate

/**
 The receiver's delegate.
 
 A map view sends messages to its delegate to notify it of changes to its
 contents or the viewpoint. The delegate also provides information about
 annotations displayed on the map, such as the styles to apply to individual
 annotations.
 代理。
 地图视图将消息发送到其委托，通知其修改其内容。该代理还提供了地图上显示的注释，如适用于个人注解样式的信息。
 */
@property(nonatomic, weak, nullable) IBOutlet id<MGLMapViewDelegate> delegate;

#pragma mark Configuring the Map's Appearance

/**
 URLs of the styles bundled with the library.
 
 @deprecated Call the relevant class method of `MGLStyle` for the URL of a
    particular default style.
 
   与库捆绑的URL样式（只读）。
 
 */
@property (nonatomic, readonly) NS_ARRAY_OF(NSURL *) *bundledStyleURLs __attribute__((deprecated("Call the relevant class method of MGLStyle for the URL of a particular default style.")));

/**
 URL of the style currently displayed in the receiver.
 
 The URL may be a full HTTP or HTTPS URL, a Mapbox URL indicating the style's
 map ID (`mapbox://styles/{user}/{style}`), or a path to a local file
 relative to the application's resource path.
 
 If you set this property to `nil`, the receiver will use the default style
 and this property will automatically be set to that style's URL.

 当前URL样式接收属性。
 
 URL可以是一个完整的HTTP或HTTPS URL，或一个Mapbox URL指明样式的地图标识（mapbox://styles/{user}/{style}），或本地应用程序的资源路径的文件的路径。指定nil默认样式。 
 */
@property (nonatomic, null_resettable) NSURL *styleURL;

/**
 Reloads the style.
 
 You do not normally need to call this method. The map view automatically
 responds to changes in network connectivity by reloading the style. You may
 need to call this method if you change the access token after a style has
 loaded but before loading a style associated with a different Mapbox account.
 
 This method does not bust the cache. Even if the style has recently changed on
 the server, calling this method does not necessarily ensure that the map view
 reflects those changes.
 
 重新加载风格。
 
 您通常不需要调用此方法。网络连接变化地图视图将自动响应并重新加载风格。如果您更改访问令牌的风格已经加载，但加载与Mapbox帐户关联不同的样式，您可能需要调用此方法。
 
 此方法不缓存。即使最近风格在服务器上更改，调用此方法不一定保证地图视图反映了这些变化。
 
 */
- (IBAction)reloadStyle:(id)sender;

/**
 A control indicating the map's direction and allowing the user to manipulate
 the direction, positioned in the upper-right corner.
 
 控制指示地图的方向并允许用户操纵方向，显示右上角（只读）。
 */
@property (nonatomic, readonly) UIImageView *compassView;

/**
 The Mapbox logo, positioned in the lower-left corner.
 
 @note The Mapbox terms of service, which governs the use of Mapbox-hosted
    vector tiles and styles,
    <a href="https://www.mapbox.com/help/mapbox-logo/">requires</a> most Mapbox
    customers to display the Mapbox logo. If this applies to you, do not
    hide this view or change its contents.
    
 Mapbox标识，显示在左下角（只读）。
 
 */
@property (nonatomic, readonly) UIImageView *logoView;

/** 
 A view showing legally required copyright notices and telemetry settings,
 positioned at the bottom-right of the map view.
 
 @note The Mapbox terms of service, which governs the use of Mapbox-hosted
    vector tiles and styles,
    <a href="https://www.mapbox.com/help/attribution/">requires</a> these
    copyright notices to accompany any map that features Mapbox-designed styles,
    OpenStreetMap data, or other Mapbox data such as satellite or terrain
    data. If that applies to this map view, do not hide this view or remove
    any notices from it.

 @note You are additionally
    <a href="https://www.mapbox.com/help/telemetry-opt-out-for-users/">required</a>
    to provide users with the option to disable anonymous usage and location
    sharing (telemetry). If this view is hidden, you must implement this
    setting elsewhere in your app or via `Settings.bundle`. See our
    <a href="https://www.mapbox.com/ios-sdk/#telemetry_opt_out">website</a> for
    implementation help.
 
  显示出法律所要求的版权声明，显示在地图视图的右下角。
  使用Mapbox的矢量瓷砖和风格，Mapbox方面需要这些版权声明.具有Mapbox设计风格，OpenStreetMap的数据，或诸如卫星或地形数据等Mapbox数据的地图。如果应用于该地图视图，不能隐藏此view。
 注意
 您还需要为用户提供禁用匿名使用和位置共享的选项。如果这种观点是隐藏的，则必须在您的应用程序或通过其他地方实施此设置Settings.bundle。请参阅我们 的网站实施帮助。
 */
@property (nonatomic, readonly) UIButton *attributionButton;

/** 
 Currently active style classes, represented as an array of string identifiers.
 
 当前活动样式，表示为字符串标识符的数组。
 */
@property (nonatomic) NS_ARRAY_OF(NSString *) *styleClasses;

/**
 Returns a Boolean value indicating whether the style class with the given
 identifier is currently active.
 
 @param styleClass The style class to query for.
 @return Whether the style class is currently active.
 
 返回一个布尔值，表示给定的标识样式lei是否处于激活状态
 */
- (BOOL)hasStyleClass:(NSString *)styleClass;

/**
 Activates the style class with the given identifier.
 
 @param styleClass The style class to activate.
 
 激活给定标识符的样式类。
 */
- (void)addStyleClass:(NSString *)styleClass;

/**
 Deactivates the style class with the given identifier.
 
 @param styleClass The style class to deactivate.
 
 停用给定标识符的样式类。
 */
- (void)removeStyleClass:(NSString *)styleClass;

#pragma mark Displaying the User's Location

/**
 A Boolean value indicating whether the map may display the user location.
 
 Setting this property to `YES` causes the map view to use the Core Location
 framework to find the current location. As long as this property is `YES`, the
 map view continues to track the user's location and update it periodically.
 
 This property does not indicate whether the user's position is actually visible
 on the map, only whether the map view is allowed to display it. To determine
 whether the user's position is visible, use the `userLocationVisible` property.
 The default value of this property is `NO`.
 
 On iOS 8 and above, your app must specify a value for
 `NSLocationWhenInUseUsageDescription` or `NSLocationAlwaysUsageDescription` in
 its `Info.plist` to satisfy the requirements of the underlying Core Location
 framework when enabling this property.
 
 布尔值，地图是否可以显示用户的位置。
 
 设置该属性YES将使用Core Location框架找到当前位置的地图视图。只要这个属性YES，地图视图继续跟踪用户的位置，并定期更新。
 
 此属性并不表示用户位置是否真的看到在地图上，地图视图是否只允许显示。来确定用户的位置是否是可见，使用userLocationVisible属性。此属性的默认值是NO。
 
 在iOS 8.0及以上，您的应用程序必须指定一个值 NSLocationWhenInUseUsageDescription或NSLocationAlwaysUsageDescription在其Info.plist启用此属性时，以满足底层的核心定位框架的要求。
 */
@property (nonatomic, assign) BOOL showsUserLocation;

/** 
 A Boolean value indicating whether the device's current location is visible in
 the map view.
 
 Use `showsUserLocation` to control the visibility of the on-screen user
 location annotation.

 布尔值，表明当前位置是否在地图视图中可见。
 */
@property (nonatomic, assign, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

/**
 Returns the annotation object indicating the user's current location.

 返回用户的当前位置
 */
@property (nonatomic, readonly, nullable) MGLUserLocation *userLocation;

/** 
 The mode used to track the user location. The default value is
 `MGLUserTrackingModeNone`.
 
 Changing the value of this property updates the map view with an animated
 transition. If you don’t want to animate the change, use the
 `-setUserTrackingMode:animated:` method instead.
 
 该模式用于跟踪用户位置。默认值是 MGLUserTrackingModeNone。
 
 更改此属性的值更新与动画过渡地图视图。如果您不想动画的变化，使用 -setUserTrackingMode:animated:的方法来代替。
 */
@property (nonatomic, assign) MGLUserTrackingMode userTrackingMode;

/**
 Sets the mode used to track the user location, with an optional transition.
 
 @param mode The mode used to track the user location.
 @param animated If `YES`, there is an animated transition from the current
    viewport to a viewport that results from the change to `mode`. If `NO`, the
    map view instantaneously changes to the new viewport. This parameter only
    affects the initial transition; subsequent changes to the user location or
    heading are always animated.
 
 设置用于跟踪用户位置，使用可选的过渡模式。
 
 @param mode 跟踪用户位置过渡模式
 
 @param animated 如果YES，当前视图动画为mode过渡模式。如果NO，地图视图立即更改为用户当前位置。此参数仅影响最初的过渡; 随后向用户位置变化总是有动画。
 
 */
- (void)setUserTrackingMode:(MGLUserTrackingMode)mode animated:(BOOL)animated;

/**
 The vertical alignment of the user location annotation within the receiver. The
 default value is `MGLAnnotationVerticalAlignmentCenter`.
 
 Changing the value of this property updates the map view with an animated
 transition. If you don’t want to animate the change, use the
 `-setUserLocationVerticalAlignment:animated:` method instead.
 
 用户位置注解的垂直对齐。默认值是MGLAnnotationVerticalAlignmentCenter。
 
 更改此属性的值更新与动画过渡地图视图。如果您不想动画的变化，使用 -setUserLocationVerticalAlignment:animated:的方法来代替。
 
 */
@property (nonatomic, assign) MGLAnnotationVerticalAlignment userLocationVerticalAlignment;

/**
 Sets the vertical alignment of the user location annotation within the
 receiver, with an optional transition.
 
 @param alignment The vertical alignment of the user location annotation.
 @param animated If `YES`, the user location annotation animates to its new
    position within the map view. If `NO`, the user location annotation
    instantaneously moves to its new position.
 
 设置用户位置注解的垂直取向，具有可选的过渡动画。
 @param alignment 用户位置注解垂直对齐。
 @param animated 如果YES，用户位置标注，动画移动到地图视图中的新位置。如果NO，用户位置注解瞬间移动到它的新位置。
 */
- (void)setUserLocationVerticalAlignment:(MGLAnnotationVerticalAlignment)alignment animated:(BOOL)animated;

/**
 Whether the map view should display a heading calibration alert when necessary.
 The default value is `YES`.
 
 在必要的时候地图视图显示一个标题校准警报。默认值是YES。
 */
@property (nonatomic, assign) BOOL displayHeadingCalibration;

/**
 The geographic coordinate that is the subject of observation as the user
 location is being tracked.
 
 By default, this property is set to an invalid coordinate, indicating that
 there is no target. In course tracking mode, the target forms one of two foci
 in the viewport, the other being the user location annotation. Typically, this
 property is set to a destination or waypoint in a real-time navigation scene.
 As the user annotation moves toward the target, the map automatically zooms in
 to fit both foci optimally within the viewport.
 
 This property has no effect if the `userTrackingMode` property is set to a
 value other than `MGLUserTrackingModeFollowWithCourse`.
 
 Changing the value of this property updates the map view with an animated
 transition. If you don’t want to animate the change, use the
 `-setTargetCoordinate:animated:` method instead.
 
 设置地理坐标也就是用户位置被跟踪。
 
 默认情况下，这个属性被设置为无效的坐标，表示没有目标。当然在跟踪模式下，目标构成了中视两个焦点之一，另一个是用户位置标注。通常情况下，这个属性被设置为在实时导航场景目的地或航点。当用户标注向目标移动，地图自动放大到视域范围内最适合用于两个焦点。
 
 如果此属性没有任何效果userTrackingMode属性设置为以外的值MGLUserTrackingModeFollowWithCourse。
 
 更改此属性的值更新与动画过渡地图视图。如果您不想动画的变化，使用 -setTargetCoordinate:animated:的方法来代替。
 

 */
@property (nonatomic, assign) CLLocationCoordinate2D targetCoordinate;

/**
 Sets the geographic coordinate that is the subject of observation as the user
 location is being tracked, with an optional transition animation.
 
 By default, the target coordinate is set to an invalid coordinate, indicating
 that there is no target. In course tracking mode, the target forms one of two
 foci in the viewport, the other being the user location annotation. Typically,
 the target is set to a destination or waypoint in a real-time navigation scene.
 As the user annotation moves toward the target, the map automatically zooms in
 to fit both foci optimally within the viewport.
 
 This method has no effect if the `userTrackingMode` property is set to a value
 other than `MGLUserTrackingModeFollowWithCourse`.
 
 @param targetCoordinate The target coordinate to fit within the viewport.
 @param animated If `YES`, the map animates to fit the target within the map
    view. If `NO`, the map fits the target instantaneously.
 
 设置地理坐标为用户位置的主体被跟踪，可选过渡动画。
 
 默认情况下，目标坐标被设定为无效的坐标，这表明没有目标。当然在跟踪模式下，目标构成了中视两个焦点之一，另一个是用户位置标注。通常，目标被设置为在一个实时导航场景目的地或航点。当用户注释向目标移动，地图自动放大到视域范围内最适合用于两个焦点。
 
 如果这个方法无效userTrackingMode属性被设定为比其他的值MGLUserTrackingModeFollowWithCourse。
 
 @param targetCoordinate 目标坐标。
 @param animated 如果YES，地图以动画模式移动到地图视图中的适合目标。如果NO，在地图上目标瞬间移动到位置。

 
 */
- (void)setTargetCoordinate:(CLLocationCoordinate2D)targetCoordinate animated:(BOOL)animated;

#pragma mark Configuring How the User Interacts with the Map 配置用户如何与地图进行交互

/**
 A Boolean value that determines whether the user may zoom the map in and
 out, changing the zoom level.
 
 When this property is set to `YES`, the default, the user may zoom the map
 in and out by pinching two fingers or by double tapping, holding, and moving
 the finger up and down.
 
 This property controls only user interactions with the map. If you set the
 value of this property to `NO`, you may still change the map zoom
 programmatically.
 
 一个布尔值，确定用户是否可以缩放地图，改变缩放级别。
 
 当该属性被设置为YES，在默认情况下，用户可通过手势放大和缩小地图。
 
 此属性控制仅在地图的用户交互。如果设置该属性的值NO，你还可以改变地图的缩放方式。
 */
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;

/**
 A Boolean value that determines whether the user may scroll around the map,
 changing the center coordinate.
 
 When this property is set to `YES`, the default, the user may scroll the map
 by dragging or swiping with one finger.
 
 This property controls only user interactions with the map. If you set the
 value of this property to `NO`, you may still change the map location
 programmatically.
 
 一个布尔值，确定用户是否可以滚动地图，改变中心坐标。
 
 当此属性设置为YES，默认的，用户可以通过拖动或用一个手指滑动滚动地图。
 
 此属性控制仅在地图的用户交互。如果设置该属性的值NO，你还可以改变地图上的位置方式。
 */
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

/**
 A Boolean value that determines whether the user may rotate the map,
 changing the direction.
 
 When this property is set to `YES`, the default, the user may rotate the map
 by moving two fingers in a circular motion.
 
 This property controls only user interactions with the map. If you set the
 value of this property to `NO`, you may still rotate the map
 programmatically.
 
 一个布尔值，确定用户是否可以旋转地图，改变的方向。
 
 当此属性设置为YES，默认的，用户可以通过在圆周运动两个手指移动旋转地图。
 
 此属性控制仅在地图的用户交互。如果将此属性设置为值NO，您仍然可以通过编程旋转地图。
 */
@property(nonatomic, getter=isRotateEnabled) BOOL rotateEnabled;

/**
 A Boolean value that determines whether the user may change the pitch (tilt) of
 the map.
 
 When this property is set to `YES`, the default, the user may tilt the map by
 vertically dragging two fingers.
 
 This property controls only user interactions with the map. If you set the
 value of this property to `NO`, you may still change the pitch of the map
 programmatically.
 
 The default value of this property is `YES`.
 
 一个布尔值，确定用户是否可以改变地图的间距（倾斜）。
 
 当此属性设置为YES，默认的，用户可以通过垂直拖移两个手指倾斜地图。
 
 此属性控制仅在地图的用户交互。如果设置该属性的值NO，你还可以改变地图的间距方式。
 
 此属性的默认值是YES。
 */
@property(nonatomic, getter=isPitchEnabled) BOOL pitchEnabled;

/**
 A floating-point value that determines the rate of deceleration after the user
 lifts their finger.

 Your application can use the `MGLMapViewDecelerationRateNormal` and
 `MGLMapViewDecelerationRateFast` constants as reference points for reasonable
 deceleration rates. `MGLMapViewDecelerationRateImmediate` can be used to
 disable deceleration entirely.
 
 用户后决定减速度的浮点值抬起他们的手指。
 
 您的应用程序可以使用MGLMapViewDecelerationRateNormal和 MGLMapViewDecelerationRateFast常数为合理的减速率的参考点。MGLMapViewDecelerationRateImmediate可用于完全禁用减速。
 */
@property(nonatomic) CGFloat decelerationRate;

#pragma mark Manipulating the Viewpoint 操控视角

/**
 The geographic coordinate at the center of the map view.
 
 Changing the value of this property centers the map on the new coordinate
 without changing the current zoom level.
 
 Changing the value of this property updates the map view immediately. If you
 want to animate the change, use the `-setCenterCoordinate:animated:` method
 instead.
 
 地理坐标地图视图的中心。
 
 更改此属性的值居中协调的新地图不改变当前缩放级别。
 
 更改此属性的值将立即更新地图视图。如果你想动画的变化，使用-setCenterCoordinate:animated:的方法来代替。
 */
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/**
 Changes the center coordinate of the map and optionally animates the change.
 
 Changing the center coordinate centers the map on the new coordinate without
 changing the current zoom level.
 
 @param coordinate The new center coordinate for the map.
 @param animated Specify `YES` if you want the map view to scroll to the new
    location or `NO` if you want the map to display the new location
    immediately.
 
 改变地图的中心坐标和任选动画的变化。
 
 改变中心坐标中心在地图上不改变当前缩放级别的新坐标。

 @param coordinate 新的中心坐标地图。
 @param animated 指定YES，如果你想地图视图滚动到新的位置，或者NO，如果你想地图立即显示新的位置。
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/**
 Changes the center coordinate and zoom level of the map and optionally animates
 the change.
 
 @param centerCoordinate The new center coordinate for the map.
 @param zoomLevel The new zoom level for the map.
 @param animated Specify `YES` if you want the map view to animate scrolling and
    zooming to the new location or `NO` if you want the map to display the new
    location immediately.
 
 改变中心坐标和地图的缩放级别和任选动画的变化。
 @param centerCoordinate 新的中心坐标地图。
 @param zoomLevel 新的缩放级别的地图。
 @param animated 指定YES，如果你想地图视图动画滚动和缩放到新的位置，或者NO，如果你想地图立即显示新的位置。
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(double)zoomLevel animated:(BOOL)animated;

/**
 Changes the center coordinate, zoom level, and direction of the map and
 optionally animates the change.
 
 @param centerCoordinate The new center coordinate for the map.
 @param zoomLevel The new zoom level for the map.
 @param direction The new direction for the map, measured in degrees relative to
    true north.
 @param animated Specify `YES` if you want the map view to animate scrolling,
    zooming, and rotating to the new location or `NO` if you want the map to
    display the new location immediately.
 
 改变中心坐标，缩放级别，并在地图上的方向和任选动画的变化。
 
 @param centerCoordinate 新的中心坐标地图。
 @param zoomLevel 新的缩放级别的地图。
 @param direction 在地图的新的方向，相对于真北衡量度。
 @param animated 指定YES，如果你想地图视图动画滚动，缩放和旋转到新的位置，或者NO，如果你想地图立即显示新的位置。

 

 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(double)zoomLevel direction:(CLLocationDirection)direction animated:(BOOL)animated;

/**
 Changes the center coordinate, zoom level, and direction of the map, calling a
 completion handler at the end of an optional animation.
 
 @param centerCoordinate The new center coordinate for the map.
 @param zoomLevel The new zoom level for the map.
 @param direction The new direction for the map, measured in degrees relative to
    true north.
 @param animated Specify `YES` if you want the map view to animate scrolling,
    zooming, and rotating to the new location or `NO` if you want the map to
    display the new location immediately.
 @param completion The block executed after the animation finishes.
 
 变化的中心坐标，缩放级别，并在地图上的方向，要求在一个可选的动画的端部的完成处理程序。
 
 @param centerCoordinate 新的中心坐标地图。
 @param zoomLevel 新的缩放级别的地图。
 @param direction 在地图的新的方向，相对于真北衡量度。
 @param animated 指定YES，如果你想地图视图动画滚动，缩放和旋转到新的位置，或者NO，如果你想地图立即显示新的位置。
 @param completion 在动画完成后的块执行。
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(double)zoomLevel direction:(CLLocationDirection)direction animated:(BOOL)animated completionHandler:(nullable void (^)(void))completion;

/** The zoom level of the receiver.
 
 In addition to affecting the visual size and detail of features on the map,
 the zoom level affects the size of the vector tiles that are loaded. At zoom
 level 0, each tile covers the entire world map; at zoom level 1, it covers ¼
 of the world; at zoom level 2, <sup>1</sup>⁄<sub>16</sub> of the world, and
 so on.
 
 Changing the value of this property updates the map view immediately. If you
 want to animate the change, use the `-setZoomLevel:animated:` method instead.
 
 接收器的缩放级别。
 
 除了 ​​影响的地图上的特征的视觉尺寸和细节，缩放级别影响加载的矢量瓦片的大小。在缩放级别0，每个瓦片覆盖了整个世界地图; 缩放级别为1，它涵盖¼世界; 在缩放级别2，1 / 16个的世界，等等。
 
 更改此属性的值将立即更新地图视图。如果你想动画的变化，使用-setZoomLevel:animated:的方法来代替。
 */
@property (nonatomic) double zoomLevel;

/**
 Changes the zoom level of the map and optionally animates the change.
 
 Changing the zoom level scales the map without changing the current center
 coordinate.
 
 @param zoomLevel The new zoom level for the map.
 @param animated Specify `YES` if you want the map view to animate the change
    to the new zoom level or `NO` if you want the map to display the new
    zoom level immediately.
 
 改变地图的缩放级别和任选动画的变化。
 
 更改缩放级别缩放而不改变当前的中心坐标地图。
 
 @param zoomLevel 新的缩放级别的地图。
 @param animated 指定YES，如果你想地图视图动画换到新的缩放级别，或NO如果你想地图立即显示新的缩放级别。
 

 */
- (void)setZoomLevel:(double)zoomLevel animated:(BOOL)animated;

/**
 * The minimum zoom level at which the map can be shown.
 *
 * Depending on the map view’s aspect ratio, the map view may be prevented
 * from reaching the minimum zoom level, in order to keep the map from
 * repeating within the current viewport.
 *
 * If the value of this property is greater than that of the
 * maximumZoomLevel property, the behavior is undefined.
 *
 * The default minimumZoomLevel is 0.
 
 最低缩放级别可以显示在地图上。
 
 取决于地图视图的长宽比，地图视图可到达最低缩放级别被阻止，以保持地图从当前视口内的重复。
 
 如果这个属性的值比maximumZoomLevel财产较大，其行为是不确定的。
 
 默认minimumZoomLevel是0。
 */
@property (nonatomic) double minimumZoomLevel;

/**
 * The maximum zoom level the map can be shown at.
 *
 * If the value of this property is smaller than that of the
 * minimumZoomLevel property, the behavior is undefined.
 *
 * The default maximumZoomLevel is 20.
 
 最大缩放级别地图上可以显示。
 
 如果这个属性的值比minimumZoomLevel财产越小，行为是不确定的。
 
 默认maximumZoomLevel为20。
 
 */
@property (nonatomic) double maximumZoomLevel;

/**
 The heading of the map, measured in degrees clockwise from true north.
 
 The value `0` means that the top edge of the map view corresponds to true
 north. The value `90` means the top of the map is pointing due east. The
 value `180` means the top of the map points due south, and so on.
 
 Changing the value of this property updates the map view immediately. If you
 want to animate the change, use the `-setDirection:animated:` method instead.
 
 地图的标题，以度为单位从真北顺时针方向旋转。
 
 该值0是指地图视图的顶部边缘对应真北。该值90是指在地图的上方指向正东。该值180是指在地图点正南的顶部，等等。
 
 更改此属性的值将立即更新地图视图。如果你想动画的变化，使用-setDirection:animated:的方法来代替。
 

 */
@property (nonatomic) CLLocationDirection direction;

/**
 Changes the heading of the map and optionally animates the change.
 
 @param direction The heading of the map, measured in degrees clockwise from
    true north.
 @param animated Specify `YES` if you want the map view to animate the change
    to the new heading or `NO` if you want the map to display the new
    heading immediately.
 
 Changing the heading rotates the map without changing the current center
 coordinate or zoom level.
 
 更改地图的标题和可选动画的变化。
 
 改变航向旋转而不改变当前的中心坐标或缩放级别地图。
 @param direction 地图的标题，以度为单位从真北顺时针方向旋转。
 @param animated 指定YES，如果你想地图视图动画换到新的标题，或NO如果你想地图以显示新的航向马上。

 */
- (void)setDirection:(CLLocationDirection)direction animated:(BOOL)animated;

/**
 Resets the map rotation to a northern heading — a `direction` of `0` degrees.
 重置地图旋转到北部的标题-一个direction的0程度。
 */
- (IBAction)resetNorth;

/**
 The coordinate bounds visible in the receiver's viewport.
 
 Changing the value of this property updates the receiver immediately. If you
 want to animate the change, call `-setVisibleCoordinateBounds:animated:`
 instead.
 
 坐标在接收机的视口中可见范围。
 
 更改此属性的值将立即更新接收器。如果你想动画的变化，调用-setVisibleCoordinateBounds:animated: 来代替。
 */
@property (nonatomic) MGLCoordinateBounds visibleCoordinateBounds;

/**
 Changes the receiver’s viewport to fit the given coordinate bounds,
 optionally animating the change.
 
 @param bounds The bounds that the viewport will show in its entirety.
 @param animated Specify `YES` to animate the change by smoothly scrolling
    and zooming or `NO` to immediately display the given bounds.
 
 更改接收器的视口使其符合给定的坐标范围，可选动画的变化。
 @param bounds 该边界视口显示的全部。
 @param animated 指定YES由平滑滚动和缩放，或者以动画的改变NO立即显示给定的范围。
 
 */
- (void)setVisibleCoordinateBounds:(MGLCoordinateBounds)bounds animated:(BOOL)animated;

/**
 Changes the receiver's viewport to fit the given coordinate bounds and
 optionally some additional padding on each side.
 
 @param bounds The bounds that the viewport will show in its entirety.
 @param insets The minimum padding (in screen points) that will be visible
    around the given coordinate bounds.
 @param animated Specify `YES` to animate the change by smoothly scrolling and
    zooming or `NO` to immediately display the given bounds.
 
 改变了接收器的视口使其符合给定的坐标范围和可选每侧一些额外的填充。
 
 @param bounds 该边界视口显示的全部。
 @param insets 最小的填充（以屏幕分）围绕给定的坐标范围，这将是可见的。
 @param animated 指定YES由平滑滚动和缩放，或者以动画的改变NO立即显示给定的范围。
 */
- (void)setVisibleCoordinateBounds:(MGLCoordinateBounds)bounds edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated;

/**
 Changes the receiver's viewport to fit all of the given coordinates and
 optionally some additional padding on each side.
 
 @param coordinates The coordinates that the viewport will show.
 @param count The number of coordinates. This number must not be greater than
    the number of elements in `coordinates`.
 @param insets The minimum padding (in screen points) that will be visible
    around the given coordinate bounds.
 @param animated Specify `YES` to animate the change by smoothly scrolling and
    zooming or `NO` to immediately display the given bounds.
 改变了接收器的视口，以适合所有定坐标和任选每侧一些额外的填充。
 
 @param coordinates 坐标视口将显示。
 @param count 坐标的数量。这个数目必须小于在元件的数量更大coordinates。
 @param insets 最小的填充（以屏幕分）围绕给定的坐标范围，这将是可见的。
 @param animated 指定YES由平滑滚动和缩放，或者以动画的改变NO立即显示给定的范围。

 
 */
- (void)setVisibleCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated;

/**
 Changes the receiver's viewport to fit all of the given coordinates and
 optionally some additional padding on each side.
 
 @param coordinates The coordinates that the viewport will show.
 @param count The number of coordinates. This number must not be greater than
    the number of elements in `coordinates`.
 @param insets The minimum padding (in screen points) that will be visible
    around the given coordinate bounds.
 @param direction The direction to rotate the map to, measured in degrees
    relative to true north.
 @param duration The duration to animate the change in seconds.
 @param function The timing function to animate the change.
 @param completion The block executed after the animation finishes.
 
 改变了接收器的视口，以适合所有定坐标和任选每侧一些额外的填充。
 
 @param coordinates 坐标视口将显示。
 @param count 坐标的数量。这个数目必须小于在元件的数量更大coordinates。
 @param insets 最小的填充（以屏幕分）围绕给定的坐标范围，这将是可见的。
 @param direction 方向旋转地图来，相对于真北衡量度。
 @param duration 的持续时间，以动画，以秒的变化。
 @param function 定时功能动画的变化。
 @param completion 在动画完成后的块执行。
 */
- (void)setVisibleCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count edgePadding:(UIEdgeInsets)insets direction:(CLLocationDirection)direction duration:(NSTimeInterval)duration animationTimingFunction:(nullable CAMediaTimingFunction *)function completionHandler:(nullable void (^)(void))completion;

/**
 Sets the visible region so that the map displays the specified annotations.

 Calling this method updates the value in the `visibleCoordinateBounds` property
 and potentially other properties to reflect the new map region. A small amount
 of padding is reserved around the edges of the map view. To specify a different
 amount of padding, use the `-showAnnotations:edgePadding:animated:` method.

 @param annotations The annotations that you want to be visible in the map.
 @param animated `YES` if you want the map region change to be animated, or `NO`
    if you want the map to display the new region immediately without animations.
 
 设置在可见光区域，使得地图显示指定注释。
 
 调用此方法将更新的价值visibleCoordinateBounds属性和潜在的其他属性，以反映新的地图区域。填充少量围绕地图视图的边缘保留。要指定不同量的填充物，使用-showAnnotations:edgePadding:animated:方法。
 @param annotations 你想要的注解是在地图上是可见的。
 @param animated YES如果你想成为动画地图区域的改变，或者NO 如果你想地图立即显示新的地区没有动画。

 */
- (void)showAnnotations:(NS_ARRAY_OF(id <MGLAnnotation>) *)annotations animated:(BOOL)animated;

/**
 Sets the visible region so that the map displays the specified annotations with
 the specified amount of padding on each side.

 Calling this method updates the value in the visibleCoordinateBounds property
 and potentially other properties to reflect the new map region.

 @param annotations The annotations that you want to be visible in the map.
 @param insets The minimum padding (in screen points) around the edges of the
    map view to keep clear of annotations.
 @param animated `YES` if you want the map region change to be animated, or `NO`
    if you want the map to display the new region immediately without animations.
 
 设置在可见光区域，使得地图显示与填充在每边的规定量的指定的注释。
 
 调用此方法将更新visibleCoordinateBounds属性的值以及可能的其它属性，以反映新的地图区域。
 
 @param annotations 你想要的注解是在地图上是可见的。
 @param insets 最小的填充（以屏幕点）周围的地图视图的边缘以保持清醒的注释。
 @param animated YES如果你想成为动画地图区域的改变，或者NO 如果你想地图立即显示新的地区没有动画
 
 */
- (void)showAnnotations:(NS_ARRAY_OF(id <MGLAnnotation>) *)annotations edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated;

/**
 A camera representing the current viewpoint of the map.
 代表地图的当前视点的摄像机。
 */
@property (nonatomic, copy) MGLMapCamera *camera;

/**
 Moves the viewpoint to a different location with respect to the map with an
 optional transition animation.
 
 @param camera The new viewpoint.
 @param animated Specify `YES` if you want the map view to animate the change to
    the new viewpoint or `NO` if you want the map to display the new viewpoint
    immediately.
 相对于具有一个可选的过渡动画地图移动视点到不同的位置。
 @param camera 新的观点。
 @param animated 指定YES，如果你想地图视图动画变化的新观点或者NO，如果你想地图立即显示新的观点。
 */
- (void)setCamera:(MGLMapCamera *)camera animated:(BOOL)animated;

/**
 Moves the viewpoint to a different location with respect to the map with an
 optional transition duration and timing function.
 
 @param camera The new viewpoint.
 @param duration The amount of time, measured in seconds, that the transition
    animation should take. Specify `0` to jump to the new viewpoint
    instantaneously.
 @param function A timing function used for the animation. Set this parameter to
    `nil` for a transition that matches most system animations. If the duration
    is `0`, this parameter is ignored.
 
 对于一个可选的过渡时间和定时功能移动视点到不同的位置到地图中。
 @param camera 新的观点。
 @param duration 的时间量，以秒为单位，即过渡动画应该采取。指定0跳转到新的观点瞬间。
 @param function 用于动画计时功能。设置此参数 nil的匹配大多数系统的动画过渡。如果持续时间0，则忽略此参数。

 */
- (void)setCamera:(MGLMapCamera *)camera withDuration:(NSTimeInterval)duration animationTimingFunction:(nullable CAMediaTimingFunction *)function;

/**
 Moves the viewpoint to a different location with respect to the map with an
 optional transition duration and timing function.
 
 @param camera The new viewpoint.
 @param duration The amount of time, measured in seconds, that the transition
    animation should take. Specify `0` to jump to the new viewpoint
    instantaneously.
 @param function A timing function used for the animation. Set this parameter to
    `nil` for a transition that matches most system animations. If the duration
    is `0`, this parameter is ignored.
 @param completion The block to execute after the animation finishes.
 
 对于一个可选的过渡时间和定时功能移动视点到不同的位置到地图中。
 @param camera 新的观点。
 @param duration 的时间量，以秒为单位，即过渡动画应该采取。指定0跳转到新的观点瞬间。
 @param function 用于动画计时功能。设置此参数 nil的匹配大多数系统的动画过渡。如果持续时间0，则忽略此参数。
 @param completion 该块在动画完成后执行。
 */
- (void)setCamera:(MGLMapCamera *)camera withDuration:(NSTimeInterval)duration animationTimingFunction:(nullable CAMediaTimingFunction *)function completionHandler:(nullable void (^)(void))completion;

/**
 Moves the viewpoint to a different location using a transition animation that
 evokes powered flight and a default duration based on the length of the flight
 path.
 
 The transition animation seamlessly incorporates zooming and panning to help
 the user find his or her bearings even after traversing a great distance.
 
 @param camera The new viewpoint.
 @param completion The block to execute after the animation finishes.
 
 移动视点到使用该唤起动力飞行以及基于所述飞行路径的长度的默认持续时间的过渡的动画的不同位置。
 
 过渡动画的无缝集成缩放和平移，以帮助用户找到他或她甚至轴承遍历一个很大的距离之后。
 @param camera 新的观点。
 @param completion 该块在动画完成后执行。

 */
- (void)flyToCamera:(MGLMapCamera *)camera completionHandler:(nullable void (^)(void))completion;

/**
 Moves the viewpoint to a different location using a transition animation that
 evokes powered flight and an optional transition duration.
 
 The transition animation seamlessly incorporates zooming and panning to help
 the user find his or her bearings even after traversing a great distance.
 
 @param camera The new viewpoint.
 @param duration The amount of time, measured in seconds, that the transition
    animation should take. Specify `0` to jump to the new viewpoint
    instantaneously. Specify a negative value to use the default duration, which
    is based on the length of the flight path.
 @param completion The block to execute after the animation finishes.
 
 移动视点到使用该唤起动力飞行和可选的过渡时间的过渡的动画的不同位置。
 
 过渡动画的无缝集成缩放和平移，以帮助用户找到他或她甚至轴承遍历一个很大的距离之后。
 
 @param camera 新的观点。
 @param duration 的时间量，以秒为单位，即过渡动画应该采取。指定0跳转到新的观点瞬间。指定要使用的默认的持续时间，这是基于对飞行路径的长度为负值。
 @param completion 该块在动画完成后执行。
 
 */
- (void)flyToCamera:(MGLMapCamera *)camera withDuration:(NSTimeInterval)duration completionHandler:(nullable void (^)(void))completion;

/**
 Moves the viewpoint to a different location using a transition animation that
 evokes powered flight and an optional transition duration and peak altitude.
 
 The transition animation seamlessly incorporates zooming and panning to help
 the user find his or her bearings even after traversing a great distance.
 
 @param camera The new viewpoint.
 @param duration The amount of time, measured in seconds, that the transition
    animation should take. Specify `0` to jump to the new viewpoint
    instantaneously. Specify a negative value to use the default duration, which
    is based on the length of the flight path.
 @param peakAltitude The altitude, measured in meters, at the midpoint of the
    animation. The value of this parameter is ignored if it is negative or if
    the animation transition resulting from a similar call to
    `-setCamera:animated:` would have a midpoint at a higher altitude.
 @param completion The block to execute after the animation finishes.
 
 移动视点到使用该唤起动力飞行和可选的过渡时间和峰高度的过渡的动画的不同位置。
 
 过渡动画的无缝集成缩放和平移，以帮助用户找到他或她甚至轴承遍历一个很大的距离之后。
 
 @param camera 新的观点。
 @param duration 的时间量，以秒为单位，即过渡动画应该采取。指定0跳转到新的观点瞬间。指定要使用的默认的持续时间，这是基于对飞行路径的长度为负值。
 @param peakAltitude 高度，以米为单位，在动画的中点。如果它是负或该参数的值被忽略，如果从一个类似呼叫产生的动画过渡到 -setCamera:animated:将在更高的高度有一个中点。
 @param completion 该块在动画完成后执行。
 

 */
- (void)flyToCamera:(MGLMapCamera *)camera withDuration:(NSTimeInterval)duration peakAltitude:(CLLocationDistance)peakAltitude completionHandler:(nullable void (^)(void))completion;

/**
 Returns the camera that best fits the given coordinate bounds.
 
 @param bounds The coordinate bounds to fit to the receiver’s viewport.
 @return A camera object centered on the same location as the coordinate
    bounds with zoom level as high (close to the ground) as possible while still
    including the entire coordinate bounds. The camera object uses the current
    direction and pitch.
 
 返回最符合给定的坐标范围相机。
 @param bounds 坐标范围以适应接收机的视口。
 @return 集中在相同的位置坐标范围与缩放级别高（接近地）尽可能同时还包括整个坐标范围的摄像机对象。该相机对象使用电流方向和俯仰。

 */

- (MGLMapCamera *)cameraThatFitsCoordinateBounds:(MGLCoordinateBounds)bounds;

/**
 Returns the camera that best fits the given coordinate bounds, optionally with
 some additional padding on each side.
 
 @param bounds The coordinate bounds to fit to the receiver’s viewport.
 @param insets The minimum padding (in screen points) that would be visible
    around the returned camera object if it were set as the receiver’s camera.
 @return A camera object centered on the same location as the coordinate bounds
    with zoom level as high (close to the ground) as possible while still
    including the entire coordinate bounds. The camera object uses the current
    direction and pitch.
 
 返回最适合给定的坐标范围，任选地与在每边的一些额外的填充相​​机。
 @param bounds 坐标范围以适应接收机的视口。
 @param insets 最小的填充（以屏幕分），如果它被设置为接收器的相机，将是各地返回的摄像头对象可见。
 @return 集中在相同的位置坐标范围与缩放级别高（接近地）尽可能同时还包括整个坐标范围的摄像机对象。该相机对象使用电流方向和俯仰。

 */
- (MGLMapCamera *)cameraThatFitsCoordinateBounds:(MGLCoordinateBounds)bounds edgePadding:(UIEdgeInsets)insets;

/**
 Returns the point in this view's coordinate system on which to "anchor" in
 response to a user-initiated gesture.
 
 For example, a pinch-to-zoom gesture would anchor the map at the midpoint of
 the pinch.
 
 If the `userTrackingMode` property is not `MGLUserTrackingModeNone`, the
 user annotation is used as the anchor point.
 
 Subclasses may override this method to provide specialized behavior - for
 example, anchoring on the map's center point to provide a "locked" zooming
 mode.
 
 @param gesture An anchorable user gesture.
 @return The point on which to anchor in response to the gesture.
 
 返回该视图的坐标系在其上的点锚响应于用户发起的手势。
 
 例如，捏到缩放手势将停泊在捏的中点地图。
 
 如果userTrackingMode属性不是MGLUserTrackingModeNone，用户注释被用作锚点。
 
 子类可以重写此方法来提供专业化的行为-例如，在地图上的中心点锚提供了锁定缩放模式。
 
 @param gesture 一个anchorable用户手势。
 @return 在其上点响应于所述姿态来锚定。
 */
- (CGPoint)anchorPointForGesture:(UIGestureRecognizer *)gesture;

/**
 The distance from the edges of the map view’s frame to the edges of the map
 view’s logical viewport.
 
 When the value of this property is equal to `UIEdgeInsetsZero`, viewport
 properties such as `centerCoordinate` assume a viewport that matches the map
 view’s frame. Otherwise, those properties are inset, excluding part of the
 frame from the viewport. For instance, if the only the top edge is inset, the
 map center is effectively shifted downward.
 
 When the map view’s superview is an instance of `UIViewController` whose
 `automaticallyAdjustsScrollViewInsets` property is `YES`, the value of this
 property may be overridden at any time.
 
 Changing the value of this property updates the map view immediately. If you
 want to animate the change, use the `-setContentInset:animated:` method
 instead.
 
 从地图视图的框架的地图视图的逻辑视口的边缘上的边缘的距离。
 
 当此属性的值等于UIEdgeInsetsZero，视性质，例如centerCoordinate假设地图视图的框架相匹配的视口。否则，这些属性将插图，不包括视口框架的一部分。例如，如果唯一的上边缘插入图示，地图中心被有效地向下移动。
 
 当地图视图的上海华是一个实例UIViewController，其 automaticallyAdjustsScrollViewInsets属性YES，此属性的值可以在任何时候被覆盖。
 
 更改此属性的值将立即更新地图视图。如果你想动画的变化，使用-setContentInset:animated:的方法来代替。
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 Sets the distance from the edges of the map view’s frame to the edges of the
 map view’s logical viewport with an optional transition animation.
 
 When the value of this property is equal to `UIEdgeInsetsZero`, viewport
 properties such as `centerCoordinate` assume a viewport that matches the map
 view’s frame. Otherwise, those properties are inset, excluding part of the
 frame from the viewport. For instance, if the only the top edge is inset, the
 map center is effectively shifted downward.
 
 When the map view’s superview is an instance of `UIViewController` whose
 `automaticallyAdjustsScrollViewInsets` property is `YES`, the value of this
 property may be overridden at any time.
 
 @param contentInset The new values to inset the content by.
 @param animated Specify `YES` if you want the map view to animate the change to
    the content inset or `NO` if you want the map to inset the content
    immediately.
 
 设置从地图视图的帧到地图视图的逻辑视口的边缘的边缘与一个可选过渡动画的距离。
 
 当此属性的值等于UIEdgeInsetsZero，视性质，例如centerCoordinate假设地图视图的框架相匹配的视口。否则，这些属性将插图，不包括视口框架的一部分。例如，如果唯一的上边缘插入图示，地图中心被有效地向下移动。
 
 当地图视图的上海华是一个实例UIViewController，其 automaticallyAdjustsScrollViewInsets属性YES，此属性的值可以在任何时候被覆盖。
 
 @param contentInset 新值由插图内容。
 @param animated 指定YES，如果你想地图视图动画变化的内容嵌入或者NO，如果你想地图立即插图的内容。
 */
- (void)setContentInset:(UIEdgeInsets)contentInset animated:(BOOL)animated;

#pragma mark Converting Geographic Coordinates 转换地理坐标

/**
 Converts a point in the given view's coordinate system to a geographic
 coordinate.
 
 @param point The point to convert.
 @param view The view in whose coordinate system the point is expressed.
 @return The geographic coordinate at the given point.
 
 转换给定的视图的坐标系中，以地理坐标的点。
 @param point 要转换的点。
 @param view 在其坐标系统中的点表示的看法。
 @return 地理坐标在指定点。

 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(nullable UIView *)view;

/**
 Converts a geographic coordinate to a point in the given view's coordinate
 system.
 
 @param coordinate The geographic coordinate to convert.
 @param view The view in whose coordinate system the returned point should be
    expressed. If this parameter is `nil`, the returned point is expressed
    in the window's coordinate system. If `view` is not `nil`, it must
    belong to the same window as the map view.
 @return The point (in the appropriate view or window coordinate system)
    corresponding to the given geographic coordinate.
 
 转换地理坐标到指定视图的坐标系中的一个点。
 
 @param coordinate 地理坐标转换。
 @param view 在其坐标系统返回的点应该表达的观点。如果这个参数是nil，返回的点窗口的坐标系中表示。如果view不是nil，则必须属于同一窗口作为地图视图。
 @return 对应于给定地理点（相应的视图或窗口坐标系中的）坐标。

 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable UIView *)view;

/**
 Converts a rectangle in the given view’s coordinate system to a geographic
 bounding box.
 
 @param rect The rectangle to convert.
 @param view The view in whose coordinate system the rectangle is expressed.
 @return The geographic bounding box coextensive with the given rectangle.
 
 给定视图的坐标系中地理边框的矩形转换。
 @param rect 矩形进行转换。
 @param view 在其坐标系统中的矩形表达的观点。
 @return 地理边界框同延指定的矩形。
 */
- (MGLCoordinateBounds)convertRect:(CGRect)rect toCoordinateBoundsFromView:(nullable UIView *)view;

/**
 Converts a geographic bounding box to a rectangle in the given view’s
 coordinate system.
 
 @param bounds The geographic bounding box to convert.
 @param view The view in whose coordinate system the returned rectangle should
    be expressed. If this parameter is `nil`, the returned rectangle is
    expressed in the window’s coordinate system. If `view` is not `nil`, it must
    belong to the same window as the map view.
 地理边界框转换为给定的视图坐标系统中的矩形。
 @param 地理边界框转换。
 @param view 在其坐标系统返回的矩形应该表达的观点。如果这个参数是nil，返回的矩形窗口的坐标系中表示。如果view不是nil，则必须属于同一窗口作为地图视图。
 */
- (CGRect)convertCoordinateBounds:(MGLCoordinateBounds)bounds toRectToView:(nullable UIView *)view;

/**
 Returns the distance spanned by one point in the map view's coordinate system
 at the given latitude and current zoom level.
 
 The distance between points decreases as the latitude approaches the poles.
 This relationship parallels the relationship between longitudinal coordinates
 at different latitudes.
 
 @param latitude The latitude of the geographic coordinate represented by the
    point.
 @return The distance in meters spanned by a single point.
 
 返回地图中的一个点跨越的距离观看的坐标系统在给定的纬度和当前缩放级别。
 
 点之间的距离减小的纬度接近磁极。这种关系平行不同纬度经度坐标之间的关系。
 
 @param 地理纬度坐标由点表示。
 @return 在由单点跨越米的距离。

 */
- (CLLocationDistance)metersPerPointAtLatitude:(CLLocationDegrees)latitude;

- (CLLocationDistance)metersPerPixelAtLatitude:(CLLocationDegrees)latitude __attribute__((deprecated("Use -metersPerPointAtLatitude:.")));

#pragma mark Annotating the Map 标注地图

/**
 The complete list of annotations associated with the receiver. (read-only)
 
 The objects in this array must adopt the `MGLAnnotation` protocol. If no
 annotations are associated with the map view, the value of this property is
 `nil`.
 
 与接收器相关联的注释的完整列表。（只读）
 
 此数组中的对象必须采取MGLAnnotation协议。如果没有注解与地图视图关联，这个属性的值 nil。
 */
@property (nonatomic, readonly, nullable) NS_ARRAY_OF(id <MGLAnnotation>) *annotations;

/**
 Adds an annotation to the map view.
 
 @note `MGLMultiPolyline`, `MGLMultiPolygon`, and `MGLShapeCollection` objects
    cannot be added to the map view at this time. Nor can `MGLMultiPoint`
    objects that are not instances of `MGLPolyline` or `MGLPolygon`. Any
    multipoint, multipolyline, multipolygon, or shape collection object that is
    specified is silently ignored.
 
 @param annotation The annotation object to add to the receiver. This object
    must conform to the `MGLAnnotation` protocol. The map view retains the
    annotation object. 
 
 添加标注到地图视图。
 @note MGLMultiPolyline，MGLMultiPolygon和MGLShapeCollection对象不能被添加到此时的地图视图。也不能MGLMultiPoint 认为是不实例的对象MGLPolyline或MGLPolygon。被指定的任何点对多点，multipolyline，多面，或形状集合对象被忽略。
 
 @param annotation 注解对象添加到接收器。这个对象必须符合MGLAnnotation协议。地图视图保留注释对象。
 */
- (void)addAnnotation:(id <MGLAnnotation>)annotation;

/**
 Adds an array of annotations to the map view.
 
 @note `MGLMultiPolyline`, `MGLMultiPolygon`, and `MGLShapeCollection` objects
    cannot be added to the map view at this time. Nor can `MGLMultiPoint`
    objects that are not instances of `MGLPolyline` or `MGLPolygon`. Any
    multipoint, multipolyline, multipolygon, or shape collection objects that
    are specified are silently ignored.
 
 @param annotations An array of annotation objects. Each object in the array
    must conform to the `MGLAnnotation` protocol. The map view retains each
    individual annotation object.
 
 注释添加到地图视图的数组。
 
 @note MGLMultiPolyline，MGLMultiPolygon和MGLShapeCollection对象不能被添加到此时的地图视图。也不能MGLMultiPoint 认为是不实例的对象MGLPolyline或MGLPolygon。是指定的任何点对多点，multipolyline，多面，或形状集合对象会被忽略。
 @param annotations 注释对象的数组。数组中的每个对象必须符合MGLAnnotation协议。地图视图保留每个注释对象。
 */
- (void)addAnnotations:(NS_ARRAY_OF(id <MGLAnnotation>) *)annotations;

/**
 Removes an annotation from the map view, deselecting it if it is selected.
 
 Removing an annotation object dissociates it from the map view entirely,
 preventing it from being displayed on the map. Thus you would typically call
 this method only when you want to hide or delete a given annotation.
 
 @param annotation The annotation object to remove. This object must conform
    to the `MGLAnnotation` protocol
 
 从地图中删除视图注释，如果它被选中它取消。
 
 删除注释对象从地图上看它离解完全，防止它被显示在地图上。因此，当你要隐藏或删除一个给定的注释，你会通常只调用此方法。
 
 @param annotation 注释对象删除。此对象必须符合MGLAnnotation协议

 */
- (void)removeAnnotation:(id <MGLAnnotation>)annotation;

/**
 Removes an array of annotations from the map view, deselecting any selected
 annotations in the array.
 
 Removing annotation objects dissociates them from the map view entirely,
 preventing them from being displayed on the map. Thus you would typically
 call this method only when you want to hide or delete the given annotations.
 
 @param annotations The array of annotation objects to remove. Objects in the
    array must conform to the `MGLAnnotation` protocol.
 
 从地图中删除视图注释，取消阵列中任意选定批注的数组。
 
 删除注释对象从地图上看离解他们完全，防止它们被显示在地图上。因此，当你要隐藏或删除指定的注解，你会通常只调用此方法。
 
 @param annotations 注释对象的阵列除去。数组中的对象必须符合MGLAnnotation协议。
 */
- (void)removeAnnotations:(NS_ARRAY_OF(id <MGLAnnotation>) *)annotations;

/**
 Returns an `MGLAnnotationView` if the given annotation is currently associated
 with a view, otherwise nil.
 
 @param annotation The annotation associated with the view. 
    Annotation must conform to the `MGLAnnotation` protocol.
 
 返回MGLAnnotationView如果给定的注释当前与视图相关联，否则为零。
 
 @param annotation 与视图相关联的注释。注释必须符合MGLAnnotation协议
 */
- (nullable MGLAnnotationView *)viewForAnnotation:(id <MGLAnnotation>)annotation;

/**
 Returns a reusable annotation image object associated with its identifier.
 
 For performance reasons, you should generally reuse `MGLAnnotationImage`
 objects for identical-looking annotations in your map views. Dequeueing
 saves time and memory during performance-critical operations such as
 scrolling.
 
 @param identifier A string identifying the annotation image to be reused.
    This string is the same one you specify when initially returning the
    annotation image object using the `-mapView:imageForAnnotation:` method.
 @return An annotation image object with the given identifier, or `nil` if no
    such object exists in the reuse queue.
 
 返回其标识符相关联的可重复使用的注解图像对象。
 
 出于性能方面的考虑，通常应重用MGLAnnotationImage 在你的地图视图寻找相同的注解对象。出队在性能关键的操作，如滚动节省时间和内存。
 
 @param identifier 标识标注图像的字符串被重用。这个字符串就是你在使用最初返回注解图像对象指定的同一个-mapView:imageForAnnotation:方法。
 @return 具有给定标识符的注释图像对象，或者nil如果没有这样的对象中的重用队列存在。

 */
- (nullable __kindof MGLAnnotationImage *)dequeueReusableAnnotationImageWithIdentifier:(NSString *)identifier;

/**
 Returns a reusable annotation view object associated with its identifier.
 
 For performance reasons, you should generally reuse `MGLAnnotationView`
 objects for identical-looking annotations in your map views. Dequeueing
 saves time and memory during performance-critical operations such as
 scrolling.
 
 @param identifier A string identifying the annotation view to be reused.
    This string is the same one you specify when initially returning the
    annotation view object using the `-mapView:viewForAnnotation:` method.
 @return An annotation view object with the given identifier, or `nil` if no
    such object exists in the reuse queue.
 
 返回其标识符相关联的可重复使用的注解视图对象。
 
 出于性能方面的考虑，通常应重用MGLAnnotationView 在你的地图视图寻找相同的注解对象。出队在性能关键的操作，如滚动节省时间和内存。
 
 @param 标识标注视图的字符串被重用。这个字符串就是你在使用最初返回注解视图对象指定的同一个-mapView:viewForAnnotation:方法。
 @return 与给定的标识符注释视图对象，nil如果没有这样的对象重用队列存在。

 */
- (nullable __kindof MGLAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

#pragma mark Managing Annotation Selections 管理标识选择

/**
 The currently selected annotations.
 
 Assigning a new array to this property selects only the first annotation in
 the array.
 
 当前选择的注解。
 
 分配一个新的数组，这个属性只选择数组中的第一个注释。
 */
@property (nonatomic, copy) NS_ARRAY_OF(id <MGLAnnotation>) *selectedAnnotations;

/**
 Selects an annotation and displays a callout view for it.
 
 If the given annotation is not visible within the current viewport, this
 method has no effect.
 
 @param annotation The annotation object to select.
 @param animated If `YES`, the callout view is animated into position.
 
 选择一个注释，并显示其标注视图。
 
 如果给定的注释是不是当前视口中可见，这种方法没有任何效果。
 
 @param annotation 注释对象进行选择。
 @param animated 如果YES，标注视图动画到位。

 
 */
- (void)selectAnnotation:(id <MGLAnnotation>)annotation animated:(BOOL)animated;

/**
 Deselects an annotation and hides its callout view.
 
 @param annotation The annotation object to deselect.
 @param animated If `YES`, the callout view is animated offscreen.
 
 取消选择注释并隐藏其标注视图。
 @param annotation 注释对象取消选择。
 @param animated 如果YES，标注视图动画屏幕外。
 
 */
- (void)deselectAnnotation:(nullable id <MGLAnnotation>)annotation animated:(BOOL)animated;

#pragma mark Overlaying the Map 叠加图层

/**
 Adds a single overlay object to the map.
 
 To remove an overlay from a map, use the `-removeOverlay:` method.
 
 @param overlay The overlay object to add. This object must conform to the
    `MGLOverlay` protocol. 
 将单个覆盖对象到地图中。
 
 从地图上删除叠加，使用-removeOverlay:方法。
 
 @param overlay 覆盖对象的补充。这个对象必须符合 MGLOverlay协议。

 
 */
- (void)addOverlay:(id <MGLOverlay>)overlay;

/**
 Adds an array of overlay objects to the map.
 
 To remove multiple overlays from a map, use the `-removeOverlays:` method.
 
 @param overlays An array of objects, each of which must conform to the
    `MGLOverlay` protocol.
 
 添加覆盖对象的数组到地图中。
 
 要从地图移除多个覆盖，使用-removeOverlays:方法。
 
 @param overlays 对象数组，每个都必须符合 MGLOverlay协议。

 */
- (void)addOverlays:(NS_ARRAY_OF(id <MGLOverlay>) *)overlays;

/**
 Removes a single overlay object from the map.
 
 If the specified overlay is not currently associated with the map view, this
 method does nothing.
 
 @param overlay The overlay object to remove.
 
 从地图中删除单个叠加层对象。
 
 如果指定覆盖当前没有与地图视图关联，此方法不起作用。
 @param overlay 覆盖对象删除。
 */
- (void)removeOverlay:(id <MGLOverlay>)overlay;

/**
 Removes one or more overlay objects from the map.
 
 If a given overlay object is not associated with the map view, it is ignored.
 
 @param overlays An array of objects, each of which conforms to the `MGLOverlay`
    protocol.
 
 从地图中删除一个或多个覆盖对象。
 
 如果给定的覆盖对象与地图视图关联，它将被忽略。
 
 @param overlays 对象的数组，其中每个符合MGLOverlay 协议。 
 */
- (void)removeOverlays:(NS_ARRAY_OF(id <MGLOverlay>) *)overlays;

#pragma mark Accessing the Underlying Map Data 访问基础地图数据

/**
 Returns an array of rendered map features that intersect with a given point.
 
 This method may return features from any of the map’s style layers. To restrict
 the search to a particular layer or layers, use the
 `-visibleFeaturesAtPoint:inStyleLayersWithIdentifiers:` method. For more
 information about searching for map features, see that method’s documentation.
 
 @param point A point expressed in the map view’s coordinate system.
 @return An array of objects conforming to the `MGLFeature` protocol that
    represent features in the sources used by the current style.
 
 返回与给定相交点呈现的地图功能的阵列。
 
 这种方法可以从任何地图的风格层的返回功能。要限制搜索到特定的一层或多层，使用 -visibleFeaturesAtPoint:inStyleLayersWithIdentifiers:方法。有关搜索地图功能的详细信息，请参阅该方法的文档。
 
 @param point 地图视图的坐标系中所表达的点。
 @return 符合对象数组MGLFeature协议表示在由当前样式中使用的源的功能。
 */
- (NS_ARRAY_OF(id <MGLFeature>) *)visibleFeaturesAtPoint:(CGPoint)point NS_SWIFT_NAME(visibleFeatures(at:));

/**
 Returns an array of rendered map features that intersect with a given point,
 restricted to the given style layers.
 
 Each object in the returned array represents a feature rendered by the
 current style and provides access to attributes specified by the relevant
 <a href="https://www.mapbox.com/mapbox-gl-style-spec/#sources">tile sources</a>.
 The returned array includes features specified in vector and GeoJSON tile
 sources but does not include anything from raster, image, or video sources.
 
 Only visible features are returned. For example, suppose the current style uses
 the
 <a href="https://www.mapbox.com/vector-tiles/mapbox-streets/">Mapbox Streets source</a>,
 but none of the specified style layers includes features that have the `maki`
 property set to `bus`. If you pass a point corresponding to the location of a
 bus stop into this method, the bus stop feature does not appear in the
 resulting array. On the other hand, if the style does include bus stops, an
 `MGLFeature` object representing that bus stop is returned and its
 `featureAttributes` dictionary has the `maki` key set to `bus` (along with
 other attributes). The dictionary contains only the attributes provided by the
 tile source; it does not include computed attribute values or rules about how
 the feature is rendered by the current style.
 
 The returned array is sorted by z-order, starting with the topmost rendered
 feature and ending with the bottommost rendered feature. A feature that is
 rendered multiple times due to wrapping across the antimeridian at low zoom
 levels is included only once, subject to the caveat that follows.
 
 Features come from tiled vector data or GeoJSON data that is converted to tiles
 internally, so feature geometries are clipped at tile boundaries and features
 may appear duplicated across tiles. For example, suppose the specified point
 lies along a road that spans the screen. The resulting array includes those
 parts of the road that lie within the map tile that contain the specified
 point, even if the road extends into other tiles.
 
 To find out the layer names in a particular style, view the style in
 <a href="https://www.mapbox.com/studio/">Mapbox Studio</a>.
 
 @param point A point expressed in the map view’s coordinate system.
 @param styleLayerIdentifiers A set of strings that correspond to the names of
    layers defined in the current style. Only the features contained in these
    layers are included in the returned array.
 @return An array of objects conforming to the `MGLFeature` protocol that
    represent features in the sources used by the current style.
 
 返回与给定相交点呈现地图功能，限于给定的风格层的数组。
 
 返回数组中的每个对象代表由当前样式呈现的功能，并提供了访问由相关指定的属性 瓦来源。返回的数组包括矢量和GeoJSON的瓷砖来源中指定的功能，但不包括栅格图像或视频源东西。
 
 唯一可见的特性被返回。例如，假设当前样式使用 Mapbox街道源，但没有指定样式层包括具有的功能maki 属性设置为bus。如果传递相应的一个公交车站的位置，这个方法的一个点，公交车站的功能不会出现在结果数组中为止。在另一方面，如果样式不包括公交车站，一个 MGLFeature是返回一个表示那个公交车站对象和它的 featureAttributes字典里的maki键值设 ​​为bus（与其他属性一起）。这本词典只包含了瓷砖源提供的属性; 它不包括有关如何特征是由当前样式呈现的计算属性值或规则。
 
 返回的数组由z顺序进行排序，从最上面的渲染功能和最底部的渲染功能结局。这是由于跨在低缩放级别子午线包装呈现多次的特征是包括只有一次，受到下面的警告。
 
 特征来自平铺矢量数据或转换为砖内部以GeoJSON数据，所以要素几何是在小块边界和特征裁剪可跨越瓦片出现重复。例如，假设指定点沿着跨越屏幕道路所在。所得阵列包括位于包含指定点的地图瓦片内的道路的那些部分，即使道路延伸到其他砖。
 
 要找出一个特定样式的图层名称，查看风格 Mapbox工作室。
 
 @param point 地图视图的坐标系中所表达的点。
 @param styleLayerIdentifiers 一组对应于当前的样式定义层的名称的字符串。只有包含在这些层的功能都包含在返回数组中为止。
 @return 符合对象数组MGLFeature协议表示在由当前样式中使用的源的功能。
 
 
 */
- (NS_ARRAY_OF(id <MGLFeature>) *)visibleFeaturesAtPoint:(CGPoint)point inStyleLayersWithIdentifiers:(nullable NS_SET_OF(NSString *) *)styleLayerIdentifiers NS_SWIFT_NAME(visibleFeatures(at:styleLayerIdentifiers:));

/**
 Returns an array of rendered map features that intersect with the given
 rectangle.
 
 This method may return features from any of the map’s style layers. To restrict
 the search to a particular layer or layers, use the
 `-visibleFeaturesAtPoint:inStyleLayersWithIdentifiers:` method. For more
 information about searching for map features, see that method’s documentation.
 
 @param rect A rectangle expressed in the map view’s coordinate system.
 @return An array of objects conforming to the `MGLFeature` protocol that
    represent features in the sources used by the current style.
 
 返回与给定矩形相交呈现地图功能的阵列。
 
 这种方法可以从任何地图的风格层的返回功能。要限制搜索到特定的一层或多层，使用 -visibleFeaturesAtPoint:inStyleLayersWithIdentifiers:方法。有关搜索地图功能的详细信息，请参阅该方法的文档。
 
 @param rect 地图视图的坐标系中所表达的矩形。
 @return 符合对象数组MGLFeature协议表示在由当前样式中使用的源的功能。
 */
- (NS_ARRAY_OF(id <MGLFeature>) *)visibleFeaturesInRect:(CGRect)rect NS_SWIFT_NAME(visibleFeatures(in:));

/**
 Returns an array of rendered map features that intersect with the given
 rectangle, restricted to the given style layers.
 
 Each object in the returned array represents a feature rendered by the
 current style and provides access to attributes specified by the relevant
 <a href="https://www.mapbox.com/mapbox-gl-style-spec/#sources">tile sources</a>.
 The returned array includes features specified in vector and GeoJSON tile
 sources but does not include anything from raster, image, or video sources.
 
 Only visible features are returned. For example, suppose the current style uses
 the
 <a href="https://www.mapbox.com/vector-tiles/mapbox-streets/">Mapbox Streets source</a>,
 but none of the specified style layers includes features that have the `maki`
 property set to `bus`. If you pass a rectangle containing the location of a bus
 stop into this method, the bus stop feature does not appear in the resulting
 array. On the other hand, if the style does include bus stops, an `MGLFeature`
 object representing that bus stop is returned and its `featureAttributes`
 dictionary has the `maki` key set to `bus` (along with other attributes). The
 dictionary contains only the attributes provided by the tile source; it does
 not include computed attribute values or rules about how the feature is
 rendered by the current style.
 
 The returned array is sorted by z-order, starting with the topmost rendered
 feature and ending with the bottommost rendered feature. A feature that is
 rendered multiple times due to wrapping across the antimeridian at low zoom
 levels is included only once, subject to the caveat that follows.
 
 Features come from tiled vector data or GeoJSON data that is converted to tiles
 internally, so feature geometries are clipped at tile boundaries and features
 may appear duplicated across tiles. For example, suppose the specified
 rectangle intersects with a road that spans the screen. The resulting array
 includes those parts of the road that lie within the map tiles covering the
 specified rectangle, even if the road extends into other tiles. The portion of
 the road within each map tile is included individually.
 
 To find out the layer names in a particular style, view the style in
 <a href="https://www.mapbox.com/studio/">Mapbox Studio</a>.
 
 @param rect A rectangle expressed in the map view’s coordinate system.
 @param styleLayerIdentifiers A set of strings that correspond to the names of
    layers defined in the current style. Only the features contained in these
    layers are included in the returned array.
 @return An array of objects conforming to the `MGLFeature` protocol that
    represent features in the sources used by the current style.
 
 返回与给定矩形相交呈现的地图功能，限于给定的风格层的数组。
 
 返回数组中的每个对象代表由当前样式呈现的功能，并提供了访问由相关指定的属性 瓦来源。返回的数组包括矢量和GeoJSON的瓷砖来源中指定的功能，但不包括栅格图像或视频源东西。
 
 唯一可见的特性被返回。例如，假设当前样式使用 Mapbox街道源，但没有指定样式层包括具有的功能maki 属性设置为bus。如果您通过包含一个公共汽车站的位置，这个方法的矩形，巴士站功能不会出现在结果数组中为止。在另一方面，如果样式不包括公交车站，一个MGLFeature 是返回一个表示那个公交车站对象和它的featureAttributes 字典里的maki键值设 ​​为bus（与其他属性一起）。这本词典只包含了瓷砖源提供的属性; 它不包括有关如何特征是由当前样式呈现的计算属性值或规则。
 
 返回的数组由z顺序进行排序，从最上面的渲染功能和最底部的渲染功能结局。这是由于跨在低缩放级别子午线包装呈现多次的特征是包括只有一次，受到下面的警告。
 
 特征来自平铺矢量数据或转换为砖内部以GeoJSON数据，所以要素几何是在小块边界和特征裁剪可跨越瓦片出现重复。例如，假设指定的矩形与跨越屏幕道路相交。所得阵列包括位于覆盖指定矩形的地图瓦片内的道路的那些部分，即使道路延伸到其他砖。每个地图瓦片内的道路的部分被单独地包括在内。
 
 要找出一个特定样式的图层名称，查看风格 Mapbox工作室。
 
 
 @param rect 地图视图的坐标系中所表达的矩形。
 @param styleLayerIdentifiers 一组对应于当前的样式定义层的名称的字符串。只有包含在这些层的功能都包含在返回数组中为止。
 @return 符合对象数组MGLFeature协议表示在由当前样式中使用的源的功能。
 */
- (NS_ARRAY_OF(id <MGLFeature>) *)visibleFeaturesInRect:(CGRect)rect inStyleLayersWithIdentifiers:(nullable NS_SET_OF(NSString *) *)styleLayerIdentifiers NS_SWIFT_NAME(visibleFeatures(in:styleLayerIdentifiers:));

#pragma mark Debugging the Map 调试地图

/**
 The options that determine which debugging aids are shown on the map.
 
 These options are all disabled by default and should remain disabled in
 released software for performance and aesthetic reasons.
 
 决定哪个选项调试工具显示在地图上。
 
 这些选项都默认为禁用，应留在性能和美观的原因发布的软件禁用。
 */
@property (nonatomic) MGLMapDebugMaskOptions debugMask;

@property (nonatomic, getter=isDebugActive) BOOL debugActive __attribute__((deprecated("Use -debugMask and -setDebugMask:.")));

- (void)toggleDebug __attribute__((deprecated("Use -setDebugMask:.")));

- (void)emptyMemoryCache __attribute__((deprecated));

/**
    Resets the map to the minimum zoom level, a center coordinate of (0, 0), and
    a northern heading.
 
 重置地图到最低缩放级别，一个中心的（0，0）坐标，和一个北方标题。
 */
- (void)resetPosition;

@end

NS_ASSUME_NONNULL_END
