const std = @import("std");
const testing = std.testing;

const test_input =
    \\2-4,6-8
    \\2-3,4-5
    \\5-7,7-9
    \\2-8,3-7
    \\6-6,4-6
    \\2-6,4-8
;

const Range = struct {
    low: i32,
    high: i32,

    pub fn new(a: i32, b: i32) Range {
        var new_r: Range = undefined;
        if (a < b) {
            new_r.low = a;
            new_r.high = b;
        } else {
            new_r.low = b;
            new_r.high = a;
        }
        return new_r;
    }

    pub fn parse(seq: []const u8) Range {
        var toks = std.mem.tokenizeAny(u8, seq, "-");
        const a: i32 = std.fmt.parseInt(i32, toks.next().?, 10) catch 0;
        const b: i32 = std.fmt.parseInt(i32, toks.next().?, 10) catch 0;
        return Range.new(a, b);
    }

    pub fn contains(self: Range, other: Range) bool {
        return self.low <= other.low and self.high >= other.high;
    }

    pub fn overlap(self: Range, other: Range) bool {
        return (self.low <= other.low and self.high >= other.low) or
            (other.low <= self.low and other.high >= self.low);
    }
};

fn p1(input: []const u8) void {
    var contains: u32 = 0;
    var overlap: u32 = 0;
    var read_iter = std.mem.tokenizeAny(u8, input, "\n");
    while (read_iter.next()) |line| {
        var toks = std.mem.tokenizeAny(u8, line, ",");
        const r1 = Range.parse(toks.next().?);
        const r2 = Range.parse(toks.next().?);
        if (r1.contains(r2) or r2.contains(r1))
            contains += 1;

        if (r1.overlap(r2))
            overlap += 1;
    }
    std.debug.print("p1: {}, p2: {}\n", .{contains, overlap});
}

test "p1" {
    p1(test_input);
    p1(@embedFile("data/day4-input"));
}
