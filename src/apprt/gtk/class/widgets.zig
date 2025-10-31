const std = @import("std");
const c = @import("../bindings.zig");

pub const Box = struct {
    box: *c.GtkBox,
    widget: *c.GtkWidget,

    pub fn init(orientation: c.GtkOrientation, spacing: i32) Box {
        const box = c.gtk_box_new(orientation, spacing);
        return .{
            .box = box,
            .widget = @ptrCast(box),
        };
    }

    pub fn append(self: Box, child: *c.GtkWidget) void {
        c.gtk_box_append(self.box, child);
    }

    pub fn setMargins(self: Box, margin: i32) void {
        c.gtk_widget_set_margin_start(self.widget, margin);
        c.gtk_widget_set_margin_end(self.widget, margin);
        c.gtk_widget_set_margin_top(self.widget, margin);
        c.gtk_widget_set_margin_bottom(self.widget, margin);
    }
};

pub const Label = struct {
    widget: *c.GtkWidget,

    pub fn init(text: [*:0]const u8) Label {
        return .{
            .widget = c.gtk_label_new(text),
        };
    }
};

pub const Button = struct {
    widget: *c.GtkWidget,

    pub fn init(label: [*:0]const u8) Button {
        return .{
            .widget = c.gtk_button_new_with_label(label),
        };
    }

    pub fn connectClicked(self: Button, callback: *const anyopaque, user_data: ?*anyopaque) void {
        _ = c.g_signal_connect_data(
            self.widget,
            "clicked",
            callback,
            user_data,
            null,
            0,
        );
    }
};
