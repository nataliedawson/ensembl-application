# Ensembl application

(Natalie Willhoft application)

## General steps in setting up environment to run my perl script

1. Ensure perl is up-to-date (brew update perl). Using version 5.26, which is documented as being compatible (https://www.ensembl.org/info/docs/api/api_installation.html).

1. Install Perl API (https://www.ensembl.org/info/docs/api/api_installation.html)

1. Use git clone to retrieve the repository (please note that my github account is under my maiden name of Dawson)
    `git clone git@github.com:nataliedawson/ensembl-application.git`

1. Export PERL5LIB environment variable as in video tutorial. 

    * For example, here are the contents of my .profile file, which is stored in my home directory

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

1. Allow the perl script to find the Ensembl-specific perl modules. Please note that I have done this by incorporating the lib path into my script using the `FindBin` module.

    * The Ensembl modules are expected to be found in the `src/` subdirectory of this GitHub project. My script uses the `FindBin` perl module to locate these modules. I have not committed the contents of this directory to version control as it is large in size (~ 674 Mb).

1. Use cpanm to install the required perl modules: `cat requirements.txt | cpanm`

1. The script is run by changing directory to within my repository directory `ensembl-application` and then running `perl ensembl-convert-coordinates.pl` on the command line. Running my script without any arguments loads the usage text.

### Answering the 'Alternatives' section

* Describe at least one other way of retrieving the same information, along with its advantages and disadvantages.

1. The Ensembl REST API.

   (Information sourced from: 
      https://github.com/Ensembl/ensembl-rest/wiki/Getting-Started
      http://rest.ensembl.org/documentation/info/assembly_map
      https://www.ensembl.org/info/docs/index.html
      https://www.ensembl.org/info/docs/tools/index.html)
   
   The Ensembl REST API provides an alternative to the Ensembl Perl API to convert the coordinates of one assembly to another. Advantages include being able to use a range of programming languages (e.g. Java, Perl, Python, Ruby) and operating systems. Disadvantages include reliance on an internet connection (and its speed) and not having access to the entire Ensembl database.


1. The Ensembl web-based tool, Assembly Converter.

   (Information sourced from:
      http://www.ensembl.org/Homo_sapiens/Tools/AssemblyConverter). 
      
   A user can perform the same mapping between from the human assembly GRCh38 to GRCh37 . The tool uses the CrossMapper program to convert genome coordinates. This method appears advantageous because the user can simply perform the conversion in a web-based session and the tool accepts a number of file formats (e.g. BAM, BED, GFF3). Disadvantages to this method are that it is reliant on an internet connection (and its speed) and the user needs to be familiar with at least one of the input file formats.

1. The Ensembl web pages

    It is possible to convert coordinates through the main Ensembl web pages. The user can do this by loading the web page for the human genome (http://www.ensembl.org/Homo_sapiens/Info/Index) and then loading a location-based display page, for example using the example region link provided (http://www.ensembl.org/Homo_sapiens/Location/View?r=17:63992802-64038237). A link is provided at the bottom of the left-hand menu to view the coordinates in the Ensembl GRCh37 assembly (http://www.ensembl.org/Homo_sapiens/Help/ListMappings?alt_assembly=GRCh37;db=core;r=17:63992802-64038237). This method is advantageous because it is very simple to use. Disadvantages include reliance on an internet connection (and its speed) and not having access to the entire Ensembl database.
