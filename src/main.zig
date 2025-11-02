const std = @import("std");
const apprt = @import("apprt/runtime.zig");

pub fn main() !void {
    const app_state = apprt.createAppState();
    defer app_state.unref();

    try apprt.run(app_state);
}
