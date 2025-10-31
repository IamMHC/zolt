const builtin = @import("builtin");
const core = @import("../core/state.zig");

pub const platform = switch (builtin.os.tag) {
    .linux => @import("gtk/App.zig"),
    else => @compileError("Unsupported platform. Supported: Linux (GTK)"),
};

pub const run = platform.run;
