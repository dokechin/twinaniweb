package Twinani::Web::Eat;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;
use DateTime::Format::ISO8601;

# This action will render a template
sub index {


  my $self = shift;

  my $page = $self->param('page') || 1;

  my $iso8601 = DateTime::Format::ISO8601->new;

  my $date_from;
  my $today = DateTime->today( time_zone => 'local' );
  if ($self->param('date')){
      $date_from = DateTime::Format::ISO8601->parse_datetime( $self->param('date') );
  }
  else{
      $date_from = $today->clone;
  }
  my $date_to = $date_from->clone;
  $date_to->set_hour(23);
  $date_to->set_minute(59);
  $date_to->set_second(59);

  my @dates;
  my $date_index = 7;
  for my $i(0 .. 6){
      my $d = $today->clone();
      $d->add( days => -$i );
      push( @dates, $d->strftime("%Y%m%d"));
      if ( $date_from == $d ) {
          $date_index = $i;
      }
  }
  if ( $date_index == 7){
      push ( @dates, $date_from);
  }
  else{
      push (@dates, "");
  }

  my ($entries, $pager) = $self->app->db->search_by_sql_abstract_more_with_pager(+{
    -columns => [qw/t.item v.name count(*)|count t.verb_id sec_to_time(avg(time_to_sec(t.issued_at)))|avg_time/],
    -from => [
        '-join',
        'tweet|t',
        't.verb_id = v.id',
        'verb|v'
    ],
    -where => +{ 't.issued_at' => 
      +{ 'between' => [ DateTime::Format::MySQL->format_datetime($date_from),
                        DateTime::Format::MySQL->format_datetime($date_to)  ] },
        't.author' =>  {'not like' => 'FFBATTLE%'},
        'v.id' => 2,
               },
    -group_by => ['t.item','v.name'],
    -order_by => ['count(*) DESC'],
    -page => $page,
    -rows => 15
});

  # Render template "root/index.html.ep" with message
  $self->render( entries => $entries,
    current_page=> $pager->current_page,
    total_pages => $pager->last_page,
    date_index => $date_index,
    dates => \@dates,
    url => 'http://twinani.dokechin.com/eat/' . $self->param('date'),
    );
}

1;

