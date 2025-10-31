const std = @import("std");

pub const GObject = opaque {};
pub const GType = usize;
pub const GTypeClass = opaque {};
pub const GTypeInstance = extern struct {
    g_class: *GTypeClass,
};

pub const GObjectStruct = extern struct {
    g_type_instance: GTypeInstance,
    ref_count: c_uint,
    qdata: ?*anyopaque,
};

pub const GParamSpec = opaque {};
pub const GValue = extern struct {
    g_type: GType,
    data: [2]u64,
};

pub extern fn g_object_new(object_type: GType, first_property_name: ?[*:0]const u8, ...) *GObject;
pub extern fn g_object_ref(object: *GObject) *GObject;
pub extern fn g_object_set_property(object: *GObject, property_name: [*:0]const u8, value: *const GValue) void;
pub extern fn g_object_get_property(object: *GObject, property_name: [*:0]const u8, value: *GValue) void;
pub extern fn g_object_notify(object: *GObject, property_name: [*:0]const u8) void;

pub extern fn g_type_register_static_simple(
    parent_type: GType,
    type_name: [*:0]const u8,
    class_size: c_uint,
    class_init: ?*const fn (*anyopaque, *anyopaque) callconv(.C) void,
    instance_size: c_uint,
    instance_init: ?*const fn (*anyopaque, *anyopaque) callconv(.C) void,
    flags: c_int,
) GType;

pub extern fn g_type_from_name(name: [*:0]const u8) GType;

pub fn GObjectWrapper(comptime T: type) type {
    return struct {
        gobject: GObjectStruct,
        data: T,

        const Self = @This();

        pub fn create(data: T) *Self {
            const ptr = @as(*Self, @ptrCast(@alignCast(
                std.c.malloc(@sizeOf(Self))
            )));

            ptr.gobject = std.mem.zeroes(GObjectStruct);
            ptr.gobject.ref_count = 1;
            ptr.data = data;

            return ptr;
        }

        pub fn ref(self: *Self) *Self {
            self.gobject.ref_count += 1;
            return self;
        }

        pub fn unref(self: *Self) void {
            self.gobject.ref_count -= 1;
            if (self.gobject.ref_count == 0) {
                std.c.free(self);
            }
        }

        pub fn getData(self: *Self) *T {
            return &self.data;
        }
    };
}
