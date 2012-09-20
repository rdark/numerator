numerator
=========

# SYNOPSIS

    numerator.pl [options]

# OPTIONS

  --help | -h
      Print brief help message and exit
  --filename | -f
      Filename to pass to numerator
 
# AUTHOR

Richard Clark - <richard@fohnet.co.uk>

# DESCRIPTION

Write a converter to and from Roman numerals.

The script should read from files specified on the command-line and writing to STDOUT. Each line of input will contain one integer (between 1 and 3999) expressed as an Arabic or Roman numeral. There should be one line of output for each line of input, containing the original number in the opposite format.

Create the test data for the script and include both this and the script output along with the script.

You can chose to write this in any language you choose, please specify the reasons for your choice.

## LANGUAGE CHOICE

I chose to write this in Perl, both because it's my favourite 'go-to' language for most tasks, and because of the vast set of modules available for it, thus avoiding wheel reinvention.

If I were to implement this task without the use of a module I would have likely used a hash to match up roman numerals with their arabic values, and then performed arithmetic/division in arabic whilst iterating through the hash of values.

## KNOWN ISSUES AND TODO

ASCII charset does not expand beyond 3999; greater than this requires use of unicode

Given more time I would have audited the code of the Roman module to check what data validation is performed, and based on this we could potentially do away with the regexes in the validate\_file subroutine.
