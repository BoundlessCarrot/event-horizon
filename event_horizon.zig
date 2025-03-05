const std = @import("std");
const stdout = std.io.getStdOut().writer();
const eql = std.mem.eql;

var width: usize = 65;
var height: usize = 65;

fn handleArgs(args: *std.process.ArgIterator) !void {
    while (args.next()) |arg| {
        if (eql(u8, arg, "-w") or eql(u8, arg, "--width")) {
            if (args.next()) |w| {
                width = try std.fmt.parseInt(usize, w, 10);
            }
        } else if (eql(u8, arg, "-h") or eql(u8, arg, "--height")) {
            if (args.next()) |h| {
                height = try std.fmt.parseInt(usize, h, 10);
            }
        } else {
            const help_msg =
                \\Usage: event_horizon [options] 
                \\Options:
                \\  -w, --width <width>    Set the width of the output
                \\  -h, --height <height>  Set the height of the output
            ;
            std.debug.print("{s}\n", .{help_msg});
        }
    }
}

pub fn main() !void {
    var args = try std.process.argsWithAllocator(std.heap.page_allocator);
    defer args.deinit();

    // Skip the program name
    _ = args.skip();

    try handleArgs(&args);

    const w: f32 = @floatFromInt(width);
    const h: f32 = @floatFromInt(height);

    for (0..height) |col| {
        for (0..width) |row| {
            const x: f32 = @floatFromInt(col);
            const y: f32 = @floatFromInt(row);

            const cx: f32 = (2 * x - w) / h;
            const cy: f32 = (2 * y - h) / h;

            var d = @sqrt((cx * cx) + (cy * cy));

            d += 0.01 * h / (2 * (x - y) + h - w) - 0.5;
            d = 0.1 / @abs(d);

            const chars = &[_]u8{ ' ', '-', '+', '=', '<', '@', '#' };
            const c: u8 = chars[@as(usize, @intFromFloat(@floor(d / (1 + d) * 7)))];
            try stdout.print("{c}{c}", .{ c, c });
        }
        try stdout.print("\n", .{});
    }
}
