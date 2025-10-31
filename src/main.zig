const std = @import("std");
const apprt = @import("apprt/runtime.zig");
const core = @import("core/state.zig");

pub fn main() !void {
    const app_state = core.createAppState();
    defer app_state.unref();

    try apprt.run(app_state);
}
