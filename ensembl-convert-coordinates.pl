#!/usr/bin/env perl

# Brief
# 1. Use the latest human data and the Perl API for Ensembl release 98
# 2. Convert coordinates on chromosome (e.g. chromosome 10 from 25000 to 
# 30000) to the same region in GRCh37
# 3. Make the script as generic as possible
# 4. Run script as a command-line program

use strict;
use warnings;

use FindBin;
use DBD::mysql;
use Data::Dumper;

# tell perl how to find ensembl-related modules
use lib "$FindBin::Bin/src/bioperl-1.6.924";
use lib "$FindBin::Bin/src/ensembl/modules";
use lib "$FindBin::Bin/src/ensembl-compara/modules";
use lib "$FindBin::Bin/src/ensembl-variation/modules";
use lib "$FindBin::Bin/src/ensembl-funcgen/modules";

# load ensembl-related modules
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Utils::ConfigRegistry;
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;


# get a new registry object
my $registry = 'Bio::EnsEMBL::Registry';

# load the latest version of human genome GRCh37
# to convert coordinates onto
$registry->load_registry_from_db(
      -host => 'ensembldb.ensembl.org',
      -user => 'anonymous',
      -port => '3337',
      -species => 'homo_sapiens',
);

# load registry from multiple databases
# first connection gets access to specified version 98
# second connection gets access to genome assembly GRCh37
# $registry->load_registry_from_multiple_dbs(
#     {
#       -host    => 'ensembldb.ensembl.org',
#       -user    => 'anonymous',
#       -port    => '3306',
#       -species => 'homo_sapiens',
#       -group   => 'core',
#       -dbname  => 'homo_sapiens_core_98_38'
#     },
#     {
#       -host => 'ensembldb.ensembl.org',
#       -user => 'anonymous',
#       -port => '3337',
#       -dbname => 'homo_sapiens_core_75_37'
#     }
# );

# use to see which database adaptors are available
# my @db_adaptors = @{ $registry->get_all_DBAdaptors() };

# foreach my $db_adaptor (@db_adaptors) {
#     my $db_connection = $db_adaptor->dbc();

#     printf(
#         "species/group\t%s/%s\ndatabase\t%s\nhost:port\t%s:%s\n\n",
#         $db_adaptor->species(),   $db_adaptor->group(),
#         $db_connection->dbname(), $db_connection->host(),
#         $db_connection->port()
#     );
# }

# print "registry: $registry\n";

# process variables
my $seq_object = "chromosome";
my $seq_object_id = "20";
my $seq_start   = 1e6;
my $seq_stop    = 2e6;
my $seq_strand  = "1";
my $genome_assembly_version = "GRCh38";
my $species = "human";
my $group = "core";

# get a slice adaptor for the human core database
my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );

# print Dumper( $slice_adaptor);
# get slice from a whole chromosome
# my $chr_slice = $slice_adaptor->fetch_by_region( 'chromosome', 'X' );


my $cs_adaptor = $registry->get_adaptor( 'Human', 'Core', 'CoordSystem' );
my $cs = $cs_adaptor->fetch_by_name($seq_object);
# my $cs = $cs_adaptor->fetch_by_dbID('homo_sapiens_core_98_38');

# get a list of all the coordinate systems with the name
# matching $seq_object
# foreach my $cs_entry ( @{ $cs_adaptor->fetch_all_by_name($seq_object) } ) {
#   print $cs_entry->name, " ", $cs->version, "\n";
# }

printf "Coordinate system: %s %s\n", $cs->name(), $cs->version();

# get a slice covered by a given region on a given chromosome
my $slice = $slice_adaptor->fetch_by_region( $seq_object, $seq_object_id, $seq_start, $seq_stop, $seq_strand, $genome_assembly_version );

printf( "# %s\n", $slice->name() );

# assign slice object attributes to variables
# gives more clarity when printing out
my $cs_name ||= $slice->coord_system_name();
my $sr_name ||= $slice->seq_region_name();
my $start   ||= $slice->start();
my $end     ||= $slice->end();
my $strand  ||= $slice->strand();
my $version ||= $slice->coord_system()->version();

# go through each segment in
my $segment_counter = 0;
foreach my $segment ( @{ $slice->project($seq_object) } ) {

  print "Segment #${segment_counter}:\n";

  # print Dumper( $segment->to_Slice() );

  printf( "%s:%s:%s:%d:%d:%d,%s\n",
    $cs_name,
    $version,
    $sr_name,
    $start + $segment->from_start() - 1,
    $start + $segment->from_end() - 1,
    $strand,
    $segment->to_Slice()->name() 
  );

  $segment_counter++;
}