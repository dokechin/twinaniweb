package Twinani::DB::Schema;
use Teng::Schema::Declare;
use DateTime::Format::MySQL;

table {
    name 'tweet';
    columns qw( author item verb_id issued_at );

    inflate 'issued_at' => sub {
        DateTime::Format::MySQL->parse_datetime(shift);
    };
    deflate 'issued_at' => sub {
        DateTime::Format::MySQL->format_datetime(shift);
    };
};

table {
    name 'verb';
    pk 'id';
    columns qw( id name regexp);
};

1;
