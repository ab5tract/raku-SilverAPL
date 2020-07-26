unit module SilverAPL::Helpers;


subset Scalaric is export where *.elems == 1;
subset Dimensional is export where *.elems > 1;

sub check-length-match(@alpha, @omega) is export {
    die "LENGTH ERROR (⍺={+@alpha},⍵={+@omega})"
        unless @alpha == @omega;
}

sub check-array-boundary(@a, $idx) is export {
    die "BOUNDARY ERROR (attempted access of index $idx from dimension of { +@a } elements"
        unless @a[$idx]:exists;
}

sub ensure-one-element-array($v) is pure is export {
    $v.^can('AT-POS') ?? $v !! [$v]
}