const std = @import("std");
// https://github.com/baboikus/zig-postcard

const print = std.debug.print;

const ALPHABET: [11]u8 = .{ ' ', '|', '_', '/', '\\', '(', '`', ',', '\'', '.', ')' };

const CODE = [_]u8{ 0x63, 0x71, 0x22, 0x80, 0x93, 0xA5,
                    0x43, 0xB5, 0xC1, 0xD0, 0xE4, 0xF0 };

const WORDS = [16][]const u8{
    "3A512QBSacQB843A3a4Qb\xC1rA3a3QB92:aca31;3q514Q61RASA3Q;1R",
    "A3a3Qrq415a3163acq728a3A3q", "rA3a3Q92:BAca31;3q514q",
    "BaC\x81", "rA3a3QB9", "3acQ", "\xB1rA3a3QB1", "CqB1B",
    "Bq", "a3A3q9", "CqbQ3a5QB32", "31Bq513\x81Bq415a316",
    "B728", "Ra", "q41512A316SA\x83Q72843A3a4Qb\xC1",
    "2:aca31;3q514\x812\x81415a3163aca31;3q514qBq3A512QBSacQB843A3a4Qb1",
};

const HEIGHT = 8;
const WIDTH = 112;
var DECODED: [HEIGHT * WIDTH]u8 = undefined;

fn decode(code: u8, old_pos: u16) u16 {
    var new_pos = old_pos;
    for ([_]u8{ code >> 4, code & 0x0F }) |idx| {
        for (WORDS[idx]) |symbol| {
            var n: u8 = 0;
            while (n < (symbol - 33) >> 4 and new_pos < DECODED.len) : (n += 1) {
                const char = ALPHABET[(symbol - 33) & 0x0F];
                DECODED[new_pos % HEIGHT * WIDTH + new_pos / HEIGHT] = char;
                new_pos += 1;
            }
        }
    }
    return new_pos;
}

pub fn main() !void {
    var pos: u16 = 0;
    for (CODE) |code| pos = decode(code, pos);

    for (DECODED) |d, idx| {
        if (idx % WIDTH == 0) print("\n", .{});
        print("{c}", .{d});
    }
    print("\n", .{});
}
