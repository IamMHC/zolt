pub const GApplicationFlags = c_uint;
pub const G_APPLICATION_DEFAULT_FLAGS: GApplicationFlags = 0;

pub const GtkApplication = opaque {};
pub const GtkWindow = opaque {};
pub const GtkWidget = opaque {};
pub const GtkBox = opaque {};
pub const GtkOrientation = enum(c_uint) {
    horizontal = 0,
    vertical = 1
};
pub const GResource = opaque {};
pub const GApplication = opaque {};

// Adwaita types
pub const AdwApplication = opaque {};
pub const AdwApplicationWindow = opaque {};
pub const AdwHeaderBar = opaque {};
pub const AdwToolbarView = opaque {};
pub const AdwBin = opaque {};
pub const AdwPreferencesGroup = opaque {};
pub const AdwPreferencesRow = opaque {};
pub const AdwActionRow = opaque {};
pub const AdwEntryRow = opaque {};

pub const GtkAlign = enum(c_uint) {
    fill = 0,
    start = 1,
    end = 2,
    center = 3,
    baseline = 4,
};
pub const GTK_ALIGN_CENTER = GtkAlign.center;

pub extern fn g_application_run(app: *GApplication, argc: c_int, argv: ?*?[*:0]u8) c_int;
pub extern fn g_object_unref(object: *anyopaque) void;
pub extern fn g_signal_connect_data(
    instance: *anyopaque,
    detailed_signal: [*:0]const u8,
    c_handler: *const anyopaque,
    data: ?*anyopaque,
    destroy_data: ?*const anyopaque,
    connect_flags: c_uint,
) c_ulong;

pub extern fn g_timeout_add(interval: c_uint, function: *const fn (?*anyopaque) callconv(.c) c_int, data: ?*anyopaque) c_uint;

pub extern fn gtk_widget_add_tick_callback(
    widget: *GtkWidget,
    callback: *const fn (*GtkWidget, *anyopaque, ?*anyopaque) callconv(.c) c_int,
    user_data: ?*anyopaque,
    notify: ?*const anyopaque,
) c_uint;

pub const GdkFrameClock = opaque {};

pub extern fn gtk_application_new(app_id: ?[*:0]const u8, flags: GApplicationFlags) ?*GtkApplication;
pub extern fn gtk_application_window_new(app: *GtkApplication) *GtkWindow;

pub extern fn gtk_window_set_title(window: *GtkWindow, title: [*:0]const u8) void;
pub extern fn gtk_window_set_default_size(window: *GtkWindow, width: c_int, height: c_int) void;
pub extern fn gtk_window_present(window: *GtkWindow) void;
pub extern fn gtk_window_set_child(window: *GtkWindow, child: *GtkWidget) void;
pub extern fn gtk_window_set_application(window: *GtkWindow, application: *GtkApplication) void;

pub extern fn gtk_box_new(orientation: GtkOrientation, spacing: c_int) *GtkBox;
pub extern fn gtk_box_append(box: *GtkBox, child: *GtkWidget) void;

pub extern fn gtk_label_new(text: [*:0]const u8) *GtkWidget;
pub extern fn gtk_label_set_text(label: *GtkWidget, text: [*:0]const u8) void;
pub extern fn gtk_button_new_with_label(label: [*:0]const u8) *GtkWidget;
pub extern fn gtk_button_set_label(button: *GtkWidget, label: [*:0]const u8) void;
pub extern fn gtk_widget_set_margin_start(widget: *GtkWidget, margin: c_int) void;
pub extern fn gtk_widget_set_margin_end(widget: *GtkWidget, margin: c_int) void;
pub extern fn gtk_widget_set_margin_top(widget: *GtkWidget, margin: c_int) void;
pub extern fn gtk_widget_set_margin_bottom(widget: *GtkWidget, margin: c_int) void;
pub extern fn gtk_widget_set_valign(widget: *GtkWidget, alignment: GtkAlign) void;
pub extern fn gtk_widget_add_css_class(widget: *GtkWidget, css_class: [*:0]const u8) void;
pub extern fn gtk_widget_set_visible(widget: *GtkWidget, visible: c_int) void;

pub extern fn g_resources_register(resource: *GResource) void;
pub extern fn zolt_get_resource() *GResource;

pub const GtkBuilder = opaque {};
pub extern fn gtk_builder_new_from_resource(resource_path: [*:0]const u8) *GtkBuilder;
pub extern fn gtk_builder_get_object(builder: *GtkBuilder, name: [*:0]const u8) ?*anyopaque;

pub const GtkCssProvider = opaque {};
pub const GdkDisplay = opaque {};
pub extern fn gtk_css_provider_new() *GtkCssProvider;
pub extern fn gtk_css_provider_load_from_resource(provider: *GtkCssProvider, resource_path: [*:0]const u8) void;
pub extern fn gtk_style_context_add_provider_for_display(
    display: *GdkDisplay,
    provider: *anyopaque,
    priority: c_uint,
) void;
pub extern fn gdk_display_get_default() ?*GdkDisplay;

pub const GTK_STYLE_PROVIDER_PRIORITY_APPLICATION: c_uint = 600;

// Adwaita functions
pub extern fn adw_application_new(app_id: ?[*:0]const u8, flags: GApplicationFlags) ?*AdwApplication;
pub extern fn adw_application_window_new(app: *AdwApplication) *AdwApplicationWindow;
pub extern fn adw_header_bar_new() *AdwHeaderBar;
pub extern fn adw_toolbar_view_new() *AdwToolbarView;
pub extern fn adw_toolbar_view_set_content(toolbar_view: *AdwToolbarView, content: *GtkWidget) void;
pub extern fn adw_toolbar_view_add_top_bar(toolbar_view: *AdwToolbarView, widget: *GtkWidget) void;

pub extern fn adw_preferences_group_new() *AdwPreferencesGroup;
pub extern fn adw_preferences_group_set_title(group: *AdwPreferencesGroup, title: [*:0]const u8) void;
pub extern fn adw_preferences_group_set_description(group: *AdwPreferencesGroup, description: [*:0]const u8) void;
pub extern fn adw_preferences_group_add(group: *AdwPreferencesGroup, child: *GtkWidget) void;

pub extern fn adw_action_row_new() *AdwActionRow;
pub extern fn adw_action_row_set_subtitle(row: *AdwActionRow, subtitle: [*:0]const u8) void;
pub extern fn adw_action_row_add_suffix(row: *AdwActionRow, widget: *GtkWidget) void;

pub extern fn adw_entry_row_new() *AdwEntryRow;

pub extern fn adw_preferences_row_set_title(row: *AdwPreferencesRow, title: [*:0]const u8) void;

pub const GObject = @import("gobject.zig");
