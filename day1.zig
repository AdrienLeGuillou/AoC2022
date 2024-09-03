const std = @import("std");
const testing = std.testing;

pub fn getMax(content: []const u8) !u32 {
    var read_iter = std.mem.splitSequence(u8, content, "\n");
    var max: u32 = 0;
    var cur: u32 = 0;
    while (read_iter.next()) |line| {
        if (line.len == 0) {
            max = if (cur > max) cur else max;
            cur = 0;
            continue;
        }
        cur += try std.fmt.parseInt(u32, line, 10);
    }
    max = if (cur > max) cur else max;
    return max;
}

fn update_max(max: *[3]u32, ccur: u32) void {
    var cur = ccur;
    var i: usize = 0;
    while (i < 3) : (i += 1) {
        if (cur > max[i]) {
            var j: usize = i;
            var tmp: u32 = undefined;
            while (j < 3) : (j += 1) {
                tmp = max[j];
                max[j] = cur;
                cur = tmp;
            }
            break;
        }
    }
}

pub fn getTop3(content: []const u8) !u32 {
    var read_iter = std.mem.splitSequence(u8, content, "\n");
    var max = [_]u32{0} ** 3;
    var cur: u32 = 0;
    while (read_iter.next()) |line| {
        if (line.len == 0) {
            update_max(&max, cur);
            cur = 0;
            continue;
        }
        cur += try std.fmt.parseInt(u32, line, 10);
    }
    update_max(&max, cur);
    return max[0] + max[1] + max[2];
}

test "first part" {
    const input = @embedFile("data/day1-input");
    const result = try getMax(input);
    std.debug.print("{}\n", .{result});
}

test "second part" {
    const input = @embedFile("data/day1-input");
    const result = try getTop3(input);
    std.debug.print("{}\n", .{result});
}
