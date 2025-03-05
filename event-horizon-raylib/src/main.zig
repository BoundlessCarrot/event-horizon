const std = @import("std");
const rl = @import("raylib");

pub fn main() !void {
    const screenWidth = 1080;
    const screenHeight = 720;

    rl.initWindow(screenWidth, screenHeight, "The Event Horizon in a single equation");
    defer rl.closeWindow();

    rl.setTargetFPS(1);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        const w: f32 = @floatFromInt(screenWidth);
        const h: f32 = @floatFromInt(screenHeight);

        for (0..screenHeight) |col| {
            for (0..screenWidth) |row| {
                const x: f32 = @floatFromInt(row);
                const y: f32 = @floatFromInt(col);

                const cx: f32 = (2 * x - w) / h;
                const cy: f32 = (2 * y - h) / h;

                var d = @sqrt((cx * cx) + (cy * cy));

                d += 0.01 * h / (2 * (x - y) + h - w + 0.000001) - 0.5;
                d = 0.1 / @abs(d);

                const color_val: u8 = @intFromFloat(@min(255, 255 * d / (1 + d)));
                const color: rl.Color = rl.Color.init(color_val, color_val, color_val, 255);

                rl.drawPixel(@as(i32, @intCast(row)), @as(i32, @intCast(col)), color);
            }
        }
    }
}
