unit module SilverAPL::Operators;

use SilverAPL::Helpers;

# REDUCE
multi sub reduce(Callable &function, *@omega) is export  {
    # Dynamically install the compound sub name into the dispatch table?
    [&function] |@omega
}