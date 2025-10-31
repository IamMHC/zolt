const std = @import("std");

pub const AppState = struct {
    counter: u32 = 0,

    pub fn init() AppState {
        return .{};
    }

    pub fn incrementCounter(self: *AppState) void {
        self.counter += 1;
        std.debug.print("Counter: {}\n", .{self.counter});
    }
};
