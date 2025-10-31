const std = @import("std");
const c = @import("../bindings.zig");

pub const Window = struct {
    window: *c.GtkWindow,

    pub fn init(app: *c.GtkApplication) Window {
        return .{
            .window = c.gtk_application_window_new(app),
        };
    }

    pub fn setTitle(self: Window, title: [*:0]const u8) void {
        c.gtk_window_set_title(self.window, title);
    }

    pub fn setDefaultSize(self: Window, width: i32, height: i32) void {
        c.gtk_window_set_default_size(self.window, width, height);
    }

    pub fn setChild(self: Window, child: *c.GtkWidget) void {
        c.gtk_window_set_child(self.window, child);
    }

    pub fn present(self: Window) void {
        c.gtk_window_present(self.window);
    }
};
