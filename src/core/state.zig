const std = @import("std");
const Diagnostics = @import("diagnostics.zig").Diagnostics;

pub const AppState = struct {
    counter: u32,
    diagnostics: Diagnostics,

    pub fn init() AppState {
        return .{
            .counter = 0,
            .diagnostics = Diagnostics.init(),
        };
    }

    pub fn incrementCounter(self: *AppState) void {
        self.counter += 1;
        std.debug.print("Counter: {}\n", .{self.counter});
    }

    pub fn tick(self: *AppState) void {
        self.diagnostics.tick();
    }
};
