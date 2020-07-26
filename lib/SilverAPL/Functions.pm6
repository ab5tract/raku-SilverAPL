unit module SilverAPL::Functions;

use SilverAPL::Helpers;

# DYADIC REPLICATE/COMPRESS
multi sub replicate($alpha, *$omega) is export {
    check-length-match($alpha, $omega);

    |do gather for $alpha.kv -> $i, $times {
        if $times {
            check-array-boundary($omega, $i);
            take |$omega[$i] xx $times
        }
    }
}

# GENERATOR (EVAL-based)
#       SimpleInlineFunctionDetails

my class SimpleInlineFunctionDetails {
    has Str  $.name is required;
    has Bool $.monadic = True;
    has Bool $.dyadic = True;
    has Str  $.f is required;
}

my @INLINE-FUNCTIONS =
        SimpleInlineFunctionDetails.new(:name('plus'),      :f<+>),
        SimpleInlineFunctionDetails.new(:name('minus'),     :f<->),
        SimpleInlineFunctionDetails.new(:name('divide'),    :f<÷>),
        SimpleInlineFunctionDetails.new(:name('times'),     :f<*>),
        SimpleInlineFunctionDetails.new(:name('max'),       :f<max>),
        SimpleInlineFunctionDetails.new(:name('min'),       :f<min>, :monadic(False)),
        SimpleInlineFunctionDetails.new(:name('exponent'),  :f<**>, :monadic(False)),
        ; # / @INLINE-FUNCTIONS

use MONKEY-SEE-NO-EVAL;
for @INLINE-FUNCTIONS -> $func {
    my $name = $func.name;
    my $f = $func.f;

    if $func.dyadic {
        # DYADIC PLUS
        EVAL qq{
            multi sub $name (Scalaric \$alpha, Dimensional \$omega) is export {
                my \$a = ensure-one-element-array(\$alpha);
                \$omega.map: \$a[0] $f *
            }

            multi sub $name (Dimensional \$alpha, Scalaric \$omega) is export {
                my \$o = ensure-one-element-array(\$omega);
                \$alpha.map: * $f \$o[0]
            }

            multi sub $name (Dimensional \$alpha, Dimensional \$omega) is export {
                @\$alpha Z$f @\$omega
            }

            multi sub $name (Scalaric \$alpha, Scalaric \$omega) is pure is export {
                ensure-one-element-array(\$alpha)[0] $f ensure-one-element-array(\$omega)[0]
            }
        }
    }
}