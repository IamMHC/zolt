const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zolt",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const blueprint_compile = b.addSystemCommand(&.{
        "blueprint-compiler",
        "compile",
        "--output",
    });
    const ui_xml = blueprint_compile.addOutputFileArg("window.ui");
    blueprint_compile.addFileArg(b.path("src/apprt/gtk/ui/window.blp"));

    const gresource_xml = b.addWriteFiles();
    _ = gresource_xml.add("zolt.gresource.xml",
        \\<?xml version="1.0" encoding="UTF-8"?>
        \\<gresources>
        \\  <gresource prefix="/org/zolt">
        \\    <file>ui/window.ui</file>
        \\    <file>css/style.css</file>
        \\  </gresource>
        \\</gresources>
    );

    _ = gresource_xml.addCopyFile(ui_xml, "ui/window.ui");
    _ = gresource_xml.addCopyFile(b.path("src/apprt/gtk/css/style.css"), "css/style.css");

    const gresource_compile = b.addSystemCommand(&.{
        "glib-compile-resources",
        "--target",
    });
    const resources_c = gresource_compile.addOutputFileArg("resources.c");
    gresource_compile.addArg("--generate-source");
    gresource_compile.addFileArg(gresource_xml.getDirectory().path(b, "zolt.gresource.xml"));
    gresource_compile.setCwd(gresource_xml.getDirectory());

    exe.addCSourceFile(.{
        .file = resources_c,
        .flags = &.{},
    });

    exe.linkLibC();
    exe.linkSystemLibrary("gtk4");
    exe.linkSystemLibrary("gobject-2.0");
    exe.linkSystemLibrary("glib-2.0");

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
}
