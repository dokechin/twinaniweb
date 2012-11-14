package Twinani::Web;
use Mojo::Base 'Mojolicious';
use Twinani::DB;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->plugin( 'Twinani::Plugin::PageNavigator' );
  $self->plugin('share_helpers');


  my $config = $self->plugin('Config', { file => 'twinani.conf' }); # ’Ç‰Á
  $self->attr( db => sub { Twinani::DB->new( $config->{db} ) } ); # ’Ç‰Á

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->route('/')->to('root#index');
  $r->route('/list/:date/:verb/:item')->to('list#item', date => qr/{\d}8/);
#  $r->route('/all')->to('all#index');
#  $r->route('/all/:date')->to('all#index',date => qr/{\d}8/);
#  $r->route('/all')->to('all#index');
  $r->route('/:controller')->to(action => 'index');
  $r->route('/:controller/:date')->to(action =>'index', date => qr/{\d}8/);


}

1;
