const std = @import("std");
const c = @import("bindings.zig");
const Application = @import("class/application.zig").Application;
const Window = @import("class/window.zig").Window;
const widgets = @import("class/widgets.zig");
const core = @import("../../core/state.zig");
const Config = @import("../../core/config.zig").Config;

var app_state: *core.AppStateObject = undefined;

fn onButtonClicked(_: *c.GtkWidget, user_data: ?*anyopaque) callconv(.c) void {
    _ = user_data;

    const state = app_state.getData();
    state.incrementCounter();
    std.debug.print("Button clicked!\n", .{});
}

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

fn activate(app: *c.GtkApplication, user_data: ?*anyopaque) callconv(.c) void {
    _ = user_data;

    loadCss();

    const builder = c.gtk_builder_new_from_resource("/org/zolt/ui/window.ui");

    const window_obj = c.gtk_builder_get_object(builder, "window") orelse {
        std.debug.print("Failed to get window from builder\n", .{});
        return;
    };
    const window: *c.GtkWindow = @ptrCast(@alignCast(window_obj));

    c.gtk_window_set_application(window, app);

    const button_obj = c.gtk_builder_get_object(builder, "demo_button");
    if (button_obj) |btn| {
        const button_widget: *c.GtkWidget = @ptrCast(@alignCast(btn));
        _ = c.g_signal_connect_data(
            button_widget,
            "clicked",
            @ptrCast(&onButtonClicked),
            null,
            null,
            0,
        );
    }

    c.gtk_window_present(window);
}

pub fn run(state: *core.AppStateObject) !void {
    app_state = state;

    const resource = c.zolt_get_resource();
    c.g_resources_register(resource);

    const config = Config{};

    const app = try Application.init(config.app_id);
    defer app.deinit();

    app.connectActivate(@ptrCast(&activate), null);
    try app.run();
}
