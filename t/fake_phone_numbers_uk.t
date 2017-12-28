#! perl -w
use Test::Most;

use Data::Fake::PhoneNumber;

subtest 'fake_uk_local_phone_number' => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_uk_local_phone_number()->('london');
        like(
            $got,
            qr/^020 7946 0\d{3}/,
            "looks like an local uk London number ($got)"
        );
    }
};

subtest 'fake_uk_local_phone_number_london_generator' => sub {
    for my $i ( 0 .. 5 ) {
        my $got =
          Data::Fake::PhoneNumber::fake_uk_local_phone_number('london')->();
        like(
            $got,
            qr/^020 7946 0\d{3}/,
            "looks like an local uk London number ($got)"
        );
    }
};

subtest 'fake_uk_local_phone_number_overridden_london_generator' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = Data::Fake::PhoneNumber::fake_uk_local_phone_number('london')
          ->('nottingham');
        like(
            $got,
            qr/^0115 496 0\d{3}/,
            "looks like an local uk nottingham number ($got)"
        );
    }
};

subtest 'fake_uk_international_phone_number' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = Data::Fake::PhoneNumber::fake_uk_international_phone_number()
          ->('london');
        like(
            $got,
            qr/^\+4420 7946 0\d{3}/,
            "looks like an international uk London number ($got)"
        );
    }
};

done_testing();