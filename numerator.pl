#!/usr/bin/env perl
#
# See perldoc for information
#
use warnings;
use strict;
use Roman;
use Getopt::Long;
use Pod::Usage;
use IO::File;

# START POD docs

=head1 SYNOPSIS

numerator.pl [options]

=head1 OPTIONS

=over 8

=item B<--help | -h>

Print brief help message and exit

=item B<--filename | -f>

Filename to pass to numerator

=back

=head1 AUTHOR

Richard Clark - <richard@fohnet.co.uk>

=head1 DESCRIPTION

Write a converter to and from Roman numerals.

The script should read from files specified on the command-line and writing to
STDOUT.  Each line of input will contain one integer (between 1 and 3999)
expressed as an Arabic or Roman numeral.  There should be one line of output
for each line of input, containing the original number in the opposite format.

Create the test data for the script and include both this and the script output
along with the script.

You can chose to write this in any language you choose, please specify the
reasons for your choice.

=head2 LANGUAGE CHOICE

I chose to write this in Perl, both because it's my favourite 'go-to' language
for most tasks, and because of the vast set of modules available for it,
thus avoiding wheel reinvention.

If I were to implement this task without the use of a module I would have
likely used a hash to match up roman numerals with their arabic values, and
then performed arithmetic/division in arabic whilst iterating through the hash
of values.

=head2 KNOWN ISSUES AND TODO

ASCII charset does not expand beyond 3999; greater than this requires use of
unicode

Given more time I would have audited the code of the Roman module to check what
data validation is performed, and based on this we could potentially do away
with the regexes in the validate_file subroutine.

=cut

# END POD DOCS

my $version = '0.01';

my ($opt_help,
    $opt_filename
);

GetOptions(
    'help|h'       => \$opt_help,
    'filename|f=s' => \$opt_filename,
)
    or pod2usage(verbose    => 0,
                 exitstatus => 1,
);

# evaluate options given and fail out to help if missing
pod2usage( verbose => 1 ) if $opt_help;
pod2usage(1) if ! $opt_filename;

# copy opt_ vars > vars to denote separation and more readable code
my $filename = $opt_filename;

# sub calls
my $numbers = validate_file();
numericalise($numbers);

# SUBS START

# validate that the input file contains only roman/arabic chars
sub validate_file
{
    my @numbers;
    # create filehandle object in ro mode
    my $fh = IO::File->new($filename,'r') or err_sub(2);

    # read file line by line and validate data is within legal ranges
    while ( my $line = $fh->getline() )
    {
        if ( $line =~ /^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/ or
             $line =~ /^([1-9][0-9]{0,2}|[1-3][0-9]{3})$/ )
        {
            # strip linebreak and push to array
            $line =~ s/\n//;
            push (@numbers, $line);
        } else {
            err_sub(1);
        }
    }

    # destroy filehandle and return arref
    undef $fh;
    return \@numbers;
}

# takes an arre containing validated data and runs conversion between
# arabic/roman numerical systems and dump to STDOUT
sub numericalise
{
    my $numbers = shift;
    # iterate array
    for my $number (@$numbers)
    {
        if (isroman($number)) { print arabic($number)."\n"; }
        else                  { print Roman($number)."\n"; }
    }
}

# handle errors
sub err_sub
{
    my $err_code = shift;
    if ($err_code)
    {
        if ($err_code == 1) {
            print "ERROR: $filename does not contain valid characters\n";
        } elsif ( $err_code == 2) {
            print "ERROR: could not open $filename\n";
        }
    } else {
        print "ERROR: unknown\n;";
        exit 99;
    }
    exit $err_code;
}

# SUBS END

