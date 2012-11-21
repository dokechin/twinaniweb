package Twinani::Web::List;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;
use DateTime::Format::ISO8601;
use utf8;


# This action will render a template
sub index {


  my $self = shift;

  my $item = $self->param('item');
  my $verb_id = $self->param('verb_id');
  my $page = $self->param('page') || 1;
  my $span = $self->param('span') || 1;
  if ($span != 1 && $span !=7 && $span != 30) {
    $span = 1;
  }

  my $dt1 = DateTime->now( time_zone => 'local' )->add( days => 0-$span );
  my $dt2 = DateTime->now( time_zone => 'local' );

  my ($entries, $pager) = $self->app->db->search_by_sql_abstract_more_with_pager(+{
    -columns => [qw/t.content t.issued_at t.author/],
    -from => [
        '-join',
        'tweet|t',
        't.verb_id = v.id',
        'verb|v'
    ],
    -where => +{ 't.issued_at' => 
      +{ 'between' => [ DateTime::Format::MySQL->format_datetime($dt1),
                        DateTime::Format::MySQL->format_datetime($dt2)  ] },
                 't.verb_id' => $verb_id,
                 't.item' => $item
                        },
    -order_by => ['t.issued_at DESC'],
    -page => $page,
    -rows => 15
});

  # Render template "root/index.html.ep" with message
  $self->render( 
    entries => $entries,
    current_page=> $pager->current_page,
    total_pages => $pager->last_page,
    span => $span,
    verb_id => $verb_id,
    item => $item,
    title => '今' . $item . 'を'. $self->app->config->{verb_of}->{$verb_id} . ' - Twinani [ツイナニ]'
    );
}


# This action will render a template
sub item {


  my $self = shift;

  my $item = $self->param('item');
  my $verb_id = $self->param('verb');
  my $page = $self->param('page') || 1;
  my $date = $self->param('date');

  my $date_from;
  my $today = DateTime->today( time_zone => 'local' );
  if ($date){
      $date_from = DateTime::Format::ISO8601->parse_datetime( $self->param('date') );
  }
  else{
      $date_from = $today->clone;
  }
  my $date_to = $date_from->clone;
  $date_to->set_hour(23);
  $date_to->set_minute(59);
  $date_to->set_second(59);

  my ($entries, $pager) = $self->app->db->search_by_sql_abstract_more_with_pager(+{
    -columns => [qw/t.content t.issued_at t.author/],
    -from => [
        '-join',
        'tweet|t',
        't.verb_id = v.id',
        'verb|v'
    ],
    -where => +{ 't.issued_at' => 
      +{ 'between' => [ DateTime::Format::MySQL->format_datetime($date_from),
                        DateTime::Format::MySQL->format_datetime($date_to)  ] },
                 't.verb_id' => $verb_id,
                 't.item' => $item
                        },
    -order_by => ['t.issued_at DESC'],
    -page => $page,
    -rows => 15
});

  my $url = Mojo::URL->new('http://twinani.dokechin.com/list/' . $date. '/' . $verb_id . '/' . $item);
  

  # Render template "list/index.html.ep" with message
  $self->render( 
    entries => $entries,
    current_page=> $pager->current_page,
    total_pages => $pager->last_page,
    date => $date,
    verb_id => $verb_id,
    item => $item,
    url => $url,
    title => $date_from->strftime( "%F" ) . 'に' . $item . 'を'. $self->app->config->{verb_of}->{$verb_id} . ' - Twinani [ツイナニ]'
    );
}

1;

