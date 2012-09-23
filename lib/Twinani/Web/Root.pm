package Twinani::Web::Root;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub index {
  my $self = shift;


   my @entries = $self->app->db->search('tweet', {});
   
  # Render template "root/index.html.ep" with message
  $self->render( entries => \@entries);
}

1;
