#! perl -w
use Test::Most;

use Data::Fake::PhoneNumber;

subtest 'non_fake_fake_phone' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = Data::Fake::PhoneNumber::non_fake_fake_phone()->();
        like(
            $got,
            qr/^\+[0-9]{2} [0-9]{3}-[0-9]{3}-[0-9]{4}/,
            "looks like an local uk London number ($got)"
        );
    }
};

subtest 'fake_phone_number_generator' => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_phone_number( 'uk', 'london' )->();
        like(
            $got,
            qr/^020 7946 0\d{3}/,
            "looks like an local uk London number ($got)"
        );
    }
};

subtest 'fake_phone_number_generator_sheffield_region' => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_phone_number('uk')->('sheffield');
        like(
            $got,
            qr/^0114 496 0\d{3}/,
            "looks like an local uk sheffield number ($got)"
        );
    }
};

subtest 'fake_london_phone_number_generator_with_nottingham_override' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = Data::Fake::PhoneNumber::fake_phone_number( 'uk', 'london' )
          ->('nottingham');
        like(
            $got,
            qr/^0115 496 0\d{3}/,
            "looks like an local uk nottingham number ($got)"
        );
    }
};

subtest 'fake_international_phone_number_generator' => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_phone_number( 'uk', 'london', 1 )->();
        like(
            $got,
            qr/^\+4420 7946 0\d{3}/,
            "looks like an non-local uk London number ($got)"
        );
    }
};

subtest 'fake_international_phone_number_generator_sheffield_region' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = Data::Fake::PhoneNumber::fake_phone_number( 'uk', undef, 1 )
          ->('sheffield');
        like(
            $got,
            qr/^\+44114 496 0\d{3}/,
            "looks like an non-local uk sheffield number ($got)"
        );
    }
};

subtest
  'fake_international_london_phone_number_generator_with_nottingham_override'
  => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_phone_number( 'uk', 'london', 1 )
          ->('nottingham');
        like(
            $got,
            qr/^\+44115 496 0\d{3}/,
            "looks like an non-local uk nottingham number ($got)"
        );
    }
  };

done_testing();