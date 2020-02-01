#!/usr/bin/perl

use strict;
use warnings;

# ensembl-related modules
use Bio::EnsEMBL::Registry;
use Bio::EnsEMBL::Utils::ConfigRegistry;
use Bio::EnsEMBL::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Compara::DBSQL::DBAdaptor;

# connect to human core db v98
new Bio::EnsEMBL::DBSQL::DBAdaptor(
  -host    => 'ensembldb.ensembl.org',
  -user    => 'anonymous',
  -port    => '3306',
  -species => 'homo_sapiens',
  -group   => 'core',
  -dbname  => 'homo_sapiens_core_98_38'
);

# create another connection for v37
