const std = @import("std");
const builtin = @import("builtin");

pub const Diagnostics = struct {
    frame_count: u64,
    last_update_time: i64,
    fps: f32,
    memory_usage: usize,

    pub fn init() Diagnostics {
        return .{
            .frame_count = 0,
            .last_update_time = std.time.milliTimestamp(),
            .fps = 0.0,
            .memory_usage = 0,
        };
    }

    pub fn tick(self: *Diagnostics) void {
        self.frame_count += 1;

        const current_time = std.time.milliTimestamp();
        const elapsed = current_time - self.last_update_time;

        if (elapsed >= 1000) {
            self.fps = @as(f32, @floatFromInt(self.frame_count)) / (@as(f32, @floatFromInt(elapsed)) / 1000.0);
            self.frame_count = 0;
            self.last_update_time = current_time;

            self.updateMemoryFromSystem();
        }
    }

    fn updateMemoryFromSystem(self: *Diagnostics) void {
        const file = std.fs.openFileAbsolute("/proc/self/statm", .{}) catch return;
        defer file.close();

        var buf: [256]u8 = undefined;
        const len = file.read(&buf) catch return;

        var iter = std.mem.splitScalar(u8, buf[0..len], ' ');
        _ = iter.next();
        if (iter.next()) |rss_pages| {
            const pages = std.fmt.parseInt(usize, std.mem.trim(u8, rss_pages, &std.ascii.whitespace), 10) catch return;
            self.memory_usage = pages * 4096;
        }
    }

    pub fn updateMemoryUsage(self: *Diagnostics, bytes: usize) void {
        self.memory_usage = bytes;
    }

    pub fn format(self: Diagnostics, allocator: std.mem.Allocator) ![]u8 {
        const memory_mb = @as(f64, @floatFromInt(self.memory_usage)) / (1024.0 * 1024.0);
        return std.fmt.allocPrint(
            allocator,
            "FPS: {d:.1}\nMemory: {d:.2} MB\nMode: {s}",
            .{ self.fps, memory_mb, @tagName(builtin.mode) }
        );
    }
};

pub fn isDebugMode() bool {
    return builtin.mode == .Debug;
}
