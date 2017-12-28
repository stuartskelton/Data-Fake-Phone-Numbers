package Data::Fake::PhoneNumber;

# ABSTRACT: Fake Phone number data generators
#

use strict;
use warnings;

use Data::Fake::Core ();

my ( $supported_country_list, $international_codes, $fake_phone_templates );

=func non_fake_fake_phone

    $generator = non_fake_fake_phone();
    $generator->() # +14 514-150-3742

    # a mixer of real fake (90%)  and non 'fake' phone (10%) numbers
    $weighted_generator = fake_weighted(
        [ fake_uk_local_phone_number(),    9 ],
        [ non_fake_fake_phone(),           1 ],
    );

Returns a generator that creates a random looking phone number that may or may not
be a real number.

=cut


sub non_fake_fake_phone {
    return Data::Fake::Core::fake_digits("+## ###-###-####");
}


=func fake_phone_number



    $generator = fake_phone_number(
        'uk',     # Country
        'london', # Region
        0         # Make_international 0 = local number prefix (0)
                  #                    1 = international number prefix(+44)
    );

    $generator->() #020 7946 0470

The region can be overridden at invocation

    $generator->('nottingham') #0115 496 0882




=cut

sub fake_phone_number {
    my ( $country, $o_region, $make_international ) = @_;
    return sub {
        my ($i_region) = @_;
        $i_region =$o_region
          || Data::Fake::Core::fake_pick(keys %{ $fake_phone_templates->{$country} } )->()
          unless $i_region;
        $i_region = lc $i_region;
        return _general_phone( $country, $i_region, $make_international )->();
    };
}

=func fake_uk_local_phone_number

    $generator = fake_uk_phone_number();
    $generator->($region)

Returns a generator that randomly creates a UK local (starts with a 0) based phone number, these numbers
are based on the UK telephone numbers from the UK regulator:
https://www.ofcom.org.uk/phones-telecoms-and-internet/information-for-industry/numbering/numbers-for-drama

For an internationalised uk number use C<fake_uk_international_phone_number>

Current regions supported are:

=over 4

    * birmingham
    * bristol
    * cardiff
    * edinburgh
    * glasgow
    * manchester
    * leeds
    * leicester
    * liverpool
    * london
    * northern_ireland
    * nottingham
    * reading
    * sheffield
    * tyneside

    * no_area
    * mobile
    * freephone
    * premium
    * uk_wide

=back

=cut


sub fake_uk_local_phone_number {
    my ($o_region) = @_;
    return fake_phone_number( 'uk', $o_region )
}

=func fake_uk_international_phone_number

    $generator = fake_uk_international_phone_number();
    $generator->($region)

Returns a generator that randomly creates a UK international (starts with a +44) based phone number.

For an local uk number use C<fake_uk_local_phone_number>

=cut


sub fake_uk_international_phone_number {
    my ($o_region) = @_;
    return fake_phone_number( 'uk', $o_region, 1 );
}

# this is the one routine to rule them all
sub _general_phone {

    my ( $country, $region, $make_international ) = @_;

    $country = Data::Fake::Core::fake_pick(@$supported_country_list)->()
      unless $country;
    $country = lc $country;

    $region =Data::Fake::Core::fake_pick( keys %{ $fake_phone_templates->{$country} } )->()
      unless $region;
    $region = lc $region;

    my $prefix = 0;
    $prefix = '+' . $international_codes->{$country} if $make_international;

    return sub {
        Data::Fake::Core::fake_digits($prefix . $fake_phone_templates->{$country}->{$region} )->();
    };

}

# this allows for overriding nature of having a set region on creation and over ridding on invocation
sub _fake_over_ridable_phone_number {
    my ( $country, $o_region, $make_international ) = @_;
    return sub {
        my ($i_region) = @_;
        $i_region =$o_region
          || Data::Fake::Core::fake_pick(keys %{ $fake_phone_templates->{$country} } )->()
          unless $i_region;
        $i_region = lc $i_region;
        return _general_phone( $country, $i_region, $make_international )->();
    };
}

$supported_country_list = ['uk'];

$international_codes = { uk => '44' };

$fake_phone_templates = {
    uk => {
        birmingham       => '121 496 0###',
        bristol          => '117 496 0###',
        cardiff          => '29 2018 0###',
        edinburgh        => '131 496 0###',
        glasgow          => '141 496 0###',
        manchester       => '161 496 0###',
        leeds            => '113 496 0###',
        leicester        => '116 496 0###',
        liverpool        => '151 496 0###',
        london           => '20 7946 0###',
        northern_ireland => '28 9649 6###',
        nottingham       => '115 496 0###',
        reading          => '118 496 0###',
        sheffield        => '114 496 0###',
        tyneside         => '191 498 0###',

        no_area   => '1632 960###',
        mobile    => '7700 900###',
        freephone => '8081 570###',
        premium   => '909 8790###',
        uk_wide   => '3069 990###'
    }
};

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Bean::Data::Fake::Phone;

    fake_uk_local_phone_number()->();     # 0141 496 0643
    fake_uk_local_phone_number()->('london');  # 020 7946 0342
    fake_uk_international_phone_number()->(london);   # +4420 7946 0342

=head1 DESCRIPTION

This module provides fake data generators for phone numbers.

No functions are exported by default.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
