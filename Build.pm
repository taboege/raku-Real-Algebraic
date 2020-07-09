unit class Build;

method build (IO() $dist-path) {
    say "Building wrapper library...";
    so run $*VM.config<make>, '-C', ~$dist-path.add("src");
}

# vim: ft=perl6
