const std = @import("std");
const c = @import("../bindings.zig");
const StateAdapter = @import("../state_adapter.zig");

pub const ContentHandlers = struct {
    app_state: *StateAdapter.AppStateObject,

    pub fn init(state: *StateAdapter.AppStateObject) ContentHandlers {
        return .{ .app_state = state };
    }

    pub fn onButtonClicked(_: *c.GtkWidget, user_data: ?*anyopaque) callconv(.c) void {
        const self: *ContentHandlers = @ptrCast(@alignCast(user_data.?));

        const state = self.app_state.getData();
        state.incrementCounter();

        std.debug.print("[Content] Button clicked! Counter: {d}\n", .{state.counter});
        // Add your main content logic here
    }
};
