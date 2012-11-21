package Twinani::Web::Root;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;
use DateTime::Format::ISO8601;
use utf8;

# This action will render a template
sub index {


  my $self = shift;

  my $page = $self->param('page') || 1;

  my $what = $self->param('what') || "all";

  my $verb_id1;
  my $verb_id2;

  if ($what eq 'all') {
    $verb_id1 = $self->app->config->{verb_id_min};
    $verb_id2 = $self->app->config->{verb_id_max};
  }
  else{
    $verb_id1 = $self->app->config->{verb_id_of}->{$what};
    $verb_id2 = $verb_id1;
  }

  my $today = DateTime->today( time_zone => 'local' );

  my $dt1 = DateTime->now( time_zone => 'local' )->add( days => -1);
  my $dt2 = DateTime->now( time_zone => 'local' );

  my @dates;
  for my $i(0 .. 7){
      my $d = $today->clone();
      $d->add( days => -$i );
      push( @dates, $d->strftime("%Y%m%d"));
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
      +{ 'between' => [ DateTime::Format::MySQL->format_datetime($dt1),
                        DateTime::Format::MySQL->format_datetime($dt2)  ] },
        't.author' =>  {'not like' => 'FFBATTLE%'},
        'v.id' =>  { 'between' => [$verb_id1, $verb_id2]},
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
    dates => \@dates,
    what => $what,
    title => '今何をつぶやいてる - Twinani [ツイナニ]'
    );
}

1;

