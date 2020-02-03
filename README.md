# Ensembl application

### The exercise

* Use the latest human data and the Perl API for Ensembl release 98

* Convert coordinates on chromosome (e.g. chromosome 10 from 25000 to 30000) to the same region in GRCh37

* Make the script as generic as possible

* Run script as a command-line program

### Answering the 'Alternatives' section

* Exercise: Describe at least one other way of retrieving the same information, along with its advantages and disadvantages.

* See REST notes for GRCh37 here: `https://www.ensembl.org/info/docs/index.html`

* and accessing Ensembl data here: `https://www.ensembl.org/info/docs/tools/index.html`

* Could query the databases directly?

* https://m.ensembl.org/info/website/tutorials/grch37.html :
* export Ensembl annotation on GRCh37 with BioMart
* http://rest.ensembl.org/documentation/info/assembly_map - allows converting from 1. GRCh38 to 2. GRCh37, 3. a query region string, and 4. species string 

* Advantages of using REST API: don't need to know perl.

* I've found a web tool by Ensembl called Assembly Converter, where a user can map between from the human assembly GRCh38 to GRCh37 (http://www.ensembl.org/Homo_sapiens/Tools/AssemblyConverter). The tool uses the CrossMapper program to convert genome coordinates. This method appears advantageous because the user can simply perform the conversion in a web-based session without writing any code. The tool accepts a number of file formats. Disadvantages: reliant on internet connection, need to create an input file in a certain format.



## General steps in setting up environment to run my perl script

* Ensure perl is up-to-date (brew update perl). Using version 5.26, which is documented as being compatible (https://www.ensembl.org/info/docs/api/api_installation.html).

* Install Perl API (https://www.ensembl.org/info/docs/api/api_installation.html)

* Export PERL5LIB environment variable as in video tutorial and incorporate lib path into perl script.


## Some methods

```
# https://www.ensembl.org/info/docs/api/registry.html
# use this to get the name 
shell> mysql -u anonymous -h ensembldb.ensembl.org -P 3306
mysql> SHOW DATABASES LIKE "homo_sapiens_core_%";
```

This gives a long list of databases to use, like the latest versions `homo_sapiens_core_75_37` and `homo_sapiens_core_99_38`.

