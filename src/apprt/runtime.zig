const builtin = @import("builtin");

pub const platform = switch (builtin.os.tag) {
    .linux => struct {
        pub const run = @import("gtk/App.zig").run;
        pub const AppStateObject = @import("gtk/state_adapter.zig").AppStateObject;
        pub const createAppState = @import("gtk/state_adapter.zig").createAppState;
    },
    else => @compileError("Unsupported platform. Only Linux (GTK4) is supported."),
};

pub const run = platform.run;
pub const AppStateObject = platform.AppStateObject;
pub const createAppState = platform.createAppState;
