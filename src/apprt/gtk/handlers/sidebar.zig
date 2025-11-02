const std = @import("std");
const c = @import("../bindings.zig");
const StateAdapter = @import("../state_adapter.zig");

pub const SidebarHandlers = struct {
    app_state: *StateAdapter.AppStateObject,

    pub fn init(state: *StateAdapter.AppStateObject) SidebarHandlers {
        return .{ .app_state = state };
    }

    pub fn onDashboardClicked(_: *c.GtkWidget, user_data: ?*anyopaque) callconv(.c) void {
        const self: *SidebarHandlers = @ptrCast(@alignCast(user_data.?));
        _ = self;
        std.debug.print("[Sidebar] Dashboard clicked!\n", .{});
        // Add your dashboard logic here
    }

    pub fn onSettingsClicked(_: *c.GtkWidget, user_data: ?*anyopaque) callconv(.c) void {
        const self: *SidebarHandlers = @ptrCast(@alignCast(user_data.?));
        _ = self;
        std.debug.print("[Sidebar] Settings clicked!\n", .{});
        // Add your settings logic here
    }

    pub fn onAboutClicked(_: *c.GtkWidget, user_data: ?*anyopaque) callconv(.c) void {
        const self: *SidebarHandlers = @ptrCast(@alignCast(user_data.?));
        _ = self;
        std.debug.print("[Sidebar] About clicked!\n", .{});
        // Add your about logic here
    }
};
