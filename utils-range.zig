const std = @import("std");

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
