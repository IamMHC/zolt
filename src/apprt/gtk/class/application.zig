const std = @import("std");
const c = @import("../bindings.zig");

pub const Application = struct {
    app: *c.AdwApplication,

    pub fn init(app_id: [:0]const u8) !Application {
        const app = c.adw_application_new(app_id.ptr, c.G_APPLICATION_DEFAULT_FLAGS) orelse
            return error.AppCreationFailed;

        return .{ .app = app };
    }

    pub fn deinit(self: Application) void {
        c.g_object_unref(self.app);
    }

    pub fn connectActivate(self: Application, callback: *const anyopaque, user_data: ?*anyopaque) void {
        _ = c.g_signal_connect_data(
            self.app,
            "activate",
            callback,
            user_data,
            null,
            0,
        );
    }

    pub fn run(self: Application) !void {
        const status = c.g_application_run(@ptrCast(self.app), 0, null);
        if (status != 0) return error.AppRunFailed;
    }
};
