use Test;

use SilverAPL::Operators;

is reduce(&infix:<+>, [^5]), 10, "monadic reduce + works";
is reduce(&infix:<*>, [1...5]), 120, "monadic * works";

done-testing;
