const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "converter",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFiles(.{
        .files = &.{
            // this thing makes list horizontal
            "main.c",
        },
    });
    exe.linkLibC();

    exe.addLibraryPath(.{ .cwd_relative = "/usr/lib/llvm-18/lib/" });
    exe.linkSystemLibrary("clang");

    exe.addIncludePath(b.path("../llvm-project/clang/include/"));
    b.exe_dir = "./build";

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
