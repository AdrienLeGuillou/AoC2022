const std = @import("std");

const test_input =
    \\vJrwpWtwJgWrhcsFMMfFFhFp
    \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    \\PmmdzqPrVvPwwTWBwg
    \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    \\ttgJtRGJQctTZtZT
    \\CrZsJsPPZsGzwwsLwLmpwMDw
;

fn get_prio(letter: u8) u32 {
    var out: u32 = 0;
    if (std.ascii.isLower(letter)) {
        out = letter - 'a' + 1;
    } else {
        out = letter - 'A' + 27;
    }
    return out;
}

fn compute_error(line: []const u8) u32 {
    const sack_len: usize = line.len / 2;
    var mismatch_ind: ?usize = null;
    for (line[0..sack_len], 0..) |_, i| {
        mismatch_ind = std.mem.indexOf(u8, line[sack_len..], line[i..i+1]);
        if (mismatch_ind != null) {
            return get_prio(line[i]);
        }
    }
    return 0;
}

fn p1(input: []const u8) u32 {
    var result: u32 = 0;
    var read_iter = std.mem.tokenizeAny(u8, input, "\n");
    while (read_iter.next()) |line| {
        result += compute_error(line);
    }
    return result;
}

test "first part" {
    std.debug.print("{}\n", .{p1(test_input)});
    std.debug.print("{}\n", .{p1(@embedFile("data/day3-input"))});
}

fn get_badge(e1: []const u8, e2: []const u8, e3: []const u8) u32 {
    for (e1, 0..) |l, i| {
        const s = e1[i..i+1];
        if (std.mem.indexOf(u8, e2, s) != null) {
            if (std.mem.indexOf(u8, e3, s) != null)
                return get_prio(l);
        }
    }
    return 0;
}

fn p2(input: []const u8) u32 {
    var result: u32 = 0;
    var read_iter = std.mem.tokenizeAny(u8, input, "\n");
    while (read_iter.next()) |elf1| {
        const elf2 = read_iter.next().?;
        const elf3 = read_iter.next().?;
        result += get_badge(elf1, elf2, elf3);
    }
    return result;
}

test "second part" {
    std.debug.print("{}\n", .{p2(test_input)});
    std.debug.print("{}\n", .{p2(@embedFile("data/day3-input"))});
}

