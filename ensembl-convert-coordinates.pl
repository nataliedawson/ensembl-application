#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use DBD::mysql;
use Data::Dumper;

# load ensembl-related modules
use lib "$FindBin::Bin/src/bioperl-1.6.924";
use lib "$FindBin::Bin/src/ensembl/modules";
use lib "$FindBin::Bin/src/ensembl-compara/modules";
use lib "$FindBin::Bin/src/ensembl-variation/modules";
use lib "$FindBin::Bin/src/ensembl-funcgen/modules";

use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Utils::ConfigRegistry;
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;


# get a new registry object
my $registry = 'Bio::EnsEMBL::Registry';

# load registry from multiple databases
$registry->load_registry_from_multiple_dbs(
    {
      -host    => 'ensembldb.ensembl.org',
      -user    => 'anonymous',
      -port    => '3306',
      -species => 'homo_sapiens',
      -group   => 'core',
      -dbname  => 'homo_sapiens_core_98_38'
    },
    {
      -host => 'ensembldb.ensembl.org',
      -user => 'anonymous',
      -port => 3337
    }
);

my @db_adaptors = @{ $registry->get_all_DBAdaptors() };

foreach my $db_adaptor (@db_adaptors) {
    my $db_connection = $db_adaptor->dbc();

    printf(
        "species/group\t%s/%s\ndatabase\t%s\nhost:port\t%s:%s\n\n",
        $db_adaptor->species(),   $db_adaptor->group(),
        $db_connection->dbname(), $db_connection->host(),
        $db_connection->port()
    );
}

# print "registry: $registry\n";


# get a slice adaptor for the human core database
my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );

# print Dumper( $slice_adaptor);