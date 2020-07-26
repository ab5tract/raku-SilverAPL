use Test;

use SilverAPL::Functions;

subtest "Simple Dyadic Functions", {
    subtest "Plus", {
        # @res is used here only to enable the first shape tests.
        # Since the underlying implementations are entirely the same, the shape only needs a single check
        is plus([1], [10 .. 19]), (my @res = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]),
            "plus() with single element alpha adds to each of omega";
        is plus([1], [10 .. 19]).elems, @res.elems,
            "plus() with scalar alpha has result in the shape of omega";
        is plus([10 .. 19], [1]), (@res = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]),
            "plus() with single element omega adds to each of alpha";
        is plus([^10], [1]).elems, @res.elems,
            "plus() with scalar omega has result in the shape of alpha";
        is plus([^10], [^10]), (@res = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]),
            "plus() with equal size alpha and omega: [^10] + [^10] ~~ [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]";
        is (plus([^10], [^10])).elems, @res.elems,
            "plus() with equal size alpha and omega has result in the same shape";
    }

    subtest "Minus", {
        is minus([1], [^10]), [1, 0, -1, -2, -3, -4, -5, -6, -7, -8],
            "minus() with single element alpha subtracts from each of omega";
        is minus([^10], [1]), [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8],
            "minus() with single element omega subtracts from each of alpha";
        is (minus [^10], [^10]), [0 xx 10],
            "minus() with equal size alpha and omega: [^10] - [^10] ~~ [0 xx 10]";
        is (minus [0 xx 10], [^10]), [0, -1, -2, -3, -4, -5, -6, -7, -8, -9],
            "minus() with equal size alpha and omega: [0 xx 10] - [^10] ~~ [0, -1, -2, -3, -4, -5, -6, -7, -8, -9]";
        is (minus [^10], [0 xx 10]), [^10],
            "minus() with equal size alpha and omega: [^10] - [0 xx 10] ~~ [^10]";
    }

    subtest "Divide", {
        my @one-to-ten = 1...10;
        is divide([1], @one-to-ten), [1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10],
            "divide() with single element alpha subtracts from each of omega";
        is divide(@one-to-ten, [1]), @one-to-ten,
            "divide() with single element omega subtracts from each of alpha";
        is (divide @one-to-ten, @one-to-ten.reverse), (my @answer = [1/10, 2/9, 3/8, 4/7, 5/6, 6/5, 7/4, 8/3, 9/2, 10]),
            "divide() with equal size alpha and omega - Test 1";
        is (divide @one-to-ten.reverse, @one-to-ten), @answer.reverse,
            "divide() with equal size alpha and omega - Test 2";
    }

     subtest "Times", {
         my @one-to-ten = 1...10;
         is (times [-10], @one-to-ten), [-10, -20, -30, -40, -50, -60, -70, -80, -90, -100 ],
             "times() with scalar alpha";
         is (times @one-to-ten, [-10]), [-10, -20, -30, -40, -50, -60, -70, -80, -90, -100 ],
             "times() with scalar is transitive";
         is (times @one-to-ten, @one-to-ten), [1, 4, 9, 16, 25, 36, 49, 64, 81, 100],
            "times() with equal size alpha and omega";
         is (times @one-to-ten.reverse, @one-to-ten), (times @one-to-ten, @one-to-ten.reverse),
             "times() with equal size alpha and omega is transitive";
     }

    subtest "Max", {
        is max(77, 88), [88],
            "max() with bare Scalaric alpha and omega";
        is max([^1000], [1001]), [1001 xx 1000],
            "max() with single element omega and array alpha";
        is max([1000], my @s = [999, 2001, 998, 2002, 1001]), [1000, 2001, 1000, 2002, 1001],
            "max() with single element alpha and array omega";
        is max(@s, @s.reverse), [1001, 2002, 998, 2002, 1001],
            "max() with equal size array alpha and omega";
    }

    subtest "Min", {
        is min(77, 88), [77],
            "min() with bare Scalaric alpha and omega";
        is min([^1000], [1001]), [^1000],
            "min() with single element omega and array alpha";
        is min([1000], my @s = [999, 2001, 998, 2002, 1001]), [999, 1000, 998, 1000, 1000],
            "min() with single element alpha and array omega";
        is min(@s, @s.reverse), [999, 2001, 998, 2001, 999],
                "min() with equal size array alpha and omega";
    }

    subtest "Exponent", {
        is exponent(2, 4), [16],
            "exponent() with bare Scalaric alpha and omega";
        is exponent([2, 3, 4], [3]), [8, 27, 64],
            "exponent() with single element omega and array alpha";
        is exponent([2], [8, 9, 10]), [256, 512, 1024],
            "exponent() with single element alpha and array omega";
        is exponent([2,3,4], [2,3,4]), [4, 27, 256],
            "exponent() with equal size array alpha and omega";
    }
}

# TODO: Engage previous APL research on the best groupings of these, but in recognition that our grouping
#           requirements are by necessity more focused around making an APL-like syntax that feels Raku
subtest "Dyadic Others", {
    subtest "replicate/compress", {
        is replicate([True, False, False, True], [2, 2, 2, 2]), [2, 2], "Dyadic replicate with bool (aka 'compress')";
        is replicate([3, 2, 1], [1, 2, 3]), [1, 1, 1, 2, 2, 3], "Dyadic replicate with integers (aka 'replicate')";
    }
}

done-testing;
