package Twinani::Web::List;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;

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
    item => $item
    );
}

1;
