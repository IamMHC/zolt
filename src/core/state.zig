const std = @import("std");
const gobject = @import("../apprt/gtk/gobject.zig");

pub const AppState = struct {
    counter: u32,

    pub fn init() AppState {
        return .{
            .counter = 0,
        };
    }

    pub fn incrementCounter(self: *AppState) void {
        self.counter += 1;
        std.debug.print("Counter: {}\n", .{self.counter});
    }
};

pub const AppStateObject = gobject.GObjectWrapper(AppState);

pub fn createAppState() *AppStateObject {
    return AppStateObject.create(AppState.init());
}
