#!/usr/bin/env perl

# Natalie Willhoft
# Software Developer application

# Brief
# 1. Use the latest human data and the Perl API for latest Ensembl release
# 2. Convert coordinates on chromosome (e.g. chromosome 10 from 25000 to 
# 30000) to the same region in GRCh37
# 3. Make the script as generic as possible
# 4. Run script as a command-line program

use strict;
use warnings;

use FindBin;
use DBD::mysql;
use Data::Dumper;
use Getopt::Long;

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

# get arguments from user
my $USAGE = <<"_USAGE";
Takes a coordinates string specifying a given genome assembly version (e.g. GRCh38) and maps it 
onto a different genome assembly version (e.g. GRCh37).

Usage:
$0 [options] [required]

Required:

  --coordinates_string      Coordinates string to be converted.
                            i.e. "chromosome:chromosome_id:sequence_start:sequence_stop:strand:genome_assembly_version"

Optional:

  --port                    Database port (default: 3337)

Examples:

  $0 --coordinates_string="chromosome:20:20000:30000:1:GRCh38" \

  $0 --coordinates_string="chromosome:X:10000:20000:1:GRCh38" \

  $0 --coordinates_string="chromosome:20:20000:30000:1:GRCh38" --port="3337" \

_USAGE

sub USAGE {
        print $USAGE;
        print "Error: @_\n" if scalar @ARGV;
        exit;
}

USAGE() unless scalar @ARGV;

# set defaults
my $coordinates_string; # coordinates string
my $species = "Human";  # species
my $port = "3337";      # database port
my $group = "Core";     # core Ensembl data

# process user input
GetOptions(
    "coordinates_string=s" => \$coordinates_string,
    "species=s"            => \$species,
    "port=s"               => \$port,
) or die( "Error in command line args.\n" );

USAGE( "Coordinate string must be specified" ) unless defined $coordinates_string;

print "Processing user input...\n";

# process variables
my ( 
  $coord_system_name,
  $seq_region_name,
  $seq_start,
  $seq_stop,
  $seq_strand,
  $genome_assembly_version
) = split( /:/, $coordinates_string );

# complain heavily if a required variable has not been defined
die "No coordinate system name provided (e.g. chromosome)\n" unless $coord_system_name;
die "No sequence region name provided (e.g. 20)\n" unless $seq_region_name;
die "No sequence start position provided (e.g. 25000)\n" unless $seq_start;
die "No sequence stop position provided (e.g. 30000)\n" unless $seq_stop;
die "No genome assembly version provided (e.g. GRCh38)\n" unless $genome_assembly_version;


printf("COORDINATE SYSTEM NAME  : %s\n", $coord_system_name);
printf("SEQUENCE REGION NAME    : %s\n", $seq_region_name);
printf("SEQUENCE START          : %s\n", $seq_start);
printf("SEQUENCE STOP           : %s\n", $seq_stop);
printf("STRAND                  : %s\n", $seq_strand);
printf("GENOME ASSEMBLY VERSION : %s\n", $genome_assembly_version);
printf("DATABASE PORT           : %s\n", $port);
printf("GROUP                   : %s\n", $group);
print "\n";

# get a new registry object
my $registry = 'Bio::EnsEMBL::Registry';

# load the latest version of human genome GRCh37
# to convert coordinates onto
print "Load registry from database...\n";
$registry->load_registry_from_db(
      -host => 'ensembldb.ensembl.org',
      -user => 'anonymous',
      -port => $port,
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

# good test example going opposite way to Ensembl REST example 
# which shows this program works
# (http://rest.ensembl.org/documentation/info/assembly_map)
# chromosome:X:1039265:1039365:1:GRCh38:human
# example provided on technical assessment notes
# chromosome:20:25000:30000:1:GRCh38:human
# chromosome:20:1e6:2e6:1:GRCh38:human



# get a slice adaptor for the human core database
my $slice_adaptor = $registry->get_adaptor( $species, $group, 'Slice' );

# print Dumper( $slice_adaptor);
# get slice from a whole chromosome
# my $chr_slice = $slice_adaptor->fetch_by_region( 'chromosome', 'X' );


my $cs_adaptor = $registry->get_adaptor( $species, $group, 'CoordSystem' );
my $cs = $cs_adaptor->fetch_by_name($coord_system_name);

print "Performing the conversion...\n\n";

printf("MAPPING FROM ASSEMBLY : %s\n", $genome_assembly_version); 
printf("MAPPING TO ASSEMBLY   : %s\n\n", $cs->version());

# get a slice covered by a given region on a given chromosome
my $slice = $slice_adaptor->fetch_by_region( $coord_system_name, $seq_region_name, $seq_start, $seq_stop, $seq_strand, $genome_assembly_version );

# printf( "# %s\n", $slice->name() );

# assign slice object attributes to variables
# gives more clarity when printing out
my $cs_name ||= $slice->coord_system_name();
my $sr_name ||= $slice->seq_region_name();
my $start   ||= $slice->start();
my $end     ||= $slice->end();
my $strand  ||= $slice->strand();
my $version ||= $slice->coord_system()->version();

# go through each segment in
my $segment_counter = 1;
foreach my $segment ( @{ $slice->project($coord_system_name) } ) {

  print "Converted segment #${segment_counter}:\n";

  # print Dumper( $segment->to_Slice() );

  printf( "%s:%s:%s:%d:%d:%d => %s\n",
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