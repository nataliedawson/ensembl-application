# Ensembl application

(Natalie Willhoft application)

### The exercise

* Use the latest human data and the Perl API for Ensembl release 98

* Convert coordinates on chromosome (e.g. chromosome 10 from 25000 to 30000) to the same region in GRCh37

* Make the script as generic as possible

* Run script as a command-line program

## General steps in setting up environment to run my perl script

1. Ensure perl is up-to-date (brew update perl). Using version 5.26, which is documented as being compatible (https://www.ensembl.org/info/docs/api/api_installation.html).

1. Install Perl API (https://www.ensembl.org/info/docs/api/api_installation.html)

1. Export PERL5LIB environment variable as in video tutorial and incorporate lib path into perl script using the FindBin module.

    * contents of my .profile file, which is stored in my home directory

    ```
    # provide access to Ensembl perl modules
    BASEDIR=/Users/nataliewillhoft/github/ensembl-application
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/ensembl/modules
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/ensembl-variation/modules
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/ensembl-compara/modules
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/ensembl-funcgen/modules
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/ensembl-tools/modules
    PERL5LIB=${PERL5LIB}:$BASEDIR/src/bioperl-1.6.924/
    export PERL5LIB

    # include path to modules installed with cpanm etc.
    PERL5LIB={$PERL5LIB}:/usr/local/lib/perl5/5.26.2/
    export PERL5LIB
    ```

1. Use cpanm to install the required perl modules: `cat requirements.txt | cpanm`

* Please note that the Ensembl modules are in the `src/` subdirectory of this GitHub project. My script using the `FindBin` perl module to locate this modules. I haven't committed this directory to version control as it is large in size (~ 674 Mb).

### Answering the 'Alternatives' section

* Describe at least one other way of retrieving the same information, along with its advantages and disadvantages.

* See REST notes for GRCh37 here: `https://www.ensembl.org/info/docs/index.html`

* and accessing Ensembl data here: `https://www.ensembl.org/info/docs/tools/index.html`

* Could query the databases directly?

* https://m.ensembl.org/info/website/tutorials/grch37.html :
* export Ensembl annotation on GRCh37 with BioMart
* http://rest.ensembl.org/documentation/info/assembly_map - allows converting from 1. GRCh38 to 2. GRCh37, 3. a query region string, and 4. species string 

* Advantages of using REST API: don't need to know perl.

1. Using the Ensembl tool called Assembly Converter. A user can perform the same mapping between from the human assembly GRCh38 to GRCh37 (http://www.ensembl.org/Homo_sapiens/Tools/AssemblyConverter). The tool uses the CrossMapper program to convert genome coordinates. This method appears advantageous because the user can simply perform the conversion in a web-based session and the tool accepts a number of file formats (e.g. BAM, BED, GFF3). Disadvantages to this method are that it is reliant on an internet connection and the user needs to be familiar with at least one of the input file formats.








## Some methods

```
# https://www.ensembl.org/info/docs/api/registry.html
# use this to get the name 
shell> mysql -u anonymous -h ensembldb.ensembl.org -P 3306
mysql> SHOW DATABASES LIKE "homo_sapiens_core_%";
```

This gives a long list of databases to use, like the latest versions `homo_sapiens_core_75_37` and `homo_sapiens_core_99_38`.

