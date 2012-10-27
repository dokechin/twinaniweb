package Twinani::Web::Go;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;

# This action will render a template
sub index {


  my $self = shift;

  my $page = $self->param('page') || 1;
  my $span = $self->param('span') || 1;
  if ($span != 1 && $span !=7 && $span != 30) {
    $span = 1;
  }

  my $dt1 = DateTime->now( time_zone => 'local' )->add( days => 0-$span );
  my $dt2 = DateTime->now( time_zone => 'local' );

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
                 't.verb_id' => '5'
                        },
    -group_by => ['t.item','v.name'],
    -order_by => ['count(*) DESC'],
    -page => $page,
    -rows => 15
});


  # Render template "root/index.html.ep" with message
  $self->render( 
    entries => $entries,
    current_page=> $pager->current_page,
    total_pages => $pager->last_page,
    span => $span
    );
}

1;

