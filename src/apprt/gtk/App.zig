const std = @import("std");
const c = @import("bindings.zig");
const Application = @import("class/application.zig").Application;
const Window = @import("class/window.zig").Window;
const widgets = @import("class/widgets.zig");
const StateAdapter = @import("state_adapter.zig");
const Config = @import("../../core/config.zig").Config;
const SidebarHandlers = @import("handlers/sidebar.zig").SidebarHandlers;
const ContentHandlers = @import("handlers/content.zig").ContentHandlers;
const diagnostics = @import("../../core/diagnostics.zig");

var app_state: *StateAdapter.AppStateObject = undefined;
var sidebar_handlers: SidebarHandlers = undefined;
var content_handlers: ContentHandlers = undefined;
var diagnostics_label: ?*c.GtkWidget = null;
var main_window: ?*c.GtkWidget = null;
var gpa = std.heap.GeneralPurposeAllocator(.{}){};

fn loadCss() void {
    const css_provider = c.gtk_css_provider_new();
    c.gtk_css_provider_load_from_resource(css_provider, "/org/zolt/css/style.css");

    const display = c.gdk_display_get_default() orelse {
        std.debug.print("Failed to get default display\n", .{});
        return;
    };

    c.gtk_style_context_add_provider_for_display(
        display,
        @ptrCast(css_provider),
        c.GTK_STYLE_PROVIDER_PRIORITY_APPLICATION,
    );
}

fn activate(app: *c.AdwApplication, user_data: ?*anyopaque) callconv(.c) void {
    _ = user_data;

    loadCss();

    // Initialize handlers
    sidebar_handlers = SidebarHandlers.init(app_state);
    content_handlers = ContentHandlers.init(app_state);

    const builder = c.gtk_builder_new_from_resource("/org/zolt/ui/window.ui");

    const window_obj = c.gtk_builder_get_object(builder, "window") orelse {
        std.debug.print("Failed to get window from builder\n", .{});
        return;
    };
    const window: *c.AdwApplicationWindow = @ptrCast(@alignCast(window_obj));
    main_window = @ptrCast(window);

    c.gtk_window_set_application(@ptrCast(window), @ptrCast(app));

    setupSidebar(builder);
    setupContent(builder);
    setupDiagnostics(builder);

    c.gtk_window_present(@ptrCast(window));
}

fn onFrameTick(_: *c.GtkWidget, _: *anyopaque, _: ?*anyopaque) callconv(.c) c_int {
    const state = app_state.getData();
    state.tick();

    if (diagnostics_label) |label| {
        const allocator = gpa.allocator();
        const text = state.diagnostics.format(allocator) catch return 1;
        defer allocator.free(text);

        const text_z = allocator.dupeZ(u8, text) catch return 1;
        defer allocator.free(text_z);

        c.gtk_label_set_text(label, text_z.ptr);
    }

    return 1;
}

fn setupDiagnostics(builder: *c.GtkBuilder) void {
    const label_obj = c.gtk_builder_get_object(builder, "diagnostics_label") orelse {
        std.debug.print("Failed to get diagnostics_label\n", .{});
        return;
    };
    diagnostics_label = @ptrCast(@alignCast(label_obj));

    const overlay_obj = c.gtk_builder_get_object(builder, "diagnostics_overlay") orelse {
        std.debug.print("Failed to get diagnostics_overlay\n", .{});
        return;
    };
    const overlay: *c.GtkWidget = @ptrCast(@alignCast(overlay_obj));

    if (diagnostics.isDebugMode()) {
        c.gtk_widget_set_visible(overlay, 1);

        if (main_window) |window| {
            _ = c.gtk_widget_add_tick_callback(
                window,
                &onFrameTick,
                null,
                null,
            );
        }
    } else {
        c.gtk_widget_set_visible(overlay, 0);
    }
}

fn setupSidebar(builder: *c.GtkBuilder) void {
    const sidebar_obj = c.gtk_builder_get_object(builder, "sidebar_buttons") orelse {
        std.debug.print("Failed to get sidebar_buttons\n", .{});
        return;
    };
    const sidebar_box: *c.GtkBox = @ptrCast(@alignCast(sidebar_obj));

    const nav_items = [_]struct { label: [:0]const u8, callback: *const fn (*c.GtkWidget, ?*anyopaque) callconv(.c) void }{
        .{ .label = "Dashboard", .callback = &SidebarHandlers.onDashboardClicked },
        .{ .label = "Settings", .callback = &SidebarHandlers.onSettingsClicked },
        .{ .label = "About", .callback = &SidebarHandlers.onAboutClicked },
    };

    for (nav_items) |item| {
        const btn = c.gtk_button_new_with_label(item.label.ptr);
        c.gtk_widget_add_css_class(btn, "flat");
        _ = c.g_signal_connect_data(
            btn,
            "clicked",
            @ptrCast(item.callback),
            &sidebar_handlers,
            null,
            0,
        );
        c.gtk_box_append(sidebar_box, btn);
    }
}

fn setupContent(builder: *c.GtkBuilder) void {
    const content_obj = c.gtk_builder_get_object(builder, "content_area") orelse {
        std.debug.print("Failed to get content_area\n", .{});
        return;
    };
    const content_box: *c.GtkBox = @ptrCast(@alignCast(content_obj));

    const group = c.adw_preferences_group_new();
    c.adw_preferences_group_set_title(group, "Welcome");
    c.adw_preferences_group_set_description(group, "Modern Adwaita UI");

    const action_row = c.adw_action_row_new();
    c.adw_preferences_row_set_title(@ptrCast(action_row), "Counter Example");
    c.adw_action_row_set_subtitle(action_row, "Click button to increment");

    const demo_button = c.gtk_button_new_with_label("Click Me");
    c.gtk_widget_set_valign(demo_button, c.GTK_ALIGN_CENTER);
    c.gtk_widget_add_css_class(demo_button, "suggested-action");
    c.gtk_widget_add_css_class(demo_button, "pill");

    _ = c.g_signal_connect_data(
        demo_button,
        "clicked",
        @ptrCast(&ContentHandlers.onButtonClicked),
        &content_handlers,
        null,
        0,
    );

    c.adw_action_row_add_suffix(action_row, demo_button);
    c.adw_preferences_group_add(@ptrCast(group), @ptrCast(action_row));

    const entry_row = c.adw_entry_row_new();
    c.adw_preferences_row_set_title(@ptrCast(entry_row), "Input Field");
    c.adw_preferences_group_add(@ptrCast(group), @ptrCast(entry_row));

    c.gtk_box_append(content_box, @ptrCast(group));
}

pub fn run(state: *StateAdapter.AppStateObject) !void {
    app_state = state;

    const resource = c.zolt_get_resource();
    c.g_resources_register(resource);

    const config = Config{};

    const app = try Application.init(config.app_id);
    defer app.deinit();

    app.connectActivate(@ptrCast(&activate), null);
    try app.run();
}
